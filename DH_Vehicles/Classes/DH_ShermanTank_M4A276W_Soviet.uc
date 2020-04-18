//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_ShermanTank_M4A276W_Soviet extends DH_ShermanTank_M4A375W; 

defaultproperties
{
    VehicleNameString="M4A2(76)W"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawnA_76mm')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_762dest'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_m4a3_76w'
	
    CannonSkins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.Sherman76w_turret_ext_nosymbols'

	
    // Hull mesh

    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A2_soviet'
	
    // Movement
	//different diesel engine
    MaxCriticalSpeed=777.0 // 45 kph
    GearRatios(1)=0.19
    GearRatios(3)=0.62
    GearRatios(4)=0.76
    TransRatio=0.094
	
	//to do: destroyed textures
}

