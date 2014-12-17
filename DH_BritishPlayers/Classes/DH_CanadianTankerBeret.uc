//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CanadianTankerBeret extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_tanker_Headgear');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'dhgear_anm.Brit_Beret'
    Skins(0)=texture'DHBritishCharactersTex.Headgear.Brit_tanker_beret'
    Skins(1)=texture'DHCanadianCharactersTex.Headgear.RoyalCanadianHussars_Badge'
}
