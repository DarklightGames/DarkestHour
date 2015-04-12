//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHGrenadeProjectile_Smoke extends DHGrenadeProjectile
    abstract;

var  class<Emitter> SmokeEmitterClass;
var  sound          SmokeIgniteSound;
var  sound          SmokeLoopSound;
var  float          SmokeSoundDuration;

// Modified to remove 'Fear' stuff, as not an exploding grenade
simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

// Modified to add smoke effects & to remove actor destruction on client
// Matt: actor is torn off & then destroyed on server, but persists for its LifeSpan on clients so grenade is still visible on ground & makes the smoke sound
simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Emitter SmokeEmitter;

    BlowUp(HitLocation);

    bTearOff = true; // stops any further replication, but client copies of actor persist so we still see the grenade on the ground

    if (Level.NetMode != NM_DedicatedServer)
    {
        SmokeEmitter = Spawn(SmokeEmitterClass, self,, Location, rotator(vect(0.0, 0.0, 1.0)));
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

// Function emptied out to remove everything relating to explosion, as not an exploding grenade
simulated function Destroyed()
{
}

defaultproperties
{
    bAlwaysRelevant=true // has to be always relevant so that the smoke effect always gets spawned
    Damage=0.0
    DamageRadius=0.0
    SmokeEmitterClass=class'DH_Effects.DH_SmokeGrenadeEffect'
    SmokeIgniteSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    SmokeLoopSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    SmokeSoundDuration=33.0
    SoundVolume=255
    SoundRadius=200.0
}
