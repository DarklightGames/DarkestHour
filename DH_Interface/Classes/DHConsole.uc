//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConsole extends ROConsole;

// Testing override of this function in hopes to stop the Unknown Steam Error bug
event ConnectFailure(string FailCode,string URL)
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
        for (Index = 0; Index < SavedPasswords.Length; ++Index)
        {
            if (SavedPasswords[Index].Server == Server)
            {
                ViewportOwner.Actor.ClearProgressMessages();
                ViewportOwner.Actor.ClientTravel(URL $ "?password=" $ SavedPasswords[Index].Password,TRAVEL_Absolute, false);

                return;
            }
        }

        LastConnectedServer = Server;

        if (ViewportOwner.GUIController.OpenMenu(NeedPasswordMenuClass, URL, FailCode))
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

        if (ViewportOwner.GUIController.OpenMenu(NeedPasswordMenuClass, URL, FailCode))
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
    else if (FailCode == "STEAMAUTH" /*|| FailCode == "STEAMVALIDATIONSTALLED"*/)
    {
        if (SteamLoginRetryCount < 5)
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
    // end _RO_

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
                       if ((DHGRI.DHObjectives[i].ObjState == OBJ_Allies ||
                           DHGRI.DHObjectives[i].ObjState == OBJ_Neutral) &&
                           DHGRI.DHObjectives[i].bActive)
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }
                       break;

                   case SIDE_Allies:
                       if ((DHGRI.DHObjectives[i].ObjState == OBJ_Axis ||
                           DHGRI.DHObjectives[i].ObjState == OBJ_Neutral) &&
                           DHGRI.DHObjectives[i].bActive)
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
                       if (DHGRI.DHObjectives[i].ObjState == OBJ_Axis)
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }
                       break;

                   case SIDE_Allies:
                       if (DHGRI.DHObjectives[i].ObjState == OBJ_Allies)
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
    if (ViewportOwner != none &&
        ViewportOwner.Actor != none &&
        ViewportOwner.Actor.Pawn != none &&
        ViewportOwner.Actor.Pawn.IsA('Vehicle'))
    {
        TypedStr = "VehicleSay ";
        TypedStrPos = Len(TypedStr);
        TypingOpen();
    }
}

defaultproperties
{
}
