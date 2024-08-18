//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1Mortar extends DH_Model35Mortar;

defaultproperties
{
    VehicleNameString="M1 Mortar"
    Team=1
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_base'
    Skins(0)=Texture'DH_Model35Mortar_tex.m1_mortar_ext'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M1MortarCannonPawn',WeaponBone="TURRET_PLACEMENT")
}
