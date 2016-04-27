//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Marder3MCannon extends DHVehicleCannon;

defaultproperties
{
    SecondarySpread=0.00127
    ManualRotationsPerSecond=0.033
//  bHasTurret=false // Matt: not a proper turret, but has a floor that means commander moves with cannon, so this makes it work better (& no downside as there's no 'turret' collision)
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
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
    YawStartConstraint=-4000.0
    YawEndConstraint=4000.0
    WeaponFireOffset=0.0
    ProjectileClass=class'DH_Vehicles.DH_Marder3MCannonShell'
    CustomPitchUpLimit=2367
    CustomPitchDownLimit=64625
    MaxPositiveYaw=3822
    MaxNegativeYaw=-3822
    bLimitYaw=true
    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=7
    PrimaryProjectileClass=class'DH_Vehicles.DH_Marder3MCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Marder3MCannonShellHE'
    FireEffectScale=1.75 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=-15.0,Y=15.0,Z=0.0)
    Mesh=SkeletalMesh'DH_Marder3M_anm.marder_turret_ext'
    Skins(0)=texture'DH_VehiclesGE_tex7.ext_vehicles.marder_turret_ext'
}
