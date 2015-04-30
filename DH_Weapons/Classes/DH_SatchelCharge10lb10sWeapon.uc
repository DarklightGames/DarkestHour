//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_SatchelCharge10lb10sWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\Common_Satchel_1st.ukx

defaultproperties
{
    ItemName="10lb Satchel Charge"
    Mesh=mesh'Common_Satchel_1st.Sachel_Charge'
    PlayerViewOffset=(X=10.0,Y=5.0,Z=0.0)
    bCanThrow=false // cannot be dropped
    FuzeLength=15.0 // was 10
    FireModeClass(0)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    PickupClass=class'DH_Weapons.DH_SatchelCharge10lb10sPickup'
    AttachmentClass=class'DH_Weapons.DH_SatchelCharge10lb10sAttachment'
    PreFireHoldAnim="Weapon_Down"
    InventoryGroup=6
    Skins(2)=texture'Weapons1st_tex.Grenades.SatchelCharge'
}
