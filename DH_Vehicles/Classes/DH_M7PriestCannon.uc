//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_M7PriestCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_M7Priest_anm.priest_turret'
    Skins(0)=Texture'DH_M7Priest_tex.ext_vehicles.M7Priest'
    Skins(1)=Texture'DH_M7Priest_tex.ext_vehicles.M7Priest2'
    FireAttachBone="Turret_placement"
    FireEffectScale=2.5 // turret fire is larger & positioned in centre of open superstructure
    FireEffectOffset=(X=-55.0,Y=-15.0,Z=100.0)

    // Turret movement
    bHasTurret=false
    ManualRotationsPerSecond=0.02
    bLimitYaw=true
    MaxPositiveYaw=5461        // 30 degrees
    MaxNegativeYaw=-2730       // -15 degrees
    YawStartConstraint=-3000.0
    YawEndConstraint=6000.0
    CustomPitchUpLimit=6371    // 35 degrees
    CustomPitchDownLimit=64625 // -5 degrees

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_M7PriestCannonShellHE'
    PrimaryProjectileClass=class'DH_Vehicles.DH_M7PriestCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_M7PriestCannonShellSmoke'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHEAT'

    ProjectileDescriptions(0)="HE-1"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HEAT"

    nProjectileDescriptions(0)="M1 HE-T"
    nProjectileDescriptions(1)="M60 WP"
    nProjectileDescriptions(2)="M67 HEAT"

    InitialPrimaryAmmo=58
    InitialSecondaryAmmo=3
    InitialTertiaryAmmo=8
    MaxPrimaryAmmo=58
    MaxSecondaryAmmo=3
    MaxTertiaryAmmo=8
    Spread=0.005
    SecondarySpread=0.005
    TertiarySpread=0.005

    // Weapon fire
    WeaponFireOffset=18.0
    AddedPitch=68

    // Artillery
    bIsArtillery=true

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04')

    RangeTable(0)=(Mils=0,Range=115)
    RangeTable(1)=(Mils=25,Range=200)
    RangeTable(2)=(Mils=55,Range=300)
    RangeTable(3)=(Mils=75,Range=400)
    RangeTable(4)=(Mils=100,Range=500)
    RangeTable(5)=(Mils=125,Range=600)
    RangeTable(6)=(Mils=150,Range=700)
    RangeTable(7)=(Mils=180,Range=800)
    RangeTable(8)=(Mils=205,Range=900)
    RangeTable(9)=(Mils=230,Range=1000)
    RangeTable(10)=(Mils=255,Range=1100)
    RangeTable(11)=(Mils=285,Range=1200)
    RangeTable(12)=(Mils=315,Range=1300)
    RangeTable(13)=(Mils=345,Range=1400)
    RangeTable(14)=(Mils=380,Range=1500)
    RangeTable(15)=(Mils=415,Range=1600)
    RangeTable(16)=(Mils=455,Range=1700)
    RangeTable(17)=(Mils=500,Range=1800)
    RangeTable(18)=(Mils=555,Range=1900)
}
