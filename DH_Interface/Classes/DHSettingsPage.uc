// *************************************************************************
//
//	***   DHSettingsPage   ***
//
// *************************************************************************

class DHSettingsPage extends UT2K4SettingsPage;

var Automated GUIButton b_Back;
var Automated GUIButton b_Apply, b_Reset;

var() config bool                 bApplyImmediately;  // Whether to apply changes to setting immediately
var UT2K4Tab_GameSettings       tp_Game;

var() editconst noexport float               SavedPitch;
var() string PageCaption;
var() GUIButton SizingButton;
var() Settings_Tabs ActivePanel;
var localized string InvalidStats;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    	local rotator PlayerRot;
    	local int i;

    	Super.InitComponent(MyController, MyOwner);
    	PageCaption = t_Header.Caption;

    	GetSizingButton();

    	PlayerRot = PlayerOwner().Rotation;
    	SavedPitch = PlayerRot.Pitch;
    	PlayerRot.Pitch = 0;
    	PlayerRot.Roll = 0;
    	PlayerOwner().SetRotation(PlayerRot);

	for ( i = 0; i < PanelCaption.Length && i < PanelClass.Length && i < PanelHint.Length; i++ )
	{
		Profile("Settings_" $ PanelCaption[i]);
		c_Tabs.AddTab(PanelCaption[i], PanelClass[i],, PanelHint[i]);
		Profile("Settings_" $ PanelCaption[i]);
	}
    	tp_Game = UT2K4Tab_GameSettings(c_Tabs.BorrowPanel(PanelCaption[3]));
}

function GetSizingButton()
{
    	local int i;
    	SizingButton = None;
    	for (i = 0; i < Components.Length; i++)
    	{
        		if (GUIButton(Components[i]) == None)
            			continue;

        		if ( SizingButton == None || Len(GUIButton(Components[i]).Caption) > Len(SizingButton.Caption))
            			SizingButton = GUIButton(Components[i]);
    	}
}

function bool InternalOnPreDraw(Canvas Canvas)
{
    	local int X, i;
    	local float XL,YL;

    	if (SizingButton == None)
        		return false;

    	SizingButton.Style.TextSize(Canvas, SizingButton.MenuState, SizingButton.Caption, XL, YL, SizingButton.FontScale);

    	XL += 32;
    	X = Canvas.ClipX - XL;
    	for (i = Components.Length - 1; i >= 0; i--)
    	{
       	 	if (GUIButton(Components[i]) == None)
            			continue;
        			Components[i].WinWidth = XL;
        			Components[i].WinLeft = X;
        			X -= XL;
    	}
    	return false;
}

function bool InternalOnCanClose(optional bool bCanceled)
{
    return true;
}

function InternalOnClose(optional Bool bCanceled)
{
    	local rotator NewRot;
    	NewRot = PlayerOwner().Rotation;
    	NewRot.Pitch = SavedPitch;
    	PlayerOwner().SetRotation(NewRot);
    	Super.OnClose(bCanceled);
}

function InternalOnChange(GUIComponent Sender)
{
	Super.InternalOnChange(Sender);

	if ( c_Tabs.ActiveTab == None )
		ActivePanel = None;
	else ActivePanel = Settings_Tabs(c_Tabs.ActiveTab.MyPanel);
}

function BackButtonClicked()
{
	if ( InternalOnCanClose(False) )
	{
    		c_Tabs.ActiveTab.OnDeActivate();
        		Controller.CloseMenu(False);
    	}
}


function DefaultsButtonClicked()
{
	ActivePanel.ResetClicked();
}

function bool ButtonClicked(GUIComponent Sender)
{
    	ActivePanel.AcceptClicked();
    	return true;
}

event bool NotifyLevelChange()
{
	bPersistent = false;
	LevelChanged();
	return true;
}

defaultproperties
{
     Begin Object Class=DHGUITabControl Name=SettingTabs
         bFillSpace=False
         bDockPanels=True
         TabHeight=0.060000
         BackgroundStyleName="DHHeader"
         WinHeight=0.044000
         RenderWeight=0.490000
         TabOrder=3
         bAcceptsInput=True
         OnActivate=SettingTabs.InternalOnActivate
         OnChange=DHSettingsPage.InternalOnChange
     End Object
     c_Tabs=DHGUITabControl'DH_Interface.DHSettingsPage.SettingTabs'

     Begin Object Class=DHGUIHeader Name=SettingHeader
         Caption="Settings"
         StyleName="DHTopper"
         WinHeight=32.000000
         RenderWeight=0.300000
     End Object
     t_Header=DHGUIHeader'DH_Interface.DHSettingsPage.SettingHeader'

     Begin Object Class=DHSettings_Footer Name=SettingFooter
         Spacer=0.010000
         StyleName="DHFooter"
         WinTop=0.950000
         WinHeight=0.045000
         RenderWeight=0.300000
         TabOrder=4
         OnPreDraw=SettingFooter.InternalOnPreDraw
     End Object
     t_Footer=DHSettings_Footer'DH_Interface.DHSettingsPage.SettingFooter'

     PanelClass(0)="DH_Interface.DHTab_GameSettings"
     PanelClass(1)="DH_Interface.DHTab_DetailSettings"
     PanelClass(2)="DH_Interface.DHTab_AudioSettings"
     PanelClass(3)="DH_Interface.DHTab_Controls"
     PanelClass(4)="DH_Interface.DHTab_Input"
     PanelClass(5)="DH_Interface.DHTab_Hud"
     PanelClass(6)="none"
     PanelCaption(0)="Game"
     PanelCaption(1)="Display"
     PanelCaption(2)="Audio"
     PanelCaption(3)="Controls"
     PanelCaption(5)="Hud"
     PanelCaption(6)="none"
     PanelHint(0)="Configure your Darkest Hour game..."
     PanelHint(1)="Select your resolution or change your display and detail settings..."
     PanelHint(2)="Adjust your audio experience..."
     PanelHint(3)="Configure your keyboard controls..."
     PanelHint(5)="Customize your HUD..."
     PanelHint(6)="how did you get this?"
     Background=Texture'DH_GUI_Tex.Menu.Setupmenu'
}
