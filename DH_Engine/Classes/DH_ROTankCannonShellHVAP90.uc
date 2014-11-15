//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShellHVAP90 extends DH_ROTankCannonShell;

// Matt: re-worked, with commentary below
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          TempHitLocation, HitNormal, SavedVelocity;
    local array<int>      HitPoints;
    local float           TouchAngle; // dummy variable passed to DHShouldPenetrate function (does not need a value setting)

    log("HVAP90.ProcessTouch called: Other =" @ Other.Tag @ " SavedTouchActor =" @ SavedTouchActor @ " SavedHitActor =" @ SavedHitActor); // TEMP
    if (Other == none || SavedTouchActor == Other || Other.bDeleteMe || Other.IsA('ROBulletWhipAttachment') || 
        Other == Instigator || Other.Base == Instigator || Other.Owner == Instigator || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    SavedTouchActor = Other;
    HitVehicleWeapon = ROVehicleWeapon(Other);
    HitVehicle = ROVehicle(Other.Base);

    // We hit a VehicleWeapon
    if (HitVehicleWeapon != none && HitVehicle != none)
    {
        // We hit the Driver's collision box, not the actual VehicleWeapon
        if (HitVehicleWeapon.HitDriverArea(HitLocation, Velocity))
        {
            // We actually hit the Driver
            if (HitVehicleWeapon.HitDriver(HitLocation, Velocity))
            {
                if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
                {
                    FirstHit = false;
                    DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 255, 0, 0);
                }

                log("HVAP90.ProcessTouch: hit driver, should damage him & shell continue"); // TEMP
                if (Role == ROLE_Authority && VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                {
                    VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
                }

                Velocity *= 0.8; // hitting the Driver's body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else
            {
                log("HVAP90.ProcessTouch: hit driver area but not driver, shell should continue"); // TEMP
                SavedTouchActor = none; // this isn't a real hit so we shouldn't save hitting this actor
            }

            return; // exit so shell carries on, as it only hit Driver's collision box not actual VehicleWeapon (even if we hit the Driver, his body won't stop shell)
        }

        SavedHitActor = HitVehicle;

        if (bDebuggingText && Role == ROLE_Authority)
        {
            if (bIsAlliedShell)
            {
                Level.Game.Broadcast(self, "Dist:" @ VSize(LaunchLocation - Location) / 66.002 @ "yards, ImpactVel:" @ VSize(Velocity) / 18.395 @ "fps");
            }
            else
            {
                Level.Game.Broadcast(self, "Dist:" @ VSize(LaunchLocation - Location) / 60.352 @ "m, ImpactVel:" @ VSize(Velocity) / 60.352 @ "m/s");
            }
        }

        // We hit a tank cannon (turret) but failed to penetrate
        if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateHVAPLarge(HitLocation, Normal(Velocity), 
            GetPenetration(LaunchLocation - HitLocation), TouchAngle, ShellImpactDamage, bShatterProne))
        {
            if (bDebuggingText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Turret ricochet!");
            }

            if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
            {
                FirstHit = false;
                DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 0, 255, 0);
            }

            // Round deflects off the turret
            if (!bShatterProne || !DH_ROTankCannon(HitVehicleWeapon).bRoundShattered)
            {
                SavedHitActor = none; // don't save hitting this actor since we deflected
                bUpdateSimulatedPosition = false; // don't replicate the position any more

                DoShakeEffect();
                DeflectWithoutNormal(HitVehicleWeapon, HitLocation);

                if (Instigator != none && ROBot(Instigator.Controller) != none)
                {
                    ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
                }
            }
            // Round shatters on turret
            else
            {
                // Don't update the position any more and don't move the projectile any more
                bUpdateSimulatedPosition = false;
                SavedVelocity = Velocity; // PHYS_none zeroes Velocity, so we have to save it
                SetPhysics(PHYS_none);
                SetDrawType(DT_none);

                ShatterExplode(HitLocation + ExploWallOut * Normal(-SavedVelocity), Normal(-SavedVelocity));
                HurtWall = none;
            }

            return;
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SavedVelocity = Velocity; // PHYS_none zeroes Velocity, so we have to save it
        SetPhysics(PHYS_none);
        SetDrawType(DT_none);

        if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
        {
            log("HVAP90.ProcessTouch: DrawStayingDebugLine for turret penetration: Velocity =" @ Velocity @ " SavedVelocity =" @ SavedVelocity); // TEMP
            FirstHit = false;
            DrawStayingDebugLine(Location, Location - (Normal(SavedVelocity) * 500.0), 255, 0, 0);
        }

        if (Role == ROLE_Authority)
        {
            if (Instigator == none || Instigator.Controller == none)
            {
                HitVehicleWeapon.SetDelayedDamageInstigatorController(InstigatorController);
                HitVehicle.SetDelayedDamageInstigatorController(InstigatorController);
            }

            HitVehicleWeapon.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);

            if (DamageRadius > 0 && HitVehicle.Health > 0)
            {
                HitVehicle.DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, HitLocation);
            }

            HurtWall = HitVehicle;
        }

        Explode(HitLocation + ExploWallOut * Normal(-SavedVelocity), Normal(-SavedVelocity));
        HurtWall = none;

        return;
    }
    // We hit something other than a VehicleWeapon
    else
    {
        // We hit a soldier ... potentially - first we need to run a HitPointTrace to make sure we actually hit part of his body, not just his collision area
        if (Other.IsA('ROPawn'))
        {
            Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * Normal(Velocity)), HitPoints, HitLocation, , 0);

            // We hit one of the body's hit points, so register a hit on the soldier
            if (Other != none)
            {
                log("HVAP90.ProcessTouch: successful HitPointTrace on ROPawn, calling ProcessLocationalDamage on it"); // TEMP
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);
                }

                Velocity *= 0.8; // hitting a body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else log("HVAP90.ProcessTouch: unsuccessful HitPointTrace on ROPawn, doing nothing"); // TEMP

            return; // exit without exploding, so shell continues on its flight
        }
        // We hit some other kind of pawn or a destroyable mesh
        else if (Other.IsA('RODestroyableStaticMesh') || Other.IsA('Pawn'))
        {
            if (Role == ROLE_Authority)
            {
                Other.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
            }

            // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so it won't make a shell explode
            if (Other.IsA('RODestroyableStaticMesh') && RODestroyableStaticMesh(Other).bWontStopBullets)
            {
                log("HVAP90.ProcessTouch: exiting as hit destroyable SM but it doesn't stop bullets"); // TEMP
                return;
            }
            else if (Other.IsA('RODestroyableStaticMesh')) log("HVAP90.ProcessTouch: exploding on destroyable SM"); // TEMP
            else log("HVAP90.ProcessTouch: exploding on Pawn" @ Other.Tag @ "that is not an ROPawn"); // TEMP
        }
        // Otherwise we hit something we aren't going to damage
        else if (Role == ROLE_Authority && Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        {
            log("HVAP90.ProcessTouch: exploding on Actor" @ Other.Tag @ "that is not a Pawn or destroyable SM???"); // TEMP
            ROBot(Instigator.Controller).NotifyIneffectiveAttack();
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SetPhysics(PHYS_none);
        SetDrawType(DT_none);

        Explode(HitLocation, vect(0.0,0.0,1.0));
        HurtWall = none;
    }
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
    local vector SavedVelocity;
//  local PlayerController PC;

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

    if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateHVAPLarge(Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellImpactDamage, bShatterProne))
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
