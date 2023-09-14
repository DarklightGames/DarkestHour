//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_ConcertinaWire extends DHConstruction;

simulated function bool CanBeCut()
{
    return StaticMesh == default.StaticMesh;
}

function CutConstruction(Pawn InstigatedBy)
{
    if (CanBeCut())
    {
        GotoState('Cut');
    }
}

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_01_unassembled')
    Stages(1)=(Progress=2,StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_01_assembled')
    ProgressMax=4
    CollisionRadius=80
    CollisionHeight=50
    CutDuration=4.0
    CutStaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02_cut'
    CutSound=Sound'DH_Obstacles.Barbed.FenceBreaking'
    CutSoundRadius=180.0
    CutSoundVolume=1.0
    bBreakOnTearDown=true
    BrokenStaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_destro_01'
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'
    MenuName="Concertina Wire"
    PlacementSound=Sound'DH_ConstructionSounds.ConcertinaWire.ConcertinaWire_Unraveling'
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.barbed_wire'
    MenuDescription="Effective at blocking infantry and light vehicles."
    SupplyCost=50
    HealthMax=250
    bCanBeMantled=false
    bCanTakeImpactDamage=true
    bIsNeutral=true
    bAcceptsProjectors=false
    GroupClass=class'DHConstructionGroup_Obstacles'
    bShouldSwitchToLastWeaponOnPlacement=false
    TakeDownProgressInterval=0.1666 // 24 hits (ProgressMax / Desired Hits)
    MinDamagetoHurt=180.0

    //SquadMemberCountMinimum=1 // DEBUG USE
}

