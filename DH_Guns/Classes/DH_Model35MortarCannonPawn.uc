//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] replace mortar round names
// [ ] calibrate range table
// [ ] UI elements for clock image
// [ ] replace pitch/yaw sounds with squeaking wheels used on the other mortars
// [ ] adjust yaw dials to be more precise
// [ ] reduce spread of mortar rounds
// [ ] replace firing effects
// [ ] remove reloading sounds
// [ ] add mortar player idle animations
// [ ] figure out a system for the firing animations
// [ ] increase off-gun rotation speed
//==============================================================================
class DH_Model35MortarCannonPawn extends DHATGunCannonPawn;

var     float FiringStartTimeSeconds;       // The time at which the firing animation started, relative to Level.TimeSeconds.
var     float OverlayFiringAnimDuration;    // The duration of the firing animation on the overlay mesh. Calculated when entering the Firing state.

var()   name  FiringCameraBone;         // The name of the bone to use for the camera while firing.
var()   int   FiringCameraBoneChannel;  // The channel to use for the firing camera bone.
var()   name  GunFireAnim;              // The firing animation to play on the gun mesh.
var()   name  OverlayFiringAnimName;    // The name of the firing animation on the overlay mesh.
var()   float FiringCameraInTime;       // How long it takes to interpolate the camera to the firing camera position at the start of the firing animation.
var()   float FiringCameraOutTime;      // How long it takes to interpolate the camera back to the normal position at the end of the firing animation.

struct SAnimationDriver
{
    var int Channel;
    var name BoneName;
    var name SequenceName;
    var int SequenceFrameCount;
};

var SAnimationDriver PitchAnimationDriver;

simulated function InitializeVehicleAndWeapon()
{
    super.InitializeVehicleAndWeapon();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetupFiringCameraChannel();
        SetupGunAnimationDrivers();
        UpdateGunAnimationDrivers();
    }
}

simulated function SuperFire(optional float F)
{
    super.Fire(F);
}

simulated function Fire(optional float F)
{
    // TODO: only if the player *CAN* fire.

    GotoState('Firing');
}

// New state for the mortar to play the firing animation.
simulated state Firing
{
    // Don't let the user move, leave, or change the round type while firing.
    function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange) { }
    simulated function Fire(optional float F) { }
    exec simulated function SwitchFireMode() { }
    function bool KDriverLeave(bool bForceLeave) { return false; }
    simulated function NextWeapon() { }
    simulated function PrevWeapon() { }

    simulated function DrawHUD(Canvas Canvas)
    {
        // TODO: add in the drawing of the HUDOverlay actor for the mortar.
        super.DrawHUD(Canvas);
    }

    // Calculate the linear interpolation value for the camera position and rotation.
    simulated function float GetCameraInterpolationTheta()
    {
        local float Theta;
        local float FiringTimeSeconds, ZoomOutTime;

        FiringTimeSeconds = Level.TimeSeconds - FiringStartTimeSeconds;
        ZoomOutTime = OverlayFiringAnimDuration - FiringCameraOutTime;

        if (FiringTimeSeconds < FiringCameraInTime)
        {
            Theta = FiringTimeSeconds / FiringCameraInTime;
        }
        else if (FiringTimeSeconds > ZoomOutTime)
        {
            Theta = 1.0 - ((FiringTimeSeconds - ZoomOutTime) / FiringCameraOutTime);
        }
        else
        {
            Theta = 1.0;
        }

        return Theta;
    }

    simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
    {
        local float Theta;
        local Vector NormalCameraLocation, FiringCameraLocation;
        local Rotator NormalCameraRotation, FiringCameraRotation;
        local Coords FiringCameraBoneCoords;

        // TODO: calculate firing camera position and rotation.
        FiringCameraBoneCoords = Gun.GetBoneCoords(FiringCameraBone);
        FiringCameraLocation = FiringCameraBoneCoords.Origin;

        // Convert the X, Y and Z axis from the bone coords to a quaternion.
        FiringCameraRotation = QuatToRotator(
            class'UQuaternion'.static.FromAxes(FiringCameraBoneCoords.XAxis, FiringCameraBoneCoords.YAxis, FiringCameraBoneCoords.ZAxis)
            );

        // Get the linear theta.
        Theta = GetCameraInterpolationTheta();

        // Perform a smoothstep on the theta.
        Theta = class'UInterp'.static.SmoothStep(Theta, 0.0, 1.0);

        Log("Theta" @ Theta);

        // Interpolate the camera position and rotation between the normal and firing camera positions.
        global.SpecialCalcFirstPersonView(PC, ViewActor, NormalCameraLocation, NormalCameraRotation);

        ViewActor = self;
        CameraLocation = class'UVector'.static.VLerp(Theta, NormalCameraLocation, FiringCameraLocation);
        CameraRotation = QuatToRotator(QuatSlerp(QuatFromRotator(NormalCameraRotation), QuatFromRotator(FiringCameraRotation), Theta));
    }

    simulated function BeginState()
    {
        if (IsLocallyControlled() && Gun != none)
        {
            Gun.PlayAnim(GunFireAnim, 1.0, 0.0, FiringCameraBoneChannel);
        }

        FiringStartTimeSeconds = Level.TimeSeconds;

        // TODO: make sure the hudoverlay is created and set up properly.

        OverlayFiringAnimDuration = Gun.GetAnimDuration(GunFireAnim);

        // ActivateOverlay?? (only on the controlling client), then deactivate overlay when done.

        Log("In Firing state");
    }

Begin:
    Sleep(3.0);
    if (Role == ROLE_Authority)
    {
        GotoState('ServerFire');
    }
    else
    {
        // Non-authoritative clients should just go back to the default state.
        GotoState('');
    }
}

simulated state ServerFire
{
    simulated function BeginState()
    {
        // Fire the round.
        super.Fire();

        GotoState('');
    }
}

// TODO: add in functionality for firing the mortar to play the animation, then spawn the projectile.

simulated function SetupFiringCameraChannel()
{
    Gun.AnimBlendParams(FiringCameraBoneChannel, 1.0, 0.0, 0.0, FiringCameraBone);
}

simulated function SetupGunAnimationDrivers()
{
    Gun.AnimBlendParams(PitchAnimationDriver.Channel, 1.0, 0.0, 0.0, PitchAnimationDriver.BoneName);
    Gun.PlayAnim(PitchAnimationDriver.SequenceName, 1.0, 0.0, PitchAnimationDriver.Channel);
    UpdateGunAnimationDrivers();
}

simulated function UpdateGunAnimationDrivers()
{
    local float Time;

    if (Gun != none)
    {
        Time = class'UInterp'.static.MapRangeClamped(
            GetGunPitch(),
            GetGunPitchMin(), GetGunPitchMax(),
            PitchAnimationDriver.SequenceFrameCount, 0.0
            );

        Gun.FreezeAnimAt(Time, PitchAnimationDriver.Channel);
    }
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (Level.NetMode != NM_DedicatedServer)
    {
        UpdateGunAnimationDrivers();
    }
}

defaultproperties
{
    PitchAnimationDriver=(Channel=1,BoneName="PITCH_ROOT",SequenceName="PITCH_DRIVER",SequenceFrameCount=30)

    GunClass=class'DH_Guns.DH_Model35MortarCannon'

    // spotting scope
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="overlay_out",ViewFOV=40.0,ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    // kneeling
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=55000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // standing
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext',DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // binoculars
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    PlayerCameraBone="CAMERA_COM"
    CameraBone="GUNSIGHT_CAMERA"

    GunsightPositions=0
    UnbuttonedPositionIndex=0
    SpottingScopePositionIndex=0
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3

    bLockCameraDuringTransition=true

    DrivePos=(X=0,Y=0.0,Z=60.0)
    DriveAnim="crouch_idle_binoc"

    OverlayCorrectionX=0
    OverlayCorrectionY=0

    AmmoShellTexture=Texture'DH_LeIG18_tex.HUD.leig18_he'   // TODO: swap it out
    AmmoShellReloadTexture=Texture'DH_LeIG18_tex.HUD.leig18_he_reload'
    ArtillerySpottingScopeClass=class'DH_Guns.DHArtillerySpottingScope_Model35Mortar'

    GunPitchOffset=7280 // +40 degrees

    FiringCameraInTime=0.65
    FiringCameraOutTime=0.65
    FiringCameraBone="FIRING_CAMERA"
    FiringCameraBoneChannel=3
    GunFireAnim="FIRE"
}
