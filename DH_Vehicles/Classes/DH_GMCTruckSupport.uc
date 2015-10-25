//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GMCTruckSupport extends DH_GMCTruck;

defaultproperties
{
    ResupplyAttachmentClass=class'DH_GMCTruckResupplyAttachment'
    ResupplyAttachBone="supply"
    ResupplyDecoAttachmentClass=class'DH_GMCTruckDecoAttachment'
    ResupplyDecoAttachBone="Deco"
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_GMCTruckPassengerEight',WeaponBone="passenger_l_5")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_GMCTruckPassengerNine',WeaponBone="passenger_r_5")
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(3)=0.75
    VehHitpoints(3)=(PointRadius=40.0,PointScale=1.0,PointBone="body",PointOffset=(X=-80.0,Y=0.0,Z=90.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    ExitPositions(2)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(3)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
}
