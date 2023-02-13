//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHDestroyableStaticMesh extends Actor
    notplaceable;

var int             Health;
var StaticMesh      DestroyedStaticMesh;
var class<Emitter>  DestroyedEmitterClass;
var vector          DestroyedEmitterOffset;
var sound           DestroyedSound;
var float           DestroyedSoundVolume;
var float           DestroyedSoundRadius;
var float           DestroyedLifeSpan;

replication
{
    reliable if (Role == ROLE_Authority)
        ClientPlayDestroyedEffects;
}

event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    Health -= Damage;

    if (Health <= 0)
    {
        BreakMe();
    }
}

function BreakMe()
{
    GotoState('Broken');
}

state Broken // NOTE: can't name it "Destroyed" because that's the name of a function
{
    function BeginState()
    {
        if (DestroyedStaticMesh != none)
        {
            SetStaticMesh(DestroyedStaticMesh);
        }

        if (Role == ROLE_Authority)
        {
            ClientPlayDestroyedEffects();
        }

        if (DestroyedSound != none)
        {
            PlaySound(DestroyedSound, SLOT_None, DestroyedSoundVolume,, DestroyedSoundRadius);
        }

        LifeSpan = DestroyedLifeSpan;

        if (DestroyedStaticMesh == none)
        {
            // If there is no destroyed static mesh here, simply destroy the actor.
            Destroy();
        }
    }
}

simulated function ClientPlayDestroyedEffects()
{
    local Emitter DestroyedEmitter;
    local vector SpawnLocation;

    if (DestroyedEmitterClass != none)
    {
        SpawnLocation = Location + (DestroyedEmitterOffset << Rotation);
        DestroyedEmitter = Spawn(DestroyedEmitterClass,,, SpawnLocation, Rotation);
    }
}

defaultproperties
{
    DrawType=DT_StaticMesh
    RemoteRole=ROLE_SimulatedProxy
    Health=100
    bStatic=false
    bNoDelete=false
    bCanBeDamaged=true
    bUseCylinderCollision=false
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
    bBlockKarma=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
    bBlockProjectiles=true
    bProjTarget=true
    bPathColliding=true
    bWorldGeometry=true
}

