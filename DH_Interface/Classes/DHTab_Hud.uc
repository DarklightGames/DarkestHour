//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTab_Hud extends ROTab_Hud;

var automated moCheckBox    ch_SimpleColours;
var automated moCheckBox    ch_ShowChatMessages;
var automated moCheckBox    ch_ShowDeathMessages;
var automated moCheckBox    ch_ShowIndicators;
var automated moCheckBox    ch_ShowVehicleVisionCone;
var automated moCheckBox    ch_ShowRallyPoint;
var automated moCheckBox    ch_UseTechnicalAmmoNames;

var bool bSimpleColours;
var bool bShowChatMessages;
var bool bShowDeathMessages;
var bool bShowIndicators;
var bool bShowVehicleVisionCone;
var bool bShowRallyPoint;
var bool bUseTechnicalAmmoNames, bUseTechnicalAmmoNamesD;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    i_BG1.UnmanageComponent(ch_ShowMapUpdatedText);
    RemoveComponent(ch_ShowMapUpdatedText);

    i_BG1.ManageComponent(ch_ShowRallyPoint);
    i_BG2.ManageComponent(ch_SimpleColours);
    i_BG2.ManageComponent(ch_ShowChatMessages);
    i_BG1.ManageComponent(ch_ShowDeathMessages);
    i_BG1.ManageComponent(ch_ShowIndicators);
    i_BG1.ManageComponent(ch_ShowVehicleVisionCone);
    i_BG1.ManageComponent(ch_UseTechnicalAmmoNames);
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{
    local DHHud H;
    local ROHud ROH;
    local DHPlayer DHP;

    DHP = DHPlayer(PlayerOwner());
    if (DHP != none)
    {
        H = DHHud(DHP.myHUD);
    }
    ROH = ROHud(PlayerOwner().myHUD);

    switch (Sender)
    {
        case ch_ShowIndicators:
            if (H != none)
            {
                bShowIndicators = H.bShowIndicators;
            }
            else
            {
                bShowIndicators = class'DHHud'.default.bShowIndicators;
            }
            ch_ShowIndicators.SetComponentValue(bShowIndicators, true);
            break;
        case ch_SimpleColours:
            if (H != none)
            {
                bSimpleColours = H.bSimpleColours;
            }
            else
            {
                bSimpleColours = class'DHHud'.default.bSimpleColours;
            }
            ch_SimpleColours.SetComponentValue(bSimpleColours, true);
            break;
        case ch_ShowChatMessages:
            if (H != none)
            {
                bShowChatMessages = bool(H.ConsoleMessageCount);
            }
            else
            {
                bShowChatMessages = bool(class'DHHud'.default.ConsoleMessageCount);
            }
            ch_ShowChatMessages.SetComponentValue(bShowChatMessages,true);
            break;
        case ch_ShowDeathMessages:
             bShowDeathMessages = class'DHHud'.default.bShowDeathMessages;
             ch_ShowDeathMessages.SetComponentValue(bShowDeathMessages, true);
             break;
        case ch_UseNativeRoleNames:
            if (DHP != none)
            {
                bUseNativeRoleNames = DHP.bUseNativeRoleNames;
            }
            else
            {
                bUseNativeRoleNames = class'DHPlayer'.default.bUseNativeRoleNames;
            }
            bUseNativeRoleNamesD = bUseNativeRoleNames;
            ch_UseNativeRoleNames.SetComponentValue(bUseNativeRoleNames,true);
            break;
        case ch_UseTechnicalAmmoNames:
            if (H != none)
            {
                bUseTechnicalAmmoNames = H.bUseTechnicalAmmoNames;
            }
            else
            {
                bUseTechnicalAmmoNames = class'DHHud'.default.bUseTechnicalAmmoNames;
            }
            ch_UseTechnicalAmmoNames.SetComponentValue(bUseTechnicalAmmoNames,true);
            break;
        case ch_ShowMapFirstSpawn:
            if (DHP != none)
            {
                bShowMapOnFirstSpawn = DHP.bShowMapOnFirstSpawn;
            }
            else
            {
                bShowMapOnFirstSpawn = class'DHPlayer'.default.bShowMapOnFirstSpawn;
            }
            bShowMapOnFirstSpawnD=bShowMapOnFirstSpawn;
            ch_ShowMapFirstSpawn.SetComponentValue(bShowMapOnFirstSpawn,true);
            break;
        case ch_ShowCompass:
            if (ROH != none)
            {
                bShowCompass = ROH.bShowCompass;
            }
            else
            {
                bShowCompass = class'ROHud'.default.bShowCompass;
            }
            ch_ShowCompass.SetComponentValue(bShowCompass,true);
            break;
        case ch_ShowRallyPoint:
            if (ROH != none)
            {
                bShowRallyPoint = H.bShowRallyPoint;
            }
            else
            {
                bShowRallyPoint = class'DHHud'.default.bShowRallyPoint;
            }
            ch_ShowRallyPoint.SetComponentValue(bShowRallyPoint, true);
            break;
        case sl_Opacity:
            fOpacity = (PlayerOwner().myHUD.HudOpacity / 255) * 100;
            sl_Opacity.SetValue(fOpacity);
            break;
        case sl_Scale:
            fScale = PlayerOwner().myHUD.HudScale * 100;
            sl_Scale.SetValue(fScale);
            break;
        case co_Hints:
            if (DHP != none)
            {
                if (DHP.bShowHints)
                    HintLevel = 1;
                else
                    HintLevel = 2;
            }
            else
            {
                if (class'DHPlayer'.default.bShowHints)
                    HintLevel = 1;
                else
                    HintLevel = 2;
            }
            HintLevelD = HintLevel;
            co_Hints.SilentSetIndex(HintLevel);
            break;
        case ch_ShowVehicleVisionCone:
            if (H != none)
            {
                bShowVehicleVisionCone = H.bShowVehicleVisionCone;
            }
            else
            {
                bShowVehicleVisionCone = class'DHHud'.default.bShowVehicleVisionCone;
            }
            ch_ShowVehicleVisionCone.SetComponentValue(bShowVehicleVisionCone, true);
            break;
        default:
            super(UT2K4Tab_HudSettings).InternalOnLoadINI(sender, s);
    }
}

function SaveSettings()
{
    local DHPlayer PC;
    local DHHud H;
    local bool bSave;

    super(UT2K4Tab_HudSettings).SaveSettings();

    PC = DHPlayer(PlayerOwner());
    H = DHHud(PlayerOwner().myHud);

    if (bUseNativeRoleNamesD != bUseNativeRoleNames)
    {
        if (PC != none)
        {
            PC.bUseNativeRoleNames = bUseNativeRoleNames;
            PC.ConsoleCommand("set DH_Engine.DHPlayer bUseNativeRoleNames" @ string(bUseNativeRoleNames));
            PC.SaveConfig();
        }
        else
        {
            class'DHPlayer'.default.bUseNativeRoleNames = bUseNativeRoleNames;
            class'DHPlayer'.static.StaticSaveConfig();
        }
    }

    if (bShowMapOnFirstSpawnD != bShowMapOnFirstSpawn)
    {
        if (PC != none)
        {
            PC.bShowMapOnFirstSpawn = bShowMapOnFirstSpawn;
            PC.ConsoleCommand("set DH_Engine.DHPlayer bShowMapOnFirstSpawn" @ string(bShowMapOnFirstSpawn));
            PC.SaveConfig();
        }
        else
        {
            class'DHPlayer'.default.bShowMapOnFirstSpawn = bShowMapOnFirstSpawn;
            class'DHPlayer'.static.StaticSaveConfig();
        }
    }

    //var int HintLevel, HintLevelD; // 0 = all hints, 1 = new hints, 2 = no hints

    //function is a mess but there's sort of no way around it since you need to run the console commands randomly
    if (HintLevelD != HintLevel)
    {
        if (HintLevel == 0) // 0 = all hints
        {
            if (PC != none)
            {
                PC.bShowHints = true;
                PC.ConsoleCommand("set DH_Engine.DHPlayer bShowHints" @ true);
                PC.UpdateHintManagement(true);

                if (PC.DHHintManager != none)
                {
                    PC.DHHintManager.NonStaticReset();
                }

                PC.SaveConfig();
            }
            else
            {
                class'DHHintManager'.static.StaticReset();
                class'DHPlayer'.default.bShowHints = true;
                class'DHPlayer'.static.StaticSaveConfig();
            }
        }
        else
        {
            if (PC != none)
            {
                PC.bShowHints = HintLevel == 1; //true if (new hints), false if (no hints)
                PC.ConsoleCommand("set DH_Engine.DHPlayer bShowHints" @ string(HintLevel == 1));
                PC.UpdateHintManagement(HintLevel == 1); //true if (new hints), false if (no hints)
                PC.SaveConfig();
            }
            else
            {
                class'DHPlayer'.default.bShowHints = HintLevel == 1; //true if (new hints), false if (no hints)
                class'DHPlayer'.static.StaticSaveConfig();
            }
        }
    }

    if (H != none)
    {
        if (H.bShowIndicators != bShowIndicators)
        {
            H.bShowIndicators = bShowIndicators;
            PC.ConsoleCommand("set DH_Engine.DHHud bShowIndicators" @ string(bShowIndicators));
            bSave = true;
        }

        if (H.bShowVehicleVisionCone != bShowVehicleVisionCone)
        {
            H.bShowVehicleVisionCone = bShowVehicleVisionCone;
            PC.ConsoleCommand("set DH_Engine.DHHud bShowVehicleVisionCone" @ string(bShowVehicleVisionCone));
            bSave = true;
        }

        if (H.bShowCompass != bShowCompass)
        {
            H.bShowCompass = bShowCompass;
            PC.ConsoleCommand("set ROEngine.ROHud bShowCompass" @ string(bShowCompass));
            bSave = true;
        }

        if (H.bShowRallyPoint != bShowRallyPoint)
        {
            H.bShowRallyPoint = bShowRallyPoint;
            PC.ConsoleCommand("set DH_Engine.DHHud bShowRallyPoint" @ string(bShowRallyPoint));
            bSave = true;
        }

        if (H.bSimpleColours != bSimpleColours)
        {
            H.bSimpleColours = bSimpleColours;
            PC.ConsoleCommand("set DH_Engine.DHHud bSimpleColours" @ string(bSimpleColours));
            bSave = true;
        }

        if (H.bShowDeathMessages != bShowDeathMessages)
        {
            H.bShowDeathMessages = bShowDeathMessages;
            PC.ConsoleCommand("set DH_Engine.DHHud bShowDeathMessages" @ string(bShowDeathMessages));
            bSave = true;
        }

        if (H.bUseTechnicalAmmoNames != bUseTechnicalAmmoNames)
        {
            H.bUseTechnicalAmmoNames = bUseTechnicalAmmoNames;
            PC.ConsoleCommand("set DH_Engine.DHHud bUseTechnicalAmmoNames" @ string(bUseTechnicalAmmoNames));
            bSave = true;
        }

        if (bSave)
        {
            H.SaveConfig();
        }
    }
    else
    {
        class'DHHud'.default.bShowCompass = bShowCompass;
        class'DHHud'.default.bShowIndicators = bShowIndicators;
        class'DHHud'.default.bShowVehicleVisionCone = bShowVehicleVisionCone;
        class'DHHud'.default.bShowRallyPoint = bShowRallyPoint;
        class'DHHud'.default.bSimpleColours = bSimpleColours;
        class'DHHud'.default.bShowDeathMessages = bShowDeathMessages;
        class'DHHud'.default.bUseTechnicalAmmoNames = bUseTechnicalAmmoNames;
        class'DHHud'.static.StaticSaveConfig();
    }
}

function InternalOnChange(GUIComponent Sender)
{
    switch (Sender)
    {
        case ch_ShowIndicators:
            bShowIndicators = ch_ShowIndicators.IsChecked();
            break;
        case ch_ShowVehicleVisionCone:
            bShowVehicleVisionCone = ch_ShowVehicleVisionCone.IsChecked();
            break;
        case ch_ShowChatMessages:
            bShowChatMessages = ch_ShowChatMessages.IsChecked();

            if (!bShowChatMessages)
            {
                nu_MsgCount.SetValue(0);
            }
            else if (nu_MsgCount.GetValue() == 0)
            {
                nu_MsgCount.SetValue(class'DHHud'.default.ConsoleMessageCount);
            }
            break;
        case nu_MsgCount:
            iCount = nu_MsgCount.GetValue();
            ch_ShowChatMessages.SetComponentValue(bool(iCount),true);
            break;
        case ch_SimpleColours:
            bSimpleColours = ch_SimpleColours.IsChecked();
            break;
        case ch_ShowDeathMessages:
            bShowDeathMessages = ch_ShowDeathMessages.IsChecked();
            break;
        case ch_ShowRallyPoint:
            bShowRallyPoint = ch_ShowRallyPoint.IsChecked();
            break;
        case ch_UseTechnicalAmmoNames:
            bUseTechnicalAmmoNames = ch_UseTechnicalAmmoNames.IsChecked();
            break;
        default:
            super.InternalOnChange(Sender);
    }
}

defaultproperties
{
    Begin Object Class=DHmoCheckBox Name=GameHudSimpleColours
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Simple HUD Colours"
        OnCreateComponent=GameHudSimpleColours.InternalOnCreateComponent
        IniOption="@Internal"
        Hint="Red/Blue team HUD colours only, for colorblind players."
        WinTop=0.043906
        WinLeft=0.379297
        WinWidth=0.196875
        TabOrder=1
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_SimpleColours=DHmoCheckBox'DH_Interface.DHTab_Hud.GameHudSimpleColours'

    Begin Object Class=DHmoCheckBox Name=GameHudShowVehicleVisionCone
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Vehicle Vision Cone"
        OnCreateComponent=GameHudShowVehicleVisionCone.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.822959
        WinLeft=0.555313
        WinWidth=0.373749
        WinHeight=0.034156
        TabOrder=29
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_ShowVehicleVisionCone=DHmoCheckBox'DH_Interface.DHTab_Hud.GameHudShowVehicleVisionCone'

    Begin Object Class=DHmoCheckBox Name=ShowChatMessages
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Chat Messages"
        OnCreateComponent=ShowChatMessages.InternalOnCreateComponent
        IniOption="@Internal"
        Hint="Show chat messages from players and server. Messages can still be read in the console."
        WinTop=0.043906
        WinLeft=0.379297
        WinWidth=0.196875
        TabOrder=1
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_ShowChatMessages=DHmoCheckBox'DH_Interface.DHTab_Hud.ShowChatMessages'

    Begin Object Class=DHmoCheckBox Name=GameHudShowDeathMessages
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Death Messages"
        OnCreateComponent=GameHudShowDeathMessages.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.822959
        WinLeft=0.555313
        WinWidth=0.373749
        WinHeight=0.034156
        TabOrder=27
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_ShowDeathMessages=DHmoCheckBox'DH_Interface.DHTab_Hud.GameHudShowDeathMessages'

    Begin Object Class=DHmoCheckBox Name=GameHudShowIndicators
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Packet Loss Indicator"
        OnCreateComponent=GameHudShowIndicators.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.822959
        WinLeft=0.555313
        WinWidth=0.373749
        WinHeight=0.034156
        TabOrder=29
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_ShowIndicators=DHmoCheckBox'DH_Interface.DHTab_Hud.GameHudShowIndicators'

    Begin Object Class=DHmoCheckBox Name=ShowCompass
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Compass"
        OnCreateComponent=ShowCompass.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.481406
        WinLeft=0.555313
        WinWidth=0.373749
        TabOrder=23
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_ShowCompass=DHmoCheckBox'DH_Interface.DHTab_Hud.ShowCompass'

    Begin Object Class=DHmoCheckBox Name=ShowRallyPoint
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Squad Rally Point Status"
        OnCreateComponent=ShowRallyPoint.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.481406
        WinLeft=0.555313
        WinWidth=0.373749
        TabOrder=28
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_ShowRallyPoint=DHmoCheckBox'DH_Interface.DHTab_Hud.ShowRallyPoint'

    Begin Object Class=DHmoCheckBox Name=ShowMapFirstSpawn
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Map On Initial Spawn"
        OnCreateComponent=ShowMapFirstSpawn.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.481406
        WinLeft=0.555313
        WinWidth=0.373749
        TabOrder=24
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_ShowMapFirstSpawn=DHmoCheckBox'DH_Interface.DHTab_Hud.ShowMapFirstSpawn'

    Begin Object Class=DHmoCheckBox Name=UseNativeRoleNames
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Use Native Role Names"
        OnCreateComponent=UseNativeRoleNames.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.822959
        WinLeft=0.555313
        WinWidth=0.373749
        WinHeight=0.034156
        TabOrder=25
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_UseNativeRoleNames=DHmoCheckBox'DH_Interface.DHTab_Hud.UseNativeRoleNames'

    Begin Object Class=DHmoCheckBox Name=UseTechnicalAmmoNames
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Use Technical Ammo Names (Tanks/AT Guns)"
        OnCreateComponent=UseTechnicalAmmoNames.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.822959
        WinLeft=0.555313
        WinWidth=0.373749
        WinHeight=0.034156
        TabOrder=26
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_UseTechnicalAmmoNames=DHmoCheckBox'DH_Interface.DHTab_Hud.UseTechnicalAmmoNames'

    Begin Object Class=DHmoComboBox Name=HintsCombo
        ComponentJustification=TXTA_Left
        CaptionWidth=0.55
        Caption="Hint Level"
        OnCreateComponent=HintsCombo.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.335021
        WinLeft=0.547773
        WinWidth=0.401953
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    co_Hints=DHmoComboBox'DH_Interface.DHTab_Hud.HintsCombo'

    Begin Object Class=DHGUISectionBackground Name=GameBK
        Caption="Options"
        WinTop=0.18036
        WinLeft=0.521367
        WinWidth=0.448633
        WinHeight=0.49974
        RenderWeight=0.001
        OnPreDraw=GameBK.InternalPreDraw
    End Object
    i_BG1=DHGUISectionBackground'DH_Interface.DHTab_Hud.GameBK'

    Begin Object Class=DHGUISectionBackground Name=GameBK1
        Caption="Style"
        WinTop=0.179222
        WinLeft=0.03
        WinWidth=0.448633
        WinHeight=0.502806
        RenderWeight=0.001
        OnPreDraw=GameBK1.InternalPreDraw
    End Object
    i_BG2=DHGUISectionBackground'DH_Interface.DHTab_Hud.GameBK1'

    Begin Object Class=moSlider Name=myHudScale
        MaxValue=100.0
        MinValue=50.0
        Caption="HUD Scaling"
        LabelStyleName="DHLargeText"
        OnCreateComponent=myHudScale.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.5"
        WinTop=0.070522
        WinLeft=0.018164
        WinWidth=0.45
        TabOrder=22
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    sl_Scale=moSlider'DH_Interface.DHTab_Hud.myHudScale'

    Begin Object Class=moSlider Name=myGameHudOpacity
        MaxValue=100.0
        MinValue=51.0
        Caption="HUD Opacity"
        LabelStyleName="DHLargeText"
        OnCreateComponent=myGameHudOpacity.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.5"
        WinTop=0.070522
        WinLeft=0.018164
        WinWidth=0.45
        TabOrder=21
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    sl_Opacity=moSlider'DH_Interface.DHTab_Hud.myGameHudOpacity'

    Begin Object Class=DHmoNumericEdit Name=GameHudMessageCount
        MinValue=0
        MaxValue=8
        ComponentJustification=TXTA_Left
        CaptionWidth=0.7
        Caption="Max. Chat Count"
        OnCreateComponent=GameHudMessageCount.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.196875
        WinLeft=0.550781
        WinWidth=0.38125
        TabOrder=9
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    nu_MsgCount=DHmoNumericEdit'DH_Interface.DHTab_Hud.GameHudMessageCount'

    Begin Object Class=DHmoNumericEdit Name=GameHudMessageScale
        MinValue=0
        MaxValue=8
        ComponentJustification=TXTA_Left
        CaptionWidth=0.7
        Caption="Chat Font Size"
        OnCreateComponent=GameHudMessageScale.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.321874
        WinLeft=0.550781
        WinWidth=0.38125
        TabOrder=10
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    nu_MsgScale=DHmoNumericEdit'DH_Interface.DHTab_Hud.GameHudMessageScale'

    Begin Object Class=DHmoNumericEdit Name=GameHudMessageOffset
        MinValue=0
        MaxValue=4
        ComponentJustification=TXTA_Left
        CaptionWidth=0.7
        Caption="Message Font Offset"
        OnCreateComponent=GameHudMessageOffset.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.436457
        WinLeft=0.550781
        WinWidth=0.38125
        TabOrder=11
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    nu_MsgOffset=DHmoNumericEdit'DH_Interface.DHTab_Hud.GameHudMessageOffset'

    Begin Object Class=DHmoCheckBox Name=GameHudVisible
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Hide HUD"
        OnCreateComponent=GameHudVisible.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.043906
        WinLeft=0.379297
        WinWidth=0.196875
        TabOrder=0
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_Visible=DHmoCheckBox'DH_Interface.DHTab_Hud.GameHudVisible'

    Begin Object Class=DHmoCheckBox Name=GameHudShowWeaponInfo
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Weapon Info"
        OnCreateComponent=GameHudShowWeaponInfo.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.181927
        WinLeft=0.05
        WinWidth=0.378125
        TabOrder=3
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_Weapons=DHmoCheckBox'DH_Interface.DHTab_Hud.GameHudShowWeaponInfo'

    Begin Object Class=DHmoCheckBox Name=GameHudShowPersonalInfo
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9
        Caption="Show Personal Info"
        OnCreateComponent=GameHudShowPersonalInfo.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.317343
        WinLeft=0.05
        WinWidth=0.378125
        TabOrder=4
        OnChange=DHTab_Hud.InternalOnChange
        OnLoadINI=DHTab_Hud.InternalOnLoadINI
    End Object
    ch_Personal=DHmoCheckBox'DH_Interface.DHTab_Hud.GameHudShowPersonalInfo'
}
