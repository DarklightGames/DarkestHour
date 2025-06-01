//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RDG1SmokeGrenadeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.RGD1_throw'
    SpinType=ST_Tumble
    MyDamageType=class'DH_Equipment.DH_RDG1SmokeGrenadeDamType'
}
