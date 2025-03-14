//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarWeapon extends DHStationaryWeapon;

defaultproperties
{
    VehicleClass=class'DH_M2Mortar'
    AttachmentClass=class'DH_M2MortarAttachment'
    PickupClass=class'DH_M2MortarPickup'    // TODO: transfer state to the pickup.
    PlayerViewOffset=(Z=-2.0)
    Mesh=SkeletalMesh'DH_Mortars_1st.M2_Mortar1st'
}
