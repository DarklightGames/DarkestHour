//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Destroyed mesh
// [ ] Collision
//==============================================================================

class DH_ML3InchMortar extends DHMortar;

defaultproperties
{
    VehicleNameString="Ordnance ML 3-inch Mortar"
    VehicleTeam=1
    Mesh=SkeletalMesh'DH_ML3InchMortar_anm.ml3inch_body_ext'
    //Skins(0)=Texture'DH_Granatwerfer34_tex.grw34_ext_yellow'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_ML3InchCannonPawn',WeaponBone="TURRET_PLACEMENT")
    CollisionRadius=32.0
    CollisionHeight=8.0
    // Reversed because the gunner uses index 1.
    ExitPositions(0)=(X=-50.00,Y=35.0,Z=20)
    ExitPositions(1)=(X=-50.00,Y=-35.0,Z=20)

    bUsesCodedDestroyedSkins=true
    DestroyedVehicleMesh=StaticMesh'DH_Model35Mortar_stc.Destroyed.model35mortar_destroyed'

    VehicleHudImage=Texture'DH_ML3InchMortar_tex.interface.ml3inch_body_icon'
    VehicleHudTurret=TexRotator'DH_ML3InchMortar_tex.interface.ml3inch_tube_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_ML3InchMortar_tex.interface.ml3inch_tube_icon_look'

    DestructionEffectOffset=(Z=-60)
}
