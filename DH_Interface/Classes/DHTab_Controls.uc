//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHTab_Controls extends ROTab_Controls;

struct ControlProfileBinds
{
    var array<string> KeyNames;
    var array<string> KeyValues;
};

var     automated moComboBox    co_ControlProfiles;
var     localized string        ControlProfiles[6];
var()   ControlProfileBinds     ControlProfileBindings[6];

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super.InitComponent(MyController, MyOwner);

    i_BG1.ManageComponent(co_ControlProfiles);

    for (i = 0; i < arraycount(ControlProfiles); ++i)
    {
        co_ControlProfiles.AddItem(ControlProfiles[i]);
    }
}

// Overridden to stop default button from not assigning fixed keys
function ResetClicked()
{
    SetUpProfileControls(1);
}

function InternalOnChange(GUIComponent Sender)
{
    super.InternalOnChange(Sender);

    if (Sender == co_ControlProfiles)
    {
        SetUpProfileControls(co_ControlProfiles.GetIndex());
        co_ControlProfiles.SetIndex(0);
    }
}

function SetUpProfileControls(int Index)
{
    local int i;

    if (Index < 1)
    {
        return;
    }

    // Always rebuild & set common controls (defaults)
    if (Controller != none)
    {
        Controller.ResetKeyboard(); // UT/RO defaults

        // Integrity check
        if (ControlProfileBindings[Index].KeyNames.Length != ControlProfileBindings[Index].KeyValues.Length)
        {
            Warn("A control profile doesn't have the same number of keys to commands and may not work as expected!!!");
        }

        // DH defaults
        for (i = 0; i < ControlProfileBindings[1].KeyNames.Length; ++i)
        {
            Controller.SetKeyBind(ControlProfileBindings[1].KeyNames[i], ControlProfileBindings[1].KeyValues[i]);
        }
    }

    // If profile is not 0 or 1, add in controls
    if (Index > 1)
    {
        for (i = 0; i < ControlProfileBindings[Index].KeyNames.Length; ++i)
        {
            Controller.SetKeyBind(ControlProfileBindings[Index].KeyNames[i], ControlProfileBindings[Index].KeyValues[i]);
        }
    }

    MapBindings();
    Initialize();
}

defaultproperties
{
    SectionStyleName="DHListSection"
    PanelCaption="Controls"

    ControlProfiles(0)="Current"
    ControlProfiles(1)="Defaults (Reset)"
    ControlProfiles(2)="Contemporary"
    ControlProfiles(3)="Recommended"

    bindings_game(4)="ToggleVehicleLock"
    captions_game(4)="Lock/Unlock Armored Vehicle"

    captions_weapons(9)="Deploy MG / Attach Bayonet / Fire Vehicle Smoke Launcher" // added fire smoke launcher to key description

    bindings_comm(3)="SquadTalk" // inserted
    captions_comm(3)="Squad Say"
    bindings_comm(4)="SpeechMenuToggle"
    captions_comm(4)="Voice Command Menu"
    bindings_comm(5)="InGameChat"
    captions_comm(5)="View In-game Chat"
    bindings_comm(6)="VoiceTalk"
    captions_comm(6)="Activate Microphone"
    bindings_comm(7)="Speak Command" // replaces "Speak Public" ("Switch to Public Voice Channel")
    captions_comm(7)="Switch to Command Voice Channel"
    bindings_comm(8)="Speak Local"
    captions_comm(8)="Switch to Local Voice Channel"
    bindings_comm(9)="Speak Unassigned"  // effectively replaces "Speak Team" ("Switch to Team Voice Channel")?
    captions_comm(9)="Switch to Unassigned Voice Channel"
    bindings_comm(10)="Speak Squad" // added
    captions_comm(10)="Switch to Squad Voice Channel"

    captions_interface(3)="Increase HUD Size / Vehicle Smoke Launcher Setting" // added adjust smoke launcher to key descriptions
    captions_interface(4)="Decrease HUD Size / Vehicle Smoke Launcher Setting"
    bindings_interface(5)="ShowOrderMenu | OnRelease HideOrderMenu"
    captions_interface(5)="Squad Orders Menu"

    Begin Object Class=DHGUIProportionalContainer Name=InputBK1
        HeaderBase=texture'DH_GUI_Tex.Menu.DHDisplay_withcaption'
        Caption="Bindings"
        LeftPadding=0.0
        RightPadding=0.0
        TopPadding=0.0
        BottomPadding=0.0
        ImageOffset(2)=10.0
        WinTop=0.004
        WinLeft=0.021641
        WinWidth=0.956718
        WinHeight=0.958
        OnPreDraw=InputBK1.InternalPreDraw
    End Object
    i_BG1=DHGUIProportionalContainer'DH_Interface.DHTab_Controls.InputBK1'

    Begin Object Class=GUILabel Name=HintLabel
        TextAlign=TXTA_Center
        bMultiLine=true
        VertAlign=TXTA_Center
        FontScale=FNS_Small
        StyleName="DHSmallText"
        WinTop=0.95
        WinHeight=0.05
        bBoundToParent=true
        bScaleToParent=true
    End Object
    l_Hint=GUILabel'DH_Interface.DHTab_Controls.HintLabel'

    Begin Object Class=DHGUIMultiColumnListBox Name=BindListBox
        HeaderColumnPerc(0)=0.5
        HeaderColumnPerc(1)=0.25
        HeaderColumnPerc(2)=0.25
        SelectedStyleName="DHListSelectionStyle"
        OnCreateComponent=DHTab_Controls.InternalOnCreateComponent
        StyleName="DHNoBox"
        WinTop=0.05
        WinHeight=0.9
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
    End Object
    lb_Binds=DHGUIMultiColumnListBox'DH_Interface.DHTab_Controls.BindListBox'

    Begin Object Class=DHmoComboBox Name=ControlProfilesComboBox
        bReadOnly=true
        ComponentJustification=TXTA_Left
        Caption="Control Profiles"
        OnCreateComponent=ControlProfilesComboBox.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.0
        WinLeft=0.01
        WinWidth=0.6
        ComponentWidth=0.4
        CaptionWidth=0.2
        OnChange=DHTab_Controls.InternalOnChange
    End Object
    co_ControlProfiles=DHmoComboBox'DH_Interface.DHTab_Controls.ControlProfilesComboBox'

    //******************
    // Profile Bindings
    //******************

    // Default (with extra DH standard keys) - this always gets applied before another profile // Matt: want to add'L' key for lock/unlock tank, but currently clashes with recommended profile
//  ControlProfileBindings(1)=(KeyNames=("Tab","GreyMinus","F2","F3","Minus","Equals","I","Insert","CapsLock","Home","End","L"),KeyValues=("ScoreToggle","CommunicationMenu","ShowVoteMenu","CommunicationMenu","ShrinkHUD","GrowHUD","SquadTalk","Speak Squad","ShowOrderMenu | OnRelease HideOrderMenu","Speak Command","Speak Unassigned","ToggleVehicleLock"))
    ControlProfileBindings(1)=(KeyNames=("Tab","GreyMinus","F2","F3","Minus","Equals","I","Insert","CapsLock","Home","End"),KeyValues=("ScoreToggle","CommunicationMenu","ShowVoteMenu","CommunicationMenu","ShrinkHUD","GrowHUD","SquadTalk","Speak Squad","ShowOrderMenu | OnRelease HideOrderMenu","Speak Command","Speak Unassigned"))

    // Contemporary
    ControlProfileBindings(2)=(KeyNames=("F","Z","V","RightMouse","MiddleMouse"),KeyValues=("Use","Prone","Deploy","ROIronSights","AltFire"))

    // Recommended
    ControlProfileBindings(3)=(KeyNames=("V","Z","G","H","T","Y","U","O","P","N","M","J","K","L","Semicolon","SingleQuote","RightMouse","MiddleMouse","Ctrl","Alt","Comma","Period","Backslash","Slash","Backspace","MouseX","MouseY","LeftBracket","RightBracket","ScrollLock"),KeyValues=("Use","Prone","ThrowWeapon","ThrowMGAmmo","VoiceTalk","Talk","TeamTalk","VehicleTalk","SquadMenu","speech ALERT 0","ShowObjectives","speech SUPPORT 2","teamsay np","speech ACK 3","speech ACK 2","speech ALERT 3","ROIronSights","AltFire","SpeechMenuToggle","Walking","","","speech ALERT 2","","","Count bXAxis | Axis aMouseX Speed=1.0","Count bYAxis | Axis aMouseY Speed=1.0","","",""))
}
