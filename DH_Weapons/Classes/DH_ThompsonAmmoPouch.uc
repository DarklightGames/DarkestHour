//=============================================================================
// DH_ThompsonAmmoPouch
//=============================================================================

class DH_ThompsonAmmoPouch extends ROAmmoPouch;


static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'Gear_tex.pouches.ger_ammo');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.Thompson_pouch'
}
