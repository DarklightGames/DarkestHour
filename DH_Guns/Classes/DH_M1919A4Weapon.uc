//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4Weapon extends DHStationaryWeapon;

defaultproperties
{
    VehicleClass=class'DH_M1919A4Gun'
    AttachmentClass=class'DH_M1919A4Attachment'
    PickupClass=class'DH_M1919A4Pickup'    // TODO: transfer state to the pickup.
    Mesh=SkeletalMesh'DH_Mortars_1st.M2_Mortar1st'  // TODO: replace
}
