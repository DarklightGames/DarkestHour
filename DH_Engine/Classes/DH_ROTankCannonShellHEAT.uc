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

    PlaySound(ExplosionSound[Rand(4)], , 2.5 * TransientSoundVolume);
}

// Sets Hardness based on the surface type hit
simulated function CheckWall(vector HitNormal, vector X)
{
    local Material      HitMaterial;
    local ESurfaceTypes HitSurfaceType;
    local vector        TempHitLocation, TempHitNormal;

    Trace(TempHitLocation, TempHitNormal, Location, Location + X * 16.0, false, , HitMaterial);

    if (HitMaterial != none)
    {
        HitSurfaceType = ESurfaceTypes(HitMaterial.SurfaceType);
    }
    else
    {
        HitSurfaceType = EST_Default;
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
