//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Gun_Alt extends DH_Flak38Gun;

#exec OBJ LOAD FILE=..\Textures\DH_Flak38_tex_TEMP.utx // TEMP

simulated event DestroyAppearance() // TEMP
{
    super.DestroyAppearance();
    Skins[0] = texture'DH_Flak38_tex_TEMP.Flak38_gun_dest';
    Skins[1] = texture'DH_Flak38_tex_TEMP.Flak38_trailer_dest';
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak38CannonPawn_Alt')
    Skins(0)=texture'DH_Artillery_tex.Flak38.Flak38_gun_alt'
    Skins(1)=texture'DH_Artillery_tex.Flak38.Flak38_trailer_alt'
}
