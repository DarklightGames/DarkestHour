//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVehicleMGPawn extends DHVehicleWeaponPawn
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx

var     bool        bExternallyLoadedMG;         // player must be unbuttoned to load MG
var     texture     VehicleMGReloadTexture;      // used to show reload progress on the HUD, like a tank cannon reload
var     vector      BinocsDrivePos;              // optional additional player position adjustment when on binocs, as player animation can be quite different from typical MG stance
var     name        GunsightCameraBone;          // optional separate camera bone for the MG gunsights
var     name        FirstPersonGunRefBone;       // static gun bone used as reference point to adjust 1st person view HUDOverlay offset, if gunner can raise his head above sights
var     float       FirstPersonOffsetZScale;     // used with HUDOverlay to scale how much lower the 1st person gun appears when player raises his head above it
var     float       FirstPersonGunShakeScale;    // scales up view shake on 1st person HUDOverlay view
var     bool        bHideMuzzleFlashAboveSights; // workaround (hack really) to turn off muzzle flash in 1st person when player raises head above sights, as it sometimes looks wrong

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  VIEW/DISPLAY  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to make into a generic function, avoiding need for overrides in subclasses, to properly handle vehicle roll, & to optimise & simplify generally
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat RelativeQuat, VehicleQuat, NonRelativeQuat;
    local bool bOnTheGun;

    ViewActor = self;

    if (PC == none || Gun == none || CameraBone =='')
    {
        return;
    }

    // Player is on the gun, so use MG's aim for camera rotation
    if (CanFire())
    {
        bOnTheGun = true;
        CameraRotation = Gun.CurrentAim;
    }
    // Otherwise, player can look around, so use PC's rotation for camera rotation
    else
    {
        CameraRotation = PC.Rotation;
    }

    // CameraRotation is currently relative to vehicle, so now factor in the vehicle's rotation (note Gun.Rotation is same as vehicle base)
    RelativeQuat = QuatFromRotator(Normalize(CameraRotation));
    VehicleQuat = QuatFromRotator(Gun.Rotation);
    NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
    CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));

    // Custom aim update
    if (bOnTheGun)
    {
        PC.WeaponBufferRotation.Yaw = CameraRotation.Yaw;
        PC.WeaponBufferRotation.Pitch = CameraRotation.Pitch;
    }

    // Get camera location - use GunsightCameraBone if there is one & player is one the gun, otherwise use normal CameraBone
    if (GunsightCameraBone != '' && bOnTheGun)
    {
        CameraLocation = Gun.GetBoneCoords(GunsightCameraBone).Origin;
    }
    else
    {
        CameraLocation = Gun.GetBoneCoords(CameraBone).Origin;
    }

    // Adjust camera location for any offset positioning (FPCamPos is either set in default props or from any ViewLocation in DriverPositions)
    if (FPCamPos != vect(0.0, 0.0, 0.0))
    {
        if (bOnTheGun)
        {
            CameraLocation = CameraLocation + (FPCamPos >> CameraRotation);
        }
        else
        {
            CameraLocation = CameraLocation + (FPCamPos >> Gun.Rotation);
        }
    }

    // Finalise the camera with any shake
    CameraLocation = CameraLocation + (PC.ShakeOffset >> PC.Rotation);
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Modified to fix bug where any HUDOverlay would be destroyed if function called before net client received Controller reference through replication
// Also to optimise & make into generic function to handle all MG types
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local vector           CameraLocation, GunOffset, x, y, z;
    local rotator          CameraRotation;
    local float            SavedOpacity, ScreenRatio;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (!bMultiPosition || (DriverPositions[DriverPositionIndex].bDrawOverlays && (!IsInState('ViewTransition') || DriverPositions[LastPositionIndex].bDrawOverlays)))
        {
            // Draw binoculars overlay
            if (DriverPositionIndex == BinocPositionIndex && BinocsOverlay != none)
            {
                DrawBinocsOverlay(C);
            }
            // Draw any HUD overlay
            else if (HUDOverlay != none)
            {
                if (!Level.IsSoftwareRendering())
                {
                    CameraLocation = PC.CalcViewLocation;
                    CameraRotation = Normalize(PC.CalcViewRotation + PC.ShakeRot);

                    // Make the first person gun appear lower when your sticking your head up
                    if (FirstPersonGunRefBone != '' && Gun != none)
                    {
                        GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;
                        GunOffset.Z += (((Gun.GetBoneCoords(FirstPersonGunRefBone).Origin.Z - CameraLocation.Z) * FirstPersonOffsetZScale));
                        GunOffset += HUDOverlayOffset;
                        HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                        C.DrawBoundActor(HUDOverlay, false, true, HUDOverlayFOV, CameraRotation, PC.ShakeRot * FirstPersonGunShakeScale, GunOffset * -1.0);
                    }
                    else
                    {
                        CameraLocation = CameraLocation + (PC.ShakeOffset.X * x) + (PC.ShakeOffset.Y * y) + (PC.ShakeOffset.Z * z);
                        HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                        HUDOverlay.SetRotation(CameraRotation);
                        C.DrawActor(HUDOverlay, false, true, HUDOverlayFOV);
                    }
                }
            }
            // Draw gunsight overlay
            else if (GunsightOverlay != none)
            {
                // Save current HUD opacity & then set up for drawing overlays
                SavedOpacity = C.ColorModulate.W;
                C.ColorModulate.W = 1.0;
                C.DrawColor.A = 255;
                C.Style = ERenderStyle.STY_Alpha;

                ScreenRatio = float(C.SizeY) / float(C.SizeX);
                C.SetPos(0.0, 0.0);

                C.DrawTile(GunsightOverlay, C.SizeX, C.SizeY, OverlayCenterTexStart - OverlayCorrectionX,
                    OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0, OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

                C.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, VehicleBase, self);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* FIRING & AMMO  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to prevent fire based on CanFire() & to add dry-fire effects if trying to fire empty MG
function Fire(optional float F)
{
    if (CanFire() && VehWep != none)
    {
        if (VehWep.ReadyToFire(false))
        {
            VehicleFire(false);
            bWeaponIsFiring = true;

            if (IsHumanControlled())
            {
                VehWep.ClientStartFire(Controller, false);
            }
        }
        else if (VehWep.ReloadState == RL_Waiting || VehWep.bReloadPaused) // no dry-fire effect if actively reloading
        {
            VehWep.DryFireEffects();
        }
    }
}

// Modified to show screen message advising player they must unbutton to reload an external MG, if they press the reload key (perhaps in confusion on finding they can't reload)
simulated exec function ROManualReload()
{
    if (!CanReload() && VehWep != none && VehWep.ReloadState != RL_ReadyToFire)
    {
        DisplayVehicleMessage(12,, true);
    }
}

// New function to check whether player is in a position where he can reload the MG
// Always true if MG is not bExternallyLoadedMG, otherwise player must be unbuttoned & not in the process of buttoning up (i.e. transitioning down)
simulated function bool CanReload()
{
    return !bExternallyLoadedMG
        || (DriverPositionIndex == UnbuttonedPositionIndex && (!IsInState('ViewTransition') || LastPositionIndex > UnbuttonedPositionIndex)) // unbuttoned position & not just unbuttoning
        || (DriverPositionIndex > UnbuttonedPositionIndex && DriverPositionIndex != BinocPositionIndex); // above the lowest unbuttoned position, but not on binocs
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************* ENTRY, CHANGING VIEW & EXIT  ************************* //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to match starting rotation to MG's aim
simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    MatchRotationToGunAim(PC);
}

// Modified to exit to added state LeavingViewTransition, just to allow CanReload() functionality to work correctly
// Also to add a workaround (hack really) to turn off muzzle flash in 1st person when player raises head above sights as it sometimes looks wrong, & a reloading hint
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        super.HandleTransition();

        if (VehWep != none)
        {
            // If the option is flagged, turn off muzzle flash if player has raised head above sights
            if (bHideMuzzleFlashAboveSights && DriverPositionIndex > 0 && VehWep.AmbientEffectEmitter != none && IsHumanControlled() && !PlayerController(Controller).bBehindView)
            {
                VehWep.AmbientEffectEmitter.bHidden = true;
            }

            // If MG is reloading but player is no longer in a valid reloading position, show a hint that they must unbutton to resume the reload
            if (VehWep.ReloadState < RL_ReadyToFire && !CanReload() && !VehWep.bReloadPaused && DHPlayer(Controller) != none)
            {
                DHPlayer(Controller).QueueHint(49, true);
            }
        }
    }

    simulated function EndState()
    {
        super.EndState();

        // Re-enable muzzle flash if it has previously been turned off when player raised head above sights
        if (bHideMuzzleFlashAboveSights && DriverPositionIndex == 0 && Gun != none && Gun.AmbientEffectEmitter != none && Gun.AmbientEffectEmitter.bHidden)
        {
            Gun.AmbientEffectEmitter.bHidden = false;
        }
    }

Begin:
    HandleTransition();
    Sleep(ViewTransitionDuration);
    GotoState('LeavingViewTransition'); // go to this added state very briefly, just so CanReload() doesn't return false due to being in state ViewTransition
}

// New state that is very briefly entered whenever player leaves state ViewTransition, just to allow CanReload() functionality to work correctly
// If MG is not loaded, try to start reloading or resume any previously paused reload (on a net client a resumed reload happens independently to server)
simulated state LeavingViewTransition
{
    simulated function BeginState()
    {
        if (VehWep != none && (VehWep.ReloadState == RL_Waiting || VehWep.bReloadPaused))
        {
            VehWep.AttemptReload();
        }

        GotoState('');
    }
}

// Modified to handle different 'can't exit' messages if MG doesn't have a hatch, so player has to exit through driver's and/or commander's hatch
simulated function bool CanExit()
{
    if (!super.CanExit())
    {
        if (DriverPositions.Length <= UnbuttonedPositionIndex) // means it is impossible to unbutton
        {
            if (DHArmoredVehicle(VehicleBase) != none && DHArmoredVehicle(VehicleBase).DriverPositions.Length > DHArmoredVehicle(VehicleBase).UnbuttonedPositionIndex) // means driver has hatch
            {
                DisplayVehicleMessage(10); // must exit through driver's or commander's hatch
            }
            else
            {
                DisplayVehicleMessage(5); // must exit through commander's hatch
            }
        }

        return false;
    }

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add an extra material property
static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    if (default.VehicleMGReloadTexture != none)
    {
        L.AddPrecacheMaterial(default.VehicleMGReloadTexture);
    }
}

// Modified to add an extra material property
simulated function UpdatePrecacheMaterials()
{
    super.UpdatePrecacheMaterials();

    Level.AddPrecacheMaterial(VehicleMGReloadTexture);
}

// Modified to handle optional adjustment to player's rotation & attachment positioning to suit binocs pose
// RelativeRotation & RelativeLocation are set on server & get replicated to net clients, but we still set them on clients so it happens instantly, without waiting for replication
simulated function HandleBinoculars(bool bMovingOntoBinocs)
{
    local rotator DesiredRelativeRotation;
    local vector  DesiredRelativeLocation;

    // On binocs, remove any player rotation (DriveRot), as some MGs turn player sideways when on the gun & that's no good for the binocs pose
    if (DriveRot != rot(0, 0, 0))
    {
        if (bMovingOntoBinocs)
        {
            DesiredRelativeRotation = rot(0, 0, 0);
        }
        else
        {
            DesiredRelativeRotation = DriveRot; // revert to default if moving off binocs
        }

        if (Driver.RelativeRotation != DesiredRelativeRotation)
        {
            Driver.SetRelativeRotation(DesiredRelativeRotation);
        }
    }

    // Option to adjust player attachment positioning to suit binocs pose
    if (BinocsDrivePos != vect(0.0, 0.0, 0.0))
    {
        if (bMovingOntoBinocs)
        {
            DesiredRelativeLocation = BinocsDrivePos + Driver.default.PrePivot;
        }
        else
        {
            DesiredRelativeLocation = DrivePos + Driver.default.PrePivot; // revert to default if moving off binocs
        }

        if (Driver.RelativeLocation != DesiredRelativeLocation)
        {
            Driver.SetRelativeLocation(DesiredRelativeLocation);
        }
    }

    super.HandleBinoculars(bMovingOntoBinocs);
}

// Modified to update custom aim, & to stop player from moving the MG if he's not in a position where he can control the MG
// Also to apply the ironsights turn speed factor if the player is controlling the MG or is using binoculars
// And to apply RotationsPerSecond limit on MGs swivel speed, which would otherwise be ignored in 1st person for player on MG, because MGs are bInstantRotation weapons
// While all other players would see a more slowly turning MG, which is very misleading, because gradual rotation via RPS is still used for other players to smooth rotation changes
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local DHPlayer C;
    local bool     bCanFire;
    local float    MaxChange;

    C = DHPlayer(Controller);
    bCanFire = CanFire();

    // Modify view movement speed by the controller's ironsights turn speed factor
    if ((bCanFire || DriverPositionIndex == BinocPositionIndex) && C != none)
    {
        YawChange *= C.DHISTurnSpeedFactor;
        PitchChange *= C.DHISTurnSpeedFactor;
    }

    if (bCanFire)
    {
        // Limit rotation speed of MG to it's specified RotationsPerSecond, as MGs are bInstantRotation weapons, which would otherwise ignore RPS in 1st person
        // But don't do this in single player mode, as very high FPS apparently cause MG movement to slow to a crawl, & there aren't any other players to worry about
        if (Level.NetMode != NM_Standalone && Gun != none)
        {
            MaxChange = Gun.RotationsPerSecond * DeltaTime * 65536;
            YawChange = FClamp(YawChange, -MaxChange, MaxChange);
            PitchChange = FClamp(PitchChange, -MaxChange, MaxChange);
        }

        // Normal custom aim update
        UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);
    }
    // Stops player moving MG if not in a position where he can control it (but 'null' update still required)
    else
    {
        UpdateSpecialCustomAim(DeltaTime, 0.0, 0.0);
    }

    if (C != none)
    {
        C.WeaponBufferRotation.Yaw = CustomAim.Yaw;
        C.WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }

    super.UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  MISCELLANEOUS ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New function to match rotation to MG's current aim (note owning net client will update rotation back to server)
simulated function MatchRotationToGunAim(optional Controller C)
{
    if (Gun != none)
    {
        if (C == none)
        {
            C = Controller;
        }

        SetRotation(Gun.CurrentAim);

        if (C != none)
        {
            C.SetRotation(Rotation);
        }
    }
}

// From deprecated ROMountedTankMGPawn
function float ModifyThreat(float Current, Pawn Threat)
{
    if (Vehicle(Threat) != none)
    {
        return Current - 2.0;
    }

    return Current + 0.4;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New debug exec to adjust BinocsDrivePos (in binoculars position, the option for a different player offset from attachment bone)
exec function SetBinocsDrivePos(int NewX, int NewY, int NewZ, optional bool bScaleOneTenth)
{
    local vector OldBinocsDrivePos;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        OldBinocsDrivePos = BinocsDrivePos;
        BinocsDrivePos.X = NewX;
        BinocsDrivePos.Y = NewY;
        BinocsDrivePos.Z = NewZ;

        if (bScaleOneTenth) // option allowing accuracy to .1 Unreal units, by passing floats as ints scaled by 10 (e.g. pass 55 for 5.5)
        {
            BinocsDrivePos /= 10.0;
        }

        if (DriverPositionIndex == BinocPositionIndex && Driver != none)
        {
            Driver.SetRelativeLocation(BinocsDrivePos + Driver.default.PrePivot);
        }

        Log(Tag @ " new BinocsDrivePos =" @ BinocsDrivePos @ "(was" @ OldBinocsDrivePos $ ")");
    }
}

defaultproperties
{
    bMustBeTankCrew=true
    PositionInArray=1
    UnbuttonedPositionIndex=1
    bDrawDriverInTP=false
    bZeroPCRotOnEntry=false // we're now calling MatchRotationToGunAim() on entering, so no point zeroing rotation
    CameraBone="mg_yaw"
    OverlayCenterSize=1.0
    FirstPersonGunShakeScale=1.0
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
    HudName="MG"
}
