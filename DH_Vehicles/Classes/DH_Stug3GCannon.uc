//==============================================================================
// DH_Stug3GCannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Sturmgeschutze III Ausf.G tank destroyer cannon
//==============================================================================
class DH_Stug3GCannon extends DH_ROTankCannon;


// Limit the left and right movement of the driver
simulated function int LimitYaw(int yaw)
{
    local int NewYaw;
	local ROVehicleWeaponPawn PwningPawn;

    PwningPawn = ROVehicleWeaponPawn(Owner);

    if ( !bLimitYaw )
    {
        return yaw;
    }

    NewYaw = yaw;

    if( PwningPawn != none )
    {
	   	if( yaw > PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewPositiveYawLimit)
	   	{
	   		NewYaw = PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewPositiveYawLimit;
	   	}
	   	else if( yaw < PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewNegativeYawLimit )
	   	{
	   		NewYaw = PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewNegativeYawLimit;
	  	}
  	}
  	else
  	{
	   	if( yaw > MaxPositiveYaw )
	   	{
	   		NewYaw = MaxPositiveYaw;
	   	}
	   	else if( yaw < MaxNegativeYaw )
	   	{
	   		NewYaw = MaxNegativeYaw;
	  	}
  	}

  	return NewYaw;
}

defaultproperties
{
     InitialTertiaryAmmo=5
     TertiaryProjectileClass=Class'DH_Vehicles.DH_Stug3GCannonShellSmoke'
     SecondarySpread=0.001270
     TertiarySpread=0.003570
     ManualRotationsPerSecond=0.025000
     PoweredRotationsPerSecond=0.025000
     bIsAssaultGun=True
     FrontArmorFactor=5.000000
     RightArmorFactor=3.000000
     LeftArmorFactor=3.000000
     RearArmorFactor=5.000000
     FrontLeftAngle=293.000000
     FrontRightAngle=67.000000
     RearRightAngle=113.000000
     RearLeftAngle=247.000000
     ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
     ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
     ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
     ReloadSoundFour=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
     CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
     CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
     CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
     ProjectileDescriptions(0)="APCBC"
     ProjectileDescriptions(2)="Smoke"
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
     ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
     NumAltMags=4
     DummyTracerClass=Class'DH_Vehicles.DH_MG34VehicleClientTracer'
     mTracerInterval=0.495867
     bUsesTracers=True
     bAltFireTracersOnly=True
     VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=-1.000000,Z=12.000000))
     VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=-1.000000,Z=-10.000000))
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="Turret"
     YawStartConstraint=-3000.000000
     YawEndConstraint=3000.000000
     PitchBone="Turret"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Barrel"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=30.000000
     AltFireOffset=(X=-145.000000,Y=-10.000000,Z=15.000000)
     RotationsPerSecond=0.025000
     bAmbientAltFireSound=True
     FireInterval=4.000000
     AltFireInterval=0.070000
     EffectEmitterClass=Class'ROEffects.TankCannonFireEffect'
     AmbientEffectEmitterClass=Class'ROVehicles.TankMGEmitter'
     bAmbientEmitterAltFireOnly=True
     FireSoundVolume=512.000000
     AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
     AltFireSoundScaling=3.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
     FireForce="Explosion05"
     ProjectileClass=Class'DH_Vehicles.DH_Stug3GCannonShell'
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
     CustomPitchUpLimit=3641
     CustomPitchDownLimit=64444
     MaxPositiveYaw=1820
     MaxNegativeYaw=-1820
     bLimitYaw=True
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=27
     InitialSecondaryAmmo=23
     InitialAltAmmo=150
     PrimaryProjectileClass=Class'DH_Vehicles.DH_Stug3GCannonShell'
     SecondaryProjectileClass=Class'DH_Vehicles.DH_Stug3GCannonShellHE'
     Mesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_ext'
     Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_ext'
     Skins(1)=Texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_turret_int'
     SoundVolume=130
     SoundRadius=200.000000
     HighDetailOverlay=Texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_turret_int'
     bUseHighDetailOverlayIndex=True
     HighDetailOverlayIndex=1
}
