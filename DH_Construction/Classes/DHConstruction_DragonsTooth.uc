//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConstruction_DragonsTooth extends DHConstruction;

defaultproperties
{
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.dragon_tooth_unassembled',Sound=none,Emitter=none)
    ProgressMax=6
    CollisionRadius=60
    CollisionHeight=50
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.dragon_tooth'
    MenuName="Dragon's Teeth"
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.dragon_teeth'
    MenuDescription="Effective at blocking all vehicles."
    SupplyCost=200
    MinDamagetoHurt=250
    HealthMax=750
    TatteredHealthThreshold=375
    TatteredStaticMesh=StaticMesh'DH_Construction_stc.Obstacles.dragon_tooth_damaged'
    bCanBeMantled=true
    bCanTakeImpactDamage=false
    bIsNeutral=true
    bAcceptsProjectors=false
    GroupClass=class'DHConstructionGroup_Obstacles'
    bShouldSwitchToLastWeaponOnPlacement=false
    bCanBeTornDownWithSupplyTruckNearby=true
}

