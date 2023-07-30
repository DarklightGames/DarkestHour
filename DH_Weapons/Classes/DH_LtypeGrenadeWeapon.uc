//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LTypeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="OTO bomba Tipo L" //placeholder until we figure the actual name for this thing
    FireModeClass(0)=class'DH_Weapons.DH_LTypeGrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_LTypeGrenadeFire' // no toss fire because it would be utterly useless
    AttachmentClass=class'DH_Weapons.DH_LTypeGrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_LTypeGrenadePickup'
    Mesh=SkeletalMesh'DH_Ltype_1st.Ltype_mesh'
    //Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.RPG43Grenade' // no texture yet


    GroupOffset=4
    DisplayFOV=80.0
}