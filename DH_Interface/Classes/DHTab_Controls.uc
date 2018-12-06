//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHTab_Controls extends ROTab_Controls;

const CONTROL_PROFILE_AMOUNT = 6;

struct CPKeys
{
    var array<string> Keys;
};

struct CPCmds
{
    var array<string> Cmds;
};

var CPKeys                      ControlProfileKeys[CONTROL_PROFILE_AMOUNT];
var CPCmds                      ControlProfileCommands[CONTROL_PROFILE_AMOUNT];
var localized string            ControlProfiles[CONTROL_PROFILE_AMOUNT];

var     automated moComboBox    co_ControlProfiles;
//var()   ControlProfileBinds     ControlProfileBindings[6];

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

    // If "Current" was selected, do nothing
    if (Index == 0)
    {
        return;
    }

    // Always rebuild & set common controls (defaults)
    if (Controller != none)
    {
        Controller.ResetKeyboard(); // UT/RO defaults (not DH defaults!)

        // Integrity check
        if (ControlProfileKeys[Index].Keys.Length != ControlProfileCommands[Index].Cmds.Length)
        {
            Warn("A control profile doesn't have the same number of keys as commands, exiting control profile setup!!!");
            return;
        }

        // DH Basic Defaults (always apply)
        for (i = 0; i < ControlProfileKeys[0].Keys.Length; ++i)
        {
            Controller.SetKeyBind(ControlProfileKeys[0].Keys[i], ControlProfileCommands[0].Cmds[i]);
        }

        // If this is the RO Classic profile, set it up and then return out
        if (Index == 2)
        {
            MapBindings();
            Initialize();
            return;
        }

        // DH Filled Defaults (always applies unless the RO classic profile was selected)
        for (i = 0; i < ControlProfileKeys[1].Keys.Length; ++i)
        {
            Controller.SetKeyBind(ControlProfileKeys[1].Keys[i], ControlProfileCommands[1].Cmds[i]);
        }

        // Fill out additional profiles if selected
        if (Index > 2)
        {
            for (i = 0; i < ControlProfileKeys[Index].Keys.Length; ++i)
            {
                Controller.SetKeyBind(ControlProfileKeys[Index].Keys[i], ControlProfileCommands[Index].Cmds[i]);
            }
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
    ControlProfiles(2)="RO Classic"
    ControlProfiles(3)="Pro 104"
    ControlProfiles(4)="Pro 105"
    ControlProfiles(5)="XBox 360 Controller"

    bindings_game(4)="ToggleVehicleLock"
    captions_game(4)="Lock/Unlock Armored Vehicle"
    bindings_game(5)="ShowOrderMenu | OnRelease HideOrderMenu"
    captions_game(5)="Squad Orders Menu"
    bindings_game(6)="SquadJoinAuto"
    captions_game(6)="Auto-Join Squad"
    bindings_game(7)="PlaceRallyPoint"
    captions_game(7)="Place Rally Point"

    bindings_weapons(9)="ROMGOperation" // renumbered from here so the new vehicle smoke launcher controls are grouped together at the end of the weapons section
    captions_weapons(9)="Change MG Barrel"
    bindings_weapons(10)="SwitchFireMode"
    captions_weapons(10)="Switch Fire Mode"
    bindings_weapons(11)="Deploy"
    captions_weapons(11)="Deploy MG / Attach Bayonet / Fire Vehicle Smoke Launcher" // added fire smoke launcher to key description
    bindings_weapons(12)="IncreaseSmokeLauncherSetting"
    captions_weapons(12)="Increase Vehicle Smoke Launcher Range/Rotation Setting"
    bindings_weapons(13)="DecreaseSmokeLauncherSetting"
    captions_weapons(13)="Decrease Vehicle Smoke Launcher Range/Rotation Setting"

    bindings_comm(3)="SquadTalk"
    captions_comm(3)="Squad Say"
    bindings_comm(4)="SpeechMenuToggle"
    captions_comm(4)="Voice Command Menu"
    bindings_comm(5)="InGameChat"
    captions_comm(5)="View In-game Chat"
    bindings_comm(6)="VoiceTalk"
    captions_comm(6)="Activate Microphone"
    bindings_comm(7)="Speak Command"
    captions_comm(7)="Switch to Command Voice Channel"
    bindings_comm(8)="Speak Local"
    captions_comm(8)="Switch to Local Voice Channel"
    bindings_comm(9)="Speak Unassigned"
    captions_comm(9)="Switch to Unassigned Voice Channel"
    bindings_comm(10)="Speak Squad"
    captions_comm(10)="Switch to Squad Voice Channel"
    bindings_comm(11)="StartTyping"
    captions_comm(11)="Start typing a chat message"

    Begin Object Class=DHGUIProportionalContainer Name=InputBK1
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption'
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

    // DO NOT EDIT ANYTHING BELOW WITHOUT ASKING

    // Defaults Basic (this always gets applied before every profile)
    ControlProfileKeys(0)=    (Keys=("Tab",        "GreyMinus ",      "F2",          "F3",               "Insert",     "CapsLock",                               "Home",         "End",             "Minus",                       "Equals",                      "Joy4","Joy6","Joy7","Joy8","Joy9","Joy10","Joy11","Joy12"))
    ControlProfileCommands(0)=(Cmds=("ScoreToggle","Menu",            "ShowVoteMenu","CommunicationMenu","Speak Squad","ShowOrderMenu | OnRelease HideOrderMenu","Speak Command","Speak Unassigned","DecreaseSmokeLauncherSetting","IncreaseSmokeLauncherSetting","",    "",    "",    "",    "",    "",     "",     ""))

    // Defaults Filled (this always gets applied EXCEPT for when RO Classic is selected)
    ControlProfileKeys(1)=    (Keys=("T",        "Y",   "U",       "I",          "O",        "P",        "F",             "G",          "H",          "N",     "GreySlash",          "NumPadPeriod",       "NumPad3",            "NumPad9",            "GreyPlus",           "RightMouse",  "MiddleMouse","Enter",      "M","J",               "K","L",                "Comma","Period","LeftBracket","RightBracket","Backslash","Slash",        "Semicolon","SingleQuote","BackSpace","PageUp","PageDown","Up","Down","Left","Right","ScrollLock","JOY1","JOY2","JOY3","JOY5","JOY13","JOY14","JOY15","JOY16","F24"))
    ControlProfileCommands(1)=(Cmds=("VoiceTalk","Talk","TeamTalk","VehicleTalk","SquadTalk","SquadMenu","ShowObjectives","ThrowWeapon","ThrowMGAmmo","Deploy","speech VEH_ORDERS 0","speech VEH_ORDERS 7","speech VEH_ORDERS 6","speech VEH_ORDERS 9","speech VEH_ALERTS 9","ROIronSights","AltFire",    "StartTyping","", "PlaceRallyPoint", "", "ToggleVehicleLock","",     "",      "",           "",            "",         "SquadJoinAuto","",         "",           "",         "",      "",        "",  "",    "",    "",     "",          "",    "",    "",    "",    "",     "",     "",     "",     ""))

    // RO Classic
    ControlProfileKeys(2)=    (Keys=())
    ControlProfileCommands(2)=(Cmds=())

    // Pro 104
    ControlProfileKeys(3)=    (Keys=("V",  "Z",    "B",                     "N",             "J",               "K",         "L",           "Semicolon",   "SingleQuote",   "Ctrl",            "Alt",                                    "Backslash",     "MouseX",                               "MouseY",                               "CapsLock","F",             "Backspace",        "Y",                  "U",       "I",          "O"))
    ControlProfileCommands(3)=(Cmds=("Use","Prone","ROMGOperation | Deploy","speech ALERT 0","speech SUPPORT 2","teamsay np","speech ACK 3","speech ACK 2","speech ALERT 3","SpeechMenuToggle","ShowOrderMenu | OnRelease HideOrderMenu","speech ALERT 2","Count bXAxis | Axis aMouseX Speed=1.0","Count bYAxis | Axis aMouseY Speed=1.0","Walking", "ShowObjectives","ToggleVehicleLock","PlaceRallyPoint",    "",        "",           ""))
    //Description:                                  Change Barrel or Deploy   Yell Grenade!    Ask For Ammo!     Forgive TK!   Say Sorry!     Say Thanks!    Yell Stop!                                                                   Yell Take Cover!

    // Pro 105
    ControlProfileKeys(4)=    (Keys=("Z",         "BackSlash","Alt","Ctrl",   "X",          "C",  "B",      "N",             "M",            "F",        "G",             "H",          "T",   "Y",       "U",        "I",          "O",             "L",             "Semicolon",     "Comma",         "Period",        "F1",    "MiddleMouse"))
    ControlProfileCommands(4)=(Cmds=("ToggleDuck","Prone",    "",   "Walking","ThrowMGAmmo","Use","AltFire","SwitchFireMode","ROMGOperation","VoiceTalk","ShowObjectives","ThrowWeapon","Talk","TeamTalk","SquadTalk","VehicleTalk","speech ORDER 2","speech ORDER 6","speech ORDER 7","speech ORDER 4","speech ALERT 7","Deploy",""))
    //Description:                                                                                                                                                                                                                  Hold Position!   Open Fire!       Cease Fire!      Attack/Move!     Friendly Fire!

    // XBox 360 Controller
    ControlProfileKeys(5)=    (Keys=("Joy1","Joy2",       "Joy3",          "Joy4",      "Joy5","Joy6",        "Joy7",      "Joy8",          "Joy9",          "Joy10",  "Joy11","Joy12","Joy13",    "Joy14",     "Joy15","Joy16",                                                "JoyX",                                     "JoyY",                                              "JoyZ",                        "JoyR",                                    "JoyU",                                               "JoyV","JoySlider1","JoySlider2"))
    ControlProfileCommands(5)=(Cmds=("Use", "ThrowWeapon","ROManualReload","NextWeapon","Jump","ROIronSights","ShowScores","ShowObjectives","Button bSprint","AltFire","",     "",     "VoiceTalk","ToggleDuck","Prone","ThrowMGAmmo | ROMGOperation | Deploy | SwitchFireMode","Axis aStrafe SpeedBase=300.0 DeadZone=0.1","Axis aBaseY SpeedBase=300.0 DeadZone=0.1 Invert=-1","Axis aBaseFire DeadZone=0.25","Axis aBaseX SpeedBase=50.0 DeadZone=0.25","Axis aLookUp SpeedBase=50.0 DeadZone=0.25 Invert=-1","",    "",          ""))
    //Description:                   A      B             X                Y            L Bmpr R Bmpr         Back         Start            LS Down          RS Down                   D-UP        D-Right      D-Down  D-Left
}
