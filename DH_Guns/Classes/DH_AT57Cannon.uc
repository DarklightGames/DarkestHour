//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_AT57Cannon extends DHATGunCannon;

#exec OBJ LOAD FILE=..\Sounds\DH_ArtillerySounds.uax

defaultproperties
{
    SecondarySpread=0.00125
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
    ProjectileDescriptions(0)="APC"
    AddedPitch=-15
    YawBone="Turret"
    YawStartConstraint=-7000.0
    YawEndConstraint=7000.0
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="com_player"
    WeaponFireOffset=20.0
    RotationsPerSecond=0.025
    FireInterval=3.0
    FireSoundVolume=512.0
    FireForce="Explosion05"
    ProjectileClass=class'DH_Guns.DH_AT57CannonShell'
    ShakeRotMag=(Z=110.0)
    ShakeRotRate=(Z=1000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    CustomPitchUpLimit=2731
    CustomPitchDownLimit=64626
    MaxPositiveYaw=6000
    MaxNegativeYaw=-6000
    bLimitYaw=true
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=60
    InitialSecondaryAmmo=25
    PrimaryProjectileClass=class'DH_Guns.DH_AT57CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_AT57CannonShellHE'
    Mesh=SkeletalMesh'DH_AT57_anm.AT57_turret'
    Skins(0)=texture'DH_Artillery_Tex.57mmGun.57mmGun'
    Skins(1)=texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle_MN'
    SoundVolume=130
    SoundRadius=200.0
}
