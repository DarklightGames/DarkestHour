//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Sandbags_Line extends DHConstruction;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_01_unpacked')
    Stages(1)=(Progress=4,StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_01_intermediate')
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    ProgressMax=8
    StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_01'
    bShouldAlignToGround=false
    MenuName="Sandbags (Line)"
    MenuIcon=Texture'DH_GUI_tex.ConstructionMenu.Construction_Sandbag_Line'
    CollisionHeight=100
    CollisionRadius=90
    SupplyCost=100
    BrokenEmitterClass=class'DHConstruction_Sandbags_BrokenEmitter'
    HealthMax=250
}
