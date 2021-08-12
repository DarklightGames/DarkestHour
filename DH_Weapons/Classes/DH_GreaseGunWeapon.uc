//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_GreaseGunWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M3 Grease Gun"
    SwayModifyFactor=0.75 // -0.05
    FireModeClass(0)=class'DH_Weapons.DH_GreaseGunFire'
    FireModeClass(1)=class'DH_Weapons.DH_GreaseGunMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_GreaseGunAttachment'
    PickupClass=class'DH_Weapons.DH_GreaseGunPickup'

    Mesh=SkeletalMesh'DH_M3GreaseGun_1st.M3GreaseGun'
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.M3GeaseGun_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=85.0
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=40.0
    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9
    PutDownAnim="putaway"
}
