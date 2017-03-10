//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PanzerIIINTank extends DH_PanzerIIILTank;

defaultproperties
{
    VehicleNameString="Panzer III Ausf.N"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIINCannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3n_destroyed2'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3n_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3n_turret_look'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.panzer3_n'
}
