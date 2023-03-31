//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Marder3MCannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    FireEffectScale=1.75 // turret fire is larger & positioned in centre of open superstructure
    FireEffectOffset=(X=-15.0,Y=15.0,Z=0.0)
    Mesh=SkeletalMesh'DH_Marder3M_anm.marder_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex7.ext_vehicles.marder_turret_ext'

    // Cannon movement
//  bHasTurret=false // not a proper turret, but has a floor that means commander moves with cannon, so this makes it work better (& no downside as there's no 'turret' collision)
    ManualRotationsPerSecond=0.033
    bLimitYaw=true
    MaxPositiveYaw=3822
    MaxNegativeYaw=-3822
    YawStartConstraint=-4000.0
    YawEndConstraint=4000.0
    CustomPitchUpLimit=2367
    CustomPitchDownLimit=64625

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_Marder3MCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Marder3MCannonShellHE'

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=6


    MaxPrimaryAmmo=20
    MaxSecondaryAmmo=7
    SecondarySpread=0.00127

    // Weapon fire
    WeaponFireOffset=0.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //~3.9 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

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
    RangeSettings(21)=2200
    RangeSettings(22)=2400
    RangeSettings(23)=2600
    RangeSettings(24)=2800
    RangeSettings(25)=3000
}
