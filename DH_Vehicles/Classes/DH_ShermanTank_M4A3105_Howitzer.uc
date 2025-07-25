//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanTank_M4A3105_Howitzer extends DH_ShermanTank_M4A375W;

defaultproperties
{
    VehicleNameString="M4A3(105) Sherman"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_ShermanCannonPawn_M4A3105_Howitzer')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M4A3_105dest'
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Shermanm4a3e2_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Sherman105_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Sherman105_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.sherman_m4a3_105'

    // Damage
    // Compared to M4A375W: 105mm ammo is more likely to explode
    AmmoIgnitionProbability=0.88  // 0.75 default

}
