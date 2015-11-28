//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarProjectileSmoke extends DHMortarProjectile
    abstract;

var  class<Emitter> SmokeEmitterClass;
var  sound          SmokeIgniteSound;
var  sound          SmokeLoopSound;
var  float          SmokeSoundDuration;

// Matt: actor is torn off & then destroyed on server, but persists for its LifeSpan on clients to play the smoke sound
simulated function Explode(vector HitLocation, vector HitNormal)
{
    super.Explode(HitLocation, HitNormal);

    bTearOff = true; // stops any further replication, but client copies of actor persist to play the smoke sound

    if (Level.NetMode != NM_DedicatedServer)
    {
        DoHitEffects(HitLocation, HitNormal);

        if (!bDud)
        {
            Spawn(SmokeEmitterClass, self,, HitLocation, rotator(vect(0.0, 0.0, 1.0)));
            PlaySound(SmokeIgniteSound, SLOT_NONE, 1.5,, 200.0);
            // Matt (March 2015): had to omit playing the smoke loop sound, as it's really weird but while you are on the mortar, the AmbientSound is heard at full volume, even if it distant.
            // Then if you come off the mortar, the smoke sound is attenuated as it should be. Not a problem with smoke grenades or shells; it's mortar specific and makes no sense to me !
            // Not an issue with network play or tearing off the actor, as it's the same problem in single player
//          AmbientSound = SmokeLoopSound;
            LifeSpan = SmokeSoundDuration; // this actor will persist as long as the smoke sound
        }
        else
        {
            Destroy();
        }
    }
    else
    {
        LifeSpan = 1.0; // on a server this actor will be automatically destroyed in 1 second, allowing time for bTearOff to replicate to clients
    }

    SetPhysics(PHYS_None);
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
