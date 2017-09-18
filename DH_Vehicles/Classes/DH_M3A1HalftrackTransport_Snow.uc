//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M3A1HalftrackTransport_Snow extends DH_M3A1HalftrackTransport;

defaultproperties
{
    Skins(0)=Texture'DH_M3Halftrack_tex.m3.Halftrack_winter'
    Skins(1)=Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'
    RandomAttachment=(Skin=Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter')
    DestroyedMeshSkins(0)=combiner'DH_M3Halftrack_tex.m3.Halftrack_winter_destroyed'
    DestroyedMeshSkins(1)=combiner'DH_M3Halftrack_tex.m3.Halftrack_2_winter_destroyed'
    DestroyedMeshSkins(2)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'
    DestroyedMeshSkins(3)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'
}
