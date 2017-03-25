//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_PlatoonHQ extends DHConstruction;

var DHSpawnPointBase    SpawnPoint;

state Constructed
{
    function Timer()
    {
        // TODO: get nearby enemy count within a certain radius (defined somewhere)
        // TODO: check for enemies nearby, allow them to capture the area!
    }
Begin:
    SetTimer(1.0, true);
};


function OnConstructed()
{
    SpawnPoint = Spawn(class'DHSpawnPoint_PlatoonHQ', self);

    if (SpawnPoint != none)
    {
        SpawnPoint.SetBase(self);
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
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'  // TODO: a proper platoon HQ bunker
    bShouldAlignToGround=true
    MenuName="Platoon HQ"
    DuplicateDistanceInMeters=250
}
