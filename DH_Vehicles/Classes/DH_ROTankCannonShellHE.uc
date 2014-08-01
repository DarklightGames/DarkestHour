//==============================================================================
// DH_ROTankCannonShellHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for all Darkest Hour High Explosive tank projectiles
//==============================================================================
class DH_ROTankCannonShellHE extends DH_ROTankCannonShell;

var		sound		ExplosionSound[4];          // sound of the round exploding
var		bool		bPenetrated;		        // This shell penetrated what it hit

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
	local ROVehicle HitVehicle;
	local ROVehicleWeapon HitVehicleWeapon;
	local bool bHitVehicleDriver;
    local float    TouchAngle; //dummy variable

	HitVehicleWeapon = ROVehicleWeapon(Other);
	HitVehicle = ROVehicle(Other.Base);

	TouchAngle=1.57;

    if (Other == none || (SavedTouchActor != none && SavedTouchActor == Other) || Other.bDeleteMe ||
		ROBulletWhipAttachment(Other) != none)
    {
    	return;
    }

    SavedTouchActor = Other;

	if ((Other != instigator) && (Other.Base != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget))
	{

	    if (HitVehicleWeapon != none && HitVehicle != none)
	    {
		    SavedHitActor = Pawn(Other.Base);

            if (HitVehicleWeapon.HitDriverArea(HitLocation, Velocity))
			{
				if (HitVehicleWeapon.HitDriver(HitLocation, Velocity))
				{
					bHitVehicleDriver = true;
				}
				else
				{
					return;
				}
			}

            if (bDebuggingText && Role == ROLE_Authority)
            {
                if (!bIsAlliedShell)
                {
                    Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$" m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s"); //, flight time = "$FlightTime$"s");
                }
                else
                {
                    Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$" yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps"); //, flight time = "$FlightTime$"s");
                }
            }

            if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateAPC(HitLocation, Normal(Velocity), GetPenetration(LaunchLocation-HitLocation), TouchAngle, ShellDiameter, ShellImpactDamage, bShatterProne))
		    {
				NonPenetrateExplode(HitLocation + ExploWallOut * Normal(-Velocity), Normal(-Velocity));

				// Don't update the position any more and don't move the projectile any more.
				bUpdateSimulatedPosition=false;
				SetPhysics(PHYS_none);
				SetDrawType(DT_none);

				HurtWall = none;
				if (Role == ROLE_Authority)
				{
					MakeNoise(1.0);
				}
		        return;
		    }

            // Don't update the position any more and don't move the projectile any more.
			bUpdateSimulatedPosition=false;
			SetPhysics(PHYS_none);
			SetDrawType(DT_none);

			if (Role == ROLE_Authority)
			{
				if (!Other.Base.bStatic && !Other.Base.bWorldGeometry)
				{
					if (Instigator == none || Instigator.Controller == none)
					{
						Other.Base.SetDelayedDamageInstigatorController(InstigatorController);
						if (bHitVehicleDriver)
						{
						    Other.SetDelayedDamageInstigatorController(InstigatorController);
						}
					}

					if (savedhitactor != none)
					{
						Other.Base.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
					}

					if (bHitVehicleDriver)
					{
						Other.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
					}

					if (DamageRadius > 0 && Vehicle(Other.Base) != none && Vehicle(Other.Base).Health > 0)
					{
						Vehicle(Other.Base).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, HitLocation);
					}
					HurtWall = Other.Base;
				}
				MakeNoise(1.0);
			}
			Explode(HitLocation + ExploWallOut * Normal(-Velocity), Normal(-Velocity));
			HurtWall = none;

            return;
	    }
	    else
	    {
			if ((Pawn(Other) != none || RODestroyableStaticMesh(Other) != none) && Role==Role_Authority)
			{
		        	Other.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
			}
	        Explode(HitLocation,vect(0,0,1));
	    }
	}
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{

    local PlayerController PC;
	local float  HitAngle; //just a dummy

    if (Wall.Base != none && Wall.Base == instigator)
     	return;

    HitAngle=1.57;

    if (bDebuggingText && Role == ROLE_Authority)
    {
        if (!bIsAlliedShell)
        {
            Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$" m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s"); //, flight time = "$FlightTime$"s");
        }
        else
        {
            Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$" yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps"); //, flight time = "$FlightTime$"s");
        }
    }

    if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateAPC(Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellDiameter, ShellImpactDamage, bShatterProne))
    {
		if (Role == ROLE_Authority)
		{
			MakeNoise(1.0);
		}
		NonPenetrateExplode(Location + ExploWallOut * HitNormal, HitNormal);

		// Don't update the position any more and don't move the projectile any more.
		bUpdateSimulatedPosition=false;
		SetPhysics(PHYS_none);
		SetDrawType(DT_none);

		if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer) )
		{
			if (ExplosionDecal.Default.CullDistance != 0)
			{
				PC = Level.GetLocalPlayerController();
				if (!PC.BeyondViewDistance(Location, ExplosionDecal.Default.CullDistance))
					Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
				else if ((Instigator != none) && (PC == Instigator.Controller) && !PC.BeyondViewDistance(Location, 2*ExplosionDecal.Default.CullDistance))
					Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
			}
			else
				Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
		}
		HurtWall = none;
        return;
    }

    if ((SavedHitActor == Wall) || (Wall.bDeleteMe))
     	return;

    // Don't update the position any more and don't move the projectile any more.
	bUpdateSimulatedPosition=false;
	SetPhysics(PHYS_none);
	SetDrawType(DT_none);

    SavedHitActor = Pawn(Wall);


	if (Role == ROLE_Authority)
	{
		if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
		{
			if (Instigator == none || Instigator.Controller == none)
				Wall.SetDelayedDamageInstigatorController(InstigatorController);

			if (savedhitactor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
			{
				Wall.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
			}

			if (DamageRadius > 0 && Vehicle(Wall) != none && Vehicle(Wall).Health > 0)
				Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
			HurtWall = Wall;
		}
		MakeNoise(1.0);
	}
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
	// We do this in the Explode logic
	if (!bCollided && (ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer) )
	{
		if (ExplosionDecal.Default.CullDistance != 0)
		{
			PC = Level.GetLocalPlayerController();
			if (!PC.BeyondViewDistance(Location, ExplosionDecal.Default.CullDistance))
				Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
			else if ((Instigator != none) && (PC == Instigator.Controller) && !PC.BeyondViewDistance(Location, 2*ExplosionDecal.Default.CullDistance))
				Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
		}
		else
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	}
	HurtWall = none;
	//log(" Shell flew "$(VSize(LaunchLocation - Location)/60.352)$" meters total");
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector TraceHitLocation, TraceHitNormal;
	local Material HitMaterial;
	local ESurfaceTypes ST;
	local bool bShowDecal, bSnowDecal;

	bPenetrated = true;

    if (SavedHitActor == none)
    {
       Trace(TraceHitLocation, TraceHitNormal, Location + vector(Rotation) * 16, Location, false,, HitMaterial);
    }

    DoShakeEffect();

	if (!bDidExplosionFX)
	{
	    if (HitMaterial == none)
			ST = EST_Default;
		else
			ST = ESurfaceTypes(HitMaterial.SurfaceType);

	    if (SavedHitActor != none)
	    {
	         PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);
	        if (EffectIsRelevant(Location,false))
	        {
	        	Spawn(ShellHitVehicleEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
	    		if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
	    			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	        }
	    }
	    else
	    {
	    	PlaySound(DirtHitSound,,5.5*TransientSoundVolume);
	        if (EffectIsRelevant(Location,false))
	        {
				Switch(ST)
				{
					case EST_Snow:
					case EST_Ice:
						Spawn(ShellHitSnowEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
						bShowDecal = true;
						bSnowDecal = true;
						break;
					case EST_Rock:
					case EST_Gravel:
					case EST_Concrete:
						Spawn(ShellHitRockEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
						bShowDecal = true;
						break;
					case EST_Wood:
					case EST_HollowWood:
						Spawn(ShellHitWoodEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
						bShowDecal = true;
						break;
					case EST_Water:
						Spawn(ShellHitWaterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
						PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
						bShowDecal = false;
						break;
					default:
						Spawn(ShellHitDirtEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
						bShowDecal = true;
						break;
				}

	    		if (bShowDecal && Level.NetMode != NM_DedicatedServer)
	    		{
	    			if (bSnowDecal && ExplosionDecalSnow != none)
					{
	    				Spawn(ExplosionDecalSnow,self,,Location, rotator(-HitNormal));
	    			}
	    			else if (ExplosionDecal != none)
					{
	    				Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	    			}
	    		}
	        }
	    }
	    PlaySound(ExplosionSound[Rand(4)],,5.5*TransientSoundVolume);

	}

	if (Corona != none)
		Corona.Destroy();

    super(ROAntiVehicleProjectile).Explode(HitLocation, HitNormal);
}

// HE Shell explosion for when it hit a tank but didn't penetrate
simulated function NonPenetrateExplode(vector HitLocation, vector HitNormal)
{
	if (bCollided)
		return;

	DoShakeEffect();

	if (!bDidExplosionFX)
	{
 	    PlaySound(VehicleDeflectSound,,5.5*TransientSoundVolume);
	    if (EffectIsRelevant(Location,false))
	    {
	    	Spawn(ShellDeflectEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
	    }

	    PlaySound(ExplosionSound[Rand(4)],,5.5*TransientSoundVolume);

	    bDidExplosionFX=true;
    }

	if (Corona != none)
		Corona.Destroy();

	// Save the hit info for when the shell is destroyed
	SavedHitLocation = HitLocation;
	SavedHitNormal = HitNormal;
	AmbientSound=none;

	BlowUp(HitLocation);

	// Give the bullet a little time to play the hit effect client side before destroying the bullet
	if (Level.NetMode == NM_DedicatedServer)
	{
		bCollided = true;
		SetCollision(false,false);
	}
	else
	{
		Destroy();
	}
}

simulated function Destroyed()
{
	local vector TraceHitLocation, TraceHitNormal;
	local Material HitMaterial;
	local ESurfaceTypes ST;
	local bool bShowDecal, bSnowDecal;
	local ROPawn Victims;
	local float damageScale, dist;
	local vector dir, Start;

	// Move karma ragdolls around when this explodes
	if (Level.NetMode != NM_DedicatedServer)
	{
		Start = Location + 32 * vect(0,0,1);

		foreach VisibleCollidingActors(class 'ROPawn', Victims, DamageRadius, Start)
		{
			// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
			if (Victims != self)
			{
				dir = Victims.Location - Start;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);

				if (Victims.Physics == PHYS_KarmaRagDoll)
				{
					Victims.DeadExplosionKarma(MyDamageType, damageScale * MomentumTransfer * dir, damageScale);
				}
			}
		}
	}

	if (!bDidExplosionFX)
	{
		if (bPenetrated)
		{
			if (bDebugBallistics && DH_ROTankCannonPawn(Instigator) != none && ROTankCannon(DH_ROTankCannonPawn(Instigator).Gun) != none)
			{
				ROTankCannon(DH_ROTankCannonPawn(Instigator).Gun).HandleShellDebug(SavedHitLocation);
			}

		    if (SavedHitActor == none)
		    {
		       Trace(TraceHitLocation, TraceHitNormal, Location + vector(Rotation) * 16, Location, false,, HitMaterial);
		    }

		    if (HitMaterial == none)
				ST = EST_Default;
			else
				ST = ESurfaceTypes(HitMaterial.SurfaceType);

		    if (SavedHitActor != none)
		    {
                PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);

		        if (EffectIsRelevant(SavedHitLocation,false))
		        {
		        	Spawn(ShellHitVehicleEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
		    		if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
		    			Spawn(ExplosionDecal,self,,SavedHitLocation, rotator(-SavedHitNormal));
		        }
		    }
		    else
		    {
		    	PlaySound(DirtHitSound,,5.5*TransientSoundVolume);
		        if (EffectIsRelevant(SavedHitLocation,false))
		        {
					Switch(ST)
					{
						case EST_Snow:
						case EST_Ice:
							Spawn(ShellHitSnowEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							bShowDecal = true;
							bSnowDecal = true;
							break;
						case EST_Rock:
						case EST_Gravel:
						case EST_Concrete:
							Spawn(ShellHitRockEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							bShowDecal = true;
							break;
						case EST_Wood:
						case EST_HollowWood:
							Spawn(ShellHitWoodEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							bShowDecal = true;
							break;
						case EST_Water:
							Spawn(ShellHitWaterEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
							bShowDecal = false;
							break;
						default:
							Spawn(ShellHitDirtEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							bShowDecal = true;
							break;
					}

		    		if (bShowDecal && Level.NetMode != NM_DedicatedServer)
		    		{
		    			if (bSnowDecal && ExplosionDecalSnow != none)
						{
		    				Spawn(ExplosionDecalSnow,self,,SavedHitLocation, rotator(-SavedHitNormal));
		    			}
		    			else if (ExplosionDecal != none)
						{
		    				Spawn(ExplosionDecal,self,,SavedHitLocation, rotator(-SavedHitNormal));
		    			}
		    		}
		        }
		    }
		    PlaySound(ExplosionSound[Rand(4)],,5.5*TransientSoundVolume);
	    }
	    else
	    {
		    PlaySound(VehicleDeflectSound,,5.5*TransientSoundVolume);
		    if (EffectIsRelevant(Location,false))
		    {
		    	Spawn(ShellDeflectEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
		    }

		    PlaySound(ExplosionSound[Rand(4)],,5.5*TransientSoundVolume);
	    }
    }

	if (Corona != none)
		Corona.Destroy();

	// Don't want to spawn the effect on the super
	super(ROAntiVehicleProjectile).Destroyed();
}



//-----------------------------------------------------------------------------
// PhysicsVolumeChange - Blow up HE rounds when they hit water
//-----------------------------------------------------------------------------
simulated function PhysicsVolumeChange(PhysicsVolume Volume)
{
	if (Volume.bWaterVolume)
	{
		Explode(Location, vector(Rotation * -1));
	}
}

defaultproperties
{
     ExplosionSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
     ExplosionSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
     ExplosionSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
     ExplosionSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
     bHasTracer=false
     ShakeRotMag=(Y=0.000000)
     ShakeRotRate=(Z=2500.000000)
     BlurTime=6.000000
     BlurEffectScalar=2.200000
     PenetrationMag=300.000000
     VehicleDeflectSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
     ShellHitVehicleEffectClass=Class'ROEffects.TankHEHitPenetrate'
     ShellDeflectEffectClass=Class'ROEffects.TankHEHitDeflect'
     ShellHitDirtEffectClass=Class'DH_Effects.DH_TankMediumHEHitEffect'
     ShellHitSnowEffectClass=Class'DH_Effects.DH_TankMediumHEHitEffect'
     ShellHitWoodEffectClass=Class'DH_Effects.DH_TankMediumHEHitEffect'
     ShellHitRockEffectClass=Class'DH_Effects.DH_TankMediumHEHitEffect'
     ShellHitWaterEffectClass=Class'DH_Effects.DH_TankMediumHEHitEffect'
     DamageRadius=300.000000
     MyDamageType=Class'DH_Vehicles.DH_HECannonShellDamage'
     ExplosionDecal=Class'ROEffects.ArtilleryMarkDirt'
     ExplosionDecalSnow=Class'ROEffects.ArtilleryMarkSnow'
     LifeSpan=10.000000
     SoundRadius=1000.000000
}
