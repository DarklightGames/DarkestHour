//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_PlatoonHQ extends DHConstruction;

#exec OBJ LOAD FILE=

var DHSpawnPointBase    SpawnPoint;
var ROSoundAttachment   SoundAttachment;

var sound               RainSound;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode < NM_DedicatedServer)
    {
        SoundAttachment = Spawn(class'ROSoundAttachment');

        if (SoundAttachment != none)
        {
            SoundAttachment.SetBase(self);
            SoundAttachment.SetRelativeLocation(vect(0, 0, 250));
            SoundAttachment.AmbientSound = RainSound;
            SoundAttachment.SoundVolume = 100;
            SoundAttachment.SoundRadius = 100;
            SoundAttachment.TransientSoundRadius=100;
            SoundAttachment.TransientSoundVolume=100;
        }
    }
}

state Constructed
{
    event BeginState()
    {
        super.BeginState();

        SetTimer(1.0, true);
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

        // TODO: do a spawn test to make sure we can even do this crap?!
//        SpawnPoint.SetBase(self);
//        SpawnPoint.SetRelativeLocation(class'DHPawn'.default.CollisionHeight * vect(0, 0, 1));
        SpawnPoint.TeamIndex = GetTeamIndex();
        SpawnPoint.SetIsActive(true);
    }
}

event Destroyed()
{
    if (SpawnPoint != none)
    {
        SpawnPoint.Destroy();
    }

    if (SoundAttachment != none)
    {
        SoundAttachment.Destroy();
    }
}

defaultproperties
{
    MenuName="Platoon HQ"
    StaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent'

    // Placement
    bShouldAlignToGround=true
    bCanPlaceIndoors=false
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

    RainSound=Sound'Amb_Weather01.Rain.Krasnyi_Rain_Inside_Heavy'
}
