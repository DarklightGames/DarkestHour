//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Hedgehog extends DHConstruction;

defaultproperties
{
    BrokenEmitterClass=class'DHConstruction_Hedgehog_BrokenEmitter'
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01_unassembled',Progress=0)
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01'
    MenuName="Hedgehog"
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.hedgehog'
    MenuDescription="Effective at blocking light and medium vehicles."
    StartRotationMin=(Yaw=-16384)
    StartRotationMax=(Yaw=16384)
    CollisionHeight=60
    CollisionRadius=60
    HealthMax=400
    SupplyCost=50
    bIsNeutral=true
    bAcceptsProjectors=false
    ProgressMax=3
    GroupClass=class'DHConstructionGroup_Obstacles'
    bShouldSwitchToLastWeaponOnPlacement=false
    MinDamagetoHurt=180.0
}
