//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIController extends UT2K4GUIController;

// Holds the name of all styles to use
var     array<string>   RODefaultStyleNames;

event InitializeController()
{
    super.InitializeController();

    RegisterStyle(class'ROInterface.ROSTY2_ImageButton');
    RegisterStyle(class'ROInterface.ROSTY2SelectButton');
    RegisterStyle(class'ROInterface.ROSTY2SelectTab');
    RegisterStyle(class'ROInterface.ROSTY_CaptionLabel');

    LastGameType = "DH_Engine.DarkestHourGame";
}

function bool ShouldSkipResetInput()
{
    local DHPlayer PC;

    if (ViewportOwner == none || ViewportOwner.Actor == none)
    {
        return false;
    }

    PC = DHPlayer(ViewportOwner.Actor);

    return PC != none && PC.bShouldSkipResetInput;
}

// Modified to skip input reset step if specified.
function SetControllerStatus(bool On)
{
    local bool bWasActive;

    if (bActive && !On && ViewportOwner != none && ViewportOwner.Actor != none && !ShouldSkipResetInput())
    {
        ViewportOwner.Actor.UnpressButtons();
    }

    bWasActive = bActive;
    bActive = On;
    bVisible = On;
    bRequiresTick = On;

    if (bActive && !bWasActive && ViewportOwner != none && ViewportOwner.Actor != none && !ShouldSkipResetInput())
    {
        ViewportOwner.Actor.UnpressButtons();
    }

    ViewportOwner.bShowWindowsMouse = On && ViewportOwner.bWindowsMouseAvailable;

    if (On)
    {
        bIgnoreUntilPress = true;
    }
    else
    {
//        ResetDesigner();
//        ViewportOwner.Actor.ConsoleCommand("toggleime 0");
    }

    PurgeComponentClasses();
}

// Modified to skip input reset step if specified.
protected event PushMenu(int Index, GUIPage NewMenu, optional string Param1, optional string Param2)
{
    if (NewMenu == none)
    {
        Log("Call to GUIController.PushMenu() with invalid NewMenu");
        return;
    }

    SetControllerStatus(true);

    if (Index >= 0)
    {
        MenuStack[Index] = NewMenu;
        ActivePage = NewMenu;
    }

    CloseOverlays();

    if (!ShouldSkipResetInput())
    {
        ResetInput();
    }

    if (NewMenu.Controller == none)
    {
        NewMenu.InitComponent(self, none);
    }

    NewMenu.CheckResolution(false, self);

    // Pass along the event
    NewMenu.Opened(NewMenu);
    NewMenu.MenuState = MSAT_Focused;
    NewMenu.PlayOpenSound();

    bCurMenuInitialized = true;

    NewMenu.HandleParameters(Param1, Param2);

    bForceMouseCheck = true;

    NewMenu.OnOpen();
}

// Modified to skip input reset step if specified.
event bool RemoveMenu(GUIPage Menu, optional bool bCancelled)
{
    if (MenuStack.Length == 0)
    {
        Log("GUIController.RemoveMenu() - Attempting to close a non-existing menu page");
        return false;
    }

    if (Menu == none || Menu == ActivePage)
    {
        return CloseMenu(bCancelled);
    }

    if (bModAuthor)
    {
        Log(Class @ "RemoveMenu [" $ Menu.Name $ "]", 'ModAuthor');
    }

    if (!bCurMenuInitialized)
    {
        if (bModAuthor)
        {
            Log("Cannot remove menu until initialization is complete!", 'ModAuthor');
        }

        return false;
    }

    if (!Menu.OnCanClose(bCancelled))
    {
        return false;
    }

    if (!ShouldSkipResetInput())
    {
        ResetInput();
    }

    Menu.PlayCloseSound();

    PopMenu(FindMenuIndex(Menu), Menu, bCancelled);

    // Gab the next page on the stack
    if (MenuStack.Length == 0)
    {
        // Pass control back to the previous menu
        if (!Menu.bAllowedAsLast && !MainNotWanted)
        {
            return OpenMenu(GetMainMenuClass());
        }

        ActivePage = none;
        SetControllerStatus(false);
    }

    VerifyStack();
    bForceMouseCheck = true;
    return true;
}

// Close the top menu.  returns true if success.
event bool CloseMenu(optional bool bCancelled)
{
    if (MenuStack.Length == 0 || ActivePage == none)
    {
        Log("Attempting to close a non-existing menu page");
        return false;
    }

    if (bModAuthor)
    {
        Log(Class @ "CloseMenu [" $ ActivePage.Name $ "]", 'ModAuthor');
    }

    if (!bCurMenuInitialized)
    {
        if (bModAuthor)
        {
            Log("Cannot close menu until initialization is complete!", 'ModAuthor');
        }

        return false;
    }

    if (!ActivePage.OnCanClose(bCancelled))
    {
        return false;
    }

    if (!ShouldSkipResetInput())
    {
        ResetInput();
    }

    ActivePage.PlayCloseSound();       // Play the closing sound

    PopMenu(FindMenuIndex(ActivePage), ActivePage, bCancelled);

    ActivePage.CheckResolution(true, self);

    // Gab the next page on the stack
    bCurMenuInitialized = false;

    if (MenuStack.Length > 0)
    {
        // Pass control back to the previous menu
        ActivePage = MenuStack[MenuStack.Length - 1];
        ActivePage.MenuState = MSAT_Focused;

        ResetFocus();
        ActivePage.FocusFirst(none);

        if (!ActivePage.bNeverFocus)
        {
            ActivePage.OnActivate();
        }
    }
    else
    {
        if (!ActivePage.bAllowedAsLast && !MainNotWanted)
        {
            ActivePage = none;
            return OpenMenu(GetMainMenuClass());
        }

        ActivePage = none;
        SetControllerStatus(false);
    }

    bCurMenuInitialized = true;

    if (ActivePage != none)
    {
        ActivePage.OnReopen();
    }

    bForceMouseCheck = true;

    return true;
}

function PurgeObjectReferences() { }

simulated static event Validate()
{
    if (default.MainMenuOptions.Length < 5)
    {
        ResetConfig();
    }
}

simulated static function string GetServerBrowserPage()
{
    Validate();
    return default.MainMenuOptions[0];
}

simulated static function string GetMultiplayerPage()
{
    Validate();

    return default.MainMenuOptions[1];
}

simulated static function string GetInstantActionPage()
{
    Validate();

    return default.MainMenuOptions[2];
}

simulated static function string GetSettingsPage()
{
    Validate();

    return default.MainMenuOptions[3];
}

simulated static function string GetQuitPage()
{
    Validate();

    return default.MainMenuOptions[4];
}

defaultproperties
{
    FONT_NUM=15
    FontStack(0)=fntUT2k4Menu'ROInterface.ROGUIController.GUIMenuFont'
    FontStack(1)=fntUT2k4Default'ROInterface.ROGUIController.GUIDefaultFont'
    FontStack(2)=fntUT2k4Large'ROInterface.ROGUIController.GUILargeFont'
    FontStack(3)=fntUT2k4Header'ROInterface.ROGUIController.GUIHeaderFont'
    FontStack(4)=fntUT2k4Small'ROInterface.ROGUIController.GUISmallFont'
    FontStack(5)=fntUT2k4MidGame'ROInterface.ROGUIController.GUIMidGameFont'
    FontStack(6)=fntUT2k4SmallHeader'ROInterface.ROGUIController.GUISmallHeaderFont'
    FontStack(7)=fntUT2k4ServerList'ROInterface.ROGUIController.GUIServerListFont'
    FontStack(8)=fntUT2k4IRC'ROInterface.ROGUIController.GUIIRCFont'
    FontStack(9)=fntROMainMenu'ROInterface.ROGUIController.GUIMainMenuFont'
    FontStack(10)=fntUT2K4Medium'ROInterface.ROGUIController.GUIMediumMenuFont'
    Begin Object Class=DHMenuFont Name=fntDHMenuFont
    End Object
    FontStack(11)=fntDHMenuFont
    Begin Object Class=DHSmallFont Name=fntDHSmallFont
    End Object
    FontStack(12)=fntDHSmallFont
    Begin Object Class=DHLargeFont Name=fntDHLargeFont
    End Object
    FontStack(13)=fntDHLargeFont
    Begin Object Class=DHButtonFont Name=fntDHButtonFont
    End Object
    FontStack(14)=fntDHButtonFont
    Begin Object class=DHHugeButtonFont Name=fntDHHugeButtonFont
    End Object
    FontStack(15)=fntDHHugeButtonFont
    MouseCursors(0)=Texture'DH_GUI_Tex.Menu.DHPointer'
    MouseCursors(1)=Texture'InterfaceArt_tex.Cursors.ResizeAll'
    MouseCursors(2)=Texture'InterfaceArt_tex.Cursors.ResizeSWNE'
    MouseCursors(3)=Texture'InterfaceArt_tex.Cursors.Resize'
    MouseCursors(4)=Texture'InterfaceArt_tex.Cursors.ResizeNWSE'
    MouseCursors(5)=Texture'InterfaceArt_tex.Cursors.ResizeHorz'
    MouseCursors(6)=Texture'DH_GUI_Tex.Menu.DHPointer'
    ImageList(0)=Texture'InterfaceArt_tex.Menu.checkBoxBall_b'
    ImageList(1)=Texture'InterfaceArt_tex.Menu.AltComboTickBlurry'
    ImageList(2)=Texture'InterfaceArt_tex.Menu.LeftMark'
    ImageList(3)=Texture'InterfaceArt_tex.Menu.RightMark'
    ImageList(4)=Texture'InterfaceArt_tex.Menu.RightMark'
    ImageList(5)=Texture'InterfaceArt_tex.Menu.RightMark'
    ImageList(6)=Texture'InterfaceArt_tex.Menu.UpMark'
    ImageList(7)=Texture'InterfaceArt_tex.Menu.DownMark'
    DefaultStyleNames(0)="ROInterface.ROSTY2CloseButton"
    DefaultStyleNames(1)="ROInterface.ROSTY_RoundScaledButton"
    DefaultStyleNames(2)="ROInterface.ROSTY2SquareButton"
    DefaultStyleNames(3)="ROInterface.ROSTY_ListBox"
    DefaultStyleNames(4)="ROInterface.ROSTY2ScrollZone"
    DefaultStyleNames(5)="ROInterface.ROSTY2TextButton"
    DefaultStyleNames(7)="ROInterface.ROSTY2Header"
    DefaultStyleNames(8)="ROInterface.ROSTY_Footer"
    DefaultStyleNames(9)="ROInterface.ROSTY_TabButton"
    DefaultStyleNames(13)="ROInterface.ROSTY_ServerBrowserGrid"
    DefaultStyleNames(15)="ROInterface.ROSTY_ServerBrowserGridHeader"
    DefaultStyleNames(21)="ROInterface.ROSTY_SquareBar"
    DefaultStyleNames(22)="ROInterface.ROSTY_MidGameButton"
    DefaultStyleNames(23)="ROInterface.ROSTY_TextLabel"
    DefaultStyleNames(24)="ROInterface.ROSTY2ComboListBox"
    DefaultStyleNames(26)="ROInterface.ROSTY2IRCText"
    DefaultStyleNames(27)="ROInterface.ROSTY2IRCEntry"
    DefaultStyleNames(29)="ROInterface.ROSTY2ContextMenu"
    DefaultStyleNames(30)="ROInterface.ROSTY2ServerListContextMenu"
    DefaultStyleNames(31)="ROInterface.ROSTY_ListSelection"
    DefaultStyleNames(32)="ROInterface.ROSTY2TabBackground"
    DefaultStyleNames(33)="ROInterface.ROSTY_BrowserListSel"
    DefaultStyleNames(34)="ROInterface.ROSTY2EditBox"
    DefaultStyleNames(35)="ROInterface.ROSTY2CheckBox"
    DefaultStyleNames(37)="ROInterface.ROSTY2SliderKnob"
    DefaultStyleNames(39)="ROInterface.ROSTY2ListSectionHeader"
    DefaultStyleNames(40)="ROInterface.ROSTY2ItemOutline"
    DefaultStyleNames(42)="ROInterface.ROSTY2MouseOverLabel"
    DefaultStyleNames(43)="ROInterface.ROSTY2SliderBar"
    DefaultStyleNames(45)="ROInterface.ROSTY2TextButtonEffect"
    DefaultStyleNames(48)="ROInterface.ROSTY2FooterButton"
    DefaultStyleNames(50)="ROInterface.ROSTY2ComboButton"
    DefaultStyleNames(51)="ROInterface.ROSTY2VertUpButton"
    DefaultStyleNames(52)="ROInterface.ROSTY2VertDownButton"
    DefaultStyleNames(53)="ROInterface.ROSTY2_VertGrip"
    DefaultStyleNames(54)="ROInterface.ROSTY2Spinner"
    DefaultStyleNames(55)="ROInterface.ROSTY2SectionHeaderTop"
    DefaultStyleNames(56)="ROInterface.ROSTY2SectionHeaderBar"
    DefaultStyleNames(57)="DH_Interface.DHStyle_BlackText"
    DefaultStyleNames(58)="DH_Interface.DHStyle_LargeText"
    DefaultStyleNames(59)="DH_Interface.DHStyle_MenuTextButton"
    DefaultStyleNames(60)="DH_Interface.DHStyle_ExitPage"
    DefaultStyleNames(61)="DH_Interface.DHStyle_Topper"
    DefaultStyleNames(62)="DH_Interface.DHStyle_TabTextButton"
    DefaultStyleNames(63)="DH_Interface.DHStyle_ListSelection"
    DefaultStyleNames(64)="DH_Interface.DHStyle_SmallText"
    DefaultStyleNames(65)="DH_Interface.DHStyle_Footer"
    DefaultStyleNames(66)="DH_Interface.DHStyle_Header"
    DefaultStyleNames(67)="DH_Interface.DHStyle_ComboListBox"
    DefaultStyleNames(68)="DH_Interface.DHStyle_EditBox"
    DefaultStyleNames(69)="DH_Interface.DHStyle_GripButton"
    DefaultStyleNames(70)="DH_Interface.DHStyle_Spinner"
    DefaultStyleNames(71)="DH_Interface.DHStyle_NoBox"
    DefaultStyleNames(72)="DH_Interface.DHStyle_SmallTextButton"
    DefaultStyleNames(73)="DH_Interface.DHStyle_MultiColBar"
    DefaultStyleNames(74)="DH_Interface.DHStyle_CloseButton"
    DefaultStyleNames(75)="DH_Interface.DHStyle_ListSection"
    DefaultStyleNames(76)="DH_Interface.DHStyle_LargeBlackText"
    DefaultStyleNames(77)="DH_Interface.DHStyle_GripButtonNB"
    DefaultStyleNames(78)="DH_Interface.DHStyle_ListSelectionBlack"
    DefaultStyleNames(79)="DH_Interface.DHStyle_SpawnButton"
    DefaultStyleNames(80)="DH_Interface.DHStyle_DeployButton"
    DefaultStyleNames(81)="DH_Interface.DHStyle_TabButton"
    DefaultStyleNames(82)="DH_Interface.DHStyle_ListHighlight"
    DefaultStyleNames(83)="DH_Interface.DHStyle_DeployTabButton"
    DefaultStyleNames(84)="DH_Interface.DHStyle_DeployContinueButton"
    DefaultStyleNames(85)="DH_Interface.DHStyle_SpawnVehicleButton"
    DefaultStyleNames(86)="DH_Interface.DHStyle_MenuTextButtonWhite"
    DefaultStyleNames(87)="DH_Interface.DHStyle_MenuTextButtonWhiteHuge"
    DefaultStyleNames(88)="DH_Interface.DHStyle_LargeEditBox"
    DefaultStyleNames(89)="DH_Interface.DHStyle_ServerBrowserGridRed"
    DefaultStyleNames(90)="DH_Interface.DHStyle_RallyPointButton"
    DefaultStyleNames(91)="DH_Interface.DHStyle_MainSpawnButton"
    DefaultStyleNames(92)="DH_Interface.DHStyle_PlatoonHQButton"
    DefaultStyleNames(93)="DH_Interface.DHStyle_ListLargeHighlight"
    DefaultStyleNames(94)="DH_Interface.DHStyle_ParatroopersButton"
    DefaultStyleNames(95)="DH_Interface.DHStyle_ListSelectionGrey"
    DefaultStyleNames(96)="DH_Interface.DHStyle_ObjectiveSpawnButton"
    RequestDataMenu="DH_Interface.DHGetDataMenu"
    DynArrayPropertyMenu="DH_Interface.DHGUIDynArrayPage"
    FilterMenu="DH_Interface.DHFilterListPage"
    MapVotingMenu="DH_Interface.DHMapVotingPage"
    EditFavoriteMenu="DH_Interface.DHEditFavoritePage"
    NetworkMsgMenu="DH_Interface.DHNetworkStatusMsg"
    MainMenuOptions(0)="DH_Interface.DHServerBrowser"
    MainMenuOptions(1)="DH_Interface.DHGamePageMP"
    MainMenuOptions(2)="DH_Interface.DHGamePageSP"
    MainMenuOptions(3)="DH_Interface.DHSettingsPage"
    MainMenuOptions(4)="DH_Interface.DHQuitPage"
    LCDLogo=Texture'DH_G15LCD.Logos.DH_BWLogoRGB8A'
}
