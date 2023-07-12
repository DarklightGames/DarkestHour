//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGrenadeProjectile_Smoke extends DHGrenadeProjectile
    abstract;

// TODO: suspect the smoke loop sound could be moved to the smoke effect emitter, probably the ignite sound too
// It's an actor so should be able to play AmbientSound or transient sound, or use a sound effect in one of its ParticleEmitters
// Would simplify this projectile as wouldn't need delayed destruction, server tear off or use of timer - could simply destroy itself when it explodes
// Similar applies to cannon & mortar smoke shells

var     class<Emitter>  SmokeEmitterClass;
var     sound           SmokeIgniteSound;
var     sound           SmokeLoopSound;
var     float           SmokeSoundDuration;

// Function emptied out to remove everything relating to explosion, as not an exploding grenade
simulated function Destroyed()
{
}

// Modified to remove 'Fear' stuff, as not an exploding grenade
simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, class'UUnits'.static.UnrealToRadians(Rotation.Yaw)))));
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

// Modified to add smoke effects & to remove actor destruction on client
// Actor is torn off & then destroyed on server, but persists for its LifeSpan on clients so grenade is still visible on ground & makes the smoke sound
simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Emitter SmokeEmitter;

    BlowUp(HitLocation);

    bTearOff = true; // stops any further replication, but client copies of actor persist so we still see the grenade on the ground

    if (Level.NetMode != NM_DedicatedServer)
    {
        SmokeEmitter = Spawn(SmokeEmitterClass, self,, HitLocation, rotator(vect(0.0, 0.0, 1.0)));
        SmokeEmitter.SetBase(self); // base the emitter on the grenade so if it bursts in mid-air the smoke emission travels with the grenade
        PlaySound(SmokeIgniteSound, SLOT_NONE, 1.5,, 200.0);
        AmbientSound = SmokeLoopSound;
        SetTimer(SmokeSoundDuration, false);  // to switch off smoke sound when it stops discharging
        LifeSpan = SmokeSoundDuration + 10.0; // this actor will persist as long as the smoke sound, then stay inert on ground for an extra 10 secs & then auto-destroy
    }
    else
    {
        LifeSpan = 1.0; // on a server this actor will be automatically destroyed in 1 second, allowing time for bTearOff to replicate to clients
    }
}

// Switches off sound sound when grenade is no longer discharging smoke
simulated function Timer()
{
    AmbientSound = none;
}

// Modified to remove everything relating to explosion & damage, as not an exploding grenade
function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        MakeNoise(1.0);
    }
}

defaultproperties
{
    bAlwaysRelevant=true // has to be always relevant so that the smoke effect always gets spawned
    FailureRate=0.0 // don't have smoke grenades fail
    Damage=0.0
    DamageRadius=0.0
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_Grenade'
    SmokeIgniteSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    SmokeLoopSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    SmokeSoundDuration=33.0
    SoundVolume=255
    SoundRadius=200.0
}
