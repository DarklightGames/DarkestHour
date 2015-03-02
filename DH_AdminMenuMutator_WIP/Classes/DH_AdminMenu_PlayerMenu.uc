//==========================================================================================
// DH_AdminMenu_PlayerMenu - by Matt UK
//==========================================================================================
//
// The top menu, which lists all the players on the server, allowing a selection to be made
// Can also choose the realism menu from here (if that option is allowed by the server)
//
//==========================================================================================
class DH_AdminMenu_PlayerMenu extends DH_AdminMenu_MenuBase;

var  localized string     Label_AimedPlayer, Label_RealismMenu; // menu labels localised so different language versions could be produced
var  localized EInputKey  KeyForRealismMenu;                    // also localised to allow default R key to be changed to suit a different language

exec function Menu()
{
    GetAllPlayerNames();
    GotoState('MenuVisible');
}

function GetAllPlayerNames()
{
    local  array<PlayerReplicationInfo>  AllPRI;
    local  PlayerReplicationInfo         PRI;
    local  int                           i;

    MenuText.Length = 0;
    MenuText[0] = Label_AimedPlayer;
    PC.GameReplicationInfo.GetPRIArray(AllPRI);

    for (i = 0; i < AllPRI.Length; ++i)
    {
        PRI = AllPRI[i];

        if (PRI != none && ROPlayerReplicationInfo(PRI) != none && (PRI.Team != none || PRI.bOnlySpectator) && PRI.PlayerName != "") // includes spectators & bots
        {
            MenuText[MenuText.Length] = PRI.PlayerName;
        }
    }
}

state MenuVisible
{
    // Extended to include special key press options for realism match menu or choosing the player in your sights
    function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
    {
        if (Action == IST_Press)
        {
            if (Key == IK_0 && MenuPage == 0) // if on 1st player list screen & press 0 for "the player in your sights"
            {
                GotoState(''); // close current menu
                SelectPlayerInSights();
                return true;
            }

            if (Key == KeyForRealismMenu && Replicator != none && Replicator.bShowRealismMenu) // if press R (or other defined key) for realism menu & the option is enabled on the server
            {
                GotoState(''); // close current menu
                ConsoleCommand("RealismMenu");
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

// Extended to add the realism match option if it's enabled (after calling the Super to display the main menu)
function DrawMenu(canvas Canvas, int PosX, out int PosY, string Title, array<string> LineText, optional out float LineHeight)
{
    super.DrawMenu(Canvas, PosX, PosY, Title, LineText, LineHeight);

    // draw the option for the realism menu
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
    local  string  PlayerName;
    local  int     TraceDistance;
    local  vector  HitLocation, HitNormal, StartTrace, EndTrace;
    local  Pawn    HitPawn;

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
            Log("DH_AdminMenu: SelectPlayerInSights =" @ PlayerName);
        }

        if (PlayerName != "")
        {
            ConsoleCommand(SelectionPrefix @ PlayerName);

            if (bDebug)
            {
                Log("DH_AdminMenu: execute console command =" @ SelectionPrefix @ PlayerName);
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
    Label_RealismMenu="R = realism match menu"
    KeyForRealismMenu=IK_R
}
