//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HetzerCannon extends DHVehicleCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_turret'
    Skins(0)=Texture'DH_Hetzer_tex.hetzer_body'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.Hetzer_mantlet_collision',AttachBone="Gun")

    GunMantletArmorFactor=6.000000
    GunMantletSlope=40.000000

    PrimaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShellSmoke'

    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"
    nProjectileDescriptions(2)="Nbgr.Kw.K"

    SecondarySpread=0.001270
    TertiarySpread=0.003570
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
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

    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
    FireEffectOffset=(X=5.000000)
    YawStartConstraint=-2000.000000
    YawEndConstraint=3000.000000
    PitchBone="gun_pitch"
    WeaponFireOffset=34.200001
    CustomPitchUpLimit=1820
    CustomPitchDownLimit=64444
    MaxPositiveYaw=2000
    MaxNegativeYaw=-910
    bLimitYaw=True
    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=8
    InitialTertiaryAmmo=3
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=15
    MaxTertiaryAmmo=5
}
