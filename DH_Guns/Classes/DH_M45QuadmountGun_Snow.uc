//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M45QuadmountGun_Snow extends DH_M45QuadmountGun;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M45QuadmountMGPawn_Snow')
    Skins(0)=Texture'DH_Artillery_tex.m45.m45_trailer_snow'
    DestroyedMeshSkins(0)=Material'DH_Artillery_tex.m45.m45_gun_dest_snow'
    DestroyedMeshSkins(1)=Material'DH_Artillery_tex.m45.m45_trailer_dest_snow'
}
