//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat1435Gun_WC extends DH_Fiat1435Gun;

defaultproperties
{
    StationaryWeaponClass=class'DH_Fiat1435WCWeapon'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Fiat1435MGPawn_WC',WeaponBone=turret_placement)
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.interface.fiat1435_turret_wc_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.interface.fiat1435_turret_wc_icon_look'
}
