//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LtypeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="OTO bomba tipo L" //placeholder until we figure the actual name for this thing
    FireModeClass(0)=class'DH_Weapons.DH_LtypeGrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_LtypeGrenadeFire' // no toss fire because it would be utterly useless
    AttachmentClass=class'DH_Weapons.DH_LtypeGrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_LtypeGrenadePickup'
    Mesh=SkeletalMesh'DH_Ltype_1st.Ltype_mesh'
    //Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.RPG43Grenade' // no texture yet


    GroupOffset=4
    DisplayFOV=80.0
}