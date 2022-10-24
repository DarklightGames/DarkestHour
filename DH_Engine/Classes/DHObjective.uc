//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHObjective extends ROObjTerritory
    hidecategories(Assault,GameObjective,JumpDest,JumpSpot,MothershipHack)
    placeable;

enum EObjectiveOperation
{
    EOO_Activate,
    EOO_Deactivate,
    EOO_Toggle,
    EOO_Lock,
    EOO_Unlock
};

enum ESpawnPointOperation
{
    ESPO_Enable,
    ESPO_Disable,
    ESPO_Toggle,
    ESPO_Lock,
    ESPO_Unlock
};

enum EVehiclePoolOperation
{
    EVPO_Enable,
    EVPO_Disable,
    EVPO_Toggle,
    EVPO_MaxSpawnsAdd,
    EVPO_MaxSpawnsSet,
    EVPO_MaxActiveAdd,
    EVPO_MaxActiveSet
};

struct SpawnPointAction
{
    var() name SpawnPointTag;
    var() ESpawnPointOperation Operation;
};

struct VehiclePoolAction
{
    var() name VehiclePoolTag;
    var() EVehiclePoolOperation Operation;
    var() int Value;
};

struct ObjOperationAction
{
    var() int ObjectiveNum;
    var() name ObjectiveTag;
    var() EObjectiveOperation Operation;
};

// Territory variables
var(ROObjTerritory) bool            bUseHardBaseRate;           // Tells the capture rate to always be the base value, so we can have consistent capture times

// Basic Obj variables
var(ROObjective) bool               bIsInitiallyActive;         // Purpose is mainly to consolidate the variables of actors into one area (less confusing to new levelers)
var(ROObjective) name               NoArtyVolumeProtectionTag;  // optional Tag for associated no arty volume that protects this SP only when the SP is active

// Objective Spawn variables
var(DHObjectiveSpawn) name          SpawnPointHintTags[2];          // Tags of hints for obj spawns (0 = Axis, 1 = Allies)
var(DHObjectiveSpawn) name          VehicleSpawnPointHintTags[2];   // Tags of hints for vehicle obj spawns (0 = Axis, 1 = Allies)
var DHSpawnPoint_Objective          SpawnPoint;                     // Reference to the attached DHSpawnPoint_Objective if one exists

// Capture/Actions variables
var(DHObjectiveCapture) bool        bLockDownOnCapture;
var(DHObjectiveCapture) bool        bUsePostCaptureOperations;  // Enables below variables to be used for post capture clear check/calls
var(DHObjectiveCapture) bool        bSetInactiveOnCapture;      // Simliar to bRecaptureable, but doesn't disable timer, just sets to inactive (bRecaptureable must = true)
var(DHObjectiveCapture) bool        bNeutralizeBeforeCapture;   // if this is true the objective will neutralize first (then can be captured by either team)
var(DHObjectiveCapture) int         PreventCaptureTime;         // time to prevent capture after the objective is activated
var(DHObjectiveCapture) int         LockDownOnCaptureTime;      // time to prevent capture after the objective is captured
var(DHObjectiveCapture) int         AlliesAddedLockDown;        // added time to lock down if Allies take the objective
var(DHObjectiveCapture) int         AxisAddedLockDown;          // added time to lock down if Axis takle the objective
var(DHObjectiveCapture) bool        bNeutralOnActivation;       // Should this capture be neutral when it is activated
var(DHObjectiveCapture) bool        bLockDownNeverControlled;   // Lock objectives on capture regardless of whether they were recently controlled or not
var(DHObjectiveCapture) bool        bGroupActionsAtDisable;

// Requirements
var(DHObjectiveRequirements) array<name>    AxisRequiredObjTagForCapture;       // ObjTag
var(DHObjectiveRequirements) array<name>    AlliesRequiredObjTagForCapture;     // ObjTag
var(DHObjectiveRequirements) array<int>     AxisRequiredObjForCapture;          // TODO: Once a lot of levels are using the tag system, make this variable un(configuratable)
var(DHObjectiveRequirements) array<int>     AlliesRequiredObjForCapture;        // TODO: Once a lot of levels are using the tag system, make this variable un(configuratable)
var(DHObjectiveRequirements) int            PlayersNeededToCapture;
var(DHObjectiveRequirements) bool           bVehiclesCanCapture;
var(DHObjectiveRequirements) bool           bTankersCanCapture;

// Clear variables
var(DHObjectiveClear) bool          bSetInactiveOnClear;        // Sets the objective inactive when cleared
var(DHObjectiveClear) bool          bDisableWhenAlliesClearObj;
var(DHObjectiveClear) bool          bDisableWhenAxisClearObj;

// Visual variables
var(DHObjectiveVisual) bool         bHideOnMap;
var(DHObjectiveVisual) bool         bHideOnMapWhenInactive;
var(DHObjectiveVisual) bool         bHideLabelWhenInactive;

// Award variables
var(DHObjectiveAwards) int          AlliedAwardedReinforcements;// Amount of reinforcement to award for allies if the obj is captured
var(DHObjectiveAwards) int          AxisAwardedReinforcements;  // Amount of reinforcement to award for axis if the obj is captured
var(DHObjectiveAwards) int          MinutesAwarded;             // Time in minutes awarded to round time when objective is captured
var(DHObjectiveAwards) int          AlliedOwnedAttritionRate;   // Rate of Axis Attrition when Allies control this objective
var(DHObjectiveAwards) int          AxisOwnedAttritionRate;     // Rate of Allies Attrition when Axis control this objective

// Non configurable variables
var     bool                        bCheckIfAxisCleared;
var     bool                        bCheckIfAlliesCleared;
var     bool                        bIsLocked;
var     bool                        bDidAwardAxisReinf;
var     bool                        bDidAwardAlliesReinf;
var     bool                        bRecentlyControlledByAxis;
var     bool                        bRecentlyControlledByAllies;
var     float                       AwardedReinforcementFactor;

// Replicated variables
var     int                         UnfreezeTime;               // The time at which the objective will be unlocked and ready to be capured again, relative to GRI.ElapsedTime

// Capture operations (after capture)
var(DH_CaptureActions)      array<ObjOperationAction>   AlliesCaptureObjActions;
var(DH_CaptureActions)      array<ObjOperationAction>   AxisCaptureObjActions;
var(DH_CaptureActions)      array<SpawnPointAction>     AlliesCaptureSpawnPointActions;
var(DH_CaptureActions)      array<SpawnPointAction>     AxisCaptureSpawnPointActions;
var(DH_CaptureActions)      array<VehiclePoolAction>    AlliesCaptureVehiclePoolActions;
var(DH_CaptureActions)      array<VehiclePoolAction>    AxisCaptureVehiclePoolActions;
var(DH_CaptureActions)      array<name>                 AlliesCaptureEvents;
var(DH_CaptureActions)      array<name>                 AxisCaptureEvents;

// Post capture cleared operations (after capture and cleared of enemies)
var(DH_ClearedActions)      array<ObjOperationAction>   AlliesClearedCaptureObjActions;
var(DH_ClearedActions)      array<ObjOperationAction>   AxisClearedCaptureObjActions;
var(DH_ClearedActions)      array<SpawnPointAction>     AlliesClearedCaptureSpawnPointActions;
var(DH_ClearedActions)      array<SpawnPointAction>     AxisClearedCaptureSpawnPointActions;
var(DH_ClearedActions)      array<VehiclePoolAction>    AlliesClearedCaptureVehiclePoolActions;
var(DH_ClearedActions)      array<VehiclePoolAction>    AxisClearedCaptureVehiclePoolActions;
var(DH_ClearedActions)      array<name>                 AlliesClearedCaptureEvents;
var(DH_ClearedActions)      array<name>                 AxisClearedCaptureEvents;

// Grouped capture operations (these will need to be the same in each grouped objective, unless you desire different actions based on the last captured grouped objective)
var(DH_GroupedActions)      array<int>                  GroupedObjectiveReliances; // array of Objective Nums this objective is grouped with (doesn't need to list itself)
var(DH_GroupedActions)      array<ObjOperationAction>   AlliesCaptureGroupObjActions;
var(DH_GroupedActions)      array<ObjOperationAction>   AxisCaptureGroupObjActions;
var(DH_GroupedActions)      array<SpawnPointAction>     AlliesGroupSpawnPointActions;
var(DH_GroupedActions)      array<SpawnPointAction>     AxisGroupSpawnPointActions;
var(DH_GroupedActions)      array<VehiclePoolAction>    AlliesGroupVehiclePoolActions;
var(DH_GroupedActions)      array<VehiclePoolAction>    AxisGroupVehiclePoolActions;
var(DH_GroupedActions)      array<name>                 AlliesGroupCaptureEvents;
var(DH_GroupedActions)      array<name>                 AxisGroupCaptureEvents;

// New group system
var()       name             ObjectiveGroupTag;
var         DHObjectiveGroup ObjectiveGroup;

// Replication
var                         EObjectiveState             OldObjState;

// Danger zone
var(DHDangerZone) float BaseInfluenceModifier;
var(DHDangerZone) float AxisInfluenceModifier;
var(DHDangerZone) float AlliesInfluenceModifier;
var(DHDangerZone) float NeutralInfluenceModifier;

// Team capture variable
var() enum ETeamCapture
{
	TEAM_Axis,
	TEAM_Allies,
	TEAM_Both,
} TeamCanCapture;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        UnfreezeTime;
}

simulated function PostBeginPlay()
{
    local DHGameReplicationInfo GRI;
    local RONoArtyVolume        NAV;
    local DHObjectiveGroup      ObjectiveGroupFound;
    local DarkestHourGame       G;

    // Call super above ROObjective
    super(GameObjective).PostBeginPlay();

    // Find the volume to use if the mapper set one
    if (VolumeTag != '')
    {
        foreach AllActors(class'Volume', AttachedVolume, VolumeTag)
        {
            AttachedVolume.AssociatedActor = self;
            break;
        }
    }

    // Find any associated no arty volume (that will only protect this objective if the objective is active)
    // Note that we don't need to record a reference to the no arty volume actor, we only need to set its AssociatedActor reference to be this objective
    if (NoArtyVolumeProtectionTag != '')
    {
        foreach AllActors(class'RONoArtyVolume', NAV, NoArtyVolumeProtectionTag)
        {
            NAV.AssociatedActor = self;
            break;
        }
    }

    if (Role == ROLE_Authority)
    {
        ObjState = InitialObjState;

        bRecentlyControlledByAxis = InitialObjState == OBJ_Axis;
        bRecentlyControlledByAllies = InitialObjState == OBJ_Allies;

        G = DarkestHourGame(Level.Game);

        // Add self to game objectives
        if (G != none)
        {
            // Aggressively enforce correct ObjNums! We delete the objective if these numbers are bad because
            // a missing objective is a hell of a lot more noticeable than a slightly misbehaving objective.
            if (ObjNum >= arraycount(G.DHObjectives))
            {
                Warn("BAD OBJECTIVE!!! The objective \"" $ GetHumanReadableName() $ "\" has an invalid ObjNum of" @ ObjNum $ "! ObjNum must be between 0 and" @ (arraycount(G.DHObjectives) - 1) @ "(inclusive)");
                Destroy();
                return;
            }

            if (G.DHObjectives[ObjNum] != none)
            {
                Warn("BAD OBJECTIVE!!! The objective \"" $ GetHumanReadableName() $ "\" has an identical ObjNum value as objective" @ G.DHObjectives[ObjNum].ObjectiveName);
                Destroy();
                return;
            }

            G.DHObjectives[ObjNum] = self;

            foreach AllActors(class'DHObjectiveGroup', ObjectiveGroupFound, ObjectiveGroupTag)
            {
                if (ObjectiveGroup != none)
                {
                    Warn("Objective group already assigned (possible duplicate tag)");
                    break;
                }

                ObjectiveGroup = ObjectiveGroupFound;
                ObjectiveGroup.AddObjective(self);
            }
        }

        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        // Add self to game replication info objectives
        if (GRI != none)
        {
            GRI.DHObjectives[ObjNum] = self;
        }
    }
}

function Reset()
{
    super.Reset();

    UnfreezeTime = 0;
    SetActive(bIsInitiallyActive);

    bCheckIfAxisCleared = false;
    bCheckIfAlliesCleared = false;
    bIsLocked = false;
    bDidAwardAxisReinf = false;
    bDidAwardAlliesReinf = false;

    bRecentlyControlledByAxis = InitialObjState == OBJ_Axis;
    bRecentlyControlledByAllies = InitialObjState == OBJ_Allies;
}

function SetActive(bool bActiveStatus)
{
    // Don't run any changes if we are already the status sent
    if (bActive == bActiveStatus)
    {
        return;
    }

    super.SetActive(bActiveStatus);

    if (bActiveStatus)
    {
        UnfreezeTime = Level.Game.GameReplicationInfo.ElapsedTime + PreventCaptureTime;

        // Make neutral if desired
        if (bNeutralOnActivation && !bDisabled && !IsNeutral())
        {
            ObjState = OBJ_Neutral;

            if (DarkestHourGame(Level.Game) != none)
            {
                DarkestHourGame(Level.Game).NotifyObjStateChanged();
            }
        }
    }
}

function DoSpawnPointAction(SpawnPointAction SPA)
{
    local DHSpawnManager SM;

    SM = DarkestHourGame(Level.Game).SpawnManager;

    if (SM == none)
    {
        return;
    }

    switch (SPA.Operation)
    {
        case ESPO_Enable:
            SM.SetSpawnPointIsActiveByTag(SPA.SpawnPointTag, true);
            break;
        case ESPO_Disable:
            SM.SetSpawnPointIsActiveByTag(SPA.SpawnPointTag, false);
            break;
        case ESPO_Toggle:
            SM.ToggleSpawnPointIsActiveByTag(SPA.SpawnPointTag);
            break;
        case ESPO_Lock:
            SM.SetSpawnPointIsLockedByTag(SPA.SpawnPointTag, true);
            break;
        case ESPO_Unlock:
            SM.SetSpawnPointIsLockedByTag(SPA.SpawnPointTag, false);
            break;
        default:
            Warn("Unhandled ESpawnPointOperation");
            break;
    }
}

function DoVehiclePoolAction(VehiclePoolAction VPA)
{
    local DHSpawnManager SM;

    SM = DarkestHourGame(Level.Game).SpawnManager;

    if (SM == none)
    {
        return;
    }

    switch (VPA.Operation)
    {
        case EVPO_Enable:
            SM.SetVehiclePoolIsActiveByTag(VPA.VehiclePoolTag, true);
            break;
        case EVPO_Disable:
            SM.SetVehiclePoolIsActiveByTag(VPA.VehiclePoolTag, false);
            break;
        case EVPO_Toggle:
            SM.ToggleVehiclePoolIsActiveByTag(VPA.VehiclePoolTag);
            break;
        case EVPO_MaxSpawnsAdd:
            SM.AddVehiclePoolMaxSpawnsByTag(VPA.VehiclePoolTag, VPA.Value);
            break;
        case EVPO_MaxSpawnsSet:
            SM.SetVehiclePoolMaxSpawnsByTag(VPA.VehiclePoolTag, VPA.Value);
            break;
        case EVPO_MaxActiveAdd:
            SM.AddVehiclePoolMaxActiveByTag(VPA.VehiclePoolTag, VPA.Value);
            break;
        case EVPO_MaxActiveSet:
            SM.SetVehiclePoolMaxActiveByTag(VPA.VehiclePoolTag, VPA.Value);
            break;
        default:
            Warn("Unhandled EVehiclePoolOperation");
            break;
    }
}

function DoObjectiveAction(ObjOperationAction OOA)
{
    local int ObjIndex;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || bIsLocked)
    {
        return;
    }

    if (OOA.ObjectiveTag != '')
    {
        if (!GRI.DHObjectiveTable.Get(string(OOA.ObjectiveTag), ObjIndex)) // This gets the objective's index by tag, and sets it as ObjIndex
        {   // if it returns false, then return out of function as something went wrong
            Warn("Something went wrong in getting objective index by tag from table in DHObjective.DoObjectiveAction()");
            return;
        }
    }
    else
    {
        ObjIndex = OOA.ObjectiveNum;
    }

    if (ObjIndex < 0)
    {
        return;
    }

    switch (OOA.Operation)
    {
        case EOO_Activate:
            GRI.DHObjectives[ObjIndex].SetActive(true);
            break;
        case EOO_Deactivate:
            GRI.DHObjectives[ObjIndex].SetActive(false);
            break;
        case EOO_Toggle:
            GRI.DHObjectives[ObjIndex].SetActive(!GRI.DHObjectives[ObjIndex].bActive);
            break;
        case EOO_Lock:
            GRI.DHObjectives[ObjIndex].bIsLocked = true;
            break;
        case EOO_Unlock:
            GRI.DHObjectives[ObjIndex].bIsLocked = false;
            break;
        default:
            Warn("Unhandled EObjectiveOperation");
            break;
    }
}

function HandleGroupActions(int Team)
{
    local DarkesthourGame DHGame;
    local bool bGroupedObjNotSame;
    local int  i;

    DHGame = DarkesthourGame(Level.Game);

    if (Team == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < GroupedObjectiveReliances.Length; ++i)
        {
            // Check if the grouped objective isn't captured for Axis
            if (!DHGame.DHObjectives[GroupedObjectiveReliances[i]].isAxis())
            {
                // One of the grouped objectives is not captured for Axis yet
                bGroupedObjNotSame = true;
            }
        }

        // If all the grouped objectives are captured for Axis, do grouped actions
        if (GroupedObjectiveReliances.Length > 0 && !bGroupedObjNotSame)
        {
            for (i = 0; i < AxisCaptureGroupObjActions.Length; ++i)
            {
                DoObjectiveAction(AxisCaptureGroupObjActions[i]);
            }

            for (i = 0; i < AxisGroupSpawnPointActions.Length; ++i)
            {
                DoSpawnPointAction(AxisGroupSpawnPointActions[i]);
            }

            for (i = 0; i < AxisGroupVehiclePoolActions.Length; ++i)
            {
                DoVehiclePoolAction(AxisGroupVehiclePoolActions[i]);
            }

            for (i = 0; i < AxisGroupCaptureEvents.Length; ++i)
            {
                TriggerEvent(AxisGroupCaptureEvents[i], none, none);
            }
        }
    }
    else if (Team == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < GroupedObjectiveReliances.Length; ++i)
        {
            // Check if the grouped objective isn't captured for Allies
            if (!DHGame.DHObjectives[GroupedObjectiveReliances[i]].isAllies())
            {
                // One of the grouped objectives is not captured for Allies yet
                bGroupedObjNotSame = true;
            }
        }

        // If all the grouped objectives are captured for Allies, do grouped actions
        if (GroupedObjectiveReliances.Length > 0 && !bGroupedObjNotSame)
        {
            for (i = 0; i < AlliesCaptureGroupObjActions.Length; ++i)
            {
                DoObjectiveAction(AlliesCaptureGroupObjActions[i]);
            }

            for (i = 0; i < AlliesGroupSpawnPointActions.Length; ++i)
            {
                DoSpawnPointAction(AlliesGroupSpawnPointActions[i]);
            }

            for (i = 0; i < AlliesGroupVehiclePoolActions.Length; ++i)
            {
                DoVehiclePoolAction(AlliesGroupVehiclePoolActions[i]);
            }

            for (i = 0; i < AlliesGroupCaptureEvents.Length; ++i)
            {
                TriggerEvent(AlliesGroupCaptureEvents[i], none, none);
            }
        }
    }
}

function GetCapturingControllers(int Teamindex, out array<Controller> Controllers)
{
    local Controller C;
    local Pawn P;
    local DHPlayerReplicationInfo PRI;
    local DHRoleInfo RI;

    Controllers.Length = 0;

    // Give players points for helping with the capture
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        P = DHPawn(C.Pawn);

        if (P == none)
        {
            P = ROVehicle(C.Pawn);

            if (P == none)
            {
                P = ROVehicleWeaponPawn(C.Pawn);

                if (!bVehiclesCanCapture)
                {
                    continue;
                }
            }
            else if (!bVehiclesCanCapture)
            {
                continue;
            }
        }

        PRI = DHPlayerReplicationInfo(C.PlayerReplicationInfo);

        if (PRI != none)
        {
            RI = DHRoleInfo(PRI.RoleInfo);
        }

        if (!C.bIsPlayer || P == none || !WithinArea(P) || C.PlayerReplicationInfo.Team == none || C.PlayerReplicationInfo.Team.TeamIndex != TeamIndex)
        {
            continue;
        }

        if (!bTankersCanCapture && RI != none && RI.bCanBeTankCrew)
        {
            continue;
        }

        Controllers[Controllers.Length] = C;
    }
}

function HandleCompletion(PlayerReplicationInfo CompletePRI, int Team)
{
    local DarkestHourGame           G;
    local int                       i;
    local array<string>             PlayerIDs;
    local int                       RoundTime, AwardedReinf;
    local int                       NumTotal[2], Num[2], NumForCheck[2];
    local array<Controller>         CapturingControllers;

    CurrentCapProgress = 0.0;

    G = DarkestHourGame(Level.Game);

    if (G == none)
    {
        return;
    }

    // If it's not recapturable, make it inactive
    if (!bRecaptureable)
    {
        SetActive(false);

        // Only turn off the timer if bUsePostCaptureOperations is false, we will turn it off after it's clear of enemies (in timer)
        if (!bUsePostCaptureOperations)
        {
            SetTimer(0.0, false);
        }

        DisableCapBarsForThisObj(); // might want to move this to above if statement, but would need testing
    }

    // Don't "disable" the objective, just "deactivate it"
    if (bSetInactiveOnCapture)
    {
        SetActive(false);
    }

    // Give players points for helping with the capture
    GetCapturingControllers(Team, CapturingControllers);

    for (i = 0; i < CapturingControllers.Length; ++i)
    {
        DarkestHourGame(Level.Game).SendScoreEvent(CapturingControllers[i], class'DHScoreEvent_ObjectiveCapture'.static.Create());

        if (PlayerController(CapturingControllers[i]) != none)
        {
             PlayerIDs[PlayerIDs.Length] = PlayerController(CapturingControllers[i]).GetPlayerIDHash();
        }
    }

    if (G.Metrics != none)
    {
        RoundTime = Level.Game.GameReplicationInfo.ElapsedTime -  Level.Game.GameReplicationInfo.RoundStartTime;
        G.Metrics.OnObjectiveCaptured(ObjNum, Team, RoundTime, PlayerIDs);
    }

    // Award round time
    if (MinutesAwarded != 0 && !bUsePostCaptureOperations)
    {
        G.ModifyRoundTime(MinutesAwarded*60, 0);
    }

    switch (Team)
    {
        case AXIS_TEAM_INDEX:
            if (bLockDownOnCapture && (bLockDownNeverControlled || bRecentlyControlledByAllies))
            {
                UnfreezeTime = Level.Game.GameReplicationInfo.ElapsedTime + LockDownOnCaptureTime + AxisAddedLockDown;
            }

            if (!bDidAwardAxisReinf && bRecentlyControlledByAllies)
            {
                bDidAwardAxisReinf = true;

                // Award reinforcements
                if (AxisAwardedReinforcements >= 0)
                {
                    G.ModifyReinforcements(AXIS_TEAM_INDEX, AxisAwardedReinforcements);
                    class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, AXIS_TEAM_INDEX, class'DHReinforcementAwardMsg', AxisAwardedReinforcements, none, none, self);
                }
                else
                {
                    AwardedReinf = int(G.GetNumPlayers() * AwardedReinforcementFactor);
                    G.ModifyReinforcements(AXIS_TEAM_INDEX, AwardedReinf);
                    class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, AXIS_TEAM_INDEX, class'DHReinforcementAwardMsg', AwardedReinf, none, none, self);
                }
            }

            // This is set to false because Axis now "recently" control the objective
            bRecentlyControlledByAllies = false;

            for (i = 0; i < AxisCaptureObjActions.Length; ++i)
            {
                DoObjectiveAction(AxisCaptureObjActions[i]);
            }

            for (i = 0; i < AxisCaptureSpawnPointActions.Length; ++i)
            {
                DoSpawnPointAction(AxisCaptureSpawnPointActions[i]);
            }

            for (i = 0; i < AxisCaptureVehiclePoolActions.Length; ++i)
            {
                DoVehiclePoolAction(AxisCaptureVehiclePoolActions[i]);
            }

            for (i = 0; i < AxisCaptureEvents.Length; ++i)
            {
                TriggerEvent(AxisCaptureEvents[i], none, none);
            }

            // Do a check for the post capture clear system
            if (bUsePostCaptureOperations)
            {
                bCheckIfAxisCleared = false;  // stop checking for when Axis are cleared (supports recapturable objectives)
                bCheckIfAlliesCleared = true; // begin checking for when Allies are cleared
            }

            if (!bGroupActionsAtDisable)
            {
                HandleGroupActions(AXIS_TEAM_INDEX);
            }

            break;

        case ALLIES_TEAM_INDEX:
            if (bLockDownOnCapture && (bLockDownNeverControlled || bRecentlyControlledByAxis))
            {
                UnfreezeTime = Level.Game.GameReplicationInfo.ElapsedTime + LockDownOnCaptureTime + AlliesAddedLockDown;
            }

            if (!bDidAwardAlliesReinf && bRecentlyControlledByAxis)
            {
                bDidAwardAlliesReinf = true;

                // Award reinforcements
                if (AlliedAwardedReinforcements >= 0)
                {
                    G.ModifyReinforcements(ALLIES_TEAM_INDEX, AlliedAwardedReinforcements);
                    class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, ALLIES_TEAM_INDEX, class'DHReinforcementAwardMsg', AlliedAwardedReinforcements, none, none, self);
                }
                else
                {
                    AwardedReinf = int(G.GetNumPlayers() * AwardedReinforcementFactor);
                    G.ModifyReinforcements(ALLIES_TEAM_INDEX, AwardedReinf);
                    class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, ALLIES_TEAM_INDEX, class'DHReinforcementAwardMsg', AwardedReinf, none, none, self);
                }
            }

            // This is set to false because Allies now "recently" control the objective
            bRecentlyControlledByAxis = false;

            for (i = 0; i < AlliesCaptureObjActions.Length; ++i)
            {
                DoObjectiveAction(AlliesCaptureObjActions[i]);
            }

            for (i = 0; i < AlliesCaptureSpawnPointActions.Length; ++i)
            {
                DoSpawnPointAction(AlliesCaptureSpawnPointActions[i]);
            }

            for (i = 0; i < AlliesCaptureVehiclePoolActions.Length; ++i)
            {
                DoVehiclePoolAction(AlliesCaptureVehiclePoolActions[i]);
            }

            for (i = 0; i < AlliesCaptureEvents.Length; ++i)
            {
                TriggerEvent(AlliesCaptureEvents[i], none, none);
            }

            // Do a check for the post capture clear system
            if (bUsePostCaptureOperations)
            {
                bCheckIfAlliesCleared = false; // stop checking for when Allies are cleared (supports recapturable objectives)
                bCheckIfAxisCleared = true;    // begin checking for when Axis are cleared
            }

            if (!bGroupActionsAtDisable)
            {
                HandleGroupActions(ALLIES_TEAM_INDEX);
            }

            break;
    }

    // Broadcast the objective capture messages (sound + message)
    if (bUsePostCaptureOperations) //Is using clear system
    {
        if (HasEnemiesPresent() || (bDisableWhenAxisClearObj && Team == ALLIES_TEAM_INDEX) || (bDisableWhenAlliesClearObj && Team == AXIS_TEAM_INDEX))
        {
            // If enemies are present in a clear objective, it will still be active, so broadcast capture
            // If the obj is set to disable when a team clears it, then check to make sure its not the opposite team
            BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(1, Team), none, none, self);
        }
        else if (!HasEnemiesPresent())
        {
            // If no enemies are present, then run a handle cleared logic immediately (don't wait for timer)
            // If objective is still active and timer is still running, then notify capture
            GetPlayersInObjective(Num, NumTotal, NumForCheck);

            if (bActive && !HandleClearedLogic(NumForCheck))
            {
                BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(1, Team), none, none, self);
            }
        }
        // Otherwise don't inform that it was captured, as timer will handle notification from here
    }
    else
    {
        if (bActive && IsNeutral())
        {
            BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(0, Team), none, none, self);
        }
        else if (bActive)
        {
            BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(1, Team), none, none, self);
        }
        else
        {
            BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(2, Team), none, none, self);
        }
    }
}

function bool HasEnemiesPresent()
{
    local int PlayerNums[2];

    GetPlayersInObjective(PlayerNums);

    return PlayerNums[int(!bool(ObjState))] > 0;
}

function GetPlayersInObjective(out int PlayerNums[2], optional out int TeamTotals[2], optional out int PlayerCheckNums[2])
{
    local Controller                C;
    local DHPlayerReplicationInfo   PRI;
    local DHRoleInfo                RI;
    local ROVehicle                 ROVeh;
    local ROVehicleWeaponPawn       VehWepPawn;

    // Loop through Controller list & determine how many players from each team are inside the attached volume, or if there is no volume, within the Radius that was set
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.bIsPlayer && C.PlayerReplicationInfo.Team != none && ((ROPlayer(C) != none && ROPlayer(C).GetRoleInfo() != none) || ROBot(C) != none))
        {
            if (C.Pawn != none && C.Pawn.Health > 0 && WithinArea(C.Pawn) && (TeamCanCapture == TEAM_Both || TeamCanCapture == C.GetTeamNum()))
            {
                ROVeh = ROVehicle(C.Pawn);
                VehWepPawn = ROVehicleWeaponPawn(C.Pawn);
                PRI = DHPlayerReplicationInfo(C.PlayerReplicationInfo);

                if (PRI != none)
                {
                    RI = DHRoleInfo(PRI.RoleInfo);
                }

                if ((!bTankersCanCapture && RI != none && RI.bCanBeTankCrew) || (!bVehiclesCanCapture && (ROVeh != none || VehWepPawn != none)))
                {
                    continue;
                }

                PlayerNums[PRI.Team.TeamIndex]++;

                if (RI != none)
                {
                    PlayerCheckNums[PRI.Team.TeamIndex] += PRI.RoleInfo.ObjCaptureWeight;
                }
                else
                {
                    PlayerCheckNums[PRI.Team.TeamIndex]++;
                }
            }

            TeamTotals[C.PlayerReplicationInfo.Team.TeamIndex]++;
        }
    }
}

function bool HandleClearedLogic(int NumForCheck[2])
{
    local int i;

    if (bUsePostCaptureOperations)
    {
        // If either team has cleared the objective
        if (bCheckIfAxisCleared && NumForCheck[0] <= 0 || bCheckIfAlliesCleared && NumForCheck[1] <= 0)
        {
            // If cleared of axis, then do Allied actions
            if (bCheckIfAxisCleared && NumForCheck[0] <= 0)
            {
                bCheckIfAxisCleared = false; // stop checking

                for (i = 0; i < AlliesClearedCaptureObjActions.Length; ++i)
                {
                    DoObjectiveAction(AlliesClearedCaptureObjActions[i]);
                }

                for (i = 0; i < AlliesClearedCaptureSpawnPointActions.Length; ++i)
                {
                    DoSpawnPointAction(AlliesClearedCaptureSpawnPointActions[i]);
                }

                for (i = 0; i < AlliesClearedCaptureVehiclePoolActions.Length; ++i)
                {
                    DoVehiclePoolAction(AlliesClearedCaptureVehiclePoolActions[i]);
                }

                for (i = 0; i < AlliesClearedCaptureEvents.Length; ++i)
                {
                    TriggerEvent(AlliesClearedCaptureEvents[i], none, none);
                }

                if (bGroupActionsAtDisable)
                {
                    HandleGroupActions(ALLIES_TEAM_INDEX);
                }
            }

            // If cleared of Allies, then do Axis actions
            if (bCheckIfAlliesCleared && NumForCheck[1] <= 0)
            {
                bCheckIfAlliesCleared = false; // stop checking

                for (i = 0; i < AxisClearedCaptureObjActions.Length; ++i)
                {
                    DoObjectiveAction(AxisClearedCaptureObjActions[i]);
                }

                for (i = 0; i < AxisClearedCaptureSpawnPointActions.Length; ++i)
                {
                    DoSpawnPointAction(AxisClearedCaptureSpawnPointActions[i]);
                }

                for (i = 0; i < AxisClearedCaptureVehiclePoolActions.Length; ++i)
                {
                    DoVehiclePoolAction(AxisClearedCaptureVehiclePoolActions[i]);
                }

                for (i = 0; i < AxisClearedCaptureEvents.Length; ++i)
                {
                    TriggerEvent(AxisClearedCaptureEvents[i], none, none);
                }

                if (bGroupActionsAtDisable)
                {
                    HandleGroupActions(AXIS_TEAM_INDEX);
                }
            }

            // Handle common is cleared logic
            if (bSetInactiveOnClear)
            {
                CurrentCapProgress = 0.0;
                SetActive(false);
                DisableCapBarsForThisObj();
                BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(2, int(ObjState)), none, none, self);

                // Award time as the objective was cleared and objective is inactive
                if (MinutesAwarded != 0)
                {
                    DarkestHourGame(Level.Game).ModifyRoundTime(MinutesAwarded * 60, 0);
                }

                return true;
            }
            else if (bDisableWhenAxisClearObj && IsAxis() || bDisableWhenAlliesClearObj && IsAllies())
            {
                CurrentCapProgress = 0.0;
                SetActive(false);
                SetTimer(0.0, false); // Disable the objective (not just set inactive, it is not meant to be enabled again until reset)
                DisableCapBarsForThisObj();
                BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(2, int(ObjState)), none, none, self);

                // Award time as the objective was cleared and objective is disabled
                if (MinutesAwarded != 0)
                {
                    DarkestHourGame(Level.Game).ModifyRoundTime(MinutesAwarded * 60, 0);
                }

                return true;
            }
            else if (!bRecaptureable)
            {
                SetTimer(0.0, false);
                BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(2, int(ObjState)), none, none, self);
                return true;
            }
        }
    }

    return false;
}

// Returns true if a team is unable to capture this objective because they have not secured the required connected objective(s).
simulated function bool IsTeamNeutralLocked(DHGameReplicationInfo GRI, int TeamIndex)
{
    return GRI != none && bNeutralizeBeforeCapture && IsNeutral() && !HasRequiredObjectives(GRI, TeamIndex);
}

function Timer()
{
    local Controller            C;
    local DHPawn                P;
    local ROVehicle             ROVeh;
    local ROVehicleWeaponPawn   VehWepPawn;
    local DHGameReplicationInfo GRI;
    local float                 OldCapProgress, Rate[2];
    local int                   NumTotal[2], Num[2], NumForCheck[2], i;
    local byte                  CurrentCapAxisCappers, CurrentCapAlliesCappers, CP;

    if (ROTeamGame(Level.Game) == none || !ROTeamGame(Level.Game).IsInState('RoundInPlay') || (!bActive && !bUsePostCaptureOperations))
    {
        return;
    }

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    GetPlayersInObjective(Num, NumTotal, NumForCheck);

    // bIsCritical is used to determine if the objective has both teams present (repurposed as it is usually not used, but replicated anyways)
    bIsCritical = Num[AXIS_TEAM_INDEX] > 0 && Num[ALLIES_TEAM_INDEX] > 0;

    // Handle is cleared logic and return if supposed to
    if (HandleClearedLogic(NumForCheck))
    {
        return;
    }

    // Do nothing else if it's not active
    if (!bActive)
    {
        return;
    }

    OldCapProgress = CurrentCapProgress;

    // Figure out the rate of capture that each side is capable of
    // Rate is defined as: Number of players in the area * BaseCaptureRate * Leader bonus (if any) * Percentage of players on the team in the area
    for (i = 0; i < 2; ++i)
    {
        if (Num[i] >= PlayersNeededToCapture && bUseHardBaseRate)
        {
            Rate[i] = BaseCaptureRate;
        }
        else if (Num[i] >= PlayersNeededToCapture)
        {
            Rate[i] = FMin(Num[i] * BaseCaptureRate * (float(Num[i]) / NumTotal[i]), MaxCaptureRate);
        }
        else
        {
            Rate[i] = 0.0;
        }
    }

    // If we are not ready to capture because of precap prevention set rate to zero
    if (Level.Game.GameReplicationInfo.ElapsedTime < UnfreezeTime)
    {
        Rate[0] = 0.0;
        Rate[1] = 0.0;
    }

    CurrentCapAxisCappers = NumForCheck[AXIS_TEAM_INDEX];
    CurrentCapAlliesCappers = NumForCheck[ALLIES_TEAM_INDEX];

    // A team that is neutral-locked behaves as though it has no players in the capture area.
    if (IsTeamNeutralLocked(GRI, AXIS_TEAM_INDEX))
    {
        CurrentCapAxisCappers = 0;
    }

    if (IsTeamNeutralLocked(GRI, ALLIES_TEAM_INDEX))
    {
        CurrentCapAlliesCappers = 0;
    }

    // NOTE: Comparing number of players as opposed to rates to decide which side has advantage for the capture, for fear that rates could be abused in this instance
    if (!IsAxis() && CurrentCapAxisCappers > CurrentCapAlliesCappers)
    {
        // Have to work down the progress the other team made first, but this is quickened since the fall off rate still occurs
        if (CurrentCapTeam == ALLIES_TEAM_INDEX)
        {
            CurrentCapProgress -= TimerRate * (MaxCaptureRate + Rate[AXIS_TEAM_INDEX]);
        }
        else
        {
            CurrentCapTeam = AXIS_TEAM_INDEX;
            CurrentCapProgress += TimerRate * Rate[AXIS_TEAM_INDEX];
        }
    }
    else if (!IsAllies() && CurrentCapAlliesCappers > CurrentCapAxisCappers)
    {
        if (CurrentCapTeam == AXIS_TEAM_INDEX)
        {
            CurrentCapProgress -= TimerRate * (MaxCaptureRate + Rate[ALLIES_TEAM_INDEX]);
        }
        else
        {
            CurrentCapTeam = ALLIES_TEAM_INDEX;
            CurrentCapProgress += TimerRate * Rate[ALLIES_TEAM_INDEX];
        }
    }
    else if (CurrentCapAxisCappers == CurrentCapAlliesCappers && CurrentCapAxisCappers != 0)
    {
        // Stalemate! No change.
    }
    else
    {
        CurrentCapProgress -= TimerRate * MaxCaptureRate;
    }

    CurrentCapProgress = FClamp(CurrentCapProgress, 0.0, 1.0);

    if (CurrentCapProgress == 0.0)
    {
        CurrentCapTeam = NEUTRAL_TEAM_INDEX;
    }
    else if (CurrentCapProgress == 1.0)
    {
        ObjectiveCompleted(none, CurrentCapTeam);
    }

    // Go through and update capture bars
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        P = DHPawn(C.Pawn);
        ROVeh = ROVehicle(C.Pawn);
        VehWepPawn = ROVehicleWeaponPawn(C.Pawn);

        if (!C.bIsPlayer)
        {
            continue;
        }

        if (P != none)
        {
            if (!bActive || !WithinArea(P))
            {
                if (P.CurrentCapArea == ObjNum)
                {
                    P.CurrentCapArea = 255;
                }
            }
            else
            {
                if (P.CurrentCapArea != ObjNum)
                {
                    P.CurrentCapArea = ObjNum;
                }

                CP = byte(Ceil(CurrentCapProgress * 100));

                // Hack to save on variables replicated (if Allies, add 100 so the range is 101-200 instead of 1-100, or just 0 if it is 0)
                if (CurrentCapTeam == ALLIES_TEAM_INDEX && CurrentCapProgress != 0.0)
                {
                    CP += 100;
                }

                if (P.CurrentCapProgress != CP)
                {
                    P.CurrentCapProgress = CP;
                }

                // Replicate # of players in capture zone
                if (P.CurrentCapAxisCappers != CurrentCapAxisCappers)
                {
                    P.CurrentCapAxisCappers = CurrentCapAxisCappers;
                }

                if (P.CurrentCapAlliesCappers != CurrentCapAlliesCappers)
                {
                    P.CurrentCapAlliesCappers = CurrentCapAlliesCappers;
                }
            }
        }

        // Draw the capture bar for rovehicles and rovehiclepawns
        if (P == none && ROVeh != none)
        {
            if (!bActive || !WithinArea(ROVeh))
            {
                if (ROVeh.CurrentCapArea == ObjNum)
                {
                    ROVeh.CurrentCapArea = 255;
                }
            }
            else
            {
                if (ROVeh.CurrentCapArea != ObjNum)
                {
                    ROVeh.CurrentCapArea = ObjNum;
                }

                CP = byte(Ceil(CurrentCapProgress * 100));

                // Hack to save on variables replicated (if Allies, add 100 so the range is 101-200 instead of 1-100, or just 0 if it is 0)
                if (CurrentCapTeam == ALLIES_TEAM_INDEX && CurrentCapProgress != 0.0)
                {
                    CP += 100;
                }

                if (ROVeh.CurrentCapProgress != CP)
                {
                    ROVeh.CurrentCapProgress = CP;
                }

                // Replicate # of players in capture zone
                if (ROVeh.CurrentCapAxisCappers != CurrentCapAxisCappers)
                {
                    ROVeh.CurrentCapAxisCappers = CurrentCapAxisCappers;
                }

                if (ROVeh.CurrentCapAlliesCappers != CurrentCapAlliesCappers)
                {
                    ROVeh.CurrentCapAlliesCappers = CurrentCapAlliesCappers;
                }
            }
        }

        if (P == none && ROVeh == none && VehWepPawn != none)
        {
            if (!bActive || !WithinArea(VehWepPawn))
            {
                if (VehWepPawn.CurrentCapArea == ObjNum)
                {
                    VehWepPawn.CurrentCapArea = 255;
                }
            }
            else
            {
                if (VehWepPawn.CurrentCapArea != ObjNum)
                {
                    VehWepPawn.CurrentCapArea = ObjNum;
                }

                CP = byte(Ceil(CurrentCapProgress * 100));

                // Hack to save on variables replicated (if Allies, add 100 so the range is 101-200 instead of 1-100, or just 0 if it is 0)
                if (CurrentCapTeam == ALLIES_TEAM_INDEX && CurrentCapProgress != 0.0)
                {
                    CP += 100;
                }

                if (VehWepPawn.CurrentCapProgress != CP)
                {
                    VehWepPawn.CurrentCapProgress = CP;
                }

                // Replicate # of players in capture zone
                if (VehWepPawn.CurrentCapAxisCappers != CurrentCapAxisCappers)
                {
                    VehWepPawn.CurrentCapAxisCappers = CurrentCapAxisCappers;
                }

                if (VehWepPawn.CurrentCapAlliesCappers != CurrentCapAlliesCappers)
                {
                    VehWepPawn.CurrentCapAlliesCappers = CurrentCapAlliesCappers;
                }
            }
        }
    }

    // Check if we should send map info change notification to players
    if (!(OldCapProgress ~= CurrentCapProgress))
    {
        // Check if we changed from 1.0 or from 0.0 (no need to send events otherwise)
        if (OldCapProgress ~= 0.0 || OldCapProgress ~= 1.0)
        {
            ROTeamGame(Level.Game).NotifyPlayersOfMapInfoChange(NEUTRAL_TEAM_INDEX);
        }
    }

    UpdateCompressedCapProgress();
}

// Modified to handle neutralizing objectives
function ObjectiveCompleted(PlayerReplicationInfo CompletePRI, int Team)
{
    local DHGameReplicationInfo GRI;

    if (!IsNeutral() && bNeutralizeBeforeCapture)
    {
        // If the objective is not neutral, has completed progress, & is set to bNeutralizedBeforeCaptured
        // Then we call different logic which will neutralize the objective without "completing" it
        ObjectiveNeutralized(Team);
        return;
    }

    if (Team == AXIS_TEAM_INDEX)
    {
        ObjState = OBJ_Axis;

        bRecentlyControlledByAxis = true;

        if (AxisEvent != '')
        {
            TriggerEvent(AxisEvent, self, None);
        }
    }
    else
    {
        ObjState = OBJ_Allies;

        bRecentlyControlledByAllies = true;

        if (AlliesEvent != '')
        {
            TriggerEvent(AlliesEvent, self, None);
        }
    }

    HandleCompletion(CompletePRI, Team);

    ROTeamGame(Level.Game).NotifyObjStateChanged();

    ROTeamGame(Level.Game).RemoveHelpRequestsForObj(ObjNum);

    // lets see if this tells the bots the objectives is done for
    UnrealMPGameInfo(Level.Game).FindNewObjectives(self);

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        GRI.ObjectiveCompleted();
    }
}

// New function to implement the bNeutralizeBeforeCapture option
function ObjectiveNeutralized(int Team)
{
    local int i;
    local array<Controller> CapturingControllers;
    local DHScoreEvent_ObjectiveNeutralize ScoreEvent;
    local DarkestHourGame G;

    // Reset values as the objective was neutralized
    CurrentCapProgress = 0.0;
    CurrentCapTeam = NEUTRAL_TEAM_INDEX;
    ObjState = OBJ_Neutral;

    // Alert the game of changes
    ROTeamGame(Level.Game).NotifyObjStateChanged();

    // Notify players
    BroadcastLocalizedMessage(class'DHObjectiveMessage', class'UInteger'.static.FromShorts(0, Team), none, none, self);

    GetCapturingControllers(Team, CapturingControllers);
    ScoreEvent = class'DHScoreEvent_ObjectiveNeutralize'.static.Create();

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        for (i = 0; i < CapturingControllers.Length; ++i)
        {
            G.SendScoreEvent(CapturingControllers[i], ScoreEvent);
        }
    }
}

// Overridden to the fix a console warning that would display when EventInstigator was none
function Trigger(Actor Other, Pawn EventInstigator)
{
    local PlayerReplicationInfo PRI;

    if (!bActive || ROTeamGame(Level.Game) == none || !ROTeamGame(Level.Game).IsInState('RoundInPlay'))
    {
        return;
    }

    if (EventInstigator != none)
    {
        PRI = EventInstigator.PlayerReplicationInfo;
    }

    if (IsAxis())
    {
        ObjectiveCompleted(PRI, ALLIES_TEAM_INDEX);
    }
    else if (IsAllies())
    {
        ObjectiveCompleted(PRI, AXIS_TEAM_INDEX);
    }
}

simulated function bool WithinArea(Actor A)
{
    if (AttachedVolume != none)
    {
        if (AttachedVolume.Encompasses(A))
        {
            return true;
        }
    }
    else if (VSize(A.Location - Location) < Radius)
    {
        return true;
    }

    return false;
}

// Overridden to make simulated functions, so can be used by the HUD, for example
simulated function bool IsAxis()
{
    return ObjState == OBJ_Axis;
}

simulated function bool IsAllies()
{
    return ObjState == OBJ_Allies;
}

simulated function bool IsNeutral()
{
    return ObjState == OBJ_Neutral;
}

simulated function bool IsFrozen(GameReplicationInfo GRI)
{
    return GRI != none && UnfreezeTime > GRI.ElapsedTime;
}

simulated function bool IsOwnedByTeam(byte TeamIndex)
{
    if (TeamIndex == AXIS_TEAM_INDEX)
        return IsAxis();
    else if (TeamIndex == ALLIES_TEAM_INDEX)
        return IsAllies();

    return false;
}

simulated function byte GetTeamIndex()
{
    switch (ObjState)
    {
        case OBJ_Axis:
            return AXIS_TEAM_INDEX;
        case OBJ_Allies:
            return ALLIES_TEAM_INDEX;
        case OBJ_Neutral:
            return NEUTRAL_TEAM_INDEX;
        default:
            return -1;
    }
}

simulated function bool IsInGroup()
{
    return ObjectiveGroupTag != '' && ObjectiveGroup != none;
}

// Clients/Server can run this function very fast because of the hashtable
simulated function bool HasRequiredObjectives(coerce DHGameReplicationInfo GRI, int TeamIndex)
{
    local int i;

    if (GRI == none)
    {
        return false;
    }

    if (TeamIndex == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < AxisRequiredObjForCapture.Length; ++i)
        {
            if (!GRI.DHObjectives[AxisRequiredObjForCapture[i]].IsAxis())
            {
                return false;
            }
        }
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < AlliesRequiredObjForCapture.Length; ++i)
        {
            if (!GRI.DHObjectives[AlliesRequiredObjForCapture[i]].IsAllies())
            {
                return false;
            }
        }
    }
    else
    {
        return false; // The capturing team "was neutral"
    }

    return true;
}

// Modified to make way simpler and remove redundant if-statement checks.
function UpdateCompressedCapProgress()
{
    if (!bActive || CurrentCapProgress ~= 0.0)
    {
        CompressedCapProgress = 0;
    }
    else
    {
        CompressedCapProgress = Max(1, CurrentCapProgress * 5);
    }
}

// Overridden to notify the HUD to update the danger zone contour.
simulated function PostNetReceive()
{
    local DHPlayer PC;
    local DHHud Hud;

    super.PostNetReceive();

    // Listen for state changes so we can notify the HUD!
    if (ObjState != OldObjState)
    {
        if (ObjState != OBJ_Neutral)
        {
            PC = DHPlayer(Level.GetLocalPlayerController());

            if (PC != none)
            {
                Hud = DHHud(PC.myHUD);

                if (Hud != none)
                {
                    Hud.OnObjectiveCompleted();
                }
            }
        }

        OldObjState = ObjState;
    }
}

defaultproperties
{
    bDoNotUseLabelShiftingOnSituationMap=true
    Texture=Texture'DHEngine_Tex.Objective'
    bVehiclesCanCapture=true
    bTankersCanCapture=true
    PlayersNeededToCapture=1
    AwardedReinforcementFactor=0.25

    // Danger zone
    BaseInfluenceModifier=1
    AxisInfluenceModifier=1
    AlliesInfluenceModifier=1
    NeutralInfluenceModifier=1

    TeamCanCapture=TEAM_Both
}
