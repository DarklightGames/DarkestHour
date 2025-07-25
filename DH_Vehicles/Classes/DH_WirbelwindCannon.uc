//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WirbelwindCannon extends DH_Flakvierling38Cannon;

defaultproperties
{
    // Turret armor
    FrontArmorFactor=1.6
    RightArmorFactor=1.6
    LeftArmorFactor=1.6
    RearArmorFactor=1.6
    RightArmorSlope=5.0
    // NOTE: our system can't distinguish between an upper/lower angle :(
    LeftArmorSlope=20.0
    FrontArmorSlope=20.0
    FrontLeftAngle=325.0
    FrontRightAngle=35.0
    RearRightAngle=165.0
    RearLeftAngle=195.0

    Mesh=SkeletalMesh'DH_Flak38_anm.Wirbelwind_turret'
    Skins(0)=Texture'DH_Artillery_tex.FlakVeirling38'
    Skins(1)=Texture'DH_Artillery_tex.Wirberlwind_turret'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc4.wirbelwind_turret_col')
}

