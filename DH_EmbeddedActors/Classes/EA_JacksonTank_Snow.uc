//==============================================================================
// DH_JacksonTank
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M36 American tank destroyer "Jackson" snow
//==============================================================================
class EA_JacksonTank_Snow extends DH_JacksonTank;

//Setup new texture package
#exec OBJ LOAD FILE=..\textures\DH_CheneuxCAVehicle_tex.utx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_EmbeddedActors.EA_JacksonCannonPawn_Snow',WeaponBone="Turret_placement")
    Skins(0)=Texture'DH_CheneuxCAVehicle_tex.ext_vehicles.M36_Bodysnow_ext'
    Skins(1)=Texture'DH_CheneuxCAVehicle_tex.ext_vehicles.M36_turretsnow_ext'
    //Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int'
    //Skins(3)=Texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int2'
    //Skins(4)=Texture'DH_VehiclesUS_tex.Treads.M10_treads'
    //Skins(5)=Texture'DH_VehiclesUS_tex.Treads.M10_treads'
}


