//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Properly animate clips in clip driver.
// [ ] Force update clip driver when gun is reloaded.
// [ ] Force update range driver when player enters the vehicle.
// [ ] Try to fix "roll" issue with rotation (not critical, but would be nice).
// [ ] Add a reload animation.
// [ ] Interface art.
// [ ] Overheating barrels?? [kind of OP to have basically infinite ammo with no cooldown].
// [ ] Attach clips as "bullets", same as on the first person weapons.
//==============================================================================

class DH_Fiat1435MG extends DHVehicleMG;

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

var int                     FiringChannel;
var name                    FiringBone;
var name                    FiringAnim;
var name                    FiringIdleAnim;

var name                    ClipBone;
var name                    ClipAnim;
var int                     ClipChannel;

var class<RO3rdShellEject>  ShellEjectClass;
var name                    ShellEjectBone;

// Ammo rounds.
var array<ROFPAmmoRound>    AmmoRounds;
var StaticMesh              AmmoRoundStaticMesh;
var array<name>             AmmoRoundBones;

struct RangeTableItem
{
    var() float Range;          // Range in the specified distance unit.
    var() float AnimationTime;  // Animation driver theta value.
};
var array<RangeTableItem> RangeTable;

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

            // TODO: rotation on this is wrong.
            ShellEjectActor = Spawn(ShellEjectClass, self,, ShellEjectCoords.Origin, GetBoneRotation(ShellEjectBone));
            //ShellEjectActor.Rotation = GetBoneRotation(Muzzle)

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

simulated function SetRangeDriverFrameTarget(float NewFrameTarget)
{
    RangeDriverAnimationFrameStart = RangeDriverAnimationFrame;
    RangeDriverAnimationFrameTarget = NewFrameTarget;
    RangeDriverAnimationTimeSecondsStart = Level.TimeSeconds;
    RangeDriverAnimationTimeSecondsEnd = RangeDriverAnimationTimeSecondsStart + RangeDriverAnimationInterpDuration;
}

simulated function Tick(float DeltaTime)
{
    local float T;

    // Only do all this crap if the local player is the driver.
    if (RangeDriverChannel != 0 && WeaponPawn.IsLocallyControlled())
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
        UpdateClipDriver();
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

simulated function UpdateAmmoRounds()
{
    local int i;
    local int ClipsVisible;

    ClipsVisible = Ceil(float(MainAmmoCharge[0]) / ROUNDS_PER_CLIP);

    for (i = 0; i < AmmoRounds.Length; i++)
    {
        if (AmmoRounds[i] != none)
        {
            AmmoRounds[i].bHidden = AmmoRounds.Length - i > ClipsVisible;
        }
    }
}

simulated function UpdateClip()
{
    UpdateAmmoRounds();
    UpdateClipDriver();
}

simulated function UpdateClipDriver()
{
    const ROUNDS_PER_CLIP = 5;
    const CLIP_PER_MAG = 10;
    const CLIP_DRIVER_FRAMES = 11;

    local float ClipFrame;
    local int ClipsVisible;
    local int TotalClips;

    if (ClipChannel == 0)
    {
        return;
    }

    TotalClips = default.MainAmmoCharge[0] / ROUNDS_PER_CLIP;
    ClipsVisible = Ceil(float(MainAmmoCharge[0]) / ROUNDS_PER_CLIP);
    ClipFrame = CLIP_DRIVER_FRAMES - (ClipsVisible + 1);

    FreezeAnimAt(ClipFrame, ClipChannel);
}

simulated function RangeIndexChanged()
{
    // Send a message to the player's HUD.
    if (WeaponPawn != none)
    {
        WeaponPawn.ReceiveLocalizedMessage(class'DHWeaponRangeMessage', RangeTable[RangeIndex].Range);
    }

    UpdateRangeDriverFrameTarget();
}

simulated function UpdateRangeDriverFrameTarget()
{
    SetRangeDriverFrameTarget(RangeTable[RangeIndex].AnimationTime * (RangeDriverAnimFrameCount - 1));
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

defaultproperties
{
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
    WeaponFireAttachmentBone=MUZZLE_WC
    WeaponFireOffset=0

    RangeDriverAnimationInterpDuration=0.5

    FiringAnim=BOLT_FIRING
    FiringIdleAnim=BOLT_IDLE
    FiringChannel=2
    FiringBone=BOLT

    ClipBone=CLIP
    ClipAnim=CLIP_DRIVER
    ClipChannel=3

    ShellEjectBone=EJECTOR
    ShellEjectClass=class'RO3rdShellEject762x25mm'

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
}
