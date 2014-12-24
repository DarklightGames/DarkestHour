//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannonA_M4A176W extends DH_ROTankCannon;

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
        CurrentRangeIndex++;
    }
}

function DecrementRange()
{
    if (CurrentRangeIndex > 0)
    {
        CurrentRangeIndex --;
    }
}

defaultproperties
{
    InitialTertiaryAmmo=26
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellHE'
    SecondarySpread=0.001000
    TertiarySpread=0.001350
    ManualRotationsPerSecond=0.020000
    PoweredRotationsPerSecond=0.062500
    FrontArmorFactor=8.900000
    RightArmorFactor=6.400000
    LeftArmorFactor=6.400000
    RearArmorFactor=6.400000
    FrontArmorSlope=1.010000
    RightArmorSlope=1.010000
    LeftArmorSlope=1.010000
    RearArmorSlope=1.000000
    FrontLeftAngle=322.000000
    FrontRightAngle=38.000000
    RearRightAngle=142.000000
    RearLeftAngle=218.000000
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_02s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
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
    AddedPitch=52
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=6
    DummyTracerClass=class'DH_Vehicles.DH_30CalVehicleClientTracer'
    mTracerInterval=0.600000
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=54.0;
    VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-2.000000))
    VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-24.000000))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="barrelA"
    GunnerAttachmentBone="com_attachment"
    AltFireOffset=(X=-170.000000,Y=-21.000000,Z=2.000000)
    RotationsPerSecond=0.062500
    bAmbientAltFireSound=true
    FireInterval=5.000000
    AltFireInterval=0.120000
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireSoundVolume=512.000000
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_loop01'
    AltFireSoundScaling=3.000000
    RotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_end01'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShell'
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
    CustomPitchUpLimit=5461
    CustomPitchDownLimit=63715
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=43
    InitialSecondaryAmmo=2
    InitialAltAmmo=200
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellHVAP'
    Mesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman76w_turret_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext'
    SoundVolume=130
    SoundRadius=200.000000
}
