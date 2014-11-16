//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_RocketProj extends DH_ROAntiVehicleProjectile
      config(DH_Penetration);

#exec OBJ LOAD FILE=Inf_Weapons.uax

var             bool                bHitWater;
var             PanzerfaustTrail    SmokeTrail;             // Smoke trail emitter

var             sound               ExplodeSound[3];        // sound of this rocket exploding

// Physics
var()       float       StraightFlightTime;          // How long the rocket has propellant and flies straight
var         float       TotalFlightTime;             // How long the rocket has been in flight
var         bool        bOutOfPropellant;            // Rocket is out of propellant
// Physics debugging
var         vector      OuttaPropLocation;

// Penetration
var bool bInHitWall;

var float MaxWall;      // Maximum wall penetration
var float WScale;       // Penetration depth scale factor to take into account; weapon scale
var float Hardness;     // wall hardness, calculated in CheckWall for surface type
var float PenetrationDamage;    // Damage done by rocket penetrating wall
var float PenetrationDamageRadius;        // Damage radius for rocket penetrating wall
var float EnergyFactor;      // For calculating penetration of projectile
var float PeneExploWallOut;   // Distance out from the wall to spawn penetration explosion

var globalconfig float  PenetrationScale;   // global Penetration depth scale factor
var globalconfig float  DistortionScale;    // global Distortion scale factor
var globalconfig bool   bDebugMode;         // If true, give our detailed report in log.
var globalconfig bool   bDebugROBallistics; // If true, set bDebugBallistics to true for getting the arrow pointers

var bool bDidPenetrationExplosionFX; // Already did the penetration explosion effects
var bool bNoWorldPen;   // Rocket has hit something other than the world and should be destroyed without running world penetration check

replication
{
    reliable if (bNetDirty && Role==ROLE_Authority)
        bOutOfPropellant;
}

simulated function PostBeginPlay()
{
    if (bDebugROBallistics)
    {
        bDebugBallistics = true;
    }

    if (Level.NetMode != NM_DedicatedServer && bHasTracer)
    {
        SmokeTrail = Spawn(class'PanzerfaustTrail', self);
        SmokeTrail.SetBase(self);

        Corona = Spawn(TracerEffect,self);
    }

    Velocity = Speed * vector(Rotation);

    if (PhysicsVolume.bWaterVolume)
    {
        bHitWater = true;
        Velocity = 0.6 * Velocity;
    }

    super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
    local PlayerController PC;

    super.PostNetBeginPlay();

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

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

        if (PC == none || PC.ViewTarget == none || VSize(PC.ViewTarget.Location - Location) > 3000)
        {
            bDynamicLight = false;
            LightType = LT_None;
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
            OuttaPropLocation = Location;
            bOutOfPropellant = true;

            //cut off the rocket engine effects when outta propellant
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

simulated function Landed(vector HitNormal)
{
    Explode(Location,HitNormal);
}

function BlowUp(vector HitLocation)
{
    HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    MakeNoise(1.0);
}

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

        ST = EST_Default;

        if (HitMaterial != none)
        {
            ST = ESurfaceTypes(HitMaterial.SurfaceType);
        }

        if (SavedHitActor != none)
        {
            PlaySound(VehicleHitSound,, 5.5 * TransientSoundVolume);
            PlaySound(ExplodeSound[Rand(3)],, 2.5 * TransientSoundVolume);

            if (EffectIsRelevant(Location, false))
            {
                Spawn(ShellHitVehicleEffectClass,,,HitLocation + HitNormal*16,rotator(HitLocation));

                if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                {
                    Spawn(ExplosionDecal, self,, Location, rotator(-HitLocation));
                }
            }
        }
        else
        {
            if (EffectIsRelevant(Location, false))
            {
                if (!PhysicsVolume.bWaterVolume)
                {
                    switch(ST)
                    {
                        case EST_Snow:
                        case EST_Ice:
                            Spawn(ShellHitSnowEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                            bShowDecal = true;
                            bSnowDecal = true;
                            break;
                        case EST_Rock:
                        case EST_Gravel:
                        case EST_Concrete:
                            Spawn(ShellHitRockEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                        case EST_Wood:
                        case EST_HollowWood:
                            Spawn(ShellHitWoodEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                        case EST_Water:
                            Spawn(ShellHitWaterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = false;
                            break;
                        default:
                            Spawn(ShellHitDirtEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                    }

                    if (bShowDecal && Level.NetMode != NM_DedicatedServer)
                    {
                        if (bSnowDecal && ExplosionDecalSnow != none)
                        {
                            Spawn(ExplosionDecalSnow, self,, HitLocation, rotator(-HitNormal));
                        }
                        else if (ExplosionDecal != none)
                        {
                            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
                        }
                    }
                }
            }
        }
    }

    if (bCollided)
    {
        return;
    }

    BlowUp(HitLocation);

    // Save the hit info for when the shell is destroyed
    SavedHitLocation = HitLocation;
    SavedHitNormal = HitNormal;
    AmbientSound = none;

    bDidExplosionFX = true;

    if (Corona != none)
        Corona.Destroy();

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

        ST = EST_Default;

        if (HitMaterial != none)
        {
            ST = ESurfaceTypes(HitMaterial.SurfaceType);
        }

        if (EffectIsRelevant(Location, false))
        {
            if (!PhysicsVolume.bWaterVolume)
            {
                switch(ST)
                {
                    case EST_Snow:
                    case EST_Ice:
                        Spawn(ShellHitSnowEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                        bShowDecal = true;
                        bSnowDecal = true;
                        break;
                    case EST_Rock:
                    case EST_Gravel:
                    case EST_Concrete:
                        Spawn(ShellHitRockEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                        bShowDecal = true;
                        break;
                    case EST_Wood:
                    case EST_HollowWood:
                        Spawn(ShellHitWoodEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                        bShowDecal = true;
                        break;
                    case EST_Water:
                        Spawn(ShellHitWaterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
                        bShowDecal = false;
                        break;
                    default:
                        Spawn(ShellHitDirtEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
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
    }

    if (bCollided)
        return;

    PenetrationBlowUp(HitLocation);

    // Save the hit info for when the shell is destroyed
    SavedHitLocation = HitLocation;
    SavedHitNormal = HitNormal;
    AmbientSound=none;

    bDidPenetrationExplosionFX = true;

    if (Corona != none)
        Corona.Destroy();

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

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local bool bHitVehicleDriver;
    local vector        TempHitLocation, HitNormal;
    local array<int>    HitPoints;
    local float         TouchAngle; //dummy variable

    HitVehicleWeapon = ROVehicleWeapon(Other);
    HitVehicle = ROVehicle(Other.Base);

    TouchAngle = 1.57;

    if (Other == none || (SavedTouchActor != none && SavedTouchActor == Other) || Other.bDeleteMe || ROBulletWhipAttachment(Other) != none )
    {
        return;
    }

    SavedTouchActor = Other;

    if (Other != Instigator && (Other.Base != Instigator) && (!Other.IsA('Projectile') || Other.bProjTarget))
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

            if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateHEAT(HitLocation, Normal(Velocity), GetPenetration(LaunchLocation-HitLocation), TouchAngle, ShellImpactDamage, bIsHEATRound))
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

                // Don't save hitting this actor since we deflected
                SavedHitActor = none;

                // Don't update the position any more
                bUpdateSimulatedPosition=false;

                FailToPenetrate(HitLocation); // No deflection for HEAT, just detonate without damage

                if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
                {
                    ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
                }

                return;

            }

            // Don't update the position any more and don't move the projectile any more.
            bUpdateSimulatedPosition = false;

            SetPhysics(PHYS_None);
            SetDrawType(DT_None);

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
                        FirstHit = false;

                        DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500), 255, 0, 0);
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
                        {
                            Vehicle(Other.Base).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, HitLocation);
                        }

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
            if ((Pawn(Other) != none || RODestroyableStaticMesh(Other) != none) && Role == ROLE_Authority)
            {
                if (ROPawn(Other) != none)
                {
                    if (!Other.bDeleteMe)
                    {
                        Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * Normal(Velocity)), HitPoints, HitLocation,, 0);

                        if (Other == none)
                        {
                            return;
                        }
                        else
                        {
                            ROPawn(Other).ProcessLocationalDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);
                        }
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
            else if (Role==ROLE_Authority)
            {
                if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
                {
                    ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
                }
            }

            Explode(HitLocation, vect(0,0,1));
        }
    }
}

// Overridden to handle world and object penetration
simulated singular function HitWall(vector HitNormal, actor Wall)
{
    local float tmpMaxWall;
    local vector TmpHitLocation, TmpHitNormal, X, Y, Z, LastLoc;
    local float xH;
    local actor tmpHit;
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
        bNoWorldPen = true;
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

    if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateHEAT(Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellImpactDamage, bIsHEATRound))
    {
        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Hull Ricochet!");
        }

        if (Drawdebuglines && Firsthit)
        {
            FirstHit = false;
            DrawStayingDebugLine(Location, Location-(Normal(Velocity)*500), 0, 255, 0);
        }

        // Don't save hitting this actor since we deflected
        SavedHitActor = none;
        // Don't update the position any more
        bUpdateSimulatedPosition = false;

        Explode(Location + ExploWallOut * HitNormal, HitNormal);

        if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        {
            ROBot(Instigator.Controller).NotifyIneffectiveAttack(ROVehicle(Wall));
        }

        return;
    }

    if (SavedHitActor == Wall || Wall.bDeleteMe)
    {
        return;
    }

    // Don't update the position any more and don't move the projectile any more.
    bUpdateSimulatedPosition = false;

    SetPhysics(PHYS_None);
    SetDrawType(DT_None);

    SavedHitActor = Pawn(Wall);

    super(ROBallisticProjectile).HitWall(HitNormal, Wall);

    if (Role == ROLE_Authority)
    {
        if (bNoWorldPen)  // Using this value as we've already done this check earlier on
        {
            if (Instigator == none || Instigator.Controller == none)
            {
                Wall.SetDelayedDamageInstigatorController(InstigatorController);
            }

            if (savedhitactor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
            {
                if (Drawdebuglines && Firsthit)
                {
                    FirstHit = false;
                    DrawStayingDebugLine(Location, Location - (Normal(SavedVelocity) * 500), 255, 0, 0);
                }

                Wall.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);
            }

            if (DamageRadius > 0 && Vehicle(Wall) != none && Vehicle(Wall).Health > 0)
            {
                Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
            }

            HurtWall = Wall;
        }
        else
        {
            if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
            {
                ROBot(Instigator.Controller).NotifyIneffectiveAttack();
            }
        }

        MakeNoise(1.0);
    }

    Explode(Location + ExploWallOut * HitNormal, HitNormal);

    HurtWall = none;

    bInHitWall = true;

    GetAxes(Rotation,X,Y,Z);

    // Do the Max Wall Calculations
    CheckWall(HitNormal,X);
    xH = 1/Hardness;
    MaxWall = EnergyFactor * xH * PenetrationScale * WScale;

    // due to MaxWall getting into very high ranges we need to make shorter trace checks till we reach the full MaxWall value
    if (MaxWall > 16)
    {
        do
        {
            if ((tmpMaxWall + 16) <= MaxWall)
            {
                tmpMaxWall += 16;
            }
            else
            {
                tmpMaxWall = MaxWall;
            }

            tmpHit = Trace(TmpHitLocation, TmpHitNormal, Location, Location + X * tmpMaxWall, false);

            // due to StaticMeshs resulting in a hit even with the trace starting right inside of them (terrain and BSP 'space' would return none)
            if (tmpHit != none && !SetLocation(TmpHitLocation + (vect(0.5, 0, 0) * X)))
            {
                tmpHit = none;
            }

        } until (tmpHit != none || tmpMaxWall >= MaxWall);
    }
    else
    {
        tmpHit = Trace(TmpHitLocation, TmpHitNormal, Location, Location + X * MaxWall, false);
    }

    if (tmpHit != none)
    {
        if (SetLocation(TmpHitLocation + (vect(0.5, 0, 0) * X)))
        {
            PenetrationExplode(TmpHitLocation + PeneExploWallOut * TmpHitNormal, TmpHitNormal);

            bInHitWall = false;

            if (MaxWall < 1.0)
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

    Trace(cTmpHitLocation, cTmpHitNormal, Location, Location + X * 16, false,, HitMaterial);

    HitSurfaceType = EST_Default;

    if (HitMaterial != none)
    {
        HitSurfaceType = ESurfaceTypes(HitMaterial.SurfaceType);
    }

    switch (HitSurfaceType)
    {
        case EST_Default:
            Hardness = 0.7;
            break;
        case EST_Rock:
            Hardness = 2.5;
            break;
        case EST_Metal:
            Hardness = 4.0;
            break;
        case EST_Wood:
            Hardness = 0.5;
            break;
        case EST_Plant:
            Hardness = 0.1;
            break;
        case EST_Flesh:
            Hardness = 0.2;
            break;
        case EST_Ice:
            Hardness = 0.8;
            break;
        case EST_Snow:
            Hardness = 0.1;
            break;
        case EST_Water:
            Hardness = 0.1;
            break;
        case EST_Glass:
            Hardness = 0.3;
            break;
        case EST_Gravel:
            Hardness = 0.4;
            break;
        case EST_Concrete:
            Hardness = 2.0;
            break;
        case EST_HollowWood:
            Hardness = 0.3;
            break;
        case EST_MetalArmor:
            Hardness = 10.0;
            break;
        case EST_Paper:
            Hardness = 0.2;
            break;
        case EST_Cloth:
            Hardness = 0.3;
            break;
        case EST_Rubber:
            Hardness = 0.2;
            break;
        case EST_Poop:
            Hardness = 0.1;
            break;
        default:
            Hardness = 0.5;
            break;
    }

    if (bDebugMode)
    {
        log("Hit Surface type:"@HitSurfaceType@"with hardness of"@Hardness);
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
        ST = EST_Default;

        if (HitMaterial != none)
        {
            ST = ESurfaceTypes(HitMaterial.SurfaceType);
        }

        if (SavedHitActor != none)
        {
            PlaySound(VehicleHitSound,, 5.5 * TransientSoundVolume);
            PlaySound(ExplodeSound[Rand(3)],, 2.5 * TransientSoundVolume);

            if (EffectIsRelevant(Location, false))
            {
                Spawn(ShellHitVehicleEffectClass,,, SavedHitLocation + SavedHitNormal * 16, rotator(SavedHitNormal));

                if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                {
                    Spawn(ExplosionDecal,self,, Location, rotator(-SavedHitNormal));
                }
            }
        }
        else
        {
            if (EffectIsRelevant(Location, false))
            {
                if (!PhysicsVolume.bWaterVolume)
                {
                    switch(ST)
                    {
                        case EST_Snow:
                        case EST_Ice:
                            Spawn(ShellHitSnowEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                            bShowDecal = true;
                            bSnowDecal = true;
                            break;
                        case EST_Rock:
                        case EST_Gravel:
                        case EST_Concrete:
                            Spawn(ShellHitRockEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                        case EST_Wood:
                        case EST_HollowWood:
                            Spawn(ShellHitWoodEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                        case EST_Water:
                            Spawn(ShellHitWaterEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = false;
                            break;
                        default:
                            Spawn(ShellHitDirtEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(ExplodeSound[Rand(3)],,2.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                    }

                    if (bShowDecal && Level.NetMode != NM_DedicatedServer)
                    {
                        if (bSnowDecal && ExplosionDecalSnow != none)
                        {
                            Spawn(ExplosionDecalSnow, self,, SavedHitLocation, rotator(-SavedHitNormal));
                        }
                        else if (ExplosionDecal != none)
                        {
                            Spawn(ExplosionDecal, self,, SavedHitLocation, rotator(-SavedHitNormal));
                        }
                    }
                }
            }
        }
    }

    if (SmokeTrail != none)
    {
        SmokeTrail.HandleOwnerDestroyed();
    }

    if (Corona != none)
    {
        Corona.Destroy();
    }

    super.Destroyed();
}

defaultproperties
{
     ExplodeSound(0)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode01'
     ExplodeSound(1)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode02'
     ExplodeSound(2)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode03'
     StraightFlightTime=0.200000
     WScale=1.000000
     PenetrationDamage=250.000000
     PenetrationDamageRadius=250.000000
     EnergyFactor=1000.000000
     PeneExploWallOut=75.000000
     PenetrationScale=0.080000
     DistortionScale=0.400000
     bHasTracer=true
     TracerEffect=class'DH_Effects.DH_OrangeTankShellTracer'
     BlurTime=6.000000
     PenetrationMag=250.000000
     ShellImpactDamage=class'ROGame.RORocketImpactDamage'
     ImpactDamage=675
     VehicleHitSound=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode01'
     WaterHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water'
     ShellHitVehicleEffectClass=class'ROEffects.PanzerfaustHitTank'
     ShellHitDirtEffectClass=class'ROEffects.PanzerfaustHitDirt'
     ShellHitSnowEffectClass=class'ROEffects.PanzerfaustHitSnow'
     ShellHitWoodEffectClass=class'ROEffects.PanzerfaustHitWood'
     ShellHitRockEffectClass=class'ROEffects.PanzerfaustHitConcrete'
     ShellHitWaterEffectClass=class'ROEffects.PanzerfaustHitWater'
     BallisticCoefficient=0.050000
     Damage=300.000000
     DamageRadius=250.000000
     MomentumTransfer=10000.000000
     ExplosionDecal=class'ROEffects.RocketMarkDirt'
     ExplosionDecalSnow=class'ROEffects.RocketMarkSnow'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_StaticMesh
     CullDistance=7500.000000
     bDynamicLight=true
     bNetTemporary=false
     bUpdateSimulatedPosition=true
     LifeSpan=15.000000
     AmbientGlow=96
     FluidSurfaceShootStrengthMod=10.000000
     bFixedRotationDir=true
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
