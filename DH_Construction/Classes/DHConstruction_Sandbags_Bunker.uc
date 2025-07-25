//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_Sandbags_Bunker extends DHConstruction_Sandbags;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.sandbags_03_unpacked')
    Stages(1)=(Progress=4,StaticMesh=StaticMesh'DH_Construction_stc.sandbags_03_intermediate')
    ProgressMax=8
    StaticMesh=StaticMesh'DH_Construction_stc.sandbags_03'
    MenuName="Sandbags (Bunker)"
    MenuIcon=Texture'DH_InterfaceArt2_tex.sandbags_bunker'
    CollisionHeight=100
    CollisionRadius=125
    SupplyCost=350
    HealthMax=1100
}
