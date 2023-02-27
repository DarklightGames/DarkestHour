//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M16Halftrack_Snow extends DH_M16Halftrack;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_M3Halftrack_tex.m3.Halftrack_winter'
    Skins(1)=Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M45QuadmountMGPawn_Snow',WeaponBone="turret_placement")
    RandomAttachment=(Skins=(Texture'DH_M3Halftrack_tex.m3.Halftrack_2_winter'))
    DestroyedMeshSkins(0)=Combiner'DH_M3Halftrack_tex.m3.Halftrack_winter_destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_M3Halftrack_tex.m3.Halftrack_2_winter_destroyed'
    DestroyedMeshSkins(3)=Combiner'DH_Artillery_tex.m45.m45_gun_dest_snow'
}
