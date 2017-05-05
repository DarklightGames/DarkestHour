//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_Hedgehog extends DHConstruction;

defaultproperties
{
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01_unassembled',Progress=0)
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01'
    bShouldAlignToGround=true
    MenuName="Hedgehog"
    StartRotationMin=(Yaw=-16384)
    StartRotationMax=(Yaw=16384)
    CollisionHeight=60
    CollisionRadius=60
    HealthMax=250
    SupplyCost=150
}
