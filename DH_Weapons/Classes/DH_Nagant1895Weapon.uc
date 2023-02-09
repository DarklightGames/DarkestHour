//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Nagant1895Weapon extends DHRevolverWeapon;

defaultproperties
{
    ItemName="Nagant M1895 Revolver"
    FireModeClass(0)=class'DH_Weapons.DH_Nagant1895Fire'
    FireModeClass(1)=class'DH_Weapons.DH_Nagant1895MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Nagant1895Attachment'
    PickupClass=class'DH_Weapons.DH_Nagant1895Pickup'

    Mesh=SkeletalMesh'DH_Nagant1895_1st.Nagant1895'

    bUseHighDetailOverlayIndex=false
    Skins(0)=Texture'DH_Nagant1895_tex.Nagant1895.Nagant1895'
    HandNum=1
    SleeveNum=2

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0

    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10

    SwayModifyFactor=1.8    //very hard double action trigger

    PreReloadAnim="single_open"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}
