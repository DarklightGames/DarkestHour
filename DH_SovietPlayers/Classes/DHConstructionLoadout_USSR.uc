//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstructionLoadout_USSR extends DHConstructionLoadout
    abstract;

defaultproperties
{
    // Logistics
    Constructions(0)=(ConstructionClass=class'DHConstruction_SupplyCache_USSR',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=class'DHConstruction_PlatoonHQ_USSR',Limit=-1,MaxActive=5)
    Constructions(2)=(ConstructionClass=class'DHConstruction_VehiclePool',Limit=-1,MaxActive=-1)

    // Ammunition
    Constructions(3)=(ConstructionClass=class'DHConstruction_Resupply_Players_USSR',Limit=-1,MaxActive=-1)
    Constructions(4)=(ConstructionClass=class'DHConstruction_Resupply_Vehicles_USSR',Limit=-1,MaxActive=-1)
    Constructions(5)=(ConstructionClass=class'DH_F1GrenadeCrateConstruction',Limit=-1,MaxActive=-1)

    // Defenses
    Constructions(6)=(ConstructionClass=class'DHConstruction_Foxhole',Limit=-1,MaxActive=-1)
    Constructions(7)=(ConstructionClass=class'DHConstruction_Sandbags_Line',Limit=-1,MaxActive=-1)
    Constructions(8)=(ConstructionClass=class'DHConstruction_Sandbags_Crescent',Limit=-1,MaxActive=-1)
    Constructions(9)=(ConstructionClass=class'DHConstruction_Sandbags_Bunker',Limit=-1,MaxActive=-1)

    // Obstacles
    Constructions(10)=(ConstructionClass=class'DHConstruction_ConcertinaWire',Limit=-1,MaxActive=-1)
    Constructions(11)=(ConstructionClass=class'DHConstruction_Hedgehog',Limit=-1,MaxActive=-1)
    Constructions(12)=(ConstructionClass=class'DHConstruction_DragonsTooth',Limit=-1,MaxActive=-1)

    // Guns
    Constructions(13)=(ConstructionClass=class'DH_Zis3GunConstruction',Limit=5,MaxActive=-1)
    Constructions(14)=(ConstructionClass=class'DH_Zis2GunConstruction',Limit=3,MaxActive=-1)
    Constructions(15)=(ConstructionClass=class'DH_M1927GunConstruction',Limit=5,MaxActive=-1)
    Constructions(16)=(ConstructionClass=class'DH_45mmM1942GunConstruction',Limit=2,MaxActive=-1)
    Constructions(17)=(ConstructionClass=class'DH_BM36MortarConstruction',Limit=3,MaxActive=-1)
}
