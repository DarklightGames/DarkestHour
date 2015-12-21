//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ObjSatchel extends DHObjective // Matt: was ROObjSatchel, but had to extend from DHObjective so can be part of new DHObjectives arrays
    hidecategories(DHObjective,ROObjTerritory,DH_CaptureActions,DH_ClearedActions,DH_GroupedActions,DH_ContestedActions,DH_ContestEndActions);

// Empty out unwanted/irrelevant functions inherited from DHObjective & ROObjTerritory
// We effectively make this so it inherits from ROObjective, as the original ROObjSatchel did
function DoSpawnPointAction(SpawnPointAction SPA);
function DoVehiclePoolAction(VehiclePoolAction VPA);
function DoObjectiveAction(ObjOperationAction OOA);
function HandleContestedActions(int Team, bool bStarted);
function HandleGroupActions(int Team);
function UpdateCompressedCapProgress();
function DisableCapBarsForThisObj();
function NotifyStateChanged(); // an empty function in ROObjective

// Skip over super in ROObjTerritory, to revert this function to the original from ROObjective
function SetActive(bool bActiveStatus)
{
    super(ROObjective).SetActive(bActiveStatus);
}

// Skip over supers in DHObjective & ROObjTerritory, to revert this function to the original from ROObjective, with the addition of option for bOverrideGameObjective
function Reset()
{
    super(ROObjective).Reset();

    if (bOverrideGameObjective)
    {
        SetActive(bIsInitiallyActive);
    }
}

// Modified to neutralise any inherited timer - should never get called, but just a safeguard
// Actually there is a Timer() in GameObjective, but only for a bAccruePoints option, which is irrelevant in this game
function Timer()
{
    SetTimer(0.0, false);
}

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

// From ROObjSatchel class
function HandleCompletion(PlayerReplicationInfo CompletePRI, int Team)
{
    bActive = false;

    if (CompletePRI != none)
    {
        Level.Game.ScoreObjective(CompletePRI, 10.0);
    }

    BroadcastLocalizedMessage(class'ROObjectiveMsg', Team + 2, none, none, self);
}

defaultproperties
{
    Texture=texture'InterfaceArt_tex.OverheadMap.ROObjectiveSatchel'
}
