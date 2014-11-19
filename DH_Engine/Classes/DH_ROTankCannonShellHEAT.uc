//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShellHEAT extends DH_ROTankCannonShell;


var sound               ExplosionSound[3];        // sound of this shell exploding

// Penetration
var bool bInHitWall;

var float MaxWall;      // Maximum wall penetration
var float WScale;       // Penetration depth scale factor to take into account; weapon scale
var float Hardness;     // wall hardness, calculated in CheckWall for surface type
var float PenetrationDamage;    // Damage done by rocket penetrating wall
var float PenetrationDamageRadius;        // Damage radius for rocket penetrating wall
var float EnergyFactor;        // For calculating penetration of projectile
var float PeneExploWallOut;   // Distance out from the wall to spawn penetration explosion

var globalconfig float  PenetrationScale;   // global Penetration depth scale factor
var globalconfig float  DistortionScale;    // global Distortion scale factor
//var globalconfig bool     bDebugMode;         // If true, give our detailed report in log.
//var globalconfig bool     bDebugROBallistics; // If true, set bDebugBallistics to true for getting the arrow pointers

var bool bDidPenetrationExplosionFX; // Already did the penetration explosion effects

var         bool                bNoWorldPen;   // Rocket has hit something other than the world and should be destroyed without running world penetration check

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local vector TraceHitLocation, TraceHitNormal;
    local Material HitMaterial;
    local ESurfaceTypes ST;
    local bool bShowDecal, bSnowDecal;

    if (!bDidExplosionFX)
    {
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
            PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
            if (EffectIsRelevant(Location, false))
            {
                Spawn(ShellHitVehicleEffectClass,,,HitLocation + HitNormal*16,rotator(HitLocation));
                if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                    Spawn(ExplosionDecal,self,,Location, rotator(-HitLocation));
            }
        }
        else
        {
            if (EffectIsRelevant(Location, false))
            {
                if (!PhysicsVolume.bWaterVolume)
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

                    if (bShowDecal && Level.NetMode != NM_DedicatedServer)
                    {
                        if (bSnowDecal && ExplosionDecalSnow != none)
                        {
                            Spawn(ExplosionDecalSnow,self,,HitLocation, rotator(-HitNormal));
                        }
                        else if (ExplosionDecal != none)
                        {
                            Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
                        }
                    }
                }
            }
        }
    }

    if (bCollided)
        return;

    BlowUp(HitLocation);

    // Save the hit info for when the shell is destroyed
    SavedHitLocation = HitLocation;
    SavedHitNormal = HitNormal;
    AmbientSound=none;

    if (Corona != none)
    Corona.Destroy();

    bDidExplosionFX = true;

    if (bNoWorldPen)
    {
        if (Level.NetMode == NM_DedicatedServer)
        {
            bCollided = true;
            SetCollision(false, false);
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

    if (!bDidPenetrationExplosionFX)
    {
        if (SavedHitActor == none)
        {
           Trace(TraceHitLocation, TraceHitNormal, Location + vector(Rotation) * 16, Location, false,, HitMaterial);
        }

        if (HitMaterial == none)
            ST = EST_Default;
        else
            ST = ESurfaceTypes(HitMaterial.SurfaceType);

/*      if (SavedHitActor != none)
        {

            PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);
            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
            if (EffectIsRelevant(Location, false))
            {
                Spawn(ShellHitVehicleEffectClass,,,HitLocation + HitLocation*16,rotator(HitLocation));
                if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                    Spawn(ExplosionDecal,self,,Location, rotator(-HitLocation));
            }
        }
        else
        { */
            if (EffectIsRelevant(Location, false))
            {
                if (!PhysicsVolume.bWaterVolume)
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

                    if (bShowDecal && Level.NetMode != NM_DedicatedServer)
                    {
                        if (bSnowDecal && ExplosionDecalSnow != none)
                        {
                            Spawn(ExplosionDecalSnow,self,,ActualHitLocation, rotator(-HitNormal));
                        }
                        else if (ExplosionDecal != none)
                        {
                            Spawn(ExplosionDecal,self,,ActualHitLocation, rotator(-HitNormal));
                        }
                    }
                }
            }
//      }
    }

    if (bCollided)
        return;

    PenetrationBlowUp(HitLocation);

    // Save the hit info for when the shell is destroyed
    SavedHitLocation = HitLocation;
    SavedHitNormal = HitNormal;
    AmbientSound=none;

    if (Corona != none)
    Corona.Destroy();

    bDidPenetrationExplosionFX = true;

    if (Level.NetMode == NM_DedicatedServer)
    {
        bCollided = true;
        SetCollision(false, false);
    }
    else
    {
        bCollided = true;
        Destroy();
    }
}

function PenetrationBlowUp(vector HitLocation)
{
    HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    MakeNoise(1.0);
}

// HEAT rounds only deflect when they strike at angles, but for simplicity's sake, lets just detonate them with no damage instead
simulated function FailToPenetrate(vector HitLocation)
{
    local vector TraceHitLocation, HitNormal;

    Trace(TraceHitLocation, HitNormal, HitLocation + Normal(Velocity) * 50, HitLocation - Normal(Velocity) * 50, true);
    Explode(HitLocation + ExploWallOut * HitNormal, HitNormal);
}

// Matt: re-worked, with commentary below
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          TempHitLocation, HitNormal, SavedVelocity;
    local array<int>      HitPoints;
    local float           TouchAngle; // dummy variable passed to DHShouldPenetrate function (does not need a value setting)

    if (bDebuggingText) log("HEAT.ProcessTouch called: Other =" @ Other.Tag @ " SavedTouchActor =" @ SavedTouchActor @ " SavedHitActor =" @ SavedHitActor); // TEMP
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

                if (bDebuggingText) log("HEAT.ProcessTouch: hit driver, authority should damage him & shell continue"); // TEMP
                if (Role == ROLE_Authority && VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                {
                    VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
                }

                Velocity *= 0.8; // hitting the Driver's body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else
            {
                if (bDebuggingText) log("HEAT.ProcessTouch: hit driver area but not driver, shell should continue"); // TEMP
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
        if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateHEAT(HitLocation, Normal(Velocity),
            GetPenetration(LaunchLocation - HitLocation), TouchAngle, ShellImpactDamage, bIsHEATRound))
        {
            if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
            {
                FirstHit = false;
                DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 0, 255, 0);
            }

            if (bDebuggingText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "HEAT failed to penetrate turret!");
            }

            FailToPenetrate(HitLocation); // no deflection for HEAT, just detonate without damage

            // Don't update the position any more and don't move the projectile any more
            bUpdateSimulatedPosition = false;
            SetPhysics(PHYS_None);
            SetDrawType(DT_None);

            HurtWall = none;

            return;
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SavedVelocity = Velocity; // PHYS_None zeroes Velocity, so we have to save it
        SetPhysics(PHYS_None);
        SetDrawType(DT_None);

        if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
        {
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
                if (bDebuggingText) log("HEAT.ProcessTouch: successful HitPointTrace on ROPawn, authority calling ProcessLocationalDamage on it"); // TEMP
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);
                }

                Velocity *= 0.8; // hitting a body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else if (bDebuggingText) log("HEAT.ProcessTouch: unsuccessful HitPointTrace on ROPawn, doing nothing"); // TEMP

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
                if (bDebuggingText) log("HEAT.ProcessTouch: exiting as hit destroyable SM but it doesn't stop bullets"); // TEMP
                return;
            }
            else if (bDebuggingText && Other.IsA('RODestroyableStaticMesh')) log("HEAT.ProcessTouch: exploding on destroyable SM"); // TEMP
            else if (bDebuggingText) log("HEAT.ProcessTouch: exploding on Pawn" @ Other.Tag @ "that is not an ROPawn"); // TEMP
        }
        // Otherwise we hit something we aren't going to damage
        else if (Role == ROLE_Authority && Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        {
            if (bDebuggingText) log("HEAT.ProcessTouch: exploding on Actor" @ Other.Tag @ "that is not a Pawn or destroyable SM???"); // TEMP
            ROBot(Instigator.Controller).NotifyIneffectiveAttack();
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SetPhysics(PHYS_None);
        SetDrawType(DT_None);

        Explode(HitLocation, vect(0.0,0.0,1.0));
        HurtWall = none;
    }
}

// Overridden to handle world and object penetration
simulated singular function HitWall(vector HitNormal, actor Wall)
{
    local float tmpMaxWall;
    local vector TmpHitLocation, TmpHitNormal, X,Y,Z, LastLoc;
    local float xH; //,EnergyFactor;
    //local rotator distortion;
    local actor tmpHit;

    local vector SavedVelocity;
//  local PlayerController PC;

    local float HitAngle;

    // Check to prevent recursive calls and to make sure we actually hit something
    if (bInHitWall || (Wall.Base != none && Wall.Base == instigator))
        return;

    LastLoc = Location;
    HitAngle = 1.57;

    // Have we hit a world item we can penetrate?
    if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
       bNoWorldPen = true;

    if (bDebuggingText && Role == ROLE_Authority)
    {
        if (!bIsAlliedShell)
        {
            Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$"m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s"); //, flight time = "$FlightTime$"s");
        }
        else
        {
            Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$"yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps"); //, flight time = "$FlightTime$"s");
        }
    }

    if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateHEAT(Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellImpactDamage, bIsHEATRound))
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

        // Don't save hitting this actor since we deflected
        SavedHitActor = none;
        // Don't update the position any more
        bUpdateSimulatedPosition=false;

        //Deflect(HitNormal, Wall);
        Explode(Location + ExploWallOut * HitNormal, HitNormal);

        if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
            ROBot(Instigator.Controller).NotifyIneffectiveAttack(ROVehicle(Wall));

        return;
    }

    if ((SavedHitActor == Wall) || (Wall.bDeleteMe))
        return;

    // Don't update the position any more and don't move the projectile any more.
    bUpdateSimulatedPosition=false;
    SetPhysics(PHYS_None);
    SetDrawType(DT_None);

    SavedHitActor = Pawn(Wall);

    Super(ROBallisticProjectile).HitWall(HitNormal, Wall);

    if (Role == ROLE_Authority)
    {
        if (bNoWorldPen)  // Using this value as we've already done this check earlier on
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
    //log(" Shell flew "$(VSize(LaunchLocation - Location)/60.352)$" meters total");

    bInHitWall = true;

    //if (bDebugMode) log("HitWall - Starting Penetration Check");

    GetAxes(Rotation,X,Y,Z);

    // Do the Max Wall Calculations
    CheckWall(HitNormal,X);
    xH = 1/Hardness;
    //EnergyFactor = 1000;         // EnergyFactor = (0.001*Vsize(Velocity))**2;
    MaxWall = EnergyFactor * xH * PenetrationScale * WScale;

    //if (bDebugMode) log("INFO - Velocity:"@Vsize(Velocity)@Velocity@" N "@Normal(Velocity)@" NRG Factor"@EnergyFactor@" MaxWall:"@MaxWall);

    // due to MaxWall getting into very high ranges we need to make shorter trace checks till we reach the full MaxWall value
    if (MaxWall > 16)
    {
        do
        {
            if ((tmpMaxWall + 16) <= MaxWall)
                tmpMaxWall += 16;
            else
                tmpMaxWall = MaxWall;
            tmpHit = Trace(TmpHitLocation,TmpHitNormal,Location,Location + X * tmpMaxWall, false);

            //if (bDebugMode) log("in do-while - tmpMaxWall:"@tmpMaxWall@" tmpHit:"@tmpHit);

            // due to StaticMeshs resulting in a hit even with the trace starting right inside of them (terrain and BSP 'space' would return none)
            if ((tmpHit != none) && !SetLocation(TmpHitLocation + (vect(0.5,0,0) * X)))
                tmpHit = none;

        } until ((tmpHit != none) || (tmpMaxWall >= MaxWall));
    }
    else
    {
        tmpHit = Trace(TmpHitLocation,TmpHitNormal,Location,Location + X * MaxWall, false);
    }

    if (tmpHit != none)
    {
        if (SetLocation(TmpHitLocation + (vect(0.5,0,0) * X)))
        {
            PenetrationExplode(TmpHitLocation + PeneExploWallOut * TmpHitNormal, TmpHitNormal);

            bInHitWall = false;

            if (MaxWall < 1.0)
            {
                if (Level.NetMode == NM_DedicatedServer) {
                    bCollided = true;
                    SetCollision(false, false);
                }
                else {
                    Destroy();
                }
            }
        }
        else
        {
            if (Level.NetMode == NM_DedicatedServer)
            {
                bCollided = true;
                SetCollision(false, false);
            }
            else
            {
                Destroy();
            }
        }
    }
    else
    {
        if (Level.NetMode == NM_DedicatedServer)
        {
            bCollided = true;
            SetCollision(false, false);
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

    if (HitMaterial != none)
        HitSurfaceType = ESurfaceTypes(HitMaterial.SurfaceType);
    else
        HitSurfaceType = EST_Default;

    switch (HitSurfaceType)
    {
        case EST_Default :
            Hardness = 0.7;
            break;
        case EST_Rock :
            Hardness = 2.5;
            break;
        case EST_Metal :
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

    return;
}

simulated function Destroyed()
{
    local vector TraceHitLocation, TraceHitNormal;
    local Material HitMaterial;
    local ESurfaceTypes ST;
    local bool bShowDecal, bSnowDecal;

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
            PlaySound(ExplosionSound[Rand(3)],,2.5*TransientSoundVolume);
            if (EffectIsRelevant(Location, false))
            {
                Spawn(ShellHitVehicleEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                    Spawn(ExplosionDecal,self,,Location, rotator(-SavedHitNormal));
            }
        }
        else
        {
            if (EffectIsRelevant(Location, false))
            {
                if (!PhysicsVolume.bWaterVolume)
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
        }
    }

    if (Corona != none)
        Corona.Destroy();

    super.Destroyed();
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
     WScale=1.000000
     PenetrationDamage=250.000000
     PenetrationDamageRadius=500.000000
     EnergyFactor=1000.000000
     PeneExploWallOut=75.000000
     PenetrationScale=0.080000
     DistortionScale=0.400000
     bIsHEATRound=true
     ShakeRotMag=(Y=0.000000)
     ShakeRotRate=(Z=2500.000000)
     BlurTime=6.000000
     BlurEffectScalar=2.100000
     VehicleDeflectSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
     ShellHitVehicleEffectClass=class'ROEffects.TankHEHitPenetrate'
     ShellDeflectEffectClass=class'ROEffects.TankHEHitDeflect'
     DamageRadius=300.000000
     MyDamageType=class'DH_HEATCannonShellDamage'
     ExplosionDecal=class'ROEffects.ArtilleryMarkDirt'
     ExplosionDecalSnow=class'ROEffects.ArtilleryMarkSnow'
     LifeSpan=10.000000
     SoundRadius=1000.000000
}
