//==============================================================================
// DH_Tiger2BCannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer VI Ausf. B "King Tiger" tank cannon
//==============================================================================
class DH_Tiger2BCannon extends DH_ROTankCannon;

// Special tracer handling for this type of cannon
simulated function UpdateTracer()
{
	local rotator SpawnDir;

	if (Level.NetMode == NM_DedicatedServer || !bUsesTracers)
		return;


 	if (Level.TimeSeconds > mLastTracerTime + mTracerInterval)
	{
		if (Instigator != None && Instigator.IsLocallyControlled())
		{
			SpawnDir = WeaponFireRotation;
		}
		else
		{
			SpawnDir = GetBoneRotation(WeaponFireAttachmentBone);
		}

        if (Instigator != None && !Instigator.PlayerReplicationInfo.bBot)
        {
        	SpawnDir.Pitch += AddedPitch;
        }

        Spawn(DummyTracerClass,,, WeaponFireLocation, SpawnDir);

		mLastTracerTime = Level.TimeSeconds;
	}
}

defaultproperties
{
     SecondarySpread=0.001520
     ManualRotationsPerSecond=0.005600
     PoweredRotationsPerSecond=0.040000
     FrontArmorFactor=18.000000
     RightArmorFactor=8.000000
     LeftArmorFactor=8.000000
     RearArmorFactor=8.000000
     FrontArmorSlope=10.000000
     RightArmorSlope=21.000000
     LeftArmorSlope=21.000000
     RearArmorSlope=21.000000
     FrontLeftAngle=326.000000
     FrontRightAngle=34.000000
     RearRightAngle=146.000000
     RearLeftAngle=214.000000
     ReloadSoundOne=Sound'Vehicle_reloads.Reloads.Pz_IV_F1_Reload_01'
     ReloadSoundTwo=Sound'Vehicle_reloads.Reloads.Pz_IV_F1_Reload_02'
     ReloadSoundThree=Sound'Vehicle_reloads.Reloads.Pz_IV_F1_Reload_03'
     ReloadSoundFour=Sound'Vehicle_reloads.Reloads.Pz_IV_F1_Reload_04'
     CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_01'
     CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_02'
     CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_03'
     ProjectileDescriptions(0)="APCBC"
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
     RangeSettings(21)=2200
     RangeSettings(22)=2400
     RangeSettings(23)=2600
     RangeSettings(24)=2800
     RangeSettings(25)=3000
     RangeSettings(26)=3200
     RangeSettings(27)=3400
     RangeSettings(28)=3600
     RangeSettings(29)=3800
     RangeSettings(30)=4000
     AddedPitch=15
     ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
     NumAltMags=10
     DummyTracerClass=Class'DH_Vehicles.DH_MG34VehicleClientTracer'
     mTracerInterval=0.495867
     bUsesTracers=True
     bAltFireTracersOnly=True
     VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=12.000000))
     VehHitpoints(1)=(PointRadius=16.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-11.000000))
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="Turret"
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Barrel"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=10.000000
     AltFireOffset=(X=-315.000000,Y=19.500000,Z=4.500000)
     RotationsPerSecond=0.040000
     bAmbientAltFireSound=True
     FireInterval=9.000000
     AltFireInterval=0.070580
     EffectEmitterClass=Class'ROEffects.TankCannonFireEffect'
     AmbientEffectEmitterClass=Class'ROVehicles.TankMGEmitter'
     bAmbientEmitterAltFireOnly=True
     FireSoundVolume=512.000000
     AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
     AltFireSoundScaling=3.000000
     RotateSound=Sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
     AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
     FireForce="Explosion05"
     ProjectileClass=Class'DH_Vehicles.DH_Tiger2BCannonShell'
     AltFireProjectileClass=Class'DH_Vehicles.DH_MG34VehicleBullet'
     ShakeRotMag=(Z=50.000000)
     ShakeRotRate=(Z=1000.000000)
     ShakeRotTime=4.000000
     ShakeOffsetMag=(Z=1.000000)
     ShakeOffsetRate=(Z=100.000000)
     ShakeOffsetTime=10.000000
     AltShakeRotMag=(X=1.000000,Y=1.000000,Z=1.000000)
     AltShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     AltShakeRotTime=2.000000
     AltShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
     AltShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     AltShakeOffsetTime=2.000000
     AIInfo(0)=(bLeadTarget=True,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=True,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=2731
     CustomPitchDownLimit=64189
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=45
     InitialSecondaryAmmo=35
     InitialAltAmmo=150
     PrimaryProjectileClass=Class'DH_Vehicles.DH_Tiger2BCannonShell'
     SecondaryProjectileClass=Class'DH_Vehicles.DH_Tiger2BCannonShellHE'
     Mesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_ext'
     Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.tiger2B_body_normandy'
     Skins(1)=Texture'DH_VehiclesGE_tex2.int_vehicles.tiger2B_turret_int'
     SoundVolume=130
     SoundRadius=300.000000
     HighDetailOverlayIndex=1
}
