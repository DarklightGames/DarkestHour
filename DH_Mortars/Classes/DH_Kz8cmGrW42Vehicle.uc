//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Kz8cmGrW42Vehicle extends DHMortarVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    PlayerResupplyAmounts(0)=4
    PlayerResupplyAmounts(1)=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Mortars.DH_Kz8cmGrW42VehicleWeaponPawn',WeaponBone="Mortar_Attachment")
    VehicleNameString="Kurz 8cm Granatwerfer 42"
}
