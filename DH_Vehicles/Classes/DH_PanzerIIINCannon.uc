//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PanzerIIINCannon extends DH_PanzerIIILCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_ext'
    CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3N_turret_coll'

    // Turret armor
    FrontArmorSlope=15.0
    FrontLeftAngle=322.0
    FrontRightAngle=38.0
    RearRightAngle=142.0
    RearLeftAngle=218.0

    // Turret movement
    CustomPitchDownLimit=64080

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'
    PrimaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHEAT'
    TertiaryProjectileClass=class'DH_Engine.DHCannonShellCanister'
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"
    ProjectileDescriptions(2)="Canister"
    InitialPrimaryAmmo=40
    InitialTertiaryAmmo=14
    Spread=0.00135
    SecondarySpread=0.0039
    TertiarySpread=0.04

    // Coaxial MG ammo
    NumMGMags=5

    // Weapon fire
    WeaponFireOffset=10.0
    AltFireOffset=(X=-56.0,Y=19.0,Z=6.5)
    AltFireSpawnOffsetX=0.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire03'

    // Cannon range settings
    RangeSettings(21)=2200
    RangeSettings(22)=2400
    RangeSettings(23)=2600
    RangeSettings(24)=2800
    RangeSettings(25)=3000
}
