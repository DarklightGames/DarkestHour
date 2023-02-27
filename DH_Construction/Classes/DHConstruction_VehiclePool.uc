//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_VehiclePool extends DHConstruction;

var class<DHSpawnPoint> SpawnPointClass;
var DHSpawnPoint        SpawnPoint;

simulated function OnConstructed()
{
    super.OnConstructed();

    if (Role == ROLE_Authority)
    {
        SpawnPoint = Spawn(SpawnPointClass, self);

        if (SpawnPoint == none)
        {
            Warn("Error creating spawn point!");
            Destroy();
        }

        SpawnPoint.SetTeamIndex(GetTeamIndex());
        SpawnPoint.SetBase(self);
        SpawnPoint.SetRelativeLocation(vect(64.0, 0, 32.0));
        SpawnPoint.SetRelativeRotation(rot(0, 0, 0));
    }
}

simulated function OnBroken()
{
    super.OnBroken();

    if (Role == ROLE_Authority)
    {
        if (SpawnPoint != none)
        {
            SpawnPoint.Destroy();
        }
    }
}

simulated event Destroyed()
{
    super.Destroyed();

    if (Role == ROLE_Authority)
    {
        if (SpawnPoint != none)
        {
            SpawnPoint.Destroy();
        }
    }
}

defaultproperties
{
    MenuName="Vehicle Pool"
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.motorpool'
    MenuDescription="Provides a team-wide vehicle spawn point."
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_Light_Vehicle_Pool_undeployed')
    ProgressMax=12
    SupplyCost=1500
    MinDamagetoHurt=5

    // Temp
    StaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_Light_Vehicle_Pool'

    // Placement
    bCanPlaceIndoors=false
    bCanPlaceInObjective=false
    DuplicateFriendlyDistanceInMeters=200.0
    DuplicateEnemyDistanceInMeters=200.0
    ObjectiveDistanceMinMeters=100.0
    EnemyObjectiveDistanceMinMeters=300.0
    ProxyTraceDepthMeters=10.0
    bCanOnlyPlaceOnTerrain=true
    bCanPlaceInWater=false
    GroundSlopeMaxInDegrees=10
    SquadMemberCountMinimum=3
    ArcLengthTraceIntervalInMeters=0.5
    ProximityRequirements(0)=(ConstructionClass=class'DHConstruction_PlatoonHQ',DistanceMeters=100.0)
    bCanBePlacedInDangerZone=false

    // Collision
    CollisionHeight=120.0
    CollisionRadius=300.0

    // Health
    HealthMax=200

    // Damage
    bCanTakeImpactDamage=true

    // Group Class
    SpawnPointClass=class'DHSpawnPoint_VehiclePool'
    GroupClass=class'DHConstructionGroup_Logistics'

    // Rules
    bCanBeTornDownByFriendlies=false
    FriendlyFireDamageScale=0.0

    CompletionPointValue=500
}

