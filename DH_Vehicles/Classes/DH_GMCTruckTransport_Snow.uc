//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GMCTruckTransport_Snow extends DH_GMCTruckTransport;


static function StaticPrecache(LevelInfo L)
{
        Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_Allied_MilitarySM.American.GMC_snow');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_Allied_MilitarySM.American.GMC_snow');
    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     Skins(0)=Texture'DH_Allied_MilitarySM.American.GMC_snow'
}
