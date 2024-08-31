//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1GarandGrenadeSmokeRocket extends DHGrenadeProjectile_Smoke;

defaultproperties
{
    Damage=100
    DamageRadius=100 //less than other projectiles with similar amount of explosives, but thats because this one has no fragmentation what so ever and usually explodes on armored vehicle, thus not hitting debree on the ground
    Speed=2716.0
    MaxSpeed=2716.0
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.US_SmokeGrenade_throw'
    MyDamageType=class'DH_Weapons.DH_M1GarandGrenadeSmokeDamType'

}
