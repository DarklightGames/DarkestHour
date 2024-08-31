//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BM36MortarCannon extends DH_Model35MortarCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.bm36mortar_tube_ext'
    Skins(0)=Texture'DH_Model35Mortar_tex.bm36_mortar_ext'

    // Gun Wheels
    GunWheels(2)=(RotationType=ROTATION_Pitch,BoneName="SOV_SIGHT_PIVOT",Scale=1.0,RotationAxis=AXIS_Y)   // Counter-rotates the sight so it stays level.

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"

    nProjectileDescriptions(0)="57O832 HE"
    nProjectileDescriptions(1)="57D832 Smoke"

    PrimaryProjectileClass=class'DH_Guns.DH_BM36MortarProjectileHE'
    SecondaryProjectileClass=class'DH_Guns.DH_BM36MortarProjectileSmoke'

    DriverAnimationChannelBone="RU_CAMERA_COM"

    // Have to set all of these in order to "remove" the third round from the parent class.
    TertiaryProjectileClass=None
    MaxTertiaryAmmo=0
    MainAmmoChargeExtra(2)=0
    ProjectileDescriptions(2)=""
    nProjectileDescriptions(2)=""
}
