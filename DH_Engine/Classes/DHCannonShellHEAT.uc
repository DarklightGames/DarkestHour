//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCannonShellHEAT extends DHCannonShell
    abstract;

// Penetration:
var bool  bInHitWall;
var float MaxWall;                    // maximum wall penetration
var float WScale;                     // penetration depth scale factor to take into account; weapon scale
var float Hardness;                   // wall hardness, calculated in CheckWall for surface type
var float EnergyFactor;               // for calculating penetration of projectile
var float PeneExploWallOut;           // distance out from the wall to spawn penetration explosion
var bool  bDidPenetrationExplosionFX; // already did the penetration explosion effects
var bool  bHitWorldObject;            // flags that shell has hit a world object & should run a world penetration check (reversing original bHitWorldObject, as this way seems more logical)

var globalconfig float PenetrationScale; // global penetration depth scale factor
var globalconfig float DistortionScale;  // global distortion scale factor

// Modified to handle world object penetration
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local DHVehicleCannon Cannon;
    local Actor           TraceHitActor;
    local vector          Direction, TempHitLocation, TempHitNormal;
    local float           xH, TempMaxWall;

    // Exit without doing anything if we hit something we don't want to count a hit on
    if (bInHitWall || Wall == none || SavedHitActor == Wall || (Wall.Base != none && Wall.Base == Instigator) || Wall.bDeleteMe) // HEAT adds bInHitWall check to prevent recursive calls
    {
        return;
    }

    SavedHitActor = Pawn(Wall);

    // Debug options
    if (DHVehicleCannonPawn(Instigator) != none)
    {
        Cannon = DHVehicleCannonPawn(Instigator).Cannon;

        if (Cannon != none && Cannon.bDebugRangeAutomatically)
        {
            Cannon.UpdateAutoDebugRange(Wall, Location);
            bDidExplosionFX = true;
            Destroy();

            return;
        }
    }

    if (bDebuggingText && Role == ROLE_Authority)
    {
        DebugShotDistanceAndSpeed();
    }

    // We hit an armored vehicle hull but failed to penetrate
    if (Wall.IsA('DHArmoredVehicle') && !DHArmoredVehicle(Wall).ShouldPenetrate(self, Location, Normal(Velocity), GetMaxPenetration(LaunchLocation, Location)))
    {
        FailToPenetrateArmor(Location, HitNormal, Wall);

        return;
    }

    // Check & record whether we hit a world object we can penetrate (added in HEAT)
    if ((Wall.bStatic || Wall.bWorldGeometry) && !Wall.bCanBeDamaged)
    {
        bHitWorldObject = true;
    }

    if (Role == ROLE_Authority)
    {
        if (!bHitWorldObject)
        {
            if (SavedHitActor != none || Wall.bCanBeDamaged)
            {
                if (ShouldDrawDebugLines())
                {
                    DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 255, 0, 0);
                }

                UpdateInstigator();

                if (ShellImpactDamage.default.bDelayedDamage && InstigatorController != none)
                {
                    Wall.SetDelayedDamageInstigatorController(InstigatorController);
                }

                Wall.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
            }

            if (DamageRadius > 0.0 && ROVehicle(Wall) != none && ROVehicle(Wall).Health > 0) // need this here as vehicle will be ignored by HurtRadius(), as it's the HurtWall actor
            {
                CheckVehicleOccupantsRadiusDamage(ROVehicle(Wall), Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
            }

            HurtWall = Wall;
        }
        else if (bBotNotifyIneffective && ROBot(InstigatorController) != none)
        {
            ROBot(InstigatorController).NotifyIneffectiveAttack();
        }
    }

    Explode(Location + ExploWallOut * HitNormal, HitNormal);

    // From here is all added in HEAT: // TODO: should we have a "if (bHitWorldObject) here before proceeding to wall pen calcs?

    bInHitWall = true; // set flag to prevent recursive calls

    // Do the MaxWall calculations
    Direction = vector(Rotation);
    CheckWall(HitNormal, Direction);
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

            TraceHitActor = Trace(TempHitLocation, TempHitNormal, Location, Location + (Direction * TempMaxWall), false);

            // Due to static meshes resulting in a hit even with the trace starting right inside of them (terrain and BSP 'space' would return none)
            if (TraceHitActor != none && !SetLocation(TempHitLocation + (vect(0.5, 0.0, 0.0) * Direction)))
            {
                TraceHitActor = none;
            }
        }
        until (TraceHitActor != none || TempMaxWall >= MaxWall)
    }
    else
    {
        TraceHitActor = Trace(TempHitLocation, TempHitNormal, Location, Location + (Direction * MaxWall), false);
    }

    if (TraceHitActor != none && SetLocation(TempHitLocation + (vect(0.5, 0.0, 0.0) * Direction)))
    {
        WorldPenetrationExplode(TempHitLocation + (PeneExploWallOut * TempHitNormal), TempHitNormal);

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
    // This is the same as the Super, except we don't call HandleDestruction yet
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

        super(DHAntiVehicleProjectile).Explode(HitLocation, HitNormal);
    }
}

// Sets Hardness based on the surface type hit
simulated function CheckWall(vector HitNormal, vector X)
{
    local material      HitMaterial;
    local ESurfaceTypes HitSurfaceType;
    local vector        TempHitLocation, TempHitNormal;

    Trace(TempHitLocation, TempHitNormal, Location, Location + X * 16.0, false,, HitMaterial);

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
        case EST_Custom01:
            Hardness = 0.1; //Sand
            break;
        case EST_Custom02:
            Hardness = 0.4; //SandBag
            break;
        case EST_Custom03:
            Hardness = 2.5; //Brick
            break;
        case EST_Custom04:
            Hardness = 1.0; //Hedgerow
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
    ShellImpactDamage=class'DH_Engine.DHShellHEATImpactDamageType'

    HullFireChance=0.3
    EngineFireChance=0.8
    // Hull fire chance is a bit lower than average APCR, because HEAT post-armor effect is a powerful, concentrated jet of molten metal, that goes in a single straight line.
    // This means that this powerful jet destroys anything it directly hits, but on another hand everything that does not get hit by this straight line remains (mostly) unharmed,
    // as HEAT spalling effects are even smaller than the ones from APCR (from what i know. Although to be fair, high caliber HEAT may cause more spalling just by the powerful explosion outside)
    // This is why Hull fire chance is quite low, as a HEAT shell has to hit components directly in order to damage them even more so than APCR
    // but Engine fire chance is increased, because a concentrated powerful jet of molten metal is more likely to critically damage it even than the APCR

    ExplosionSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    ExplosionSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    ExplosionSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    ExplosionSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
    WScale=1.0
    EnergyFactor=1000.0
    PeneExploWallOut=75.0
    PenetrationScale=0.08
    DistortionScale=0.4
    ShakeRotMag=(Y=0.0)
    ShakeRotRate=(Z=2500.0)
    BlurTime=6.0
    BlurEffectScalar=2.1
    VehicleDeflectSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
    ShellHitVehicleEffectClass=class'DH_Effects.DHPanzerfaustHitTank'
    ShellDeflectEffectClass=class'ROEffects.TankHEHitDeflect'
    DamageRadius=300.0
    MyDamageType=class'DH_Engine.DHShellHEATDamageType'
    ExplosionDecal=class'ROEffects.ArtilleryMarkDirt'
    ExplosionDecalSnow=class'ROEffects.ArtilleryMarkSnow'
    LifeSpan=10.0
//  SoundRadius=1000.0 // removed as affects shell's flight 'whistle' (i.e. AmbientSound), not the explosion sound radius
    ExplosionSoundVolume=1.5
}
