//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_PlatoonHQ extends DHConstruction;

#exec OBJ LOAD FILE=..\Textures\DH_Construction_tex.utx

var DHSpawnPoint_PlatoonHQ  SpawnPoint;
var int                     FlagSkinIndex;
var sound                   RainSound;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
}

simulated function OnConstructed()
{
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;

    super.OnConstructed();

    if (Role == ROLE_Authority)
    {
        if (SpawnPoint == none)
        {
            SpawnPoint = Spawn(class'DHSpawnPoint_PlatoonHQ', self);
        }

        if (SpawnPoint != none)
        {
            // "A Platoon HQ has been constructed and will be established in N seconds."
            SpawnPoint.BroadcastTeamLocalizedMessage(GetTeamIndex(), class'DHPlatoonHQMessage', 4);

            TraceStart = Location + vect(0, 0, 32);
            TraceEnd = Location - vect(0, 0, 32);

            HitLocation = Location;

            if (Trace(HitLocation, HitNormal, TraceEnd, TraceStart) == none)
            {
                Warn("Hey yo something done fucked up, bad spawn locations afoot");
                Destroy();
            }

            HitLocation.Z += class'DHPawn'.default.CollisionHeight / 2;

            SpawnPoint.Construction = self;
            SpawnPoint.SetLocation(HitLocation);
            SpawnPoint.SetTeamIndex(GetTeamIndex());
            SpawnPoint.SetIsActive(true);
            SpawnPoint.ResetActivationTimer();
        }
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
            SpawnPoint.BroadcastTeamLocalizedMessage(GetTeamIndex(), class'DHPlatoonHQMessage', 3);
        }

        DestroyAttachments();
    }
}

function StaticMesh GetConstructedStaticMesh()
{
    switch (GetTeamIndex())
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

function static StaticMesh GetProxyStaticMesh(DHConstructionProxy CP)
{
    switch (CP.PlayerOwner.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent';
        case ALLIES_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent';
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
    MenuIcon=Texture'DH_GUI_tex.DeployMenu.PlatoonHQ'
    Stages(0)=()
    ProgressMax=12

    // Placement
    bShouldAlignToGround=true
    bCanPlaceIndoors=false
    bCanPlaceInObjective=false
    DuplicateFriendlyDistanceInMeters=250
    DuplicateEnemyDistanceInMeters=50
    ProxyDistanceInMeters=10.0
    bCanOnlyPlaceOnTerrain=true
    bCanPlaceInWater=false
    GroundSlopeMaxInDegrees=5
    SquadMemberCountMinimum=3

    StartRotationMin=(Yaw=32768)
    StartRotationMax=(Yaw=32768)

    // Collision
    CollisionHeight=120
    CollisionRadius=250

    // Health
    HealthMax=500
    TatteredHealthThreshold=250

    SupplyCost=1000

    RainSound=Sound'Amb_Weather01.Rain.Krasnyi_Rain_Inside_Heavy'

    FlagSkinIndex=1
}

