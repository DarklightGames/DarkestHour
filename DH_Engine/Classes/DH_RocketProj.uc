//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

// Matt: originally extended DH_ROAntiVehicleProjectile, but has so much in common with a HEAT shell it's simpler & cleaner to extend that
class DH_RocketProj extends DH_ROTankCannonShellHEAT
    abstract;

#exec OBJ LOAD FILE=Inf_Weapons.uax

var PanzerfaustTrail SmokeTrail;         // smoke trail emitter
var() float          StraightFlightTime; // how long the rocket has propellant and flies straight

// Modified to spawn a rocket smoke trail
simulated function PostBeginPlay()
{
    SetPhysics(PHYS_Flying);

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
    
    SetTimer(StraightFlightTime, false); // Matt: added so we can cut off the rocket engine effects when out of propellant, instead of using Tick
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

// Cut off the rocket engine effects when out of propellant (more efficient alternative to original use of Tick)
simulated function Timer()
{
    SetPhysics(PHYS_Projectile);

    if (SmokeTrail != none)
    {
        SmokeTrail.HandleOwnerDestroyed();
    }

    if (Corona != none)
    {
        Corona.Destroy();
    }
}

/*
// Fixes broken RO class to make rockets work like rockets
simulated function Tick(float DeltaTime) // Matt: removed as a timer can be used, which is more efficient (note if Tick was retained it could be much optimised, as below)
{
//  SetPhysics(PHYS_Flying); // Matt: removed as crazy to keep setting this every Tick, just to reset to PHYS_Projectile at end of every Tick once out of propellant (moved to PostBeginPlay)

//  super.Tick(DeltaTime); // Matt: in shells generally, we now empty out the Super from ROAntiVehicleProjectile

    if (!bOutOfPropellant)
    {
        if (TotalFlightTime <= StraightFlightTime)
        {
            TotalFlightTime += DeltaTime;
        }
        else
        {
            bOutOfPropellant = true;
            SetPhysics(PHYS_Projectile); // Matt: moved here as we only need to do this once

            // Cut off the rocket engine effects when out of propellant
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

//  if (bOutOfPropellant && Physics != PHYS_Projectile) // Matt: moved up, as we only need to do this once, when we run out of propellant - it's crazy to keep checking it every Tick
//  {
//      SetPhysics(PHYS_Projectile);
//  }
}
*/

simulated function BlowUp(vector HitLocation)
{
    super.BlowUp(HitLocation);

    if (SmokeTrail != none)
    {
        SmokeTrail.HandleOwnerDestroyed();
    }
}

simulated function Destroyed()
{
    super.Destroyed();

    if (SmokeTrail != none)
    {
        SmokeTrail.HandleOwnerDestroyed();
    }
}

defaultproperties
{
    bExplodesOnHittingBody=true
    bExplodesOnHittingWater=false
    ExplosionSound(0)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode03'
    StraightFlightTime=0.2
    PenetrationDamageRadius=250.0
    TracerEffect=class'DH_Effects.DH_OrangeTankShellTracer'
    PenetrationMag=250.0
    ShellImpactDamage=class'ROGame.RORocketImpactDamage'
    ImpactDamage=675
    VehicleHitSound=SoundGroup'Inf_Weapons.panzerfaust60.faust_explode01'
    ShellHitVehicleEffectClass=class'ROEffects.PanzerfaustHitTank'
    ShellHitDirtEffectClass=class'ROEffects.PanzerfaustHitDirt'
    ShellHitSnowEffectClass=class'ROEffects.PanzerfaustHitSnow'
    ShellHitWoodEffectClass=class'ROEffects.PanzerfaustHitWood'
    ShellHitRockEffectClass=class'ROEffects.PanzerfaustHitConcrete'
    ShellHitWaterEffectClass=class'ROEffects.PanzerfaustHitWater'
    BallisticCoefficient=0.05
    Damage=300.0
    DamageRadius=250.0
    ExplosionDecal=class'ROEffects.RocketMarkDirt'
    ExplosionDecalSnow=class'ROEffects.RocketMarkSnow'
    LightType=LT_Steady
    LightEffect=LE_QuadraticNonIncidence
    LightHue=28
    LightBrightness=255.0
    LightRadius=5.0
    CullDistance=7500.0
    bDynamicLight=true
    LifeSpan=15.0
    ExplosionSoundVolume=5.0 // seems high but TransientSoundVolume is only 0.3, compared to 1.0 for a shell

//  Override unwanted defaults now inherited from DH_ROTankCannonShellHEAT & DH_ROTankCannonShell:
    ShakeRotMag=(Y=50.0,Z=200.0)
    ShakeRotRate=(Y=500.0,Z=1500.0)
    BlurEffectScalar=1.9
    VehicleDeflectSound=Sound'ProjectileSounds.cannon_rounds.AP_deflect'
    ShellDeflectEffectClass=none
    MyDamageType=class'DamageType'
    AmbientSound=none
    TransientSoundVolume=0.3
    TransientSoundRadius=300.0 
    SpeedFudgeScale=1.0
    InitialAccelerationTime=0.1
    RotationRate=(Roll=0)
    DesiredRotation=(Roll=0)
}
