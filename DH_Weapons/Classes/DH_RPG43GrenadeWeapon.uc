//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_RPG43GrenadeWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_RPG43Grenade_1st.ukx

defaultproperties
{
    ItemName="RPG43 Anti-Tank Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_RPG43GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_RPG43GrenadeFire' // no toss fire because it would be utterly useless
    AttachmentClass=class'DH_Weapons.DH_RPG43GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_RPG43GrenadePickup'
    InventoryGroup=9

    Mesh=SkeletalMesh'DH_RPG43Grenade_1st.RPG43Grenade'
    Skins(2)=texture'DH_Weapon_tex.AlliedSmallArms.RPG43Grenade' // TODO: there is no specularity mask for this weapon
}
