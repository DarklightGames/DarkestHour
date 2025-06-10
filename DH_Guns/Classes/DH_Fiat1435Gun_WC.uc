//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat1435Gun_WC extends DH_Fiat1435Gun;

defaultproperties
{
    VehicleNameString="Fiat mod. 14"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Fiat1435MGPawn_WC',WeaponBone=turret_placement)
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.interface.fiat1435_turret_wc_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.interface.fiat1435_turret_wc_icon_look'
}
