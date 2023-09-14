//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M2MortarWeapon extends DHMortarWeapon;

defaultproperties
{
    VehicleClass=class'DH_Weapons.DH_M2MortarVehicle'
    AttachmentClass=class'DH_Weapons.DH_M2MortarAttachment'
    PlayerViewOffset=(Z=-2.0)
    ItemName="60mm Mortar M2"
    Mesh=SkeletalMesh'DH_Mortars_1st.M2_Mortar1st'
    HighExplosiveMaximum=24
    HighExplosiveResupplyCount=6
    SmokeMaximum=4
    SmokeResupplyCount=1
}
