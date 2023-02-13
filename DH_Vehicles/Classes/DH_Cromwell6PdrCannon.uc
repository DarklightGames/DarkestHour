//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cromwell6PdrCannon extends DH_CromwellCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Cromwell_anm.cromwell6pdr_turret_ext'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Cromwell6pdr_turret_Coll')
    PrimaryProjectileClass=class'DH_Vehicles.DH_Cromwell6PdrCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Cromwell6PdrCannonShellHE'
    TertiaryProjectileClass=none


    ProjectileDescriptions(2)=""

    nProjectileDescriptions(0)="Mk.IX APC"
    nProjectileDescriptions(1)="Mk.X HE-T"
    nProjectileDescriptions(2)=""

    InitialPrimaryAmmo=28
    InitialSecondaryAmmo=16
    InitialTertiaryAmmo=0
    MaxPrimaryAmmo=36
    MaxSecondaryAmmo=25
    MaxTertiaryAmmo=0
    WeaponFireOffset=-4.4
    AddedPitch=50
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'

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
}
