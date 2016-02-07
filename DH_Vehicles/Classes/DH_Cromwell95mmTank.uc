//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Cromwell95mmTank extends DH_CromwellTank;

defaultproperties
{
    VehicleNameString="Cromwell Mk.VI"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Cromwell95mmCannonPawn')
//  VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_95mm_Rot'      // TODO - make HUD icons for 95mm turret
//  VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_95mm_Look'
//  SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.cromwell_95mm'                    // TODO - make vehicle icon for 95mm Cromwell
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Crommy_95mm_wrecked'
}
