//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// CODING
//==============================================================================
// [ ] set up name reuse on stationry weapons (use name of veh)
// [~] re-use & re-tool the construction/proxy weapon system for placing
//     stationary weapons
// [ ] add a "point to" animation driver for the arm thing
// [ ] transfer ammo state between weapon, pickup and vehicle
// [ ] make smoke grenade actually WP
//==============================================================================
// ART
//==============================================================================
// [ ] re-export all gun animations
// [ ] fix vis bounds
// [ ] redo first person anims
// [ ] add raise/lower/binoc anims for third person
// [ ] remake collision meshes
// [ ] destroyed mesh
// [ ] third person attachment & animations
// [ ] UI art
//==============================================================================

class DH_M2Mortar extends DHMortar;

defaultproperties
{
    VehicleNameString="M2 60mm Mortar"
    VehicleTeam=1
    Mesh=SkeletalMesh'DH_M2Mortar_anm.M2MORTAR_BODY_EXT'
    Skins(0)=Texture'DH_M2Mortar_tex.m2mortar.M2MORTAR_BODY_EXT'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M2MortarCannonPawn',WeaponBone="TURRET_PLACEMENT")
    CollisionRadius=32.0
    CollisionHeight=8.0
    // Reversed because the gunner uses index 1.
    ExitPositions(0)=(X=-50.00,Y=35.0,Z=20)
    ExitPositions(1)=(X=-50.00,Y=-35.0,Z=20)

    bUsesCodedDestroyedSkins=true
    //DestroyedVehicleMesh=StaticMesh'DH_M2Mortar_stc.Destroyed.M2mortar_destroyed'

    //VehicleHudImage=Texture'DH_M2Mortar_tex.interface.M2mortar_body_icon'
    //VehicleHudTurret=TexRotator'DH_M2Mortar_tex.interface.M2mortar_tube_icon_rot'
    //VehicleHudTurretLook=TexRotator'DH_M2Mortar_tex.interface.M2mortar_tube_icon_look'

    DestructionEffectOffset=(Z=-60)

    StationaryWeaponClass=class'DH_M2MortarWeapon'
}
