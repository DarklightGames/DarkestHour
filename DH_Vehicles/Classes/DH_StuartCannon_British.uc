//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_StuartCannon_British extends DH_StuartCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_extB'
    Skins(0)=Texture'DH_VehiclesUK_tex.Brit_M5_body_ext'
    Skins(2)=Texture'DH_VehiclesUK_tex.Brit_M5_armor'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Stuart_turret_colB')
    NumMGMags=9
}
