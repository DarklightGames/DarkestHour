//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConstruction_ConcertinaWire extends DHConstruction;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_01_unassembled',Sound=none,Emitter=none)
    ProgressMax=2
    CollisionRadius=90
    CollisionHeight=50
    BrokenStaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_destro_01'
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'
    MenuName="Concertina Wire"
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.barbed_wire'
    MenuDescription="Effective at blocking infantry and light vehicles."
    SupplyCost=25
    HealthMax=250
    bCanBeMantled=false
    bCanTakeImpactDamage=true
    bIsNeutral=true
    bAcceptsProjectors=false
    GroupClass=class'DHConstructionGroup_Obstacles'
}
