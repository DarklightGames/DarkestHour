//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1MortarCannon extends DH_Model35MortarCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.m1mortar_tube_ext'
    Skins(0)=Texture'DH_Model35Mortar_tex.m1_mortar_ext'

    // Gun Wheels
    GunWheels(2)=(RotationType=ROTATION_Pitch,BoneName="US_SIGHT_PIVOT",Scale=1.0,RotationAxis=AXIS_Y)   // Counter-rotates the sight so it stays level.

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HE-L"

    nProjectileDescriptions(0)="M34A1 HE"
    nProjectileDescriptions(1)="M56 WP"
    nProjectileDescriptions(2)="M56 HE"

    PrimaryProjectileClass=class'DH_Guns.DH_M1MortarProjectileHE'
    SecondaryProjectileClass=class'DH_Guns.DH_M1MortarProjectileWP'
    TertiaryProjectileClass=class'DH_Guns.DH_M1MortarProjectileHE_L'

    DriverAnimationChannelBone="US_CAMERA_COM"
    
    MaxTertiaryAmmo=0   // HACK: This stops the large HE shells from being resupplied. Replace this later.
}
