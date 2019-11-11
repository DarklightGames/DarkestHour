//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCannonShellSmokeWP extends DHCannonShellSmoke
    abstract;

var int   GasDamage;
var float   GasRadius; //
var class   <damagetype>    GasDamageClass;

// Modified to add gas damage
simulated function Explode(vector HitLocation, vector HitNormal)
{
        super.Explode(HitLocation, HitNormal);

    gotostate('ReleasingGas');
}

state ReleasingGas
{
   function ProcessTouch(actor other,vector hitlocation)
   {}
   function BlowUp(vector hitlocation)
   {}
   function Explode(vector hitlocation,vector hitnormal)
   {}
   function Timer()
   {
      HurtRadius(GasDamage,GasRadius,GasDamageClass,0,location);
      settimer(2.0,false);
   }
   //function TakeDamage(Damage, FireStarter, Location, vect(0.0, 0.0, 0.0), GasDamageClass);
   //{}

    begin:
    settimer(0.5,false);
    sleep(50.0);
    destroy();
}


defaultproperties
{
    bExplodesOnArmor=true
    bExplodesOnHittingWater=true
    bExplodesOnHittingBody=true

    //The smoke screen effect
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_Shell'

    //In all cases we want an impact to result in the WP explosion effect
    ShellHitVehicleEffectClass=class'DH_Effects.DHShellExplosion_MediumWP'
    ShellDeflectEffectClass=class'DH_Effects.DHShellExplosion_MediumWP'

    ShellHitDirtEffectClass=class'DH_Effects.DHShellExplosion_MediumWP'
    ShellHitSnowEffectClass=class'DH_Effects.DHShellExplosion_MediumWP'
    ShellHitWoodEffectClass=class'DH_Effects.DHShellExplosion_MediumWP'
    ShellHitRockEffectClass=class'DH_Effects.DHShellExplosion_MediumWP'
    ShellHitWaterEffectClass=class'DH_Effects.DHShellExplosion_MediumWP'

    //Sounds adopted from HE shell since this shell ruptures on impact too
    VehicleDeflectSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
    ExplosionSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    ExplosionSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    ExplosionSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    ExplosionSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'

    VehicleHitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    DirtHitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    RockHitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    WaterHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    WoodHitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'

    //Damage Chances - Upon penetration
    HullFireChance=0.65// defaults here - customize per shell class
    EngineFireChance=0.90 // defaults here - customize per shell class

    Damage=100.0
    DamageRadius=480.0
    MyDamageType=class'DH_Engine.DHShellSmokeWPDamageType' // new dam type that sets nearby players on fire upon "explosion"
    GasDamageClass=class'DH_Engine.DHShellSmokeWPGasDamageType'
    GasDamage=25
    GasRadius=800.0
}
