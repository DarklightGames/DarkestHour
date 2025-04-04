//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// CODING
//==============================================================================
// [ ] add a "point to" animation driver for the arm thing
// [ ] make smoke grenade actually WP
// [~] make sure you can't pick up other stationary weapons if you are currently
//     holding one (currently working accidentially because of not being able to
//     switch weapons while holding one)
// [ ] when a player runs out of ammo, prompt them to press X to change round
//     type.
// [ ] allow resupply while holding (needs custom resupply logic for saved state)
// [ ] add dust effect when weapon is deployed (same as constructions)
// [ ] don't let the player pick it up while prone
// [ ] shells are not visually in empty/reloading state on UI when out of ammo
//==============================================================================
// ART
//==============================================================================
// [ ] third person raise/lower/binoc animations
// [ ] third person carrying animations
// [ ] re-export FP mesh without sight
// [ ] add tube sliding sounds to the TP firing anims
//==============================================================================
// AUDIO
//==============================================================================
// [ ] no distant sound for 60mm explosion?
// [ ] replace firing sound to distinguish from the 8cm
//==============================================================================
// BUGS
//==============================================================================
// [ ] clicking after all HE has been fired doesn't swap to new ammo type
// [ ] can circumvent force switch behavior by picking up the weapon while
//     unable to switch weapons (i.e. while reloading)
// [ ] some sort of bug happening when the player gets into a bad state when
//     interacting with the pickups (slows down, can't switch weapons etc.) PRONE-TOGGLING FIXES IT
// [ ] can get into the "rotating" state without the rotating weapon, leaving a
//     permanent rotating decal under the gun. (seems to just be trying to 
//     switch weapons fsr)
// [ ] can deploy while doing first draw, due to fucky AnimEnd thing, it
//     doesn't play the deploy animation. use STATES
// [ ] when player dies on it, why is the ragdoll half into the ground?
// [ ] mortar disappears when enterting and exiting a vehicle with it in-hand
// [ ] player can still "move" camera while in locked view modes (gunsight etc.)
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
