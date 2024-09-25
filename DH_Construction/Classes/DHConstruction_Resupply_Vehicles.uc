//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Resupply_Vehicles extends DHConstruction_Resupply
    abstract;

defaultproperties
{
    ResupplyType=RT_Vehicles
    ResupplyAttachmentCollisionRadius=600.0
    MenuName="Ammo Crate (Vehicles)"
    MenuDescription="Provides a resupply point for vehicles and guns."
    ResupplyCount=15
}
