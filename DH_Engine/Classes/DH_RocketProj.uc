//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

// Matt: originally extended DH_ROAntiVehicleProjectile, but has so much in common with a HEAT shell it's simpler & cleaner to extend that
class DH_RocketProj extends DH_ROTankCannonShellHEAT
//  config(DH_Penetration)
    abstract;

#exec OBJ LOAD FILE=Inf_Weapons.uax

var PanzerfaustTrail SmokeTrail;         // smoke trail emitter
var() float          StraightFlightTime; // how long the rocket has propellant and flies straight
var   float          TotalFlightTime;    // how long the rocket has been in flight
var   bool           bOutOfPropellant;   // rocket is out of propellant

// Matt: removed as no longer used anywhere:
// var bool   bHitWater;
// var vector OuttaPropLocation;      // physics debugging
// var globalconfig bool  bDebugMode; // if true, give our detailed report in log

replication
{
    reliable if (bNetDirty && Role==ROLE_Authority)
        bOutOfPropellant;
}


// Modified to spawn a rocket smoke trail
simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer && bHasTracer)
    {
        SmokeTrail = Spawn(class'PanzerfaustTrail', self);
        SmokeTrail.SetBase(self);

        Corona = Spawn(TracerEffect, self);
    }

//  Velocity = Speed * vector(Rotation); // Matt: removed as already done in Super in ROBallisticProjectile

    if (PhysicsVolume.bWaterVolume)
    {
        Velocity = 0.6 * Velocity;
    }

    super(DH_ROAntiVehicleProjectile).PostBeginPlay();
}

// Modified to drop lighting if low detail or not required
simulated function PostNetBeginPlay()
{
    local PlayerController PC;

    super.PostNetBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (Level.bDropDetail || Level.DetailMode == DM_Low)
        {
            bDynamicLight = false;
            LightType = LT_None;
        }
        else
        {
            PC = Level.GetLocalPlayerController();

            if (Instigator != none && PC == Instigator.Controller)
            {
                return;
            }

            if (PC == none || PC.ViewTarget == none || VSize(PC.ViewTarget.Location - Location) > 3000.0)
            {
                bDynamicLight = false;
                LightType = LT_None;
            }
        }
    }
}

// Fixes broken RO class to make rockets work like rockets
simulated function Tick(float DeltaTime)
{
    SetPhysics(PHYS_Flying);

    super.Tick(DeltaTime);

    if (!bOutOfPropellant)
    {
        if (TotalFlightTime <= StraightFlightTime)
        {
            TotalFlightTime += DeltaTime;
        }
        else
        {
//          OuttaPropLocation = Location; // Matt: deprecated
            bOutOfPropellant = true;

            // cut off the rocket engine effects when outta propellant
            if (SmokeTrail != none)
            {
                SmokeTrail.HandleOwnerDestroyed();
            }

            if (Corona != none)
            {
                Corona.Destroy();
            }
        }
    }

    if (bOutOfPropellant && Physics != PHYS_Projectile)
    {
        SetPhysics(PHYS_Projectile);
    }
}

// Matt: re-worked, with commentary below
simulated function DELETEProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          TempHitLocation, HitNormal, SavedVelocity;
    local array<int>      HitPoints;
    local float           TouchAngle; // dummy variable passed to DHShouldPenetrate function (does not need a value setting)

    if (bDebuggingText) Log("Rocket.ProcessTouch called: Other =" @ Other.Tag @ " SavedTouchActor =" @ SavedTouchActor @ " SavedHitActor =" @ SavedHitActor); // TEMP

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

                if (bDebuggingText) Log("Rocket.ProcessTouch: hit driver, authority should damage him & explode"); // TEMP
                if (Role == ROLE_Authority && VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                {
                    VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
                }
            }
            else
            {
                if (bDebuggingText) Log("Rocket.ProcessTouch: hit driver area but not driver, rocket should continue"); // TEMP
                SavedTouchActor = none; // this isn't a real hit so we shouldn't save hitting this actor
                return;
            }
        }

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
                Level.Game.Broadcast(self, "Rocket HEAT failed to penetrate turret!");
            }

//            FailToPenetrate(HitLocation); // no deflection for HEAT, just detonate without damage

            // Don't update the position any more and don't move the projectile any more
            bUpdateSimulatedPosition = false;
            SetPhysics(PHYS_None);
            SetDrawType(DT_None);

            HurtWall = none;

            return;
        }

        // Don't update the position any more and don't move the projectile any more.
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
            if (!Other.Base.bStatic && !Other.Base.bWorldGeometry)
            {
                // Matt: removed as SetDDI is irrelevant to VehWeapon (empty function) & for Vehicle we'll let the VehWeapon call SetDDI on the Vehicle only if it's calling TakeDamage on it
//              if (ShellImpactDamage.default.bDelayedDamage && Instigator == none || Instigator.Controller == none)
//              {
//                  HitVehicleWeapon.SetDelayedDamageInstigatorController(InstigatorController);
//                  HitVehicle.SetDelayedDamageInstigatorController(InstigatorController);
//              }

                HitVehicleWeapon.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);

                if (DamageRadius > 0 && HitVehicle.Health > 0)
                {
                    HitVehicle.DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, HitLocation);
                }

                HurtWall = HitVehicle;
            }
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
                if (bDebuggingText) Log("Rocket.ProcessTouch: successful HitPointTrace on ROPawn, authority calling ProcessLocationalDamage on it"); // TEMP
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);
                }
            }
            else
            {
                if (bDebuggingText) Log("Rocket.ProcessTouch: unsuccessful HitPointTrace on ROPawn, doing nothing"); // TEMP
                return; // exit without exploding, so rocket continues on its flight
            }
        }
        // We hit some other kind of pawn or a destroyable mesh
        else if (Other.IsA('RODestroyableStaticMesh') || Other.IsA('Pawn'))
        {
            if (Role == ROLE_Authority)
            {
                Other.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
            }

            // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so it won't make a rocket explode
            if (Other.IsA('RODestroyableStaticMesh') && RODestroyableStaticMesh(Other).bWontStopBullets)
            {
                if (bDebuggingText) Log("Rocket.ProcessTouch: exiting as hit destroyable SM but it doesn't stop bullets"); // TEMP
                return;
            }
            else if (bDebuggingText && Other.IsA('RODestroyableStaticMesh')) Log("Rocket.ProcessTouch: exploding on destroyable SM"); // TEMP
            else if (bDebuggingText) Log("Rocket.ProcessTouch: exploding on Pawn" @ Other.Tag @ "that is not an ROPawn"); // TEMP
        }
        // Otherwise we hit something we aren't going to damage
        else if (Role == ROLE_Authority && Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        {
            if (bDebuggingText) Log("Rocket.ProcessTouch: exploding on Actor" @ Other.Tag @ "that is not a Pawn or destroyable SM???"); // TEMP
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
simulated singular function DELETEHitWall(vector HitNormal, actor Wall)
{
    local float tmpMaxWall;
    local vector TmpHitLocation, TmpHitNormal, X, Y, Z, LastLoc;
    local float xH;
    local Actor tmpHit;
    local vector SavedVelocity;
    local float HitAngle;

    // Check to prevent recursive calls and to make sure we actually hit something
    if (bInHitWall || (Wall.Base != none && Wall.Base == instigator))
    {
        return;
    }

    LastLoc = Location;
    HitAngle = 1.57;

    // Have we hit a world item we can penetrate?
    if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
    {
//        bNoWorldPen = true;
    }

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
}

defaultproperties
{
    bExplodesOnHittingBody=true
    bExplodesOnHittingWater=false
    ExplosionSound(0)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode03'
    StraightFlightTime=0.200000
    PenetrationDamageRadius=250.000000
    TracerEffect=class'DH_Effects.DH_OrangeTankShellTracer'
    PenetrationMag=250.000000
    ShellImpactDamage=class'ROGame.RORocketImpactDamage'
    ImpactDamage=675
    VehicleHitSound=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode01'
    ShellHitVehicleEffectClass=class'ROEffects.PanzerfaustHitTank'
    ShellHitDirtEffectClass=class'ROEffects.PanzerfaustHitDirt'
    ShellHitSnowEffectClass=class'ROEffects.PanzerfaustHitSnow'
    ShellHitWoodEffectClass=class'ROEffects.PanzerfaustHitWood'
    ShellHitRockEffectClass=class'ROEffects.PanzerfaustHitConcrete'
    ShellHitWaterEffectClass=class'ROEffects.PanzerfaustHitWater'
    BallisticCoefficient=0.050000
    Damage=300.000000
    DamageRadius=250.000000
    ExplosionDecal=class'ROEffects.RocketMarkDirt'
    ExplosionDecalSnow=class'ROEffects.RocketMarkSnow'
    LightType=LT_Steady
    LightEffect=LE_QuadraticNonIncidence
    LightHue=28
    LightBrightness=255.000000
    LightRadius=5.000000
    CullDistance=7500.000000
    bDynamicLight=true
    LifeSpan=15.000000

//  Override unwanted defaults now inherited from DH_ROTankCannonShellHEAT & DH_ROTankCannonShell:
    ShakeRotMag=(Y=50.0,Z=200.0)
    ShakeRotRate=(Y=500.0,Z=1500.0)
    BlurEffectScalar=1.9
    VehicleDeflectSound=Sound'ProjectileSounds.cannon_rounds.AP_deflect'
    ShellDeflectEffectClass=none
    MyDamageType=class'DamageType'
    SoundRadius=64.0
    AmbientVolumeScale=1.0
    SpeedFudgeScale=1.0
    InitialAccelerationTime=0.1
    Speed=0.0
    MaxSpeed=2000.0
}
