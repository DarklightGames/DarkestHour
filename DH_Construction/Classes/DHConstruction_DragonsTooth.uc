//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_DragonsTooth extends DHConstruction;

defaultproperties
{
    // Properties
    MenuName="Dragon's Teeth"
    MenuDescription="Effective at blocking all vehicles."
    GroupClass=Class'DHConstructionGroup_Obstacles'
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
    DamageTypeScales(0)=(DamageType=Class'DHArtilleryDamageType',Scale=1.5)         // Artillery
    DamageTypeScales(1)=(DamageType=Class'ROTankShellExplosionDamage',Scale=0.5)    // HE Splash
    DamageTypeScales(2)=(DamageType=Class'DHShellHEImpactDamageType',Scale=0.8)     // HE Impact
    DamageTypeScales(3)=(DamageType=Class'ROTankShellImpactDamage',Scale=0.4)       // AP Impact
    DamageTypeScales(4)=(DamageType=Class'DHRocketImpactDamage',Scale=0.8)          // AT Rocket Impact
    DamageTypeScales(5)=(DamageType=Class'DH_SatchelDamType',Scale=1.4)             // Satchel/Grenades
    DamageTypeScales(6)=(DamageType=Class'DHMortarDamageType',Scale=0.5)            // Mortar
}

