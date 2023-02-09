//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSettingsPage extends UT2K4SettingsPage;

// Modified to avoid "failed to load NULL" log errors
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local rotator PlayerRot;
    local int     i;

    super(UT2K4MainPage).InitComponent(MyController, MyOwner); // skip over Super in UT2K4SettingsPage as we're re-stating it here

    PageCaption = t_Header.Caption;

    GetSizingButton();

    PlayerRot = PlayerOwner().Rotation;
    SavedPitch = PlayerRot.Pitch;
    PlayerRot.Pitch = 0;
    PlayerRot.Roll = 0;
    PlayerOwner().SetRotation(PlayerRot);

    for (i = 0; i < PanelCaption.Length && i < PanelClass.Length && i < PanelHint.Length; ++i)
    {
        if (PanelClass[i] != "") // added to avoid log errors by trying to load null class (where a PanelClass entry is set to "" in default properties to empty it)
        {
            Profile("Settings_" $ PanelCaption[i]);
            c_Tabs.AddTab(PanelCaption[i], PanelClass[i],, PanelHint[i]);
            Profile("Settings_" $ PanelCaption[i]);
        }
    }

    tp_Game = UT2K4Tab_GameSettings(c_Tabs.BorrowPanel(PanelCaption[3]));
}

// From deprecated ROSettingsPage class
function bool InternalOnCanClose(optional bool bCanceled)
{
    return true;
}

// Modified to add save config
function BackButtonClicked()
{
    if (InternalOnCanClose(false))
    {
        SaveConfig(); // added in DH
        c_Tabs.ActiveTab.OnDeActivate();
        Controller.CloseMenu(false);
    }
}

defaultproperties
{
    Background=Texture'DH_GUI_Tex.Menu.Setupmenu'

    PanelCaption(0)="Game"
    PanelCaption(1)="Display"
    PanelCaption(2)="Audio"
    PanelCaption(3)="Controls"
    PanelCaption(4)="Input"
    PanelCaption(5)="HUD"
    PanelCaption(6)=""

    PanelClass(0)="DH_Interface.DHTab_GameSettings"
    PanelClass(1)="DH_Interface.DHTab_DetailSettings"
    PanelClass(2)="DH_Interface.DHTab_AudioSettings"
    PanelClass(3)="DH_Interface.DHTab_Controls"
    PanelClass(4)="DH_Interface.DHTab_Input"
    PanelClass(5)="DH_Interface.DHTab_Hud"
    PanelClass(6)=""

    PanelHint(0)="Configure game and network related settings..."
    PanelHint(1)="Select your resolution or change your display and detail settings..."
    PanelHint(2)="Adjust your audio experience..."
    PanelHint(3)="Configure your keyboard and mouse controls..."
    PanelHint(4)="Configure misc. input options..."
    PanelHint(5)="Customize your HUD..."
    PanelHint(6)="how did you get this?"

    Begin Object Class=DHGUITabControl Name=SettingTabs
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.06
        BackgroundStyleName="DHHeader"
        WinHeight=0.044
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
        OnActivate=SettingTabs.InternalOnActivate
        OnChange=DHSettingsPage.InternalOnChange
    End Object
    c_Tabs=DHGUITabControl'DH_Interface.DHSettingsPage.SettingTabs'

    Begin Object Class=DHGUIHeader Name=SettingHeader
        Caption="Settings"
        StyleName="DHTopper"
        WinHeight=32.0
        RenderWeight=0.3
    End Object
    t_Header=DHGUIHeader'DH_Interface.DHSettingsPage.SettingHeader'

    Begin Object Class=DHSettings_Footer Name=SettingFooter
        Spacer=0.01
        StyleName="DHFooter"
        RenderWeight=0.3
        TabOrder=4
        OnPreDraw=SettingFooter.InternalOnPreDraw
    End Object
    t_Footer=DHSettings_Footer'DH_Interface.DHSettingsPage.SettingFooter'
}
