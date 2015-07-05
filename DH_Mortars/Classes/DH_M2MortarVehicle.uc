//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M2MortarVehicle extends DHMortarVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Mortars.DH_M2MortarVehicleWeaponPawn',WeaponBone="Mortar_Attachment")
    VehicleNameString="60mm Mortar M2"
    VehicleTeam=1
}
