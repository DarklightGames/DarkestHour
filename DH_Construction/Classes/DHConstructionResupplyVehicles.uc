//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionResupplyVehicles extends DHConstruction_Resupply
    abstract;

defaultproperties
{
    ResupplyType=RT_Vehicles
    ResupplyAttachmentCollisionRadius=600.0
    MenuName="Ammo Crate (Vehicles)"
    MenuDescription="Provides a resupply point for vehicles and guns."
    ResupplyCount=25
}
