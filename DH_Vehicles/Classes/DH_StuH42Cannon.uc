//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_StuH42Cannon extends DH_Stug3GCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_ext'

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_StuH42CannonShellHE'
    PrimaryProjectileClass=class'DH_Vehicles.DH_StuH42CannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_StuH42CannonShellSmoke'
    TertiaryProjectileClass=class'DH_Vehicles.DH_StuH42CannonShellHEAT'
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HEAT"
    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=6
    InitialTertiaryAmmo=10
    Spread=0.0015
    SecondarySpread=0.00357
    TertiarySpread=0.00275

    // Weapon fire & sounds
    WeaponFireOffset=-53.5
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
}
