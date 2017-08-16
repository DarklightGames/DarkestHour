//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Sandbags_Bunker extends DHConstruction;

defaultproperties
{
    bAcceptsProjectors=false
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_03_unpacked')
    Stages(1)=(Progress=6,StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_03_intermediate')
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    ProgressMax=12
    StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_03'
    bShouldAlignToGround=false
    MenuName="Sandbags (Bunker)"
    CollisionHeight=100
    CollisionRadius=90
    SupplyCost=500
    BrokenEmitterClass=class'DHConstruction_Sandbags_BrokenEmitter'
    HealthMax=400
}
