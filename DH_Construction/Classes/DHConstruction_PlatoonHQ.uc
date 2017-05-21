//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_PlatoonHQ extends DHConstruction;

#exec OBJ LOAD FILE=..\Textures\DH_Construction_tex.utx

var DHSpawnPoint_PlatoonHQ  SpawnPoint;
var ROSoundAttachment       RainSoundAttachment;
var int                     FlagSkinIndex;
var sound                   RainSound;

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

        SpawnPoint.Construction = self;
        SpawnPoint.SetLocation(HitLocation);
        SpawnPoint.SetTeamIndex(GetTeamIndex());
        SpawnPoint.SetIsActive(true);
    }
}

simulated function DestroyAttachments()
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

simulated event Destroyed()
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

function OnTeamIndexChanged()
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

// TODO: fill this in with the correct flag materials
function Material GetFlagMaterial()
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
            break;
        case NATION_Britain:
            break;
        case NATION_USSR:
            break;
        }
        break;
    }

    return Texture'DH_Construction_tex.Base.flags_01_blank';
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
    TatteredHealthThreshold=125

    SupplyCost=750

    RainSound=Sound'Amb_Weather01.Rain.Krasnyi_Rain_Inside_Heavy'

    FlagSkinIndex=1
}
