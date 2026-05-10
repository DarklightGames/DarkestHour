//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionLoadout_Canada extends DHConstructionLoadout_Britain
    abstract;

defaultproperties
{
    // Logistics
    Constructions(0)=(ConstructionClass=Class'DHConstruction_SupplyCache_Canada',Limit=-1,MaxActive=-1)
    Constructions(1)=(ConstructionClass=Class'DHConstruction_PlatoonHQ_Canada',Limit=-1,MaxActive=5)
}