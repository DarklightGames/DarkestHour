//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShell extends DH_ROAntiVehicleProjectile;

var     sound               ExplosionSound[4];    // sound of the round exploding
var     bool                bAlwaysDoShakeEffect; // this shell will always DoShakeEffect when it explodes, not just if hit vehicle armor
//var   bool                bHitWater;            // Matt: removed as not used anywhere

struct RangePoint
{
    var() int               Range;                // meter distance for this Range setting
    var() float             RangeValue;           // the adjustment value for this Range setting
};

var()   array<RangePoint>   MechanicalRanges;     // the Range setting values for tank cannons that do mechanical pitch adjustments for aiming
var()   array<RangePoint>   OpticalRanges;        // the Range setting values for tank cannons that do optical sight adjustments for aiming
var     bool                bMechanicalAiming;    // uses the Mechanical Range settings for this projectile
var     bool                bOpticalAiming;       // uses the Optical Range settings for this projectile (usually Allied sights only)


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
        Corona = Spawn(TracerEffect, self);
    }

    if (PhysicsVolume.bWaterVolume)
    {
//      bHitWater = true; // Matt: deprecated
        Velocity = 0.6 * Velocity;
    }

    if (Level.bDropDetail)
    {
        bDynamicLight = false;
        LightType = LT_none;
    }

    super.PostBeginPlay();
}

// For tank cannon aiming - returns the proper pitch adjustment to hit a target at a particular Range
simulated static function int GetPitchForRange(int Range)
{
    local int i;

    if (!default.bMechanicalAiming)
    {
        return 0;
    }

    for (i = 0; i < default.MechanicalRanges.Length; i++)
    {
        if (default.MechanicalRanges[i].Range >= Range)
        {
            return default.MechanicalRanges[i].RangeValue;
        }
    }

    return 0;
}

// For tank cannon aiming - returns the proper Y adjustment of the scope to hit a target at a particular Range
simulated static function float GetYAdjustForRange(int Range)
{
    local int i;

    if (!default.bOpticalAiming)
    {
        return 0;
    }

    for (i = 0; i < default.OpticalRanges.Length; i++)
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

function BlowUp(vector HitLocation)
{
    HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    HurtWall = none; // reset after HurtRadius, which is the only thing that uses HurtWall

    MakeNoise(1.0);

    super.BlowUp(HitLocation);
}

// New function just to consolidate long code that's repeated in more than one function
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal, optional float ActualLocationAdjustment)
{
    local vector        TraceHitLocation, TraceHitNormal;
    local Material      HitMaterial;
    local ESurfaceTypes SurfType;
    local bool          bShowDecal, bSnowDecal;

    if (bAlwaysDoShakeEffect || SavedHitActor != none)
    {
        DoShakeEffect();
    }

    if (SavedHitActor != none)
    {
        PlaySound(VehicleHitSound, , 5.5 * TransientSoundVolume);

        if (EffectIsRelevant(HitLocation, false))
        {
            Spawn(ShellHitVehicleEffectClass, , , HitLocation + HitNormal * 16.0, rotator(HitNormal));
            bShowDecal = true;
        }
    }
    else if (!PhysicsVolume.bWaterVolume && !bDidWaterHitFX && EffectIsRelevant(HitLocation, false))
    {
        Trace(TraceHitLocation, TraceHitNormal, HitLocation + vector(Rotation) * 16.0, HitLocation, false, , HitMaterial);

        if (HitMaterial == none)
        {
            SurfType = EST_Default;
        }
        else
        {
            SurfType = ESurfaceTypes(HitMaterial.SurfaceType);
        }

        switch (SurfType)
        {
            case EST_Snow:
            case EST_Ice:
                Spawn(ShellHitSnowEffectClass, , , HitLocation + HitNormal * 16.0, rotator(HitNormal));
                PlaySound(DirtHitSound, , 5.5 * TransientSoundVolume);
                bShowDecal = true;
                bSnowDecal = true;
                break;

            case EST_Rock:
            case EST_Gravel:
            case EST_Concrete:
                Spawn(ShellHitRockEffectClass, , , HitLocation + HitNormal * 16.0, rotator(HitNormal));
                PlaySound(RockHitSound, , 5.5 * TransientSoundVolume);
                bShowDecal = true;
                break;

            case EST_Wood:
            case EST_HollowWood:
                Spawn(ShellHitWoodEffectClass, , , HitLocation + HitNormal * 16.0, rotator(HitNormal));
                PlaySound(WoodHitSound, , 5.5 * TransientSoundVolume);
                bShowDecal = true;
                break;

            case EST_Water:
                Spawn(ShellHitWaterEffectClass, , , HitLocation + HitNormal * 16.0, rotator(HitNormal));
                PlaySound(WaterHitSound, , 5.5 * TransientSoundVolume); // Matt: added as can't see why not (no duplication with CheckForSplash water effects as here we aren't in a WaterVolume)
                bShowDecal = false;
                break;

            default:
                Spawn(ShellHitDirtEffectClass, , , HitLocation + HitNormal * 16.0, rotator(HitNormal));
                PlaySound(DirtHitSound, , 5.5 * TransientSoundVolume);
                bShowDecal = true;
                break;
        }
    }

    if (bShowDecal && Level.NetMode != NM_DedicatedServer)
    {
        // Adjust decal position to reverse any offset already applied to passed HitLocation to spawn explosion effects away from hit surface (e.g. PeneExploWall adjustment in HEAT shell)
        if (ActualLocationAdjustment != 0.0)
        {
            HitLocation -= (ActualLocationAdjustment * HitNormal);
        }

        if (bSnowDecal && ExplosionDecalSnow != none)
        {
            Spawn(ExplosionDecalSnow, self, , HitLocation, rotator(-HitNormal));
        }
        else if (ExplosionDecal != none)
        {
            Spawn(ExplosionDecal, self, , HitLocation, rotator(-HitNormal));
        }
    }
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
    AmbientSound=sound'Vehicle_Weapons.Misc.projectile_whistle01'
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
