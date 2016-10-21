//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ThompsonWeapon extends DHAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Thompson_1st.ukx

defaultproperties
{
    ItemName="M1A1 Thompson"
    FireModeClass(0)=class'DH_Weapons.DH_ThompsonFire'
    FireModeClass(1)=class'DH_Weapons.DH_ThompsonMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_ThompsonAttachment'
    PickupClass=class'DH_Weapons.DH_ThompsonPickup'

    Mesh=SkeletalMesh'DH_Thompson_1st.M1A1_Thompson' // TODO: there is no specularity mask for this weapon

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=30.0

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7

    bHasSelectFire=true
    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    PutDownAnim="putaway"
}
