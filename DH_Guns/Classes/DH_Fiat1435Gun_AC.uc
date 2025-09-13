//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat1435Gun_AC extends DH_Fiat1435Gun;

defaultproperties
{
    VehicleNameString="Fiat mod. 35"
    MountedWeaponClass=Class'DH_Fiat1435ACWeapon'
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Guns.DH_Fiat1435MGPawn_AC',WeaponBone=turret_placement)
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_look'
}
