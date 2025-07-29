//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BazookaFire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=Class'DH_BazookaRocket'
    AmmoClass=Class'DH_BazookaAmmo'
    Spread=350.0
    ExhaustDamageType=Class'DH_BazookaExhaustDamType'
    ExhaustDamage=180.0
    ExhaustLength=320.0
    MuzzleBone="muzzle" //"warhead1"

    //** Effects **//
    FlashEmitterClass=Class'DHMuzzleFlash1stBazooka'
    SmokeEmitterClass = Class'ROMuzzleSmoke'
}
