//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RDG1SmokeGrenadeProjectile extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    StaticMesh=StaticMesh'WeaponPickupSM.RGD1_throw'
    SpinType=ST_Tumble
    MyDamageType=Class'DH_RDG1SmokeGrenadeDamType'
}
