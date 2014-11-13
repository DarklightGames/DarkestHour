//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PantherGDecoration_CamoTwo extends DH_VehicleDecoAttachment;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_VehicleDecoGE_stc.usx

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_VehicleDecoGE_stc.Panther.schurzen04'
     CullDistance=80000.000000
     Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo2'
}
