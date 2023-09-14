//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTab_DetailSettings extends ROTab_DetailSettings;

var automated moCheckBox        ch_DynamicFogRatio;
var bool                        bUseDynamicFogRatio;

var automated moCheckBox        ch_UseVSync;
var bool                        bUseVSync;              // The optional variable already exists as UseVSync under D3DDrv.RENDERDEVICE

var automated moNumericEdit     nu_MinDesiredFPS;
var int                         NumMinDesiredFPS;

var automated moSlider          sl_CorpseStayTime;
var int                         CorpseStayNum;

var bool                        bIsUpdatingGameDetails; // When true, we are in the process of updating all of the options via the Game details option

function SetupPositions()
{
    super.SetupPositions();

    sb_Section1.UnmanageComponent(ch_Advanced);
    sb_Section1.ManageComponent(ch_UseVSync);

    sb_Section2.ManageComponent(ch_DynamicFogRatio);
    sb_Section2.ManageComponent(nu_MinDesiredFPS);
    sb_Section2.ManageComponent(sl_DistanceLOD);
    sb_Section2.ManageComponent(sl_CorpseStayTime);
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super(UT2K4Tab_DetailSettings).InitComponent(MyController, MyOwner);

    RemoveComponent(ch_Advanced);
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

        case co_ScopeDetail:
            for (i = 0; i < arraycount(ScopeLevels); ++i)
            {
                Options.Length = Options.Length + 1;
                Options[i].Item = ScopeLevels[i];
            }
            break;

        case co_Decal:
            Options.Length = 6;
            Options[0].Item = DetailLevels[3];
            Options[1].Item = DetailLevels[4];
            Options[2].Item = DetailLevels[5];
            Options[3].Item = DetailLevels[6];
            Options[4].Item = DetailLevels[7];
            Options[5].Item = DetailLevels[8];
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
    local string TempStr;
    local bool bPlayerShadows, bBlobShadows;

    PC = PlayerOwner();

    switch (Sender)
    {
        case co_GlobalDetails:
            iGlobalDetails = class'ROPlayer'.default.GlobalDetailLevel;
            iGlobalDetailsD = iGlobalDetails;
            co_GlobalDetails.SilentSetIndex(iGlobalDetails);
            break;

        case co_ScopeDetail:
            switch (class'DHWeapon'.default.ScopeDetail)
            {
                case RO_ModelScope:
                    iScopeDetail = 0;
                    break;

                case RO_TextureScope:
                    iScopeDetail = 1;
                    break;

                case RO_ModelScopeHigh:
                    iScopeDetail = 2;
                    break;

                default:
                    iScopeDetail = -1;
            }

            iScopeDetailD = iScopeDetail;

            if (iScopeDetail < 0)
            {
                co_ScopeDetail.SilentSetIndex(0);
            }
            else
            {
                co_ScopeDetail.SilentSetIndex(iScopeDetail);
            }
            break;

        case ch_UseVSync:
            bUseVSync = bool(PC.ConsoleCommand("get" @ co_RenderDevice.GetComponentValue() @ "UseVSync")); // Get the UseVSync value for the current render device
            ch_UseVSync.SetComponentValue(bUseVSync,true);
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
            break;

        // Copied from UT2K4Tab_DetailSettings
        case co_Shadows:
            TempStr = GetNativeClassName("Engine.Engine.RenderDevice");

            // No render-to-texture on anything but Direct3D
            if (TempStr == "D3DDrv.D3DRenderDevice" || TempStr == "D3D9Drv.D3D9RenderDevice")
            {
                bPlayerShadows = bool(PC.ConsoleCommand("get ROEngine.ROPawn bPlayerShadows"));
                bBlobShadows = bool(PC.ConsoleCommand("get ROEngine.ROPawn bBlobShadow"));

                if (bBlobShadows)
                {
                    iShadow = 1;
                }
                else if (bPlayerShadows)
                {
                    iShadow = 2;
                }
                else
                {
                    iShadow = 0;
                }
            }
            else
            {
                bBlobShadows = bool(PC.ConsoleCommand("get ROEngine.ROPawn bBlobShadow"));

                if (bBlobShadows)
                {
                    iShadow = 1;
                }
                else
                {
                    iShadow = 0;
                }
            }

            iShadowD = iShadow;
            co_Shadows.SilentSetIndex(iShadow);
            break;

        case sl_CorpseStayTime:
            CorpseStayNum = class'DHPlayer'.default.CorpseStayTime;
            sl_CorpseStayTime.SetComponentValue(CorpseStayNum, true);
            break;

        case ch_DynamicFogRatio:
            bUseDynamicFogRatio = bool(PlayerOwner().ConsoleCommand("get DH_Engine.DHPlayer bDynamicFogRatio", false));
            ch_DynamicFogRatio.SetComponentValue(bUseDynamicFogRatio, true);
            break;

        case nu_MinDesiredFPS:
            NumMinDesiredFPS = int(PlayerOwner().ConsoleCommand("get DH_Engine.DHPlayer MinDesiredFPS", false));
            nu_MinDesiredFPS.SetComponentValue(NumMinDesiredFPS, true);
            break;

        default:
            super(UT2K4Tab_DetailSettings).InternalOnLoadINI(sender, s);
    }

    // Post-super checks
    switch (Sender)
    {
        case co_Decal:
            switch (class'LevelInfo'.default.DecalStayScale)
            {
                case 0.0:
                    iDecal = 0;
                    break;
                case 1.0:
                    iDecal = 1;
                    break;
                case 2.0:
                    iDecal = 2;
                    break;
                case 4.0:
                    iDecal = 3;
                    break;
                case 8.0:
                    iDecal = 4;
                    break;
                case 16.0:
                    iDecal = 5;
                    break;
                default:
                    iDecal = 2;
                    break;
            }

            iDecalD = iDecal;
            co_Decal.SilentSetIndex(iDecal);
            break;

        case co_RenderDevice:
            DisableHDRControlIfNeeded();

            // Disable control if card doesn't support hdr
            if (ROPlayer(PlayerOwner()) != none && !ROPlayer(PlayerOwner()).PostFX_IsBloomCapable())
            {
                ch_HDR.DisableMe();
            }

            break;
    }
}

function InternalOnChange(GUIComponent Sender)
{
    local bool bGoingUp;
    local int i;

    if (!bIsUpdatingGameDetails)
    {
        switch (Sender)
        {
            case co_GlobalDetails:
            case co_Resolution:
            case co_ColorDepth:
            case co_RenderDevice:
            case sl_Contrast:
            case sl_Gamma:
            case sl_Brightness:
            case ch_FullScreen:
                break;
            default:
                co_GlobalDetails.SilentSetIndex(MAX_DETAIL_OPTIONS - 1);
                iGlobalDetails = MAX_DETAIL_OPTIONS - 1;
        }
    }

    super(UT2K4Tab_DetailSettings).InternalOnChange(Sender);

    if (bIgnoreChange)
    {
        return;
    }

    switch (Sender)
    {
        // These changes are saved together on SaveSettings
        case co_GlobalDetails:
            i = co_GlobalDetails.GetIndex();
            bGoingUp = i > iGlobalDetails && i != iGlobalDetailsD && (i != MAX_DETAIL_OPTIONS - 1);
            iGlobalDetails = i;
            UpdateGlobalDetails();
            break;

        case co_ScopeDetail:
            i = co_ScopeDetail.GetIndex();
            bGoingUp = i > iScopeDetail && i != iScopeDetailD;
            iScopeDetail = i;
            break;

        case ch_UseVSync:
            bUseVSync = ch_UseVSync.IsChecked();
            PlayerOwner().ConsoleCommand("set" @ co_RenderDevice.GetComponentValue() @ "UseVSync" @ bUseVSync);
            bGoingUp = bUseVSync;
            break;

        case ch_MotionBlur:
            bMotionBlur = ch_MotionBlur.IsChecked();
            bGoingUp = bMotionBlur && bMotionBlur != bMotionBlurD;
            break;

        case ch_HDR:
            bHDR = ch_HDR.IsChecked();
            bGoingUp = bHDR && bHDR != bHDRD;
            break;

        case co_Decal:
            switch (co_Decal.GetIndex())
            {
                case 0:
                    iDecal = 0.0;
                    break;
                case 1:
                    iDecal = 1.0;
                    break;
                case 2:
                    iDecal = 2.0;
                    break;
                case 3:
                    iDecal = 4.0;
                    break;
                case 4:
                    iDecal = 8.0;
                    break;
                case 5:
                    iDecal = 16.0;
                    break;
            }
            break;

        case sl_CorpseStayTime:
            CorpseStayNum = int(sl_CorpseStayTime.GetComponentValue());
            PlayerOwner().ConsoleCommand("set DH_Engine.DHPlayer CorpseStayTime" @ CorpseStayNum);
            break;

        case ch_DynamicFogRatio:
            bUseDynamicFogRatio = bool(ch_DynamicFogRatio.GetComponentValue());
            PlayerOwner().ConsoleCommand("set DH_Engine.DHPlayer bDynamicFogRatio" @ bUseDynamicFogRatio);

            // If we are turning the DynamicFogRatio off, then update the current LODDistance to the setting of the fog distance slider
            // From UScript, we cannot get the current LODDistance setting, we can get the INI setting, but not the current used value
            // So instead, the optimal approach is to just have the current LODDistance value match the fog slider when this setting is turned off
            if (PlayerOwner().Level != none && !bUseDynamicFogRatio)
            {
                PlayerOwner().Level.UpdateDistanceFogLOD(fDistance);
            }
            break;

        case nu_MinDesiredFPS:
            NumMinDesiredFPS = int(nu_MinDesiredFPS.GetComponentValue());
            PlayerOwner().ConsoleCommand("set DH_Engine.DHPlayer MinDesiredFPS" @ NumMinDesiredFPS);
            break;
    }

    if (bGoingUp)
    {
        ShowPerformanceWarning();
    }
}

function UpdateGlobalDetails()
{
    local PlayerController PC;

    PC = PlayerOwner();

    UpdateGlobalDetailsVisibility();

    if (iGlobalDetails == MAX_DETAIL_OPTIONS - 1)
    {
        return; // do not change settings if we picked custom
    }

    bShowPerfWarning = false;
    bIsUpdatingGameDetails = true;

    switch (iGlobalDetails)
    {
        case 0: // Lowest
            co_Texture.SetIndex(0);         // Range = 0 - 8
            co_Char.SetIndex(0);            // Range = 0 - 8
            co_World.SetIndex(0);           // Range = 0 - 2
            co_ScopeDetail.SetIndex(1);     // Range = 0 - 2 , 1 being lowest
            co_Physics.SetIndex(0);         // Range = 0 - 2
            co_Decal.SetIndex(0);           // Range = 0 - 5
            co_Shadows.SetIndex(0);         // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.SetIndex(0);         // Range = 0 - 3
            co_MultiSamples.SetIndex(0);
            co_Anisotropy.SetIndex(0);
            ch_ForceFSAAScreenshotSupport.SetComponentValue(false, false);
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
            fDistance = 0.25;
            ch_HDR.SetComponentValue(false, false);
            break;

        case 1: // Low
            co_Texture.SetIndex(3);         // Range = 0 - 8
            co_Char.SetIndex(3);            // Range = 0 - 8
            co_World.SetIndex(0);           // Range = 0 - 2
            co_ScopeDetail.SetIndex(1);     // Range = 0 - 2 , 1 being lowest
            co_Physics.SetIndex(0);         // Range = 0 - 2
            co_Decal.SetIndex(1);           // Range = 0 - 5
            co_Shadows.SetIndex(1);         // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.SetIndex(1);         // Range = 0 - 3
            co_MultiSamples.SetIndex(0);

            if (AnisotropyModes.Length > 1)
            {
                co_Anisotropy.SetIndex(1);
            }
            else
            {
                co_Anisotropy.SetIndex(0);
            }

            ch_ForceFSAAScreenshotSupport.SetComponentValue(false, false);
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
            fDistance = 0.5;
            ch_HDR.SetComponentValue(false, false);
            break;

        case 2: // Medium
            co_Texture.SetIndex(5);         // Range = 0 - 8
            co_Char.SetIndex(5);            // Range = 0 - 8
            co_World.SetIndex(1);           // Range = 0 - 2
            co_ScopeDetail.SetIndex(1);     // Range = 0 - 2 , 1 being lowest
            co_Physics.SetIndex(1);         // Range = 0 - 2
            co_Decal.SetIndex(2);           // Range = 0 - 5
            co_Shadows.SetIndex(1);         // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.SetIndex(2);         // Range = 0 - 3
            co_MultiSamples.SetIndex(0);

            if (AnisotropyModes.Length > 2)
            {
                co_Anisotropy.SetIndex(2);
            }
            else if (AnisotropyModes.Length > 1)
            {
                co_Anisotropy.SetIndex(1);
            }
            else
            {
                co_Anisotropy.SetIndex(0);
            }

            ch_ForceFSAAScreenshotSupport.SetComponentValue(false, false);
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
            fDistance = 0.75;
            ch_HDR.SetComponentValue(false, false);
            break;

        case 3: // High
            co_Texture.SetIndex(6);         // Range = 0 - 8
            co_Char.SetIndex(6);            // Range = 0 - 8
            co_World.SetIndex(2);           // Range = 0 - 2
            co_ScopeDetail.SetIndex(0);     // Range = 0 - 2 , 1 being lowest
            co_Physics.SetIndex(1);         // Range = 0 - 2
            co_Decal.SetIndex(3);           // Range = 0 - 5
            co_Shadows.SetIndex(1);         // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.SetIndex(2);         // Range = 0 - 3
            co_MultiSamples.SetIndex(0);

            if (MultiSampleModes.Length > 1)
            {
                co_MultiSamples.SetIndex(1);
            }
            else
            {
                co_MultiSamples.SetIndex(0);
            }

            if (AnisotropyModes.Length > 3)
            {
                co_Anisotropy.SetIndex(3);
            }
            else if (AnisotropyModes.Length > 2)
            {
                co_Anisotropy.SetIndex(2);
            }
            else if (AnisotropyModes.Length > 1)
            {
                co_Anisotropy.SetIndex(1);
            }
            else
            {
                co_Anisotropy.SetIndex(0);
            }

            ch_ForceFSAAScreenshotSupport.SetComponentValue(false, false);
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
            fDistance = 1.0;
            ch_HDR.SetComponentValue(true, false);
            break;

        case 4: // Higher
            co_Texture.SetIndex(7);         // Range = 0 - 8
            co_Char.SetIndex(7);            // Range = 0 - 8
            co_World.SetIndex(2);           // Range = 0 - 2
            co_ScopeDetail.SetIndex(2);     // Range = 0 - 2 , 1 being lowest
            co_Physics.SetIndex(1);         // Range = 0 - 2
            co_Decal.SetIndex(4);           // Range = 0 - 5
            co_Shadows.SetIndex(min(co_Shadows.ItemCount() - 1, 3));  // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.SetIndex(2);         // Range = 0 - 3

            if (MultiSampleModes.Length > 2)
            {
                co_MultiSamples.SetIndex(2);
            }
            else if (MultiSampleModes.Length > 1)
            {
                co_MultiSamples.SetIndex(1);
            }
            else
            {
                co_MultiSamples.SetIndex(0);
            }

            if (AnisotropyModes.Length > 3)
            {
                co_Anisotropy.SetIndex(3);
            }
            else if (AnisotropyModes.Length > 2)
            {
                co_Anisotropy.SetIndex(2);
            }
            else if (AnisotropyModes.Length > 1)
            {
                co_Anisotropy.SetIndex(1);
            }
            else
            {
                co_Anisotropy.SetIndex(0);
            }

            ch_ForceFSAAScreenshotSupport.SetComponentValue(true, false);
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
            fDistance = 1.0;
            ch_HDR.SetComponentValue(true, false);
            break;

        case 5: // Highest
            co_Texture.SetIndex(8);         // Range = 0 - 8
            co_Char.SetIndex(8);            // Range = 0 - 8
            co_World.SetIndex(2);           // Range = 0 - 2
            co_ScopeDetail.SetIndex(2);     // Range = 0 - 2 , 1 being lowest
            co_Physics.SetIndex(2);         // Range = 0 - 2
            co_Decal.SetIndex(5);           // Range = 0 - 5
            co_Shadows.SetIndex(min(co_Shadows.ItemCount() - 1, 3));  // Range = 0 - 2 (0 - 1 sometimes -- check that!)
            co_MeshLOD.SetIndex(3);         // Range = 0 - 3

            if (((bool(PC.ConsoleCommand("ISNVIDIAGPU"))) && (!bool(PC.ConsoleCommand("SUPPORTEDMULTISAMPLE 4"))) || (!bool(PC.ConsoleCommand("ISNVIDIAGPU"))))
                && (MultiSampleModes.Length > 3))
            {
                co_MultiSamples.SetIndex(3);
            }
            else if (MultiSampleModes.Length > 2)
            {
                co_MultiSamples.SetIndex(2);
            }
            else if (MultiSampleModes.Length > 1)
            {
                co_MultiSamples.SetIndex(1);
            }
            else
            {
                co_MultiSamples.SetIndex(0);
            }

            co_Anisotropy.SetIndex(AnisotropyModes.Length - 1);
            ch_ForceFSAAScreenshotSupport.SetComponentValue(true, false);
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
            fDistance = 1.0;
            ch_HDR.SetComponentValue(true, false);
            break;
    }

    bIsUpdatingGameDetails = false;
    bShowPerfWarning = true;
}

// Modified to simply always show the advanced options.
function UpdateGlobalDetailsVisibility()
{
    sb_Section2.EnableMe();
    DisableHDRControlIfNeeded();

    if (co_RenderDevice.GetExtra() != RenderMode[0])
    {
       co_MultiSamples.DisableMe();
       ch_ForceFSAAScreenshotSupport.DisableMe();
    }
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
        {
            ROPlayer(PC).bUseBlurEffect = bMotionBlur;
        }

        bMotionBlurD = bMotionBlur;
    }

    if (bHDR != bHDRD)
    {
        PC.ConsoleCommand("set ini:Engine.Engine.ViewportManager Bloom" @ bHDR);

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

    if (iScopeDetail != iScopeDetailD)
    {
        class'DH_Engine.DHWeapon'.default.ScopeDetail = ScopeDetailSettings(iScopeDetail);
        class'DH_Engine.DHWeapon'.static.StaticSaveConfig();

        if (PC.Pawn != none && PC.Pawn.Weapon != none && DHWeapon(PC.Pawn.Weapon) != none)
        {
            DHWeapon(PC.Pawn.Weapon).ScopeDetail = class'DH_Engine.DHWeapon'.default.ScopeDetail;
            DHWeapon(PC.Pawn.Weapon).AdjustIngameScope();
        }

        iScopeDetailD = iScopeDetail;
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
        {
            ROPawn(PC.Pawn).SaveConfig();
        }
        else
        {
            class'ROPawn'.static.StaticSaveConfig();
        }

        UpdateShadows(iShadow == 1, iShadow > 0);
    }

    if (class'Vehicle'.default.bVehicleShadows != iShadow > 0)
    {
        class'Vehicle'.default.bVehicleShadows = iShadow > 0;
        class'Vehicle'.static.StaticSaveConfig();
        UpdateVehicleShadows(iShadow > 0);
    }

    if (int(PC.ConsoleCommand("get ini:DH_Engine.DHPlayer CorpseStayTime")) != CorpseStayNum)
    {
        PC.ConsoleCommand("set ini:DH_Engine.DHPlayer CorpseStayTime" @ CorpseStayNum);
        bSavePlayerConfig = true;
    }

    if (bool(PC.ConsoleCommand("get DH_Engine.DHPlayer bDynamicFogRatio")) != bUseDynamicFogRatio)
    {
        PC.ConsoleCommand("set ini:DH_Engine.DHPlayer bDynamicFogRatio" @ bUseDynamicFogRatio);
        PC.ConsoleCommand("set DH_Engine.DHPlayer bDynamicFogRatio" @ bUseDynamicFogRatio);

        if (DHPlayer(PC) != none)
        {
            DHPlayer(PC).bDynamicFogRatio = bUseDynamicFogRatio;
            DHPlayer(PC).SaveConfig();
        }
    }

    if (int(PC.ConsoleCommand("get DH_Engine.DHPlayer MinDesiredFPS")) != NumMinDesiredFPS)
    {
        PC.ConsoleCommand("set ini:DH_Engine.DHPlayer MinDesiredFPS" @ NumMinDesiredFPS);
        PC.ConsoleCommand("set DH_Engine.DHPlayer MinDesiredFPS" @ NumMinDesiredFPS);

        if (DHPlayer(PC) != none)
        {
            DHPlayer(PC).MinDesiredFPS = NumMinDesiredFPS;
            DHPlayer(PC).SaveConfig();
        }
    }

    if (bool(PC.ConsoleCommand("get" @ co_RenderDevice.GetComponentValue() @ "UseVSync")) != bUseVSync)
    {
        PlayerOwner().ConsoleCommand("set" @ co_RenderDevice.GetComponentValue() @ "UseVSync" @ bUseVSync);
        bSavePlayerConfig = true;
    }

    if (bSavePlayerConfig)
    {
       class'ROEngine.ROPlayer'.static.StaticSaveConfig();
    }
}

function bool RenderDeviceClick(byte Btn)
{
    switch (Btn)
    {
    case QBTN_Yes:
        SaveSettings();
        Console(Controller.Master.Console).DelayedConsoleCommand("relaunch -mod=DarkestHour");
        break;

    case QBTN_Cancel:
        sRenDev = sRenDevD;
        co_RenderDevice.Find(sRenDev);
        co_RenderDevice.SetComponentValue(sRenDev, true);
        break;
    }

    return true;
}

defaultproperties
{
    RenderModeText(0)="Direct3D 9.0 (Recommended)"
    RenderModeText(1)="Direct3D 8.0 (Rendering Issues)"
    RenderModeText(2)="OpenGL (Unstable)"
    RenderMode(0)="D3D9Drv.D3D9RenderDevice"
    RenderMode(1)="D3DDrv.D3DRenderDevice"
    RenderMode(2)="OpenGLDrv.OpenGLRenderDevice"

    RelaunchQuestion="The graphics mode has been successfully changed.  However, it will not take effect until the next time the game is started.  Would you like to restart the game right now?"

    DisplayModes(0)=(Width=1024,Height=768)
    DisplayModes(1)=(Width=1280,Height=800)
    DisplayModes(2)=(Width=1280,Height=1024)
    DisplayModes(3)=(Width=1280,Height=720)
    DisplayModes(4)=(Width=1360,Height=768)
    DisplayModes(5)=(Width=1366,Height=768)
    DisplayModes(6)=(Width=1440,Height=900)
    DisplayModes(7)=(Width=1536,Height=864)
    DisplayModes(8)=(Width=1600,Height=900)
    DisplayModes(9)=(Width=1680,Height=1050)
    DisplayModes(10)=(Width=1920,Height=1200)
    DisplayModes(11)=(Width=1920,Height=1080)
    DisplayModes(12)=(Width=2560,Height=1080)
    DisplayModes(13)=(Width=2560,Height=1440)
    DisplayModes(14)=(Width=3440,Height=1440)
    DisplayModes(15)=(Width=3840,Height=2160)

    // Background for left side "Basic Rendering"
    Begin Object Class=DHGUISectionBackground Name=sbSection1
        Caption="Basic Rendering"
        WinTop=0.004
        WinLeft=0.022
        WinWidth=0.485
        WinHeight=0.540729
        RenderWeight=0.01
        OnPreDraw=sbSection1.InternalPreDraw
    End Object
    sb_Section1=DHGUISectionBackground'DH_Interface.DHTab_DetailSettings.sbSection1'

    // Background for right side "Game Details"
    Begin Object Class=DHGUISectionBackground Name=sbSection2
        Caption="Game Details"
        WinTop=0.004
        WinLeft=0.53
        WinWidth=0.452751
        WinHeight=0.969928
        RenderWeight=0.01
        OnPreDraw=sbSection2.InternalPreDraw
    End Object
    sb_Section2=DHGUISectionBackground'DH_Interface.DHTab_DetailSettings.sbSection2'

    // Background for left side 2 "Gamma Test"
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

    // Gamma Test Image
    Begin Object Class=GUIImage Name=GammaBar
        Image=Texture'DH_GUI_Tex.Menu.DHGammaSet'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Normal
        OnChange=DHTab_DetailSettings.InternalOnChange
    End Object
    i_GammaBar=GUIImage'DH_Interface.DHTab_DetailSettings.GammaBar'


// ======================================================
// [Basic Rendering] "LEFT SIDE"
// ======================================================
    Begin Object Class=DHmoComboBox Name=RenderDeviceCombo
        ComponentJustification=TXTA_Left
        CaptionWidth=0.55
        Caption="Render Device"
        OnCreateComponent=RenderDeviceCombo.InternalOnCreateComponent
        IniOption="@Internal"
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_RenderDevice=DHmoComboBox'DH_Interface.DHTab_DetailSettings.RenderDeviceCombo'

    Begin Object Class=DHmoComboBox Name=VideoResolution
        bReadOnly=true
        CaptionWidth=0.55
        Caption="Resolution"
        OnCreateComponent=VideoResolution.InternalOnCreateComponent
        IniOption="@INTERNAL"
        IniDefault="640x480"
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
        TabOrder=2
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_ColorDepth=DHmoComboBox'DH_Interface.DHTab_DetailSettings.VideoColorDepth'

    Begin Object Class=DHmoComboBox Name=GlobalDetails
        ComponentJustification=TXTA_Left
        CaptionWidth=0.55
        Caption="Game details"
        OnCreateComponent=GlobalDetails.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Higher"
        TabOrder=3
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_GlobalDetails=DHmoComboBox'DH_Interface.DHTab_DetailSettings.GlobalDetails'

    Begin Object Class=DHmoCheckBox Name=VideoFullScreen
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Full Screen"
        OnCreateComponent=VideoFullScreen.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        TabOrder=4
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_FullScreen=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.VideoFullScreen'

    Begin Object Class=moSlider Name=BrightnessSlider
        MaxValue=1.0
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.55
        Caption="Brightness"
        LabelStyleName="DHLargeText"
        OnCreateComponent=BrightnessSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.8"
        TabOrder=5
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Brightness=moSlider'DH_Interface.DHTab_DetailSettings.BrightnessSlider'

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
        TabOrder=6
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Gamma=moSlider'DH_Interface.DHTab_DetailSettings.GammaSlider'

    Begin Object Class=moSlider Name=ContrastSlider
        MaxValue=1.0
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.55
        Caption="Contrast"
        LabelStyleName="DHLargeText"
        OnCreateComponent=ContrastSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.8"
        TabOrder=7
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Contrast=moSlider'DH_Interface.DHTab_DetailSettings.ContrastSlider'

    Begin Object Class=DHmoCheckBox Name=UseVSyncCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="VSync (Not Recommended)"
        Hint="VSync is used to reduce screen tearing at the high cost of input lag (GPU settings can override many graphic settings such as this)"
        OnCreateComponent=UseVSyncCheckBox.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        TabOrder=8
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_UseVSync=UseVSyncCheckBox


// ======================================================
// [Game Details] "RIGHT SIDE" (starts at tab order 20)
// ======================================================
    Begin Object Class=DHmoComboBox Name=DetailTextureDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Texture Detail"
        OnCreateComponent=DetailTextureDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        TabOrder=20
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
        TabOrder=21
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
        TabOrder=22
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
        TabOrder=23
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Physics=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailPhysics'

    Begin Object Class=DHmoComboBox Name=MeshLOD
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Dynamic Mesh LOD"
        OnCreateComponent=MeshLOD.InternalOnCreateComponent
        IniOption="@Internal"
        TabOrder=24
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_MeshLOD=DHmoComboBox'DH_Interface.DHTab_DetailSettings.MeshLOD'

    Begin Object Class=DHmoComboBox Name=DetailDecalStay
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Decal Stay"
        OnCreateComponent=DetailDecalStay.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Normal"
        TabOrder=25
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Decal=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailDecalStay'

    Begin Object Class=DHmoComboBox Name=DetailAntialiasing
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Antialiasing"
        OnCreateComponent=DetailAntialiasing.InternalOnCreateComponent
        IniOption="@Internal"
        TabOrder=26
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
        TabOrder=27
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Anisotropy=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailAnisotropy'

    Begin Object Class=DHmoComboBox Name=DetailCharacterShadows
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Character Shadows"
        OnCreateComponent=DetailCharacterShadows.InternalOnCreateComponent
        IniOption="@Internal"
        TabOrder=28
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Shadows=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailCharacterShadows'

    Begin Object Class=DHmoComboBox Name=ScopeDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.65
        Caption="Scope Detail"
        OnCreateComponent=ScopeDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Textured"
        TabOrder=29
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_ScopeDetail=DHmoComboBox'DH_Interface.DHTab_DetailSettings.ScopeDetail'

    Begin Object Class=DHmoCheckBox Name=DetailForceFSAASS
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Force FSAA Screenshots"
        OnCreateComponent=DetailForceFSAASS.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        TabOrder=30
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_ForceFSAAScreenshotSupport=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailForceFSAASS'

    Begin Object Class=DHmoCheckBox Name=MotionBlur
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Blur Effects"
        OnCreateComponent=MotionBlur.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        TabOrder=31
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_MotionBlur=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.MotionBlur'

    Begin Object Class=DHmoCheckBox Name=HDRCheckbox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="HDR Bloom"
        OnCreateComponent=HDRCheckbox.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        TabOrder=32
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_HDR=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.HDRCheckbox'

    Begin Object Class=DHmoCheckBox Name=DetailDecals
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Decals"
        OnCreateComponent=DetailDecals.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        TabOrder=33
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
        TabOrder=34
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_DynLight=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDynamicLighting'

    Begin Object Class=DHmoCheckBox Name=DetailDetailTextures
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Detail Textures"
        OnCreateComponent=DetailDetailTextures.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        TabOrder=35
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Textures=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDetailTextures'

    Begin Object Class=DHmoCheckBox Name=DetailCoronas
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Coronas"
        OnCreateComponent=DetailCoronas.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        TabOrder=36
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Coronas=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailCoronas'

    Begin Object Class=DHmoCheckBox Name=DetailTrilinear
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Trilinear Filtering"
        OnCreateComponent=DetailTrilinear.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        TabOrder=37
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Trilinear=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailTrilinear'

    Begin Object Class=DHmoCheckBox Name=DetailProjectors
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Projectors"
        OnCreateComponent=DetailProjectors.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        TabOrder=38
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Projectors=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailProjectors'

    Begin Object Class=DHmoCheckBox Name=WeatherEffects
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Weather Effects"
        OnCreateComponent=WeatherEffects.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        TabOrder=39
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Weather=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.WeatherEffects'

    Begin Object Class=DHmoCheckBox Name=DetailDecoLayers
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Ground Details"
        OnCreateComponent=DetailDecoLayers.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        TabOrder=40
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_DecoLayers=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDecoLayers'

    Begin Object Class=DHmoCheckBox Name=DynamicFogRatioCH
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Dynamic Fog Distance (Recommended)"
        Hint="Keeps FPS as high as possible by adjusting the fog distance automatically based on FPS"
        OnCreateComponent=DynamicFogRatioCH.InternalOnCreateComponent
        IniDefault="false"
        TabOrder=41
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
        IniOption="@Internal"
    End Object
    ch_DynamicFogRatio=DynamicFogRatioCH

    Begin Object class=DHmoNumericEdit Name=MinDesiredFPS_NU
        Caption="Min Desired FPS"
        CaptionWidth=0.85
        OnCreateComponent=MinDesiredFPS_NU.InternalOnCreateComponent
        MinValue=20
        MaxValue=300
        Step=10
        ComponentJustification=TXTA_Left
        Hint="Used by Dynamic Fog Distance to determine when to start lowing fog distance"
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
        INIOption="@Internal"
        bAutoSizeCaption=true
        TabOrder=42
    End Object
    nu_MinDesiredFPS=MinDesiredFPS_NU

    Begin Object Class=moSlider Name=DistanceLODSlider
        MaxValue=1.0
        Value=0.5
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.65
        Caption="Fog Distance"
        LabelStyleName="DHLargeText"
        OnCreateComponent=DistanceLODSlider.InternalOnCreateComponent
        IniOption="@Internal"
        TabOrder=43
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_DistanceLOD=moSlider'DH_Interface.DHTab_DetailSettings.DistanceLODSlider'

    Begin Object Class=moSlider Name=CorpseStayTime
        Value=15.0
        MinValue=5.0
        MaxValue=60.0
        bIntSlider=true
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.65
        Caption="Corpse Stay Time (Seconds)"
        LabelStyleName="DHLargeText"
        OnCreateComponent=DistanceLODSlider.InternalOnCreateComponent
        IniOption="@Internal"
        TabOrder=44
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_CorpseStayTime=moSlider'CorpseStayTime'
}
