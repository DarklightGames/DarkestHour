//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Replace pitch/yaw sounds with squeaking wheels used on the other mortars
// [ ] Stop pitch/yaw noises when going into the firing mode
//==============================================================================

class DHMortarCannonPawn extends DHATGunCannonPawn
    abstract;

var     int     FiringDriverPositionIndex;      // The driver position index that allows the gun to be fired.

var     float   FiringStartTimeSeconds;         // The time at which the firing animation started, relative to Level.TimeSeconds.
var     float   OverlayFiringAnimDuration;      // The duration of the firing animation on the overlay mesh. Calculated when entering the Firing state.
var()   float   FireDelaySeconds;               // The amount of time to wait into the firing animation before actually firing the round.

var()   name  HandsFiringCameraBone;    // The name of the bone to use for the camera while firing.
var()   name  HandsFiringAnimName;      // The name of the firing animation on the hands mesh.
var()   float FiringCameraInTime;       // How long it takes to interpolate the camera to the firing camera position at the start of the firing animation.
var()   float FiringCameraOutTime;      // How long it takes to interpolate the camera back to the normal position at the end of the firing animation.
var()   float ProjectileLifeSpan;       // The life span of the projectile attached to the gunner's hand.

// First person hands.
var     DHFirstPersonHands  HandsActor;             // The first person hands actor.
var     Mesh                HandsMesh;              // The first person hands mesh.
var     DHDecoAttachment    HandsProjectile;        // The first person projectile.
var     Rotator             HandsProjectileRelativeRangeMin;
var     Rotator             HandsProjectileRangeMax;

var()   Vector              HandsRelativeLocation;  // The location of the hands in actor relation to it's attachment bone.
var()   name                HandsAttachBone;        // The bone to attach the first person hands to.
var()   name                HandsProjectileBone;    // The bone to attach the first person projectile to.

struct FireAnim
{
    var float Angle;
    var name AnimName;
};
var private array<FireAnim> PlayerFireAnims;

struct SAnimationDriver
{
    var int Channel;
    var name BoneName;
    var name SequenceName;
    var int SequenceFrameCount;
};

var SAnimationDriver PitchAnimationDriver;

// Used for triggering the firing animation on the client since
// server-to-client functions are for the owning client only.
var byte PlayerFireCount;
var byte OldPlayerFireCount;
var StaticMesh FiringProjectileMesh;

replication
{
    reliable if (Role < ROLE_Authority)
        ServerPlayThirdPersonFiringAnim;
    reliable if (Role == ROLE_Authority)
        PlayerFireCount, FiringProjectileMesh;
}

// TODO: move this to the base class, add sanity checks.
simulated exec function HandsRelPos(float X)
{
    HandsRelativeLocation.X = X;

    if (HandsActor != none)
    {
        HandsActor.SetRelativeLocation(HandsRelativeLocation);
    }
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (RemoteRole != ROLE_Authority)
    {
        OldPlayerFireCount = PlayerFireCount;
    }
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (PlayerFireCount != OldPlayerFireCount)
    {
        OldPlayerFireCount = PlayerFireCount;

        PlayThirdPersonFiringAnim();
    }
}

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
                BP.CreateCalibrationInfo(VehWep, BP.Location, Pitch + GunPitchOffset, AngleUnit);
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
        SetupGunAnimationDrivers();
        UpdateGunAnimationDrivers();
    }
}

simulated function InitializeHands()
{
    local DHPlayer PC;
    local DHRoleInfo RI;

    if (Gun == none)
    {
        Warn("No gun found for mortar cannon pawn!");
        return;
    }

    if (HandsActor != none)
    {
        HandsActor.Destroy();
        HandsActor = none;
    }

    HandsActor = Spawn(class'DHFirstPersonHands', self);

    if (HandsActor == none)
    {
        Warn("Failed to spawn hands actor for mortar cannon pawn!");
        return;
    }

    // Set the hands skin based on the player's role.
    HandsActor.LinkMesh(HandsMesh);
    HandsActor.SetSkins(DHPlayer(Controller));

    HandsActor.bHidden = true;
    
    Gun.AttachToBone(HandsActor, HandsAttachBone);

    HandsActor.SetRelativeLocation(HandsRelativeLocation);
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

    // Record the duration of the firing animation.
    OverlayFiringAnimDuration = HandsActor.GetAnimDuration(HandsFiringAnimName);
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
    // If the driver is not in the firing position, switch positions in the direction of the firing position.
    if (DriverPositionIndex < FiringDriverPositionIndex)
    {
        NextWeapon();
        return;
    }
    else if (DriverPositionIndex > FiringDriverPositionIndex)
    {
        PrevWeapon();
        return;
    }

    if (!CanFire() || ArePlayersWeaponsLocked() || !Gun.ReadyToFire(false))
    {
        return;
    }

    GotoState('Firing');
}

// Get the firing animations to play based on the gun pitch.
// Anim1 is the base animation, or the one that is closest to the current pitch.
// Anim2 is the next animation to blend into.
// BlendAlpha is the alpha value to blend between the two animations.
simulated function GetFireAnims(out name AnimName1, out name AnimName2, out float BlendAlpha)
{
    local int i, j;
    local float Pitch;

    Pitch = class'UUnits'.static.UnrealToDegrees(GetGunPitch());

    if (Pitch < PlayerFireAnims[0].Angle)
    {
        AnimName1 = PlayerFireAnims[0].AnimName;
        AnimName2 = PlayerFireAnims[0].AnimName;
        BlendAlpha = 0.0;
        return;
    }
    else if (Pitch > PlayerFireAnims[PlayerFireAnims.Length - 1].Angle)
    {
        AnimName1 = PlayerFireAnims[PlayerFireAnims.Length - 1].AnimName;
        AnimName2 = PlayerFireAnims[PlayerFireAnims.Length - 1].AnimName;
        BlendAlpha = 0.0;
        return;
    }

    // Find the two animations to blend between.
    for (i = 0; i < PlayerFireAnims.Length - 1; ++i)
    {
        j = Min(i + 1, PlayerFireAnims.Length - 1);

        if (Pitch >= PlayerFireAnims[i].Angle && Pitch <= PlayerFireAnims[j].Angle)
        {
            AnimName1 = PlayerFireAnims[i].AnimName;
            AnimName2 = PlayerFireAnims[j].AnimName;

            if (i == j)
            {
                BlendAlpha = 0.0;
            }
            else
            {
                BlendAlpha = (Pitch - PlayerFireAnims[i].Angle) / (PlayerFireAnims[j].Angle - PlayerFireAnims[i].Angle);
            }

            break;
        }
    }
}

simulated function PlayThirdPersonFiringAnim()
{
    local name AnimName1, AnimName2;
    local float BlendAlpha;
    local DHDecoAttachment ProjectileMesh;

    if (Driver == none)
    {
        return;
    }

    GetFireAnims(AnimName1, AnimName2, BlendAlpha);

    Driver.PlayAnim(AnimName1);
    Driver.AnimBlendParams(1, BlendAlpha, 0.2, 0.2, '');
    Driver.PlayAnim(AnimName2, 1.0, 0.0, 1);

    // Spawn the projectile mesh on the client for the firing animation.
    ProjectileMesh = Spawn(class'DHDecoAttachment', self);
    ProjectileMesh.SetStaticMesh(FiringProjectileMesh);

    Driver.AttachToBone(ProjectileMesh, 'weapon_rhand');
    
    ProjectileMesh.SetRelativeLocation(vect(0, 0, 0));
    ProjectileMesh.SetRelativeRotation(rot(0, 0, 0));
    ProjectileMesh.LifeSpan = ProjectileLifeSpan;
}

function ServerPlayThirdPersonFiringAnim(class<Projectile> ProjectileClass)
{
    // Increment counter so that remote clients are notified to play the firing animation.
    PlayerFireCount++;
    FiringProjectileMesh = ProjectileClass.default.StaticMesh;

    // Also play the firing animation on the server so that the hitboxes more or less line up (latency permitting).
    PlayThirdPersonFiringAnim();
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

        // TODO: convert this to be attached to be on the hands mesh.
        // this will negate the need for mortar-specific camera animations.
        FiringCameraBoneCoords = HandsActor.GetBoneCoords(HandsFiringCameraBone);
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
        HandsActor.bHidden = Theta < 1.0;

        ViewActor = self;
        CameraLocation = class'UVector'.static.VLerp(Theta, NormalCameraLocation, FiringCameraLocation);
        CameraRotation = QuatToRotator(QuatSlerp(QuatFromRotator(NormalCameraRotation), QuatFromRotator(FiringCameraRotation), Theta));

        // Neutralize the roll to prevent motion sickness.
        CameraRotation.Roll = CameraRotation.Roll * (1.0 - Theta);

        // Finalise the camera with any shake
        CameraLocation += PC.ShakeOffset >> PC.Rotation;
        CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    }

    simulated function BeginState()
    {
        local DHPlayer PC;
        
        PC = DHPlayer(Controller);

        if (IsLocallyControlled())
        {
            // Trigger the firing animation on the driver.
            ServerPlayThirdPersonFiringAnim(Gun.ProjectileClass);

            if (PC != none && GetGunPitch() > class'UUnits'.static.DegreesToUnreal(89))
            {
                // "You have just launched a mortar round straight up into the air. You may want to take cover!"
                PC.QueueHint(66, true);
            }

            if (HandsActor != none)
            {
                HandsActor.PlayAnim(HandsFiringAnimName, 1.0, 0.0);
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
    bNetNotify=true
}
