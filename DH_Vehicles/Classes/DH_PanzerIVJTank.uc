//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PanzerIVJTank extends DH_PanzerIVHTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex4.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc3.usx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Panzer IV Ausf.J"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVJCannonPawn')
    bHasAddedSideArmor=true
    MaxCriticalSpeed=793.0 // 47 kph

    // Hull mesh
    Mesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.panzer4J_body_ext'
    Skins(3)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2'
    Skins(4)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2'
    Skins(5)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo1'
    Skins(6)=texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    Skins(7)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_ext'
    HighDetailOverlayIndex=6
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int')

    // Damage
    VehHitpoints(0)=(PointOffset=(X=-100.0,Y=0.0,Z=12.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointOffset=(X=30.0,Y=-27.0,Z=0.0)) // ammo stores x 3
    VehHitpoints(2)=(PointRadius=20.0,PointOffset=(X=-20.0,Y=-27.0,Z=0.0))
    VehHitpoints(3)=(PointRadius=20.0,PointOffset=(X=-30.0,Y=27.0,Z=0.0))
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.PanzerIVJ.PanzerIVJ_dest'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-176.0,Y=-10.0,Z=42.0),ExhaustRotation=(Pitch=22000,Yaw=0)) // this model has twin exhausts
    ExhaustPipes(1)=(ExhaustPosition=(X=-176.0,Y=46.0,Z=42.0),ExhaustRotation=(Pitch=22000,Yaw=0))
    LeftWheelBones(13)=""
    RightWheelBones(13)=""

    // HUD
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.panzer4j_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer4j_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer4j_turret_look'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.panzer4_j'
}
