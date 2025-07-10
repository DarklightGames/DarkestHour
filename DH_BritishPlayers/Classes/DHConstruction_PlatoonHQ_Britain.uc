//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_PlatoonHQ_Britain extends DHConstruction_PlatoonHQ
    placeable;

defaultproperties
{
    TeamOwner=TEAM_Allies
    TeamIndex=ALLIES_TEAM_INDEX
    FlagMaterial=Texture'DH_Construction_tex.BRIT_flag_01'
    StaticMesh=StaticMesh'DH_Construction_stc.USA_HQ_tent'
    BrokenStaticMesh=StaticMesh'DH_Construction_stc.USA_HQ_tent_destroyed'
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.USA_HQ_tent_unpacked')
    TatteredStaticMesh=StaticMesh'DH_Construction_stc.USA_HQ_tent_light_destro'
}
