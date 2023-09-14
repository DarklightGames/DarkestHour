//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

enum ECategoryIDs
{
    CID_Movement,
    CID_Looking,
    CID_Weapons,
    CID_Inventory,
    CID_Comm,
    CID_Game,
    CID_Misc,
    CID_Interface
};

var localized string            Section_Inventory;
var array<string>               Bindings_Inventory;
var localized string            Captions_Inventory[15];

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

// Overriden to add additional DH command categories
function LoadCommands()
{
    local array<string> VoiceCommands;
    local int i;

    ClearBindings();

    // Load RO keybinds
    AddControlBindings(Section_Game,      Bindings_Game.length,       CID_Game);
    AddControlBindings(Section_Movement,  Bindings_Movement.length,   CID_Movement);
    AddControlBindings(Section_Weapons,   Bindings_Weapons.length,    CID_Weapons);
    AddControlBindings(Section_Inventory, Bindings_Inventory.length,  CID_Inventory);
    AddControlBindings(Section_Looking,   Bindings_Looking.length,    CID_Looking);
    AddControlBindings(Section_Comm,      Bindings_Comm.length,       CID_Comm);
    AddControlBindings(Section_Interface, Bindings_Interface.length,  CID_Interface);
    AddControlBindings(Section_Misc,      Bindings_Misc.length,       CID_Misc);

    // Load custom keybinds
    LoadCustomBindings();

    // Load speech binds
    UpdateVoicePackClass();

    // Support requests
    CreateAliasMapping("", Section_Speech_Prefix $ class'ROConsole'.default.SMStateName[1], true);
    VoicePackClass.static.GetAllSupports( VoiceCommands );
    for (i = 0; i < VoiceCommands.Length; ++i)
    {
        CreateAliasMapping("speech SUPPORT" @ i, VoiceCommands[i], false);
    }

    // Acknowledgements requests
    CreateAliasMapping("", Section_Speech_Prefix $ class'ROConsole'.default.SMStateName[2], true);
    VoicePackClass.static.GetAllAcknowledges( VoiceCommands );
    for (i = 0; i < VoiceCommands.Length; ++i)
    {
        CreateAliasMapping("speech ACK" @ i, VoiceCommands[i], false);
    }

    // Enemy spotted
    CreateAliasMapping("", Section_Speech_Prefix $ class'ROConsole'.default.SMStateName[3], true);
    VoicePackClass.static.GetAllEnemies( VoiceCommands );
    for (i = 0; i < VoiceCommands.Length; ++i)
    {
        CreateAliasMapping("speech ENEMY" @ i, VoiceCommands[i], false);
    }

    // Alerts
    CreateAliasMapping("", Section_Speech_Prefix $ class'ROConsole'.default.SMStateName[4], true);
    VoicePackClass.static.GetAllAlerts( VoiceCommands );
    for (i = 0; i < VoiceCommands.Length; ++i)
    {
        CreateAliasMapping("speech ALERT" @ i, VoiceCommands[i], false);
    }

    // Vehicle orders
    CreateAliasMapping("", Section_Speech_Prefix $ class'ROConsole'.default.SMStateName[5], true);
    VoicePackClass.static.GetAllVehicleDirections( VoiceCommands );
    for (i = 0; i < VoiceCommands.Length; ++i)
    {
        CreateAliasMapping("speech VEH_ORDERS" @ i, VoiceCommands[i], false);
    }

    // Vehicle alerts
    CreateAliasMapping("", Section_Speech_Prefix $ class'ROConsole'.default.SMStateName[6], true);
    VoicePackClass.static.GetAllVehicleAlerts( VoiceCommands );
    for (i = 0; i < VoiceCommands.Length; ++i)
    {
        CreateAliasMapping("speech VEH_ALERTS" @ i, VoiceCommands[i], false);
    }

    // Commands
    CreateAliasMapping("", Section_Speech_Prefix $ class'ROConsole'.default.SMStateName[7], true);
    VoicePackClass.static.GetAllOrders( VoiceCommands );
    for (i = 0; i < VoiceCommands.Length; ++i)
    {
        CreateAliasMapping("speech ORDER" @ i, VoiceCommands[i], false);
    }

    // Extras
    CreateAliasMapping("", Section_Speech_Prefix $ class'ROConsole'.default.SMStateName[8], true);
    VoicePackClass.static.GetAllExtras( VoiceCommands );
    for (i = 0; i < VoiceCommands.Length; ++i)
    {
        CreateAliasMapping("speech TAUNT" @ i, VoiceCommands[i], false);
    }
}

// Function which replaces "AddBindings" in ROTab_Controls
function AddControlBindings(string Section_Title, int Num_Elements, ECategoryIDs Category_ID)
{
    local int i;
    local string BindStr, CaptionStr;

    if (Section_Title != "")
    {
        CreateAliasMapping("", Section_Title, true );
    }

    for (i = 0; i < Num_Elements; i++)
    {
        switch (Category_ID)
        {
            case CID_Movement: BindStr = Bindings_Movement[i]; CaptionStr = Captions_Movement[i]; break;
            case CID_Looking: BindStr = Bindings_Looking[i]; CaptionStr = Captions_Looking[i]; break;
            case CID_Weapons: BindStr = Bindings_Weapons[i]; CaptionStr = Captions_Weapons[i]; break;
            case CID_Inventory: BindStr = Bindings_Inventory[i]; CaptionStr = Captions_Inventory[i]; break;
            case CID_Comm: BindStr = Bindings_Comm[i]; CaptionStr = Captions_Comm[i]; break;
            case CID_Game: BindStr = Bindings_Game[i]; CaptionStr = Captions_Game[i]; break;
            case CID_Misc: BindStr = Bindings_Misc[i]; CaptionStr = Captions_Misc[i]; break;
            case CID_Interface: BindStr = Bindings_Interface[i]; CaptionStr = Captions_Interface[i]; break;
            default: BindStr = ""; CaptionStr = "Unknown ID: " $ Category_ID; break;
        }

        CreateAliasMapping(BindStr, CaptionStr, false);
    }
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

    // Inventory a DH keybind category
    Section_Inventory="Inventory"
    Bindings_Inventory(0)="SwitchWeapon 1"
    Captions_Inventory(0)="Inventory Slot 1"
    Bindings_Inventory(1)="SwitchWeapon 2"
    Captions_Inventory(1)="Inventory Slot 2"
    Bindings_Inventory(2)="SwitchWeapon 3"
    Captions_Inventory(2)="Inventory Slot 3"
    Bindings_Inventory(3)="SwitchWeapon 4"
    Captions_Inventory(3)="Inventory Slot 4"
    Bindings_Inventory(4)="SwitchWeapon 5"
    Captions_Inventory(4)="Inventory Slot 5"
    Bindings_Inventory(5)="SwitchWeapon 6"
    Captions_Inventory(5)="Inventory Slot 6"
    Bindings_Inventory(6)="SwitchWeapon 7"
    Captions_Inventory(6)="Inventory Slot 7"
    Bindings_Inventory(7)="SwitchWeapon 8"
    Captions_Inventory(7)="Inventory Slot 8"
    Bindings_Inventory(8)="SwitchWeapon 9"
    Captions_Inventory(8)="Inventory Slot 9"
    Bindings_Inventory(9)="SwitchWeapon 0"
    Captions_Inventory(9)="Inventory Slot 0"

    // Additional game keybinds
    Bindings_Game(4)="ToggleVehicleLock"
    Captions_Game(4)="Lock/Unlock Armored Vehicle"
    Bindings_Game(5)="ShowOrderMenu | OnRelease HideOrderMenu"
    Captions_Game(5)="Squad Orders Menu"
    Bindings_Game(6)="SquadMenu"
    Captions_Game(6)="Squad Menu"
    Bindings_Game(7)="SquadJoinAuto"
    Captions_Game(7)="Auto-Join Squad"
    Bindings_Game(8)="PlaceRallyPoint"
    Captions_Game(8)="Place Rally Point"

    // Additional movement keybinds
    Bindings_Movement(12)="ToggleRun"
    Captions_Movement(12)="Toggle Run"

    // Overidden & Additional Weapon keybinds
    Bindings_Weapons(9)="ROMGOperation" // renumbered from here so the new vehicle smoke launcher controls are grouped together at the end of the weapons section
    Captions_Weapons(9)="Change MG Barrel"
    Bindings_Weapons(10)="SwitchFireMode"
    Captions_Weapons(10)="Switch Fire Mode"
    Bindings_Weapons(11)="Deploy"
    Captions_Weapons(11)="Deploy MG / Attach Bayonet / Fire Vehicle Smoke Launcher" // added fire smoke launcher to key description
    Bindings_Weapons(12)="IncreaseSmokeLauncherSetting"
    Captions_Weapons(12)="Increase Vehicle Smoke Launcher Range/Rotation Setting"
    Bindings_Weapons(13)="DecreaseSmokeLauncherSetting"
    Captions_Weapons(13)="Decrease Vehicle Smoke Launcher Range/Rotation Setting"
    Bindings_Weapons(14)="ToggleSelectedArtilleryTarget"
    Captions_Weapons(14)="Toggle Selected Artillery Target"

    // Overriden & Additional Communications keybinds
    Bindings_Comm(3)="SquadTalk"
    Captions_Comm(3)="Squad Say"
    Bindings_Comm(4)="SpeechMenuToggle"
    Captions_Comm(4)="Voice Command Menu"
    Bindings_Comm(5)="InGameChat"
    Captions_Comm(5)="View In-game Chat"
    Bindings_Comm(6)="VoiceTalk"
    Captions_Comm(6)="Activate Microphone"
    Bindings_Comm(7)="Speak Command"
    Captions_Comm(7)="Switch to Command Voice Channel"
    Bindings_Comm(8)="Speak Local"
    Captions_Comm(8)="Switch to Local Voice Channel"
    Bindings_Comm(9)="Speak Unassigned"
    Captions_Comm(9)="Switch to Unassigned Voice Channel"
    Bindings_Comm(10)="Speak Squad"
    Captions_Comm(10)="Switch to Squad Voice Channel"
    Bindings_Comm(11)="StartTyping"
    Captions_Comm(11)="Start typing a chat message"
    Bindings_Comm(12)="CommunicationMenu"
    Captions_Comm(12)="Mute Menu"

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
    ControlProfileKeys(3)=    (Keys=("V",  "Z",    "B",                     "N",             "J",               "K",         "L",           "Semicolon",   "SingleQuote",   "Ctrl",            "Alt",                                    "Backslash",     "MouseX",                               "MouseY",                               "CapsLock","F",             "Backspace",        "Y",                  "U",                "I",          "O"))
    ControlProfileCommands(3)=(Cmds=("Use","Prone","ROMGOperation | Deploy","speech ALERT 0","speech SUPPORT 2","teamsay np","speech ACK 3","speech ACK 2","speech ALERT 3","SpeechMenuToggle","ShowOrderMenu | OnRelease HideOrderMenu","speech ALERT 2","Count bXAxis | Axis aMouseX Speed=1.0","Count bYAxis | Axis aMouseY Speed=1.0","Walking", "ShowObjectives","ToggleVehicleLock","PlaceRallyPoint",    "ToggleRun",        "",           ""))
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
