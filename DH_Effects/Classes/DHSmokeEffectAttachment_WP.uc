//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Actor that spawns a smoke emitter, plays the smoke sounds, and destroys
// itself when the sound is over.
//==============================================================================

class DHSmokeEffectAttachment_WP extends DHSmokeEffectAttachment
    notplaceable;

var     Emitter         SmokeEmitter;
var     class<Emitter>  SmokeEmitterClass;
var     Sound           SmokeIgniteSound;
var     Sound           SmokeLoopSound;
var     float           SmokeSoundDuration;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        SetTimer(SmokeSoundDuration, false);
        
        AmbientSound = SmokeLoopSound;

        PlaySound(SmokeIgniteSound, SLOT_NONE, 1.5,, 200.0);
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        SmokeEmitter = Spawn(SmokeEmitterClass,,,Location);
        SmokeEmitter.SetBase(self);
    }
}

simulated function Timer()
{
    // The sound is over, so there's no point in keeping this actor around.
    Destroy();
}

defaultproperties
{
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_Phosphorus'
    SmokeIgniteSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    SmokeLoopSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    SmokeSoundDuration=33.0
    RemoteRole=ROLE_DumbProxy
    bHidden=true
}
