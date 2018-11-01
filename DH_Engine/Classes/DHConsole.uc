//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConsole extends ROConsole;

const RECONNECT_DELAY = 1.0;

var bool        bLockConsoleOpen;
var bool        bDelayForReconnect;
var float       DelayWaitTime;
var string      StoredServerAddress;

var array<string>           SayTypes;
var string                  SayType;

// Modified to fix the reconnect console command, a delay is need, but so is a bit in ConnectFailure, as it does techically fail still
simulated event Tick(float Delta)
{
    super.Tick(Delta);

    // We have been queued with reconnect command
    if (bDelayForReconnect)
    {
        // Handle delay count up
        DelayWaitTime += Delta;

        // Once we have been delayed long enough
        if (DelayWaitTime > RECONNECT_DELAY)
        {
            // Make sure we properly stored the server address
            if (StoredServerAddress != "")
            {
                // Even if you strip the extra bit off of the address string here, it is somehow added later, and must be stripped/handled in ConnectFailure
                DelayedConsoleCommand("Open" @ StoredServerAddress);
            }

            // Lets not hang forever here or otherwise somehow get stuck/repeat commands
            DelayWaitTime = 0.0;
            bDelayForReconnect = false;
        }
    }
}

exec function Reconnect()
{
    if (ViewportOwner == none || ViewportOwner.Actor == none)
    {
        return;
    }

    // Initiate a locked console which is queued for reconnect in RECONNECT_DELAY seconds
    bDelayForReconnect = true;
    bLockConsoleOpen = true;

    // Store current network address
    StoredServerAddress = ViewportOwner.Actor.GetServerNetworkAddress();

    // Disconnect from the current server (tick will handle the reconnect, sorta)
    DelayedConsoleCommand("Disconnect");
}

// Testing override of this function in hopes to stop the Unknown Steam Error bug
event ConnectFailure(string FailCode, string URL)
{
    local string Error, Server;
    local int    i,Index;

    LastURL = URL;
    Server = Left(URL, InStr(URL, "/"));

    i = InStr(FailCode, " ");

    if (i > 0)
    {
        Error = Right(FailCode, Len(FailCode) - i - 1);
        FailCode = Left(FailCode, i);
    }

    Log("Connect Failure: " @ FailCode $ "[" $ Error $ "] (" $ URL $ ")", 'Debug');

    if (FailCode == "NEEDPW")
    {
        /* Removing this, because the password saving stuff not only doesn't work right, but causes very strange problems with trying
        to connect to passworded servers!
        for (Index = 0; Index < SavedPasswords.Length; ++Index)
        {
            if (SavedPasswords[Index].Server == Server)
            {
                ViewportOwner.Actor.ClearProgressMessages();
                ViewportOwner.Actor.ClientTravel(URL $ "?password=" $ SavedPasswords[Index].Password,TRAVEL_Absolute, false);

                return;
            }
        }*/

        LastConnectedServer = Server;

        if (ViewportOwner.GUIController.OpenMenu("DH_Engine.DHGetPassword", Server, FailCode))
        {
            return;
        }
    }
    else if (FailCode == "WRONGPW")
    {
        ViewportOwner.Actor.ClearProgressMessages();

        for (Index = 0; Index < SavedPasswords.Length; Index++)
        {
            if (SavedPasswords[Index].Server == Server)
            {
                SavedPasswords.Remove(Index, 1);
                SaveConfig();
            }
        }

        LastConnectedServer = Server;

        if (ViewportOwner.GUIController.OpenMenu("DH_Engine.DHGetPassword", URL, FailCode))
        {
            return;
        }
    }
    else if (FailCode == "NEEDSTATS")
    {
        ViewportOwner.Actor.ClearProgressMessages();

        if (ViewportOwner.GUIController.OpenMenu(StatsPromptMenuClass, "", FailCode))
        {
            GUIController(ViewportOwner.GUIController).ActivePage.OnReopen = OnStatsConfigured;
            return;
        }
    }
    else if (FailCode == "LOCALBAN")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.GUIController.OpenMenu(class'GameEngine'.default.DisconnectMenuClass,Localize("Errors","ConnectionFailed", "Engine"), class'AccessControl'.default.IPBanned);
        return;
    }
    else if (FailCode == "SESSIONBAN")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.GUIController.OpenMenu(class'GameEngine'.default.DisconnectMenuClass,Localize("Errors","ConnectionFailed", "Engine"), class'AccessControl'.default.SessionBanned);
        return;
    }
    else if (FailCode == "SERVERFULL")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.GUIController.OpenMenu(class'GameEngine'.default.DisconnectMenuClass, ServerFullMsg);

        return;
    }
    else if (FailCode == "CHALLENGE")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.Actor.ClientNetworkMessage("FC_Challege", "");

        return;
    }
    // _RO_
    else if (FailCode == "STEAMLOGGEDINELSEWHERE")
    {
        ViewportOwner.Actor.ClearProgressMessages();

        LastConnectedServer = Server;

        if (ViewportOwner.GUIController.OpenMenu(SteamLoginMenuClass, URL, FailCode))
        {
            return;
        }
    }
    else if (FailCode == "STEAMVACBANNED")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.Actor.ClientNetworkMessage("ST_VACBan", "");

        return;
    }
    else if (FailCode == "STEAMVALIDATIONSTALLED")
    {
        // Lame hack for a Steam problem - take this out when Valve fixes the SteamValidationStalled bug
        if (SteamLoginRetryCount < 5)
        {
            ++SteamLoginRetryCount;

            ViewportOwner.Actor.ClientTravel(URL, TRAVEL_Absolute, false);
            ViewportOwner.GUIController.CloseAll(false, true);
        }
        else
        {
            ViewportOwner.Actor.ClearProgressMessages();
            ViewportOwner.Actor.ClientNetworkMessage("ST_Unknown", "");
        }

        return;
    }
    else if (FailCode == "STEAMAUTH")
    {
        // Check to see if the URL is more than just the IP, if so then use the cut off IP
        if (InStr(URL, "/") != -1)
        {
            ViewportOwner.Actor.ClientTravel(Server,TRAVEL_Absolute, false);
            ViewportOwner.GUIController.CloseAll(false, true);
            return;
        }
        else if (SteamLoginRetryCount < 5) // Try again a few times
        {
            SteamLoginRetryCount++;
            ViewportOwner.Actor.ClientTravel(URL,TRAVEL_Absolute, false);
            ViewportOwner.GUIController.CloseAll(false, true);
            return;
        }
        else
        {
            ViewportOwner.Actor.ClearProgressMessages();
            ViewportOwner.Actor.ClientNetworkMessage("ST_Unknown","");
            return;
        }
    }

    Log("Unhandled connection failure!  FailCode '" $ FailCode @ "'   URL '" $ URL $ "'");
    ViewportOwner.Actor.ProgressCommand("menu:" $ class'GameEngine'.default.DisconnectMenuClass, FailCode, Error);
}

// Modified for DHObjectives
state SpeechMenuVisible
{
    //--------------------------------------------------------------------------
    // build voice command array for attack voices
    //--------------------------------------------------------------------------
    function buildSMAttackArray()
    {
       local DHGameReplicationInfo DHGRI;
       local DHPlayerReplicationInfo DHPRI;
       local int i;

       DHGRI = DHGameReplicationInfo(ViewportOwner.Actor.GameReplicationInfo);
       DHPRI = DHPlayerReplicationInfo(ViewportOwner.Actor.PlayerReplicationInfo);
       SMArraySize = 0;
       PreviousStateName = ROSMS_Commanders;

       for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
        {
            if (DHGRI.DHObjectives[i] != none)
            {
                switch (DHPRI.RoleInfo.Side)
                {
                   case SIDE_Axis:
                       if ((DHGRI.DHObjectives[i].IsAllies() || DHGRI.DHObjectives[i].IsNeutral()) && DHGRI.DHObjectives[i].bActive)
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }
                       break;

                   case SIDE_Allies:
                       if ((DHGRI.DHObjectives[i].IsAxis() || DHGRI.DHObjectives[i].IsNeutral()) && DHGRI.DHObjectives[i].bActive)
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }

                       break;
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    // build voice command array for defend voices
    //--------------------------------------------------------------------------
    function buildSMDefendArray()
    {
       local DHGameReplicationInfo DHGRI;
       local DHPlayerReplicationInfo DHPRI;
       local int i;

       DHGRI = DHGameReplicationInfo(ViewportOwner.Actor.GameReplicationInfo);
       DHPRI = DHPlayerReplicationInfo(ViewportOwner.Actor.PlayerReplicationInfo);
       SMArraySize = 0;
       PreviousStateName = ROSMS_Commanders;

       //TODO: find out if the number of objectives can be hardcoded (16)
       for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
       {
            if (DHGRI.DHObjectives[i] != none)
            {
                switch (DHPRI.RoleInfo.Side)
                {
                   case SIDE_Axis:
                       if (DHGRI.DHObjectives[i].IsAxis())
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }
                       break;

                   case SIDE_Allies:
                       if (DHGRI.DHObjectives[i].IsAllies())
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }

                       break;
                }
            }
        }

    }

    function buildSMGotoArray()
    {
       local DHGameReplicationInfo DHGRI;
       local int i;

       DHGRI = DHGameReplicationInfo(ViewportOwner.Actor.GameReplicationInfo);
       SMArraySize = 0;
       PreviousStateName = ROSMS_Vehicle_Orders;

       //TODO: find out if the number of objectives can be hardcoded (16)
       for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
       {
            if (DHGRI.DHObjectives[i] != none)
            {
                SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                SMArraySize++;
            }
        }
    }
}

exec function VehicleTalk()
{
    if (CanUseSayType("VehicleSay"))
    {
        SayType = "VehicleSay";
        TypedStr = "";
        TypedStrPos = 0;
        TypingOpen();
    }
}

exec function TeamTalk()
{
    if (CanUseSayType("TeamSay"))
    {
        SayType = "TeamSay";
        TypedStr = "";
        TypedStrPos = 0;
        TypingOpen();
    }
}

exec function SquadTalk()
{
    if (CanUseSayType("SquadSay"))
    {
        SayType = "SquadSay";
        TypedStr = "";
        TypedStrPos = 0;
        TypingOpen();
    }
}

exec function Talk()
{
    UpdateSayType();
    TypedStr = "";
    TypedStrPos = 0;
    TypingOpen();
}

// Modified to fix reconnect command bug
exec function ConsoleClose()
{
    // If we are locked open, then do nothing and return
    if (bLockConsoleOpen)
    {
        // To prevent from always being locked lets unlock now, this also gives the user a chance to cancel the reconnect by closing the console
        bLockConsoleOpen = false;
        return;
    }

    super.ConsoleClose();
}

function DecrementSayType()
{
    local int i, j, SayTypeIndex;

    SayTypeIndex = GetSayTypeIndex(SayType);
    --SayTypeIndex;

    for (i = 0; i < SayTypes.Length; ++i)
    {
        // TODO: not sure if unrealscript is smart enough to do the mod correctly
        j = (SayTypeIndex - i) % SayTypes.Length;

        if (CanUseSayType(SayTypes[j]))
        {
            SayType = SayTypes[j];
            return;
        }
    }
}

function IncrementSayType()
{
    local int i, j, SayTypeIndex;

    SayTypeIndex = GetSayTypeIndex(SayType);
    ++SayTypeIndex;

    for (i = 0; i < SayTypes.Length; ++i)
    {
        j = (SayTypeIndex + i) % SayTypes.Length;

        if (CanUseSayType(SayTypes[j]))
        {
            SayType = SayTypes[j];
            return;
        }
    }
}

static function int GetSayTypeIndex(string SayType)
{
    local int i;

    for (i = 0; i < default.SayTypes.Length; ++i)
    {
        if (SayType == default.SayTypes[i])
        {
            return i;
        }
    }

    return -1;
}

// If the current SayType is invalid, find the next available SayType.
function UpdateSayType()
{
    if (!CanUseSayType(SayType))
    {
        IncrementSayType();
    }
}

function bool CanUseSayType(string SayType)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none)
    {
        return false;
    }

    switch (SayType)
    {
        case "Say":
            return true;
        case "TeamSay":
            return PC.PlayerReplicationInfo != none && PC.PlayerReplicationInfo.Team != none;
        case "SquadSay":
            return PC.IsInSquad();
        case "VehicleSay":
            return PC.Pawn != none && PC.Pawn.IsA('Vehicle');
    }

    return false;
}

state Typing
{
    function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
    {
        local string Temp;

        if (Action == IST_Press)
        {
            bIgnoreKeys = false;
        }

        if (Key == IK_Escape)
        {
            if (TypedStr != "")
            {
                TypedStr = "";
                TypedStrPos = 0;
                HistoryCur = HistoryTop;
            }
            else
            {
                TypingClose();
            }

             return true;
        }
        else if (Action != IST_Press)
        {
            return false;
        }
        else if (Key == IK_Enter)
        {
            if (TypedStr != "")
            {
                History[HistoryTop] = TypedStr;
                HistoryTop = (HistoryTop + 1) % arraycount(History);

                if (HistoryBot == -1 || HistoryBot == HistoryTop)
                {
                    HistoryBot = (HistoryBot+1) % arraycount(History);
                }

                HistoryCur = HistoryTop;

                // Make a local copy of the string.
                Temp = SayType @ TypedStr;
                TypedStr = "";
                TypedStrPos = 0;

                if (!ConsoleCommand(Temp))
                {
                    Message(Localize("Errors", "Exec", "Core"), 6.0);
                }

                Message("", 6.0);
            }

            TypingClose();

            return true;
        }
        else if (Key == IK_Up)
        {
            if (HistoryBot >= 0)
            {
                if (HistoryCur == HistoryBot)
                {
                    HistoryCur = HistoryTop;
                }
                else
                {
                    HistoryCur--;

                    if (HistoryCur < 0)
                    {
                        HistoryCur = arraycount(History) - 1;
                    }
                }

                TypedStr = History[HistoryCur];
                TypedStrPos = Len(TypedStr);
            }

            return true;
        }
        else if (Key == IK_Down)
        {
            if (HistoryBot >= 0)
            {
                if (HistoryCur == HistoryTop)
                {
                    HistoryCur = HistoryBot;
                }
                else
                {
                    HistoryCur = (HistoryCur+ 1 ) % arraycount(History);
                }

                TypedStr = History[HistoryCur];
                TypedStrPos = Len(TypedStr);
            }
        }
        else if (Key == IK_Backspace)
        {
            if (TypedStrPos > 0)
            {
                TypedStr = Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos);
                --TypedStrPos;
            }

            return true;
        }
        else if (Key == IK_Delete)
        {
            if (TypedStrPos < Len(TypedStr))
            {
                TypedStr = Left(TypedStr, TypedStrPos) $ Right(TypedStr, Len(TypedStr) - TypedStrPos - 1);
            }

            return true;
        }
        else if (Key == IK_Left)
        {
            TypedStrPos = Max(0, TypedStrPos - 1);
            return true;
        }
        else if (Key == IK_Right)
        {
            TypedStrPos = Min(Len(TypedStr), TypedStrPos + 1);
            return true;
        }
        else if (Key == IK_Home)
        {
            TypedStrPos = 0;
            return true;
        }
        else if (Key == IK_End)
        {
            TypedStrPos = Len(TypedStr);
            return true;
        }
        else if (Key == IK_Tab)
        {
            IncrementSayType();
        }

        return true;
    }
}

defaultproperties
{
    NeedPasswordMenuClass="DH_Engine.DHGetPassword" // lol this doesn't even work, had to replace the reference to this with a direct string

    SayTypes(0)="Say"
    SayTypes(1)="TeamSay"
    SayTypes(2)="SquadSay"
    SayTypes(3)="VehicleSay"
}

