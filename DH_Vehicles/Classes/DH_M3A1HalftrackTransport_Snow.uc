//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M3A1HalftrackTransport_Snow extends DH_M3A1HalftrackTransport;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_M3Halftrack_tex.m3.Halftrack_winter'
    Skins(1)=Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'
//  Skins(2)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks_winter' // TODO: get some snowy treads made (same for M16 & for factory classes)
//  Skins(3)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks_winter'
    RandomAttachment=(Skins=(Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'))
    DestroyedMeshSkins(0)=Combiner'DH_M3Halftrack_tex.m3.Halftrack_winter_destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_M3Halftrack_tex.m3.Halftrack_2_winter_destroyed'
}
