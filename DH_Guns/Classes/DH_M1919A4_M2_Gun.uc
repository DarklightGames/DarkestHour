//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] fire/move marks hit the backside of the gun
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
    VehicleHudImage=Texture'DH_Fiat1435_tex.fiat1435_tripod_icon'
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_look'
    MountedWeaponClass=Class'DH_M1919A4Weapon'
}
