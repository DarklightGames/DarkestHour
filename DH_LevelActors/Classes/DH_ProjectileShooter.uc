//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ProjectileShooter extends DH_LevelActors
    showcategories(Sound)
    placeable;

var() enum ETargetMode
{
    TM_None,
    TM_Sequential,
    TM_Random,
} TargetMode;

var() enum EProjectileMode
{
    PM_Sequential,
    PM_Random,
} ProjectileMode;

var() name TargetTag;
var() array<class<Projectile> > ProjectileClasses;
var() int MaxProjectiles;
var() float FireInterval;
var() Range FireDelayRange;
var() float ProjectileOffset;

var() enum EFiringSoundType
{
    FST_None,
    FST_Looping,
    FST_Single,
} FiringSoundType;

var() Sound LoopingFireSound;
var() Sound SingleFireSound;

var() class<WeaponAmbientEmitter> WeaponAmbientEmitterClass;
var WeaponAmbientEmitter WeaponAmbientEmitter;

var array<Actor> TargetActors;
var int FireCount;
var bool bIsFiring;
var bool bOldIsFiring;

replication
{
    reliable if (Role == ROLE_Authority)
        bIsFiring;
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (bIsFiring != bOldIsFiring)
    {
        // Update the emitter status to reflect the firing state.
        WeaponAmbientEmitter.SetEmitterStatus(bIsFiring);
    }

    bOldIsFiring = bIsFiring;
}

function Reset()
{
    super.Reset();

    FireCount = 0;
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        WeaponAmbientEmitter = Spawn(WeaponAmbientEmitterClass,,, Location, Rotation);
        WeaponAmbientEmitter.Attach(self);
    }

    FindTargetActors();
}

simulated function FindTargetActors()
{
    local Actor TargetActor;

    super.PostBeginPlay();

    foreach AllActors(class'Actor', TargetActor, TargetTag)
    {
        TargetActors[TargetActors.Length] = TargetActor;
    }
}

simulated event Trigger(Actor Other, Pawn EventInstigator)
{
    if (Role == ROLE_Authority)
    {
        GotoState('Firing');
    }
}

simulated function class<Projectile> GetProjectileClass()
{
    local int i;

    if (ProjectileClasses.Length == 0)
    {
        return none;
    }

    switch (ProjectileMode)
    {
        case PM_Sequential:
            i = FireCount % ProjectileClasses.Length;
            break;

        case PM_Random:
            i = Rand(ProjectileClasses.Length);
            break;
    }

    return ProjectileClasses[i];
}

state Firing
{
    function BeginState()
    {
        local float FireDelay;

        super.BeginState();

        // Set the firing flag so that the client can update the emitter status.
        bIsFiring = true;

        FireDelay = FireDelayRange.Min + FRand() * (FireDelayRange.Max - FireDelayRange.Min);

        if (FireDelay <= 0.0)
        {
            Timer();
        }
        else
        {
            SetTimer(FireDelay, false);
        }

        if (FiringSoundType == FST_Looping)
        {
            AmbientSound = LoopingFireSound;
        }
    }

    function Timer()
    {
        if (FireCount >= MaxProjectiles)
        {
            GotoState('');
            return;
        }

        SpawnProjectile();

        if (FiringSoundType == FST_Single)
        {
            PlaySound(SingleFireSound);
        }

        FireCount++;

        SetTimer(FireInterval, false);
    }

    function EndState()
    {
        super.EndState();

        if (FiringSoundType == FST_Looping)
        {
            AmbientSound = none;
        }
    }
}

simulated function Rotator GetProjectileRotation()
{
    local int i;
    local Vector TargetLocation;

    if (TargetMode == TM_None)
    {
        return Rotation;
    }

    switch (TargetMode)
    {
        case TM_Sequential:
            i = FireCount % TargetActors.Length;
            break;

        case TM_Random:
            i = Rand(TargetActors.Length);
            break;
    }

    TargetLocation = TargetActors[i].Location;

    // Return the rotation to the target location.
    return Rotator(TargetLocation - Location);
}

simulated function Projectile SpawnProjectile()
{
    local Rotator ProjectileRotation;
    local Vector ProjectileLocation;

    ProjectileRotation = GetProjectileRotation();
    ProjectileLocation = Location + vector(Rotation) * ProjectileOffset;
    
    return Spawn(GetProjectileClass(),,, Location, ProjectileRotation);
}

defaultproperties
{
    bHidden=true
    MaxProjectiles=1
    RemoteRole=ROLE_SimulatedProxy
    FireInterval=0.1
    bDirectional=true
    ProjectileOffset=32.0
}