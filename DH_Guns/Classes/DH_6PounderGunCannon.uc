//==============================================================================
// DH_6PounderGunCannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// British 6 Pounder Mk. IV AT-Gun cannon
//==============================================================================
class DH_6PounderGunCannon extends DH_ATGunCannon;

#exec OBJ LOAD FILE=..\Sounds\DH_ArtillerySounds.uax

defaultproperties
{
     InitialTertiaryAmmo=20
     TertiaryProjectileClass=Class'DH_Guns.DH_6PounderCannonShellHE'
     SecondarySpread=0.004800
     TertiarySpread=0.001250
     ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
     ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
     ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
     CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
     CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
     CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
     ProjectileDescriptions(0)="APCBC"
     ProjectileDescriptions(1)="APDS"
     ProjectileDescriptions(2)="HE"
     RangeSettings(1)=100
     RangeSettings(2)=200
     RangeSettings(3)=300
     RangeSettings(4)=400
     RangeSettings(5)=500
     RangeSettings(6)=600
     RangeSettings(7)=700
     RangeSettings(8)=800
     RangeSettings(9)=900
     RangeSettings(10)=1000
     RangeSettings(11)=1100
     RangeSettings(12)=1200
     RangeSettings(13)=1300
     RangeSettings(14)=1400
     RangeSettings(15)=1500
     RangeSettings(16)=1600
     RangeSettings(17)=1700
     RangeSettings(18)=1800
     RangeSettings(19)=1900
     RangeSettings(20)=2000
     AddedPitch=50
     YawBone="Turret"
     YawStartConstraint=-7000.000000
     YawEndConstraint=7000.000000
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Barrel"
     GunnerAttachmentBone="com_player"
     WeaponFireOffset=20.000000
     RotationsPerSecond=0.025000
     FireInterval=3.000000
     EffectEmitterClass=Class'ROEffects.TankCannonFireEffect'
     FireSoundVolume=512.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     FireForce="Explosion05"
     ProjectileClass=Class'DH_Guns.DH_6PounderCannonShell'
     ShakeRotMag=(Z=110.000000)
     ShakeRotRate=(Z=1000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Z=5.000000)
     ShakeOffsetRate=(Z=100.000000)
     ShakeOffsetTime=2.000000
     AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=2731
     CustomPitchDownLimit=64626
     MaxPositiveYaw=6000
     MaxNegativeYaw=-6000
     bLimitYaw=true
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=66
     InitialSecondaryAmmo=10
     PrimaryProjectileClass=Class'DH_Guns.DH_6PounderCannonShell'
     SecondaryProjectileClass=Class'DH_Guns.DH_6PounderCannonShellAPDS'
     Mesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret'
     Skins(0)=Texture'DH_Artillery_Tex.57mmGun.57mmGun'
     Skins(1)=Texture'DH_Artillery_Tex.17pounder.17Pounder_ext'
     Skins(2)=Texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle_MN'
     SoundVolume=130
     SoundRadius=200.000000
}
