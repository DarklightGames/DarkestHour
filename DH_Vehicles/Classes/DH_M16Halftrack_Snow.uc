//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M16Halftrack_Snow extends DH_M16Halftrack;

defaultproperties
{
    Skins(0)=texture'DH_M3Halftrack_tex.m3.Halftrack_winter'
    Skins(1)=texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M45QuadmountMGPawn_Snow',WeaponBone="turret_placement")
    RandomAttachOptions(0)=(Skin=texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter')
    RandomAttachOptions(1)=(Skin=texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter')
    DestroyedMeshSkins(0)=Combiner'DH_Artillery_tex.m45.m45_gun_dest_snow'
    DestroyedMeshSkins(1)=Combiner'DH_M3Halftrack_tex.m3.Halftrack_winter_destroyed'
    DestroyedMeshSkins(2)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'
    DestroyedMeshSkins(3)=Combiner'DH_M3Halftrack_tex.m3.Halftrack_2_winter_destroyed'
}

