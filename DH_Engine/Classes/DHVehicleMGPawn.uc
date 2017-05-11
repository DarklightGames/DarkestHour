//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVehicleMGPawn extends DHVehicleWeaponPawn
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx

var     bool        bMustUnbuttonToReload;       // player must be unbuttoned to load MG
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
            CameraLocation += (FPCamPos >> CameraRotation);
        }
        else
        {
            CameraLocation += (FPCamPos >> Gun.Rotation);
        }
    }

    // Finalise the camera with any shake
    CameraLocation += (PC.ShakeOffset >> PC.Rotation);
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
                        CameraLocation += (PC.ShakeOffset.X * x) + (PC.ShakeOffset.Y * y) + (PC.ShakeOffset.Z * z);
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
//  ****************************** FIRING & RELOAD  *******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add dry-fire effects if trying to fire empty MG (but not if actively reloading)
function Fire(optional float F)
{
    if (CanFire() && !ArePlayersWeaponsLocked())
    {
        super(ROVehicleWeaponPawn).Fire(F); // skip over Super in DHVehicleWeaponPawn to avoid duplicating checks on CanFire() & ArePlayersWeaponsLocked()

        if (VehWep != none && VehWep.ReloadState != RL_ReadyToFire && (VehWep.ReloadState == RL_Waiting || VehWep.bReloadPaused))
        {
            VehWep.DryFireEffects();
        }
    }
}

// Implemented to handle externally-mounted MGs where player must be unbuttoned to reload, & to prevent reloading if player using binoculars
simulated function bool CanReload()
{
    if (DriverPositionIndex == BinocPositionIndex)
    {
        return false;
    }

    return !bMustUnbuttonToReload || DriverPositionIndex > UnbuttonedPositionIndex
        || (DriverPositionIndex == UnbuttonedPositionIndex && (!IsInState('ViewTransition') || LastPositionIndex > UnbuttonedPositionIndex)); // if unbuttoned position make sure not unbuttoning
}

// Modified to show screen message advising player they must unbutton to reload an external MG, if they press the reload key (perhaps in confusion on finding they can't reload)
simulated exec function ROManualReload()
{
    if (bMustUnbuttonToReload && !CanReload() && VehWep != none && VehWep.ReloadState != RL_ReadyToFire)
    {
        DisplayVehicleMessage(12,, true);
    }
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

            // If player was reloading MG but can't continue in the new position, interrupt the reload
            if (VehWep.ReloadState < RL_ReadyToFire && !VehWep.bReloadPaused && !CanReload() && VehWep.bMultiStageReload)
            {
                VehWep.PauseReload();

                // If player was loading externally mounted MG, show a hint he must unbutton (or stop using binocs) to continue the reload
                if (bMustUnbuttonToReload && IsLocallyControlled() && DHPlayer(Controller) != none)
                {
                    DHPlayer(Controller).QueueHint(48, true);
                }
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
// If we did this at the end of state ViewTransition, AttemptReload() would fail because CanReload() would return false due to ViewTransition
// Note owning net client runs this independently from server & may resume a paused reload (but not start a new reload)
simulated state LeavingViewTransition
{
    simulated function BeginState()
    {
        if (VehWep != none && (VehWep.ReloadState == RL_Waiting || (VehWep.bReloadPaused && VehWep.ReloadState < RL_ReadyToFire)))
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

// Modified to update custom aim, & to stop player from moving the MG if he's not in a position where he is controlling it
// And to apply RotationsPerSecond limit on MG's movement speed, which would otherwise be ignored in 1st person for player on the gun as MGs are bInstantRotation weapons
// While other players would see a more slowly turning MG (which is very misleading) as gradual rotation via RPS is still used for other players to smooth rotation changes
// Also to apply the player's scope turn speed factor if the player is using binoculars
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local DHPlayer PC;
    local float    MaxChange;

    PC = DHPlayer(Controller);

    // If player is on the gun (in a position where he is controlling it), his look movement rotates the MG & we do a normal custom aim update
    // We apply his ironsight turn speed reduction, so it feels the same as aiming the infantry version of the same MG
    if (CanFire())
    {
        if (PC != none)
        {
            YawChange *= PC.DHISTurnSpeedFactor;
            PitchChange *= PC.DHISTurnSpeedFactor;

            // Limit rotation speed of MG to it's specified RotationsPerSecond, so 1st person movement matches 3rd person limits
            // The MaxChange calculation seems odd, but the Super takes Yaw/PitchChange & multiplies it by DeltaTime & by 32, then applies that to pawn's rotation
            // The max change we want to apply in rotational units is (RPS * dT * 65536), i.e. the max rotation, in units, the MG can make in DeltaTime
            // The Super will apply (Change * dT * 32) so we need that to equal (RPS * dT * 65536), meaning we need to pass a max change of (RPS * 65536/32), i.e. RPS * 2048
            // Native function UpdateSpecialCustomAim() is doing the same rotation adjustment to the MG's aim
            if (Gun != none)
            {
                MaxChange = Gun.RotationsPerSecond * 2048.0;
                YawChange = FClamp(YawChange, -MaxChange, MaxChange);
                PitchChange = FClamp(PitchChange, -MaxChange, MaxChange);
            }
        }

        UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);
    }
    // If player is not on the gun we stop the MG from moving (a 'null' custom aim update is necessary)
    // And if he is using binoculars we apply his scope turn speed reduction
    else
    {
        if (DriverPositionIndex == BinocPositionIndex && PC != none)
        {
            YawChange *= PC.DHScopeTurnSpeedFactor;
            PitchChange *= PC.DHScopeTurnSpeedFactor;
        }

        UpdateSpecialCustomAim(DeltaTime, 0.0, 0.0);
    }

    if (PC != none)
    {
        PC.WeaponBufferRotation.Yaw = CustomAim.Yaw;
        PC.WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }

    super.UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange); // updates weapon pawn's rotation
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

exec function LogMG() // DEBUG (Matt: please use & report if you ever find you can't fire or reload MG when you should be able to)
{
    Log("LogMG: Gun =" @ Gun.Tag @ " VehWep =" @ VehWep.Tag @ " VehWep.WeaponPawn =" @ VehWep.WeaponPawn.Tag @ " Gun.Owner =" @ Gun.Owner.Tag);
    Log("Controller =" @ Controller.Tag @ " ViewTransition =" @ IsInState('ViewTransition') @ " DriverPositionIndex =" @ DriverPositionIndex);
    Log("ReloadState =" @ GetEnum(enum'EReloadState', VehWep.ReloadState) @ " bReloadPaused =" @ VehWep.bReloadPaused @ " CanReload() =" @ CanReload() @ " ProjectileClass =" @ VehWep.ProjectileClass);
    Log("AmmoIndex =" @ VehWep.GetAmmoIndex() @ " PrimaryAmmoCount() =" @ VehWep.PrimaryAmmoCount() @ " NumMGMags =" @ VehWep.NumMGMags
        @ " HasAmmoToReload() =" @ VehWep.HasAmmoToReload(VehWep.GetAmmoIndex()));
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
