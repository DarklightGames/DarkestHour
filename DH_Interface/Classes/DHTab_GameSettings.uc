//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHTab_GameSettings extends ROTab_GameSettings;

var automated moComboBox    co_ConfigViewFOV;
var automated moComboBox    co_PurgeCacheDays;
var automated GUILabel      l_ID;
var automated DHGUIButton   b_CopyID;

var     int                 ViewFOV;
var     int                 PurgeCacheDaysValues[3];
var     localized string    PurgeCacheDaysText[3];
var     localized string    HashReqText, IDText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local int FOV;

    super.InitComponent(MyController, MyOwner);

    i_BG1.ManageComponent(co_ConfigViewFOV);
    i_BG2.ManageComponent(l_ID);
    i_BG2.ManageComponent(b_CopyID);
    i_BG2.ManageComponent(co_PurgeCacheDays);

    for (i = 0; i < arraycount(PurgeCacheDaysText); ++i)
    {
        co_PurgeCacheDays.AddItem(PurgeCacheDaysText[i]);
    }

    for (FOV = class'DHPlayer'.default.ViewFOVMin; FOV <= class'DHPlayer'.default.ViewFOVMax; FOV += 5.0)
    {
        co_ConfigViewFOV.AddItem(string(FOV));
    }

    ed_PlayerName.MyEditBox.bConvertSpaces = false;
    ed_PlayerName.MyEditBox.MaxWidth = 32;

    //l_ID.Caption = DHPlayer(PlayerOwner()).ROIDHash;
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{
    local int PurgeCacheDays, PurgeCacheDaysIndex, i;

    switch (Sender)
    {
        case co_ConfigViewFOV:
            ViewFOV = class'DH_Engine.DHPlayer'.default.ConfigViewFOV;
            co_ConfigViewFOV.SetComponentValue(ViewFOV, true);
            break;

        case co_PurgeCacheDays:
            PurgeCacheDays = int(PlayerOwner().ConsoleCommand("get Core.System PurgeCacheDays", false));

            for (i = 0; i < arraycount(PurgeCacheDaysValues); ++i)
            {
                if (PurgeCacheDays == PurgeCacheDaysValues[i])
                {
                    PurgeCacheDaysIndex = i;

                    break;
                }
            }

            co_PurgeCacheDays.SetIndex(PurgeCacheDaysIndex);

            break;

        case l_ID:
            s = PlayerOwner().ConsoleCommand("get DH_Engine.DHPlayer ROIDHash", false);

            if (s == "")
            {
                l_ID.Caption = default.IDText @ default.HashReqText;
                b_CopyID.DisableMe();
            }
            else
            {
                l_ID.Caption = default.IDText @ s;
                b_CopyID.EnableMe();
            }

            break;

        default:
            super.InternalOnLoadINI(Sender, s); // no need to call the Super if the passed GUIComponent is one of the options above
    }
}

function InternalOnChange(GUIComponent Sender)
{
    super.InternalOnChange(Sender);

    switch (Sender)
    {
        case co_ConfigViewFOV:
            ViewFOV = int(co_ConfigViewFOV.GetItem(co_ConfigViewFOV.GetIndex()));
            break;
    }
}

function bool OnClick(GUIComponent Sender)
{
    switch (Sender)
    {
        case b_CopyID:
            PlayerOwner().CopyToClipboard(PlayerOwner().ConsoleCommand("get DH_Engine.DHPlayer ROIDHash", false));
            break;
    }

    return false;
}

function SaveSettings()
{
    local int PurgeCacheDaysIndex;

    class'DHPlayer'.static.SetDefaultViewFOV(ViewFOV);
    PlayerOwner().FixFOV(); // switch to new default FOV setting

    PurgeCacheDaysIndex = co_PurgeCacheDays.GetIndex();
    PlayerOwner().ConsoleCommand("set Core.System PurgeCacheDays" @ PurgeCacheDaysValues[PurgeCacheDaysIndex]);

    super.SaveSettings();
}

function ResetClicked()
{
    local ROPlayer ROP;
    local int      i;

    super.ResetClicked();

    class'DHPlayer'.static.ResetConfig("ConfigViewFOV");
    PlayerOwner().ConsoleCommand("set Core.System PurgeCacheDays" @ PurgeCacheDaysValues[0]);
    class'ROPlayer'.static.ResetConfig("bManualTankShellReloading"); // added as this reset was missing in RO parent class

    ROP = ROPlayer(PlayerOwner());

    // Added so reset values for the vehicle properties actually get reset immediately if reset in game
    // Before they didn't take effect until the player had exited the game
    if (ROP != none)
    {
        ROP.bInterpolatedTankThrottle = class'ROPlayer'.default.bInterpolatedTankThrottle;
        ROP.bInterpolatedVehicleThrottle = class'ROPlayer'.default.bInterpolatedVehicleThrottle;
        ROP.bManualTankShellReloading = class'ROPlayer'.default.bManualTankShellReloading;
    }

    for (i = 0; i < Components.Length; ++i)
    {
        Components[i].LoadINI();
    }
}

defaultproperties
{
    PurgeCacheDaysValues(0)=0
    PurgeCacheDaysValues(1)=30
    PurgeCacheDaysValues(2)=365
    PurgeCacheDaysText(0)="Never"
    PurgeCacheDaysText(1)="Monthly"
    PurgeCacheDaysText(2)="Yearly"
    IDText="ID:"
    HashReqText="Must join multiplayer first"

    NetSpeedText(0)="Modem (2600)"
    NetSpeedText(1)="ISDN (5000)"
    NetSpeedText(2)="Cable/ADSL (10000)"
    NetSpeedText(3)="LAN/T1 (15000)"

    // Gameplay options
    Begin Object Class=DHGUISectionBackground Name=GameBK1
        Caption="Gameplay"
        WinTop=0.05
        WinLeft=0.25
        WinWidth=0.5
        WinHeight=0.25
        RenderWeight=0.1001
        OnPreDraw=GameBK1.InternalPreDraw
    End Object
    i_BG1=DHGUISectionBackground'DH_Interface.DHTab_GameSettings.GameBK1'

    Begin Object Class=DHmoEditBox Name=OnlineStatsName
        Caption="Player Name"
        OnCreateComponent=OnlineStatsName.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.373349
        WinLeft=0.524912
        WinWidth=0.419316
        TabOrder=1
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
    End Object
    ed_PlayerName=DHmoEditBox'DH_Interface.DHTab_GameSettings.OnlineStatsName'

    Begin Object Class=DHmoComboBox Name=ConfigViewFOV
        ComponentJustification=TXTA_Left
        Caption="Normal View FOV"
        Hint="Lower for a more zoomed view, raise for a wider field of view"
        OnCreateComponent=ConfigViewFOV.InternalOnCreateComponent
        IniOption="@Internal"
        TabOrder=2
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
        bReadOnly=true
    End Object
    co_ConfigViewFOV=DHmoComboBox'DH_Interface.DHTab_GameSettings.ConfigViewFOV'

    Begin Object Class=DHmoComboBox Name=GameGoreLevel
        bReadOnly=true
        Caption="Gore Level"
        OnCreateComponent=GameGoreLevel.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.415521
        WinLeft=0.05
        WinWidth=0.4
        RenderWeight=1.04
        TabOrder=3
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
    End Object
    co_GoreLevel=DHmoComboBox'DH_Interface.DHTab_GameSettings.GameGoreLevel'

    // Network options
    Begin Object Class=DHGUISectionBackground Name=GameBK2
        Caption="Network"
        WinTop=0.35
        WinLeft=0.25
        WinWidth=0.5
        WinHeight=0.3
        RenderWeight=0.1002
        OnPreDraw=GameBK2.InternalPreDraw
    End Object
    i_BG2=DHGUISectionBackground'DH_Interface.DHTab_GameSettings.GameBK2'

    Begin Object class=GUILabel Name=EpicID
        WinWidth=0.888991
        WinHeight=0.067703
        WinLeft=0.054907
        WinTop=0.858220
        IniOption="@Internal"
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
        Caption="You must first join a multiplayer game before your ID is displayed"
        TextAlign=TXTA_Center
        bMultiLine=false
        StyleName="TextLabel"
        RenderWeight=0.2
    End Object
    l_ID=EpicID

    Begin Object class=DHGUIButton Name=CopyROIDButton
        Caption="Copy ID To Clipboard"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_CopyID=CopyROIDButton

    Begin Object Class=DHmoCheckBox Name=NetworkDynamicNetspeed
        ComponentJustification=TXTA_Left
        CaptionWidth=0.959
        Caption="Dynamic Netspeed"
        OnCreateComponent=NetworkDynamicNetspeed.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.166017
        WinLeft=0.528997
        WinWidth=0.419297
        TabOrder=4
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
    End Object
    ch_DynNetspeed=DHmoCheckBox'DH_Interface.DHTab_GameSettings.NetworkDynamicNetspeed'

    Begin Object Class=DHmoComboBox Name=OnlineNetSpeed
        bReadOnly=true
        ComponentJustification=TXTA_Left
        Caption="Connection"
        OnCreateComponent=OnlineNetSpeed.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Cable Modem/DSL"
        WinTop=0.122944
        WinLeft=0.528997
        WinWidth=0.419297
        TabOrder=5
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
    End Object
    co_Netspeed=DHmoComboBox'DH_Interface.DHTab_GameSettings.OnlineNetSpeed'

    Begin Object Class=DHmoComboBox Name=PurgeCacheDaysComboBox
        bReadOnly=true
        ComponentJustification=TXTA_Left
        Caption="Purge Cache"
        OnCreateComponent=PurgeCacheDaysComboBox.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.122944
        WinLeft=0.528997
        WinWidth=0.419297
        TabOrder=6
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
    End Object
    co_PurgeCacheDays=DHmoComboBox'DH_Interface.DHTab_GameSettings.PurgeCacheDaysComboBox'

    // Simulation realism options
    Begin Object Class=DHGUISectionBackground Name=GameBK3
        Caption="Simulation Realism"
        WinTop=0.7
        WinLeft=0.25
        WinWidth=0.5
        WinHeight=0.25
        RenderWeight=0.1002
        OnPreDraw=GameBK3.InternalPreDraw
    End Object
    i_BG3=DHGUISectionBackground'DH_Interface.DHTab_GameSettings.GameBK3'

    Begin Object Class=DHmoCheckBox Name=ThrottleTanks
        ComponentJustification=TXTA_Left
        CaptionWidth=0.959
        Caption="Incremental Tank Throttle"
        OnCreateComponent=ThrottleTanks.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.166017
        WinLeft=0.528997
        WinWidth=0.419297
        TabOrder=7
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
    End Object
    ch_TankThrottle=DHmoCheckBox'DH_Interface.DHTab_GameSettings.ThrottleTanks'

    Begin Object Class=DHmoCheckBox Name=ThrottleVehicle
        ComponentJustification=TXTA_Left
        CaptionWidth=0.959
        Caption="Incremental Vehicle Throttle"
        OnCreateComponent=ThrottleVehicle.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.166017
        WinLeft=0.528997
        WinWidth=0.419297
        TabOrder=8
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
    End Object
    ch_VehicleThrottle=DHmoCheckBox'DH_Interface.DHTab_GameSettings.ThrottleVehicle'

    Begin Object Class=DHmoCheckBox Name=ManualReloading
        ComponentJustification=TXTA_Left
        CaptionWidth=0.959
        Caption="Manual Tank Shell Reloading"
        OnCreateComponent=ManualReloading.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.166017
        WinLeft=0.528997
        WinWidth=0.419297
        TabOrder=9
        OnChange=DHTab_GameSettings.InternalOnChange
        OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
    End Object
    ch_ManualReloading=DHmoCheckBox'DH_Interface.DHTab_GameSettings.ManualReloading'
}
