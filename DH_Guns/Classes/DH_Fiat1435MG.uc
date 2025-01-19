//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Interface art.
// [ ] Overheating barrels?? [kind of OP to have basically infinite ammo with no cooldown].
// [ ] Third person handling animations (yaw driver!).
// [ ] Using iron-sight zoom speed when using the zoom in/out (underlying function needs to be basically rewritten).
// [ ] Muzzle flash too far forward.
// [ ] Fix rig hierarchy so that dust cover animation works properly
// [ ] Sound notification for reload animation.
// [ ] Maybe make a little "ping" sound when the clip cycles.
// [ ] Fix timing of reload stages and remove the sounds.
// [ ] Destroyed mesh.
// [ ] Make sure it all works in MP.
//==============================================================================

class DH_Fiat1435MG extends DHVehicleMG;

// Range Driver
var name                    RangeDriverAnim;
var int                     RangeDriverAnimFrameCount;
var int                     RangeDriverChannel;
var name                    RangeDriverBone;
var DHUnits.EDistanceUnit   RangeDistanceUnit;
var int                     RangeIndex;

var private float           RangeDriverAnimationFrame;
var private float           RangeDriverAnimationFrameStart;
var private float           RangeDriverAnimationFrameTarget;
var private float           RangeDriverAnimationTimeSecondsStart;
var private float           RangeDriverAnimationTimeSecondsEnd;

var() float                 RangeDriverAnimationInterpDuration;

// Firing Animation
var int                     FiringChannel;
var name                    FiringBone;
var name                    FiringAnim;
var name                    FiringIdleAnim;

// Clip Animation
var name                    ClipBone;
var name                    ClipAnim;
var int                     ClipChannel;

// Shell Ejection
var()   class<RO3rdShellEject>  ShellEjectClass;
var()   name                    ShellEjectBone;
var()   Rotator                 ShellEjectRotationOffset;

// Ammo Round
var array<ROFPAmmoRound>    AmmoRounds;
var StaticMesh              AmmoRoundStaticMesh;
var array<name>             AmmoRoundBones;

// Range Table
struct RangeTableItem
{
    var() float Range;          // Range in the specified distance unit.
    var() float AnimationTime;  // Animation driver theta value.
};
var array<RangeTableItem> RangeTable;

// Reload
var()   name                    ReloadSequence;
var     float                   ReloadStartTimeSeconds; // The time that the reload animation started.
var     float                   ReloadEndTimeSeconds;   // The time that the reload animation will end.
var()   float                   ReloadCameraTweenTime;  // The time that the camera will tween back to the player's view.

replication
{
    reliable if (Role == ROLE_Authority)
        RangeIndex;
}

simulated function OnSwitchMesh()
{
    super.OnSwitchMesh();
    
    SetupAnimationDrivers();
    InitializeAmmoRounds();
    UpdateRangeDriverFrameTarget();
}

simulated function DestroyAmmoRounds()
{
    local int i;

    for (i = 0; i < AmmoRounds.Length; i++)
    {
        if (AmmoRounds[i] != none)
        {
            AmmoRounds[i].Destroy();
        }
    }

    AmmoRounds.Length = 0;
}

simulated function InitializeAmmoRounds()
{
    local int i;

    DestroyAmmoRounds();

    for (i = 0; i < AmmoRoundBones.Length; i++)
    {
        AmmoRounds[i] = Spawn(class'ROFPAmmoRound', self);

        if (AmmoRounds[i] == none)
        {
            continue;
        }

        AmmoRounds[i].bOwnerNoSee = false;

        AttachToBone(AmmoRounds[i], AmmoRoundBones[i]);
        AmmoRounds[i].SetStaticMesh(AmmoRoundStaticMesh);
    }
}

function Fire(Controller C)
{
    local coords ShellEjectCoords;
    local Actor ShellEjectActor;

    super.Fire(C);
    
    StartFiringAnimation();

    // TODO: make sure this will work in multiplayer; only have this run on the client. server doesn't care.
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (ShellEjectClass != none && ShellEjectBone != '')
        {
            ShellEjectCoords = GetBoneCoords(ShellEjectBone);

            ShellEjectActor = Spawn(ShellEjectClass, self,, ShellEjectCoords.Origin, GetBoneRotation(ShellEjectBone));
            ShellEjectActor.SetRotation(ShellEjectActor.Rotation + ShellEjectRotationOffset);

            // The class defines bOwnerNoSee as true since this is meant only for third person, but we want to just
            // reuse the same class for first person as well.
            ShellEjectActor.bOwnerNoSee = false;
        }
    }
    
    UpdateClip();
}

function StartFiringAnimation()
{
    if (FiringChannel != 0)
    {
        LoopAnim(FiringAnim, 1.0, 0.0, FiringChannel);
    }
}

function StopFiringAnimation()
{
    if (FiringChannel != 0)
    {
        PlayAnim(FiringIdleAnim, 1.0, 0.0, FiringChannel);
    }
}

function CeaseFire(Controller C, Bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    StopFiringAnimation();
}

simulated function SetRangeDriverFrameTarget(float NewFrameTarget, optional float InterpDuration)
{
    RangeDriverAnimationFrameStart = RangeDriverAnimationFrame;
    RangeDriverAnimationFrameTarget = NewFrameTarget;
    RangeDriverAnimationTimeSecondsStart = Level.TimeSeconds;
    RangeDriverAnimationTimeSecondsEnd = RangeDriverAnimationTimeSecondsStart + InterpDuration;
}

simulated state Reloading
{
    // Don't allow the player to change the range while reloading.
    simulated function DecrementRange();
    simulated function IncrementRange();
    
    simulated function BeginState()
    {
        local DH_Fiat1435MGPawn MGPawn;

        MGPawn = DH_Fiat1435MGPawn(WeaponPawn);

        // Disable the clip driver.
        if (ClipChannel != 0)
        {
            AnimBlendParams(ClipChannel, 0.0,,, ClipBone);
        }

        // Disable the firing driver (since this controls the bolt and we animate the bolt in the reload animation).
        if (FiringChannel != 0)
        {
            AnimBlendParams(FiringChannel, 0.0,,, FiringBone);
        }

        // For simplicity, just have a single reload phase.
        ReloadStartTimeSeconds = Level.TimeSeconds;
        ReloadEndTimeSeconds = Level.TimeSeconds + GetAnimDuration(ReloadSequence);

        PlayAnim(ReloadSequence, 1.0, 0.0, 0.0);

        // Zoom out.
        if (MGPawn != none)
        {
            MGPawn.PlayHandsReloadAnim();

            MGPawn.SetIsZoomed(false);
        }
    }

    simulated function EndState()
    {
        // Enable the clip driver.
        if (ClipChannel != 0)
        {
            AnimBlendParams(ClipChannel, 1.0,,, ClipBone);

            // Force the clip into the "full" position.
            FreezeAnimAt(0.0, ClipChannel);
        }

        // Enable the firing driver.
        if (FiringChannel != 0)
        {
            AnimBlendParams(FiringChannel, 1.0,,, FiringBone);
        }
    }

Begin:
    Sleep(GetAnimDuration(ReloadSequence));
    GotoState('');
}

simulated function Tick(float DeltaTime)
{
    local float T;

    // Only do all this crap if the local player is the driver.
    if (RangeDriverChannel != 0 && WeaponPawn != none && WeaponPawn.IsLocallyControlled())
    {
        if (RangeDriverAnimationFrameTarget != RangeDriverAnimationFrame)
        {
            T = class'UInterp'.static.MapRangeClamped(Level.TimeSeconds, RangeDriverAnimationTimeSecondsStart, RangeDriverAnimationTimeSecondsEnd, 0.0, 1.0);

            RangeDriverAnimationFrame = class'UInterp'.static.Deceleration(T, RangeDriverAnimationFrameStart, RangeDriverAnimationFrameTarget);

            UpdateRangeDriver();
        }
    }
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetupAnimationDrivers();
}

simulated function SetupAnimationDrivers()
{
    if (FiringChannel != 0)
    {
        AnimBlendParams(FiringChannel, 1.0,,, FiringBone);
        PlayAnim(FiringIdleAnim, 0.0, 0.0, FiringChannel);
    }

    if (RangeDriverChannel != 0)
    {
        AnimBlendParams(RangeDriverChannel, 1.0,,, RangeDriverBone);
        PlayAnim(RangeDriverAnim, 0.0, 0.0, RangeDriverChannel);
        UpdateRangeDriver();
    }

    if (ClipChannel != 0)
    {
        AnimBlendParams(ClipChannel, 1.0,,, ClipBone);
        PlayAnim(ClipAnim, 0.0, 0.0, ClipChannel);
        UpdateClipDriver(MainAmmoCharge[0]);
    }
}

simulated function UpdateRangeDriver()
{
    if (RangeDriverChannel == 0)
    {
        return;
    }
    
    FreezeAnimAt(RangeDriverAnimationFrame, RangeDriverChannel);
}

simulated function UpdateAmmoRounds(int Ammo)
{
    local int i;
    local int ClipsVisible;

    ClipsVisible = Ceil(float(Ammo) / ROUNDS_PER_CLIP);

    for (i = 0; i < AmmoRounds.Length; i++)
    {
        if (AmmoRounds[i] != none)
        {
            AmmoRounds[i].bHidden = AmmoRounds.Length - i > ClipsVisible;
        }
    }
}

simulated function UpdateClipWithAmmo(int Ammo)
{
    UpdateAmmoRounds(Ammo);
    UpdateClipDriver(Ammo);
}

simulated function UpdateClip()
{
    UpdateClipWithAmmo(MainAmmoCharge[0]);
}

simulated function UpdateClipDriver(int Ammo)
{
    const ROUNDS_PER_CLIP = 5;
    const CLIP_PER_MAG = 10;
    const CLIP_DRIVER_FRAMES = 11;

    local float ClipFrame;
    local int ClipsVisible;

    if (ClipChannel == 0)
    {
        return;
    }

    ClipsVisible = Ceil(float(Ammo) / ROUNDS_PER_CLIP);
    ClipFrame = CLIP_DRIVER_FRAMES - (ClipsVisible + 1);

    FreezeAnimAt(ClipFrame, ClipChannel);
}

simulated function RangeIndexChanged()
{
    // Send a message to the player's HUD.
    if (WeaponPawn != none && WeaponPawn.IsLocallyControlled())
    {
        WeaponPawn.ReceiveLocalizedMessage(class'DHWeaponRangeMessage', RangeTable[RangeIndex].Range);
    }

    UpdateRangeDriverFrameTarget(RangeDriverAnimationInterpDuration);
}

simulated function UpdateRangeDriverFrameTarget(optional float InterpDuration)
{
    SetRangeDriverFrameTarget(RangeTable[RangeIndex].AnimationTime * (RangeDriverAnimFrameCount - 1), InterpDuration);
}

simulated function DecrementRange()
{
    super.DecrementRange();

    if (RangeIndex > 0)
    {
        RangeIndex--;
        RangeIndexChanged();
    }
}

simulated function IncrementRange()
{
    super.IncrementRange();

    if (RangeIndex < RangeTable.Length - 1)
    {
        RangeIndex++;
        RangeIndexChanged();
    }
}

simulated function StartReload(optional bool bResumingPausedReload)
{
    super.StartReload(bResumingPausedReload);

    // TODO: only do this if we're locally controlled.
    GotoState('Reloading');
}

// Called from animation when the clip goes out of view.
simulated event ClipFill()
{
    UpdateClipWithAmmo(InitialPrimaryAmmo);
}

defaultproperties
{
    ReloadSequence="RELOAD_WC"
    ReloadCameraTweenTime=0.5

    RangeDistanceUnit=DU_Meters
    RangeDriverAnim="SIGHT_DRIVER"
    RangeDriverAnimFrameCount=10
    RangeDriverChannel=1
    RangeDriverBone="REAR_SIGHT"
    
    RangeTable(0)=(Range=100.0,AnimationTime=0.120)
    RangeTable(1)=(Range=200.0,AnimationTime=0.135)
    RangeTable(2)=(Range=300.0,AnimationTime=0.150)
    RangeTable(3)=(Range=400.0,AnimationTime=0.165)
    RangeTable(4)=(Range=500.0,AnimationTime=0.190)
    RangeTable(5)=(Range=600.0,AnimationTime=0.230)
    RangeTable(6)=(Range=700.0,AnimationTime=0.27)
    RangeTable(7)=(Range=800.0,AnimationTime=0.31)
    RangeTable(8)=(Range=900.0,AnimationTime=0.36)
    RangeTable(9)=(Range=1000.0,AnimationTime=0.41)

    Mesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_WC_3RD'
    YawBone=MG_YAW
    PitchBone=MG_PITCH

    bLimitYaw=true
    MaxNegativeYaw=-2184    // -12 degrees
    MaxPositiveYaw=2184     // +12 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    // Ammo
    ProjectileClass=class'DH_Guns.DH_Fiat1435Bullet'
    InitialPrimaryAmmo=50
    NumMGMags=20
    FireInterval=0.1    // 600rpm
    TracerProjectileClass=class'DH_Guns.DH_Fiat1435TracerBullet'
    TracerFrequency=7

    // Weapon fire
    FireSoundClass=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoopEnd'
    ShakeRotMag=(X=30.0,Y=30.0,Z=30.0)
    ShakeOffsetMag=(X=0.02,Y=0.02,Z=0.02)
    WeaponFireAttachmentBone="MUZZLE_WC"
    WeaponFireOffset=0

    RangeDriverAnimationInterpDuration=0.5

    FiringAnim=BOLT_FIRING
    FiringIdleAnim=BOLT_IDLE
    FiringChannel=2
    FiringBone=FIRING_ROOT

    ClipBone=CLIP
    ClipAnim=CLIP_DRIVER
    ClipChannel=3

    ShellEjectBone=EJECTOR
    ShellEjectClass=class'RO3rdShellEject762x54mm'
    ShellEjectRotationOffset=(Pitch=-16384,Yaw=16384)

    AmmoRoundStaticMesh=StaticMesh'DH_Fiat1435_stc.FIAT1435_CLIP_CARTRIDGE_1ST'
    AmmoRoundBones(0)="CLIP_CARTRIDGES_01"
    AmmoRoundBones(1)="CLIP_CARTRIDGES_02"
    AmmoRoundBones(2)="CLIP_CARTRIDGES_03"
    AmmoRoundBones(3)="CLIP_CARTRIDGES_04"
    AmmoRoundBones(4)="CLIP_CARTRIDGES_05"
    AmmoRoundBones(5)="CLIP_CARTRIDGES_06"
    AmmoRoundBones(6)="CLIP_CARTRIDGES_07"
    AmmoRoundBones(7)="CLIP_CARTRIDGES_08"
    AmmoRoundBones(8)="CLIP_CARTRIDGES_09"
    AmmoRoundBones(9)="CLIP_CARTRIDGES_10"

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Fiat1435_stc.FIAT1435_GUN_WC_COLLISION_YAW',AttachBone="MG_YAW")

    ProjectileRotationMode=PRM_MuzzleBone

    // Regular MGs do not have collision on because it's assumed that they're a small part
    // mounted on a larger vehicle. In this case, we want to have collision on because it's
    // a standalone weapon.
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true
}
