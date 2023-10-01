//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BerettaM1934Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_BerettaM1934Bullet'
    AmmoClass=class'DH_Weapons.DH_BerettaM1934Ammo'
    FireRate=0.2

    Spread=250
    MaxVerticalRecoilAngle=300
    MaxHorizontalRecoilAngle=175

    FireSounds(0)=Sound'Inf_Weapons.tt33.tt33_fire01'
    FireSounds(1)=Sound'Inf_Weapons.tt33.tt33_fire02'
    FireSounds(2)=Sound'Inf_Weapons.tt33.tt33_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellHipOffset=(X=0.0,Y=0.0,Z=0.0)
    ShellRotOffsetHip=(Pitch=0,Yaw=0,Roll=0)
    bReverseShellSpawnDirection=true
}
