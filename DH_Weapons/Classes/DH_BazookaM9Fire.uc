//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BazookaM9Fire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_BazookaM9Rocket'
    AmmoClass=class'DH_Weapons.DH_BazookaM9Ammo'
    Spread=375.0    // slightly higher than the M1A1 due to the poorer flight characteristics of the M6A3 round
    ExhaustDamageType=class'DH_Weapons.DH_BazookaExhaustDamType'
    ExhaustDamage=180.0
    ExhaustLength=320.0
    MuzzleBone="muzzle" //"warhead1"

    //** Effects **//
    FlashEmitterClass=class'DH_Effects.DHMuzzleFlash1stBazooka'
    SmokeEmitterClass = class'ROEffects.ROMuzzleSmoke'
}
