//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerFaustFire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=Class'DH_PanzerFaustRocket'
    AmmoClass=Class'DH_PanzerFaustAmmo'
    ExhaustDamageType=Class'DH_PanzerfaustExhaustDamType'
    ExhaustLength=320.0
    MaxVerticalRecoilAngle=1000
    MaxHorizontalRecoilAngle=600
    FireSounds(0)=Sound'DH_WeaponSounds.panzerfaust60_fire011'
    FireSounds(1)=Sound'DH_WeaponSounds.panzerfaust60_fire021'
    FireSounds(2)=Sound'DH_WeaponSounds.panzerfaust60_fire031'
    FireAnim="shoothip"
    MuzzleBone="Warhead"
    AimError=1200.0
    Spread=550.0
}
