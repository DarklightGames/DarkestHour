//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarProjectileSmoke extends DHMortarProjectile
    abstract;

var     class<Emitter>  SmokeEmitterClass;  // class to spawn for smoke emitter
var     sound           SmokeIgniteSound;   // initial sound when smoke begins emitting
var     sound           SmokeLoopSound;     // ambient looping sound as smoke continues to emit
var     float           SmokeSoundDuration; // duration until smoke sound stops playing as smoke clears, used to make projectile persist to keep playing SmokeLoopSound

// Modified to delay destroying projectile until the end of the SmokeSoundDuration (unless shell was a dud)
// Means actor persists as long as the smoke sound, so players keep hearing it until the smoke fades away
// Not relevant on server & client actors will already have been torn off & are independent from server as mortar shells are bNetTemporary projectiles
simulated function HandleDestruction()
{
    if (Level.NetMode != NM_DedicatedServer && !bDud)
    {
        LifeSpan = SmokeSoundDuration; // actor will destroy itself automatically after this time
        SetPhysics(PHYS_None);
    }
    else
    {
        Destroy();
    }
}

// Implemented to spawn a smoke emitter & play smoke sound (if shell isn't a dud)
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
    super.SpawnExplosionEffects(HitLocation, HitNormal);

    if (Level.NetMode != NM_DedicatedServer && !bDud)
    {
        Spawn(SmokeEmitterClass, self,, HitLocation, rotator(vect(0.0, 0.0, 1.0)));
        PlaySound(SmokeIgniteSound, SLOT_NONE, 1.5,, 200.0);
        AmbientSound = SmokeLoopSound;
    }
}

defaultproperties
{
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_Grenade'
    SmokeIgniteSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    SmokeLoopSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    SmokeSoundDuration=33.0
    SoundVolume=255
    SoundRadius=200.0
    HitMapMarkerClass=class'DH_Engine.DHMapMarker_ArtilleryHit_Smoke'
}
