//==============================================================================
// ROTankSmokeShell
//
// Original content Copyright © 2005 - 2008 Tripwire Interactive, LLC
// All other content Copyright © 2006 - 2008 William "Teufelhund" Miller
//
// Base class for RO tank cannon smoke shells.
//==============================================================================
class DH_ROTankCannonShellSmoke extends DH_ROTankCannonShellHE;


//==============================================================================
// Variables
//==============================================================================
var()  float            DestroyTimer;
var    bool             bCalledDestroy;
var    Emitter          SmokeEmitter;

var()  class<Emitter>  	SmokeEffectClass;

//==============================================================================
// Functions
//==============================================================================
simulated function NonPenetrateExplode(vector HitLocation, vector HitNormal)
{
    super.NonPenetrateExplode(HitLocation, HitNormal);

	if (Level.NetMode != NM_DedicatedServer)
	{
        SmokeEmitter = Spawn(SmokeEffectClass, self, , HitLocation, rotator(-HitNormal));
        SmokeEmitter.SetBase(Self);
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    super.Explode(HitLocation, HitNormal);

	if (Level.NetMode != NM_DedicatedServer)
	{
        SmokeEmitter = Spawn(SmokeEffectClass, self, , HitLocation, rotator(-HitNormal));
        SmokeEmitter.SetBase(Self);
	}
}

simulated function KillSmoke()
{
    if( SmokeEmitter != none )
    {
    	SmokeEmitter.Kill();
    }
}

//is this function needed?
function Reset()
{
    if( SmokeEmitter != none )
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

//==============================================================================
// Default Properties
//==============================================================================

defaultproperties
{
     DestroyTimer=20.000000
     SmokeEffectClass=Class'DH_Effects.DH_SmokeShellEffect'
     bMechanicalAiming=True
     bOpticalAiming=True
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
