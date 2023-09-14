//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SatchelCharge10lb10sWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="3KG Satchel Charge"
    FireModeClass(0)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    AttachmentClass=class'DH_Weapons.DH_SatchelCharge10lb10sAttachment'
    PickupClass=class'DH_Weapons.DH_SatchelCharge10lb10sPickup'

    InventoryGroup=7
    GroupOffset=2
    Priority=2

    Mesh=SkeletalMesh'Common_Satchel_1st.Sachel_Charge'
    Skins(2)=Texture'Weapons1st_tex.Grenades.SatchelCharge'

    PlayerViewOffset=(X=10.0,Y=5.0,Z=0.0)

    FuzeLength=15.0
    PreFireHoldAnim="Weapon_Down"
}
