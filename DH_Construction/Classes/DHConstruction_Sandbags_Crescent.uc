//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Sandbags_Crescent extends DHConstruction;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_01_unpacked')
    Stages(1)=(Progress=4,StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_02_intermediate')
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    ProgressMax=8
    StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_02'
    bShouldAlignToGround=false
    MenuName="Sandbags (Crescent)"
    CollisionHeight=100
    CollisionRadius=150
    SupplyCost=200
    BrokenEmitterClass=class'DHConstruction_Sandbags_BrokenEmitter'
    HealthMax=300
}
