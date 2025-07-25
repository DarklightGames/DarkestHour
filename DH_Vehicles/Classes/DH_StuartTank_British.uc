//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_StuartTank_British extends DH_StuartTank;

defaultproperties
{
    VehicleNameString="Stuart Mk.VI"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_StuartCannonPawn_British')
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_extB'
    Skins(0)=Texture'DH_VehiclesUK_tex.Brit_M5_body_ext'
    Skins(4)=Texture'DH_VehiclesUK_tex.Brit_M5_armor'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M5_Stuart_dest_Brit'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.m5_stuart_uk'
}
