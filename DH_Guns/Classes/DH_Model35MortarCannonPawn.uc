//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Replace pitch/yaw sounds with squeaking wheels used on the other mortars
// [ ] Replace firing effects
// [ ] Add mortar player idle & firing animations
//==============================================================================
// Nice to Have
//==============================================================================
// [ ] Stop pitch/yaw noises when going into the firing mode
//==============================================================================

class DH_Model35MortarCannonPawn extends DHATGunCannonPawn;

var     float   FiringStartTimeSeconds;         // The time at which the firing animation started, relative to Level.TimeSeconds.
var     float   OverlayFiringAnimDuration;      // The duration of the firing animation on the overlay mesh. Calculated when entering the Firing state.
var()   float   FireDelaySeconds;               // The amount of time to wait into the firing animation before actually firing the round.

var()   name  FiringCameraBone;         // The name of the bone to use for the camera while firing.
var()   int   FiringCameraBoneChannel;  // The channel to use for the firing camera bone.
var()   name  GunFireAnim;              // The firing animation to play on the gun mesh.
var()   name  OverlayFiringAnimName;    // The name of the firing animation on the overlay mesh.
var()   float FiringCameraInTime;       // How long it takes to interpolate the camera to the firing camera position at the start of the firing animation.
var()   float FiringCameraOutTime;      // How long it takes to interpolate the camera back to the normal position at the end of the firing animation.

// First person hands.
var     DHMortarHandsActor  HandsActor;             // The first person hands actor.
var     Mesh                HandsMesh;              // The first person hands mesh.
var     DHDecoAttachment    HandsProjectile;        // The first person projectile.
var     int                 HandsHandsSkinIndex;    // The skin index for the hand.
var     int                 HandsSleeveSkinIndex;   // The skin index for the sleeves on the hands.

var()   Rotator             HandsRotationOffset;    // The rotation offset for the first person hands.
var()   name                HandsAttachBone;        // The bone to attach the first person hands to.
var()   name                HandsProjectileBone;    // The bone to attach the first person projectile to.
var()   array<name>         HandsFireAnims;         // The first person firing animations (selected randomly; make sure they are all the same length!).

struct SAnimationDriver
{
    var int Channel;
    var name BoneName;
    var name SequenceName;
    var int SequenceFrameCount;
};

var SAnimationDriver PitchAnimationDriver;

exec function CalibrateMortar(string AngleUnitString, int Samples)
{
    local DHBallisticProjectile BP;
    local int Pitch;    // Unreal units.
    local int MinPitch, MaxPitch;
    local float PitchStep;
    local UUnits.EAngleUnit AngleUnit;
    local DHVehicleCannon.EProjectileRotationMode OriginalRotationMode;

    // We need to temporarily change the rotation mode to current aim so that the projectile is spawned with the correct rotation.
    OriginalRotationMode = Cannon.ProjectileRotationMode;
    Cannon.ProjectileRotationMode = PRM_CurrentAim;

    if (Samples == 0)
    {
        Samples = 25;
    }

    AngleUnit = class'UUnits'.static.GetAngleUnitFromString(AngleUnitString);

    if (Level.NetMode == NM_Standalone)
    {
        MinPitch = GetGunPitchMin() - GunPitchOffset;
        MaxPitch = GetGunPitchMax() - GunPitchOffset;
        PitchStep = float(MaxPitch - MinPitch) / Samples;

        for (Pitch = MinPitch; Pitch < MaxPitch; Pitch += PitchStep)
        {
            Cannon.CurrentAim.Pitch = Pitch + GunPitchOffset;
            Cannon.CurrentAim.Yaw = 0;

            Cannon.CalcWeaponFire(false);

            BP = DHBallisticProjectile(Cannon.SpawnProjectile(Cannon.ProjectileClass, false));

            if (BP != none)
            {
                BP.bIsCalibrating = true;
                BP.LifeStart = Level.TimeSeconds;
                BP.DebugAngleValue = Pitch + GunPitchOffset;
                BP.DebugAngleUnit = AngleUnit;
                BP.StartLocation = BP.Location;
            }
        }
    }

    Cannon.ProjectileRotationMode = OriginalRotationMode;
}

simulated function Destroyed()
{
    if (HandsActor != none)
    {
        HandsActor.Destroy();
    }

    if (HandsProjectile != none)
    {
        HandsProjectile.Destroy();
    }

    super.Destroyed();
}

simulated function InitializeVehicleAndWeapon()
{
    super.InitializeVehicleAndWeapon();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetupFiringCameraChannel();
        SetupGunAnimationDrivers();
        UpdateGunAnimationDrivers();

        // Record the duration of the firing animation.
        OverlayFiringAnimDuration = Gun.GetAnimDuration(GunFireAnim);
    }
}

// TODO: When getting on and off this pawn, create and delete the hands actor (also if the player dies).
simulated function InitializeHands()
{
    local DHPlayer PC;
    local DHRoleInfo RI;

    if (HandsActor != none)
    {
        HandsActor.Destroy();
        HandsActor = none;
    }

    HandsActor = Spawn(class'DHMortarHandsActor', self);

    if (HandsActor == none)
    {
        Warn("Failed to spawn hands actor for mortar cannon pawn!");
        return;
    }

    HandsActor.LinkMesh(HandsMesh);
    HandsActor.bHidden = true;

    // Apply the player's hands and sleeve texture texture to the hands mesh.
    PC = DHPlayer(Controller);

    if (PC != none)
    {
        RI = DHRoleInfo(PC.GetRoleInfo());
    }

    if (RI != none)
    {
        HandsActor.Skins[HandsHandsSkinIndex] = RI.GetHandTexture(class'DH_LevelInfo'.static.GetInstance(Level));
        HandsActor.Skins[HandsSleeveSkinIndex] = RI.static.GetSleeveTexture();
    }

    if (Gun == none)
    {
        Warn("No gun found for mortar cannon pawn!");
        return;
    }
    
    Gun.AttachToBone(HandsActor, HandsAttachBone);
    HandsActor.SetRelativeLocation(vect(0, 0, 0));
    HandsActor.SetRelativeRotation(rot(0, 0, 0));

    if (HandsProjectile != none)
    {
        HandsProjectile.Destroy();
        HandsProjectile = none;
    }

    HandsProjectile = Spawn(class'DHDecoAttachment', self);

    // Get the selected projectile & use it's static mesh.
    if (HandsProjectile != none)
    {
        UpdateHandsProjectileStaticMesh();
        HandsActor.AttachToBone(HandsProjectile, HandsProjectileBone);
        HandsProjectile.SetRelativeLocation(vect(0, 0, 0));
        HandsProjectile.SetRelativeRotation(rot(0, 0, 0));
    }
}

simulated function UpdateHandsProjectileStaticMesh()
{
    if (HandsProjectile != none && Gun != none && Gun.ProjectileClass != none)
    {
        HandsProjectile.SetStaticMesh(Gun.ProjectileClass.default.StaticMesh);
    }
}

simulated function Fire(optional float F)
{
    // If the driver is in the spotting scope position, move down to the position where the mortar can be fired.
    if (DriverPositionIndex == SpottingScopePositionIndex)
    {
        NextWeapon();
        return;
    }

    if (!CanFire() || ArePlayersWeaponsLocked() || !Gun.ReadyToFire(false))
    {
        return;
    }

    GotoState('Firing');
}

// New state for the mortar to play the firing animation.
simulated state Firing
{
    // Don't let the user move, leave, or change the round type while firing.
    simulated function Fire(optional float F) { }
    function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange) { }
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

        // Interpolate the camera position and rotation between the normal and firing camera positions.
        global.SpecialCalcFirstPersonView(PC, ViewActor, NormalCameraLocation, NormalCameraRotation);

        // Hide the hands mesh if the camera is not fully in the firing position.
        // TODO: also need to do the projectile mesh!)
        HandsActor.bHidden = Theta < 1.0;

        ViewActor = self;
        CameraLocation = class'UVector'.static.VLerp(Theta, NormalCameraLocation, FiringCameraLocation);
        CameraRotation = QuatToRotator(QuatSlerp(QuatFromRotator(NormalCameraRotation), QuatFromRotator(FiringCameraRotation), Theta));

        // Neutralize the roll to prevent motion sickness.
        CameraRotation.Roll = 0;

        // Finalise the camera with any shake
        CameraLocation += PC.ShakeOffset >> PC.Rotation;
        CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    }

    simulated function BeginState()
    {
        if (IsLocallyControlled())
        {
            if (Gun != none)
            {
                Gun.PlayAnim(GunFireAnim, 1.0, 0.0, FiringCameraBoneChannel);
            }

            if (HandsActor != none)
            {
                HandsActor.PlayAnim(HandsFireAnims[Rand(HandsFireAnims.Length)], 1.0, 0.0, 0);
            }

            // TODO: turn off the rotate sound
            //Cannon.Base.RotateSoundAttachment.SoundVolume = 0;

            // Update the hands projectile mesh to the round we are about to fire.
            UpdateHandsProjectileStaticMesh();
        }

        FiringStartTimeSeconds = Level.TimeSeconds;
    }

Begin:
    FireDelaySeconds = FMin(OverlayFiringAnimDuration, default.FireDelaySeconds);
    Sleep(FireDelaySeconds);
    SuperFire();
    Sleep(OverlayFiringAnimDuration - FireDelaySeconds);
    GotoState('');
}

// Needed so that we can call the correct Fire function from within the Firing state.
function SuperFire()
{
    super.Fire();
}

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

// Modified so that we call our special tick function here.
// TODO: Just move this to the base class.
simulated state ViewTransition
{
    simulated function Tick(float DeltaTime)
    {
        super.Tick(DeltaTime);

        if (Level.NetMode != NM_DedicatedServer)
        {
            UpdateGunAnimationDrivers();
        }
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

simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    if (IsLocallyControlled())
    {
        InitializeHands();
    }
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    super.ClientKDriverLeave(PC);

    if (HandsActor != none)
    {
        HandsActor.Destroy();
        HandsActor = none;
    }
}

defaultproperties
{
    PitchAnimationDriver=(Channel=1,BoneName="PITCH_ROOT",SequenceName="PITCH_DRIVER",SequenceFrameCount=30)

    GunClass=class'DH_Guns.DH_Model35MortarCannon'

    // Spotting Scope
    DriverPositions(0)=(DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="overlay_out",ViewFOV=40.0,ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    // Kneeling
    DriverPositions(1)=(DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=55000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // Standing
    DriverPositions(2)=(DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // Binoculars
    DriverPositions(3)=(DriverTransitionAnim="stand_idleiron_binoc",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

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

    AmmoShellTextures(0)=Texture'DH_Model35Mortar_tex.interface.IT_HE_M110_3360_ICON'
    AmmoShellTextures(1)=Texture'DH_Model35Mortar_tex.interface.IT_SMOKE_M110_3360_ICON'
    AmmoShellTextures(2)=Texture'DH_Model35Mortar_tex.interface.IT_SMOKE_M110_B_ICON'

    AmmoShellReloadTextures(0)=Texture'DH_Model35Mortar_tex.interface.IT_HE_M110_3360_ICON_RELOAD'
    AmmoShellReloadTextures(1)=Texture'DH_Model35Mortar_tex.interface.IT_SMOKE_M110_3360_ICON_RELOAD'
    AmmoShellReloadTextures(2)=Texture'DH_Model35Mortar_tex.interface.IT_SMOKE_M110_B_ICON'

    ArtillerySpottingScopeClass=class'DH_Guns.DHArtillerySpottingScope_Model35Mortar'

    GunPitchOffset=7280 // +40 degrees

    FiringCameraInTime=0.65
    FiringCameraOutTime=0.65
    FiringCameraBone="MY_COOL_CAMERA"
    FiringCameraBoneChannel=3
    GunFireAnim="FIRINGCAMERA"

    HandsMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_hands'
    HandsFireAnims=("FIRE_HANDS")
    HandsAttachBone="PITCH"
    HandsSleeveSkinIndex=1
    HandsProjectileBone="PROJECTILE"
    HandsRotationOffset=(Yaw=-16384)

    FireDelaySeconds=2.35
}
