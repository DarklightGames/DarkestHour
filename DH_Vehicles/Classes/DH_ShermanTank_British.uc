//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanTank_British extends DH_ShermanTank;

#exec OBJ LOAD FILE=..\textures\DH_VehiclesUK_tex.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.Brit_Sherman_body_ext');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.Brit_Sherman_body_ext');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_British')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Brit_Sherman_Dest'
    VehicleNameString="Sherman Mk.II "
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_Sherman_body_ext'
}
