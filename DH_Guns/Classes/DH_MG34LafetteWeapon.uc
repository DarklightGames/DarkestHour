//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MG34LafetteWeapon extends DHMountedWeapon;

defaultproperties
{
    ItemName="Maschinengewehr 34 (Lafette)"
    ConstructionClasses(0)=Class'DH_MG34LafetteGunConstruction'
    ConstructionClasses(1)=Class'DH_MG34LafetteGunConstruction_Low'
    AttachmentClass=Class'DH_MG34LafetteAttachment'
    PickupClass=Class'DH_MG34LafettePickup'
    Mesh=SkeletalMesh'DH_M2Mortar_anm.M2MORTAR_WEAPON'      // TODO: replace
}
