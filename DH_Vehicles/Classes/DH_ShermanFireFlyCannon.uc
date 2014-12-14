//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanFireFlyCannon extends DH_ROTankCannon;

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
    InitialTertiaryAmmo=25
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanFireFlyCannonShellHE'
    SecondarySpread=0.006000
    TertiarySpread=0.001560
    ManualRotationsPerSecond=0.025000
    PoweredRotationsPerSecond=0.056000
    FrontArmorFactor=7.600000
    RightArmorFactor=5.100000
    LeftArmorFactor=5.100000
    RearArmorFactor=6.400000
    RightArmorSlope=5.000000
    LeftArmorSlope=5.000000
    FrontLeftAngle=316.000000
    FrontRightAngle=44.000000
    RearRightAngle=136.000000
    RearLeftAngle=224.000000
    ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01'
    ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_02'
    ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_04'
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="APDS"
    ProjectileDescriptions(2)="HE"
    RangeSettings(1)=200
    RangeSettings(2)=400
    RangeSettings(3)=600
    RangeSettings(4)=800
    RangeSettings(5)=1000
    RangeSettings(6)=1200
    RangeSettings(7)=1400
    RangeSettings(8)=1600
    RangeSettings(9)=1800
    RangeSettings(10)=2000
    RangeSettings(11)=2400
    RangeSettings(12)=2800
    RangeSettings(13)=3200
    RangeSettings(14)=3600
    RangeSettings(15)=4000
    ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=10
    DummyTracerClass=class'DH_Vehicles.DH_30CalVehicleClientTracer'
    mTracerInterval=0.600000
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=40.0;
    VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=8.000000))
    VehHitpoints(1)=(PointRadius=16.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-14.000000))
    hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=205.000000
    AltFireOffset=(X=20.000000,Y=-17.000000,Z=-2.000000)
    RotationsPerSecond=0.056000
    bAmbientAltFireSound=true
    FireInterval=7.000000
    AltFireInterval=0.120000
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireSoundVolume=512.000000
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_loop01'
    AltFireSoundScaling=3.000000
    RotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_end01'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_ShermanFireFlyCannonShell'
    AltFireProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
    ShakeRotMag=(Z=50.000000)
    ShakeRotRate=(Z=1000.000000)
    ShakeRotTime=4.000000
    ShakeOffsetMag=(Z=1.000000)
    ShakeOffsetRate=(Z=100.000000)
    ShakeOffsetTime=10.000000
    AltShakeRotMag=(X=0.010000,Y=0.010000,Z=0.010000)
    AltShakeRotRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    AltShakeRotTime=2.000000
    AltShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
    AltShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    AltShakeOffsetTime=2.000000
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
    CustomPitchUpLimit=4551
    CustomPitchDownLimit=64625
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=48
    InitialSecondaryAmmo=4
    InitialAltAmmo=200
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanFireFlyCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanFireFlyCannonShellAPDS'
    Mesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_turret_ext'
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.FireFly_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.FireFly_armor_ext'
    Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.Sherman_turret_int'
    SoundVolume=130
    SoundRadius=200.000000
}
