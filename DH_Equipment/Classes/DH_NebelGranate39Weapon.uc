//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_NebelGranate39Weapon extends DHExplosiveWeapon;

defaultproperties
{
    FireModeClass(0)=Class'DH_NebelGranate39Fire'
    FireModeClass(1)=Class'DH_NebelGranate39TossFire'
    PickupClass=Class'DH_NebelGranate39Pickup'
    AttachmentClass=Class'DH_NebelGranate39Attachment'
    ItemName="NB 39 Smoke Grenade"
    NativeItemName="Nebelhandgranate 39"
    Mesh=SkeletalMesh'Axis_Granate_1st.German-Grenade-Mesh'
    Skins(2)=Texture'Weapons1st_tex.Grenades.StielGranate_smokenade'

    InventoryGroup=4
    GroupOffset=0
    Priority=2
    DisplayFOV=80.0
}
