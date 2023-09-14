//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_WoodFence extends DHConstruction;

defaultproperties
{
    StaticMesh=StaticMesh'DH_Obstacles_stc.Wood.fence_rail4_12ft'
    GroupClass=class'DH_Construction.DHConstructionGroup_Debug'
    MenuName="Wood Fence"
    CollisionRadius=170
    bCanBePlacedWithControlPoints=true
}

