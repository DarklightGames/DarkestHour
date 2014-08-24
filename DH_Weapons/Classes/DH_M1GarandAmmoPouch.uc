//=============================================================================
// DH_M1GarandAmmoPouch
//=============================================================================

class DH_M1GarandAmmoPouch extends ROAmmoPouch;


static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'Gear_tex.pouches.ger_ammo');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.M1Garand_pouch'
}
