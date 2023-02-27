//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BHPFire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_BHPBullet'
    AmmoClass=class'DH_BHPammo'

    Spread=185.0
    MaxVerticalRecoilAngle=380
    MaxHorizontalRecoilAngle=235

    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.browninghp.browninghpfire01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.browninghp.browninghpfire02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.browninghp.browninghpfire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
}
