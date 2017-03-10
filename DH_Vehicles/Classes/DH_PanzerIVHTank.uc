//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PanzerIVHTank extends DH_PanzerIVGLateTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

defaultproperties
{
    VehicleNameString="Panzer IV Ausf.H"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVHCannonPawn')

    Mesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_camo1'
    Skins(3)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    Skins(4)=texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    Skins(5)=texture'DH_VehiclesGE_tex2.ext_vehicles.gear_Stug'
    HighDetailOverlayIndex=4
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_body_int')

    FrontArmor(0)=(Thickness=8.0,Slope=14.0)
    RightArmor(0)=(Thickness=3.1)
    LeftArmor(0)=(Thickness=3.1)
    RearArmor(0)=(Thickness=2.0,Slope=9.0)
/*
    FrontArmor(0)=(Thickness=x.0,Slope=-x.0,MaxRelativeHeight=x.0,LocationName="lower")
    FrontArmor(1)=(Thickness=x.0,Slope=x.0,LocationName="upper")
    RightArmor(0)=(Thickness=x.0,MaxRelativeHeight=x.0,LocationName="lower")
    RightArmor(1)=(Thickness=x.0,Slope=x.0,LocationName="upper")
    LeftArmor(0)=(Thickness=x.0,MaxRelativeHeight=x.0,LocationName="lower")
    LeftArmor(1)=(Thickness=x.0,Slope=x.0,LocationName="upper")
    RearArmor(0)=(Thickness=x.0,Slope=-x.0,MaxRelativeHeight=x.0,LocationName="lower")
    RearArmor(1)=(Thickness=x.0,Slope=x.0,LocationName="upper")

    UFrontArmorFactor=8.0
    URightArmorFactor=3.1
    ULeftArmorFactor=3.1
    URearArmorFactor=2.0
    UFrontArmorSlope=14.0
*/

    MaxCriticalSpeed=693.0 // 43 kph
    ExhaustPipes(0)=(ExhaustPosition=(X=-170.0,Y=13.0,Z=35.0))
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.panzer4h_body'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.panzer4_h'
}
