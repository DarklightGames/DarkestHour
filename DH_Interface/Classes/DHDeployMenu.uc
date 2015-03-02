//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
class DHDeployMenu extends UT2K4GUIPage;

var automated FloatingImage     i_background;

var automated DHGUIComboBox     co_MenuComboBox;
var localized string            MenuOptions[10];

var automated GUITabControl     c_LoadoutArea;
var automated GUITabControl     c_DeploymentMapArea;

var array<string>               DeploymentPanelClass;
var localized array<string>     DeploymentPanelCaption;
var localized array<string>     DeploymentPanelHint;

var array<string>               LoadoutPanelClass;
var localized array<string>     LoadoutPanelCaption;
var localized array<string>     LoadoutPanelHint;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local PlayerController pc;

    Super.InitComponent(MyController, MyOwner);

    // Initialize menu options
    for (i = 0; i < arraycount(MenuOptions); ++i)
    {
        co_MenuComboBox.AddItem(MenuOptions[i]);
    }

    // Lets don't add tabs if owner is a spectator as it might confuse player if they somehow open this menu
    if (PlayerOwner().PlayerReplicationInfo.Team == none)
    {
        // We are spectating, lets not add any tabs
    }
    else
    {
        // Initialize loadout panels
        for (i = 0;i<LoadoutPanelClass.Length;++i)
        {
            c_LoadoutArea.AddTab(LoadoutPanelCaption[i],LoadoutPanelClass[i],,LoadoutPanelHint[i]);
        }

        // Initialize deployment panel(s)
        for (i = 0;i<DeploymentPanelClass.Length;++i)
        {
            c_DeploymentMapArea.AddTab(DeploymentPanelCaption[i],DeploymentPanelClass[i],,DeploymentPanelHint[i]);
        }
    }

    SetTimer(0.1,true);

    // Makes this menu not pause in single-player
    pc = PlayerOwner();
    if (pc != none && pc.Level.Pauser != none)
    {
        pc.SetPause(false);
    }
}

function InternalOnChange(GUIComponent Sender)
{
    if (Sender == co_MenuComboBox)
    {
        switch (co_MenuComboBox.GetIndex())
        {
            // Switch Team
            case 1:
                // Open team select menu
                Controller.ReplaceMenu("DH_Interface.DHGUITeamSelection");
                break;

            // Map Vote
            case 2:
                Controller.OpenMenu(Controller.MapVotingMenu);
                break;

            // Kick Vote
            case 3:
                Controller.OpenMenu(Controller.KickVotingMenu);
                break;

            // Communication
            case 4:
                Controller.OpenMenu("ROInterface.ROCommunicationPage");
                break;

            // Server Browser
            case 5:
                Controller.OpenMenu("DH_Interface.DHServerBrowser");
                break;

            // Options
            case 6:
                Controller.OpenMenu("DH_Interface.DHSettingsPage_new");
                break;

            // Suicide
            case 7:
                PlayerOwner().ConsoleCommand("SUICIDE");
                CloseMenu();
                break;

            // Disconnect
            case 8:
                PlayerOwner().ConsoleCommand("DISCONNECT");
                CloseMenu();
                break;
        }

        co_MenuComboBox.SetIndex(0); // Forces edit area to always show index 0
    }
}

function CloseMenu()
{
    if (Controller != none)
    {
        Controller.RemoveMenu(self);
    }
}

defaultproperties
{
    bRenderWorld=True
    bAllowedAsLast=True
    BackgroundColor=(B=0,G=125,R=0)
    InactiveFadeColor=(B=0,G=0,R=0)
    WinTop=0.0
    WinHeight=1.0

    // Background
    Begin Object Class=FloatingImage Name=FloatingBackground
        Image=texture'DH_GUI_Tex.Menu.MultiMenuBack'
        DropShadow=none
        ImageStyle=ISTY_Scaled
        WinTop=0.0
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=1.0
        RenderWeight=0.000003
    End Object
    i_Background=FloatingImage'DH_Interface.DHDeployMenu.FloatingBackground'

    // Loadout / Role Area
    Begin Object class=GUITabControl Name=LoadoutArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.03
        BackgroundStyleName="DHHeader"
        WinWidth=0.313189
        WinHeight=0.03861
        WinLeft=0.018555
        WinTop=0.052083
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
    End Object
    c_LoadoutArea=GUITabControl'DH_Interface.DHDeployMenu.LoadoutArea'

    // Deployment Area
    Begin Object class=GUITabControl name=DeploymentArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.03
        BackgroundStyleName="DHHeader"
        WinWidth=0.642175
        WinHeight=0.039361
        WinLeft=0.340298
        WinTop=0.050421
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
    End Object
    c_DeploymentMapArea=GUITabControl'DH_Interface.DHDeployMenu.DeploymentArea'

    // Menu Combo Box
    Begin Object Class=DHGUIComboBox Name=MenuOptionsBox
        bReadOnly=true
        WinWidth=0.111653
        WinHeight=0.036836
        WinLeft=0.018159
        WinTop=0.00706
        TabOrder=0
        OnChange=DHDeployMenu.InternalOnChange
        MaxVisibleItems=10
    End Object
    co_MenuComboBox=MenuOptionsBox

    MenuOptions(0)="Menu"
    MenuOptions(1)="Change Team"
    MenuOptions(2)="Map Vote"
    MenuOptions(3)="Kick Vote"
    MenuOptions(4)="Communication"
    MenuOptions(5)="Server Browser"
    MenuOptions(6)="Options"
    MenuOptions(7)="Suicide"
    MenuOptions(8)="Disconnect"

    // Panel Variables
    LoadoutPanelCaption(0)="Role"
    LoadoutPanelCaption(1)="Vehicle"
    LoadoutPanelCaption(2)="Squad"

    LoadoutPanelHint(0)="Choose a role/class to deploy"
    LoadoutPanelHint(1)="Choose a vehicle to deploy"
    LoadoutPanelHint(2)="Create or join a squad"

    LoadoutPanelClass(0)="DH_Interface.DHRoleSelectPanel"
    LoadoutPanelClass(1)="DH_Interface.DHVehicleSelectPanel"
    LoadoutPanelClass(2)=""

    DeploymentPanelClass(0)="DH_Interface.DHDeploymentMapMenu"
    DeploymentPanelCaption(0)="Deployment"
    DeploymentPanelHint(0)="Deploy to the battlefield"
}
