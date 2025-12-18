//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// MODELING & TEXTURING
//==============================================================================
// [~] Destroyed mesh
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
// [ ] make shield an optional attachment (no separate variant though, please)
// [ ] functionality to allow for good looking TP reload animations (either move
//     the gun to aim straight or just have this occur in TP, ala the hetzer)
// [ ] persist barrel states through different instances (pickup, inventory,
//     vehicle)
// [ ] use explicit skin when using mounted weapon (don't use underlying skin
//     toggling functionality in the construction weapon)
// [ ] add collision querying for placement (i.e., make sure there's enough room
//     for the gunner)
// [ ] add barrel overheating/swap hint for mounted MGs
//==============================================================================
// BUGS
//==============================================================================
// [ ] PLACED MAXIM HAS INCORRECT TEAM? possible bug introduced in merge
// [ ] mounted guns start moving as karma objects once force is applied to them
//     (grenade explosion nearby etc.) [mnight have to do with whether or not it has a karma collision box]
// [ ] view screws up once barrel has failed (due to CanFire being used in
//     SpecialCamCalc or whatever it's called)
// [ ] shells eject backwards with other mount (maybe make a second base mesh
//     entirely so we can have different collision)
// [ ] make sure vis box is correct
//==============================================================================
// MISC
//==============================================================================
// [ ] new sounds (firing, reload etc.)
//==============================================================================

class DH_MaximM191030Gun extends DHATGun;

defaultproperties
{
    VehicleTeam=ALLIES_TEAM_INDEX
    VehicleNameString="Maxim M1910/30"
    BeginningIdleAnim="IDLE"
    Mesh=SkeletalMesh'DH_Maxim_anm.MAXIM_BODY_EXT'
    Skins(0)=Texture'DH_Maxim_tex.MAXIM_BODY_EXT'
    bCanBeRotated=true
    CollisionRadius=32.0
    CollisionHeight=16.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_MaximM191030MGPawn',WeaponBone="TURRET_PLACEMENT")
    RotationsPerSecond=0.125
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_Maxim_tex.MAXIM_BODY_ICON'
    VehicleHudTurret=TexRotator'DH_Maxim_tex.MAXIM_TURRET_ROT'
    VehicleHudTurretLook=TexRotator'DH_Maxim_tex.MAXIM_TURRET_LOOK'
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
