//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShellHEAT extends DH_ROTankCannonShell;

// Penetration:
var bool  bInHitWall;
var float MaxWall;                    // maximum wall penetration
var float WScale;                     // penetration depth scale factor to take into account; weapon scale
var float Hardness;                   // wall hardness, calculated in CheckWall for surface type
var float PenetrationDamage;          // damage done by shell penetrating wall
var float PenetrationDamageRadius;    // damage radius for shell penetrating wall
var float EnergyFactor;               // for calculating penetration of projectile
var float PeneExploWallOut;           // distance out from the wall to spawn penetration explosion
var bool  bDidPenetrationExplosionFX; // already did the penetration explosion effects
var bool  bHitWorldObject;            // flags that shell has hit a world object & should run a world penetration check (Matt: reversing original bHitWorldObject, as this way seems more logical)

var globalconfig float PenetrationScale; // global penetration depth scale factor
var globalconfig float DistortionScale;  // global distortion scale factor


simulated function DELETEExplode(vector HitLocation, vector HitNormal)
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

    if (!bHitWorldObject)
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

simulated function DELETEPenetrationExplode(vector HitLocation, vector HitNormal)
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

//    PenetrationBlowUp(HitLocation);

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

// HEAT rounds only deflect when they strike at angles, but for simplicity's sake, lets just detonate them with no damage instead
simulated function DELETEFailToPenetrate(vector HitLocation)
{
    local vector TraceHitLocation, HitNormal;

    Trace(TraceHitLocation, HitNormal, HitLocation + Normal(Velocity) * 50, HitLocation - Normal(Velocity) * 50, true);
    Explode(HitLocation + ExploWallOut * HitNormal, HitNormal);
}

// Matt: re-worked, with commentary below
simulated function DELETEProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          TempHitLocation, HitNormal, SavedVelocity;
    local array<int>      HitPoints;
    local float           TouchAngle; // dummy variable passed to DHShouldPenetrate function (does not need a value setting)

    if (bDebuggingText) Log("HEAT.ProcessTouch called: Other =" @ Other.Tag @ " SavedTouchActor =" @ SavedTouchActor @ " SavedHitActor =" @ SavedHitActor); // TEMP
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
                if (ShouldDrawDebugLines())
                {
                    DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 255, 0, 0);
                }

                if (bDebuggingText) Log("HEAT.ProcessTouch: hit driver, authority should damage him & shell continue"); // TEMP
                if (Role == ROLE_Authority && VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                {
                    VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
                }

                Velocity *= 0.8; // hitting the Driver's body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else
            {
                if (bDebuggingText) Log("HEAT.ProcessTouch: hit driver area but not driver, shell should continue"); // TEMP
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
        if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrate(Class, HitLocation, Normal(Velocity), GetPenetration(LaunchLocation - HitLocation)))
        {
            if (ShouldDrawDebugLines())
            {
                DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 0, 255, 0);
            }

            if (bDebuggingText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "HEAT failed to penetrate turret!");
            }

//            FailToPenetrate(HitLocation); // no deflection for HEAT, just detonate without damage

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

        if (ShouldDrawDebugLines())
        {
            DrawStayingDebugLine(Location, Location - (Normal(SavedVelocity) * 500.0), 255, 0, 0);
        }

        if (Role == ROLE_Authority)
        {
            // Matt: removed as SetDDI is irrelevant to VehWeapon (empty function) & for Vehicle we'll let the VehWeapon call SetDDI on the Vehicle only if it's calling TakeDamage on it
//          if (ShellImpactDamage.default.bDelayedDamage && Instigator == none || Instigator.Controller == none)
//          {
//              HitVehicleWeapon.SetDelayedDamageInstigatorController(InstigatorController);
//              HitVehicle.SetDelayedDamageInstigatorController(InstigatorController);
//          }

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
            Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * Normal(Velocity)), HitPoints, HitLocation,, 0);

            // We hit one of the body's hit points, so register a hit on the soldier
            if (Other != none)
            {
                if (bDebuggingText) Log("HEAT.ProcessTouch: successful HitPointTrace on ROPawn, authority calling ProcessLocationalDamage on it"); // TEMP
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);
                }

                Velocity *= 0.8; // hitting a body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else if (bDebuggingText) Log("HEAT.ProcessTouch: unsuccessful HitPointTrace on ROPawn, doing nothing"); // TEMP

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
                if (bDebuggingText) Log("HEAT.ProcessTouch: exiting as hit destroyable SM but it doesn't stop bullets"); // TEMP
                return;
            }
            else if (bDebuggingText && Other.IsA('RODestroyableStaticMesh')) Log("HEAT.ProcessTouch: exploding on destroyable SM"); // TEMP
            else if (bDebuggingText) Log("HEAT.ProcessTouch: exploding on Pawn" @ Other.Tag @ "that is not an ROPawn"); // TEMP
        }
        // Otherwise we hit something we aren't going to damage
        else if (Role == ROLE_Authority && Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        {
            if (bDebuggingText) Log("HEAT.ProcessTouch: exploding on Actor" @ Other.Tag @ "that is not a Pawn or destroyable SM???"); // TEMP
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

// Modified to handle world and object penetration
simulated singular function HitWall(vector HitNormal, Actor Wall)
{
    local vector SavedVelocity, X, Y, Z, TempHitLocation, TempHitNormal;
    local float  xH, TempMaxWall;
    local Actor  TraceHitActor;

    // Check to prevent recursive calls
    if (bInHitWall)
    {
        return;
    }

    // Have we hit a world item we can penetrate?
    if ((Wall.bStatic || Wall.bWorldGeometry) && RODestroyableStaticMesh(Wall) == none && Mover(Wall) == none)
    {
        bHitWorldObject = true;
    }

    // From here is the standard function from DH_ROAntiVehicleProjectile
    if ((Wall.Base != none && Wall.Base == Instigator) || SavedHitActor == Wall || Wall.bDeleteMe)
    {
        return;
    }

    if (bDebuggingText && Role == ROLE_Authority)
    {
        DebugShotDistanceAndSpeed();
    }

    // We hit an armored vehicle hull but failed to penetrate
    if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrate(Class, Location, Normal(Velocity), GetPenetration(LaunchLocation - Location)))
    {
        FailToPenetrateArmor(Location, HitNormal, Wall);

        return;
    }

    SavedHitActor = Pawn(Wall);

    if (Role == ROLE_Authority)
    {
//      if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
        if (!bHitWorldObject) // using this instead of above, as as we've already done this check earlier on
        {
            if (SavedHitActor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
            {
                if (ShouldDrawDebugLines())
                {
                    DrawStayingDebugLine(Location, Location - (Normal(SavedVelocity) * 500.0), 255, 0, 0);
                }

                if (Instigator == none || Instigator.Controller == none)
                {
                    Wall.SetDelayedDamageInstigatorController(InstigatorController);
                }

                Wall.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);
            }

            if (DamageRadius > 0 && Vehicle(Wall) != none && Vehicle(Wall).Health > 0)
            {
                Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
            }

            HurtWall = Wall;
        }
        else if (bBotNotifyIneffective && Instigator != none && ROBot(Instigator.Controller) != none)
        {
            ROBot(Instigator.Controller).NotifyIneffectiveAttack();
        }
    }

    Explode(Location + ExploWallOut * HitNormal, HitNormal);
    // End of the standard function from DH_ROAntiVehicleProjectile // Matt: TEST - should we have a "if (bHitWorldObject) here before proceeding to wall pen calcs?

    bInHitWall = true;

    // Do the MaxWall calculations
    GetAxes(Rotation, X, Y, Z);
    CheckWall(HitNormal, X);
    xH = 1.0 / Hardness;
    MaxWall = EnergyFactor * xH * PenetrationScale * WScale;

    // Due to MaxWall getting into very high ranges we need to make shorter trace checks till we reach the full MaxWall value
    if (MaxWall > 16.0)
    {
        do
        {
            if ((TempMaxWall + 16.0) <= MaxWall)
            {
                TempMaxWall += 16.0;
            }
            else
            {
                TempMaxWall = MaxWall;
            }

            TraceHitActor = Trace(TempHitLocation, TempHitNormal, Location, Location + (X * TempMaxWall), false);

            // Due to static meshes resulting in a hit even with the trace starting right inside of them (terrain and BSP 'space' would return none)
            if (TraceHitActor != none && !SetLocation(TempHitLocation + (vect(0.5,0.0,0.0) * X)))
            {
                TraceHitActor = none;
            }

        }
        until (TraceHitActor != none || TempMaxWall >= MaxWall);
    }
    else
    {
        TraceHitActor = Trace(TempHitLocation, TempHitNormal, Location, Location + X * MaxWall, false);
    }

    if (TraceHitActor != none && SetLocation(TempHitLocation + (vect(0.5,0.0,0.0) * X)))
    {
        WorldPenetrationExplode(TempHitLocation + PeneExploWallOut * TempHitNormal, TempHitNormal);

        bInHitWall = false;

        if (MaxWall >= 1.0)
        {
            return;
        }
    }

    HandleDestruction();
}

// Modified to handle shell destruction only if we didn't hit & penetrate a world object (if we did then we leave it to WorldPenetrationExplode)
simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (!bHitWorldObject)
    {
        super.Explode(HitLocation, HitNormal);
    }
    // This is the same as the Super, except we don't call HandleDestruction
    else if (!bCollided)
    {
        if (!bDidExplosionFX)
        {
            SpawnExplosionEffects(HitLocation, HitNormal);
            bDidExplosionFX = true;
        }

        if (bDebugBallistics)
        {
            HandleShellDebug(HitLocation);
        }

        BlowUp(HitLocation);
    }
}

// Alternative version of Explode if we have penetrated a world object (renamed from original PenetrationExplode, which misleadingly implied it related to vehicle penetration)
simulated function WorldPenetrationExplode(vector HitLocation, vector HitNormal)
{
    if (!bCollided)
    {
        if (!bDidPenetrationExplosionFX)
        {
            SpawnExplosionEffects(HitLocation, HitNormal, PeneExploWallOut); // passing PeneExploWallOut allows SpawnExplosionEffects to correctly adjust the explosion decal position
            bDidPenetrationExplosionFX = true;
        }

        super(DH_ROAntiVehicleProjectile).Explode(HitLocation, HitNormal);
    }
}

// Modified to always play an explosion sound for HEAT
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal, optional float ActualLocationAdjustment)
{
    super.SpawnExplosionEffects(HitLocation, HitNormal, ActualLocationAdjustment);

    PlaySound(ExplosionSound[Rand(4)], , 5.5 * TransientSoundVolume);
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

defaultproperties
{
    RoundType=RT_HEAT
    bExplodesOnArmor=true
    bExplodesOnHittingWater=true
    bAlwaysDoShakeEffect=true
    ExplosionSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    ExplosionSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    ExplosionSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    ExplosionSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
    DirtHitSound=none // so don't play in SpawnExplosionEffects, as will be drowned out by ExplosionSound
    RockHitSound=none
    WoodHitSound=none
    WaterHitSound=none
    WScale=1.000000
    PenetrationDamage=250.000000
    PenetrationDamageRadius=500.000000
    EnergyFactor=1000.000000
    PeneExploWallOut=75.000000
    PenetrationScale=0.080000
    DistortionScale=0.400000
//  bIsHEATRound=true // deprecated
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
