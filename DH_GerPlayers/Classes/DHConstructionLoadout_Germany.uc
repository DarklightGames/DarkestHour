//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstructionLoadout_Germany extends DHConstructionLoadout
    abstract;

defaultproperties
{
    // Logistics
    Constructions(0)=(ConstructionClass=class'DH_GerPlayers.DHConstruction_SupplyCache_Germany',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=class'DH_GerPlayers.DHConstruction_PlatoonHQ_Germany',Limit=-1,MaxActive=5)
    Constructions(2)=(ConstructionClass=class'DH_Construction.DHConstruction_VehiclePool',Limit=-1,MaxActive=-1)

    // Ammunition
    Constructions(3)=(ConstructionClass=class'DH_GerPlayers.DHConstruction_Resupply_Players_Germany',Limit=-1,MaxActive=-1)
    Constructions(4)=(ConstructionClass=class'DH_Construction.DHConstruction_Resupply_Vehicles',Limit=-1,MaxActive=-1)
    Constructions(5)=(ConstructionClass=class'DH_Construction.DHConstruction_GrenadeCrate',Limit=-1,MaxActive=-1)
    Constructions(6)=(ConstructionClass=class'DH_Construction.DHConstruction_AntiTankCrate',Limit=-1,MaxActive=-1)

    // Defenses
    Constructions(7)=(ConstructionClass=class'DH_Construction.DHConstruction_Foxhole',Limit=-1,MaxActive=-1)
    Constructions(8)=(ConstructionClass=class'DH_Construction.DHConstruction_Sandbags_Line',Limit=-1,MaxActive=-1)
    Constructions(9)=(ConstructionClass=class'DH_Construction.DHConstruction_Sandbags_Crescent',Limit=-1,MaxActive=-1)
    Constructions(10)=(ConstructionClass=class'DH_Construction.DHConstruction_Sandbags_Bunker',Limit=-1,MaxActive=-1)

    // Obstacles
    Constructions(11)=(ConstructionClass=class'DH_Construction.DHConstruction_ConcertinaWire',Limit=-1,MaxActive=-1)
    Constructions(12)=(ConstructionClass=class'DH_Construction.DHConstruction_Hedgehog',Limit=-1,MaxActive=-1)
    Constructions(13)=(ConstructionClass=class'DH_Construction.DHConstruction_DragonsTooth',Limit=-1,MaxActive=-1)

    Constructions(14)=(ConstructionClass=class'DH_Guns.DH_Pak38ATGunConstruction',Limit=5,MaxActive=-1)
    Constructions(15)=(ConstructionClass=class'DH_Guns.DH_Pak40ATGunConstruction',Limit=5,MaxActive=-1)
    Constructions(16)=(ConstructionClass=class'DH_Guns.DH_Pak43ATGunConstruction',Limit=5,MaxActive=-1)
    Constructions(17)=(ConstructionClass=class'DH_Guns.DH_Flak38GunConstruction',Limit=5,MaxActive=-1)
    Constructions(18)=(ConstructionClass=class'DH_Guns.DH_Flak88GunConstruction',Limit=5,MaxActive=-1)
    Constructions(19)=(ConstructionClass=class'DH_Guns.DH_Leig18GunConstruction',Limit=3,MaxActive=-1)
}
