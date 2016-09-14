//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeWeapon extends DH_StielGranateWeapon;

defaultproperties
{
    FireModeClass(0)=class'DH_Weapons.DH_RPG43GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_RPG43GrenadeFire'  // No toss fire because it would be utterly useless.
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    PickupClass=class'DH_Weapons.DH_RPG43GrenadePickup'
    AttachmentClass=class'DH_Weapons.DH_RPG43GrenadeAttachment'
    ItemName="RPG43 Anti-Tank Grenade"
    Mesh=SkeletalMesh'DH_RPG43_1st.Sov_rpg43'
    HighDetailOverlay=none
    bUseHighDetailOverlayIndex=false
    InventoryGroup=7
    Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.RPG43_Diff'
}
