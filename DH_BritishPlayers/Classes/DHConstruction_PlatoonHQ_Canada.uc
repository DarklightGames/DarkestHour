//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_PlatoonHQ_Canada extends DHConstruction_PlatoonHQ
    placeable;

defaultproperties
{
    TeamOwner=TEAM_Allies
    TeamIndex=ALLIES_TEAM_INDEX
    FlagMaterial=Texture'DH_Construction_tex.Base.CAN_flag_01'
    StaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent'
    BrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_destroyed'
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_unpacked')
    TatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_light_destro'
}
