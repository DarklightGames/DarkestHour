//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Kz8cmGrW42Vehicle extends DHMortarVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Weapons.DH_Kz8cmGrW42VehicleWeaponPawn',WeaponBone="Mortar_Attachment")
    VehicleNameString="Kurz 8cm Granatwerfer 42"
}
