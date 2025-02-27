//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Autoblinda41Cannon extends DHVehicleAutoCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_ext'

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_FiatL640_stc.collision.fiatl640_turret_collision',AttachBone="gun_yaw")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_FiatL640_stc.collision.fiatl640_turret_hatch_collision',AttachBone="hatch")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_FiatL640_stc.collision.fiatl640_turret_gun_collision',AttachBone="gun_pitch")

    // TODO: fix the skin ordering on interior/exterior to match (ext first, then int)
    //Skins(0)=Texture'DH_Autoblinda_tex.ab41_turret_ext'
    //Skins(1)=Texture'DH_Autoblinda_tex.ab41_turret_int'

    BeginningIdleAnim="closed"
    GunnerAttachmentBone="gun_yaw"

    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0)

    // Turret armor
    FrontArmorFactor=4.0
    RightArmorFactor=2.0
    LeftArmorFactor=2.0
    RearArmorFactor=0.6
    
    FrontArmorSlope=10.5
    RightArmorSlope=30.0
    LeftArmorSlope=30.0
    RearArmorSlope=12.2

    FrontLeftAngle=331.0
    FrontRightAngle=29.0
    RearRightAngle=151.0
    RearLeftAngle=209.0

    // Cannon movement
    ManualRotationsPerSecond=0.058  // 21 degrees per second
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=63352  // -12 degrees

    // Cannon ammo  // TODO: add correct L6/40 ammo types
    PrimaryProjectileClass=class'DH_Vehicles.DH_Breda2065CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Breda2065CannonShellHE'

    nProjectileDescriptions(0)="Granata Perforante da 20"   // AP
    nProjectileDescriptions(1)="Granata da 20"              // HE

    InitialPrimaryAmmo=8
    InitialSecondaryAmmo=8

    MaxPrimaryAmmo=8
    MaxSecondaryAmmo=8
    SecondarySpread=0.0013  // TODO: not needed

    // 35 total magazines (280 rounds) [TODO: figure out the distribution]
    NumPrimaryMags=25
    NumSecondaryMags=10

    WeaponFireAttachmentBone="MUZZLE"
    FireInterval=0.25   // 240 rounds per minute

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_Breda38Bullet'
    InitialAltAmmo=24
    NumMGMags=10
    AltFireInterval=0.109  // 550 rounds per minute
    TracerProjectileClass=class'DH_Weapons.DH_Breda38BulletTracer'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=-2.0
    
    AltFireAttachmentBone="MG_MUZZLE"
    AltFireOffset=(X=-8,Y=0,Z=0)

    // TODO: get new sounds for all these!
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire03'
    AltFireSoundClass=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoop'
    AltFireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoopEnd'

    YawBone="gun_yaw"
    PitchBone="gun_pitch"
    
    ShootAnim="shoot"
    ShootAnimBoneName="barrel"

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=16.0,RotationAxis=AXIS_Y)
    GunWheels(1)=(RotationType=ROTATION_Yaw,BoneName="YAW_GEAR_02",Scale=16.0,RotationAxis=AXIS_Y)
    GunWheels(2)=(RotationType=ROTATION_Yaw,BoneName="YAW_GEAR_03",Scale=-16.0,RotationAxis=AXIS_Y)
    GunWheels(3)=(RotationType=ROTATION_Yaw,BoneName="YAW_GEAR_01",Scale=-16.0,RotationAxis=AXIS_Y)
    GunWheels(4)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=-64.0,RotationAxis=AXIS_Y)
}
