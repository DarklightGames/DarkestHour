//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_TT33Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_TT33Bullet'
    AmmoClass=Class'TT33Ammo'

    Spread=210
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=300
    FireRate=0.22

    FireSounds(0)=Sound'Inf_Weapons.tt33_fire01'
    FireSounds(1)=Sound'Inf_Weapons.tt33_fire02'
    FireSounds(2)=Sound'Inf_Weapons.tt33_fire03'
    ShellEjectClass=Class'ShellEject1st762x25mm'
    ShellHipOffset=(X=0.0,Y=3.0,Z=0.0)
    ShellRotOffsetHip=(Pitch=2500,Yaw=4000,Roll=0)
    bReverseShellSpawnDirection=true
}
