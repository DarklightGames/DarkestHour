//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Cromwell95mmTank extends DH_CromwellTank;

defaultproperties
{
    VehicleNameString="Cromwell Mk.VI"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Cromwell95mmCannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Crommy_95mm_wrecked'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_95mm_Rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_95mm_Look'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.cromwell_95mm'
}
