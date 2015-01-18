//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HellcatCannon extends DH_ROTankCannon;

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
    InitialTertiaryAmmo=10
    TertiaryProjectileClass=class'DH_Vehicles.DH_HellcatCannonShellHE'
    SecondarySpread=0.001000
    TertiarySpread=0.001350
    ManualRotationsPerSecond=0.033000
    PoweredRotationsPerSecond=0.067000
    FrontArmorFactor=1.900000
    RightArmorFactor=1.300000
    LeftArmorFactor=1.300000
    RearArmorFactor=1.300000
    RightArmorSlope=20.000000
    LeftArmorSlope=20.000000
    RearArmorSlope=13.000000
    FrontLeftAngle=324.000000
    FrontRightAngle=36.000000
    RearRightAngle=144.000000
    RearLeftAngle=216.000000
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
    MinCommanderHitHeight=47.0;
    VehHitpoints(0)=(PointRadius=13.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-15.000000))
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=10.000000
    FireInterval=5.000000
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    FireSoundVolume=512.000000
    RotateSound=sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_HellcatCannonShell'
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
    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=5
    PrimaryProjectileClass=class'DH_Vehicles.DH_HellcatCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_HellcatCannonShellHVAP'
    Mesh=SkeletalMesh'DH_Hellcat_anm.hellcat_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_ext'
    Skins(1)=texture'DH_VehiclesUS_tex5.int_vehicles.hellcat_turret_int'
    SoundVolume=130
    SoundRadius=300.000000
}
