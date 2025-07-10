//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionLoadout_USSR extends DHConstructionLoadout
    abstract;

defaultproperties
{
    // Logistics
    Constructions(0)=(ConstructionClass=Class'DHConstruction_SupplyCache_USSR',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=Class'DHConstruction_PlatoonHQ_USSR',Limit=-1,MaxActive=5)
    Constructions(2)=(ConstructionClass=Class'DHConstruction_VehiclePool',Limit=-1,MaxActive=-1)

    // Ammunition
    Constructions(3)=(ConstructionClass=Class'DHConstruction_Resupply_Players_USSR',Limit=-1,MaxActive=-1)
    Constructions(4)=(ConstructionClass=Class'DHConstruction_Resupply_Vehicles_USSR',Limit=-1,MaxActive=-1)
    Constructions(5)=(ConstructionClass=Class'DH_F1GrenadeCrateConstruction',Limit=-1,MaxActive=-1)

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
    // TODO: there are also "late" versions; maybe just make them variants.
    Constructions(13)=(ConstructionClass=Class'DH_Zis3GunConstruction',Limit=5,MaxActive=-1)
    Constructions(14)=(ConstructionClass=Class'DH_Zis2GunConstruction',Limit=3,MaxActive=-1)
    Constructions(15)=(ConstructionClass=Class'DH_M1927GunConstruction',Limit=5,MaxActive=-1)
    Constructions(16)=(ConstructionClass=Class'DH_45mmM1942GunConstruction',Limit=2,MaxActive=-1)
    Constructions(17)=(ConstructionClass=Class'DH_BM36MortarConstruction',Limit=3,MaxActive=-1)
}
