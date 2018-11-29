//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConstruction_Watchtower extends DHConstruction;

defaultproperties
{
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Constructions.GER_watchtower_undeployed')
    ProgressMax=12
    StaticMesh=StaticMesh'DH_Construction_stc.Constructions.GER_watchtower'
    bShouldAlignToGround=false
    bCanBeTornDownByFriendlies=false
    bCanOnlyPlaceOnTerrain=true
    bCanPlaceIndoors=false
    bCanPlaceInWater=false
    CollisionRadius=120.0
    CollisionHeight=300.0
    bShouldBlockSquadRallyPoints=true
    bLimitTerrainSurfaceTypes=true
    TerrainSurfaceTypes(0)=EST_Default
    TerrainSurfaceTypes(1)=EST_Dirt
    TerrainSurfaceTypes(2)=EST_Snow
    TerrainSurfaceTypes(3)=EST_Mud
    TerrainSurfaceTypes(4)=EST_Plant
    bIsNeutral=true
    MenuName="Watchtower"
    ProxyTraceDepthMeters=10.0
    ProxyTraceHeightMeters=5.0
    HealthMax=250
    TatteredHealthThreshold=125
    TatteredStaticMesh=StaticMesh'DH_Construction_stc.Constructions.GER_watchtower_damaged'
    BrokenLifespan=30.0
    BrokenStaticMesh=StaticMesh'DH_Construction_stc.Constructions.GER_watchtower_destroyed'
    BrokenEmitterClass=Class'DHConstruction_Watchtower_BrokenEmitter'
    BrokenSounds(0)=Sound'DH_SundrySounds.foley.CrashWood'
    StartRotationMin=(Yaw=-16384)
    StartRotationMax=(Yaw=-16384)
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.WatchTower'
    GroupClass=Class'DHConstructionGroup_Defenses'
    SupplyCost=900
    bCanTakeImpactDamage=true
    MinDamagetoHurt=25
    bAcceptsProjectors=false

    // Damage
    HarmfulDamageTypes(0)=class'DHArtilleryDamageType'                 // Artillery
    HarmfulDamageTypes(1)=class'ROTankShellExplosionDamage'         // HE Splash
    HarmfulDamageTypes(2)=class'DH_SatchelDamType'                  // Satchel
    HarmfulDamageTypes(3)=class'DHMortarDamageType'                 // Mortar
    HarmfulDamageTypes(4)=class'DHRocketImpactDamage'               // Direct AT weapon hits
    HarmfulDamageTypes(5)=class'ROTankShellImpactDamage'            // AP and HE direct hits

    DamageTypeScales(0)=(DamageType=class'DHArtilleryDamageType',Scale=1.5)
    DamageTypeScales(1)=(DamageType=class'ROTankShellExplosionDamage',Scale=0.6)
    DamageTypeScales(2)=(DamageType=class'DH_SatchelDamType',Scale=1.4)
    DamageTypeScales(3)=(DamageType=class'DHMortarDamageType',Scale=0.5)
    DamageTypeScales(4)=(DamageType=class'DHRocketImpactDamage',Scale=0.8)
    DamageTypeScales(5)=(DamageType=class'ROTankShellImpactDamage',Scale=0.4)
}

