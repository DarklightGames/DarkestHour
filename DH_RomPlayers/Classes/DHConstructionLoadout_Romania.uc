//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionLoadout_Romania extends DHConstructionLoadout
    abstract;

defaultproperties
{
    // Logistics
    Constructions(0)=(ConstructionClass=Class'DHConstruction_SupplyCache_Romania',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=Class'DHConstruction_PlatoonHQ_Romania',Limit=-1,MaxActive=5)
    Constructions(2)=(ConstructionClass=Class'DHConstruction_VehiclePool',Limit=-1,MaxActive=-1)

    // Ammunition
    Constructions(3)=(ConstructionClass=Class'DHConstruction_Resupply_Players_Romania',Limit=-1,MaxActive=-1)
    Constructions(5)=(ConstructionClass=Class'DH_StielGranateCrateConstruction',Limit=-1,MaxActive=-1) //not strictly wrong, but ideally should have their own eventually
    //Constructions(6)  romania didnt really have any anti-tank purposed hand held weapons (except for basic explosives) until they received some panzerfausts later on

    // Defenses
    Constructions(6)=(ConstructionClass=Class'DHConstruction_Foxhole',Limit=-1,MaxActive=-1)
    Constructions(7)=(ConstructionClass=Class'DHConstruction_Sandbags_Line',Limit=-1,MaxActive=-1)
    Constructions(8)=(ConstructionClass=Class'DHConstruction_Sandbags_Crescent',Limit=-1,MaxActive=-1)
    Constructions(9)=(ConstructionClass=Class'DHConstruction_Sandbags_Bunker',Limit=-1,MaxActive=-1)

    // Obstacles
    Constructions(10)=(ConstructionClass=Class'DHConstruction_ConcertinaWire',Limit=-1,MaxActive=-1)
    Constructions(11)=(ConstructionClass=Class'DHConstruction_Hedgehog',Limit=-1,MaxActive=-1)
    Constructions(12)=(ConstructionClass=Class'DHConstruction_DragonsTooth',Limit=-1,MaxActive=-1)

    // Guns  // while these guns were used by romania, they should eventually get different artillery guns besides these
    // as of now, these are semi-accurate placeholder guns
    Constructions(13)=(ConstructionClass=Class'DH_Cannone4732GunConstruction',Limit=5,MaxActive=-1)
    Constructions(14)=(ConstructionClass=Class'DH_Pak38ATGunConstruction',Limit=3,MaxActive=-1)
    Constructions(15)=(ConstructionClass=Class'DH_Pak40ATGunConstruction',Limit=3,MaxActive=-1)
}
