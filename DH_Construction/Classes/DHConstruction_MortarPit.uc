//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_MortarPit extends DHConstruction_Sandbags;

defaultproperties
{
    // Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.mortar_pit_01')
    // Stages(1)=(Progress=2,StaticMesh=StaticMesh'DH_Construction_stc.mortar_pit_02')
    //ProgressMax=4
    StaticMesh=StaticMesh'DH_Construction_stc.mortar_pit'
    MenuName="Sandbags (Mortar Pit)"
    MenuIcon=Texture'DH_InterfaceArt2_tex.sandbags_crescent'
    CollisionHeight=100
    CollisionRadius=150
    SupplyCost=250
    HealthMax=750

    // Mortar Socket
    Sockets(0)=(TagFilters=((Operation=Include,Tag=CT_Mortar)))
}
