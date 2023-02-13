//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerFaustFire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PanzerFaustRocket'
    AmmoClass=class'DH_Weapons.DH_PanzerFaustAmmo'
    ExhaustDamageType=class'DH_Weapons.DH_PanzerfaustExhaustDamType'
    ExhaustLength=320.0
    MaxVerticalRecoilAngle=1000
    MaxHorizontalRecoilAngle=600
    FireSounds(0)=Sound'DH_WeaponSounds.faust.panzerfaust60_fire011'
    FireSounds(1)=Sound'DH_WeaponSounds.faust.panzerfaust60_fire021'
    FireSounds(2)=Sound'DH_WeaponSounds.faust.panzerfaust60_fire031'
    FireAnim="shoothip"
    MuzzleBone="Warhead"
    AimError=1200.0
    Spread=550.0
}
