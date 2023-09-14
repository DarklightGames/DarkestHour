//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// The top menu, which lists all the players on the server, allowing a selection to be made
// Can also choose the special menu for a realism match (or testing) from here (if that option is allowed by the server)
class DHAdminMenu_PlayerMenu extends DHAdminMenu_MenuBase;

var localized string    Label_AimedPlayer,
                        Label_RealismMenu,
                        Label_ServerMenu;                     // menu labels for the options for 'player in your sights' & the realism/testing menu

var localized EInputKey KeyForRealismMenu,
                        KeyForServerMenu;                    // localized to allow default R key to be changed to suit a different language

exec function Menu()
{
    GetAllPlayerNames();
    GotoState('MenuVisible');
}

function GetAllPlayerNames()
{
    local array<PlayerReplicationInfo> AllPRI;
    local int                          i;

    MenuText.Length = 0;
    MenuText[0] = Label_AimedPlayer;
    PC.GameReplicationInfo.GetPRIArray(AllPRI);

    for (i = 0; i < AllPRI.Length; ++i)
    {
        if (ROPlayerReplicationInfo(AllPRI[i]) != none && AllPRI[i].PlayerName != "") // includes spectators & bots, but cast to ROPRI excluded "WebAdmin" & possible other phantom 'players'
        {
            MenuText[MenuText.Length] = AllPRI[i].PlayerName;
        }
    }
}

state MenuVisible
{
    // Extended to include special key press options for realism/testing menu or choosing the player in your sights
    function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
    {
        if (Action == IST_Press)
        {
            // Pressing '0' on 1st player list screen is always "the player in your sights" option
            if (Key == IK_0 && MenuPage == 0)
            {
                GotoState(''); // close current menu
                SelectPlayerInSights();

                return true;
            }

            // If press R (or other config-defined key) for realism/testing menu & the option is enabled on the server
            if (Key == KeyForRealismMenu && Replicator != none && Replicator.bShowRealismMenu)
            {
                GotoState(''); // close current menu
                ConsoleCommand("RealismMenu");

                return true;
            }

            // If press M (server menu, open server menu)
            if (Key == KeyForServerMenu)
            {
                GotoState(''); // close current menu
                ConsoleCommand("ServerMenu");

                return true;
            }
        }

        return super.KeyEvent(Key, Action, Delta);
    }

    // Makes the 'Menu' command act as a toggle, so it closes the menu if we call it again when the menu is already visible
    exec function Menu()
    {
        GotoState('');
    }
}

// Extended to add the realism/testing option if it's enabled (after calling the Super to display the main menu)
function DrawMenu(canvas Canvas, int PosX, out int PosY, string Title, array<string> LineText, optional out float LineHeight)
{
    super.DrawMenu(Canvas, PosX, PosY, Title, LineText, LineHeight);

    // Draw Server Menu
    PosY += LineHeight * 2.0; // skip a line
    Canvas.SetPos(PosX, PosY);
    Canvas.DrawText(Label_ServerMenu);

    if (Replicator != none && Replicator.bShowRealismMenu)
    {
        PosY += LineHeight * 2.0; // skip a line
        Canvas.SetPos(PosX, PosY);
        Canvas.DrawText(Label_RealismMenu);
    }
}

// Selects the player in your sights, without having to select their name from the list
function SelectPlayerInSights()
{
    local string PlayerName;
    local int    TraceDistance;
    local vector HitLocation, HitNormal, StartTrace, EndTrace;
    local Pawn   HitPawn;

    if (ROPlayer(PC) != none)
    {
        TraceDistance = ROPlayer(PC).GetMaxViewDistance();
        StartTrace = PC.Pawn.Location + PC.Pawn.EyePosition();
        EndTrace = StartTrace + TraceDistance * vector(PC.Pawn.GetViewRotation());

        HitPawn = Pawn(PC.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true));

        // replaces any spaces in player's name with non-breaking spaces, which effectively makes it 1 word while looking the same
        if (HitPawn != none && HitPawn.PlayerReplicationInfo != none)
        {
            PlayerName = Repl(HitPawn.PlayerReplicationInfo.PlayerName," "," ");
        }

        if (bDebug)
        {
            Log("DHAdminMenu: SelectPlayerInSights =" @ PlayerName);
        }

        if (PlayerName != "")
        {
            ConsoleCommand(SelectionPrefix @ PlayerName);

            if (bDebug)
            {
                Log("DHAdminMenu: execute console command =" @ SelectionPrefix @ PlayerName);
            }
        }
        else
        {
            ErrorMessageToSelf(24); // no player in sights
            Menu(); // go back to player list instead instead of closing menu if no player in sights, so allowing another player choice
        }
    }
}

defaultproperties
{
    MenuTitle="PLAYER ADMIN MENU"
    bUseMenuTextAsMenuCommand=true
    SelectionPrefix="PlayerActionsMenu"
    bTreatSelectionAsOneWord=true

    Label_AimedPlayer="[Player in your sights]"
    Label_RealismMenu="R = realism match (or testing) menu"
    Label_ServerMenu="M = server menu (common server settings)"
    KeyForRealismMenu=IK_R
    KeyForServerMenu=IK_M
}
