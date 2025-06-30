//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M3A1HalftrackTransport_Soviet_Snow extends DH_M3A1HalftrackTransport;

defaultproperties
{
    // Hull mesh
    Skins(0)=Texture'DH_M3Halftrack_tex.M3Halftrack_sov_winter'
    Skins(1)=Texture'DH_M3Halftrack_tex.Halftrack_2'
    Skins(2)=Texture'DH_M3Halftrack_tex.Halfrack_tracks'
    Skins(3)=Texture'DH_M3Halftrack_tex.Halfrack_tracks'

    //to do: destroyed skin
    RandomAttachmentGroups(0)=(Options=((Probability=0.5,Attachment=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3_bumper_01',Skins=(Texture'DH_M3Halftrack_tex.Halftrack_2_winter'))),(Probability=0.5,Attachment=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3_bumper_02',Skins=(Texture'DH_M3Halftrack_tex.Halftrack_2_winter')))))
    DestroyedMeshSkins(0)=Combiner'DH_M3Halftrack_tex.Halftrack_winter_destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_M3Halftrack_tex.Halftrack_2_winter_destroyed'
}
