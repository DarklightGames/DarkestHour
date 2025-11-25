//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// MODELING & TEXTURING
//==============================================================================
// [ ] FP and TP texturing
// [ ] FP model
// [ ] Destroyed mesh
//==============================================================================
// ANIMATION
//==============================================================================
// [ ] FP belt animations
// [ ] FP reload animation
// [ ] TP reload animation
// [ ] FP item animations
// [ ] TP item animations
//==============================================================================
// CODE
//==============================================================================
// [ ] functionality to allow for good looking TP reload animations (either move
//     the gun to aim straight or just have this occur in TP, ala the hetzer)
// [ ] persist barrel states through different instances (pickup, inventory,
//     vehicle)
// [ ] add collision querying for standing mounts
// [ ] standing mounts should always be flat when placed
// [ ] add UI for barrel heat/damage??
// [ ] persist variant when picking up mounted gun
// [ ] add barrel overheating/swap prompt for mounted MGs
//==============================================================================
// BUGS
//==============================================================================
// [ ] mounted guns start moving as karma objects once force is applied to them
//     (grenade explosion nearby etc.)
// [ ] view screws up once barrel has failed (due to CanFire being used in
//     SpecialCamCalc or whatever it's called)
// [ ] reloads from supply points not working
// [ ] the anim channel for blending the upper body is still active for some
//     reason? was not an issue before. maybe just mute that channel; first 
//     find out which one it is!
//==============================================================================
// MISC
//==============================================================================
// [ ] new sounds (firing, reload etc.)
// [ ] add steaming sound for MG steam actor (placeholder used for now)
// [ ] interface art
//==============================================================================

class DH_MaximM191030Gun extends DHATGun;

defaultproperties
{
    VehicleTeam=ALLIES_TEAM_INDEX
    VehicleNameString="Maxim M1910/30"
    BeginningIdleAnim="IDLE"
    Mesh=SkeletalMesh'DH_Maxim_anm.MAXIM_BODY_EXT'
    bCanBeRotated=true
    CollisionRadius=32.0
    CollisionHeight=16.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_MaximM191030MGPawn',WeaponBone="TURRET_PLACEMENT")
    RotationsPerSecond=0.125
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_Fiat1435_tex.fiat1435_tripod_icon'                   // TODO: replace
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_rot'        // TODO: replace
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_look'   // TODO: replace
    MountedWeaponClass=Class'DH_MaximM191030Weapon'

    ExitPositions(0)=(X=0,Y=0,Z=80)         // Failsafe exit position (ontop of the gun)
    ExitPositions(1)=(X=-80,Y=0,Z=30)       // Main exit position (behind the gun)
    ExitPositions(2)=(X=0,Y=-80.0,Z=30)     // Beside the gun
    ExitPositions(3)=(X=0,Y=+80.0,Z=30)     
    ExitPositions(4)=(X=-80,Y=-80.0,Z=30)
    ExitPositions(5)=(X=-80,Y=80.0,Z=30)

    // In order for the collision meshes to actually work, for some reason there needs to be karma shapes.
    // However, we don't actually want the gun to move, so we set the max speed and angular speed to 0.
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KMaxSpeed=0.0
        KMaxAngularSpeed=0.0
    End Object
    KParams=KParams0
}
