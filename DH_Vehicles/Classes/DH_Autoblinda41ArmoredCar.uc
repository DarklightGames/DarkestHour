//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Autoblinda41ArmoredCar extends DH_AutoblindaArmoredCar;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Autoblinda 41"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Autoblinda41CannonPawn',WeaponBone="turret_attachment")
    DestroyedVehicleMesh=StaticMesh'DH_Autoblinda_stc.ab41_destroyed'
    VehicleHudTurret=TexRotator'DH_Autoblinda_tex.ab41_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Autoblinda_tex.ab41_turret_look'
    SpawnOverlay(0)=Material'DH_Autoblinda_tex.ab41_icon'
}
