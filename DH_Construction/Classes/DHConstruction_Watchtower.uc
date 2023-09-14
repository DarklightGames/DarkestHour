//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    DamageTypeScales(0)=(DamageType=class'DHArtilleryDamageType',Scale=1.5)         // Artillery
    DamageTypeScales(1)=(DamageType=class'ROTankShellExplosionDamage',Scale=0.6)    // HE Splash
    DamageTypeScales(2)=(DamageType=class'DHShellHEImpactDamageType',Scale=1.5)     // HE Impact
    DamageTypeScales(3)=(DamageType=class'ROTankShellImpactDamage',Scale=0.4)       // AP Impact
    DamageTypeScales(4)=(DamageType=class'DHRocketImpactDamage',Scale=0.8)          // AT Rocket Impact
    DamageTypeScales(5)=(DamageType=class'DH_SatchelDamType',Scale=1.4)             // Satchels
    DamageTypeScales(6)=(DamageType=class'DHMortarDamageType',Scale=0.5)            // Mortar
}

