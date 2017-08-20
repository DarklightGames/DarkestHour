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
}

