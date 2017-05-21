//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PIATFire extends DHRocketFire;

defaultproperties
{
    bCausesExhaustDamage=false
    FireSounds(0)=SoundGroup'DH_WeaponSounds.PIAT.PIAT_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.PIAT.PIAT_Fire01'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.PIAT.PIAT_Fire01'
    maxVerticalRecoilAngle=2500
    maxHorizontalRecoilAngle=1000
    AmmoClass=class'DH_Weapons.DH_PIATAmmo'
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0
    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetTime=4.0
    ProjectileClass=class'DH_Weapons.DH_PIATRocket'
    AimError=1200.0
    Spread=490.0
}
