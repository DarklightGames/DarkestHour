//==============================================================================
// DH_ROTankCannonShellHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for all Darkest Hour HEAT tank projectiles
//==============================================================================
class DH_ROTankCannonShellHEAT extends DH_ROTankCannonShell;


var	sound				ExplosionSound[3];        // sound of this shell exploding

// Penetration
var bool bInHitWall;

var float MaxWall;		// Maximum wall penetration
var float WScale;		// Penetration depth scale factor to take into account; weapon scale
var float Hardness;		// wall hardness, calculated in CheckWall for surface type
var float PenetrationDamage;    // Damage done by rocket penetrating wall
var	float PenetrationDamageRadius;        // Damage radius for rocket penetrating wall
var float EnergyFactor;        // For calculating penetration of projectile
var float PeneExploWallOut;   // Distance out from the wall to spawn penetration explosion

var globalconfig float 	PenetrationScale;	// global Penetration depth scale factor
var globalconfig float 	DistortionScale;	// global Distortion scale factor
//var globalconfig bool 	bDebugMode;			// If true, give our detailed report in log.
//var globalconfig bool 	bDebugROBallistics;	// If true, set bDebugBallistics to true for getting the arrow pointers

var	bool bDidPenetrationExplosionFX; // Already did the penetration explosion effects

var			bool				bNoWorldPen;   // Rocket has hit something other than the world and should be destroyed without running world penetration check


simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector TraceHitLocation, TraceHitNormal;
	local Material HitMaterial;
	local ESurfaceTypes ST;
	local bool bShowDecal, bSnowDecal;

	if( !bDidExplosionFX )
	{
	    if ( SavedHitActor == none )
	    {
	       Trace(TraceHitLocation, TraceHitNormal, Location + Vector(Rotation) * 16, Location, false,, HitMaterial);
	    }

	    if (HitMaterial == None)
			ST = EST_Default;
		else
			ST = ESurfaceTypes(HitMaterial.SurfaceType);

	    if ( SavedHitActor != none )
	    {

	        PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);
	        PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
	        if ( EffectIsRelevant(Location,false) )
	        {
	        	Spawn(ShellHitVehicleEffectClass,,,HitLocation + HitNormal*16,rotator(HitLocation));
	    		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
	    			Spawn(ExplosionDecal,self,,Location, rotator(-HitLocation));
	        }
	    }
	    else
	    {
	        if ( EffectIsRelevant(Location,false) )
	        {
				if( !PhysicsVolume.bWaterVolume )
				{
					Switch(ST)
					{
						case EST_Snow:
						case EST_Ice:
							Spawn(ShellHitSnowEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							bSnowDecal = true;
							break;
						case EST_Rock:
						case EST_Gravel:
						case EST_Concrete:
							Spawn(ShellHitRockEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
						case EST_Wood:
						case EST_HollowWood:
							Spawn(ShellHitWoodEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
						case EST_Water:
							Spawn(ShellHitWaterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
							bShowDecal = false;
							break;
						default:
							Spawn(ShellHitDirtEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
					}

		    		if ( bShowDecal && Level.NetMode != NM_DedicatedServer )
		    		{
		    			if( bSnowDecal && ExplosionDecalSnow != None)
						{
		    				Spawn(ExplosionDecalSnow,self,,HitLocation, rotator(-HitNormal));
		    			}
		    			else if( ExplosionDecal != None)
						{
		    				Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
		    			}
		    		}
				}
	        }
	    }
	}

    if( bCollided )
		return;

   	BlowUp(HitLocation);

	// Save the hit info for when the shell is destroyed
	SavedHitLocation = HitLocation;
	SavedHitNormal = HitNormal;
	AmbientSound=none;

    if ( Corona != None )
    Corona.Destroy();

    bDidExplosionFX = true;

    if( bNoWorldPen )
    {
        if (Level.NetMode == NM_DedicatedServer)
	    {
		    bCollided = true;
		    SetCollision(False,False);
	    }
	    else
	    {
		    bCollided = true;
		    Destroy();
      	}
    }
}

simulated function PenetrationExplode(vector HitLocation, vector HitNormal)
{
	local vector TraceHitLocation, TraceHitNormal;
	local Material HitMaterial;
	local ESurfaceTypes ST;
	local bool bShowDecal, bSnowDecal;
	local vector ActualHitLocation; // Point of impact before adjustment for explosion centre

	ActualHitLocation = HitLocation - PeneExploWallOut * HitNormal;

	if( !bDidPenetrationExplosionFX )
	{
	    if ( SavedHitActor == none )
	    {
	       Trace(TraceHitLocation, TraceHitNormal, Location + Vector(Rotation) * 16, Location, false,, HitMaterial);
	    }

	    if (HitMaterial == None)
			ST = EST_Default;
		else
			ST = ESurfaceTypes(HitMaterial.SurfaceType);

	    /*if ( SavedHitActor != none )
	    {

	        PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);
	        PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
	        if ( EffectIsRelevant(Location,false) )
	        {
	        	Spawn(ShellHitVehicleEffectClass,,,HitLocation + HitLocation*16,rotator(HitLocation));
	    		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
	    			Spawn(ExplosionDecal,self,,Location, rotator(-HitLocation));
	        }
	    }
	    else
	    {*/
	        if ( EffectIsRelevant(Location,false) )
	        {
				if( !PhysicsVolume.bWaterVolume )
				{
					Switch(ST)
					{
						case EST_Snow:
						case EST_Ice:
							Spawn(ShellHitSnowEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							bSnowDecal = true;
							break;
						case EST_Rock:
						case EST_Gravel:
						case EST_Concrete:
							Spawn(ShellHitRockEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
						case EST_Wood:
						case EST_HollowWood:
							Spawn(ShellHitWoodEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
						case EST_Water:
							Spawn(ShellHitWaterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
							bShowDecal = false;
							break;
						default:
							Spawn(ShellHitDirtEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
					}

		    		if ( bShowDecal && Level.NetMode != NM_DedicatedServer )
		    		{
		    			if( bSnowDecal && ExplosionDecalSnow != None)
						{
		    				Spawn(ExplosionDecalSnow,self,,ActualHitLocation, rotator(-HitNormal));
		    			}
		    			else if( ExplosionDecal != None)
						{
		    				Spawn(ExplosionDecal,self,,ActualHitLocation, rotator(-HitNormal));
		    			}
		    		}
				}
	        }
	    //}
	}

    if( bCollided )
		return;

    PenetrationBlowUp(HitLocation);

	// Save the hit info for when the shell is destroyed
	SavedHitLocation = HitLocation;
	SavedHitNormal = HitNormal;
	AmbientSound=none;

	if ( Corona != None )
	Corona.Destroy();

    bDidPenetrationExplosionFX = true;

   	if (Level.NetMode == NM_DedicatedServer)
   	{
   		bCollided = true;
       	SetCollision(False,False);
    }
    else
    {
       	bCollided = true;
       	Destroy();
    }
}

function PenetrationBlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

// HEAT rounds only deflect when they strike at angles, but for simplicity's sake, lets just detonate them with no damage instead
simulated function FailToPenetrate(vector HitLocation)
{
	local vector TraceHitLocation, HitNormal;

    Trace(TraceHitLocation, HitNormal, HitLocation + Normal(Velocity) * 50, HitLocation - Normal(Velocity) * 50, True);
	Explode(HitLocation + ExploWallOut * HitNormal, HitNormal);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local ROVehicle HitVehicle;
	local ROVehicleWeapon HitVehicleWeapon;
	local bool bHitVehicleDriver;

	local Vector        TempHitLocation, HitNormal;
	local array<int>	HitPoints;
    local float         TouchAngle; //dummy variable

	HitVehicleWeapon = ROVehicleWeapon(Other);
	HitVehicle = ROVehicle(Other.Base);

	TouchAngle=1.57;

    if( Other == none || (SavedTouchActor != none && SavedTouchActor == Other) || Other.bDeleteMe ||
		ROBulletWhipAttachment(Other) != none  )
    {
    	return;
    }

    SavedTouchActor = Other;

	if ( (Other != instigator) && (Other.Base != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
	{
	    if( HitVehicleWeapon != none && HitVehicle != none )
	    {
		   SavedHitActor = Pawn(Other.Base);

			if ( HitVehicleWeapon.HitDriverArea(HitLocation, Velocity) )
			{
				if( HitVehicleWeapon.HitDriver(HitLocation, Velocity) )
				{
					bHitVehicleDriver = true;
				}
				else
				{
				    return;
     			}
			}

            if(bDebuggingText && Role == ROLE_Authority)
            {
                if(!bIsAlliedShell)
                {
                    Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$" m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s");
                }
                else
                {
                    Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$" yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps");
                }
            }

            if( HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateHEAT( HitLocation, Normal(Velocity), GetPenetration(LaunchLocation-HitLocation), TouchAngle, ShellImpactDamage, bIsHEATRound))
		    {

                if(bDebuggingText && Role == ROLE_Authority)
                {
	  				Level.Game.Broadcast(self, "Turret Ricochet!");
                }

				if( Drawdebuglines && Firsthit )
				{
					FirstHit=false;
					DrawStayingDebugLine( Location, Location-(Normal(Velocity)*500), 0, 255, 0);
						// DrawStayingDebugLine( Location, Location + 1000*HitNormal, 0, 255, 255);
				}

				// Don't save hitting this actor since we deflected
       			SavedHitActor = none;
       			// Don't update the position any more
				bUpdateSimulatedPosition=false;

                //DeflectWithoutNormal(Other.Base, HitLocation);
			    FailToPenetrate(HitLocation); // No deflection for HEAT, just detonate without damage

			    if( Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none )
		        	ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
                return;
		    }

	        // Don't update the position any more and don't move the projectile any more.
        	bUpdateSimulatedPosition=false;
		    SetPhysics(PHYS_None);
		    SetDrawType(DT_None);

		    if ( Role == ROLE_Authority )
		    {
			    if ( !Other.Base.bStatic && !Other.Base.bWorldGeometry )
			    {
				    if ( Instigator == None || Instigator.Controller == None )
				    {
					    Other.Base.SetDelayedDamageInstigatorController( InstigatorController );
					    if( bHitVehicleDriver )
					    {
					        Other.SetDelayedDamageInstigatorController( InstigatorController );
	                    }
	                }

				    if( Drawdebuglines && Firsthit )
				    {
					    FirstHit=false;
					    DrawStayingDebugLine( Location, Location-(Normal(Velocity)*500), 255, 0, 0);
			        }

				    if ( savedhitactor != none )
				    {
					    Other.Base.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
			        }

				    if( bHitVehicleDriver )
				    {
					    Other.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
			        }

				    if( Other != none && !Other.bDeleteMe )
				    {
					    if (DamageRadius > 0 && Vehicle(Other.Base) != None && Vehicle(Other.Base).Health > 0)
						    Vehicle(Other.Base).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, HitLocation);
				        HurtWall = Other.Base;
		            }
			    }
			    MakeNoise(1.0);
		    }
			Explode(HitLocation + ExploWallOut * Normal(-Velocity), Normal(-Velocity));
			HurtWall = None;

            return;
	    }
	    else
	    {
			if ( (Pawn(Other) != none || RODestroyableStaticMesh(Other) != none) && Role==Role_Authority )
			{
		        if( ROPawn(Other) != none )
		        {

					if(!Other.bDeleteMe)
			        {
				        Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * Normal(Velocity)), HitPoints, HitLocation,, 0);

						if( Other == none )
							return;
						else
							ROPawn(Other).ProcessLocationalDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage,HitPoints);

					}
					else
					{
						return;
					}
				}
				else
				{
				 	Other.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
				}
			}
			else if(Role==Role_Authority )
			{
		        if( Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none )
					ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
			}
	        Explode(HitLocation,Vect(0,0,1));
	    }
	}
}

// Overridden to handle world and object penetration
simulated singular function HitWall(vector HitNormal, actor Wall)
{
	local float tmpWallDiff, tmpMaxWall;
	local vector TmpHitLocation, TmpHitNormal, X,Y,Z, LastLoc;
	local float xH; //,EnergyFactor;
	//local rotator distortion;
	local actor tmpHit;

	local vector SavedVelocity;
//	local PlayerController PC;

	local float HitAngle;

    // Check to prevent recursive calls and to make sure we actually hit something
	if (bInHitWall || ( Wall.Base != none && Wall.Base == instigator ))
		return;

	LastLoc = Location;
	HitAngle = 1.57;

    // Have we hit a world item we can penetrate?
    if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
	   bNoWorldPen = true;

    if(bDebuggingText && Role == ROLE_Authority)
    {
        if(!bIsAlliedShell)
        {
            Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$"m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s"); //, flight time = "$FlightTime$"s");
        }
        else
        {
            Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$"yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps"); //, flight time = "$FlightTime$"s");
        }
    }

	if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateHEAT( Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellImpactDamage, bIsHEATRound))
	{

        if(bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Hull Ricochet!");
        }

		if( Drawdebuglines && Firsthit )
		{
			FirstHit=false;
			DrawStayingDebugLine( Location, Location-(Normal(Velocity)*500), 0, 255, 0);
				// DrawStayingDebugLine( Location, Location + 1000*HitNormal, 255, 0, 255);
		}

		// Don't save hitting this actor since we deflected
		SavedHitActor = none;
		// Don't update the position any more
		bUpdateSimulatedPosition=false;

		//Deflect(HitNormal, Wall);
		Explode(Location + ExploWallOut * HitNormal, HitNormal);

		if( Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none )
			ROBot(Instigator.Controller).NotifyIneffectiveAttack(ROVehicle(Wall));

        return;
	}

    if ((SavedHitActor == Wall) || (Wall.bDeleteMe) )
     	return;

    // Don't update the position any more and don't move the projectile any more.
	bUpdateSimulatedPosition=false;
	SetPhysics(PHYS_None);
	SetDrawType(DT_None);

    SavedHitActor = Pawn(Wall);

	Super(ROBallisticProjectile).HitWall(HitNormal, Wall);

	if ( Role == ROLE_Authority )
	{
		if ( bNoWorldPen )  // Using this value as we've already done this check earlier on
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );

			if ( savedhitactor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
			{
				if( Drawdebuglines && Firsthit )
				{
					FirstHit=false;
					DrawStayingDebugLine( Location, Location-(Normal(SavedVelocity)*500), 255, 0, 0);
				}
				Wall.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);
			}

			if (DamageRadius > 0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0)
				Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
			HurtWall = Wall;
		}
		else
		{
			if( Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none )
	        	ROBot(Instigator.Controller).NotifyIneffectiveAttack();
		}
		MakeNoise(1.0);
	}
	Explode(Location + ExploWallOut * HitNormal, HitNormal);

	HurtWall = None;
	//log(" Shell flew "$(VSize(LaunchLocation - Location)/60.352)$" meters total");

	bInHitWall = True;

	//if(bDebugMode) log("HitWall - Starting Penetration Check");

	GetAxes(Rotation,X,Y,Z);

	// Do the Max Wall Calculations
	CheckWall(HitNormal,X);
	xH = 1/Hardness;
	//EnergyFactor = 1000;         // EnergyFactor = (0.001*Vsize(Velocity))**2;
	MaxWall = EnergyFactor * xH * PenetrationScale * WScale;

	//if(bDebugMode) log("INFO - Velocity:"@Vsize(Velocity)@Velocity@" N "@Normal(Velocity)@" NRG Factor"@EnergyFactor@" MaxWall:"@MaxWall);

	// due to MaxWall getting into very high ranges we need to make shorter trace checks till we reach the full MaxWall value
	if ( MaxWall > 16)
    {
		do
        {
			if ( (tmpMaxWall + 16) <= MaxWall )
				tmpMaxWall += 16;
			else
				tmpMaxWall = MaxWall;
			tmpHit = Trace(TmpHitLocation,TmpHitNormal,Location,Location + X * tmpMaxWall,False);

			//if(bDebugMode) log("in do-while - tmpMaxWall:"@tmpMaxWall@" tmpHit:"@tmpHit);

			// due to StaticMeshs resulting in a hit even with the trace starting right inside of them (terrain and BSP 'space' would return None)
			if ( (tmpHit != None) && !SetLocation(TmpHitLocation + (vect(0.5,0,0) * X)) )
				tmpHit = None;

		} until ( (tmpHit != None) || (tmpMaxWall >= MaxWall) );
	}
	else
    {
		tmpHit = Trace(TmpHitLocation,TmpHitNormal,Location,Location + X * MaxWall,False);
		//if(bDebugMode) log("MaxWall <= 16 - MaxWall:"@MaxWall@" tmpHit:"@tmpHit);
	}

	//if(bDebugMode) log("MaxWall:"@MaxWall@" tmpHit:"@tmpHit@" TmpHitLocation:"@TmpHitLocation@" TmpHitNormal:"@TmpHitNormal);

//	if (Trace(TmpHitLocation,TmpHitNormal,Location,Location + X * MaxWall,False) != None)
	if (tmpHit != None)
	{
		if (SetLocation(TmpHitLocation + (vect(0.5,0,0) * X)))
		{
		/*	if (Role == ROLE_Authority)
			{
				tmpWallDiff = VSize(LastLoc - Location) / 2.0;
				MaxWall -= tmpWallDiff;
				tmpWallDiff /= 100.0;

				// material dependant damage, velocity and direction changes
				if ( (tmpWallDiff * 2.0 * (1 + Hardness / 4)) < 1.0 )
					Damage *= 1.0 - tmpWallDiff * 2.0 * (1 + Hardness / 4);
				else
					Damage *= 0.01;

				if ( (tmpWallDiff * (1 + Hardness / 2)) < 1.0 )
					Velocity *= 1.0 - tmpWallDiff * (1 + Hardness / 2);
				else
					Velocity *= 0.01;

				// would result in about 20° max for a hardness of 5 and around 2° max for a hardness of .5
				if ( DistortionScale > 0.0 ) {
					distortion.Yaw = 3000 * Hardness / 2 * (FRand()-0.5);
            		distortion.Pitch = 3000 * Hardness / 2 * (FRand()-0.5);
            		distortion.Roll = 3000 * Hardness / 2 * (FRand()-0.5);
					Velocity = Velocity >> (distortion * DistortionScale);
				}

				if(bDebugMode) log("INFO - resulting Velocity:"@Vsize(Velocity)@Velocity@" N "@Normal(Velocity)@" resulting Damage"@Damage@" resulting MaxWall:"@MaxWall@" tmpWallDiff:"@tmpWallDiff@" Hardness:"@Hardness@" distortion"@distortion);
			}       */

			// spawn an impact effect on the backside of the wall too
/*			if( ROVehicle(tmpHit) != none)
			{
				if (Level.NetMode != NM_DedicatedServer)
				{
					VehEffect = Spawn(class'ROVehicleHitEffect',,, TmpHitLocation, rotator(-TmpHitNormal));
					VehEffect.InitHitEffects(TmpHitLocation,TmpHitNormal);
 				}
			}
			else if (ShellHitRockEffectClass != None && (Level.NetMode != NM_DedicatedServer))
			{
				Spawn(ShellHitRockEffectClass,,, TmpHitLocation, rotator(-TmpHitNormal));
			}*/
			PenetrationExplode(TmpHitLocation + PeneExploWallOut * TmpHitNormal, TmpHitNormal);

			bInHitWall = False;

			if ( MaxWall < 1.0 ) {
				//if(bDebugMode) log(">>>> Projectile - destroy:"@self);
 				if (Level.NetMode == NM_DedicatedServer) {
					bCollided = true;
					SetCollision(False,False);
 				}
 				else {
					Destroy();
 				}
			}
		}
		else
        {
			//if(bDebugMode) log(">>>> Projectile - destroy:"@self);
 			if (Level.NetMode == NM_DedicatedServer)
            {
				bCollided = true;
				SetCollision(False,False);
 			}
 			else
            {
				Destroy();
 			}
		}
	}
	else
    {
		//if(bDebugMode) log(">>>> Projectile - destroy:"@self);
 		if (Level.NetMode == NM_DedicatedServer)
        {
			bCollided = true;
			SetCollision(False,False);
 		}
 		else
        {
			Destroy();
 		}
    }
}

simulated function CheckWall(vector HitNormal, vector X)
{
	local Material HitMaterial;
	local ESurfaceTypes HitSurfaceType;
	local vector cTmpHitLocation, cTmpHitNormal;

	Trace(cTmpHitLocation, cTmpHitNormal, Location, Location + X*16, false,, HitMaterial);

	if (HitMaterial != None)
		HitSurfaceType = ESurfaceTypes(HitMaterial.SurfaceType);
	else
		HitSurfaceType = EST_Default;

	switch ( HitSurfaceType )
	{
		case EST_Default :
			Hardness = 0.7;
			break;
		case EST_Rock :
//			Hardness = 2.0;
			Hardness = 2.5;
			break;
		case EST_Metal :
//			Hardness = 8.0; // too much
			Hardness = 4.0;
			break;
		case EST_Wood :
			Hardness = 0.5;
			break;
		case EST_Plant :
			Hardness = 0.1;
			break;
		case EST_Flesh :
			Hardness = 0.2;
			break;
		case EST_Ice :
//			Hardness = 1.0;
			Hardness = 0.8;
			break;
		case EST_Snow :
			Hardness = 0.1;
			break;
		case EST_Water :
			Hardness = 0.1;
			break;
		case EST_Glass :
			Hardness = 0.3;
			break;
		case EST_Gravel :
			Hardness = 0.4;
			break;
		case EST_Concrete :
			Hardness = 2.0;
			break;
		case EST_HollowWood :
			Hardness = 0.3;
			break;
		case EST_MetalArmor :
//			Hardness = 16.0;
			Hardness = 10.0;
			break;
		case EST_Paper :
			Hardness = 0.2;
			break;
		case EST_Cloth :
			Hardness = 0.3;
			break;
		case EST_Rubber :
			Hardness = 0.2;
			break;
		case EST_Poop :
			Hardness = 0.1;
			break;
		default:
			Hardness = 0.5;
			break;
	}

	//if(bDebugMode) log("Hit Surface type:"@HitSurfaceType@"with hardness of"@Hardness);

	return;
}

/* HE Shell explosion for when it hit a tank but didn't penetrate
simulated function NonPenetrateExplode(vector HitLocation, vector HitNormal)
{
	if( bCollided )
		return;

	DoShakeEffect();

	if( !bDidExplosionFX )
	{
 	    PlaySound(VehicleDeflectSound,,5.5*TransientSoundVolume);
	    if ( EffectIsRelevant(Location,false) )
	    {
	    	Spawn(ShellDeflectEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
	    }

	    PlaySound(ExplosionSound[Rand(3)],,5.5*TransientSoundVolume);

	    bDidExplosionFX=true;
    }

	if ( Corona != None )
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
		SetCollision(False,False);
	}
	else
	{
		Destroy();
	}
}
*/
simulated function Destroyed()
{
	local vector TraceHitLocation, TraceHitNormal;
	local Material HitMaterial;
	local ESurfaceTypes ST;
	local bool bShowDecal, bSnowDecal;

    if ( SavedHitActor == none )
    {
       Trace(TraceHitLocation, TraceHitNormal, Location + Vector(Rotation) * 16, Location, false,, HitMaterial);
    }

    DoShakeEffect();

	if( !bDidExplosionFX )
	{
	    if (HitMaterial == None)
			ST = EST_Default;
		else
			ST = ESurfaceTypes(HitMaterial.SurfaceType);

	    if ( SavedHitActor != none )
	    {

	        PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);
	        PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
	        if ( EffectIsRelevant(Location,false) )
	        {
	        	Spawn(ShellHitVehicleEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
	    		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
	    			Spawn(ExplosionDecal,self,,Location, rotator(-SavedHitNormal));
	        }
	    }
	    else
	    {
	        if ( EffectIsRelevant(Location,false) )
	        {
				if( !PhysicsVolume.bWaterVolume )
				{
					Switch(ST)
					{
						case EST_Snow:
						case EST_Ice:
							Spawn(ShellHitSnowEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							bSnowDecal = true;
							break;
						case EST_Rock:
						case EST_Gravel:
						case EST_Concrete:
							Spawn(ShellHitRockEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
						case EST_Wood:
						case EST_HollowWood:
							Spawn(ShellHitWoodEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
						case EST_Water:
							Spawn(ShellHitWaterEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
							bShowDecal = false;
							break;
						default:
							Spawn(ShellHitDirtEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
							PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
							bShowDecal = true;
							break;
					}

		    		if ( bShowDecal && Level.NetMode != NM_DedicatedServer )
		    		{
		    			if( bSnowDecal && ExplosionDecalSnow != None)
						{
		    				Spawn(ExplosionDecalSnow,self,,SavedHitLocation, rotator(-SavedHitNormal));
		    			}
		    			else if( ExplosionDecal != None)
						{
		    				Spawn(ExplosionDecal,self,,SavedHitLocation, rotator(-SavedHitNormal));
		    			}
		    		}
				}
	        }
	    }
    }

    if ( Corona != None )
		Corona.Destroy();

    Super.Destroyed();
}


//-----------------------------------------------------------------------------
// PhysicsVolumeChange - Blow up HE rounds when they hit water
//-----------------------------------------------------------------------------
simulated function PhysicsVolumeChange( PhysicsVolume Volume )
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
     WScale=1.000000
     PenetrationDamage=250.000000
     PenetrationDamageRadius=500.000000
     EnergyFactor=1000.000000
     PeneExploWallOut=75.000000
     PenetrationScale=0.080000
     DistortionScale=0.400000
     bIsHEATRound=True
     ShakeRotMag=(Y=0.000000)
     ShakeRotRate=(Z=2500.000000)
     BlurTime=6.000000
     BlurEffectScalar=2.100000
     VehicleDeflectSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
     ShellHitVehicleEffectClass=Class'ROEffects.TankHEHitPenetrate'
     ShellDeflectEffectClass=Class'ROEffects.TankHEHitDeflect'
     DamageRadius=300.000000
     MyDamageType=Class'DH_Vehicles.DH_PanzerIVCannonShellDamageHEAT'
     ExplosionDecal=Class'ROEffects.ArtilleryMarkDirt'
     ExplosionDecalSnow=Class'ROEffects.ArtilleryMarkSnow'
     LifeSpan=10.000000
     SoundRadius=1000.000000
}
