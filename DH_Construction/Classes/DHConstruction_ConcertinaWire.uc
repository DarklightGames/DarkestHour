//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_ConcertinaWire extends DHConstruction;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_01_unassembled',Sound=none,Emitter=none)
    ProgressMax=3
    CollisionRadius=90
    CollisionHeight=50
    BrokenStaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_destro_01'
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'
    MenuName="Concertina Wire"
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.barbed_wire'
    SupplyCost=50
    HealthMax=250
    bCanBeMantled=false
    bCanTakeImpactDamage=true
    bIsNeutral=true
    bAcceptsProjectors=false
}
