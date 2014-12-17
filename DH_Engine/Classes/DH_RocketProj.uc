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
//          OuttaPropLocation = Location; // Matt: removed as no longer being used anywhere
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
    ShakeRotMag=(Y=50.0,Z=200.0)    // (Y=0.0)
    ShakeRotRate=(Y=500.0,Z=1500.0) // (Z=2500.0)
    BlurEffectScalar=1.9 // 2.1
    VehicleDeflectSound=sound'ProjectileSounds.cannon_rounds.AP_deflect' // SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
    ShellDeflectEffectClass=none   // class'ROEffects.TankHEHitDeflect'
    MyDamageType=class'DamageType' // 'DH_HEATCannonShellDamage'
    SoundRadius=64.0 // 1000.0

    DirtHitSound=none  // SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Dirt'
    RockHitSound=none  // SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Rock'
    WoodHitSound=none  // SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Wood'
    AmbientVolumeScale=1.0 // 5.0
    SpeedFudgeScale=1.0    // 0.5
    InitialAccelerationTime=0.1 // 0.2
    Speed=0.0       // 500.0
    MaxSpeed=2000.0 // 22000.0
}
