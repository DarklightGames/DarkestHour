//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHTab_DetailSettings extends ROTab_DetailSettings;

function SetupPositions()
{
    super.SetupPositions();

    sb_Section2.UnmanageComponent(co_ScopeDetail);
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    RemoveComponent(co_ScopeDetail);
}

//Overrided to remove extra options for scope detail
function MyGetComboOptions(moComboBox Combo, out array<GUIListElem> Options)
{
    local int i;

    Options.Remove(0, Options.Length);

    if (Combo == none)
    {
        return;
    }

    switch (Combo)
    {
        case co_GlobalDetails:
            for (i = 0; i < arraycount(DetailOptions); ++i)
            {
                Options.Length = Options.Length + 1;
                Options[i].Item = DetailOptions[i];
            }
            break;
    }

    if (Options.Length == 0)
    {
        GetComboOptions(Combo, Options);
    }
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{
    local PlayerController PC;
    local string tempStr;
    local bool a, b;

    PC = PlayerOwner();

    switch (Sender)
    {
        case co_GlobalDetails:
            iGlobalDetails = class'ROPlayer'.default.GlobalDetailLevel;
            iGlobalDetailsD = iGlobalDetails;
            co_GlobalDetails.SilentSetIndex(iGlobalDetails);
            ch_Advanced.SetComponentValue(iGlobalDetailsD == MAX_DETAIL_OPTIONS, true);
            break;

        case ch_MotionBlur:
            bMotionBlur = bool(PC.ConsoleCommand("get ROEngine.ROPlayer bUseBlurEffect"));
            bMotionBlurD = bMotionBlur;
            ch_MotionBlur.SetComponentValue(bMotionBlur,true);
            break;

        case ch_HDR:
            bHDR = bool(PC.ConsoleCommand("get ini:Engine.Engine.ViewportManager Bloom"));
            bHDRD = bHDR;
            ch_HDR.SetComponentValue(bHDR,true);
            break;

        case ch_Advanced:
            break; // value is set by co_GlobalDetails

        // copied from UT2K4Tab_DetailSettings
        case co_Shadows:
            tempStr = GetNativeClassName("Engine.Engine.RenderDevice");

            // No render-to-texture on anything but Direct3D.
            if ((tempStr == "D3DDrv.D3DRenderDevice") ||
                (tempStr == "D3D9Drv.D3D9RenderDevice"))
            {
                a = bool(PC.ConsoleCommand("get ROEngine.ROPawn bPlayerShadows"));
                b = bool(PC.ConsoleCommand("get ROEngine.ROPawn bBlobShadow"));

                if (b)
                    iShadow = 1;
                else if (a)
                    iShadow = 2;
                else
                    iShadow = 0;
            }
            else
            {
                b = bool(PC.ConsoleCommand("get ROEngine.ROPawn bBlobShadow"));
                if (b)
                    iShadow = 1;
                else
                    iShadow = 0;
            }

            iShadowD = iShadow;
            co_Shadows.SilentSetIndex(iShadow);
            break;

        default:
            super(UT2K4Tab_DetailSettings).InternalOnLoadINI(sender, s);
    }

    // Post-super checks
    switch (Sender)
    {
        case co_RenderDevice:
            DisableHDRControlIfNeeded();

            // Disable control if card doesn't support hdr
            if (ROPlayer(PlayerOwner()) != none)
                if (!ROPlayer(PlayerOwner()).PostFX_IsBloomCapable())
                    ch_HDR.DisableMe();

            break;
    }
}

function InternalOnChange(GUIComponent Sender)
{
    local bool bGoingUp;
    local int i;

    super(UT2K4Tab_DetailSettings).InternalOnChange(Sender);

    if (bIgnoreChange)
        return;

    switch (Sender)
    {
        // These changes are saved together on SaveSettings
        case co_GlobalDetails:
            i = co_GlobalDetails.GetIndex();
            bGoingUp = i > iGlobalDetails && i != iGlobalDetailsD && (i != MAX_DETAIL_OPTIONS - 1);
            iGlobalDetails = i;
            //ch_Advanced.SetComponentValue(i == MAX_DETAIL_OPTIONS, true);
            UpdateGlobalDetails();
            break;

        case ch_MotionBlur:
            bMotionBlur = ch_MotionBlur.IsChecked();
            bGoingUp = bMotionBlur && bMotionBlur != bMotionBlurD;
            break;

        case ch_HDR:
            bHDR = ch_HDR.IsChecked();
            bGoingUp = bHDR && bHDR != bHDRD;
            break;

        case ch_Advanced:
            if (ch_Advanced.IsChecked())
            {
                iGlobalDetails = MAX_DETAIL_OPTIONS - 1;
                co_GlobalDetails.SilentSetIndex(iGlobalDetails);
            }
            UpdateGlobalDetailsVisibility();
            break;
    }

    if (bGoingUp)
        ShowPerformanceWarning();
}

function UpdateGlobalDetails()
{
    local PlayerController PC;
    PC = PlayerOwner();

    UpdateGlobalDetailsVisibility();

    if (iGlobalDetails == MAX_DETAIL_OPTIONS - 1)
        return; // do not change settings if we picked custom

    bShowPerfWarning = false;

    switch (iGlobalDetails)
    {
        case 0: // Lowest
            co_Texture.SetIndex(0);         // Range = 0 - 8
            co_Char.SetIndex(0);            // Range = 0 - 8
            co_World.SetIndex(0);           // Range = 0 - 2
            co_Physics.setindex(0);         // Range = 0 - 2
            co_Decal.setindex(0);           // Range = 0 - 2
            co_Shadows.setindex(0);         // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.setindex(0);         // Range = 0 - 3
            co_MultiSamples.setindex(0);
            co_Anisotropy.setindex(0);
            ch_ForceFSAAScreenshotSupport.SetComponentValue(false,false);
            ch_Decals.SetComponentValue(false, false);
            ch_DynLight.SetComponentValue(false, false);
            ch_Coronas.SetComponentValue(false, false);
            ch_Textures.SetComponentValue(false, false);
            ch_Projectors.SetComponentValue(false, false);
            ch_DecoLayers.SetComponentValue(false, false);
            ch_Trilinear.SetComponentValue(false, false);
            ch_Weather.SetComponentValue(false, false);
            ch_DecoLayers.SetComponentValue(false, false);
            ch_MotionBlur.SetComponentValue(true, false);
            sl_DistanceLOD.SetComponentValue(0.25, false); // Range = 0.0 - 1.0
            ch_HDR.SetComponentValue(false, false);
            break;

        case 1: // Low
            co_Texture.SetIndex(3);         // Range = 0 - 8
            co_Char.SetIndex(3);            // Range = 0 - 8
            co_World.SetIndex(0);           // Range = 0 - 2
            co_Physics.setindex(0);         // Range = 0 - 2
            co_Decal.setindex(1);           // Range = 0 - 2
            co_Shadows.setindex(1);         // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.setindex(1);         // Range = 0 - 3
            co_MultiSamples.setindex(0);

            if (AnisotropyModes.Length>1)
                 co_Anisotropy.SetIndex(1);
            else
                 co_Anisotropy.setindex(0);

            ch_ForceFSAAScreenshotSupport.SetComponentValue(false,false);
            ch_Decals.SetComponentValue(true, false);
            ch_DynLight.SetComponentValue(false, false);
            ch_Coronas.SetComponentValue(true, false);
            ch_Textures.SetComponentValue(false, false);
            ch_Projectors.SetComponentValue(true, false);
            ch_DecoLayers.SetComponentValue(true, false);
            ch_Trilinear.SetComponentValue(false, false);
            ch_Weather.SetComponentValue(true, false);
            ch_MotionBlur.SetComponentValue(true, false);
            sl_DistanceLOD.SetComponentValue(0.50, false); // Range = 0.0 - 1.0
            ch_HDR.SetComponentValue(false, false);
            break;

        case 2: // Medium
            co_Texture.SetIndex(5);         // Range = 0 - 8
            co_Char.SetIndex(5);            // Range = 0 - 8
            co_World.SetIndex(1);           // Range = 0 - 2
            co_Physics.setindex(1);         // Range = 0 - 2
            co_Decal.setindex(1);           // Range = 0 - 2
            co_Shadows.setindex(1);         // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.setindex(2);         // Range = 0 - 3
            co_MultiSamples.setindex(0);

            if (AnisotropyModes.Length>2)
                 co_Anisotropy.setindex(2);
            else if (AnisotropyModes.Length>1)
                 co_Anisotropy.SetIndex(1);
            else
                 co_Anisotropy.setindex(0);

            ch_ForceFSAAScreenshotSupport.SetComponentValue(false,false);
            ch_Decals.SetComponentValue(true, false);
            ch_DynLight.SetComponentValue(true, false);
            ch_Coronas.SetComponentValue(true, false);
            ch_Textures.SetComponentValue(true, false);
            ch_Projectors.SetComponentValue(true, false);
            ch_DecoLayers.SetComponentValue(true, false);
            ch_Trilinear.SetComponentValue(false, false);
            ch_Weather.SetComponentValue(true, false);
            ch_MotionBlur.SetComponentValue(true, false);
            sl_DistanceLOD.SetComponentValue(0.75, false); // Range = 0.0 - 1.0
            ch_HDR.SetComponentValue(false, false);
            break;

        case 3: // High
            co_Texture.SetIndex(6);         // Range = 0 - 8
            co_Char.SetIndex(6);            // Range = 0 - 8
            co_World.SetIndex(2);           // Range = 0 - 2
            co_Physics.setindex(1);         // Range = 0 - 2
            co_Decal.setindex(2);           // Range = 0 - 2
            co_Shadows.setindex(1);         // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.setindex(2);         // Range = 0 - 3
            co_MultiSamples.setindex(0);

            if (MultiSampleModes.Length>1)
                 co_MultiSamples.setindex(1);
            else
                 co_MultiSamples.setindex(0);

            if (AnisotropyModes.Length>3)
                 co_Anisotropy.setindex(3);
            else if (AnisotropyModes.Length>2)
                 co_Anisotropy.setindex(2);
            else if (AnisotropyModes.Length>1)
                 co_Anisotropy.SetIndex(1);
            else
                 co_Anisotropy.setindex(0);

            ch_ForceFSAAScreenshotSupport.SetComponentValue(false,false);
            ch_Decals.SetComponentValue(true, false);
            ch_DynLight.SetComponentValue(true, false);
            ch_Coronas.SetComponentValue(true, false);
            ch_Textures.SetComponentValue(true, false);
            ch_Projectors.SetComponentValue(true, false);
            ch_DecoLayers.SetComponentValue(true, false);
            ch_Trilinear.SetComponentValue(false, false);
            ch_Weather.SetComponentValue(true, false);
            ch_MotionBlur.SetComponentValue(true, false);
            sl_DistanceLOD.SetComponentValue(1.0, false); // Range = 0.0 - 1.0
            ch_HDR.SetComponentValue(true, false);
            break;

        case 4: // Higher
            co_Texture.SetIndex(7);         // Range = 0 - 8
            co_Char.SetIndex(7);            // Range = 0 - 8
            co_World.SetIndex(2);           // Range = 0 - 2
            co_Physics.setindex(1);         // Range = 0 - 2
            co_Decal.setindex(2);           // Range = 0 - 2
            co_Shadows.setindex(min(co_Shadows.ItemCount() - 1, 3));  // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.setindex(2);         // Range = 0 - 3

            if (MultiSampleModes.Length>2)
                 co_MultiSamples.setindex(2);
            else if (MultiSampleModes.Length>1)
                 co_MultiSamples.setindex(1);
            else
                 co_MultiSamples.setindex(0);

            if (AnisotropyModes.Length>3)
                 co_Anisotropy.setindex(3);
            else if (AnisotropyModes.Length>2)
                 co_Anisotropy.SetIndex(2);
            else if (AnisotropyModes.Length>1)
                 co_Anisotropy.SetIndex(1);
            else
                 co_Anisotropy.setindex(0);

            ch_ForceFSAAScreenshotSupport.SetComponentValue(true,false);
            ch_Decals.SetComponentValue(true, false);
            ch_DynLight.SetComponentValue(true, false);
            ch_Coronas.SetComponentValue(true, false);
            ch_Textures.SetComponentValue(true, false);
            ch_Projectors.SetComponentValue(true, false);
            ch_DecoLayers.SetComponentValue(true, false);
            ch_Trilinear.SetComponentValue(false, false);
            ch_Weather.SetComponentValue(true, false);
            ch_MotionBlur.SetComponentValue(true, false);
            sl_DistanceLOD.SetComponentValue(1.0, false); // Range = 0.0 - 1.0
            ch_HDR.SetComponentValue(true, false);
            break;

        case 5: // Highest
            co_Texture.SetIndex(8);         // Range = 0 - 8
            co_Char.SetIndex(8);            // Range = 0 - 8
            co_World.SetIndex(2);           // Range = 0 - 2
            co_Physics.setindex(2);         // Range = 0 - 2
            co_Decal.setindex(2);           // Range = 0 - 2
            co_Shadows.setindex(min(co_Shadows.ItemCount() - 1, 3));  // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.setindex(3);         // Range = 0 - 3

            if (
                  (
                      (true==bool(PC.ConsoleCommand("ISNVIDIAGPU")))
                       && (false==bool(PC.ConsoleCommand("SUPPORTEDMULTISAMPLE 4"))
                  )
                   || (false==bool(PC.ConsoleCommand("ISNVIDIAGPU"))))
                   && (MultiSampleModes.Length>3)
              )
                 co_MultiSamples.setindex(3);
            else if (MultiSampleModes.Length>2)
                 co_MultiSamples.setindex(2);
            else if (MultiSampleModes.Length>1)
                 co_MultiSamples.setindex(1);
            else
                 co_MultiSamples.setindex(0);

            co_Anisotropy.setindex(AnisotropyModes.Length-1);
            ch_ForceFSAAScreenshotSupport.SetComponentValue(true,false);
            ch_Decals.SetComponentValue(true, false);
            ch_DynLight.SetComponentValue(true, false);
            ch_Coronas.SetComponentValue(true, false);
            ch_Textures.SetComponentValue(true, false);
            ch_Projectors.SetComponentValue(true, false);
            ch_DecoLayers.SetComponentValue(true, false);
            ch_Trilinear.SetComponentValue(true, false);
            ch_Weather.SetComponentValue(true, false);
            ch_MotionBlur.SetComponentValue(true, false);
            sl_DistanceLOD.SetComponentValue(1.0, false); // Range = 0.0 - 1.0
            ch_HDR.SetComponentValue(true, false);
            break;
    }

    bShowPerfWarning = true;
}

function SaveSettings()
{
    local PlayerController PC;
    local bool bSavePlayerConfig;

    super(UT2K4Tab_DetailSettings).SaveSettings();

    PC = PlayerOwner();

    if (bMotionBlur != bMotionBlurD)
    {
        class'ROEngine.ROPlayer'.default.bUseBlurEffect = bMotionBlur;
        bSavePlayerConfig = true;

        if (ROPlayer(PC) != none)
            ROPlayer(PC).bUseBlurEffect = bMotionBlur;

        bMotionBlurD = bMotionBlur;
    }

    if (bHDR != bHDRD)
    {
        PC.ConsoleCommand("set ini:Engine.Engine.ViewportManager Bloom"@bHDR);

        if (ROPlayer(PC) != none)
        {
            ROPlayer(PC).PostFX_SetActive(0, bHDR);
        }

        bHDRD = bHDR;
    }

    if (iGlobalDetails != iGlobalDetailsD)
    {
        class'ROEngine.ROPlayer'.default.GlobalDetailLevel = iGlobalDetails;
        bSavePlayerConfig = true;

        iGlobalDetailsD = iGlobalDetails;
    }

    if (iShadow != iShadowD)
    {
        if (PC.Pawn != none && ROPawn(PC.Pawn) != none)
        {
            ROPawn(PC.Pawn).bBlobShadow = iShadow == 1;
            ROPawn(PC.Pawn).bPlayerShadows = iShadow > 0;
        }

        class'ROPawn'.default.bBlobShadow = iShadow == 1;
        class'ROPawn'.default.bPlayerShadows = iShadow > 0;
        iShadowD = iShadow;

        if (PC.Pawn != none && ROPawn(PC.Pawn) != none)
            ROPawn(PC.Pawn).SaveConfig();
        else
            class'ROPawn'.static.StaticSaveConfig();

        UpdateShadows(iShadow == 1, iShadow > 0);
    }

    if (class'Vehicle'.default.bVehicleShadows != (iShadow > 0))
    {
        class'Vehicle'.default.bVehicleShadows = iShadow > 0;
        class'Vehicle'.static.StaticSaveConfig();
        UpdateVehicleShadows(iShadow > 0);
    }

    if (bSavePlayerConfig)
       class'ROEngine.ROPlayer'.static.StaticSaveConfig();
}

defaultproperties
{
    DisplayModes(0)=(Width=1280,Height=720)
    DisplayModes(1)=(Width=1024,Height=768)
    DisplayModes(2)=(Width=1280,Height=768)
    DisplayModes(3)=(Width=1360,Height=768)
    DisplayModes(4)=(Width=1366,Height=768)
    DisplayModes(5)=(Width=1280,Height=800)
    DisplayModes(6)=(Width=1152,Height=864)
    DisplayModes(7)=(Width=1536,Height=864)
    DisplayModes(8)=(Width=1440,Height=900)
    DisplayModes(9)=(Width=1600,Height=900)
    DisplayModes(10)=(Width=1280,Height=960)
    DisplayModes(11)=(Width=1280,Height=1024)
    DisplayModes(12)=(Width=1680,Height=1050)
    DisplayModes(13)=(Width=1920,Height=1080)
    DisplayModes(14)=(Width=1600,Height=1200)
    DisplayModes(15)=(Width=1920,Height=1200)
    DisplayModes(16)=(Width=2560,Height=1440)
    Begin Object Class=DHmoComboBox Name=GlobalDetails
        ComponentJustification=TXTA_Left
        CaptionWidth=0.55
        Caption="Game details"
        OnCreateComponent=GlobalDetails.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Higher"
        WinTop=0.063021
        WinLeft=0.55
        WinWidth=0.4
        TabOrder=2
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_GlobalDetails=DHmoComboBox'DH_Interface.DHTab_DetailSettings.GlobalDetails'
    Begin Object Class=DHmoCheckBox Name=HDRCheckbox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="HDR Bloom"
        OnCreateComponent=HDRCheckbox.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.479308
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=13
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_HDR=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.HDRCheckbox'
    Begin Object Class=DHmoCheckBox Name=Advanced
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Show Advanced Options"
        OnCreateComponent=Advanced.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.479308
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=2
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Advanced=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.Advanced'
    Begin Object Class=DHmoCheckBox Name=MotionBlur
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Motion Blur"
        OnCreateComponent=MotionBlur.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.479308
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=13
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_MotionBlur=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.MotionBlur'
    Begin Object Class=DHGUISectionBackground Name=sbSection1
        Caption="Resolution"
        WinTop=0.004
        WinLeft=0.022
        WinWidth=0.485
        WinHeight=0.540729
        RenderWeight=0.01
        OnPreDraw=sbSection1.InternalPreDraw
    End Object
    sb_Section1=DHGUISectionBackground'DH_Interface.DHTab_DetailSettings.sbSection1'
    Begin Object Class=DHGUISectionBackground Name=sbSection2
        Caption="Options"
        WinTop=0.004
        WinLeft=0.53
        WinWidth=0.452751
        WinHeight=0.875228
        RenderWeight=0.01
        OnPreDraw=sbSection2.InternalPreDraw
    End Object
    sb_Section2=DHGUISectionBackground'DH_Interface.DHTab_DetailSettings.sbSection2'
    Begin Object Class=DHGUISectionBackground Name=sbSection3
        bFillClient=true
        Caption="Gamma Test"
        ImageOffset(3)=10.0
        WinTop=0.562
        WinLeft=0.022
        WinWidth=0.485
        WinHeight=0.411928
        RenderWeight=0.01
        OnPreDraw=sbSection3.InternalPreDraw
    End Object
    sb_Section3=DHGUISectionBackground'DH_Interface.DHTab_DetailSettings.sbSection3'
    Begin Object Class=GUIImage Name=GammaBar
        Image=texture'DH_GUI_Tex.Menu.DHGammaSet'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Normal
        OnChange=DHTab_DetailSettings.InternalOnChange
    End Object
    i_GammaBar=GUIImage'DH_Interface.DHTab_DetailSettings.GammaBar'
    Begin Object Class=DHmoComboBox Name=DetailTextureDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Texture Detail"
        OnCreateComponent=DetailTextureDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        WinTop=0.063021
        WinLeft=0.55
        WinWidth=0.4
        TabOrder=7
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Texture=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailTextureDetail'
    Begin Object Class=DHmoComboBox Name=DetailCharacterDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Character Detail"
        OnCreateComponent=DetailCharacterDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        WinTop=0.116667
        WinLeft=0.55
        WinWidth=0.4
        TabOrder=8
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Char=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailCharacterDetail'
    Begin Object Class=DHmoComboBox Name=DetailWorldDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="World Detail"
        OnCreateComponent=DetailWorldDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        WinTop=0.170312
        WinLeft=0.55
        WinWidth=0.4
        TabOrder=9
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_World=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailWorldDetail'
    Begin Object Class=DHmoComboBox Name=DetailPhysics
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Physics Detail"
        OnCreateComponent=DetailPhysics.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        WinTop=0.223958
        WinLeft=0.55
        WinWidth=0.4
        TabOrder=10
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Physics=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailPhysics'
    Begin Object Class=DHmoComboBox Name=DetailDecalStay
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Decal Stay"
        OnCreateComponent=DetailDecalStay.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Normal"
        WinTop=0.282032
        WinLeft=0.55
        WinWidth=0.4
        TabOrder=12
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Decal=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailDecalStay'
    Begin Object Class=DHmoComboBox Name=MeshLOD
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Dynamic Mesh LOD"
        OnCreateComponent=MeshLOD.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.223958
        WinLeft=0.55
        WinWidth=0.4
        TabOrder=11
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_MeshLOD=DHmoComboBox'DH_Interface.DHTab_DetailSettings.MeshLOD'
    Begin Object Class=DHmoComboBox Name=VideoResolution
        bReadOnly=true
        CaptionWidth=0.55
        Caption="Resolution"
        OnCreateComponent=VideoResolution.InternalOnCreateComponent
        IniOption="@INTERNAL"
        IniDefault="640x480"
        WinTop=0.060417
        WinLeft=0.030508
        WinWidth=0.39
        TabOrder=1
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Resolution=DHmoComboBox'DH_Interface.DHTab_DetailSettings.VideoResolution'
    Begin Object Class=DHmoComboBox Name=VideoColorDepth
        CaptionWidth=0.55
        Caption="Color Depth"
        OnCreateComponent=VideoColorDepth.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.117188
        WinLeft=0.030234
        WinWidth=0.39
        TabOrder=2
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_ColorDepth=DHmoComboBox'DH_Interface.DHTab_DetailSettings.VideoColorDepth'
    Begin Object Class=DHmoComboBox Name=RenderDeviceCombo
        ComponentJustification=TXTA_Left
        CaptionWidth=0.55
        Caption="Render Device"
        OnCreateComponent=RenderDeviceCombo.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.335021
        WinLeft=0.547773
        WinWidth=0.401953
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_RenderDevice=DHmoComboBox'DH_Interface.DHTab_DetailSettings.RenderDeviceCombo'
    Begin Object Class=DHmoComboBox Name=DetailCharacterShadows
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Character Shadows"
        OnCreateComponent=DetailCharacterShadows.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.431378
        WinLeft=0.6
        WinWidth=0.3
        TabOrder=13
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Shadows=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailCharacterShadows'
    Begin Object Class=DHmoComboBox Name=DetailAntialiasing
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Antialiasing"
        OnCreateComponent=DetailAntialiasing.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.45
        WinLeft=0.55
        WinWidth=0.4
        TabOrder=12
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_MultiSamples=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailAntialiasing'
    Begin Object Class=DHmoComboBox Name=DetailAnisotropy
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Anisotropic Filtering"
        OnCreateComponent=DetailAnisotropy.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.48
        WinLeft=0.6
        WinWidth=0.4
        TabOrder=12
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Anisotropy=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailAnisotropy'
    Begin Object Class=DHmoCheckBox Name=DetailDecals
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Decals"
        OnCreateComponent=DetailDecals.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.479308
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=14
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Decals=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDecals'
    Begin Object Class=DHmoCheckBox Name=DetailDynamicLighting
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Dynamic Lighting"
        OnCreateComponent=DetailDynamicLighting.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.526716
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=15
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_DynLight=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDynamicLighting'
    Begin Object Class=DHmoCheckBox Name=DetailCoronas
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Coronas"
        OnCreateComponent=DetailCoronas.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.624136
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=17
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Coronas=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailCoronas'
    Begin Object Class=DHmoCheckBox Name=DetailDetailTextures
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Detail Textures"
        OnCreateComponent=DetailDetailTextures.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.575425
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=16
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Textures=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDetailTextures'
    Begin Object Class=DHmoCheckBox Name=DetailProjectors
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Projectors"
        OnCreateComponent=DetailProjectors.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.721195
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=19
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Projectors=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailProjectors'
    Begin Object Class=DHmoCheckBox Name=DetailDecoLayers
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Foliage"
        OnCreateComponent=DetailDecoLayers.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.769906
        WinLeft=0.599727
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=20
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_DecoLayers=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDecoLayers'
    Begin Object Class=DHmoCheckBox Name=DetailTrilinear
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Trilinear Filtering"
        OnCreateComponent=DetailTrilinear.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.673263
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=18
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Trilinear=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailTrilinear'
    Begin Object Class=DHmoCheckBox Name=VideoFullScreen
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Full Screen"
        OnCreateComponent=VideoFullScreen.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.169531
        WinLeft=0.030976
        WinWidth=0.3875
        TabOrder=3
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_FullScreen=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.VideoFullScreen'
    Begin Object Class=DHmoCheckBox Name=WeatherEffects
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Weather Effects"
        OnCreateComponent=WeatherEffects.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.86491
        WinLeft=0.599727
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=21
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Weather=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.WeatherEffects'
    Begin Object Class=DHmoCheckBox Name=DetailForceFSAASS
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Force FSAA Screenshots"
        OnCreateComponent=DetailForceFSAASS.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.499308
        WinLeft=0.6
        WinWidth=0.3
        WinHeight=0.04
        TabOrder=12
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_ForceFSAAScreenshotSupport=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailForceFSAASS'
    Begin Object Class=moSlider Name=GammaSlider
        MaxValue=2.5
        MinValue=0.5
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.55
        Caption="Gamma"
        LabelStyleName="DHLargeText"
        OnCreateComponent=GammaSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.8"
        WinTop=0.272918
        WinLeft=0.012501
        WinWidth=0.461133
        TabOrder=5
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Gamma=moSlider'DH_Interface.DHTab_DetailSettings.GammaSlider'
    Begin Object Class=moSlider Name=BrightnessSlider
        MaxValue=1.0
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.55
        Caption="Brightness"
        LabelStyleName="DHLargeText"
        OnCreateComponent=BrightnessSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.8"
        WinTop=0.229951
        WinLeft=0.012188
        WinWidth=0.461445
        TabOrder=4
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Brightness=moSlider'DH_Interface.DHTab_DetailSettings.BrightnessSlider'
    Begin Object Class=moSlider Name=ContrastSlider
        MaxValue=1.0
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.55
        Caption="Contrast"
        LabelStyleName="DHLargeText"
        OnCreateComponent=ContrastSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.8"
        WinTop=0.313285
        WinLeft=0.012188
        WinWidth=0.461133
        TabOrder=6
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Contrast=moSlider'DH_Interface.DHTab_DetailSettings.ContrastSlider'
    Begin Object Class=moSlider Name=DistanceLODSlider
        MaxValue=1.0
        Value=0.5
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.65
        Caption="Fog Distance"
        LabelStyleName="DHLargeText"
        OnCreateComponent=DistanceLODSlider.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.91
        WinLeft=0.56
        WinWidth=0.4
        TabOrder=22
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_DistanceLOD=moSlider'DH_Interface.DHTab_DetailSettings.DistanceLODSlider'
}
