//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHConsole extends ROConsole;

// Testing override of this function in hopes to stop the Unknown Steam Error bug
event ConnectFailure(string FailCode,string URL)
{
    local string Error, Server;
    local int    i,Index;

    LastURL = URL;
    Server = Left(URL, InStr(URL, "/"));

    i = instr(FailCode, " ");

    if (i > 0)
    {
        Error = Right(FailCode, Len(FailCode) - i - 1);
        FailCode = Left(FailCode, i);
    }

    Log("Connect Failure: " @ FailCode $ "[" $ Error $ "] (" $ URL $ ")", 'Debug');

    if (FailCode == "NEEDPW")
    {
        for (Index = 0;Index < SavedPasswords.Length;Index++)
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
            SteamLoginRetryCount++;

            ViewportOwner.Actor.ClientTravel(URL,TRAVEL_Absolute, false);
            ViewportOwner.GUIController.CloseAll(false, true);

            return;
        }
        else
        {
            ViewportOwner.Actor.ClearProgressMessages();
            ViewportOwner.Actor.ClientNetworkMessage("ST_Unknown","");
            //ViewportOwner.Actor.ClientNetworkMessage("This stalled, Theel", "");

            return;
        }
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
            //ViewportOwner.Actor.ClientNetworkMessage("This steam auth, Theel", "");

            return;
        }
    }
    // end _RO_

    Log("Unhandled connection failure!  FailCode '" $ FailCode @ "'   URL '" $ URL $ "'");
    ViewportOwner.Actor.ProgressCommand("menu:" $ class'GameEngine'.default.DisconnectMenuClass, FailCode, Error);
}

defaultproperties
{
}
