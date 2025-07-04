//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MG34SemiAutoFire extends DHLMGSingleFire;

defaultproperties
{
    ProjectileClass=Class'DH_MG34Bullet'
    TracerProjectileClass=Class'DH_MG34TracerBullet'
    AmmoClass=Class'MG50Rd792x57DrumAmmo'
    FireRate=0.08
    TracerFrequency=7
    Spread=75.0
    RecoilRate=0.04
    //PctHipMGPenalty=0.6

    // Recoil
    MaxVerticalRecoilAngle=250
    MaxHorizontalRecoilAngle=110

    FireSounds(0)=SoundGroup'Inf_Weapons.mg34_fire_single'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    ShellIronSightOffset=(X=25.0,Y=0.0,Z=-10.0)
    ShellRotOffsetIron=(Pitch=3000)

    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Hip_Shoot_End"
    BipodDeployFireAnim="Bipod_shoot_single"
    BipodDeployFireLoopAnim="Bipod_Shoot_Loop"
    BipodDeployFireEndAnim="Bipod_Shoot_End"
    
    FireLastAnim="hip_shoot_end"
    BipodDeployFireLastAnim="bipd_shoot_end"

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
}
