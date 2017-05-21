//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_GreaseGunWeapon extends DHAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_M3GreaseGun_1st.ukx

defaultproperties
{
    ItemName="M3 Grease Gun"
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
    IronSightDisplayFOV=30.0
    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7
    PutDownAnim="putaway"
}
