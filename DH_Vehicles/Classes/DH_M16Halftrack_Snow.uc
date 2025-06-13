//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M16Halftrack_Snow extends DH_M16Halftrack;

defaultproperties
{
    Skins(0)=Texture'DH_M3Halftrack_tex.Halftrack_winter'
    Skins(1)=Texture'DH_M3Halftrack_tex.Halftrack_2_winter'
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M45QuadmountMGPawn_Snow',WeaponBone="turret_placement")
    RandomAttachmentGroups(0)=(Options=((Probability=0.5,Attachment=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3_bumper_01',Skins=(Texture'DH_M3Halftrack_tex.Halftrack_2_winter'))),(Probability=0.5,Attachment=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3_bumper_02',Skins=(Texture'DH_M3Halftrack_tex.Halftrack_2_winter')))))
    DestroyedMeshSkins(0)=Combiner'DH_M3Halftrack_tex.Halftrack_winter_destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_M3Halftrack_tex.Halftrack_2_winter_destroyed'
    DestroyedMeshSkins(3)=Combiner'DH_Artillery_tex.m45_gun_dest_snow'
}
