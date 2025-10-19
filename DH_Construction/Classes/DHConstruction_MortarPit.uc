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
    CollisionRadius=130
    SupplyCost=250
    HealthMax=750

    Begin Object Class=DHConstructionSocketParameters Name=MortarSocketParams
        TagFilters(0)=(Tag=CT_Mortar)
    End Object

    // Mortar Socket
    Sockets(0)=(Parameters=MortarSocketParams)
    ConstructionTags=(CT_MortarPit)
    StartRotationMin=(Yaw=0)
    StartRotationMax=(Yaw=0)
}
