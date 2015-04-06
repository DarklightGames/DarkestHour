//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_OpelBlitzSupport extends DH_OpelBlitz;

defaultproperties
{
    ResupplyAttachmentClass=class'DH_OpelBlitzResupplyAttachment'
    ResupplyAttachBone="supply"
    ResupplyDecoAttachmentClass=class'DH_OpelBlitzDecoAttachment'
    ResupplyDecoAttachBone="Deco"
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_OpelBlitzPassengerFour',WeaponBone="passenger_l_3")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_OpelBlitzPassengerSeven',WeaponBone="passenger_r_3")
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.8
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(3)=0.8
    ExitPositions(2)=(X=-255.0,Y=-30.0,Z=60.0)
    ExitPositions(3)=(X=-255.0,Y=30.0,Z=60.0)
}
