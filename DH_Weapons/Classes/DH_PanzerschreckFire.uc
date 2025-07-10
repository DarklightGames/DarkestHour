//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerschreckFire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=Class'DH_PanzerschreckRocket'
    AmmoClass=Class'DH_PanzerschreckAmmo'
    ExhaustDamageType=Class'DH_PanzerschreckExhaustDamType'
    ExhaustDamage=210.0
    ExhaustLength=280.0
    Spread=300.0

    MuzzleBone="muzzle" //"warhead1"

    //** Effects **//
    FlashEmitterClass=Class'DHMuzzleFlash1stPanzerschreck'
    SmokeEmitterClass = Class'ROMuzzleSmoke'
}
