// *************************************************************************
//
//	***   SS ski cap panzer   ***
//
// *************************************************************************

class DH_WSSHatPanzerB extends DH_Headgear;


static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.SS_HG_1');
}

defaultproperties
{
     bIsHelmet=False
     Mesh=SkeletalMesh'gear_anm.ger_NCOlate_cap'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.SS_HG_1'
}
