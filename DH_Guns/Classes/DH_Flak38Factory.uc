//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Flak38Factory extends DHATGunFactory;

defaultproperties
{
    VehicleClass=class'DH_Guns.DH_Flak38Gun'
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_base_static'
    Skins(0)=Texture'DH_Artillery_tex.Flak38.Flak38_gun'
    TeamNum=AXIS
}
