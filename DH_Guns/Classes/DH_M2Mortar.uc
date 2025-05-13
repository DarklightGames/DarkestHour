//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// ART
//==============================================================================
// [~] Third person carrying animations
// [ ] Add tube sliding sounds to the TP firing anims
//==============================================================================
// AUDIO
//==============================================================================
// [ ] No distant sound for 60mm explosion?
// [ ] Replace firing sound to distinguish from the 8cm
//==============================================================================
// BUGS
//==============================================================================
// [ ] Clicking fire or reload after all HE has been fired doesn't swap to new
//     ammo type (affects all AT guns etc.)
// [ ] Player can still "move" camera while in locked view modes (gunsight etc.)
// [ ] Player can somehow fail to deploy the mortar due to a "no room" error.
//     Seems to happen if the player doesn't move the mouse at all. Seems
//     impossible to reproduce after successfully deploying.
//==============================================================================
// NICE TO HAVE
//==============================================================================
// [ ] Make smoke grenade actually WP
// [ ] Add a "point to" animation driver for the arm thing (when yawing the gun
//     to the side, parts of the model don't line up because of the simplified
//     rigging).
// [ ] When a player runs out of ammo, prompt them to press X to change round
//     type.
// [ ] When player dies on it, why is the ragdoll half into the ground?
//==============================================================================
// FINISHING TOUCHES
//==============================================================================
// [ ] Validate that this all works in MP
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
