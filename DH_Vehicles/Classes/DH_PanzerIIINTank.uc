//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIINTank extends DH_PanzerIIILTank;

defaultproperties
{
    VehicleNameString="Panzer III Ausf.N"
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIINCannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3n_destroyed2'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3n_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3n_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.panzer3_n'

	AmmoIgnitionProbability=0.75  // 0.75 default; 75mm ammo instead of 50mm
}
