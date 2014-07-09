//=============================================================================
// DH_USSmokeGrenadeProjectile
//=============================================================================

class DH_USSmokeGrenadeProjectile extends StielGranateProjectile;

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
		SetPhysics(PHYS_None);

		if(Role == ROLE_Authority)
			SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)),QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));
	}
	else
	{
		HitWall(HitNormal, None);
	}
}

//-----------------------------------------------------------------------------
// HitWall
//-----------------------------------------------------------------------------

simulated function HitWall(vector HitNormal, actor Wall)
{
	local vector VNorm;
    local ESurfaceTypes ST;

	GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST);

	// Return here, this was causing the famous "Nade bug"
	if(ROCollisionAttachment(Wall) != none)
	{
		return;
	}

	// Reflect off Wall w/damping
	//VNorm = (Velocity dot HitNormal) * HitNormal;
	//Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
	//Velocity = -HitNormal * Velocity * 0.3;
	Bounces--;

	if (Bounces <= 0)
	{
		bBounce = false;
		//SetPhysics(PHYS_None);
	}
	else
	{
	    // Reflect off Wall w/damping
    	VNorm = (Velocity dot HitNormal) * HitNormal;
    	Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
		//Velocity = 0.3 * (Velocity - 2.0 * HitNormal * (Velocity dot HitNormal));
		//RandSpin(100000);
		Speed = VSize(Velocity);
	}

	if ((Level.NetMode != NM_DedicatedServer) && (Speed > 150) && ImpactSound != none )
	{
		PlaySound(ImpactSound, SLOT_Misc, 1.1); // Increase volume of impact
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

	if( Role == ROLE_Authority )
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

    if( SmokeEmitter != none )
    {
    	SmokeEmitter.Kill();
    }
}

function Reset()
{
    if( SmokeEmitter != none )
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
     MyDamageType=Class'DH_Equipment.DH_USSmokeGrenadeDamType'
     StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.US_SmokeGrenade_throw'
     bAlwaysRelevant=True
     LifeSpan=30.000000
     SoundVolume=255
     SoundRadius=200.000000
}
