//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RedSmokeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.US_RedSmokeGrenade_throw'
    SmokeAttachmentClass=class'DH_Effects.DHSmokeEffectAttachment_Red'
    MyDamageType=class'DH_Equipment.DH_RedSmokeDamType'
}
