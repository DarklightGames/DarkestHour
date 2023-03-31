//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_NebelGranate39Weapon extends DHExplosiveWeapon;

defaultproperties
{
    FireModeClass(0)=class'DH_Equipment.DH_NebelGranate39Fire'
    FireModeClass(1)=class'DH_Equipment.DH_NebelGranate39TossFire'
    PickupClass=class'DH_Equipment.DH_NebelGranate39Pickup'
    AttachmentClass=class'DH_Equipment.DH_NebelGranate39Attachment'
    ItemName="Nebelhandgranate 39"
    Mesh=SkeletalMesh'Axis_Granate_1st.German-Grenade-Mesh'
    Skins(2)=Texture'Weapons1st_tex.Grenades.StielGranate_smokenade'

    InventoryGroup=4
    GroupOffset=0
    Priority=2
    DisplayFOV=80.0
}
