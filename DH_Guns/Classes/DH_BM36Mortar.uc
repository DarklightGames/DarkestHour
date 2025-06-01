//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BM36Mortar extends DH_Model35Mortar;

defaultproperties
{
    VehicleNameString="82-BM-36 Mortar"
    VehicleTeam=1
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_base'
    Skins(0)=Texture'DH_Model35Mortar_tex.bm36_mortar_ext'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_BM36MortarCannonPawn',WeaponBone="TURRET_PLACEMENT")
}
