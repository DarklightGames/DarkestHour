//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShell extends DH_ROAntiVehicleProjectile;


var     bool    bHitWater;

struct RangePoint
{
    var() int               Range;              // Meter distance for this Range setting
    var() float             RangeValue;         // The adjustment value for this Range setting
};

var()   array<RangePoint>   MechanicalRanges;   // The Range setting values for tank cannons that do mechanical pitch adjustments for aiming
var()   array<RangePoint>   OpticalRanges;      // The Range setting values for tank cannons that do optical sight adjustments for aiming
var     bool                bMechanicalAiming;  // Uses the Mechanical Range settings for this projectile
var     bool                bOpticalAiming;     // Uses the Optical Range settings for this projectile (usually Allied sights only)


simulated function PostBeginPlay()
{

    // Set a longer lifespan for the shell if there is a possibility of a very long Range shot
    switch(Level.ViewDistanceLevel)
    {
        case VDL_Default_1000m:
            break;
        case VDL_Medium_2000m:
            Lifespan *= 1.3;
            break;
        case VDL_High_3000m:
            Lifespan *= 1.8;
            break;
        case VDL_Extreme_4000m:
            Lifespan *= 2.8;
            break;
    }

    if (Level.NetMode != NM_DedicatedServer && bHasTracer)
    {
        Corona = Spawn(TracerEffect,self);
    }

    if (PhysicsVolume.bWaterVolume)
    {
        bHitWater = true;
        Velocity=0.6*Velocity;
    }
    if (Level.bDropDetail)
    {
        bDynamicLight = false;
        LightType = LT_none;
    }

    super.PostBeginPlay();
}

// for tank cannon aiming. Returns the proper pitch adjustment to hit a target at a particular Range
simulated static function int GetPitchForRange(int Range)
{
    local int i;

    if (!default.bMechanicalAiming)
        return 0;

    for (i = 0; i < default.MechanicalRanges.Length; i++)
    {
        if (default.MechanicalRanges[i].Range >= Range)
        {
            return default.MechanicalRanges[i].RangeValue;
        }
    }

    return 0;
}
// for tank cannon aiming. Returns the proper Y adjustment of the scope to hit a target at a particular Range
simulated static function float GetYAdjustForRange(int Range)
{
    local int i;

    if (!default.bOpticalAiming)
        return 0;

    for (i = 0; i < default.OpticalRanges.Length; i++)
    {
        if (default.OpticalRanges[i].Range >= Range)
        {
            return default.OpticalRanges[i].RangeValue;
        }
    }

    return 0;
}

simulated function Destroyed()
{
    local vector TraceHitLocation, TraceHitNormal;
    local Material HitMaterial;
    local ESurfaceTypes ST;
    local bool bShowDecal, bSnowDecal;

    if (DH_ROTankCannonPawn(Instigator) != none && ROTankCannon(DH_ROTankCannonPawn(Instigator).Gun) != none)
    {
        ROTankCannon(DH_ROTankCannonPawn(Instigator).Gun).HandleShellDebug(SavedHitLocation);
    }

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

            DoShakeEffect();

            PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);
            if (EffectIsRelevant(SavedHitLocation, false))
            {
                Spawn(ShellHitVehicleEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                    Spawn(ExplosionDecal,self,,SavedHitLocation, rotator(-SavedHitNormal));
            }
        }
        else
        {
            if (EffectIsRelevant(SavedHitLocation, false))
            {
                if (!PhysicsVolume.bWaterVolume)
                {
                    switch(ST)
                    {
                        case EST_Snow:
                        case EST_Ice:
                            Spawn(ShellHitSnowEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(DirtHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = true;
                            bSnowDecal = true;
                            break;
                        case EST_Rock:
                        case EST_Gravel:
                        case EST_Concrete:
                            Spawn(ShellHitRockEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(RockHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                        case EST_Wood:
                        case EST_HollowWood:
                            Spawn(ShellHitWoodEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(WoodHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                        case EST_Water:
                            Spawn(ShellHitWaterEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            bShowDecal = false;
                            break;
                        default:
                            //log("default hit");
                            Spawn(ShellHitDirtEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(DirtHitSound,,5.5*TransientSoundVolume);
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

    if (DH_ROTankCannonPawn(Instigator) != none && ROTankCannon(DH_ROTankCannonPawn(Instigator).Gun) != none)
    {
        ROTankCannon(DH_ROTankCannonPawn(Instigator).Gun).HandleShellDebug(HitLocation);
    }

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

            DoShakeEffect();

            PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);
            if (EffectIsRelevant(Location, false))
            {
                Spawn(ShellHitVehicleEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                    Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
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
                            PlaySound(DirtHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = true;
                            bSnowDecal = true;
                            break;
                        case EST_Rock:
                        case EST_Gravel:
                        case EST_Concrete:
                            Spawn(ShellHitRockEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            PlaySound(RockHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                        case EST_Wood:
                        case EST_HollowWood:
                            Spawn(ShellHitWoodEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            PlaySound(WoodHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = true;
                            break;
                        case EST_Water:
                            Spawn(ShellHitWaterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            bShowDecal = false;
                            break;
                        default:
                            Spawn(ShellHitDirtEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                            PlaySound(DirtHitSound,,5.5*TransientSoundVolume);
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
        }
    }

    if (Corona != none)
        Corona.Destroy();

    super.Explode(HitLocation, HitNormal);
}

defaultproperties
{
    bHasTracer=true
    TracerEffect=class'DH_Effects.DH_RedTankShellTracerBig'
    ShellImpactDamage=class'DH_TankShellImpactDamage'
    ImpactDamage=400
    VehicleHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_penetrate'
    DirtHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Dirt'
    RockHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Rock'
    WaterHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    WoodHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Wood'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrate'
    ShellDeflectEffectClass=class'ROEffects.TankAPHitDeflect'
    ShellHitDirtEffectClass=class'ROEffects.TankAPHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankAPHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankAPHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankAPHitRockEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankAPHitWaterEffect'
    AmbientVolumeScale=5.000000
    SpeedFudgeScale=0.500000
    InitialAccelerationTime=0.200000
    Speed=500.000000
    MaxSpeed=22000.000000
    Damage=100.000000
    DamageRadius=5.000000
    MomentumTransfer=10000.000000
    MyDamageType=class'DH_TankShellAPExplosionDamage'
    ExplosionDecal=class'ROEffects.TankAPMarkDirt'
    ExplosionDecalSnow=class'ROEffects.TankAPMarkSnow'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Tracers.shells.Allied_shell'
    bNetTemporary=false
    bUpdateSimulatedPosition=true
    AmbientSound=Sound'Vehicle_Weapons.Misc.projectile_whistle01'
    LifeSpan=7.500000
    AmbientGlow=96
    FluidSurfaceShootStrengthMod=10.000000
    SoundVolume=255
    SoundRadius=700.000000
    TransientSoundVolume=1.000000
    TransientSoundRadius=1000.000000
    bUseCollisionStaticMesh=true
    bFixedRotationDir=true
    RotationRate=(Roll=50000)
    DesiredRotation=(Roll=30000)
    ForceType=FT_Constant
    ForceRadius=100.000000
    ForceScale=5.000000
}
