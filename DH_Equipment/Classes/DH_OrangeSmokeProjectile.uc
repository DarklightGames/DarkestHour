//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OrangeSmokeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Ger_OrangeSmokeGrenade_throw'
    SmokeAttachmentClass=class'DH_Effects.DHSmokeEffectAttachment_Orange'
    MyDamageType=class'DH_Equipment.DH_OrangeSmokeDamType'
}
