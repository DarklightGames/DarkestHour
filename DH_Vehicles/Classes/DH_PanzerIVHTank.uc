//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerIVHTank extends DH_PanzerIVGLateTank;

defaultproperties
{
    VehicleNameString="Panzer IV Ausf.H"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_PanzerIVHCannonPawn')

    Mesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex3.Panzer4J_body_camo1'
    Skins(3)=Texture'DH_VehiclesGE_tex2.Alpha' // hides hull side skirts
    Skins(4)=Texture'axis_vehicles_tex.Panzer4F2_int'
    Skins(5)=Texture'DH_VehiclesGE_tex2.gear_Stug'
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

    ExhaustPipes(0)=(ExhaustPosition=(X=-170.0,Y=13.0,Z=35.0))
    VehicleHudImage=Texture'DH_InterfaceArt_tex.panzer4h_body'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.panzer4_h'
}
