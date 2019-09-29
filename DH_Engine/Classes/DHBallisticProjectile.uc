//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHBallisticProjectile extends ROBallisticProjectile
    abstract;

var bool    bIsArtilleryProjectile; // Whether or not we report our hits to be tracked on artillery targets.
                                    // This should not be set in defaultproperties, but should instead be
                                    // set in whatever logic block that spawns the projectile.

simulated function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority && bIsArtilleryProjectile)
    {
        SetHitLocation(HitLocation);
    }
}

// New function to set hit location in team's artillery targets so it's marked on the map for mortar crew
function SetHitLocation(vector HitLocation)
{
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo PRI;
    local int      TeamIndex;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || InstigatorController == none || InstigatorController.Pawn == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(InstigatorController.PlayerReplicationInfo);

    if (PRI == none || PRI.RoleInfo == none)
    {
        return;
    }

    TeamIndex = InstigatorController.GetTeamNum();

    // Zero out the z coordinate for 2D distance checking from targets
    HitLocation.Z = 0.0;
}

defaultproperties
{
}

