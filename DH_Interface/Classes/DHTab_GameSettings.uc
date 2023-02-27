//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTab_GameSettings extends Settings_Tabs;

var automated GUISectionBackground i_BG1, i_BG2, i_BG3;

var automated DHmoEditBox       ed_PlayerName;
var automated DHmoComboBox      co_ViewFOV;
var automated DHmoCheckBox      ch_NoGore;
var automated DHmoCheckBox      ch_BayonetAtStart;
var automated DHmoCheckBox      ch_TankThrottle, ch_VehicleThrottle, ch_ManualReloading, ch_LockTankOnEntry;
var automated GUILabel          l_PlayerROID;     // label showing player's unique ROID
var automated DHGUIButton       b_CopyPlayerROID; // button to copy player's ROID to clipboard
var automated DHmoCheckBox      ch_DynamicNetSpeed;
var automated DHmoComboBox      co_Netspeed, co_PurgeCacheDays;

var     int                     OriginalNetSpeed, OriginalPurgeCacheDays; // save initial values so can tell later if they have changed & need to be saved
var     int                     PurgeCacheDaysValues[3]; // deliberately one less than PurgeCacheDaysText array size, as highest text in list is for possible custom value

var     localized string        UserDefinedNetSpeedText;
var     localized string        PurgeCacheDaysText[4];
var     localized string        IDText, NoROIDText;
var     localized string        DegreesText;

var     localized string        NetSpeedText[7];
var     int                     NetSpeedValues[7];

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int ViewFOVSetting, i;

    super(Settings_Tabs).InitComponent(MyController, MyOwner); // skip over the Super in ROTab_GameSettings as it's re-stated here

    i_BG1.ManageComponent(ed_PlayerName);
    i_BG1.ManageComponent(co_ViewFOV);
    i_BG1.ManageComponent(ch_NoGore);
    i_BG1.ManageComponent(ch_BayonetAtStart);

    i_BG2.ManageComponent(ch_TankThrottle);
    i_BG2.ManageComponent(ch_VehicleThrottle);
    i_BG2.ManageComponent(ch_ManualReloading);
    i_BG2.ManageComponent(ch_LockTankOnEntry);

    i_BG3.ManageComponent(l_PlayerROID);
    i_BG3.ManageComponent(b_CopyPlayerROID);
    i_BG3.ManageComponent(ch_DynamicNetSpeed);
    i_BG3.ManageComponent(co_Netspeed);
    i_BG3.ManageComponent(co_PurgeCacheDays);

    ed_PlayerName.MyEditBox.MaxWidth = 32; // compared to RO, this allows longer player name & no longer converts spaces

    for (ViewFOVSetting = class'DHPlayer'.default.ViewFOVMin; ViewFOVSetting <= class'DHPlayer'.default.ViewFOVMax; ViewFOVSetting += 5)
    {
        co_ViewFOV.AddItem(string(ViewFOVSetting) @ DegreesText);
    }

    for (i = 0; i < arraycount(NetSpeedText); ++i)
    {
        co_Netspeed.AddItem(Repl(NetSpeedText[i], "{0}", NetSpeedValues[i]));
    }

    for (i = 0; i < arraycount(PurgeCacheDaysValues); ++i) // deliberately using PurgeCacheDaysValues array size, as highest list text is reserved for possible custom value
    {
        co_PurgeCacheDays.AddItem(PurgeCacheDaysText[i]);
    }
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{
    local PlayerController PC;
    local float            ViewFOV;
    local int              i, j;
    local bool             bOptionEnabled;

    PC = PlayerOwner();

    if (PC == none)
    {
        return;
    }

    switch (Sender)
    {
        // Player name
        case ed_PlayerName:
            ed_PlayerName.SetText(PC.GetUrlOption("Name"));
            break;

        // View FOV
        case co_ViewFOV:
            ViewFOV = float(PC.ConsoleCommand("get DH_Engine.DHPlayer ConfigViewFOV"));
            ViewFOV = Round(ViewFOV / 5.0) * 5.0;  // round existing config setting to nearest 5 degrees
            co_ViewFOV.Find(string(int(ViewFOV)) @ DegreesText); // finds current FOV in the list array & sets the list's index position
            break;

        // Gore level
        case ch_NoGore:
            if (PC.Level.Game != none)
            {
                bOptionEnabled = PC.Level.Game.GoreLevel == 0;
            }
            else
            {
                bOptionEnabled = class'GameInfo'.default.GoreLevel == 0;
            }

            ch_NoGore.Checked(bOptionEnabled);
            break;

        // Spawn with bayonet
        case ch_BayonetAtStart:
            ch_BayonetAtStart.Checked(PlayerOwner().ConsoleCommand("get DH_Engine.DHPlayer bSpawnWithBayonet"));
            break;

        // Vehicle settings
        case ch_TankThrottle:
            if (DHPlayer(PC) != none)
            {
                bOptionEnabled = DHPlayer(PC).bInterpolatedTankThrottle;
            }
            else
            {
                bOptionEnabled = class'DHPlayer'.default.bInterpolatedTankThrottle;
            }

            ch_TankThrottle.Checked(bOptionEnabled);
            break;

        case ch_VehicleThrottle:
            if (DHPlayer(PC) != none)
            {
                bOptionEnabled = DHPlayer(PC).bInterpolatedVehicleThrottle;
            }
            else
            {
                bOptionEnabled = class'DHPlayer'.default.bInterpolatedVehicleThrottle;
            }

            ch_VehicleThrottle.Checked(bOptionEnabled);
            break;

        case ch_ManualReloading:
            if (DHPlayer(PC) != none)
            {
                bOptionEnabled = DHPlayer(PC).bManualTankShellReloading;
            }
            else
            {
                bOptionEnabled = class'DHPlayer'.default.bManualTankShellReloading;
            }

            ch_ManualReloading.Checked(bOptionEnabled);
            break;

        case ch_LockTankOnEntry:
            if (DHPlayer(PC) != none)
            {
                bOptionEnabled = DHPlayer(PC).bLockTankOnEntry;
            }
            else
            {
                bOptionEnabled = class'DHPlayer'.default.bLockTankOnEntry;
            }

            ch_LockTankOnEntry.Checked(bOptionEnabled);
            break;

        // Player's ROID
        case l_PlayerROID:
            s = PlayerOwner().ConsoleCommand("get DH_Engine.DHPlayer ROIDHash", false);

            if (s == "")
            {
                l_PlayerROID.Caption = default.IDText @ default.NoROIDText;
                b_CopyPlayerROID.DisableMe();
            }
            else
            {
                l_PlayerROID.Caption = default.IDText @ s;
                b_CopyPlayerROID.EnableMe();
            }

            break;

        // Net speed
        case ch_DynamicNetSpeed:
            ch_DynamicNetSpeed.Checked(PC.bDynamicNetSpeed);
            break;

        case co_Netspeed:
            // Get the ConfiguredInternetSpeed and set it to i
            if (PC.Player != none)
            {
                i = PC.Player.ConfiguredInternetSpeed;
            }
            else
            {
                i = class'Player'.default.ConfiguredInternetSpeed;
            }

            // Remove the NetSpeed User Defined value (last value), we will add it back only if it is actually defined by the user
            co_NetSpeed.RemoveItem(arraycount(NetSpeedText) - 1);

            // Select the setting based on the NetSpeed value
            for (j = 0; j < arraycount(NetSpeedValues); ++j)
            {
                if (i == NetSpeedValues[j])
                {
                    if (j == arraycount(NetSpeedValues) - 1)
                    {
                        co_NetSpeed.AddItem(Repl(default.NetSpeedText[arraycount(NetSpeedText) - 1], "%NetSpeed%", i));
                    }

                    OriginalNetSpeed = j;
                }
            }

            co_NetSpeed.SetIndex(OriginalNetSpeed);
            break;

        // Purge cache
        case co_PurgeCacheDays:
            OriginalPurgeCacheDays = int(PlayerOwner().ConsoleCommand("get Core.System PurgeCacheDays", false));

            // Try to match player's current config file setting to one our our pre-set list values & set the list index to that position
            // But if player has a non-standard setting, the list index ends up being the highest position, which is the 'custom days' option
            // The custom days option doesn't change the player's setting, unless he actively selects another option from the pre-set list
            for (i = 0; i < arraycount(PurgeCacheDaysValues); ++i)
            {
                if (OriginalPurgeCacheDays == PurgeCacheDaysValues[i])
                {
                    break;
                }
            }

            // If we didn't find a match, set the text for the extra 'custom days' option in the list, if we haven't already done so (check size of list array)
            if (i == arraycount(PurgeCacheDaysValues) && co_PurgeCacheDays.ItemCount() < arraycount(PurgeCacheDaysText))
            {
                co_PurgeCacheDays.AddItem(Repl(PurgeCacheDaysText[i], "%NumDays%", OriginalPurgeCacheDays));
            }

            co_PurgeCacheDays.SetIndex(i);
            break;
    }
}

function bool OnClick(GUIComponent Sender)
{
    if (Sender == b_CopyPlayerROID)
    {
        PlayerOwner().CopyToClipboard(PlayerOwner().ConsoleCommand("get DH_Engine.DHPlayer ROIDHash", false));
    }

    return false;
}

function SaveSettings()
{
    local PlayerController PC;
    local DHPlayer         DHP;
    local string           PlayerName;
    local float            ViewFOV;
    local int              GoreLevel, NetSpeed, PurgeCacheDays;
    local bool             bTankThrottle, bVehicleThrottle, bManualReloading, bDynamicNetSpeed, bSaveConfig, bStaticSaveConfig;
    local bool             bSpawnWithBayonet, bLockTankOnEntry;

    PC = PlayerOwner();
    DHP = DHPlayer(PC);

    // Player name
    PlayerName = ed_PlayerName.GetText();

    if (PlayerName != PC.GetUrlOption("Name"))
    {
        ReplaceText(PlayerName, "\"", "");
        PC.ConsoleCommand("SetName" @ PlayerName);
    }

    // View FOV
    ViewFOV = float(Repl(co_ViewFOV.GetText(), " " $ DegreesText, "")); // gets text value for list's current index position, then strips the degrees text & converts to number

    if (ViewFOV != class'DHPlayer'.default.ConfigViewFOV)
    {
        class'DHPlayer'.static.SetDefaultViewFOV(ViewFOV);
        PC.FixFOV(); // switches player to new default FOV setting
    }

    // Gore level
    if (!ch_NoGore.IsChecked())
    {
        GoreLevel = 2; // 2 is the 'full gore' game option, while if no gore is checked here it defaults to zero, which is 'no gore'
    }

    if (PC.Level != none && PC.Level.Game != none)
    {
        if (PC.Level.Game.GoreLevel != GoreLevel)
        {
            PC.Level.Game.GoreLevel = GoreLevel;
            PC.Level.Game.SaveConfig();
        }
    }
    else if (class'GameInfo'.default.GoreLevel != GoreLevel)
    {
        class'GameInfo'.default.GoreLevel = GoreLevel;
        class'GameInfo'.static.StaticSaveConfig();
    }

    // Spawn with bayonet
    bSpawnWithBayonet = ch_BayonetAtStart.IsChecked();

    if (DHP != none && DHP.bSpawnWithBayonet != bSpawnWithBayonet)
    {
        DHP.bSpawnWithBayonet = bSpawnWithBayonet;
        DHP.ServerSetBayonetAtSpawn(bSpawnWithBayonet);
        bSaveConfig = true;
    }

    // Vehicle settings
    bTankThrottle    = ch_TankThrottle.IsChecked();
    bVehicleThrottle = ch_VehicleThrottle.IsChecked();
    bManualReloading = ch_ManualReloading.IsChecked();
    bLockTankOnEntry = ch_LockTankOnEntry.IsChecked();

    if (DHP != none)
    {
        if (DHP.bInterpolatedTankThrottle != bTankThrottle)
        {
            DHP.bInterpolatedTankThrottle = bTankThrottle;
            bSaveConfig = true;
        }

        if (DHP.bInterpolatedVehicleThrottle != bVehicleThrottle)
        {
            DHP.bInterpolatedVehicleThrottle = bVehicleThrottle;
            bSaveConfig = true;
        }

        if (DHP.bManualTankShellReloading != bManualReloading)
        {
            DHP.SetManualTankShellReloading(bManualReloading);
            bSaveConfig = true;
        }

        if (DHP.bLockTankOnEntry != bLockTankOnEntry)
        {
            DHP.SetLockTankOnEntry(bLockTankOnEntry);
            bSaveConfig = true;
        }
    }
    else
    {
        if (class'DHPlayer'.default.bInterpolatedTankThrottle != bTankThrottle)
        {
            class'DHPlayer'.default.bInterpolatedTankThrottle = bTankThrottle;
            bStaticSaveConfig = true;
        }

        if (class'DHPlayer'.default.bInterpolatedVehicleThrottle != bVehicleThrottle)
        {
            class'DHPlayer'.default.bInterpolatedVehicleThrottle = bVehicleThrottle;
            bStaticSaveConfig = true;
        }

        if (class'DHPlayer'.default.bManualTankShellReloading != bManualReloading)
        {
            class'DHPlayer'.default.bManualTankShellReloading = bManualReloading;
            bStaticSaveConfig = true;
        }

        if (class'DHPlayer'.default.bLockTankOnEntry != bLockTankOnEntry)
        {
            class'DHPlayer'.default.bLockTankOnEntry = bLockTankOnEntry;
            bStaticSaveConfig = true;
        }

        if (bStaticSaveConfig)
        {
            class'DHPlayer'.static.StaticSaveConfig();
        }
    }

    // Net speed
    bDynamicNetSpeed = ch_DynamicNetSpeed.IsChecked();
    NetSpeed = co_NetSpeed.GetIndex();

    if (PC.bDynamicNetSpeed != bDynamicNetSpeed)
    {
        PC.bDynamicNetSpeed = bDynamicNetSpeed;
        bSaveConfig = true;
    }

    if (NetSpeed != OriginalNetSpeed || class'Player'.default.ConfiguredInternetSpeed == 9636)
    {
        if (PC.Player != none)
        {
            PC.Player.ConfiguredInternetSpeed = NetSpeedValues[NetSpeed];
            PC.ConsoleCommand("NetSpeed" @ NetSpeedValues[NetSpeed]);
            PC.Player.SaveConfig();
        }
        else
        {
            class'Player'.default.ConfiguredInternetSpeed = NetSpeedValues[NetSpeed];
            class'Player'.static.StaticSaveConfig();
        }
    }

    // Purge cache
    if (co_PurgeCacheDays.GetIndex() < arraycount(PurgeCacheDaysValues)) // no change if list index remains in the highest position, which is the 'custom days' option
    {
        PurgeCacheDays = PurgeCacheDaysValues[co_PurgeCacheDays.GetIndex()];

        if (PurgeCacheDays != OriginalPurgeCacheDays)
        {
            PC.ConsoleCommand("set Core.System PurgeCacheDays" @ PurgeCacheDays);
        }
    }

    if (bSaveConfig)
    {
        PC.SaveConfig();
    }
}

function ResetClicked()
{
    local DHPlayer DHP;
    local int      i;

    class'DHPlayer'.static.ResetConfig("ConfigViewFOV");
    class'GameInfo'.static.ResetConfig("GoreLevel");
    class'DHPlayer'.static.ResetConfig("bSpawnWithBayonet");
    class'DHPlayer'.static.ResetConfig("bInterpolatedTankThrottle");
    class'DHPlayer'.static.ResetConfig("bInterpolatedVehicleThrottle");
    class'DHPlayer'.static.ResetConfig("bManualTankShellReloading"); // note this reset was missing in the original RO parent class
    class'DHPlayer'.static.ResetConfig("bLockTankOnEntry");
    class'PlayerController'.static.ResetConfig("bDynamicNetSpeed");
    class'Player'.static.ResetConfig("ConfiguredInternetSpeed");
    PlayerOwner().ConsoleCommand("set Core.System PurgeCacheDays" @ PurgeCacheDaysValues[0]);

    DHP = DHPlayer(PlayerOwner());

    // Added so the reset values for the these properties actually get reset immediately if reset in game
    // Before they didn't take effect until the player had exited the game
    if (DHP != none)
    {
        DHP.bInterpolatedTankThrottle = class'DHPlayer'.default.bInterpolatedTankThrottle;
        DHP.bInterpolatedVehicleThrottle = class'DHPlayer'.default.bInterpolatedVehicleThrottle;
        DHP.bManualTankShellReloading = class'DHPlayer'.default.bManualTankShellReloading;
        DHP.bLockTankOnEntry = class'DHPlayer'.default.bLockTankOnEntry;
    }

    for (i = 0; i < Components.Length; ++i)
    {
        Components[i].LoadINI();
    }
}

defaultproperties
{
    PanelCaption="Game"
    WinTop=0.15
    WinHeight=0.72
    WinLeft=0.0
    WinWidth=1.0
    bAcceptsInput=false

    DegreesText="degrees"
    IDText="ID:"
    NoROIDText="Must join multiplayer first"

    NetSpeedValues(0)=10000
    NetSpeedValues(1)=12000
    NetSpeedValues(2)=15000
    NetSpeedValues(3)=20000
    NetSpeedValues(4)=30000
    NetSpeedValues(5)=50000
    NetSpeedValues(6)=0

    NetSpeedText(0)="Lowest ({0})"
    NetSpeedText(1)="Low ({0})"
    NetSpeedText(2)="Medium ({0})"
    NetSpeedText(3)="Recommended ({0})"
    NetSpeedText(4)="High ({0})"
    NetSpeedText(5)="Extreme ({0})"
    NetSpeedText(6)="User Defined (%NetSpeed%)"

    PurgeCacheDaysValues(0)=0
    PurgeCacheDaysValues(1)=30
    PurgeCacheDaysValues(2)=365
    PurgeCacheDaysText(0)="Never"
    PurgeCacheDaysText(1)="Monthly"
    PurgeCacheDaysText(2)="Yearly"
    PurgeCacheDaysText(3)="Custom (from ini file) - every %NumDays% days"

    // Gameplay options
    Begin Object Class=DHGUISectionBackground Name=GameBK1
        Caption="Gameplay"
        WinTop=0.0
        WinLeft=0.225
        WinWidth=0.55
        WinHeight=0.5
        RenderWeight=0.1
        OnPreDraw=GameBK1.InternalPreDraw
    End Object
    i_BG1=DHGUISectionBackground'GameBK1'

    Begin Object Class=DHmoEditBox Name=PlayerName
        Caption="Player Name"
        CaptionWidth=0.38
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    ed_PlayerName=DHmoEditBox'PlayerName'

    Begin Object Class=DHmoComboBox Name=ViewFOV
        Caption="Normal Field Of View"
        Hint="How much of the world can be seen across the width of your screen. A lower FOV gives a slightly more zoomed view, while a higher FOV is more zoomed out but gives extra peripheral vision. Note a widescreen monitor does not give extra width of vision; the same view is spread across the wider screen and the top and bottom get cropped."
        CaptionWidth=0.38
        ComponentJustification=TXTA_Left
        bReadOnly=true
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    co_ViewFOV=DHmoComboBox'ViewFOV'

    Begin Object Class=DHmoCheckBox Name=NoGore
        Caption="No Gore"
        Hint="Recommended to have this unchecked"
        CaptionWidth=0.959
        ComponentJustification=TXTA_Left
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    ch_NoGore=DHmoCheckBox'NoGore'

    Begin Object Class=DHmoCheckBox Name=BayonetSpawn
        Caption="Spawn with bayonet attached"
        Hint="Useful if you always want to have your bayonet attached and don't like having to attach it each spawn"
        CaptionWidth=0.959
        ComponentJustification=TXTA_Left
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    ch_BayonetAtStart=DHmoCheckBox'BayonetSpawn'

    // Vehicle options
    Begin Object Class=DHGUISectionBackground Name=GameBK2
        Caption="Vehicle"
        WinTop=0.525
        WinLeft=0.05
        WinWidth=0.425
        WinHeight=0.45
        RenderWeight=0.1
        OnPreDraw=GameBK2.InternalPreDraw
    End Object
    i_BG2=DHGUISectionBackground'GameBK2'

    Begin Object Class=DHmoCheckBox Name=ThrottleTanks
        Caption="Incremental Throttle - Tanks"
        Hint="Uses a throttle for tanks, useful for long drives"
        CaptionWidth=0.959
        ComponentJustification=TXTA_Left
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    ch_TankThrottle=DHmoCheckBox'ThrottleTanks'

    Begin Object Class=DHmoCheckBox Name=ThrottleOtherVehicles
        Caption="Incremental Throttle - Other Vehicles"
        Hint="Uses a throttle for non-tank vehicles, not recommended"
        CaptionWidth=0.959
        ComponentJustification=TXTA_Left
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    ch_VehicleThrottle=DHmoCheckBox'ThrottleOtherVehicles'

    Begin Object Class=DHmoCheckBox Name=ManualReloading
        Caption="Manual Tank Shell Reloading"
        Hint="Rounds will not reload until you click after firing, useful if you decide you want to change round types after firing"
        CaptionWidth=0.959
        ComponentJustification=TXTA_Left
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    ch_ManualReloading=DHmoCheckBox'ManualReloading'

    Begin Object Class=DHmoCheckBox Name=LockTankOnEntry
        Caption="Lock tank when entering it"
        Hint="Automatically lock a tank (or other armored vehicle) when you spawn into it, or if you enter an empty tank. This stops other players from using tank crew positions."
        CaptionWidth=0.959
        ComponentJustification=TXTA_Left
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    ch_LockTankOnEntry=DHmoCheckBox'LockTankOnEntry'

    // Network options
    Begin Object Class=DHGUISectionBackground Name=GameBK3
        Caption="Network"
        WinTop=0.525
        WinLeft=0.525
        WinWidth=0.425
        WinHeight=0.45
        RenderWeight=0.1
        OnPreDraw=GameBK3.InternalPreDraw
    End Object
    i_BG3=DHGUISectionBackground'GameBK3'

    Begin Object class=GUILabel Name=PlayersROID
        Caption="You must first join a multiplayer game before your ID is displayed"
        StyleName="TextLabel"
        TextAlign=TXTA_Center
        RenderWeight=0.2
        IniOption="@Internal"
        OnLoadINI=InternalOnLoadINI
    End Object
    l_PlayerROID=PlayersROID

    Begin Object class=DHGUIButton Name=CopyROIDButton
        Caption="Copy ID To Clipboard"
        Hint="This will allow you to paste your ROID as text"
        StyleName="DHSmallTextButtonStyle"
        OnClick=OnClick
    End Object
    b_CopyPlayerROID=CopyROIDButton

    Begin Object Class=DHmoCheckBox Name=DynamicNetspeed
        Caption="Dynamic Netspeed"
        Hint="Will lower NetSpeed to 6000 or until 40 ping is achieved, useful for those who want better ping vs stable NetSpeed"
        CaptionWidth=0.959
        ComponentJustification=TXTA_Left
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    ch_DynamicNetSpeed=DHmoCheckBox'DynamicNetspeed'

    Begin Object Class=DHmoComboBox Name=NetSpeed
        Caption="NetSpeed (Bytes Per Second)"
        Hint="Your maximum desired internet speed used by the game (in Bytes Per Second). Servers can set a maximum client speed, which will override clients."
        CaptionWidth=0.38
        ComponentJustification=TXTA_Left
        bReadOnly=true
        IniDefault="Recommended (20000)"
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    co_Netspeed=DHmoComboBox'NetSpeed'

    Begin Object Class=DHmoComboBox Name=PurgeCacheDays
        Caption="Purge Cache"
        Hint="How often to delete custom downloaded files from servers"
        CaptionWidth=0.38
        ComponentJustification=TXTA_Left
        bReadOnly=true
        IniOption="@Internal"
        OnChange=InternalOnChange
        OnLoadINI=InternalOnLoadINI
    End Object
    co_PurgeCacheDays=DHmoComboBox'PurgeCacheDays'
}
