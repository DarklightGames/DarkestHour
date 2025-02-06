//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

    // TODO: this explodes like 1 or 2 seconds after being thrown, fuze length is not working

    Mesh=SkeletalMesh'Common_Satchel_1st.Sachel_Charge'
    Skins(2)=Texture'Weapons1st_tex.Grenades.SatchelCharge'

    PlayerViewOffset=(X=10.0,Y=5.0,Z=0.0)

    FuzeLengthRange=(Min=15.0,Max=15.0)
    PreFireHoldAnim="Weapon_Down"
}
