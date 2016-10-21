//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="RPG43 Anti-Tank Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_RPG43GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_RPG43GrenadeFire' // no toss fire because it would be utterly useless
    AttachmentClass=class'DH_Weapons.DH_RPG43GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_RPG43GrenadePickup'
    InventoryGroup=7

    Mesh=SkeletalMesh'DH_RPG43_1st.Sov_rpg43'
    Skins(2)=texture'DH_Weapon_tex.AlliedSmallArms.RPG43_Diff'
}
