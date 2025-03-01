//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarWeapon extends DHStationaryWeapon;

defaultproperties
{
    VehicleClass=class'DH_M2Mortar'
    AttachmentClass=class'DH_M2MortarAttachment'
    PlayerViewOffset=(Z=-2.0)
    ItemName="60mm Mortar M2"   // TODO: if we play it smart we can 
    Mesh=SkeletalMesh'DH_Mortars_1st.M2_Mortar1st'
}
