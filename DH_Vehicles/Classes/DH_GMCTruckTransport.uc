//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GMCTruckTransport extends DH_GMCTruck;

defaultproperties
{
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_GMCTruckPassengerThree',WeaponBone="passenger_l_3")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_GMCTruckPassengerFour',WeaponBone="passenger_l_5")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_GMCTruckPassengerFive',WeaponBone="passenger_r_1")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_GMCTruckPassengerSix',WeaponBone="passenger_r_3")
    PassengerWeapons(6)=(WeaponPawnClass=class'DH_Vehicles.DH_GMCTruckPassengerSeven',WeaponBone="passenger_r_5")
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.55
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.65
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.55
    VehicleHudOccupantsX(6)=0.55
    VehicleHudOccupantsY(6)=0.65
    VehicleHudOccupantsX(7)=0.55
    VehicleHudOccupantsY(7)=0.75
    ExitPositions(2)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(3)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(4)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(5)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    ExitPositions(6)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    ExitPositions(7)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
}
