//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeWeapon extends DH_StielGranateWeapon;

#exec OBJ LOAD FILE=DO_RU_Weapons.ukx

defaultproperties
{
    FireModeClass(0)=class'DH_Weapons.DH_RPG43GrenadeFire'
    FireModeClass(1)=None
    SelectForce="SwitchToAssaultRifle"
    PutDownAnim="Put_away"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    PickupClass=class'DH_Weapons.DH_RPG43GrenadePickup'
    AttachmentClass=class'DH_Weapons.DH_RPG43GrenadeAttachment'
    ItemName="RPG43 Anti-Tank Grenade"
    //mesh=SkeletalMesh'DO_RU_Weapons.Sov_rpg43'
    HighDetailOverlay=None
    bUseHighDetailOverlayIndex=False
    InventoryGroup=7
}
