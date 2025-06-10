//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BazookaM9Fire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=Class'DH_BazookaM9Rocket'
    AmmoClass=Class'DH_BazookaM9Ammo'
    Spread=375.0    // slightly higher than the M1A1 due to the poorer flight characteristics of the M6A3 round
    ExhaustDamageType=Class'DH_BazookaExhaustDamType'
    ExhaustDamage=180.0
    ExhaustLength=320.0
    MuzzleBone="muzzle" //"warhead1"

    //** Effects **//
    FlashEmitterClass=Class'DHMuzzleFlash1stBazooka'
    SmokeEmitterClass = Class'ROMuzzleSmoke'
}
