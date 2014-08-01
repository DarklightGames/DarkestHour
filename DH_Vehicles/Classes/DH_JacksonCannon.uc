//==============================================================================
// DH_JacksonCannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M36 American tank destroyer - 90mm cannon class (late)
//==============================================================================
class DH_JacksonCannon extends DH_ROTankCannon;


// American tanks must use the actual sight markings to aim!
simulated function int GetRange()
{
	return RangeSettings[0];
}

// Disable clicking sound for range adjustment
function IncrementRange()
{
	if (CurrentRangeIndex < RangeSettings.Length - 1)
	{
		if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none)

		CurrentRangeIndex++;
	}
}

function DecrementRange()
{
	if (CurrentRangeIndex > 0)
	{
		if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none)

		CurrentRangeIndex --;
	}
}

defaultproperties
{
     InitialTertiaryAmmo=10
     TertiaryProjectileClass=Class'DH_Vehicles.DH_JacksonCannonShellHE'
     SecondarySpread=0.001100
     TertiarySpread=0.001250
     ManualRotationsPerSecond=0.010000
     PoweredRotationsPerSecond=0.062500
     FrontArmorFactor=6.900000
     RightArmorFactor=3.200000
     LeftArmorFactor=3.200000
     RearArmorFactor=8.000000
     FrontArmorSlope=45.000000
     RightArmorSlope=5.000000
     LeftArmorSlope=5.000000
     FrontLeftAngle=325.000000
     FrontRightAngle=35.000000
     RearRightAngle=145.000000
     RearLeftAngle=215.000000
     ReloadSoundOne=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01'
     ReloadSoundTwo=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02'
     ReloadSoundThree=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03'
     ReloadSoundFour=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04'
     CannonFireSound(0)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire01'
     CannonFireSound(1)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire02'
     CannonFireSound(2)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire02'
     ProjectileDescriptions(0)="APCBC"
     ProjectileDescriptions(1)="HVAP"
     ProjectileDescriptions(2)="HE"
     RangeSettings(1)=400
     RangeSettings(2)=800
     RangeSettings(3)=1200
     RangeSettings(4)=1600
     RangeSettings(5)=2000
     RangeSettings(6)=2400
     RangeSettings(7)=2800
     RangeSettings(8)=3200
     RangeSettings(9)=4200
     AddedPitch=145
     VehHitpoints(0)=(PointRadius=10.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=20.000000,Z=-10.000000))
     YawBone="Turret"
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Gun"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=240.000000
     RotationsPerSecond=0.062500
     FireInterval=6.000000
     EffectEmitterClass=Class'ROEffects.TankCannonFireEffect'
     FireSoundVolume=512.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
     FireForce="Explosion05"
     ProjectileClass=Class'DH_Vehicles.DH_JacksonCannonShell'
     ShakeRotMag=(Z=50.000000)
     ShakeRotRate=(Z=1000.000000)
     ShakeRotTime=4.000000
     ShakeOffsetMag=(Z=1.000000)
     ShakeOffsetRate=(Z=100.000000)
     ShakeOffsetTime=10.000000
     AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=3641
     CustomPitchDownLimit=63715
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=32
     InitialSecondaryAmmo=6
     PrimaryProjectileClass=Class'DH_Vehicles.DH_JacksonCannonShell'
     SecondaryProjectileClass=Class'DH_Vehicles.DH_JacksonCannonShellHVAP'
     Mesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext'
     Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.M36_turret_ext'
     Skins(1)=Texture'DH_VehiclesUS_tex3.int_vehicles.M36_turret_int'
     Skins(2)=Texture'DH_VehiclesUS_tex3.int_vehicles.M36_turret_int2'
     SoundVolume=130
     SoundRadius=300.000000
}
