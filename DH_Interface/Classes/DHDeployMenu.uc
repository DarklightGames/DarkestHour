//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHDeployMenu extends UT2K4GUIPage;

var automated       FloatingImage                   i_background;
var automated       GUIButton                       b_Confirm, b_ChangeTeam;
//var automated       GUISlider                       s_AmmoSlider; THIS SHOULD GO IN THE NEW ROLE GUI
var automated       GUIProgressBar                  p_SpawnProgressBar;
var automated       GUITabControl                   c_LoadoutArea;
var automated       GUITabControl                   c_DeploymentMapArea;

var array<string>               DeploymentPanelClass;
var localized array<string>     DeploymentPanelCaption;
var localized array<string>     DeploymentPanelHint;

var array<string>               LoadoutPanelClass;
var localized array<string>     LoadoutPanelCaption;
var localized array<string>     LoadoutPanelHint;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    Super.InitComponent(MyController, MyOwner);

    //Initialize loadout panels

    for(i=0;i<LoadoutPanelClass.Length;++i)
    {
        c_LoadoutArea.AddTab(LoadoutPanelCaption[i],LoadoutPanelClass[i],,LoadoutPanelHint[i]);
    }


    //Initialize deployment panel(s)
    for(i=0;i<DeploymentPanelClass.Length;++i)
    {
        c_DeploymentMapArea.AddTab(DeploymentPanelCaption[i],DeploymentPanelClass[i],,DeploymentPanelHint[i]);
    }

    //function GUITabPanel AddTab(string InCaption, string PanelClass, optional GUITabPanel ExistingPanel, optional string InHint, optional bool bForceActive)
}

function bool OnClick(GUIComponent Sender)
{
    switch(Sender)
    {
        case b_ChangeTeam:
            CloseMenu();
        break;
    }
}

function CloseMenu()
{
    if (Controller != none)
        Controller.RemoveMenu(self);
}

function InternalOnClose(optional bool bCancelled)
{
    local PlayerController pc;

    // Turn pause off if currently paused
    pc = PlayerOwner();
    if (pc != None && pc.Level.Pauser != None)
        pc.SetPause(false);

    Super.OnClose(bCancelled);
}

DefaultProperties
{
    //Menu variables
    bRenderWorld=True
    bAllowedAsLast=True
    BackgroundColor=(B=0,G=125,R=0)
    InactiveFadeColor=(B=0,G=0,R=0)
    OnClose=InternalOnClose
    //OnOpen=InternalOnOpen
    WinTop=0.0
    WinHeight=1.0

    //Components
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

    //LOADOUT AREA
    Begin Object class=GUITabControl Name=LoadoutArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.06
        BackgroundStyleName="DHHeader"
        WinWidth=0.326861
        WinHeight=0.065954
        WinLeft=0.000000
        WinTop=0.053385
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
        //OnActivate=PageTabs.InternalOnActivate
        //OnChange=DHGamePageMP.InternalOnChange
    End Object
    c_LoadoutArea=GUITabControl'DH_Interface.DHDeployMenu.LoadoutArea'

    //DEPLOYMENT MAP AREA
    Begin Object class=GUITabControl name=DeploymentArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.06
        BackgroundStyleName="DHHeader"
        WinWidth=0.656958
        WinHeight=0.944096
        WinLeft=0.330549
        WinTop=0.053025
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
    End Object
    c_DeploymentMapArea=GUITabControl'DH_Interface.DHDeployMenu.DeploymentArea'

    //CONFIRM BUTTON
    Begin Object class=GUIButton Name=ConfirmButton
        CaptionAlign=TXTA_Right
        Caption="Confirm"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=0
        bFocusOnWatch=true
        OnClick=DHDeployMenu.OnClick
        //OnKeyEvent=FixConfigButton.InternalOnKeyEvent
        WinWidth=0.099853
		WinHeight=0.036120
		WinLeft=0.887277
		WinTop=0.955100
    End Object
    b_Confirm=GUIButton'DH_Interface.DHDeployMenu.ConfirmButton'

    //CHANGE TEAM BUTTON
    Begin Object class=GUIButton Name=ChangeTeamButton
        CaptionAlign=TXTA_Center
        Caption="Change Team"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=0
        bFocusOnWatch=true
        OnClick=DHDeployMenu.OnClick
        //OnKeyEvent=FixConfigButton.InternalOnKeyEvent
        WinWidth=0.142500
        WinHeight=0.045573
        WinLeft=0.004297
        WinTop=0.006250
    End Object
    b_ChangeTeam=GUIButton'DH_Interface.DHDeployMenu.ChangeTeamButton'

    //Panel Variables
    LoadoutPanelCaption(0)="Role"
    LoadoutPanelCaption(1)="Vehicle"
    LoadoutPanelCaption(2)="Squad"

    LoadoutPanelHint(0)="Choose a role/class to deploy"
    LoadoutPanelHint(1)="Choose a vehicle to deploy"
    LoadoutPanelHint(2)="Create or join a squad"

    LoadoutPanelClass(0)="DH_Interface.DHRoleSelectPanel"
    LoadoutPanelClass(1)=""
    LoadoutPanelClass(2)=""

    DeploymentPanelClass(0)="DH_Interface.DHDeploymentMapMenu"
    DeploymentPanelCaption(0)="Deployment"
    DeploymentPanelHint(0)="Deploy to the battlefield"
}