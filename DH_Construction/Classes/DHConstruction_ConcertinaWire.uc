//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_ConcertinaWire extends DHConstruction;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_01_unassembled',Sound=none,Emitter=none)
    Stages(1)=(Progress=4,StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_01_intermediate',Sound=none,Emitter=none)
    ProgressMax=8
    CollisionRadius=90
    CollisionHeight=50
    BrokenStaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_destro_01'
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'
    bShouldAlignToGround=true
    MenuName="Concertina Wire"
    MenuIcon=Texture'DH_GUI_tex.ConstructionMenu.Construction_WireBarricade'
    SupplyCost=50
    bCanBeMantled=false
    bCanTakeImpactDamage=true
}
