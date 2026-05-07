//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat14Gun extends DH_Fiat1435Gun;

defaultproperties
{
    VehicleNameString="Fiat mod. 14"
    MountedWeaponClass=Class'DH_Fiat14Weapon'
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Fiat14MGPawn',WeaponBone=turret_placement)
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_look'
}
