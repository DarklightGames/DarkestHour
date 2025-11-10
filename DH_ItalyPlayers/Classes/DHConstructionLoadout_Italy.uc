//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionLoadout_Italy extends DHConstructionLoadout
    abstract;

defaultproperties
{
    Loadouts(0)=Class'DHConstructionLoadout_Sandbags'
    
    // Logistics
    Constructions(0)=(ConstructionClass=Class'DHConstruction_SupplyCache_Italy',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=Class'DHConstruction_PlatoonHQ_Italy',Limit=-1,MaxActive=5)
    Constructions(2)=(ConstructionClass=Class'DHConstruction_VehiclePool',Limit=-1,MaxActive=-1)

    // Ammunition
    Constructions(3)=(ConstructionClass=Class'DHConstruction_Resupply_Players_Italy',Limit=-1,MaxActive=-1)
    Constructions(4)=(ConstructionClass=Class'DHConstruction_Resupply_Vehicles_Italy',Limit=-1,MaxActive=-1)
    Constructions(5)=(ConstructionClass=Class'DH_SRCMMod35GrenadeCrateConstruction',Limit=-1,MaxActive=-1)

    // Obstacles
    Constructions(10)=(ConstructionClass=Class'DHConstruction_ConcertinaWire',Limit=-1,MaxActive=-1)
    Constructions(11)=(ConstructionClass=Class'DHConstruction_Hedgehog',Limit=-1,MaxActive=-1)
    Constructions(12)=(ConstructionClass=Class'DHConstruction_DragonsTooth_Italy',Limit=-1,MaxActive=-1)

    // Guns
    Constructions(13)=(ConstructionClass=Class'DH_Cannone4732GunConstruction',Limit=5,MaxActive=-1)
    Constructions(14)=(ConstructionClass=Class'DH_Model35MortarConstruction',Limit=3,MaxActive=-1)
    Constructions(15)=(ConstructionClass=Class'DH_Fiat1435GunConstruction',Limit=5,MaxActive=-1)
}
