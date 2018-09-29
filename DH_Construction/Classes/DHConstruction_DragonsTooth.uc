//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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
    MinDamagetoHurt=125
    HealthMax=750
    TatteredHealthThreshold=300

    // Damage
    bCanTakeImpactDamage=false
    HarmfulDamageTypes(0)=class'ROArtilleryDamType'                 // Artillery
    HarmfulDamageTypes(1)=class'ROTankShellExplosionDamage'         // HE Splash
    HarmfulDamageTypes(2)=class'DH_SatchelDamType'                  // Satchel
    HarmfulDamageTypes(3)=class'DHMortarDamageType'                 // Mortar
    HarmfulDamageTypes(4)=class'DHRocketImpactDamage'               // Direct AT weapon hits
    HarmfulDamageTypes(5)=class'ROTankShellImpactDamage'            // AP and HE direct hits

    DamageTypeScales(0)=(DamageType=class'ROArtilleryDamType',Scale=1.5)
    DamageTypeScales(1)=(DamageType=class'ROTankShellExplosionDamage',Scale=0.6)
    DamageTypeScales(2)=(DamageType=class'DH_SatchelDamType',Scale=1.4)
    DamageTypeScales(3)=(DamageType=class'DHMortarDamageType',Scale=0.5)
    DamageTypeScales(4)=(DamageType=class'DHRocketImpactDamage',Scale=0.8)
    DamageTypeScales(5)=(DamageType=class'ROTankShellImpactDamage',Scale=0.4)
}

