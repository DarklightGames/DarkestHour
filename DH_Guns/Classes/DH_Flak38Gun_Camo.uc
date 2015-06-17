//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Gun_Camo extends DH_Flak38Gun;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak38CannonPawn_Camo')
    Skins(0)=texture'DH_Artillery_tex.Flak38.Flak38_gun_camo'
    Skins(1)=texture'DH_Artillery_tex.Flak38.Flak38_trailer_camo'
    DestroyedMeshSkins(0)=material'DH_Artillery_tex.Flak38.Flak38_gun_dest_camo'
    DestroyedMeshSkins(1)=material'DH_Artillery_tex.Flak38.Flak38_trailer_dest_camo'
}
