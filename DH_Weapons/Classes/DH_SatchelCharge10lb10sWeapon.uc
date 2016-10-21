//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SatchelCharge10lb10sWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\Common_Satchel_1st.ukx

defaultproperties
{
    ItemName="10lb Satchel Charge"
    FireModeClass(0)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    AttachmentClass=class'DH_Weapons.DH_SatchelCharge10lb10sAttachment'
    PickupClass=class'DH_Weapons.DH_SatchelCharge10lb10sPickup'
    InventoryGroup=6

    Mesh=SkeletalMesh'Common_Satchel_1st.Sachel_Charge'
    Skins(2)=texture'Weapons1st_tex.Grenades.SatchelCharge'

    PlayerViewOffset=(X=10.0,Y=5.0,Z=0.0)

    FuzeLength=15.0
    PreFireHoldAnim="Weapon_Down"
}
