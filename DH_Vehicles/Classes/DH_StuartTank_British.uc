//==============================================================================
// DH_StuartTank_British
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British M5A1 (Stuart) light tank
//==============================================================================
class DH_StuartTank_British extends DH_StuartTank;

#exec OBJ LOAD FILE=..\textures\DH_VehiclesUK_tex.utx

static function StaticPrecache(LevelInfo L)
{
        Super.StaticPrecache(L);

        L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Brit_M5_body_ext');
        L.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_armor');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_Tex.int_vehicles.M5_body_int');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_Tex.treads.M5_treads');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Brit_M5_body_ext');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_armor');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_Tex.int_vehicles.M5_body_int');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_Tex.treads.M5_treads');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_StuartCannonPawn_British')
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
     VehiclePositionString="in a M5A1 Stuart"
     VehicleNameString="M5A1 Stuart"
     Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_extB'
     Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_body_ext'
     Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_armor'
     Skins(4)=Texture'DH_VehiclesUS_tex.int_vehicles.M5_body_int'
}
