//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConstruction_SupplyCacheMain extends DHConstruction_SupplyCache;

static function bool ShouldShowOnMenu(DHConstruction.Context Context)
{
    return false;
}

defaultproperties
{
    BonusSupplyGenerationRate=180
    bCanBeDamaged=false
    bCanBeTornDownWhenConstructed=false
    InitialSupplyCount=8000
    StaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.USA_supply_cache_full'
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Static_Main'
}
