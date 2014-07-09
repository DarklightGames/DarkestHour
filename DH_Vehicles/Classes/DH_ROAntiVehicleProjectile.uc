//==============================================================================
// DH_ROAntiVehicleProjectile
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for all Darkest Hour Anti-Vehicle weapon projectiles
//==============================================================================
class DH_ROAntiVehicleProjectile extends ROAntiVehicleProjectile
	    abstract;

var 	float 		DHPenetrationTable[11];

var		float		ShellDiameter;				    // to assist in T/d calculations

var     bool        bIsHEATRound;                   // Triggers different penetration calcs for HEAT projectiles (generally rockets)
var     bool        bIsAlliedShell;                 // just for debugging stuff, maybe later for shell shatter
var     bool        bShatterProne;                  // assists with shatter gap calculations

var()   class<Emitter>  ShellShatterEffectClass; 	// Effect for this shell shattering against a vehicle
var 	sound 		    ShatterVehicleHitSound; 	// sound of this shell shattering on the vehicle
var		sound		    ShatterSound[4];            // sound of the round exploding

var 	Effects 	Corona;     // Shell tracer
var	    bool		bHasTracer; // will be disabled for HE shells, and any others with no tracers
var	class<Effects>	TracerEffect;

// camera shakes //
var() 		vector 				ShakeRotMag;           		// how far to rot view
var() 		vector 				ShakeRotRate;          		// how fast to rot view
var() 		float  				ShakeRotTime;          		// how much time to rot the instigator's view
var() 		vector 				ShakeOffsetMag;        		// max view offset vertically
var() 		vector 				ShakeOffsetRate;       		// how fast to offset view vertically
var() 		float  				ShakeOffsetTime;       		// how much time to offset view
var			float				BlurTime;                   // How long blur effect should last for this shell
var			float				BlurEffectScalar;
var         float               PenetrationMag;             //different for AP and HE shells and can be set by caliber too

// Debugging code - set to false on release
var     bool	bDebuggingText;

//Borrowed from AB: Just using a standard linear interpolation equation here
simulated function float GetPenetration(vector Distance)
{
	local float MeterDistance;
	local float PenetrationNumber;

	MeterDistance = VSize(Distance)/60.352;

	//Distance debugging
 	//log(self$" traveled "$MeterDistance$" meters for penetration calculations");
	//Level.Game.Broadcast(self, self$" traveled "$MeterDistance$" meters for penetration calculations");

    if      ( MeterDistance < 100)  PenetrationNumber = ( DHPenetrationTable[0] + (100 - MeterDistance) * (DHPenetrationTable[0]-DHPenetrationTable[1]) / 100 );
	else if ( MeterDistance < 250)	PenetrationNumber = ( DHPenetrationTable[1] + (250 - MeterDistance) * (DHPenetrationTable[0]-DHPenetrationTable[1]) / 150 );
	else if ( MeterDistance < 500)	PenetrationNumber = ( DHPenetrationTable[2] + (500 - MeterDistance) * (DHPenetrationTable[1]-DHPenetrationTable[2]) / 250 );
	else if ( MeterDistance < 750)	PenetrationNumber = ( DHPenetrationTable[3] + (750 - MeterDistance) * (DHPenetrationTable[2]-DHPenetrationTable[3]) / 250 );
	else if ( MeterDistance < 1000)	PenetrationNumber = ( DHPenetrationTable[4] + (1000 - MeterDistance) * (DHPenetrationTable[3]-DHPenetrationTable[4]) / 250 );
	else if ( MeterDistance < 1250)	PenetrationNumber = ( DHPenetrationTable[5] + (1250 - MeterDistance) * (DHPenetrationTable[4]-DHPenetrationTable[5]) / 250 );
	else if ( MeterDistance < 1500)	PenetrationNumber = ( DHPenetrationTable[6] + (1500 - MeterDistance) * (DHPenetrationTable[5]-DHPenetrationTable[6]) / 250 );
	else if ( MeterDistance < 1750)	PenetrationNumber = ( DHPenetrationTable[7] + (1750 - MeterDistance) * (DHPenetrationTable[6]-DHPenetrationTable[7]) / 250 );
	else if ( MeterDistance < 2000)	PenetrationNumber = ( DHPenetrationTable[8] + (2000 - MeterDistance) * (DHPenetrationTable[7]-DHPenetrationTable[8]) / 250 );
	else if ( MeterDistance < 2500)	PenetrationNumber = ( DHPenetrationTable[9] + (2500 - MeterDistance) * (DHPenetrationTable[8]-DHPenetrationTable[9]) / 500 );
	else if ( MeterDistance < 3000)	PenetrationNumber = ( DHPenetrationTable[10] + (3000 - MeterDistance) * (DHPenetrationTable[9]-DHPenetrationTable[10]) / 500 );
	else PenetrationNumber = DHPenetrationTable[10];

    if (NumDeflections > 0)
    {
        PenetrationNumber = PenetrationNumber * 0.04;  //just for now, until pen is based on velocity
    }

	return PenetrationNumber;

}

//DH CODE: Returns (T/d) for APC/APCBC shells
simulated function float GetOverMatch (float ArmorFactor, float ShellDiameter)
{
    local float OverMatchFactor;

    OverMatchFactor = ( ArmorFactor / ShellDiameter );

    return OverMatchFactor;

}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local ROVehicle HitVehicle;
	local ROVehicleWeapon HitVehicleWeapon;
	local bool bHitVehicleDriver;

	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;

    local float         TouchAngle;     // dummy variable

	HitVehicleWeapon = ROVehicleWeapon(Other);
	HitVehicle = ROVehicle(Other.Base);

	TouchAngle=1.57;

    if( Other == none || (SavedTouchActor != none && SavedTouchActor == Other) || Other.bDeleteMe ||
		ROBulletWhipAttachment(Other) != none  )
    {
    	return;
    }

    SavedTouchActor = Other;

	if ( (Other != instigator) && (Other.Base != instigator) && (Other.Owner != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
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

            if ( HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateAPC( HitLocation, Normal(Velocity), GetPenetration(LaunchLocation-HitLocation), TouchAngle, ShellDiameter, ShellImpactDamage, bShatterProne))
            {
                if(bDebuggingText && Role == ROLE_Authority)
                {
                    Level.Game.Broadcast(self, "Turret Ricochet!");
                }

                if( Drawdebuglines && Firsthit )
				{
					FirstHit=false;
					DrawStayingDebugLine( Location, Location-(Normal(Velocity)*500), 0, 255, 0);
				}

                if (!bShatterProne || !DH_ROTankCannon(HitVehicleWeapon).bRoundShattered)
                {
				    // Don't save hitting this actor since we deflected
       			    SavedHitActor = none;
       			    // Don't update the position any more
				    bUpdateSimulatedPosition=false;

                    DoShakeEffect();
			        DeflectWithoutNormal(Other, HitLocation);
                    if( Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none )
        			   ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
                    return;
                }
                else
                {
                	ShatterExplode(HitLocation + ExploWallOut * Normal(-Velocity), Normal(-Velocity));

				    // Don't update the position any more and don't move the projectile any more.
				    bUpdateSimulatedPosition=false;
				    SetPhysics(PHYS_None);
				    SetDrawType(DT_None);

				    HurtWall = None;
				    if ( Role == ROLE_Authority )
				    {
					   MakeNoise(1.0);
				    }
		            return;
                }
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
							ROPawn(Other).ProcessLocationalDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);

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

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	local vector SavedVelocity;
//	local PlayerController PC;

	local float HitAngle;

	HitAngle=1.57;

    if ( Wall.Base != none && Wall.Base == instigator )
     	return;

    SavedVelocity = Velocity;

    if(bDebuggingText && Role == ROLE_Authority)
    {
        if(!bIsAlliedShell)
        {
          Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$"m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s");
        }
        else
        {
          Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$"yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps");
        }
    }

    if ( Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateAPC( Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellDiameter, ShellImpactDamage, bShatterProne))
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

        if (!bShatterProne || !DH_ROTreadCraft(Wall).bRoundShattered)
        {

		    // Don't save hitting this actor since we deflected
            SavedHitActor = none;
            // Don't update the position any more
		    bUpdateSimulatedPosition=false;

            DoShakeEffect();
		    Deflect(HitNormal, Wall);

		    if( Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none )
			   ROBot(Instigator.Controller).NotifyIneffectiveAttack(ROVehicle(Wall));

            return;
        }
        else
        {
        	if ( Role == ROLE_Authority )
		    {
                MakeNoise(1.0);
            }

            ShatterExplode(Location + ExploWallOut * HitNormal, HitNormal);

		    // Don't update the position any more and don't move the projectile any more.
		    bUpdateSimulatedPosition=false;
		    SetPhysics(PHYS_None);
		    SetDrawType(DT_None);

		    HurtWall = None;
            return;
        }
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
		if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
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

}

simulated function DoShakeEffect()
{
	local PlayerController PC;
	local float Dist, Scale;

	//viewshake
	if (Level.NetMode != NM_DedicatedServer)
	{
		PC = Level.GetLocalPlayerController();
		if (PC != None && PC.ViewTarget != None)
		{
			Dist = VSize(Location - PC.ViewTarget.Location);
			if (Dist < PenetrationMag * 3.0 && ShellDiameter > 2.0)
			{
				scale = (PenetrationMag*3.0  - Dist) / (PenetrationMag*3.0 /*4.0*/);
                scale *= BlurEffectScalar;

				PC.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);

				if( PC.Pawn != none && ROPawn(PC.Pawn) != none )
				{
					scale = scale - (scale * 0.35 - ((scale * 0.35) * ROPawn(PC.Pawn).GetExposureTo(Location + 50 * -Normal(PhysicsVolume.Gravity))));
				}
				ROPlayer(PC).AddBlur(BlurTime*scale, FMin(1.0,scale));
			}
		}
	}
}

// AP shell shatter for when it hit a tank but didn't penetrate
simulated function ShatterExplode(vector HitLocation, vector HitNormal)
{
	if( bCollided )
		return;

	DoShakeEffect();

	if( !bDidExplosionFX )
	{
 	    PlaySound(ShatterVehicleHitSound,,5.5*TransientSoundVolume);
	    if ( EffectIsRelevant(Location,false) )
	    {
	    	Spawn(ShellShatterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
	    }

	    PlaySound(ShatterSound[Rand(4)],,5.5*TransientSoundVolume);

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

defaultproperties
{
     bIsAlliedShell=True
     ShellShatterEffectClass=Class'DH_Effects.DH_TankAPShellShatter'
     ShatterVehicleHitSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
     ShatterSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
     ShatterSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
     ShatterSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
     ShatterSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
     ShakeRotMag=(Y=50.000000,Z=200.000000)
     ShakeRotRate=(Y=500.000000,Z=1500.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(Z=10.000000)
     ShakeOffsetRate=(Z=200.000000)
     ShakeOffsetTime=5.000000
     BlurTime=3.000000
     BlurEffectScalar=1.900000
     PenetrationMag=100.000000
}
