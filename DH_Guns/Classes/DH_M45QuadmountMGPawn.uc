//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountMGPawn extends DHVehicleMGPawn;

// From ROTankCannonPawn, so the turret movement keys control the weapon
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

// Modified to remove the super from DHVehicleMGPawn, which makes the mouse control the MG as well as the turret movement keys
// But retaining the scope turn speed factor if the player is using binoculars
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local float TurnSpeedFactor;

    if (DriverPositionIndex == BinocPositionIndex && DHPlayer(Controller) != none)
    {
        TurnSpeedFactor = DHPlayer(Controller).DHISTurnSpeedFactor;
        YawChange *= TurnSpeedFactor;
        PitchChange *= TurnSpeedFactor;
    }

    super(VehicleWeaponPawn).UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);
}

// Modified to add elements from DHVehicleCannonPawn, so camera rotation is only locked to gun's aim when on the reflector sight (pos 0), not in any firing position
// And to factor turret's yaw into player's view rotation (so player's view turns with the turret) & into camera position offset
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat    RelativeQuat, VehicleQuat, NonRelativeQuat;
    local rotator BaseRotation;
    local bool    bOnTheGun;

    ViewActor = self;

    if (PC == none || Gun == none)
    {
        return;
    }

    // Player is on the gun, so use MG's aim for camera rotation
    if (DriverPositionIndex == 0) // was "if (CanFire())", which would include the head raised position 1
    {
        bOnTheGun = true;
        CameraRotation = Gun.CurrentAim;
    }
    // Otherwise, player can look around, so use PC's rotation for camera rotation
    else
    {
        CameraRotation = PC.Rotation;
        CameraRotation.Yaw += Gun.CurrentAim.Yaw; // added to factor in turret's yaw, so player's view turns with the turret
    }

    // CameraRotation is currently relative to vehicle, so now factor in the vehicle's rotation (note Gun.Rotation is same as vehicle base)
    RelativeQuat = QuatFromRotator(Normalize(CameraRotation));
    VehicleQuat = QuatFromRotator(Gun.Rotation);
    NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
    CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));

    // Get camera location - use GunsightCameraBone if player is one the gun, otherwise use normal CameraBone
    if (bOnTheGun)
    {
        // Custom aim update
        PC.WeaponBufferRotation.Yaw = CameraRotation.Yaw;
        PC.WeaponBufferRotation.Pitch = CameraRotation.Pitch;

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
            BaseRotation = Gun.Rotation;
            BaseRotation.Yaw += Gun.CurrentAim.Yaw; // added to factor in the turret's yaw
            CameraLocation = CameraLocation + (FPCamPos >> BaseRotation);
        }
    }

    // Finalise the camera with any shake
    CameraLocation = CameraLocation + (PC.ShakeOffset >> PC.Rotation);
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Can't fire if using binoculars
function bool CanFire()
{
    return DriverPositionIndex != BinocPositionIndex;
}

defaultproperties
{
    GunClass=class'DH_Guns.DH_M45QuadmountMG'
    PositionInArray=0
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMustBeTankCrew=false
    bMultiPosition=true
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=0.0,Z=6.0),ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionUpAnim="lookover_up",bExposed=true)
    DriverPositions(1)=(ViewLocation=(X=-15.0,Y=0.0,Z=15.0),ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionDownAnim="lookover_down",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewLocation=(X=-15.0,Y=0.0,Z=15.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=0.0,Y=0.0,Z=-13.0)
    DriveAnim="Vt3485_driver_idle_close"
    GunsightCameraBone="Gun"
    CameraBone="Camera_com"
    bSpecialRotateSounds=true
    RotateSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload' // TODO: make ammo reload texture for 50 cal 'tombstone' ammo chest
    EntryRadius=130.0
}
