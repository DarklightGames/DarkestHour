//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_GreaseGunWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M3 Grease Gun"
    SwayModifyFactor=0.65 // -0.05
    FireModeClass(0)=class'DH_Weapons.DH_GreaseGunFire'
    FireModeClass(1)=class'DH_Weapons.DH_GreaseGunMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_GreaseGunAttachment'
    PickupClass=class'DH_Weapons.DH_GreaseGunPickup'

    Mesh=SkeletalMesh'DH_M3GreaseGun_1st.M3GreaseGun'

    DisplayFOV=80.0
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=55.0
    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9
    PutDownAnim="putaway"
    FirstSelectAnim="draw_first"
}
