//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIVJTank extends DH_PanzerIVHTank;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Panzer IV Ausf.J"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVJCannonPawn')
    bHasAddedSideArmor=true
    MaxCriticalSpeed=793.0 // 47 kph

    // Hull mesh
    Mesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.panzer4J_body_ext'
    Skins(3)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2'
    Skins(4)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2'
    Skins(5)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo1'
    Skins(6)=Texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    Skins(7)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_ext'
    HighDetailOverlayIndex=6
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int')

    // Damage
	// pros: 5 men crew
	// cons: petrol fuel;
	// (mostly unchanged as it extends ausf H)
	// this modification was produced late in the war (1944-45), most (if not all) tanks of this modification had very low quality armor due to absence of proper alloys, which was less effective and caused a lot of spalling
    Health=535
    HealthMax=535.0
	VehHitpoints(0)=(PointOffset=(X=-100.0,Y=0.0,Z=12.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointOffset=(X=30.0,Y=-27.0,Z=0.0)) // ammo stores x 3
    VehHitpoints(2)=(PointRadius=20.0,PointOffset=(X=-20.0,Y=-27.0,Z=0.0))
    VehHitpoints(3)=(PointRadius=20.0,PointOffset=(X=-30.0,Y=27.0,Z=0.0))
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.PanzerIVJ.PanzerIVJ_dest'

    // Hull armor
    FrontArmor(0)=(Thickness=2.4,Slope=-64.0,MaxRelativeHeight=-20.0,LocationName="lower nose")
    FrontArmor(1)=(Thickness=7.2,Slope=-12.0,MaxRelativeHeight=6.8,LocationName="nose")
    FrontArmor(2)=(Thickness=2.0,Slope=73.0,MaxRelativeHeight=22.5,LocationName="glacis")
    FrontArmor(3)=(Thickness=7.2,Slope=10.0,LocationName="upper")

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-176.0,Y=-10.0,Z=42.0),ExhaustRotation=(Pitch=22000,Yaw=0)) // this model has twin exhausts
    ExhaustPipes(1)=(ExhaustPosition=(X=-176.0,Y=46.0,Z=42.0),ExhaustRotation=(Pitch=22000,Yaw=0))
    LeftWheelBones(13)=""
    RightWheelBones(13)=""

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.panzer4j_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer4j_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer4j_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.panzer4_j'
}
