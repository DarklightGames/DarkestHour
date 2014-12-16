//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShellSmoke extends DH_ROTankCannonShellHE;

var()  float            DestroyTimer;
var    bool             bCalledDestroy;
var    Emitter          SmokeEmitter;
var()  class<Emitter>   SmokeEffectClass;

simulated function NonPenetrateExplode(vector HitLocation, vector HitNormal)
{
    super.NonPenetrateExplode(HitLocation, HitNormal);

    if (Level.NetMode != NM_DedicatedServer)
    {
        SmokeEmitter = Spawn(SmokeEffectClass, self,, HitLocation, rotator(-HitNormal));
        SmokeEmitter.SetBase(Self);
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    super.Explode(HitLocation, HitNormal);

    if (Level.NetMode != NM_DedicatedServer)
    {
        SmokeEmitter = Spawn(SmokeEffectClass, self,, HitLocation, rotator(-HitNormal));
        SmokeEmitter.SetBase(Self);
    }
}

simulated function KillSmoke()
{
    if (SmokeEmitter != none)
    {
        SmokeEmitter.Kill();
    }
}

//is this function needed?
function Reset()
{
    if (SmokeEmitter != none)
    {
        SmokeEmitter.Destroyed();
    }

    super.Reset();
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    DestroyTimer -= DeltaTime;

    if (DestroyTimer <= 0.0 && !bCalledDestroy)
    {
        bCalledDestroy = true;
        KillSmoke();
    }
}

defaultproperties
{
    RoundType=RT_Smoke
    DestroyTimer=20.000000
    SmokeEffectClass=class'DH_Effects.DH_SmokeShellEffect'
    bMechanicalAiming=true
    bOpticalAiming=true
    ImpactDamage=20
    BallisticCoefficient=0.600000
    SpeedFudgeScale=0.750000
    MaxSpeed=500.000000
    Damage=75.000000
    DamageRadius=50.000000
    AmbientSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    LifeSpan=12.000000
    AmbientGlow=50
    SoundVolume=175
    SoundRadius=500.000000
    TransientSoundVolume=0.750000
    TransientSoundRadius=750.000000
}
