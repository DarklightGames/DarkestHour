//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PantherGTank extends DH_PantherDTank;

defaultproperties
{
    VehicleNameString="Panzer V 'Panther' Ausf.G"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn')
    FrontArmor(0)=(Thickness=6.2)
    FrontArmor(1)=(Thickness=8.2)
    RightArmor(1)=(Thickness=5.0,Slope=30.0)
    LeftArmor(1)=(Thickness=5.0,Slope=30.0)
}
