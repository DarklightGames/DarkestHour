//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MortarProjectileSmoke extends DH_MortarProjectile
    abstract;

//Sounds
var sound SmokeLoopSound;
var sound SmokeIgniteSound;

var float SmokeSoundDuration;

//Emitter class
var class<Emitter> SmokeEmitterClass;
var Emitter SmokeEmitter;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    super.Explode(HitLocation, HitNormal);

    if (Level.NetMode != NM_DedicatedServer)
    {
        DoHitEffects(HitLocation, HitNormal);

        if (!bDud)
        {
            Spawn(SmokeEmitterClass, self,, HitLocation, rotator(vect(0.0, 0.0, 1.0)));
            PlaySound(SmokeIgniteSound, SLOT_None, 4.0,, 200.0);
            SetPhysics(PHYS_None);
        }
    }

    Destroy();
}

defaultproperties
{
    SmokeLoopSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    SmokeIgniteSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    SmokeSoundDuration=30.000000
    SmokeEmitterClass=class'ROEffects.GrenadeSmokeEffect'
    SoundVolume=255
    SoundRadius=200.0
}
