//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_MillsBombWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="Mills Bomb"
    FireModeClass(0)=class'DH_Weapons.DH_MillsBombFire'
    FireModeClass(1)=class'DH_Weapons.DH_MillsBombTossFire'
    AttachmentClass=class'DH_Weapons.DH_MillsBombAttachment'
    PickupClass=class'DH_Weapons.DH_MillsBombPickup'
    InventoryGroup=2
    Mesh=SkeletalMesh'DH_MillsBomb.MillsBomb'
    DisplayFOV=90.0
    FuzeLength=4.0
    bHasReleaseLever=true
    LeverReleaseSound=sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
}

