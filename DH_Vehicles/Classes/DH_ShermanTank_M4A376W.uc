//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanTank_M4A376W extends DH_ShermanTank_M4A375W; // later 76mm version with HVAP instead of smoke rounds

defaultproperties
{
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.M4A3_body_ext_alt'
    VehicleNameString="M4A3(76)W Sherman"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_ShermanCannonPawnA_76mm')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M4A3_762dest'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Sherman76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Sherman76_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.sherman_m4a3_76w'
}

