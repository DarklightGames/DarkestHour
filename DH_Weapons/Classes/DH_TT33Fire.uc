//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TT33Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_TT33Bullet'
    AmmoClass=class'ROAmmo.TT33Ammo'
    FireRate=0.2

    Spread=210
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=300

    FireSounds(0)=Sound'Inf_Weapons.tt33.tt33_fire01'
    FireSounds(1)=Sound'Inf_Weapons.tt33.tt33_fire02'
    FireSounds(2)=Sound'Inf_Weapons.tt33.tt33_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellHipOffset=(X=0.0,Y=3.0,Z=0.0)
    ShellRotOffsetHip=(Pitch=2500,Yaw=4000,Roll=0)
    bReverseShellSpawnDirection=true
}
