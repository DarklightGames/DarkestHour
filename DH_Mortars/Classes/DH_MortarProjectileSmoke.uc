class DH_MortarProjectileSmoke extends DH_MortarProjectile
abstract;

//Sounds
var sound SmokeLoopSound;
var sound SmokeIgniteSound;

var float SmokeSoundDuration;

//Emitter class
var class<Emitter> SmokeEmitterClass;
var Emitter SmokeEmitter;

function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
        MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    super.Explode(HitLocation, HitNormal);

    if (Level.NetMode != NM_DedicatedServer)
    {
        DoHitEffects(HitLocation, HitNormal);

        if (!bDud)
        {
            Spawn(SmokeEmitterClass, self, , HitLocation, rotator(vect(0, 0, 1)));
            PlaySound(SmokeIgniteSound, SLOT_none, 4.0, , 200);
            SetPhysics(PHYS_none);
        }
    }

    Destroy();
}

defaultproperties
{
     SmokeLoopSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
     SmokeIgniteSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
     SmokeSoundDuration=30.000000
     SmokeEmitterClass=Class'ROEffects.GrenadeSmokeEffect'
     SoundVolume=255
     SoundRadius=200.000000
}
