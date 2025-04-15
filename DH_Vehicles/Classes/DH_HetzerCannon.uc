//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerCannon extends DHVehicleCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Hetzer_anm.HETZER_TURRET_EARLY_EXT'
    Skins(0)=Texture'DH_Hetzer_tex.HETZER_BODY_EXT'
    BeginningIdleAnim="idle"

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.HETZER_TURRET_COLLISION_PITCH',AttachBone="PITCH")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.HETZER_TURRET_COLLISION_HATCH_B',AttachBone="HATCH_B")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.HETZER_TURRET_COLLISION_HATCH_F',AttachBone="HATCH_F")
    GunWheels(0)=(RotationType=ROTATION_Pitch,BoneName="GUNSIGHT",Scale=-1.0,RotationAxis=AXIS_Y)

    GunMantletArmorFactor=6.000000
    GunMantletSlope=40.000000

    PrimaryProjectileClass=Class'DH_JagdpanzerIVL48CannonShell'
    SecondaryProjectileClass=Class'DH_JagdpanzerIVL48CannonShellHE'
    TertiaryProjectileClass=Class'DH_JagdpanzerIVL48CannonShellSmoke'

    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"
    nProjectileDescriptions(2)="Nbgr.Kw.K"

    SecondarySpread=0.001270
    TertiarySpread=0.003570
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.75mm_L_fire03'
    ManualRotationsPerSecond=0.025000
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
    bHasTurret=False

    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.reload_02s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_04')
    FireEffectOffset=(X=5.000000)
    YawStartConstraint=-2000.000000
    YawEndConstraint=3000.000000
    PitchBone="PITCH"
    YawBone="YAW"
    WeaponFireAttachmentBone="MUZZLE"
    WeaponFireOffset=0

    CustomPitchUpLimit=2184     // +12 degrees
    CustomPitchDownLimit=64444  // -6 degrees

    MaxPositiveYaw=2002     // +11 degrees
    MaxNegativeYaw=-910     // -5 degrees

    bLimitYaw=True
    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=8
    InitialTertiaryAmmo=3
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=15
    MaxTertiaryAmmo=5

    ShootAnim="shoot"
    ShootAnimBoneName="barrel"
}
