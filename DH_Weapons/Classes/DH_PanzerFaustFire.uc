//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PanzerFaustFire extends DHRocketFire;

defaultproperties
{
    ExhaustLength=32.0
    ExhaustDamage=200.0
    ExhaustDamageType=class'DH_Weapons.DH_PanzerfaustExhaustDamType'
    MuzzleBone="Warhead"
    FireSounds(0)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire03'
    maxVerticalRecoilAngle=1000
    maxHorizontalRecoilAngle=600
    FireAnim="shoothip"
    AmmoClass=class'DH_Weapons.DH_PanzerFaustAmmo'
    ProjectileClass=class'DH_Weapons.DH_PanzerFaustRocket'
    AimError=1200.0
    Spread=550.0
}
