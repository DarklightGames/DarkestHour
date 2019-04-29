//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PanzerFaustFire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PanzerFaustRocket'
    AmmoClass=class'DH_Weapons.DH_PanzerFaustAmmo'
    ExhaustDamageType=class'DH_Weapons.DH_PanzerfaustExhaustDamType'
    ExhaustLength=32.0
    MaxVerticalRecoilAngle=1000
    MaxHorizontalRecoilAngle=600
    FireSounds(0)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire03'
    FireAnim="shoothip"
    MuzzleBone="Warhead"
    AimError=1200.0
    Spread=550.0
}
