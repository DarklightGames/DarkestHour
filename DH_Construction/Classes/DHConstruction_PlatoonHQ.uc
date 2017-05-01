//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_PlatoonHQ extends DHConstruction;

var DHSpawnPointBase    SpawnPoint;
var ROSoundAttachment   RainSoundAttachment;

var sound               RainSound;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
}

simulated state Constructed
{
    simulated function BeginState()
    {
        super.BeginState();

        if (Role == ROLE_Authority)
        {
            SetTimer(1.0, true);
        }

        if (Level.NetMode < NM_DedicatedServer)
        {
            if (RainSoundAttachment != none)
            {
                RainSoundAttachment.Destroy();
            }

            if (LevelInfo != none && LevelInfo.Weather == WEATHER_Rainy)
            {
                RainSoundAttachment = Spawn(class'ROSoundAttachment');

                if (RainSoundAttachment != none)
                {
                    RainSoundAttachment.SetBase(self);
                    RainSoundAttachment.SetRelativeLocation(vect(0, 0, 250));
                    RainSoundAttachment.AmbientSound = RainSound;
                    RainSoundAttachment.SoundVolume = 100;
                    RainSoundAttachment.SoundRadius = 100;
                    RainSoundAttachment.TransientSoundRadius=100;
                    RainSoundAttachment.TransientSoundVolume=100;
                }
            }
        }
    }

    function Timer()
    {
        // TODO: get nearby enemy count within a certain radius (defined somewhere)
        // TODO: check for enemies nearby, allow them to capture the area!
    }
}


function OnConstructed()
{
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;

    super.OnConstructed();

    SpawnPoint = Spawn(class'DHSpawnPoint_PlatoonHQ', self);

    if (SpawnPoint != none)
    {
        TraceStart = Location + vect(0, 0, 32);
        TraceEnd = Location - vect(0, 0, 32);

        HitLocation = Location;

        if (Trace(HitLocation, HitNormal, TraceEnd, TraceStart) == none)
        {
            Warn("Hey yo something done fucked up, bad spawn locations afoot");
            Destroy();
        }

        HitLocation.Z += class'DHPawn'.default.CollisionHeight / 2;

        SpawnPoint.SetLocation(HitLocation);
        SpawnPoint.TeamIndex = GetTeamIndex();
        SpawnPoint.SetIsActive(true);
    }
}

function DestroyAttachments()
{
    if (SpawnPoint != none)
    {
        SpawnPoint.Destroy();
    }

    if (RainSoundAttachment != none)
    {
        RainSoundAttachment.Destroy();
    }
}

event Destroyed()
{
    DestroyAttachments();
}

simulated state Broken
{
    simulated function BeginState()
    {
        super.BeginState();

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

defaultproperties
{
    MenuName="Platoon HQ"
    Stages(0)=()
    ProgressMax=4

    // Placement
    bShouldAlignToGround=true
    bCanPlaceIndoors=false
    bCanPlaceInObjective=false
    DuplicateDistanceInMeters=250
    ProxyDistanceInMeters=10.0
    bCanOnlyPlaceOnTerrain=true
    bCanPlaceInWater=false
    GroundSlopeMaxInDegrees=5

    StartRotationMin=(Yaw=32768)
    StartRotationMax=(Yaw=32768)

    // Collision
    CollisionHeight=120
    CollisionRadius=250

    // Health
    HealthMax=250

    RainSound=Sound'Amb_Weather01.Rain.Krasnyi_Rain_Inside_Heavy'
}
