//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_Sandbags_MortarPit extends DHConstruction_Sandbags;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.MORTAR_PIT_01')
    Stages(1)=(Progress=4,StaticMesh=StaticMesh'DH_Construction_stc.MORTAR_PIT_02')
    ProgressMax=8
    StaticMesh=StaticMesh'DH_Construction_stc.MORTAR_PIT_03'
    MenuName="Sandbags (Mortar Pit)"
    MenuIcon=Texture'DH_InterfaceArt2_tex.sandbags_crescent'
    CollisionHeight=100
    CollisionRadius=130
    SupplyCost=250
    HealthMax=750
    ConstructionTags=(CT_MortarPit)
    StartRotationMin=(Yaw=0)
    StartRotationMax=(Yaw=0)
    GroundSlopeMaxInDegrees=5.0
    Begin Object Class=DHConstructionSocketParameters Name=MortarSocketParams
        TagFilters(0)=(Operation=Include,Tag=CT_Mortar)
    End Object
    Sockets(0)=(Parameters=MortarSocketParams)
}
