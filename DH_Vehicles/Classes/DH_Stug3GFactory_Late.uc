//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Stug3GFactory_Late extends DH_Stug3GFactory; // late war version with remote-controlled MG & with saukopf mantlet

defaultproperties
{
    VehicleClass=class'DH_Vehicles.DH_Stug3GDestroyer_Late'
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_camo2'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3G_armor_camo2'
    Skins(2)=texture'DH_VehiclesGE_tex2.Treads.Stug3g_treads'
    Skins(3)=texture'DH_VehiclesGE_tex2.Treads.Stug3g_treads'
}
