//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Nagant1895BramitWeapon extends DHRevolverWeapon;

defaultproperties
{
    ItemName="Nagant M1895 (BraMit)"
    FireModeClass(0)=class'DH_Weapons.DH_Nagant1895BramitFire'
    FireModeClass(1)=class'DH_Weapons.DH_Nagant1895BramitMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Nagant1895BramitAttachment'
    PickupClass=class'DH_Weapons.DH_Nagant1895BramitPickup'

    Mesh=SkeletalMesh'DH_Nagant1895_1st.Nagant1895Bramit'

    bUseHighDetailOverlayIndex=false
    Skins(0)=Texture'DH_Nagant1895_tex.Nagant1895.Nagant1895'
    HandNum=1
    SleeveNum=2

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0

    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10

    SwayModifyFactor=1.9    //very hard double action trigger

    PreReloadAnim="single_open"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}
