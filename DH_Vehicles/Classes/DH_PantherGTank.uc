//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PantherGTank extends DH_PantherDTank;

defaultproperties
{
    FrontArmor(1)=(Thickness=8.2) // DEMO: new banded hull armor system, replacing below
    RightArmor(1)=(Thickness=5.0,Slope=30.0)
    LeftArmor(1)=(Thickness=5.0,Slope=30.0)
/*
    UFrontArmorFactor=8.2
    URightArmorFactor=5.0
    ULeftArmorFactor=5.0
    URightArmorSlope=30.0
    ULeftArmorSlope=30.0
*/
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn')
    VehicleNameString="Panzer V 'Panther' Ausf.G"
}
