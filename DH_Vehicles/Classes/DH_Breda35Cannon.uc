//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Breda35Cannon extends DHVehicleAutoCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Breda35_anm.BREDA35_TURRET_EXT'
    //Skins(0)=Texture'DH_Artillery_tex.Breda35.Breda35_gun'
    //CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Breda35.Breda35_turret_coll')
    GunnerAttachmentBone="GUN_YAW" // gunner doesn't move so we don't need a dedicated attachment bone

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=32.0,RotationAxis=AXIS_Z)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=32.0,RotationAxis=AXIS_Z)

    AnimationDrivers(0)=(Channel=1,BoneName="PITCH_DRIVER_ROOT",AnimationName="PITCH_DRIVER",AnimationFrameCount=69,RotationType=ROTATION_Pitch,bIsReversed=true)

    // Turret movement
    RotationsPerSecond=0.05
    PitchUpLimit=12740
    CustomPitchUpLimit=12740
    CustomPitchDownLimit=63716

    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"
    WeaponFireAttachmentBone="MUZZLE"

    // Cannon ammo
    PrimaryProjectileClass=class'DHCannonShell_MixedMag'
    // SecondaryProjectileClass=class'DH_Breda35CannonShellAP'
    // TertiaryProjectileClass=class'DH_Breda35CannonShellHE'
    SecondaryProjectileClass=class'DH_Breda2065CannonShell'
    TertiaryProjectileClass=class'DH_Breda2065CannonShellHE'

    ProjectileDescriptions(0)="Mixed"
    ProjectileDescriptions(1)="AP"
    ProjectileDescriptions(2)="HE-T"

    nProjectileDescriptions(0)="MIXEDFILLMEINLATER"
    nProjectileDescriptions(1)="Granata Perforante da 20"   // AP
    nProjectileDescriptions(2)="Granata da 20"              // HE

    NumPrimaryMags=12
    NumSecondaryMags=4
    NumTertiaryMags=4
    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=20
    InitialTertiaryAmmo=20

    // Weapon fire
    FireInterval=0.2
    WeaponFireOffset=5.0
    AddedPitch=35 // tricky one as has no range settings & AddedPitch varies widely between ranges (35/44/32/17/-5 for 500/800/1000/1200/1500m) - this global adjustment works well up to 1000m
    ShellCaseEmitterClass=class'DH_20mmShellCaseEmitter'
    ShellCaseEjectorBone="EJECTOR"

    // Animations
    BeginningIdleAnim="optic_idle"
    ShootLoweredAnim="shoot_optic"
    ShootIntermediateAnim="shoot_opensight"
    ShootRaisedAnim="shoot_lookover"

    // Penetration (no defense against any AT weaponry)
    FrontArmorFactor=0.0
    RearArmorFactor=0.0
    LeftArmorFactor=0.0
    RightArmorFactor=0.0
}
