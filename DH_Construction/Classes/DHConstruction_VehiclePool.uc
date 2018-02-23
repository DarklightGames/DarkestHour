//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
        SpawnPoint.SetRelativeLocation(vect(0, 0, 32.0));
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
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_Light_Vehicle_Pool_undeployed')
    ProgressMax=4   // TODO: make this larger later
    SpawnPointClass=class'DHSpawnPoint_VehiclePool'
    StaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_Light_Vehicle_Pool'
    MenuName="Vehicle Pool"
    ProxyTraceDepthMeters=10.0
    bHidden=false
    CollisionRadius=300.0
    CollisionHeight=60.0
    GroupClass=class'DHConstructionGroup_Logistics'
}

