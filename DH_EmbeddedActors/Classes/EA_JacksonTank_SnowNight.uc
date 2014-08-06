//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EA_JacksonTank_SnowNight extends EA_JacksonTank_Snow;

//Setup new texture package
#exec OBJ LOAD FILE=..\textures\DH_CheneuxCAVehicle_tex.utx

DefaultProperties
{
	PassengerWeapons(0)=(WeaponPawnClass=Class'DH_EmbeddedActors.EA_JacksonCannonPawn_SnowNight',WeaponBone="Turret_placement")
	//Skins(0)=Texture'DH_CheneuxCAVehicle_tex.ext_vehicles.M36Jackson_HullSnowDark'
	//Skins(1)=Texture'DH_CheneuxCAVehicle_tex.ext_vehicles.M36Jackson_TurretSnowDark'
}