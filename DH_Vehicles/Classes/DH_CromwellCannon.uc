//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_CromwellCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_turret_ext'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_body_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int2'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Cromwell_turret_Coll'
    BeginningIdleAnim="com_idle_close"
    GunnerAttachmentBone="Com_attachment"

    // Turret armor
    FrontArmorFactor=7.6
    RightArmorFactor=6.3
    LeftArmorFactor=6.3
    RearArmorFactor=5.7
    FrontLeftAngle=318.0
    FrontRightAngle=42.0
    RearRightAngle=138.0
    RearLeftAngle=222.0

    // Turret movement
    ManualRotationsPerSecond=0.029
    PoweredRotationsPerSecond=0.0625
    YawBone="Turret"
    PitchBone="Gun"
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=64500

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_CromwellCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShellSmoke'
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(2)="Smoke"
    InitialPrimaryAmmo=33
    InitialSecondaryAmmo=26
    InitialTertiaryAmmo=5
    SecondarySpread=0.00175
    TertiarySpread=0.0036
    FireInterval=4.0

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Vehicles.DH_BesaVehicleBullet'
    InitialAltAmmo=225
    NumAltMags=6
    AltFireInterval=0.092
    bUsesTracers=true
    AltTracerProjectileClass=class'DH_Vehicles.DH_BesaVehicleTracerBullet'
    bAltFireTracersOnly=true
    AltFireTracerFrequency=5
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'

    // Weapon fire
    WeaponFireAttachmentBone="Barrel"
    AltFireOffset=(X=-109.5,Y=-11.5,Z=1.0)
    AltFireSpawnOffsetX=23.0
    FireForce="Explosion05"

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    bAmbientAltFireSound=true
    AltFireSoundClass=SoundGroup'Inf_Weapons.dt.dt_fire_loop'
    AltFireEndSound=SoundGroup'Inf_Weapons.dt.dt_fire_end'
    AltFireSoundScaling=3.0
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    ReloadSound=sound'Vehicle_reloads.Reloads.DT_ReloadHidden'
    SoundVolume=130
    SoundRadius=300.0
    FireSoundVolume=512.0

    // Cannon range settings
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
    RangeSettings(11)=2200
    RangeSettings(12)=2400
    RangeSettings(13)=2600
    RangeSettings(14)=2800
    RangeSettings(15)=3000
    RangeSettings(16)=3200

    // Screen shake
    ShakeRotMag=(Z=50.0)
    ShakeRotRate=(Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(Z=1.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=10.0
    AltShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    AltShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0

    // Miscellaneous
    FireAttachBone="Turret"
    FireEffectOffset=(X=-3.0,Y=-30.0,Z=50.0)
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
}
