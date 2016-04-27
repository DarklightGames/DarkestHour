//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M2MortarWeapon extends DHMortarWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_1st.ukx

defaultproperties
{
    VehicleClass=class'DH_Mortars.DH_M2MortarVehicle'
    AttachmentClass=class'DH_Mortars.DH_M2MortarAttachment'
    PlayerViewOffset=(Z=-2.0)
    ItemName="60mm Mortar M2"
    Mesh=SkeletalMesh'DH_Mortars_1st.M2_Mortar1st'
    HighExplosiveMaximum=24
    HighExplosiveResupplyCount=6
    SmokeMaximum=4
    SmokeResupplyCount=1
}
