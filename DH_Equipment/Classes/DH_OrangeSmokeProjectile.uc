//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OrangeSmokeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.Ger_OrangeSmokeGrenade_throw'
    SmokeAttachmentClass=Class'DHSmokeEffectAttachment_Orange'
    MyDamageType=Class'DH_OrangeSmokeDamType'
}
