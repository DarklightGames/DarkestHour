//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_M4A3E2_Jumbo extends DH_ShermanTank_M4A375W;

defaultproperties
{
    VehicleNameString="M4A3E2(75)W Sherman"
    ReinforcementCost=8
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_M4A3E2_Jumbo')
    VehicleMass=14.0
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A3E2_ext'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int')
    FrontArmor(0)=(Thickness=13.97)
    FrontArmor(1)=(Thickness=13.97)
    FrontArmor(2)=(Thickness=11.43)
    FrontArmor(3)=(Thickness=8.7) // TODO: Bird & Livingston says 64mm plus 38mm for front, & 38mm + 38mm for upper sides
    RightArmor(0)=(Thickness=3.81,MaxRelativeHeight=69.7,LocationName="lower")
    RightArmor(1)=(Thickness=5.8,LocationName="upper")
    LeftArmor(0)=(Thickness=3.81,MaxRelativeHeight=69.7,LocationName="lower")
    LeftArmor(1)=(Thickness=5.8,LocationName="upper")
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3E2_dest'
    GearRatios(4)=0.67
    TransRatio=0.07
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.shermanm4a3e2_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.ShermanJumbo75_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.ShermanJumbo75_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_m4a3e2'
}
