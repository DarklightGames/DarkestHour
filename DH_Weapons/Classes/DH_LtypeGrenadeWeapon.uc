//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LTypeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="O.T.O Tipo L Anti-Tank Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_LTypeGrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_LTypeGrenadeFire' // no toss fire because it would be utterly useless
    AttachmentClass=class'DH_Weapons.DH_LTypeGrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_LTypeGrenadePickup'
    Mesh=SkeletalMesh'DH_Ltype_anm.Ltype_1st'
    GroupOffset=4
    DisplayFOV=80.0
}