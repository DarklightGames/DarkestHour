//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WolverineTank_British extends DH_WolverineTank;

defaultproperties
{
    VehicleNameString="Wolverine SP"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_WolverineCannonPawn_British')
    Skins(0)=Texture'DH_VehiclesUK_tex.Achilles_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.Achilles_turret_ext'
    DestroyedMeshSkins(0)=Material'DH_VehiclesUK_tex.Achilles_body_dest'
    DestroyedMeshSkins(1)=Material'DH_VehiclesUK_tex.Achilles_turret_dest'
}
