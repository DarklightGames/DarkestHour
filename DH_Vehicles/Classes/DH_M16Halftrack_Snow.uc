//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M16Halftrack_Snow extends DH_M16Halftrack;

defaultproperties
{
    Skins(0)=Texture'DH_M3Halftrack_tex.m3.Halftrack_winter'
    Skins(1)=Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M45QuadmountMGPawn_Snow',WeaponBone="turret_placement")
    RandomAttachmentGroups(0)=(Options=((Probability=0.5,Attachment=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_bumper_01',Skins=(Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'))),(Probability=0.5,Attachment=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_bumper_02',Skins=(Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter')))))
    DestroyedMeshSkins(0)=Combiner'DH_M3Halftrack_tex.m3.Halftrack_winter_destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_M3Halftrack_tex.m3.Halftrack_2_winter_destroyed'
    DestroyedMeshSkins(3)=Combiner'DH_Artillery_tex.m45.m45_gun_dest_snow'
}
