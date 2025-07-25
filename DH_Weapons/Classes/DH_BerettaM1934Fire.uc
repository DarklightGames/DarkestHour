//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BerettaM1934Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_BerettaM1934Bullet'
    AmmoClass=Class'DH_BerettaM1934Ammo'
    FireRate=0.2

    Spread=250
    MaxVerticalRecoilAngle=300
    MaxHorizontalRecoilAngle=175

    FireSounds(0)=Sound'DH_BerettaM1934_sounds.beretta_m1934_fire_sg_01'
    FireSounds(1)=Sound'DH_BerettaM1934_sounds.beretta_m1934_fire_sg_02'
    FireSounds(2)=Sound'DH_BerettaM1934_sounds.beretta_m1934_fire_sg_03'
    ShellEjectClass=Class'ShellEject1st9x19mm'
    ShellHipOffset=(X=0.0,Y=0.0,Z=0.0)
    ShellRotOffsetHip=(Pitch=0,Yaw=0,Roll=0)
    bReverseShellSpawnDirection=true
}
