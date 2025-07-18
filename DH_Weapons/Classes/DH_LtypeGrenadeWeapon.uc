//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LTypeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="O.T.O Tipo L Anti-Tank Grenade"
    FireModeClass(0)=Class'DH_LTypeGrenadeFire'
    FireModeClass(1)=Class'DH_LTypeGrenadeFire' // no toss fire because it would be utterly useless
    AttachmentClass=Class'DH_LTypeGrenadeAttachment'
    PickupClass=Class'DH_LTypeGrenadePickup'
    Mesh=SkeletalMesh'DH_Ltype_anm.Ltype_1st'
    GroupOffset=4
    DisplayFOV=80.0
    bHasReleaseLever=true   // HACK: stops the grenade from automatically throwing after a certain amount of time.
}