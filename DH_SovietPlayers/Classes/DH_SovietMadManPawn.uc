//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SovietMadManPawn extends DH_SovietPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.sov_marine_Bushlat'
    Skins(0)=Texture'DHSovietCharactersTex.bushlat'
    Skins(1)=Texture'Characters_tex.rus_face01'
    Skins(2)=Texture'DHSovietCharactersTex.Gear'

    GroundSpeed=250
    WalkingPct=0.3
    Health=300
    Stamina=500
    MinHurtSpeed=700.0
    bNeverStaggers=true

}
