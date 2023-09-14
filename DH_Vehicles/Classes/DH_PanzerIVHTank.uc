//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIVHTank extends DH_PanzerIVGLateTank;

defaultproperties
{
    VehicleNameString="Panzer IV Ausf.H"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVHCannonPawn')

    Mesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_camo1'
    Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha' // hides hull side skirts
    Skins(4)=Texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    Skins(5)=Texture'DH_VehiclesGE_tex2.ext_vehicles.gear_Stug'
    HighDetailOverlayIndex=4
    DestroyedMeshSkins(0)=none // remove skins inherited from ausf G, as the inherited DestroyedVehicleMesh is correct for this vehicle & we don't want it changed
    DestroyedMeshSkins(2)=none

    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_int')

    FrontArmor(1)=(Thickness=8.5,Slope=-14.0)
    FrontArmor(2)=(Thickness=2.0,Slope=72.0)
    FrontArmor(3)=(Thickness=8.5)
    RearArmor(1)=(Slope=11.0)

    MaxCriticalSpeed=693.0 // 43 kph
    ExhaustPipes(0)=(ExhaustPosition=(X=-170.0,Y=13.0,Z=35.0))
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.panzer4h_body'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.panzer4_h'
}
