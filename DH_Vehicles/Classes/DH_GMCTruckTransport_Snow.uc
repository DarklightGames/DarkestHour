//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GMCTruckTransport_Snow extends DH_GMCTruckTransport;

static function StaticPrecache(LevelInfo L)
{
        super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_Allied_MilitarySM.American.GMC_snow');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_Allied_MilitarySM.American.GMC_snow');
    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    Skins(0)=texture'DH_Allied_MilitarySM.American.GMC_snow'
}
