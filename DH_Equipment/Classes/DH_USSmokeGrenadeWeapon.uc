//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_USSmokeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    FireModeClass(0)=class'DH_Equipment.DH_USSmokeGrenadeFire'
    FireModeClass(1)=class'DH_Equipment.DH_USSmokeGrenadeTossFire'
    PickupClass=class'DH_Equipment.DH_USSmokeGrenadePickup'
    AttachmentClass=class'DH_Equipment.DH_USSmokeGrenadeAttachment'
    ItemName="M8 Smoke Grenade"
    Mesh=SkeletalMesh'DH_M8Grenade_1st.M8'

    HandNum=0
    SleeveNum=2

    InventoryGroup=4
    GroupOffset=2
    Priority=2
}

