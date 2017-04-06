//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_PlatoonHQ extends DHConstruction;

var DHSpawnPointBase    SpawnPoint;

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
}

defaultproperties
{
    MenuName="Platoon HQ"

    StaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent'  // TODO: a proper platoon HQ bunker

    // Placement
    bShouldAlignToGround=false
    bCanPlaceIndoors=false
    DuplicateDistanceInMeters=250
    ProxyDistanceInMeters=10.0
}
