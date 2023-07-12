//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_6PounderGunCannon extends DH_AT57Cannon;

defaultproperties
{
    Skins(1)=Texture'DH_Artillery_Tex.6pounder.6pounder' // show 6 pdr's muzzle brake
    PrimaryProjectileClass=class'DH_Guns.DH_6PounderCannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_6PounderCannonShellAPDS'
    TertiaryProjectileClass=class'DH_Guns.DH_6PounderCannonShellHE'


    ProjectileDescriptions(1)="APDS"
    ProjectileDescriptions(2)="HE"

    nProjectileDescriptions(0)="Mk.XT APC"
    nProjectileDescriptions(1)="Mk.I APDS"
    nProjectileDescriptions(2)="Mk.X HE-T"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=3
    InitialTertiaryAmmo=8
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=5
    MaxTertiaryAmmo=15
    SecondarySpread=0.002 //become APDS instead of HE, was originally 0.006 but was found to be too much, APDS should have a half chance of hitting a frontal panther turret at 400 yards, it now does.
    TertiarySpread=0.00125
    WeaponFireOffset=19.0 // different from US 57mm AT gun due to 6 pdr's muzzle brake
    AddedPitch=50

    RangeSettings(1)=100 // 6 pdr has mechanical range adjustment on gunsight
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
