//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// CODING
//==============================================================================
// [ ] add a "point to" animation driver for the arm thing
// [ ] make smoke grenade actually WP
// [ ] make sure you can't pick up other stationary weapons if you are currently holding one
// [ ] when player dies on it, why is the ragdoll half into the ground?
// [ ] tube sliding sounds in fp and tp
// [ ] interrupt the pick-up interaction if error is ever not none
// [ ] look at issue with not being able to raise on 8cm mortars (initial position issue?)
// [ ] pickup option sometimes crashes the game (some sort of interaction bug);
//     probably related to object holding onto actor reference. (it's the array of objects, almost certainly)
//==============================================================================
// ART
//==============================================================================
// [ ] re-export gun mesh and animations
// [ ] first person firing animations
// [ ] third person raise/lower/binoc animations
// [ ] first person carrying animations
// [ ] third person carrying animations
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
    DestroyedVehicleMesh=StaticMesh'DH_M2Mortar_stc.M2mortar_destroyed'

    VehicleHudImage=Texture'DH_M2Mortar_tex.interface.M2mortar_body'
    VehicleHudTurret=TexRotator'DH_M2Mortar_tex.interface.M2mortar_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M2Mortar_tex.interface.M2mortar_turret_look'

    DestructionEffectOffset=(Z=-60)

    StationaryWeaponClass=class'DH_M2MortarWeapon'
}
