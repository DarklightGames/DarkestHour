//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_Hedgehog extends DHConstruction;

defaultproperties
{
    BrokenEmitterClass=Class'DHConstruction_Hedgehog_BrokenEmitter'
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.hedgehog_01_unassembled',Progress=0)
    StaticMesh=StaticMesh'DH_Construction_stc.hedgehog_01'
    MenuName="Hedgehog"
    MenuIcon=Texture'DH_InterfaceArt2_tex.hedgehog'
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
    GroupClass=Class'DHConstructionGroup_Obstacles'
    bShouldSwitchToLastWeaponOnPlacement=false
    MinDamagetoHurt=180.0
}
