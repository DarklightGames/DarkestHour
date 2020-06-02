//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_WirbelwindTank extends DH_PanzerIVGLateTank;

defaultproperties
{
    VehicleNameString="Flakpanzer IV 'Wirbelwind'"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WirbelwindCannonPawn')
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.wirbelwind_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.wirbelwind_turret_look'
    SpawnOverlay(0)=Texture'DH_InterfaceArt_tex.Vehicles.wirbelwind'

    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.wirbelwind.Wirbelwind_destro'
}

