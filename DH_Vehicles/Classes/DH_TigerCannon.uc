//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_TigerCannon extends DH_ROTankCannon;

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

defaultproperties
{
    SecondarySpread=0.001250
    ManualRotationsPerSecond=0.007700
    PoweredRotationsPerSecond=0.025000
    FrontArmorFactor=17.100000
    RightArmorFactor=8.700000
    LeftArmorFactor=8.700000
    RearArmorFactor=8.700000
    FrontArmorSlope=8.000000
    FrontLeftAngle=320.000000
    FrontRightAngle=40.000000
    RearRightAngle=140.000000
    RearLeftAngle=220.000000
    ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01'
    ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_02'
    ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_04'
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
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
    ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=8
    DummyTracerClass=class'DH_Vehicles.DH_MG34VehicleClientTracer'
    mTracerInterval=0.495867
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=60.0
    VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=-3.000000,Z=12.000000))
    VehHitpoints(1)=(PointRadius=16.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=-3.000000,Z=-11.000000))
    hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=265.000000
    AltFireOffset=(X=10.000000,Y=31.000000,Z=2.000000)
    RotationsPerSecond=0.025000
    bAmbientAltFireSound=true
    FireInterval=7.000000
    AltFireInterval=0.070580
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireSoundVolume=512.000000
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AltFireSoundScaling=3.000000
    RotateSound=Sound'DH_GerVehicleSounds2.Tiger2B.tiger2B_turret_traverse_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_TigerCannonShell'
    AltFireProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
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
    CustomPitchUpLimit=3095
    CustomPitchDownLimit=64353
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=48
    InitialSecondaryAmmo=44
    InitialAltAmmo=150
    PrimaryProjectileClass=class'DH_Vehicles.DH_TigerCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_TigerCannonShellHE'
    Mesh=SkeletalMesh'axis_tiger1_anm.Tiger1_turret_ext'
    Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.Tiger1_ext'
    SoundVolume=120
    SoundRadius=300.000000
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.tiger1_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1
}
