//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionLoadout_Poland extends DHConstructionLoadout_USSR
    abstract;

defaultproperties
{
    // Logistics
    Constructions(0)=(ConstructionClass=Class'DHConstruction_SupplyCache_Poland',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=Class'DHConstruction_PlatoonHQ_Poland',Limit=-1,MaxActive=5)

    // Guns
    Constructions(9)=(ConstructionClass=Class'DH_Zis3GunLateConstruction',Limit=5,MaxActive=-1)
}