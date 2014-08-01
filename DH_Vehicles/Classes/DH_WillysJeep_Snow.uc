//===================================================================
// DH_WillysJeep
//
//  Models and textures by Peter "Foo'Bar" Schaller - 2007/2008
//  Coding and sounds by Eric "Shurek" Parris - 2008
//
// Willys Jeep MB military scout vehicle for the US Army
//===================================================================
class DH_WillysJeep_Snow extends DH_WillysJeep;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep_snow');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep_snow');

	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep_Snow'
     HighDetailOverlay=Texture'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep_Snow'
     bUseHighDetailOverlayIndex=true
}
