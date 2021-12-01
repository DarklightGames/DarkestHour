//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_BazookaM9Fire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_BazookaM9Rocket'
    AmmoClass=class'DH_Weapons.DH_BazookaM9Ammo'
    //Spread=480.0
    Spread=0.0
    ExhaustDamageType=class'DH_Weapons.DH_BazookaExhaustDamType'
    ExhaustDamage=180.0
    ExhaustLength=320.0
    MuzzleBone="muzzle" //"warhead1"

    //** Effects **//
    FlashEmitterClass=class'DH_Effects.DHMuzzleFlash1stBazooka'
    SmokeEmitterClass = class'ROEffects.ROMuzzleSmoke'
}
