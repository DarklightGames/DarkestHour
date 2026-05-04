//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4_M2_Gun extends DH_M1919A4Gun;

defaultproperties
{
    BeginningIdleAnim="idle"
    Mesh=SkeletalMesh'DH_M1919A4_anm.TRIPOD_M2_BODY'
    CollisionRadius=36.0
    CollisionHeight=36.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M1919A4_M2_MGPawn',WeaponBone="turret_placement")
    RotationsPerSecond=0.125
    VehicleHudImage=Texture'DH_M1919A4_tex.HUD.M1919A4_M2_BODY'
    VehicleHudTurret=TexRotator'DH_M1919A4_tex.HUD.M1919A4_M2_TURRRET_ROT'  // TODO: spelling error
    VehicleHudTurretLook=TexRotator'DH_M1919A4_tex.HUD.M1919A4_M2_TURRRET_LOOK'
    MountedWeaponClass=Class'DH_M1919A4Weapon'
}
