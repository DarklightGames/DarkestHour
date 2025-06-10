//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M34GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="RG-34 Grenade"
    NativeItemName="OUG vz.34 Rucni Granat"
    FireModeClass(0)=Class'DH_M34GrenadeFire'
    FireModeClass(1)=Class'DH_M34GrenadeFire' // no toss fire because it would be utterly useless
    AttachmentClass=Class'DH_M34GrenadeAttachment'
    PickupClass=Class'DH_M34GrenadePickup'
    Mesh=SkeletalMesh'DH_M34Grenade_1st.M34'
    Skins(0)=Texture'DH_m34grenade_tex.m34.m34' // TODO: there is no specularity mask for this weapon
    handnum=1
    sleevenum=2
    GroupOffset=4
    DisplayFOV=80.0
}
