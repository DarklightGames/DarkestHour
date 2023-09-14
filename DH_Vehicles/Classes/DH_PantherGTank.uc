//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherGTank extends DH_PantherDTank;

defaultproperties
{
    VehicleNameString="Panzer V 'Panther' Ausf.G"
    Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.pantherg_ext'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn')
    FrontArmor(0)=(Thickness=6.2)
    FrontArmor(1)=(Thickness=8.2)
    RightArmor(0)=(Thickness=5.0)
    RightArmor(1)=(Thickness=5.0,Slope=30.0)
    LeftArmor(0)=(Thickness=5.0)
    LeftArmor(1)=(Thickness=5.0,Slope=30.0)

    // Damage
	// pros: 5 men crew;
	// cons: petrol fuel; general unreliability of the panthers; this variant is a later one, so partially fixed and improved
    Health=565
    HealthMax=565.0
	EngineHealth=240  //engine health is lowered for above reason (higher than ausf D)

    EngineRestartFailChance=0.25 //unreliability
}
