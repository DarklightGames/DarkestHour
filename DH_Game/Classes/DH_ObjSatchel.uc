//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ObjSatchel extends ROObjSatchel;

// Matt: modified to use cast to DHThrowableExplosiveProjectile instead of ROSatchelChargeProjectile
// DH_SatchelCharge10lb10sProjectile no longer extends ROSatchelChargeProjectile, so wouldn't be recognised here
// And we can't simply cast to DH_SatchelCharge10lb10sProjectile, because of compiler build order & dependencies
// So have moved SavedInstigator & SavedPRI variables from satchel projectile into DHThrowableExplosiveProjectile
function Trigger(Actor Other, Pawn EventInstigator)
{
    local PlayerReplicationInfo SavedPRI;

    if (!bActive || ROTeamGame(Level.Game) == none || !ROTeamGame(Level.Game).IsInState('RoundInPlay'))
    {
        return;
    }

    if (EventInstigator != none && EventInstigator.PlayerReplicationInfo != none)
    {
        SavedPRI = EventInstigator.PlayerReplicationInfo;
    }
    else if (DHThrowableExplosiveProjectile(Other) != none && DHThrowableExplosiveProjectile(Other).SavedPRI != none)
    {
        SavedPRI = DHThrowableExplosiveProjectile(Other).SavedPRI;
    }

    if (SavedPRI != none)
    {
        if (ObjState == OBJ_Axis)
        {
            ObjectiveCompleted(SavedPRI, ALLIES_TEAM_INDEX);
        }
        else if (ObjState == OBJ_Allies)
        {
            ObjectiveCompleted(SavedPRI, AXIS_TEAM_INDEX);
        }
        else if (ObjState== OBJ_Neutral && SavedPRI.Team != none)
        {
            ObjectiveCompleted(SavedPRI, SavedPRI.Team.TeamIndex);
        }
    }
}

defaultproperties
{
}
