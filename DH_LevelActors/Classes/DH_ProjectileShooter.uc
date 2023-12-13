//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ProjectileShooter extends Actor
    placeable;

var() enum ETargetMode
{
    TM_None,
    TM_Sequential,
    TM_Random,
} TargetMode;

var() name TargetTag;
var() class<Projectile> ProjectileClass;
var() int MaxProjectiles;
var() float FireInterval;
var() float FireDelay;

var array<Actor> TargetActors;
var int FireCount;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    FindTargetActors();
}

simulated function FindTargetActors()
{
    local int i;
    local Actor TargetActor;

    super.PostBeginPlay();

    foreach AllActors(class'Actor', TargetActor, TargetTag)
    {
        TargetActors[TargetActors.Length] = TargetActor;
    }
}

simulated event Trigger(Actor Other, Pawn EventInstigator)
{
    GotoState('Firing');
}

state Firing
{
    function BeginState()
    {
        local float FireTime;

        super.BeginState();

        SetTimer(FireDelay, false);

        Level.Game.Broadcast(self, "Firing started");
    }

    function Timer()
    {
        local float FireTime;

        if (FireCount >= MaxProjectiles)
        {
            GotoState('');
            return;
        }

        SpawnProjectile();

        FireCount++;

        SetTimer(FireInterval, false);
    }

    function EndState()
    {
        super.EndState();

        Level.Game.Broadcast(self, "Firing ended");
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

simulated function SpawnProjectile()
{
    local Projectile Projectile;
    local Rotator ProjectileRotation;

    if (ProjectileClass == none)
    {
        return;
    }

    ProjectileRotation = GetProjectileRotation();
    Projectile = Spawn(ProjectileClass,,, Location, ProjectileRotation);
    // TODO: optionally remove gravity from the projectile.
}

defaultproperties
{
    bHidden=true
    MaxProjectiles=1
    Role=ROLE_Authority
    FireInterval=0.1
}