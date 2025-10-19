//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarWeapon extends DHMortarWeapon;

defaultproperties
{
    VehicleClass=Class'DH_M2MortarVehicle'
    AttachmentClass=Class'DH_M2MortarAttachment'
    PlayerViewOffset=(Z=-2.0)
    ItemName="60mm Mortar M2"
    Mesh=SkeletalMesh'DH_Mortars_1st.M2_Mortar1st'
    HighExplosiveMaximum=24
    HighExplosiveResupplyCount=6
    SmokeMaximum=4
    SmokeResupplyCount=1
}
