//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Hedgehog extends DHConstruction;

defaultproperties
{
    BrokenEmitterClass=class'DHConstruction_Hedgehog_BrokenEmitter'
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01_unassembled',Progress=0)
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01'
    bShouldAlignToGround=true
    MenuName="Hedgehog"
    MenuIcon=Texture'DH_GUI_tex.ConstructionMenu.Construction_Hedgehog'
    StartRotationMin=(Yaw=-16384)
    StartRotationMax=(Yaw=16384)
    CollisionHeight=60
    CollisionRadius=60
    HealthMax=500
    SupplyCost=150
}
