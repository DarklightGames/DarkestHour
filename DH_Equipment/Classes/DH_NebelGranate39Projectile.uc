//=============================================================================
// NebelGranate39Projectile
//=============================================================================
// Grenade projectile for the German NebelHandGranate 39 smoke grenade
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2006 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

//=============================================================================

class DH_NebelGranate39Projectile extends DH_StielGranateProjectile;

var float DestroyTimer;
var bool bCalledDestroy;
var Emitter SmokeEmitter;
var sound SmokeSound;

//-----------------------------------------------------------------------------
// Landed
//-----------------------------------------------------------------------------

simulated function Landed(vector HitNormal)
{
	if (Bounces <= 0)
	{
		SetPhysics(PHYS_none);
		SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)),QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));
	}
	else
	{
		HitWall(HitNormal, none);
	}
}

//-----------------------------------------------------------------------------
// BlowUp
//-----------------------------------------------------------------------------

function BlowUp(vector HitLocation)
{
	//DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

	if (Role == ROLE_Authority)
		MakeNoise(1.0);
}

//-----------------------------------------------------------------------------
// Explode
//-----------------------------------------------------------------------------

simulated function Explode(vector HitLocation, vector HitNormal)
{
	BlowUp(HitLocation);

	if (Role == ROLE_Authority)
	{
		AmbientSound = SmokeSound;
	}

	PlaySound(ExplosionSound[Rand(3)],, 1.0,,200);

    //DoShakeEffect();

	if (Level.NetMode != NM_DedicatedServer)
	{
	    SmokeEmitter = Spawn(ExplodeDirtEffectClass,self,, Location, rotator(vect(0,0,1)));
	    SmokeEmitter.SetBase(Self);
	}
}

simulated function Destroyed()
{
    super(ROThrowableExplosiveProjectile).Destroyed();

    if (SmokeEmitter != none)
    {
    	SmokeEmitter.Kill();
    }
}

function Reset()
{
    if (SmokeEmitter != none)
    {
    	SmokeEmitter.Destroy();
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
		Destroy();
	}
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     DestroyTimer=30.000000
     SmokeSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
     ExplodeDirtEffectClass=Class'ROEffects.GrenadeSmokeEffect'
     ExplosionSound(0)=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
     ExplosionSound(1)=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
     ExplosionSound(2)=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
     Damage=0.000000
     DamageRadius=0.000000
     MyDamageType=Class'DH_Equipment.DH_NebelGranate39DamType'
     StaticMesh=StaticMesh'WeaponPickupSM.Projectile.gersmokenade_throw'
     bAlwaysRelevant=true
     LifeSpan=30.000000
     SoundVolume=255
     SoundRadius=200.000000
}
