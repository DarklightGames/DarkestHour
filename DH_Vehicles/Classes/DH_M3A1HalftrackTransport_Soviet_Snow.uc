//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M3A1HalftrackTransport_Soviet_Snow extends DH_M3A1HalftrackTransport;

defaultproperties
{
    bIsWinterVariant=true
    // Hull mesh
    Skins(0)=Texture'DH_M3Halftrack_tex.m3.M3Halftrack_sov_winter'
    Skins(1)=Texture'DH_M3Halftrack_tex.m3.Halftrack_2'
    Skins(2)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'
    Skins(3)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'

    //to do: destroyed skin
    RandomAttachment=(Skins=(Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'))
    DestroyedMeshSkins(0)=combiner'DH_M3Halftrack_tex.m3.Halftrack_winter_destroyed'
    DestroyedMeshSkins(1)=combiner'DH_M3Halftrack_tex.m3.Halftrack_2_winter_destroyed'
}
