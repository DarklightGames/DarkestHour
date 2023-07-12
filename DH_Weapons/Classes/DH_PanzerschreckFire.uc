//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerschreckFire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PanzerschreckRocket'
    AmmoClass=class'DH_Weapons.DH_PanzerschreckAmmo'
    ExhaustDamageType=class'DH_Weapons.DH_PanzerschreckExhaustDamType'
    ExhaustDamage=210.0
    ExhaustLength=280.0
    Spread=300.0

    MuzzleBone="muzzle" //"warhead1"

    //** Effects **//
    FlashEmitterClass=class'DH_Effects.DHMuzzleFlash1stPanzerschreck'
    SmokeEmitterClass = class'ROEffects.ROMuzzleSmoke'
}
