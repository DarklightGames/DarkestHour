//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat35Gun extends DH_Fiat1435Gun;

defaultproperties
{
    VehicleNameString="Fiat mod. 35"
    MountedWeaponClass=Class'DH_Fiat35Weapon'
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Guns.DH_Fiat35MGPawn',WeaponBone=turret_placement)
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.fiat35_turret_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.fiat35_turret_icon_look'
}
