//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionLoadout_Germany extends DHConstructionLoadout
    abstract;

defaultproperties
{
    // Sandbags
    Loadouts(0)=Class'DHConstructionLoadout_Sandbags'

    // Logistics
    Constructions(0)=(ConstructionClass=Class'DHConstruction_SupplyCache_Germany',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=Class'DHConstruction_PlatoonHQ_Germany',Limit=-1,MaxActive=5)
    Constructions(2)=(ConstructionClass=Class'DHConstruction_VehiclePool',Limit=-1,MaxActive=-1)

    // Ammunition
    Constructions(3)=(ConstructionClass=Class'DHConstruction_Resupply_Players_Germany',Limit=-1,MaxActive=-1)
    Constructions(4)=(ConstructionClass=Class'DHConstruction_Resupply_Vehicles_Germany',Limit=-1,MaxActive=-1)
    Constructions(5)=(ConstructionClass=Class'DH_StielGranateCrateConstruction',Limit=-1,MaxActive=-1)
    Constructions(6)=(ConstructionClass=Class'DH_PanzerfaustCrateConstruction',Limit=6,MaxActive=-1)

    // Obstacles
    Constructions(7)=(ConstructionClass=Class'DHConstruction_ConcertinaWire',Limit=-1,MaxActive=-1)
    Constructions(8)=(ConstructionClass=Class'DHConstruction_Hedgehog',Limit=-1,MaxActive=-1)
    Constructions(9)=(ConstructionClass=Class'DHConstruction_DragonsTooth',Limit=-1,MaxActive=-1)

    Constructions(10)=(ConstructionClass=Class'DH_MG34LafetteGunConstruction',Limit=3,MaxActive=-1)
    Constructions(11)=(ConstructionClass=Class'DH_Granatwerfer34MortarConstruction',Limit=3,MaxActive=-1)
    Constructions(12)=(ConstructionClass=Class'DH_Pak36ATGunConstruction',Limit=3,MaxActive=-1)
    Constructions(13)=(ConstructionClass=Class'DH_Pak38ATGunConstruction',Limit=3,MaxActive=-1)
    Constructions(14)=(ConstructionClass=Class'DH_Pak40ATGunConstruction',Limit=3,MaxActive=-1)
    Constructions(15)=(ConstructionClass=Class'DH_Flak38GunConstruction',Limit=2,MaxActive=-1)
    Constructions(16)=(ConstructionClass=Class'DH_Flak88GunConstruction',Limit=2,MaxActive=-1)
    Constructions(17)=(ConstructionClass=Class'DH_Leig18GunConstruction',Limit=2,MaxActive=-1)
}
