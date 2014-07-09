//=============================================================================
// DH_M1CarbineAmmoPouch
//=============================================================================

class DH_M1CarbineAmmoPouch extends ROAmmoPouch;


static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'Gear_tex.pouches.ger_ammo');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.M1Carbine_pouch'
}
