//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_IS2Tank_Late extends DH_IS2Tank; // late war tank with APBC rounds instead of AP

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_IS2CannonPawn_Late')

        // Hull armor
    FrontArmor(0)=(Thickness=10.0,Slope=-30.0,MaxRelativeHeight=-0.5,LocationName="lower")
    FrontArmor(1)=(Thickness=10.0,Slope=60.0,LocationName="upper") //model 1944 sloped glacis - no drivers plate
    RightArmor(0)=(Thickness=9.0,MaxRelativeHeight=15.5,LocationName="lower")
    RightArmor(1)=(Thickness=9.0,Slope=15.0,LocationName="upper")
    LeftArmor(0)=(Thickness=9.0,MaxRelativeHeight=15.5,LocationName="lower")
    LeftArmor(1)=(Thickness=9.0,Slope=15.0,LocationName="upper")
    RearArmor(0)=(Thickness=6.0,Slope=-41.0,MaxRelativeHeight=-0.5,LocationName="lower")
    RearArmor(1)=(Thickness=6.0,Slope=49.0,LocationName="upper")
}
