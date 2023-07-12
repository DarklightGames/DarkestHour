//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M45QuadmountMGPawn extends DHVehicleMGPawn;

// Matt: modified to add workaround fix for weird problem with opacity of gun sights
// A net client would not render objects correctly through the glass sights shader material, with some objects being rendered in front of the sights
// But for some weird reason, if we call SetLocation on the VehicleBase, it cures the problem ! (have to do this each time the actor is spawned on a client)
simulated function InitializeVehicleBase()
{
    super.InitializeVehicleBase();

    if (Role < ROLE_Authority)
    {
        VehicleBase.SetLocation(VehicleBase.Location);
    }
}

// From DHVehicleCannonPawn so the turret movement keys control the weapon (just omitting the gun damage checks)
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

    if (IsHumanControlled())
    {
        PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
        PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

// From DHVehicleCannonPawn (just omitting the periscope position check)
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local float TurnSpeedFactor;

    if (DriverPositionIndex == BinocPositionIndex && DHPlayer(Controller) != none)
    {
        TurnSpeedFactor = DHPlayer(Controller).DHScopeTurnSpeedFactor;
        YawChange *= TurnSpeedFactor;
        PitchChange *= TurnSpeedFactor;
    }

    super(DHVehicleWeaponPawn).UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange); // skip over Super in DHVehicleMGPawn
}

// Modified so camera rotation & offset positioning is always based on the weapon's aim, so player's view always moves with turret
// But with 'look around' rotation added in when player's head is raised above the reflector sight
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat RelativeQuat, TurretQuat, NonRelativeQuat;

    ViewActor = self;

    if (PC == none || Gun == none)
    {
        return;
    }

    // Get base camera rotation from weapon's aimed direction, as player moves with weapon in both pitch & yaw
    CameraRotation = Gun.GetBoneRotation(CameraBone);

    // Player has his head raised above the reflector sight & can look around, so factor in the PlayerController's relative view rotation
    if (DriverPositionIndex > 0 || IsInState('ViewTransition'))
    {
        RelativeQuat = QuatFromRotator(Normalize(PC.Rotation));
        TurretQuat = QuatFromRotator(CameraRotation);
        NonRelativeQuat = QuatProduct(RelativeQuat, TurretQuat);
        CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));
    }

    // Get camera location
    CameraLocation = Gun.GetBoneCoords(CameraBone).Origin;

    // Finalise the camera with any shake
    CameraLocation += PC.ShakeOffset >> PC.Rotation;
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Modified to skip over the Super in DHVehicleMGPawn so we use the same zeroed initial view rotation as a cannon pawn, since we control this MG like a turret
simulated function SetInitialViewRotation()
{
    super(DHVehicleWeaponPawn).SetInitialViewRotation();
}

// From DHVehicleCannonPawn, so player faces forwards if he's on the gunsight when switching to behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    if (PC != none && PC.bBehindView && bBehindViewChanged && DriverPositionIndex == 0)
    {
        PC.SetRotation(rot(0, 0, 0));
    }

    super.POVChanged(PC, bBehindViewChanged);
}

// From DHVehicleCannonPawn, to set view rotation when player moves away from a position where his view was locked to a bone's rotation
// Stops camera snapping to a strange rotation as view rotation reverts to pawn/PC rotation, which has been redundant & could have wandered meaninglessly via mouse movement
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        super.HandleTransition();

        if (LastPositionIndex == 0 && IsFirstPerson())
        {
            SetInitialViewRotation();
        }
    }
}

// From DHVehicleCannonPawn, so if player exits while on the gunsight, his view rotation is zeroed so he exits facing forwards
// Necessary because while on gunsight his view rotation is locked to camera bone, but pawn/PC rotation can wander meaninglessly via mouse movement
simulated function ClientKDriverLeave(PlayerController PC)
{
    if (DriverPositionIndex == 0 && !IsInState('ViewTransition') && PC != none)
    {
        PC.SetRotation(rot(0, 0, 0)); // note that an owning net client will update this back to the server
    }

    super.ClientKDriverLeave(PC);
}

// Can't fire if using binoculars
function bool CanFire()
{
    return DriverPositionIndex != BinocPositionIndex || !IsHumanControlled();
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_M45QuadmountMG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionUpAnim="sights_out",bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionDownAnim="sights_in",ViewPitchUpLimit=6000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    bDrawDriverInTP=true
    DrivePos=(X=-10.0,Y=0.0,Z=-37.0)
    DriveAnim="VSU76_driver_idle_close"
    CameraBone="Camera_com"
    VehicleMGReloadTexture=Texture'DH_Artillery_tex.ATGun_Hud.m45_ammo_reload'
    bSpecialRotateSounds=true
    RotateSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PitchSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
}
