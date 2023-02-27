//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// The base for all admin menu local interactions (these are the menus that only exist clientside, not on the server)
// Note that text strings are made as localized variables so different language versions can be produced
class DHAdminMenu_MenuBase extends Interaction
    abstract;

const  ITEMS_PER_PAGE = 10; // how many menu items are to be displayed on one page

var  localized array<string>  MenuText;             // array of the menu option description to be displayed
var  array<string>            MenuCommand;          // array of the actual command lines to be executed when we choose a menu option

var  DHAdminMenu_Replicator   Replicator;           // reference to the mutator's 'helper' replicated actor, which replicates some variables used by the menus on the client
var  PlayerController         PC;                   // reference to the local PlayerController, just to simplify lots of ViewportOwner.Actor references
var  int                      MenuPage;             // for menu lists that run over into more than 1 page, this records the current page number
var  string                   PreviousMenu;         // saves the command to open the previous menu, so that 'previous menu' key can operate correctly
var  bool                     bMenuDidAdminLogin;   // gets set to true if the menu automatically logs in the admin, which flags that we need to log them out afterwards
var  bool                     bInitialVariablesSet; // a flag that we have done initial setup

// Variables set in menus to tell HandleInput function how to build its command string
// (allows HI to be a generic function & avoids subclass redefinitions)
var  localized string  MenuTitle;                   // menu heading on the screen
var  string            SelectionPrefix;             // any text to add before the selected menu command
var  string            SelectionSuffix;             // any text to after the selected menu command
var  bool              bUseSelectionIndexAsSuffix;  // tells HI to use the selection index number as SelectionSuffix, i.e. add the number at the end of the command string
var  bool              bUseMenuTextAsMenuCommand;   // tells HI to use the MenuText array instead of a separate MenuCommand array (e.g. for player selection list)
var  bool              bTreatSelectionAsOneWord;    // tells HI to replace any spaces with non-breaking spaces, which effectively makes name into 1 word but looks the same
var  bool              bKeepMenuOpen;               // if set to true it prevents HI from closing the menu after the function completes, e.g. if error is encountered

// Menu labels
var  localized string  Label_PageNumber, Label_PreviousMenu, Label_PreviousPage, Label_NextPage, Label_ExitMenu;

// Config variables that can be set (or overridden) in any player's DarkestHour.ini file
var  config  string    AdminName, AdminPassword;    // local player's own admin account details - if added to their config file, menu automatically logs them in & out
var  config  color     MenuColour;                  // a default is set but can be overridden in config
var  config  float     MenuPosX, MenuPosY;          // top left positioning of menus on the screen, ranging from 0 to 1 (a default is set but can be overridden in config)
var  config  bool      bDebug;                      // if true, various events will be logged

// Triggered when an interaction is created, which happens every round as re remove & re-create menus each time
// However it is often too early to do setup stuff, e.g. wouldn't have Replicator reference & may not have GRI
function Initialized()
{
    PC = ViewportOwner.Actor; // just to simplify lots of ViewportOwner.Actor references

    if (bDebug)
    {
        Log(Name @ "initialized as local interaction - admin account in local config =" @ AdminName);
    }
}

state MenuVisible
{
    function BeginState()
    {
        bVisible = true;
        MenuPage = 0;
    }

    function EndState()
    {
        bVisible = false;
    }

    function PostRender(canvas Canvas)
    {
        local int PosX, PosY;

        // Calculate the top left position for the menu, as a proportion of the screen resolution
        PosX = MenuPosX * Canvas.ClipX;
        PosY = MenuPosY * Canvas.ClipY;

        DrawMenu(Canvas, PosX, PosY, MenuTitle, MenuText);
    }

    function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
    {
        local int KeyNumber;

        if (Action == IST_Press)
        {
            // Handle a number key press
            if (IsNumberKey(Key, KeyNumber))
            {
                if (bUseMenuTextAsMenuCommand) // if flagged as true we use MenuText array instead of separate MenuCommand array (means the 2 arrays would be same anyway)
                {
                    return HandleInput(KeyNumber, MenuText);
                }
                else
                {
                    return HandleInput(KeyNumber, MenuCommand);
                }
            }

            // Handle escape key press (exit menu)
            if (Key == IK_Escape)
            {
                GotoState('');    // close menu
                AdminLogoutIfNecessary();

                return true;
            }

            // Handle page down key press (next page)
            if (Key == IK_PageDown)
            {
                if (MenuText.Length > ((MenuPage + 1) * ITEMS_PER_PAGE))
                {
                    MenuPage++;
                }

                return true;
            }

            // Handle page up key press (previous page or previous menu)
            if (Key == IK_PageUp)
            {
                if (MenuPage > 0) // previous page if not on 1st menu page
                {
                    MenuPage--;
                }
                else if (PreviousMenu != "") // otherwise previous menu (if there is one)
                {
                    GotoState(''); // close current menu
                    ConsoleCommand(PreviousMenu);
                }

                return true;
            }
        }

        return false;
    }
}

// Displays menu based on an input list - updates PosY & LineHeight for use in subclass (PosY is last drawn vertical position, allowing subclass to add to end of menu list)
function DrawMenu(canvas Canvas, int PosX, out int PosY, string Title, array<string> LineText, optional out float LineHeight)
{
    local int   KeyNumber, i;
    local float XL;

    // Set correct LineHeight based on the player's local config for ConsoleFontSize
    Canvas.TextSize("SAMPLE", XL, LineHeight);

    // Set menu text colour based on config variable
    Canvas.SetDrawColor(MenuColour.B, MenuColour.G, MenuColour.R);

    // Draw menu title
    if (Title != "")
    {
        if (LineText.Length > ITEMS_PER_PAGE)
        {
            Title @= Label_PageNumber;
            Title = Repl(Title, "%X%", MenuPage + 1);
            Title = Repl(Title, "%Y%", string((LineText.Length + ITEMS_PER_PAGE - 1) / ITEMS_PER_PAGE));
        }

        Canvas.SetPos(PosX, PosY);
        Canvas.DrawText(Title);
        PosY += LineHeight * 1.5; // skip half a line
    }

    // Draw the numbered menu options
    for (i = MenuPage * ITEMS_PER_PAGE; i < Min((MenuPage + 1) * ITEMS_PER_PAGE, LineText.Length); ++i)
    {
        if (LineText[i] != "")
        {
            Canvas.SetPos(PosX, PosY);
            Canvas.DrawText(KeyNumber $ "." @ LineText[i]);
            PosY += LineHeight; // next line
        }

        KeyNumber++;
    }

    PosY += LineHeight; // skip a line after menu list, before PgUp/PgDn/Esc options
    Canvas.SetPos(PosX, PosY);

    // Draw text for previous page/menu
    if (MenuPage > 0)
    {
        Canvas.DrawText(Label_PreviousPage);
    }
    else if (PreviousMenu != "")
    {
        Canvas.DrawText(Label_PreviousMenu);
    }
    else
    {
        PosY -= LineHeight; // no line to display, so move the Canvas position back up one line
    }

    // Draw text for next page
    if (LineText.Length > ((MenuPage + 1) * ITEMS_PER_PAGE))
    {
        PosY += LineHeight;
        Canvas.SetPos(PosX, PosY);
        Canvas.DrawText(Label_NextPage);
    }

    // Draw text for exit menu
    PosY += LineHeight * 2.0; // skip a line
    Canvas.SetPos(PosX, PosY);
    Canvas.DrawText(Label_ExitMenu);
}

// Takes the number key pressed & executes a command based on the selection list
function bool HandleInput(int KeyIn, array<string> SelectionList)
{
    local int    SelectionIndex;
    local string CommandString, bDoAdminLogin; // bDoAdminLogin should be bool but needs to be another type so can be passed as out parameter to BuildCommandString

    if (KeyIn < 0 || KeyIn > 9)
    {
        return false;
    }

    SelectionIndex = KeyIn + (MenuPage * ITEMS_PER_PAGE); // adjust for page number

    if (SelectionIndex < SelectionList.Length)
    {
        CommandString = SelectionList[SelectionIndex];

        if (CommandString == "") // stops a blank menu option (especially 0) from executing a meaningless command & exiting the menu
        {
            return true;
        }

        BuildCommandString(CommandString, SelectionIndex, bDoAdminLogin);
        ExecuteCommand(CommandString, bDoAdminLogin); // note ExecuteCommand uses coerce modifier that forces our string bDoAdminLogin to correct bool type

        if (bKeepMenuOpen) // if a function has flagged this as true then don't close the menu (but re-set the flag)
        {
            bKeepMenuOpen = false;
        }
        else
        {
            GotoState('');    // close menu
        }

        return true;
    }

    return false;
}

// Builds a command string for HandleInput function
function BuildCommandString(out string CommandString, out int SelectionIndex, out string bDoAdminLogin) // bDoAdminLogin is really bool but they don't work with 'out' paramenters
{
    if (bTreatSelectionAsOneWord)// if flagged, replace any spaces in selected name (e.g. player, objective or role name) with non-breaking spaces to stop it being split
    {
        CommandString = Repl(CommandString," "," ");
    }

    if (SelectionPrefix != "")
    {
        CommandString = SelectionPrefix @ CommandString;
    }

    // Appending index number of player role or objective avoids problems of server/client mismatch on roles/objective name, due to client running a different language
    if (bUseSelectionIndexAsSuffix)
    {
        if (SelectionIndex == 0) // special handling of index 0 to avoid problems where failed string to int cast (i.e. non-number) in mutator returns misleading index of 0
        {
            SelectionSuffix = "[zero]";
        }
        else
        {
            SelectionSuffix = "[" $ SelectionIndex $ "]"; // wrap index number in brackets just to add readability to on-screen commands
        }
    }

    if (SelectionSuffix != "")
    {
        CommandString @= SelectionSuffix;
    }

    if (Left(CommandString, 1) == "*") // if asterisk prefix, set flag to require admin login & then remove asterisk from string
    {
        bDoAdminLogin = "true";
        CommandString = Mid(CommandString, 1);
    }
}

// Executes console command, logging in 'silently' as a admin first, if necessary
// Note we cannot do admin logout here as the menus leave typing open & the Mutate command won't have been sent yet - instead we log out in the Mutate function
simulated function ExecuteCommand(string CommandString, coerce bool bDoAdminLogin)
{
    if (bDoAdminLogin && !Replicator.bBypassAdminLogin && PC.Level.NetMode != NM_Standalone)
    {
        if (!IsLoggedInAsAdmin())
        {
            // Attempt automatic admin login if we have a user name & password from player's config file, & if player not already logged in
            // We add an identifying prefix to the passed user name, which is used to avoid spammy log entries for silent admin logins from here
            // Also flag that we need to log the player out again afterwards
            // Note: would like to check here if admin login was successful, but bIsAdmin won't have had time to replicate
            if (AdminName != "" && AdminPassword != "")
            {
                PC.AdminLoginSilent(class'DHAccessControl'.static.AdminMenuMutatorLoginPrefix() $ AdminName @ AdminPassword);
                bMenuDidAdminLogin = true;
            }
            else
            {
                ErrorMessageToSelf(1); // must be an admin

                return;
            }
        }

        ConsoleCommand(CommandString);

        if (bDebug)
        {
            Log("DHAdminMenu: auto-login for" @ AdminName $ ", execute console command =" @ CommandString);
        }
    }
    else
    {
        ConsoleCommand(CommandString);

        if (bDebug)
        {
            Log("DHAdminMenu: execute console command =" @ CommandString);
        }
    }
}

// Takes a key press in the form of an EInputKey enum & checks if it is a number key, modifying the passed KeyNumber variable if it is
function bool IsNumberKey(EInputKey Key, out int KeyNumber)
{
    if (Key >= 48 && Key <= 57)
    {
        KeyNumber = Key - 48;

        return true;
    }

    KeyNumber = -1;

    return false;
}

// Does an admin logout but only if the menu automatically logged them in (otherwise leave them logged in, as they were before)
function AdminLogoutIfNecessary()
{
    if (bMenuDidAdminLogin)
    {
        bMenuDidAdminLogin = false;
        PC.AdminLogout();

        if (bDebug)
        {
            Log("DHAdminMenu: automatic admin logout for" @ AdminName);
        }
    }
}

// Toggles admin login if admin credentials are set in their own DarkestHour.ini file
// This isn't used in this mutator package but it's a very useful console command to have bound to one key, just for general admin use
// Note the silent login option won't work properly - it logs in ok, but the toggle then fails on logout & you have to do it manually with the "AdminLogout" command
// This is because PRI's bSilentAdmin bool isn't replicated (unlike bAdmin), so net client can't detect that player is already logged in as silent admin & always tries to log in
exec function AdminLoginToggle(optional bool bSilentLogin)
{
    if (IsLoggedInAsAdmin())
    {
        PC.AdminLogout();
    }
    else
    {
        if (AdminName != "" && AdminPassword != "")
        {
            if (bSilentLogin)
            {
                PC.AdminLoginSilent(AdminName @ AdminPassword);
            }
            else
            {
                PC.AdminLogin(AdminName @ AdminPassword);
            }
        }
        else
        {
            ErrorMessageToSelf(23); // need to set up your admin details in .ini file
        }
    }
}

// Note bSilentAdmin won't work on a net client as bSilentAdmin isn't replicated (unlike bAdmin), so client can't tell that player is logged in
function bool IsLoggedInAsAdmin()
{
    return PC.PlayerReplicationInfo.bAdmin;
}

function ErrorMessageToSelf(byte MessageNumber, optional string InsertedName)
{
    if (MessageNumber > 0)
    {
        PC.ClientMessage(class'DH_AdminMenuMutator.DHAdminMenu_ErrorMessages'.static.AssembleMessage(MessageNumber, InsertedName));
    }
}

// Builds the mutate command for the console on the admin's screen, ready for the admin to type any necessary detail at the end & press return to execute
// Includes info to tell the Mutate function whether or not to log admin out afterwards & also displays a screen prompt/confirmation message to the admin
function BuildMutateCommand(string CommandString, optional int MessageNumber)
{
    local DHConsole Console;

    Console = DHConsole(ViewportOwner.Console);

    if (Console == none)
    {
        return;
    }

    if (CommandString == "")
    {
        AdminLogoutIfNecessary();

        return;
    }

    if (bMenuDidAdminLogin) // if the menu automatically logged in the admin this flag will have been set to true
    {
        bMenuDidAdminLogin = false; // re-set for next time
        Console.SayType = "";
        Console.TypedStr = "Mutate logout" @ CommandString; // adds 1st argument for Mutate function that flags to log the admin out afterwards
    }
    else
    {
        Console.SayType = "";
        Console.TypedStr = "Mutate nologout" @ CommandString; // adds 1st argument for Mutate function that flags NOT to log the admin out afterwards
    }

    Console.TypedStrPos = Len(ViewportOwner.Console.TypedStr);
    Console.TypingOpen();

    if (MessageNumber > 0) // display the relevant prompt/confirmation message across the admin's screen
    {
        PC.ReceiveLocalizedMessage(class'DH_AdminMenuMutator.DHAdminMenu_AdminMessages', MessageNumber);
    }
}

// Using this event to remove each admin menu interaction when the map changes or we leave the server
// Our mutator's Replicator actor creates new menus each map change or when we connect to the server
function NotifyLevelChange()
{
    super.NotifyLevelChange();

    RemoveThisInteraction();
}

// Cleanly removes the admin menu interaction, including setting the actor references to 'none' (apparently have to careful about leaving actor references in a non-actor object)
function RemoveThisInteraction()
{
    Replicator = none;
    PC = none;
    Master.RemoveInteraction(self);
}

defaultproperties
{
    MenuColour=(B=255,G=255,R=255) // default white colour
    MenuPosX=0.01 // default almost on left edge of screen
    MenuPosY=0.25 // default with top of menu one quarter of the way down the screen

    Label_PageNumber="Page %X% of %Y%"
    Label_PreviousMenu="PgUp = previous menu"
    Label_PreviousPage="PgUp = previous page"
    Label_NextPage="PgDn = next page"
    Label_ExitMenu="Esc = exit admin menu"
}
