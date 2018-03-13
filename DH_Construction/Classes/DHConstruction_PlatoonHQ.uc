//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_PlatoonHQ extends DHConstruction
    notplaceable;

#exec OBJ LOAD FILE=..\Textures\DH_Construction_tex.utx

var DHSpawnPoint_PlatoonHQ          SpawnPoint;
var int                             FlagSkinIndex;
var class<DHSpawnPoint_PlatoonHQ>   SpawnPointClass;

simulated state Constructed
{
    simulated function bool CanTakeTearDownDamageFromPawn(Pawn P, optional bool bShouldSendErrorMessage)
    {
        if (!super.CanTakeTearDownDamageFromPawn(P, bShouldSendErrorMessage))
        {
            return false;
        }

        if (SpawnPoint != none && SpawnPoint.CapturingEnemiesCount >= SpawnPoint.EnemiesNeededToCapture)
        {
            return true;
        }

        // "You must have another teammate nearby to deconstruct an enemy Platoon HQ!"
        if (Role == ROLE_Authority && bShouldSendErrorMessage)
        {
            P.ReceiveLocalizedMessage(class'DHGameMessage', 22);
        }

        return false;
    }
}

simulated function OnConstructed()
{
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;

    super.OnConstructed();

    if (Role == ROLE_Authority)
    {
        if (SpawnPoint == none)
        {
            SpawnPoint = Spawn(SpawnPointClass, self);
        }

        if (SpawnPoint != none)
        {
            // "A Platoon HQ has been constructed and will be established in N seconds."
            class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), class'DHPlatoonHQMessage', 4);

            TraceStart = Location + vect(0, 0, 32);
            TraceEnd = Location - vect(0, 0, 32);
            HitLocation = Location;

            if (Trace(HitLocation, HitNormal, TraceEnd, TraceStart) == none)
            {
                Warn("Hey yo something done fucked up, bad spawn locations afoot");
                Destroy();
            }

            HitLocation.Z += class'DHPawn'.default.CollisionHeight / 2;

            SpawnPoint.Construction = self; // TODO: could this be eliminated? The spawn point already has this construction set as the owner!
            SpawnPoint.SetLocation(HitLocation);
            SpawnPoint.SetTeamIndex(GetTeamIndex());
            SpawnPoint.SetIsActive(true);
            SpawnPoint.ResetActivationTimer();
        }

        // TODO: Find any nearby friendly "Build Platoon HQ" icons within 50m and remove them.
    }
}

simulated function DestroyAttachments()
{
    if (SpawnPoint != none)
    {
        SpawnPoint.Destroy();
    }
}

simulated function Destroyed()
{
    DestroyAttachments();
}

simulated state Broken
{
    simulated function BeginState()
    {
        super.BeginState();

        if (SpawnPoint != none)
        {
            // "A Platoon HQ has been destroyed."
            class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), class'DHPlatoonHQMessage', 3);
        }

        DestroyAttachments();
    }
}

static function StaticMesh GetConstructedStaticMesh(DHConstruction.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent';
        case ALLIES_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent';
    }
}

function StaticMesh GetBrokenStaticMesh()
{
    switch (GetTeamIndex())
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_destroyed';
        case ALLIES_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_destroyed';
    }
}

function StaticMesh GetStageStaticMesh(int StageIndex)
{
    switch (GetTeamIndex())
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_unpacked';
        case ALLIES_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_unpacked';
    }
}

function StaticMesh GetTatteredStaticMesh()
{
    switch (GetTeamIndex())
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_light_destro';
        case ALLIES_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_light_destro';
    }
}

simulated function OnTeamIndexChanged()
{
    local Material FlagMaterial;

    super.OnTeamIndexChanged();

    if (FlagSkinIndex != -1)
    {
        FlagMaterial = GetFlagMaterial();

        if (FlagMaterial != none)
        {
            Skins[FlagSkinIndex] = FlagMaterial;
        }
    }
}

simulated function Material GetFlagMaterial()
{
    switch (GetTeamIndex())
    {
    case AXIS_TEAM_INDEX:
        return Texture'DH_Construction_tex.Base.GER_flag_01';
    case ALLIES_TEAM_INDEX:
        switch (LevelInfo.AlliedNation)
        {
        case NATION_USA:
            return Texture'DH_Construction_tex.Base.USA_flag_01';
        case NATION_Canada:
            return Texture'DH_Construction_tex.Base.CAN_flag_01';
        case NATION_Britain:
            return Texture'DH_Construction_tex.Base.BRIT_flag_01';
        case NATION_USSR:
            return Texture'DH_Construction_tex.Base.SOVIET_flag_01';
        }
        break;
    }

    return Texture'DH_Construction_tex.Base.flags_01_blank';
}

defaultproperties
{
    MenuName="Platoon HQ"
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.platoon_hq'
    MenuDescription="Provides a team-wide spawn point."
    Stages(0)=()
    ProgressMax=9
    SupplyCost=750

    // Placement
    bCanPlaceIndoors=false
    bCanPlaceInObjective=false
    DuplicateFriendlyDistanceInMeters=200
    DuplicateEnemyDistanceInMeters=50
    ProxyTraceDepthMeters=10.0
    bCanOnlyPlaceOnTerrain=true
    bCanPlaceInWater=false
    GroundSlopeMaxInDegrees=10
    SquadMemberCountMinimum=3
    ArcLengthTraceIntervalInMeters=0.5

    StartRotationMin=(Yaw=32768)
    StartRotationMax=(Yaw=32768)

    // Collision
    CollisionHeight=120
    CollisionRadius=250

    // Health
    HealthMax=500
    TatteredHealthThreshold=250

    FlagSkinIndex=1
    SpawnPointClass=class'DHSpawnPoint_PlatoonHQ'
    bCanBeTornDownByFriendlies=false
    FriendlyFireDamageScale=0.0
    ObjectiveDistanceMinMeters=75
    EnemyObjectiveDistanceMinMeters=150
    GroupClass=class'DHConstructionGroup_Logistics'
}

