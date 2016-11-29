//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMortarProjectileSmoke extends DHMortarProjectile
    abstract;

var     class<Emitter>  SmokeEmitterClass;  // class to spawn for smoke emitter
var     sound           SmokeIgniteSound;   // initial sound when smoke begins emitting
var     sound           SmokeLoopSound;     // ambient looping sound as smoke continues to emit
var     float           SmokeSoundDuration; // duration until smoke sound stops playing as smoke clears, used to make projectile persist to keep playing SmokeLoopSound

// Modified to delay destroying this actor until the end of the SmokeSoundDuration, unless shell was a dud
// Not relevant on server as doesn't need to broadcast smoke sound  (mortar shells are bAlwaysRelevant so all clients have actor & smoke sounds get played locally)
simulated function HandleDestruction()
{
    if (Level.NetMode != NM_DedicatedServer && !bDud)
    {
        LifeSpan = SmokeSoundDuration; // actor will destroy itself automatically after this time
    }
    else
    {
        Destroy();
    }
}

// Implemented to spawn a smoke emitter & play smoke sound
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
    super.SpawnExplosionEffects(HitLocation, HitNormal);

    // Spawn smoke emitter & play smoke sounds, if shell isn't a dud (not relevant on server)
    // Then set LifeSpan for this actor so it persists as long as the smoke sound, so players keep hearing it until the smoke fades away
    if (Level.NetMode != NM_DedicatedServer && !bDud)
    {
        Spawn(SmokeEmitterClass, self,, HitLocation, rotator(vect(0.0, 0.0, 1.0)));
        PlaySound(SmokeIgniteSound, SLOT_NONE, 1.5,, 200.0);
        AmbientSound = SmokeLoopSound;

        SetPhysics(PHYS_None);
        LifeSpan = SmokeSoundDuration;
    }
    // Or destroy actor now if shell is a dud or if on a server
    // Mortar shells are bAlwaysRelevant so all clients have this actor & smoke sounds are played locally
    else
    {
        Destroy();
    }
}

defaultproperties
{
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_Grenade'
    SmokeIgniteSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    SmokeLoopSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    SmokeSoundDuration=33.0
    SoundVolume=255
    SoundRadius=200.0
}
