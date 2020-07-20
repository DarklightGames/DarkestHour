//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_RPG40GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="RPG40 Anti-Tank Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_RPG40GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_RPG40GrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_RPG40GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_RPG40GrenadePickup'
    Mesh=SkeletalMesh'DH_RPG40Grenade_1st.RPG40Grenade_1st'
    Skins(2)=Texture'DH_RPG40Grenade_tex.Weapon.RPG40Grenade' // TODO: there is no specularity mask for this weapon
    DisplayFOV=75.0

    GroupOffset=4
}
