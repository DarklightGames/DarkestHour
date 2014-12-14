//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HetzerCannon extends DH_ROTankCannon;

// Limit the left and right movement of the driver (Matt: this is in all DH assault gun type vehicles)
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
    TertiaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShellSmoke'
    SecondarySpread=0.001270
    ManualRotationsPerSecond=0.025000
    PoweredRotationsPerSecond=0.025000
    bIsAssaultGun=true
    FrontArmorFactor=6.000000
    RightArmorFactor=2.000000
    LeftArmorFactor=2.000000
    RearArmorFactor=2.000000
    FrontArmorSlope=60.000000
    RightArmorSlope=40.000000
    LeftArmorSlope=40.000000
    RearArmorSlope=60.000000
    FrontLeftAngle=293.000000
    FrontRightAngle=67.000000
    RearRightAngle=113.000000
    RearLeftAngle=247.000000
    ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01'
    ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_02'
    ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03'
    ReloadSoundFour=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_04'
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
    MinCommanderHitHeight=15.0;
    VehHitpoints(0)=(PointRadius=8.000000,PointScale=1.000000,PointBone="com_attachment",PointOffset=(Z=24.799999))
    VehHitpoints(1)=(PointRadius=16.000000,PointScale=1.000000,PointBone="com_attachment",PointOffset=(X=-8.000000,Z=2.400000))
    hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    YawStartConstraint=-2000.000000
    YawEndConstraint=3000.000000
    PitchBone="gun_pitch"
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=160.000000
    RotationsPerSecond=0.025000
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    FireSoundVolume=512.000000
    RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShell'
    ShakeRotMag=(Z=50.000000)
    ShakeRotRate=(Z=1000.000000)
    ShakeRotTime=4.000000
    ShakeOffsetMag=(Z=1.000000)
    ShakeOffsetRate=(Z=100.000000)
    ShakeOffsetTime=10.000000
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
    CustomPitchUpLimit=1820
    CustomPitchDownLimit=64444
    MaxPositiveYaw=2000
    MaxNegativeYaw=-910
    bLimitYaw=true
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=10
    PrimaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShellHE'
    Mesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret'
    Skins(0)=Texture'DH_Hetzer_tex_V1.hetzer_body'
    SoundVolume=130
    SoundRadius=200.000000
}
