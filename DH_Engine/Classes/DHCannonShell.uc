//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCannonShell extends DHAntiVehicleProjectile
    abstract;

struct RangePoint
{
    var() int               Range;                // the distance for this range setting
    var() float             RangeValue;           // the adjustment value for this range setting
};

var()   bool                bMechanicalAiming;    // uses the mechanical range settings for this projectile
var()   array<RangePoint>   MechanicalRanges;     // the range setting values for tank cannons that do mechanical pitch adjustments for aiming
var()   bool                bOpticalAiming;       // uses the optical range settings for this projectile
var()   array<RangePoint>   OpticalRanges;        // the range setting values for tank cannons that do optical sight adjustments for aiming

var()   class<DHMapMarker_ArtilleryHit>  HitMapMarkerClass;

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

    if (PhysicsVolume != none && PhysicsVolume.bWaterVolume)
    {
        Velocity *= 0.6;
    }

    super.PostBeginPlay();
}

// Modified so we don't spawn explosion effects at SavedHitLocation/SavedHitNormal, which were pointless variables & that system didn't - and could never - work
// Explosion effects are only triggered from here if a net client hasn't 'caught up' with the server version of the projectile & handled its own collision & explosion
// So server, after waiting arbitrary split second delay, destroys projectile, making client trigger explosion effects here as it hasn't flagged bDidExplosionFX locally
// In which case the client cannot possibly have run Explode(), which was the only place SavedHitLocation & SavedHitNormal were set
// Resulting in a catch 22 situation & the client always having null SavedHitLocation & SavedHitNormal if this functionality gets triggered
// Meaning the shell would explode at a zero vector location, i.e. the world origin, instead of where it actually is!
simulated function Destroyed()
{
    local vector HitLocation, HitNormal;

    // If shell is being destroyed without having exploded, usually it means a replicated client version of shell actor is being destroyed
    // by server just before client actor has had time to impact & explode locally - so we spawn explosion effects so the player sees them
    if (!bDidExplosionFX)
    {
        // Do a trace up to 10m forward, along shell's flight path, to get a hit location & normal for what we should be just about to hit
        // If trace fails to hit anything we fall back to using shell's current location & a 'straight up' hit normal
        if (Trace(HitLocation, HitNormal, Location + (600.0 * vector(Rotation)), Location, true) != none)
        {
            SpawnExplosionEffects(HitLocation, HitNormal);
        }
        else
        {
            SpawnExplosionEffects(Location, vect(0.0, 0.0, 1.0));
        }

        bDidExplosionFX = true;
    }

    super.Destroyed();
}

// Pitch aim adjustment for gunsights with mechanically adjusted range setting - returns the proper pitch adjustment to hit a target at a particular range
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

// Vertical position adjustment of gunsight reticle for cannons with optical range setting - returns the proper Y adjustment of reticle to hit a target at a particular range
simulated static function float GetYAdjustForRange(int Range)
{
    local int i;

    if (!default.bOpticalAiming)
    {
        return 0.0;
    }

    for (i = 0; i < default.OpticalRanges.Length; ++i)
    {
        if (default.OpticalRanges[i].Range >= Range)
        {
            return default.OpticalRanges[i].RangeValue;
        }
    }

    return 0.0;
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

        if (Role == ROLE_Authority && HitMapMarkerClass != none)
        {
            SaveHitPosition(HitLocation, HitNormal, HitMapMarkerClass);
        }

        if (bDebugBallistics)
        {
            HandleShellDebug(HitLocation); // simpler to call this here than in the tank cannon class, as we have saved TraceHitLoc in PostBeginPlay if bDebugBallistics is true
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

// New function just to consolidate long code that's repeated in more than one function
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal, optional float ActualLocationAdjustment)
{
    local sound          HitSound;
    local class<Emitter> HitEmitterClass;
    local vector         TraceHitLocation, TraceHitNormal;
    local material       HitMaterial;
    local ESurfaceTypes  SurfType;
    local bool           bShowDecal, bSnowDecal;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    // Hit a vehicle - set hit effects and play a suppression/shell shock effect for vehicle occupants
    if (ROVehicle(SavedHitActor) != none)
    {
        //VehicleShellShockEffect();
        HitSound = VehicleHitSound;
        HitEmitterClass = ShellHitVehicleEffectClass;
        PlayOwnedSound(Sound'DH_SundrySounds.shell_shock.shellshock', SLOT_None, 1.0, true, 10.0, 1.0, true);
    }
    // Hit something else - get material type & set effects
    else if (!(PhysicsVolume != none && PhysicsVolume.bWaterVolume))
    {
        Trace(TraceHitLocation, TraceHitNormal, HitLocation + (16.0 * vector(Rotation)), HitLocation, false,, HitMaterial);

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
                HitSound = DirtHitSound;
                HitEmitterClass = ShellHitSnowEffectClass;
                bShowDecal = true;
                bSnowDecal = true;
                break;

            case EST_Rock:
            case EST_Gravel:
            case EST_Concrete:
            case EST_Custom03:  //Brick
                HitSound = RockHitSound;
                HitEmitterClass = ShellHitRockEffectClass;
                bShowDecal = true;
                break;

            case EST_Wood:
            case EST_HollowWood:
                HitSound = WoodHitSound;
                HitEmitterClass = ShellHitWoodEffectClass;
                bShowDecal = true;
                break;

            case EST_Water:
                HitSound = WaterHitSound; // added as can't see why not (no duplication with CheckForSplash water effects as here we aren't in a WaterVolume)
                HitEmitterClass = ShellHitWaterEffectClass;
                break;

            case EST_Metal:
            case EST_MetalArmor:
                HitSound = VehicleDeflectSound;
                HitEmitterClass = ShellDeflectEffectClass;
                break;

            default:
                HitSound = DirtHitSound;
                HitEmitterClass = ShellHitDirtEffectClass;
                bShowDecal = true;
                break;
        }
    }

    // Play impact sound (moved effect relevance check so only affects hit effect, as impact sound should play even if effect is skipped because it's not on player's screen)
    if (HitSound != none)
    {
        PlaySound(HitSound, SLOT_Misc, 5.5 * TransientSoundVolume);
    }

    // Play random explosion sound if this shell has any
    if (ExplosionSound.Length > 0)
    {
        PlaySound(ExplosionSound[Rand(ExplosionSound.Length - 1)], SLOT_None, ExplosionSoundVolume * TransientSoundVolume);
    }

    // Play explosion effect
    // Effect relevance check is skipped altogether for an HE explosion, as it's big & not instantaneous, so player may hear sound & turn towards explosion & must be able to see it
    if (HitEmitterClass != none && (RoundType == RT_HE || EffectIsRelevant(HitLocation, false)))
    {
        Spawn(HitEmitterClass,,, HitLocation + HitNormal * 16.0, rotator(HitNormal));
    }

    // Spawn explosion decal
    if (bShowDecal)
    {
        // Adjust decal position to reverse any offset already applied to passed HitLocation to spawn explosion effects away from hit surface (e.g. PeneExploWall adjustment in HEAT shell)
        if (ActualLocationAdjustment != 0.0)
        {
            HitLocation -= ActualLocationAdjustment * HitNormal;
        }

        if (bSnowDecal && ExplosionDecalSnow != none)
        {
            Spawn(ExplosionDecalSnow, self,, HitLocation, rotator(-HitNormal));
        }
        else if (ExplosionDecal != none)
        {
            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
        }
    }

    // Do a shake effect if projectile always causes shake, or if we hit a vehicle
    if (bAlwaysDoShakeEffect || ROVehicle(SavedHitActor) != none)
    {
        DoShakeEffect();
    }
}

defaultproperties
{
    bHasTracer=true
    bHasShellTrail=true
    DrawScale=1.5
    StaticMesh=StaticMesh'WeaponPickupSM.Ammo.76mm_Shell'
    CoronaClass=class'DH_Effects.DHShellTracer_RedLarge'
    ShellTrailClass=class'DH_Effects.DHShellTrail_Red'
    ShellImpactDamage=class'DH_Engine.DHShellImpactDamageType'
    ImpactDamage=400

    Speed=22000.0
    MaxSpeed=22000.0
    Damage=140.0 //default - this really needs to be custom set per AP shell class
    DamageRadius=650.0 //default - this really needs to be custom set per AP shell class

    HullFireChance=0.25 // defaults here - customize per shell class
    EngineFireChance=0.50 // defaults here - customize per shell class

    VehicleHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_penetrate'
    DirtHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Dirt'
    RockHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Rock'
    WaterHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    WoodHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Wood'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrate'
    ShellDeflectEffectClass=class'DH_Effects.DHTankAPHitDeflect'
    ShellHitDirtEffectClass=class'ROEffects.TankAPHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankAPHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankAPHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankAPHitRockEffect'
    ShellHitWaterEffectClass=class'DH_Effects.DHShellSplashEffect'

    MomentumTransfer=10000.0
    MyDamageType=class'DH_Engine.DHShellAPExplosionDamageType'
    ExplosionDecal=class'ROEffects.TankAPMarkDirt'
    ExplosionDecalSnow=class'ROEffects.TankAPMarkSnow'
    DrawType=DT_StaticMesh

    bNetTemporary=true // false
    bUpdateSimulatedPosition=true

    LifeSpan=7.5
    AmbientGlow=96
    FluidSurfaceShootStrengthMod=10.0

    //Sound
    AmbientSound=Sound'Vehicle_Weapons.Misc.projectile_whistle01' //TODO: replace this
    AmbientVolumeScale=5.0 //5.0
    SoundVolume=255 // full volume
    SoundRadius=250.0 // about 300m - was SoundRadius=700 or about 1,1 km
    TransientSoundVolume=1.0 //Explosion Sound - full volume
    TransientSoundRadius=1000.0 //Explosion Sound - full volume
    ExplosionSoundVolume=1.0 //full volume

    bFixedRotationDir=true
    RotationRate=(Roll=50000)
    DesiredRotation=(Roll=30000)
    ForceType=FT_Constant
    ForceRadius=100.0
    ForceScale=5.0
}
