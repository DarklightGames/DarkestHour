//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Sandbags_Bunker extends DHConstruction;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_03_unpacked')
    Stages(1)=(Progress=6,StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_03_intermediate')
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    ProgressMax=12
    StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_03'
    bShouldAlignToGround=false
    MenuName="Sandbags (Bunker)"
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.sandbags_bunker'
    CollisionHeight=100
    CollisionRadius=125
    SupplyCost=500
    BrokenEmitterClass=class'DHConstruction_Sandbags_BrokenEmitter'
    HealthMax=400
    bCanTakeImpactDamage=true
    bIsNeutral=true
    bAcceptsProjectors=false
}
