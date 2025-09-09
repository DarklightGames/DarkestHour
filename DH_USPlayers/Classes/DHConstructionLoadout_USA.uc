//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionLoadout_USA extends DHConstructionLoadout
    abstract;

defaultproperties
{
    // Logistics
    Constructions(0)=(ConstructionClass=Class'DHConstruction_SupplyCache_USA',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=Class'DHConstruction_PlatoonHQ_USA',Limit=-1,MaxActive=5)
    Constructions(2)=(ConstructionClass=Class'DHConstruction_VehiclePool',Limit=-1,MaxActive=-1)

    // Ammunition
    Constructions(3)=(ConstructionClass=Class'DHConstruction_Resupply_Players_USA',Limit=-1,MaxActive=-1)
    Constructions(4)=(ConstructionClass=Class'DHConstruction_Resupply_Vehicles_USA',Limit=-1,MaxActive=-1)
    Constructions(5)=(ConstructionClass=Class'DH_M1GrenadeCrateConstruction',Limit=-1,MaxActive=-1)

    // Defenses
    Constructions(6)=(ConstructionClass=Class'DHConstruction_Foxhole',Limit=-1,MaxActive=-1)
    Constructions(7)=(ConstructionClass=Class'DHConstruction_Sandbags_Line',Limit=-1,MaxActive=-1)
    Constructions(8)=(ConstructionClass=Class'DHConstruction_Sandbags_Crescent',Limit=-1,MaxActive=-1)
    Constructions(9)=(ConstructionClass=Class'DHConstruction_Sandbags_Bunker',Limit=-1,MaxActive=-1)

    // Obstacles
    Constructions(10)=(ConstructionClass=Class'DHConstruction_ConcertinaWire',Limit=-1,MaxActive=-1)
    Constructions(11)=(ConstructionClass=Class'DHConstruction_Hedgehog',Limit=-1,MaxActive=-1)
    Constructions(12)=(ConstructionClass=Class'DHConstruction_DragonsTooth',Limit=-1,MaxActive=-1)

    // Guns
    Constructions(13)=(ConstructionClass=Class'DH_AT57GunConstruction',Limit=5,MaxActive=-1)
    Constructions(14)=(ConstructionClass=Class'DH_M5GunConstruction',Limit=3,MaxActive=-1)
    Constructions(15)=(ConstructionClass=Class'DH_M1MortarConstruction',Limit=3,MaxActive=-1)
    Constructions(16)=(ConstructionClass=Class'DH_M116GunConstruction',Limit=3,MaxActive=-1)
    Constructions(17)=(ConstructionClass=Class'DH_M1919A4GunConstruction',Limit=6,MaxActive=-1)
    Constructions(18)=(ConstructionClass=Class'DH_M2MortarConstruction',Limit=3,MaxActive=-1)
}
