//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Cannone4732Gun_NoWheels extends DH_Cannone4732Gun;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_body_nowheels'
    DestroyedVehicleMesh=StaticMesh'DH_Cannone4732_stc.Destroyed.cannone4732_destroyed_nowheels'
    VehicleHudImage=Texture'DH_Cannone4732_tex.Interface.cannone4732_body_nowheels_icon'
    RotationsPerSecond=0.05 // Rotates slower than the wheeled version
}
