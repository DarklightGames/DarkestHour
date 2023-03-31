//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SdKfz2519DCannon extends DHVehicleCannon;

defaultproperties
{
    // Don't have a bone for the Pak40 attachment, so this offsets from the hull's 'body' bone to fit correctly onto the pedestal mount
    // Would be easy to add a weapon attachment bone to the hull mesh, but would then need a modified interior mesh to match
    Mesh=SkeletalMesh'DH_Stummel.stummel_ext'
    // WeaponAttachOffset=(X=-42.76,Y=0.3,Z=37.95)
    Skins(0)=Texture'DH_VehiclesGE_tex8.ext_vehicles.stummel_ext'

    bHasTurret=false
    ManualRotationsPerSecond=0.025
    bLimitYaw=true
    MaxPositiveYaw=2200
    MaxNegativeYaw=-2200
    YawStartConstraint=-2200
    YawEndConstraint=2200
    CustomPitchUpLimit=3400
    CustomPitchDownLimit=65275

    ShakeRotMag=(Z=110.0)
    ShakeRotRate=(Z=1100.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetTime=2.0

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_SdKfz2519CannonShellHEAT'
    TertiaryProjectileClass=class'DH_SdKfz2519CannonShellSmoke'

    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"
    ProjectileDescriptions(2)="SMOKE"

    nProjectileDescriptions(0)="Sprgr.Kw.K."
    nProjectileDescriptions(1)="Gr.38 Hl/C"
    nProjectileDescriptions(2)="Nbgr.Kw.K."

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=6
    InitialTertiaryAmmo=5

    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=15
    MaxTertiaryAmmo=10

    Spread=0.001
    SecondarySpread=0.001
    TertiarySpread=0.001

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

    ShootLoweredAnim="fire_close"
    ShootRaisedAnim="fire_open"

    // Cannon range settings
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
}
