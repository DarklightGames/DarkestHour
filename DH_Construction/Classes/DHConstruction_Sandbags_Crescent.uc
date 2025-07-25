//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_Sandbags_Crescent extends DHConstruction_Sandbags;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.sandbags_01_unpacked')
    Stages(1)=(Progress=2,StaticMesh=StaticMesh'DH_Construction_stc.sandbags_02_intermediate')
    ProgressMax=4
    StaticMesh=StaticMesh'DH_Construction_stc.sandbags_02'
    MenuName="Sandbags (Crescent)"
    MenuIcon=Texture'DH_InterfaceArt2_tex.sandbags_crescent'
    CollisionHeight=100
    CollisionRadius=150
    SupplyCost=200
    HealthMax=700
}
