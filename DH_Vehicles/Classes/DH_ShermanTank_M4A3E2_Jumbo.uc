//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanTank_M4A3E2_Jumbo extends DH_ShermanTank_M4A375W;

defaultproperties
{
    VehicleNameString="M4A3E2(75)W Sherman"
    ReinforcementCost=8
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_ShermanCannonPawn_M4A3E2_Jumbo')
    VehicleMass=14.0
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex3.ShermanM4A3E2_ext'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int')

    //Armor Values. Sources: Page 69 of WWII Ballistics: Armor and Gunnery and http://the.shadock.free.fr/sherman_minutia/manufacturer/m4a3e2jumbo/m4a3e2.html
    FrontArmor(0)=(Thickness=11.43,Slope=-45.0,MaxRelativeHeight=41.0,LocationName="lower nose")
    FrontArmor(1)=(Thickness=13.97,MaxRelativeHeight=55.0,LocationName="mid nose") // represents flattest, front facing part of rounded nose plate
    FrontArmor(2)=(Thickness=11.43,Slope=56.0,MaxRelativeHeight=73.0,LocationName="upper nose")
    FrontArmor(3)=(Thickness=10.2,Slope=47.0,LocationName="upper")
    RightArmor(0)=(Thickness=3.81,MaxRelativeHeight=69.7,LocationName="lower")
    RightArmor(1)=(Thickness=7.6,LocationName="upper")
    LeftArmor(0)=(Thickness=3.81,MaxRelativeHeight=69.7,LocationName="lower")
    LeftArmor(1)=(Thickness=7.6,LocationName="upper")
    RearArmor(0)=(Thickness=3.81,Slope=-10.0,MaxRelativeHeight=61.0,LocationName="lower")
    RearArmor(1)=(Thickness=3.81,Slope=22.0,LocationName="upper")

    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M4A3E2_dest'
    GearRatios(4)=0.67
    TransRatio=0.07
    VehicleHudImage=Texture'DH_InterfaceArt_tex.shermanm4a3e2_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.ShermanJumbo75_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.ShermanJumbo75_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.sherman_m4a3e2'
}
