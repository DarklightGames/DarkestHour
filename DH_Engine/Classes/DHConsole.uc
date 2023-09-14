//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConsole extends ROConsole;

const RECONNECT_DELAY = 1.0;

var bool        bLockConsoleOpen;
var bool        bDelayForReconnect;
var float       DelayWaitTime;
var string      StoredServerAddress;

var array<string>           SayTypes;
var string                  SayType;

// Since "say" messages are being treated differently now, we want to keep a
// separate history so we don't accidentally broadcast console messages (like
// admin login credentials etc.).
var array<string>           SayHistory;
var int                     SayHistoryCur;

const SAY_HISTORY_MAX = 16;

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
        ViewportOwner.GUIController.OpenMenu(class'GameEngine'.default.DisconnectMenuClass,Localize("Errors","ConnectionFailed", "Engine"), class'DHAccessControl'.default.IPBanned);
        return;
    }
    else if (FailCode == "SESSIONBAN")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.GUIController.OpenMenu(class'GameEngine'.default.DisconnectMenuClass,Localize("Errors","ConnectionFailed", "Engine"), class'DHAccessControl'.default.SessionBanned);
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

// Modified for DHObjectives and to give squad leaders access to order commands.
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

    // Build voice command array for main voices.
    // Overriden to give squad leaders the ability to use order commands.
    function BuildSMMainArray()
    {
        local int i;
        local bool bCanUseOrderCommands, bCanUseVehicleCommands;

        SMOffset = 0;
        SMArraySize = 0;

        bCanUseOrderCommands = CanUseOrderCommands();
        bCanUseVehicleCommands = CanUseVehicleCommands();

        for (i = 1; i < 9; i++)
        {
            if (((i == 5 || i == 6) && !bCanUseVehicleCommands) ||
                 (i == 7 && !bCanUseOrderCommands))
            {
                continue;
            }

            SMNameArray[SMArraySize] = SMStateName[i];
            SMIndexArray[SMArraySize] = i;
            SMArraySize++;
        }
    }

    // Build voice command array for order voices.
    function BuildSMOrderArray()
    {
        local int i;
        local class<ROVoicePack> ROVP;

        SMArraySize = 0;
        SMOffset = 0;
        PreviousStateName = ROSMS_Main;

        ROVP = GetROVoiceClass();

        if (ROVP == none)
        {
            return;
        }

        if (CanUseOrderCommands())
        {
            for (i = 0; i < ROVP.Default.numCommands; i++)
            {
                if(ROVP.Default.OrderAbbrev[i] != "")
                {
                    SMNameArray[SMArraySize] = ROVP.Default.OrderAbbrev[i];
                }
                else
                {
                    SMNameArray[SMArraySize] = ROVP.Default.OrderString[i];
                }

                SMIndexArray[SMArraySize] = i;
                SMArraySize++;
            }
        }
    }

    // Overriden to give squad leaders the ability to use order commands.
    // TODO: This function could use a refactor
    function HandleInput(int KeyIn)
    {
        local int SelectIndex;
        local bool bCanUseVehicleCommands;

        // GO BACK - previous state (might back out of menu);
        if (KeyIn == -1)
        {
            LeaveState();
            HighlightRow = 0;
            return;
        }

        // TOP LEVEL - we just enter a new state
        if (ROSMState == ROSMS_Main)
        {
            bCanUseVehicleCommands = CanUseVehicleCommands();

            //only leaders are able to issue orders
            if (CanUseOrderCommands())
            {
                // don't show vehicle commands if not in vehicle
                if (bCanUseVehicleCommands)
                {
                        switch (KeyIn)
                        {
                            case 1: SMType = 'SUPPORT'; EnterROState(ROSMS_Support); break;
                            case 2: SMType = 'ACK'; EnterROState(ROSMS_Ack); break;
                            case 3: SMType = 'ENEMY'; EnterROState(ROSMS_Enemy); break;
                            case 4: SMType = 'ALERT'; EnterROState(ROSMS_Alert); break;
                            case 5: SMType = 'VEH_ORDERS'; EnterROState(ROSMS_Vehicle_Orders); break;
                            case 6: SMType = 'VEH_ALERTS'; EnterROState(ROSMS_Vehicle_Alerts); break;
                            case 7: SMType = 'ORDER'; EnterROState(ROSMS_Commanders); break;
                            case 8: SMType = 'TAUNT'; EnterROState(ROSMS_Extras); break;
                        }
                }
                else
                {
                        switch (KeyIn)
                        {
                            case 1: SMType = 'SUPPORT'; EnterROState(ROSMS_Support); break;
                            case 2: SMType = 'ACK'; EnterROState(ROSMS_Ack); break;
                            case 3: SMType = 'ENEMY'; EnterROState(ROSMS_Enemy); break;
                            case 4: SMType = 'ALERT'; EnterROState(ROSMS_Alert); break;
                            case 5: SMType = 'ORDER'; EnterROState(ROSMS_Commanders); break;
                            case 6: SMType = 'TAUNT'; EnterROState(ROSMS_Extras); break;
                        }
                }
            }
            else
            {
               // Non-leaders, no orders
               if (bCanUseVehicleCommands)
               {
                    switch (KeyIn)
                    {
                        case 1: SMType = 'SUPPORT'; EnterROState(ROSMS_Support); break;
                        case 2: SMType = 'ACK'; EnterROState(ROSMS_Ack); break;
                        case 3: SMType = 'ENEMY'; EnterROState(ROSMS_Enemy); break;
                        case 4: SMType = 'ALERT'; EnterROState(ROSMS_Alert); break;
                        case 5: SMType = 'VEH_ORDERS'; EnterROState(ROSMS_Vehicle_Orders); break;
                        case 6: SMType = 'VEH_ALERTS'; EnterROState(ROSMS_Vehicle_Alerts); break;
                        case 7: SMType = 'TAUNT'; EnterROState(ROSMS_Extras); break;
                    }
                }
                else
                {
                   switch (KeyIn)
                   {
                       case 1: SMType = 'SUPPORT'; EnterROState(ROSMS_Support); break;
                       case 2: SMType = 'ACK'; EnterROState(ROSMS_Ack); break;
                       case 3: SMType = 'ENEMY'; EnterROState(ROSMS_Enemy); break;
                       case 4: SMType = 'ALERT'; EnterROState(ROSMS_Alert); break;
                       case 5: SMType = 'TAUNT'; EnterROState(ROSMS_Extras); break;
                   }
               }
            }

            return;
        }
        else if (ROSMState == ROSMS_Commanders)
        {
            switch (KeyIn)
            {
                case 1: SMType = 'ATTACK'; EnterROState(ROSMS_Attack);
                        return;
                case 2: SMType = 'DEFEND'; EnterROState(ROSMS_Defend);
                        return;
            }

            if (KeyIn < 3) // Send messages for other orders
            {
               return;
            }
        }
        else if (ROSMState == ROSMS_Vehicle_Orders && KeyIn == 1)
        {
            SMType = 'VEH_GOTO'; EnterROState(ROSMS_Vehicle_Goto);
            return;
        }
        else if (ROSMState == ROSMS_Support && KeyIn == 2)
        {
            SMType = 'HELPAT'; EnterROState(ROSMS_HelpAt);
            return;
        }
        else if (ROSMState == ROSMS_Alert && KeyIn == 9)
        {
            SMType = 'UNDERATTACK'; EnterROState(ROSMS_UnderAttackAt);
            return;
        }

        // Next page on the same level
        if (KeyIn == 0)
        {
            // Check there is a next page!
            if (SMArraySize - SMOffset > 9 && SMArraySize != 10)
            {
                SMOffset += 9;
                return;
            }

            KeyIn = 10;
        }

        // Previous page on the same level
        if (KeyIn == -2)
        {
            SMOffset = Max(SMOffset - 9, 0);
            return;
        }

        // Otherwise - we have selected something!
        SelectIndex = SMOffset + KeyIn - 1;

        if (SelectIndex < 0 || SelectIndex >= SMArraySize) // discard - out of range selections.
        {
            return;
        }

        // Check if we need to open a new menu to select order target squad
        if (ROSMState == ROSMS_Attack || ROSMState == ROSMS_Defend || ROSMState == ROSMS_Commanders)
        {
            if (bCheckIfOwnerTeamHasBots())
            {
                // Save selected objective
                savedSelectedObjective = SMIndexArray[SelectIndex];

                // Generate menu with list of bots
                EnterROState(ROSMS_SelectSquad);
                return;
            }
        }

        if (ROSMState == ROSMS_SelectSquad)
        {
            // If this were the squad select menu, we want to have special code to
            // handle speech generation (to select proper objective and target
            // squad)
            if (SMIndexArray[SelectIndex] != -1)
            {
                ViewportOwner.Actor.xSpeech(SMType, savedSelectedObjective, PRIs[SMIndexArray[SelectIndex]]);
            }
            else
            {
                ViewportOwner.Actor.xSpeech(SMType, savedSelectedObjective, none);
            }
        }
        else
        {
            ViewportOwner.Actor.Speech(SMType, SMIndexArray[SelectIndex], "");
        }

        PlayConsoleSound(SMAcceptSound);
        GotoState('');
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
    if (CanUseSayType("Say"))
    {
        SayType = "Say";
        TypedStr = "";
        TypedStrPos = 0;
        TypingOpen();
    }
}

exec function StartTyping()
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
        j = (SayTypeIndex - i) % SayTypes.Length;

        if (j < 0)
        {
            // Unrealscript has an interesting idea of what a modulo operator
            // does, so we need to correct this.
            j = -j;
        }

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

        if (j < 0)
        {
            // Unrealscript has an interesting idea of what a modulo operator
            // should be doing, so we need to correct it.
            j = -j;
        }

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

// If the current SayType is invalid, revert to the default say type.
function UpdateSayType()
{
    if (!CanUseSayType(SayType))
    {
        if (CanUseSayType(default.SayType))
        {
            SayType = default.SayType;
        }
        else
        {
            DecrementSayType();
        }
    }
}

function bool CanUseSayType(string SayType)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;

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
        case "CommandSay":
            PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
            return PRI != none && PRI.CanAccessCommandChannel();
    }

    return false;
}

static function class<DHLocalMessage> GetSayTypeMessageClass(string SayType)
{
    // TODO: make struct of saytypes instead
    switch (SayType)
    {
        case "Say":
            return class'DHSayMessage';
        case "TeamSay":
            return class'DHTeamSayMessage';
        case "SquadSay":
            return class'DHSquadSayMessage';
        case "VehicleSay":
            return class'DHVehicleSayMessage';
        case "CommandSay":
            return class'DHCommandSayMessage';
    }

    return none;
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
                SayHistoryCur = -1;
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
                History[HistoryTop] = SayType @ TypedStr;
                HistoryTop = (HistoryTop + 1) % arraycount(History);

                if (HistoryBot == -1 || HistoryBot == HistoryTop)
                {
                    HistoryBot = (HistoryBot + 1) % arraycount(History);
                }

                HistoryCur = HistoryTop;

                // SayHistory
                SayHistory.Insert(0, 1);
                SayHistory[0] = TypedStr;

                if (SayHistory.Length > SAY_HISTORY_MAX)
                {
                    SayHistory.Length = SAY_HISTORY_MAX;
                }

                SayHistoryCur = -1;

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
            SayHistoryCur = (SayHistoryCur + 1) % SayHistory.Length;
            TypedStr = SayHistory[SayHistoryCur];
            TypedStrPos = Len(TypedStr);
            return true;
        }

        else if (Key == IK_Down)
        {
            if (SayHistoryCur == -1)
            {
                SayHistoryCur = SayHistory.Length;
            }

            SayHistoryCur = (SayHistoryCur - 1) % SayHistory.Length;
            TypedStr = Eval(SayHistoryCur == -1, "", SayHistory[SayHistoryCur]);
            TypedStrPos = Len(TypedStr);
            return true;
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

function bool CanUseOrderCommands()
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(ViewportOwner.Actor.PlayerReplicationInfo);

    return (PRI != none && PRI.IsSquadLeader()) || ViewportOwner.Actor.Level.NetMode == NM_Standalone;
}

function bool CanUseVehicleCommands()
{
    local Pawn P;

    P = ViewportOwner.Actor.Pawn;

    return P != none && (P.IsA('ROVehicle') || P.IsA('ROVehicleWeaponPawn'));
}

defaultproperties
{
    NeedPasswordMenuClass="DH_Engine.DHGetPassword" // lol this doesn't even work, had to replace the reference to this with a direct string

    SayType="Say"
    SayTypes(0)="Say"
    SayTypes(1)="TeamSay"
    SayTypes(2)="SquadSay"
    SayTypes(3)="CommandSay"
    SayTypes(4)="VehicleSay"
}
