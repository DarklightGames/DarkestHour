//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_PlatoonHQ_Italy extends DHConstruction_PlatoonHQ
    placeable;

defaultproperties
{
    TeamOwner=TEAM_Axis
    TeamIndex=AXIS_TEAM_INDEX
    FlagMaterial=Texture'DH_Construction_tex.Base.GER_flag_01'   // TODO: replace
    StaticMesh=StaticMesh'DH_Construction_stc.Bases.ITA_HQ_tent'
    BrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_destroyed'   // TODO: replace
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_unpacked')   // TODO: replace
    TatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.ITA_HQ_tent_light_destro'
}