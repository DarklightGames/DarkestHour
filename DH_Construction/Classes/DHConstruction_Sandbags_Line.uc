//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_Sandbags_Line extends DHConstruction_Sandbags;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.sandbags_01_unpacked')
    Stages(1)=(Progress=2,StaticMesh=StaticMesh'DH_Construction_stc.sandbags_01_intermediate')
    ProgressMax=4
    StaticMesh=StaticMesh'DH_Construction_stc.sandbags_01'
    MenuName="Sandbags (Line)"
    MenuIcon=Texture'DH_InterfaceArt2_tex.sandbags_line'
    CollisionHeight=100
    CollisionRadius=90
    SupplyCost=100
    HealthMax=500
}
