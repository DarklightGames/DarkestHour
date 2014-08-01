// *************************************************************************
//
//	***   DHGUIController   ***
//
// *************************************************************************

class DHGUIController extends UT2K4GUIController;

var Array<string>       RODefaultStyleNames;      // Holds the name of all styles to use

event InitializeController()
{
    	Super.InitializeController();

    	RegisterStyle(class'ROInterface.ROSTY2_ImageButton');
    	RegisterStyle(class'ROInterface.ROSTY2SelectButton');
    	RegisterStyle(class'ROInterface.ROSTY2SelectTab');
    	RegisterStyle(class'ROInterface.ROSTY_CaptionLabel');

	LastGameType="DH_Engine.DarkestHourGame";
	log("DHGUIController initialized ");
}


function PurgeObjectReferences()
{
}


static simulated event Validate()
{
	if (default.MainMenuOptions.Length < 5)
		ResetConfig();
}

static simulated function string GetServerBrowserPage()
{
	Validate();
	return default.MainMenuOptions[0];
}

static simulated function string GetMultiplayerPage()
{
	Validate();
	return default.MainMenuOptions[1];
}

static simulated function string GetInstantActionPage()
{
	Validate();
	return default.MainMenuOptions[2];
}

static simulated function string GetSettingsPage()
{
	Validate();
	return default.MainMenuOptions[3];
}

static simulated function string GetQuitPage()
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
     RequestDataMenu="DH_Interface.DHGetDataMenu"
     DynArrayPropertyMenu="DH_Interface.DHGUIDynArrayPage"
     FilterMenu="DH_Interface.DHFilterListPage"
     MapVotingMenu="DH_Interface.DHMapVotingPage"
     EditFavoriteMenu="DH_Interface.DHEditFavoritePage"
     MainMenuOptions(0)="DH_Interface.DHServerBrowser"
     MainMenuOptions(1)="DH_Interface.DHGamePageMP"
     MainMenuOptions(2)="DH_Interface.DHGamePageSP"
     MainMenuOptions(3)="DH_Interface.DHSettingsPage"
     MainMenuOptions(4)="DH_Interface.DHQuitPage"
     LCDLogo=Texture'DH_G15LCD.Logos.DH_BWLogoRGB8A'
}
