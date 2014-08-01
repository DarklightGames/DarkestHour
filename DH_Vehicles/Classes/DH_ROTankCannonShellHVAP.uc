//==============================================================================
// DH_ROTankCannonShellHVAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for APCR/HVAP projectiles - 50mm to 76mm
//==============================================================================
class DH_ROTankCannonShellHVAP extends DH_ROTankCannonShell;


simulated function ProcessTouch(Actor Other, vector HitLocation)
{
	local ROVehicle HitVehicle;
	local ROVehicleWeapon HitVehicleWeapon;
	local bool bHitVehicleDriver;

	local vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;

    local float         TouchAngle;     // dummy variable

	HitVehicleWeapon = ROVehicleWeapon(Other);
	HitVehicle = ROVehicle(Other.Base);

	TouchAngle=1.57;

    if (Other == none || (SavedTouchActor != none && SavedTouchActor == Other) || Other.bDeleteMe ||
		ROBulletWhipAttachment(Other) != none )
    {
    	return;
    }

    SavedTouchActor = Other;

	if ((Other != instigator) && (Other.Base != instigator) && (Other.Owner != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget))
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
                  Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$" m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s");
               }
               else
               {
                  Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$" yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps");
               }
            }

            if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateHVAP(HitLocation, Normal(Velocity), GetPenetration(LaunchLocation-HitLocation), TouchAngle, ShellImpactDamage, bShatterProne))
            {
                if (bDebuggingText && Role == ROLE_Authority)
                {
                    Level.Game.Broadcast(self, "Turret Ricochet!");
                }

                if (Drawdebuglines && Firsthit)
				{
					FirstHit=false;
					DrawStayingDebugLine(Location, Location-(Normal(Velocity)*500), 0, 255, 0);
				}

                if (!bShatterProne || !DH_ROTankCannon(HitVehicleWeapon).bRoundShattered)
                {
				    // Don't save hitting this actor since we deflected
       			    SavedHitActor = none;
       			    // Don't update the position any more
				    bUpdateSimulatedPosition=false;

                    DoShakeEffect();
			        DeflectWithoutNormal(Other, HitLocation);
                    if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        			   ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
                    return;
                }
                else
                {
                	ShatterExplode(HitLocation + ExploWallOut * Normal(-Velocity), Normal(-Velocity));

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

				    if (Drawdebuglines && Firsthit)
				    {
					    FirstHit=false;
					    DrawStayingDebugLine(Location, Location-(Normal(Velocity)*500), 255, 0, 0);
				    }

				    if (savedhitactor != none)
				    {
					    Other.Base.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
			        }

				    if (bHitVehicleDriver)
				    {
					    Other.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
			        }

				    if (Other != none && !Other.bDeleteMe)
				    {
					    if (DamageRadius > 0 && Vehicle(Other.Base) != none && Vehicle(Other.Base).Health > 0)
						    Vehicle(Other.Base).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, HitLocation);
				        HurtWall = Other.Base;
				    }
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
		        if (ROPawn(Other) != none)
		        {

					if (!Other.bDeleteMe)
			        {
				        Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * Normal(Velocity)), HitPoints, HitLocation,, 0);

						if (Other == none)
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
			else if (Role==Role_Authority)
			{
		        if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
					ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
			}

	        Explode(HitLocation,vect(0,0,1));
	    }
	}
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	local vector SavedVelocity;
//	local PlayerController PC;

	local float HitAngle;

	HitAngle=1.57;

    if (Wall.Base != none && Wall.Base == instigator)
     	return;

    SavedVelocity = Velocity;

    if (bDebuggingText && Role == ROLE_Authority)
    {
        if (!bIsAlliedShell)
        {
          Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$"m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s");
        }
        else
        {
          Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$"yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps");
        }
    }

    if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateHVAP(Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellImpactDamage, bShatterProne))
    {

        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Hull Ricochet!");
        }

        if (Drawdebuglines && Firsthit)
        {
			FirstHit=false;
			DrawStayingDebugLine(Location, Location-(Normal(Velocity)*500), 0, 255, 0);
			// DrawStayingDebugLine(Location, Location + 1000*HitNormal, 255, 0, 255);
        }

        if (!bShatterProne || !DH_ROTreadCraft(Wall).bRoundShattered)
        {

		    // Don't save hitting this actor since we deflected
            SavedHitActor = none;
            // Don't update the position any more
		    bUpdateSimulatedPosition=false;

            DoShakeEffect();
		    Deflect(HitNormal, Wall);

		    if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
			   ROBot(Instigator.Controller).NotifyIneffectiveAttack(ROVehicle(Wall));

            return;
        }
        else
        {
        	if (Role == ROLE_Authority)
		    {
                MakeNoise(1.0);
            }

            ShatterExplode(Location + ExploWallOut * HitNormal, HitNormal);

		    // Don't update the position any more and don't move the projectile any more.
		    bUpdateSimulatedPosition=false;
		    SetPhysics(PHYS_none);
		    SetDrawType(DT_none);

		    HurtWall = none;
            return;
        }
    }

    if ((SavedHitActor == Wall) || (Wall.bDeleteMe))
     	return;

    // Don't update the position any more and don't move the projectile any more.
	bUpdateSimulatedPosition=false;
	SetPhysics(PHYS_none);
	SetDrawType(DT_none);

    SavedHitActor = Pawn(Wall);

	Super(ROBallisticProjectile).HitWall(HitNormal, Wall);

	if (Role == ROLE_Authority)
	{
		if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
		{
			if (Instigator == none || Instigator.Controller == none)
				Wall.SetDelayedDamageInstigatorController(InstigatorController);

			if (savedhitactor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
			{
				if (Drawdebuglines && Firsthit)
				{
					FirstHit=false;
					DrawStayingDebugLine(Location, Location-(Normal(SavedVelocity)*500), 255, 0, 0);
				}
				Wall.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);
			}

			if (DamageRadius > 0 && Vehicle(Wall) != none && Vehicle(Wall).Health > 0)
				Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
			HurtWall = Wall;
		}
		else
		{
			if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
	        	ROBot(Instigator.Controller).NotifyIneffectiveAttack();
		}
		MakeNoise(1.0);
	}

	Explode(Location + ExploWallOut * HitNormal, HitNormal);

	HurtWall = none;

}

defaultproperties
{
     bShatterProne=true
}
