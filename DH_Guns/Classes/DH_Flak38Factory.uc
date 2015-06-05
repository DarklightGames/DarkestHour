//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Factory extends DHATGunFactory;

#exec OBJ LOAD FILE=..\Animations\DH_Flak38_anm.ukx

defaultproperties
{
    VehicleClass=class'DH_Guns.DH_Flak38Gun'
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_base_wheels'
    Skins(0)=texture'DH_Flak38_tex.Flak38.flak38_cart_01_a_d'
}
