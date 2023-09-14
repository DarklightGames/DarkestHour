//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ObjSatchel extends DHObjective // was ROObjSatchel, but had to extend from DHObjective so can be part of new DHObjectives arrays
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

    SetActive(bIsInitiallyActive);
}

// Modified to neutralise any inherited timer - should never get called, but just a safeguard
// Actually there is a Timer() in GameObjective, but only for a bAccruePoints option, which is irrelevant in this game
function Timer()
{
    SetTimer(0.0, false);
}

// Modified to use cast to DHThrowableExplosiveProjectile instead of ROSatchelChargeProjectile
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
        if (IsAxis())
        {
            ObjectiveCompleted(SavedPRI, ALLIES_TEAM_INDEX);
        }
        else if (IsAllies())
        {
            ObjectiveCompleted(SavedPRI, AXIS_TEAM_INDEX);
        }
        else if (IsNeutral() && SavedPRI.Team != none)
        {
            ObjectiveCompleted(SavedPRI, SavedPRI.Team.TeamIndex);
        }
    }
}

// From ROObjSatchel class
function HandleCompletion(PlayerReplicationInfo CompletePRI, int Team)
{
    local Controller C;
    local DarkestHourGame G;
    local array<string> PlayerIDs;
    local DHGameReplicationInfo GRI;
    local int RoundTime;

    bActive = false;

    if (CompletePRI != none)
    {
        Level.Game.ScoreObjective(CompletePRI, 10.0);
    }

    G = DarkestHourGame(Level.Game);

    if (G != none && G.Metrics != none)
    {
        for (C = Level.ControllerList; C != none; C = C.nextController)
        {
            if (C.PlayerReplicationInfo == CompletePRI)
            {
                PlayerIDs[PlayerIDs.Length] = PlayerController(C).GetPlayerIDHash();
                break;
            }
        }

        GRI = DHGameReplicationInfo(G.GameReplicationInfo);

        if (GRI != none)
        {
            RoundTime = GRI.ElapsedTime - GRI.RoundStartTime;
        }

        G.Metrics.OnObjectiveCaptured(ObjNum, Team, RoundTime, PlayerIDs);
    }

    BroadcastLocalizedMessage(class'ROObjectiveMsg', Team + 2, none, none, self);
}

defaultproperties
{
    Texture=Texture'InterfaceArt_tex.OverheadMap.ROObjectiveSatchel'
}
