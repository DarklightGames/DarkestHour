//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_DragonsTooth extends DHConstruction;

defaultproperties
{
    // Properties
    MenuName="Dragon's Teeth"
    MenuDescription="Effective at blocking all vehicles."
    GroupClass=class'DHConstructionGroup_Obstacles'
    bCanBeMantled=true
    bIsNeutral=true
    SupplyCost=250
    CollisionRadius=60
    CollisionHeight=50
    bShouldSwitchToLastWeaponOnPlacement=false

    // Construction and Display
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.dragon_tooth'
    TatteredStaticMesh=StaticMesh'DH_Construction_stc.Obstacles.dragon_tooth_damaged'
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.dragon_tooth_unassembled',Sound=none,Emitter=none)
    ProgressMax=7
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.dragon_teeth'
    bAcceptsProjectors=false

    // Health
    MinDamagetoHurt=150
    HealthMax=1000
    TatteredHealthThreshold=300

    // Damage
    bCanTakeImpactDamage=false
    DamageTypeScales(0)=(DamageType=class'DHArtilleryDamageType',Scale=1.5)         // Artillery
    DamageTypeScales(1)=(DamageType=class'ROTankShellExplosionDamage',Scale=0.5)    // HE Splash
    DamageTypeScales(2)=(DamageType=class'DHShellHEImpactDamageType',Scale=0.8)     // HE Impact
    DamageTypeScales(3)=(DamageType=class'ROTankShellImpactDamage',Scale=0.4)       // AP Impact
    DamageTypeScales(4)=(DamageType=class'DHRocketImpactDamage',Scale=0.8)          // AT Rocket Impact
    DamageTypeScales(5)=(DamageType=class'DH_SatchelDamType',Scale=1.4)             // Satchel/Grenades
    DamageTypeScales(6)=(DamageType=class'DHMortarDamageType',Scale=0.5)            // Mortar
}

