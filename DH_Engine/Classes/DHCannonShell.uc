//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCannonShell extends DHAntiVehicleProjectile
    abstract;

struct RangePoint
{
    var() int               Range;                // meter distance for this Range setting
    var() float             RangeValue;           // the adjustment value for this Range setting
};

var()   bool                bMechanicalAiming;    // uses the mechanical range settings for this projectile
var()   array<RangePoint>   MechanicalRanges;     // the range setting values for tank cannons that do mechanical pitch adjustments for aiming
var()   bool                bOpticalAiming;       // uses the optical range settings for this projectile
var()   array<RangePoint>   OpticalRanges;        // the range setting values for tank cannons that do optical sight adjustments for aiming

simulated function PostBeginPlay()
{
    // Set a longer lifespan for the shell if there is a possibility of a very long range shot
    switch (Level.ViewDistanceLevel)
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
        Corona = Spawn(CoronaClass, self);
    }

    if (PhysicsVolume.bWaterVolume)
    {
        Velocity *= 0.6;
    }

    if (Level.bDropDetail)
    {
        bDynamicLight = false;
        LightType = LT_None;
    }

    super.PostBeginPlay();
}

// For tank cannon aiming - returns the proper pitch adjustment to hit a target at a particular range
simulated static function int GetPitchForRange(int Range)
{
    local int i;

    if (!default.bMechanicalAiming)
    {
        return 0;
    }

    for (i = 0; i < default.MechanicalRanges.Length; ++i)
    {
        if (default.MechanicalRanges[i].Range >= Range)
        {
            return default.MechanicalRanges[i].RangeValue;
        }
    }

    return 0;
}

// For tank cannon aiming - returns the proper Y adjustment of the scope to hit a target at a particular range
simulated static function float GetYAdjustForRange(int Range)
{
    local int i;

    if (!default.bOpticalAiming)
    {
        return 0;
    }

    for (i = 0; i < default.OpticalRanges.Length; ++i)
    {
        if (default.OpticalRanges[i].Range >= Range)
        {
            return default.OpticalRanges[i].RangeValue;
        }
    }

    return 0;
}

simulated function Landed(vector HitNormal)
{
    Explode(Location, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (!bCollided)
    {
        if (!bDidExplosionFX)
        {
            SpawnExplosionEffects(HitLocation, HitNormal);
            bDidExplosionFX = true;
        }

        if (bDebugBallistics)
        {
            HandleShellDebug(HitLocation); // Matt: simpler to call this here than in the tank cannon class, as we have saved TraceHitLoc in PostBeginPlay if bDebugBallistics is true
        }

        super.Explode(HitLocation, HitNormal);
    }
}

simulated function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        HurtWall = none; // reset after HurtRadius, which is the only thing that uses HurtWall

        MakeNoise(1.0);
    }

    super.BlowUp(HitLocation);
}

simulated function Destroyed()
{
    if (!bDidExplosionFX)
    {
        SpawnExplosionEffects(SavedHitLocation, SavedHitNormal);
    }

    super.Destroyed();
}

defaultproperties
{
    bHasTracer=true
    CoronaClass=class'DH_Effects.DH_RedTankShellTracerBig'
    ShellImpactDamage=class'DH_Engine.DHShellImpactDamageType'
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
    AmbientVolumeScale=5.0
    SpeedFudgeScale=0.5
    InitialAccelerationTime=0.2
    Speed=500.0
    MaxSpeed=22000.0
    Damage=100.0
    DamageRadius=5.0
    MomentumTransfer=10000.0
    MyDamageType=class'DH_Engine.DHShellAPExplosionDamageType'
    ExplosionDecal=class'ROEffects.TankAPMarkDirt'
    ExplosionDecalSnow=class'ROEffects.TankAPMarkSnow'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Tracers.shells.Allied_shell'
    bNetTemporary=false
    bUpdateSimulatedPosition=true
    AmbientSound=sound'Vehicle_Weapons.Misc.projectile_whistle01'
    LifeSpan=7.5
    AmbientGlow=96
    FluidSurfaceShootStrengthMod=10.0
    SoundVolume=255
    SoundRadius=700.0
    TransientSoundVolume=1.0
    TransientSoundRadius=1000.0
    ExplosionSoundVolume=1.0
    bFixedRotationDir=true
    RotationRate=(Roll=50000)
    DesiredRotation=(Roll=30000)
    ForceType=FT_Constant
    ForceRadius=100.0
    ForceScale=5.0
}
