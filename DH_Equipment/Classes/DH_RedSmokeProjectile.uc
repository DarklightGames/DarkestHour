//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RedSmokeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.US_RedSmokeGrenade_throw'
    SmokeAttachmentClass=Class'DHSmokeEffectAttachment_Red'
    MyDamageType=Class'DH_RedSmokeDamType'
}
