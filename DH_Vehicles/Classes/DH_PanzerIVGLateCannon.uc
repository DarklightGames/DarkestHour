//==============================================================================
// DH_PanzerIVGLateCannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer IV Ausf. G tank cannon
//==============================================================================
class DH_PanzerIVGLateCannon extends DH_ROTankCannon;

/*
// Special tracer handling for this type of cannon
simulated function UpdateTracer()
{
    local rotator SpawnDir;

    if (Level.NetMode == NM_DedicatedServer || !bUsesTracers)
        return;


    if (Level.TimeSeconds > mLastTracerTime + mTracerInterval)
    {
        if (Instigator != none && Instigator.IsLocallyControlled())
        {
            SpawnDir = WeaponFireRotation;
        }
        else
        {
            SpawnDir = GetBoneRotation(WeaponFireAttachmentBone);
        }

        if (Instigator != none && !Instigator.PlayerReplicationInfo.bBot)
        {
            SpawnDir.Pitch += AddedPitch;
        }

        Spawn(DummyTracerClass,,, WeaponFireLocation, SpawnDir);

        mLastTracerTime = Level.TimeSeconds;
    }
}
*/

defaultproperties
{
     InitialTertiaryAmmo=8
     TertiaryProjectileClass=Class'DH_Vehicles.DH_PanzerIVCannonShellHEAT'
     SecondarySpread=0.001270
     TertiarySpread=0.003570
     ManualRotationsPerSecond=0.020000
     PoweredRotationsPerSecond=0.040000
     bHasAddedSideArmor=true
     FrontArmorFactor=5.000000
     RightArmorFactor=3.100000
     LeftArmorFactor=3.100000
     RearArmorFactor=3.100000
     FrontArmorSlope=12.000000
     RightArmorSlope=26.000000
     LeftArmorSlope=26.000000
     RearArmorSlope=10.000000
     FrontLeftAngle=322.000000
     FrontRightAngle=38.000000
     RearRightAngle=142.000000
     RearLeftAngle=218.000000
     ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
     ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
     ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03'
     ReloadSoundFour=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
     CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
     CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
     CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
     ProjectileDescriptions(0)="APCBC"
     ProjectileDescriptions(2)="HEAT"
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
     NumAltMags=5
     DummyTracerClass=Class'DH_Vehicles.DH_MG34VehicleClientTracer'
     mTracerInterval=0.495867
     bUsesTracers=true
     bAltFireTracersOnly=true
     VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=-5.000000,Z=17.000000))
     VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=-5.000000,Z=-5.000000))
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="Turret"
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Gun"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=200.000000
     AltFireOffset=(X=10.000000,Y=19.000000,Z=2.000000)
     RotationsPerSecond=0.040000
     bAmbientAltFireSound=true
     FireInterval=5.000000
     AltFireInterval=0.070580
     EffectEmitterClass=Class'ROEffects.TankCannonFireEffect'
     AmbientEffectEmitterClass=Class'ROVehicles.TankMGEmitter'
     bAmbientEmitterAltFireOnly=true
     FireSoundVolume=512.000000
     AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
     AltFireSoundScaling=3.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'
     AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
     FireForce="Explosion05"
     ProjectileClass=Class'DH_Vehicles.DH_PanzerIVCannonShell'
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
     AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=3641
     CustomPitchDownLimit=64080
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=44
     InitialSecondaryAmmo=35
     InitialAltAmmo=150
     PrimaryProjectileClass=Class'DH_Vehicles.DH_PanzerIVCannonShell'
     SecondaryProjectileClass=Class'DH_Vehicles.DH_PanzerIVCannonShellHE'
     Mesh=SkeletalMesh'axis_panzer4H_anm.Panzer4H_turret_ext'
     Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.Panzer4F2_ext'
     Skins(1)=Texture'axis_vehicles_tex2.ext_vehicles.Panzer4H_Armor'
     Skins(2)=Texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
     SoundVolume=130
     SoundRadius=200.000000
     HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.Panzer4f2_int_s'
     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=2
}
