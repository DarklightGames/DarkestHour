//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSpawnPoint_SquadRallyPoint extends DHSpawnPointBase
    notplaceable;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Construction_stc.usx

var DHSquadReplicationInfo SRI;                 // Convenience variable to access the SquadReplicationInfo.
var int SquadIndex;                             // The squad index of the squad that owns this rally point.
var int RallyPointIndex;                        // The index into SRI.RallyPoints.
var int SpawnsRemaining;                        // The amount of spawns remaining on the rally point.

// Creation
var float CreatedTimeSeconds;                   // The time (relative to Level.TimeSeconds) that this rally point was created
var sound CreationSound;                        // Sound that is played when the squad rally point is first placed.

// Encroachment
var int EncroachmentRadiusInMeters;             // The distance, in meters, that enemies must be within to affect the EncroachmentPenaltyCounter
var int EncroachmentPenaltyBlockThreshold;      // The value that EncroachmentPenaltyCounter must reach for the rally point to be "blocked".
var int EncroachmentPenaltyOverrunThreshold;    // The value that EncroachmentPenaltyCounter must reach for the rally point to be "overrun".
var int EncroachmentPenaltyCounter;             // Running counter of encroachment penalty.

// Establishment
var int EstablishmentRadiusInMeters;            // The distance, in meters, that squadmates and enemies must be within to influence the EstablishmentCounter.
var float EstablishmentStartTimeSeconds;        // The value of Level.TimeSeconds when this rally point began Establishment.
var float EstablishmentCounter;                 // Running counter to keep track of Establishment status.
var float EstablishmentCounterThreshold;        // The value that EstablishmentCounter must reach for the rally point to be "established".

// Overrun
var int OverrunRadiusInMeters;                  // The distance, in meters, that enemies must be within to immediately overrun a rally point.
var float OverrunMinimumTimeSeconds;            // The number of seconds a rally point must be "alive" for in order to be overrun by enemies. (To stop squad rally points being used as "enemy radar".

// Abandonment
var bool bCanSendAbandonmentWarningMessage;     // Whether or not we should send the abandonment message the next time the squad rally point has no teammates nearby while constructing

// Accrual timer (used for adding available spawns on
var int SpawnAccrualTimer;
var int SpawnAccrualThreshold;

replication
{
    reliable if (Role == ROLE_Authority)
        SquadIndex, RallyPointIndex, SpawnsRemaining;
}

function Reset()
{
    Destroy();
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        SRI = DarkestHourGame(Level.Game).SquadReplicationInfo;

        CreatedTimeSeconds = Level.TimeSeconds;

        if (SRI == none)
        {
            Destroy();
        }

        PlaySound(CreationSound, SLOT_None, 4.0,, 60.0,, true);
    }
}

auto state Constructing
{
    function Step()
    {
        local int SquadmateCount;
        local int EnemyCount;

        global.Step();

        GetPlayerCountsWithinRadius(default.EstablishmentRadiusInMeters, SquadIndex, SquadmateCount, EnemyCount);

        EstablishmentCounter -= EnemyCount;
        EstablishmentCounter += SquadmateCount;

        if (bCanSendAbandonmentWarningMessage && SquadmateCount == 0)
        {
            // "A newly created squad rally point is being abandoned!"
            SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 58);

            bCanSendAbandonmentWarningMessage = false;
        }
        else if (SquadmateCount > 0)
        {
            bCanSendAbandonmentWarningMessage = true;
        }

        if (SquadmateCount == 0 && EnemyCount == 0)
        {
            // No one is around to establish the rally point, start depleting the counter.
            EstablishmentCounter -= 1;
        }

        if (EstablishmentCounter >= default.EstablishmentCounterThreshold)
        {
            // Rally point exceeded the Establishment counter threshold. This
            // rally point is now established!
            GotoState('Active');
        }
        else if (EstablishmentCounter <= 0)
        {
            // Delay destruction of the rally point so it can't be used as enemy radar.
            if (Level.TimeSeconds - EstablishmentStartTimeSeconds > default.OverrunMinimumTimeSeconds)
            {
                // "A squad rally point failed to be established."
                SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 55);

                Destroy();
            }
        }
    }

Begin:
    EstablishmentStartTimeSeconds = Level.TimeSeconds;
}

function Step()
{
    local int OverrunningEnemiesCount;

    GetPlayerCountsWithinRadius(OverrunRadiusInMeters,,, OverrunningEnemiesCount);

    // Destroy the rally point immediately if there are enemies within a
    // very short distance.
    if (OverrunningEnemiesCount >= 1)
    {
        // "A squad rally point has been overrun by enemies."
        SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 54);

        Destroy();
    }
}

state Active
{
    function Step()
    {
        local int EncroachingEnemiesCount;

        global.Step();

        GetPlayerCountsWithinRadius(default.EncroachmentRadiusInMeters,,, EncroachingEnemiesCount);

        if (EncroachingEnemiesCount > 0)
        {
            // There are enemies nearby, so increase the encroachment penalty
            // counter by the number of nearby enemies.
            EncroachmentPenaltyCounter += EncroachingEnemiesCount;
        }
        else
        {
            // There are no enemies nearby, decrease the penalty timer by the
            // amount of nearby friendlies.
            EncroachmentPenaltyCounter -= 2;    // TODO; get rid of magic number
        }

        EncroachmentPenaltyCounter = Max(0, EncroachmentPenaltyCounter);

        if (EncroachmentPenaltyCounter < default.EncroachmentPenaltyBlockThreshold)
        {
            BlockReason = SPBR_None;
        }
        else if (EncroachmentPenaltyCounter < default.EncroachmentPenaltyOverrunThreshold)
        {
            // The encoroachment penalty counter has reached a point where we
            // are now blocking the spawn from being used until enemies are
            // cleared out.
            BlockReason = SPBR_EnemiesNearby;
        }
        else
        {
            // "A squad rally point has been overrun by enemies."
            SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 54);

            Destroy();
        }
    }

    event BeginState()
    {
        SetIsActive(true);

        UpdateAppearance();
    }
}

function SetIsActive(bool bIsActive)
{
    super.SetIsActive(bIsActive);

    if (SRI != none && bIsActive)
    {
        SRI.OnSquadRallyPointActivated(self);
    }
}

simulated function bool CanSpawnWithParameters(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex, optional bool bSkipTimeCheck)
{
    if (!super.CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex, bSkipTimeCheck))
    {
        return false;
    }

    if (self.SquadIndex != SquadIndex)
    {
        return false;
    }

    if (SpawnsRemaining == 1)
    {
        // TODO: must be SL to use; where are we gonna get this from? a PRI??
    }

    return true;
}

simulated function bool IsVisibleTo(int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex)
{
    return super.IsVisibleTo(TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex) && self.SquadIndex == SquadIndex;
}

function bool PerformSpawn(DHPlayer PC)
{
    local DarkestHourGame G;
    local vector SpawnLocation;
    local rotator SpawnRotation;

    G = DarkestHourGame(Level.Game);

    if (PC == none || PC.Pawn != none || G == none)
    {
        return false;
    }

    if (CanSpawnWithParameters(GRI, PC.GetTeamNum(), PC.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex) &&
        GetSpawnPosition(SpawnLocation, SpawnRotation, PC.VehiclePoolIndex))
    {
        if (G.SpawnPawn(PC, SpawnLocation, SpawnRotation, self) == none)
        {
            return false;
        }

        SpawnsRemaining -= 1;

        if (SpawnsRemaining <= 0)
        {
            // "A squad rally point has been exhausted."
            SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 46);

            Destroy();
        }

        return true;
    }

    return false;
}

function OnSpawnKill(Pawn VictimPawn, Controller KillerController)
{
    if (KillerController != none && KillerController.GetTeamNum() != GetTeamIndex())
    {
        // "A squad rally point has been overrun by enemies."
        SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 54);

        Destroy();
    }
}

simulated function string GetMapStyleName()
{
    return "DHRallyPointButtonStyle";
}

function UpdateAppearance()
{
    local DarkestHourGame G;
    local DH_LevelInfo.EAlliedNation AlliedNation;
    local StaticMesh NewStaticMesh;

    G = DarkestHourGame(Level.Game);

    if (G != none && G.DHLevelInfo != none)
    {
        AlliedNation = G.DHLevelInfo.AlliedNation;
    }

    if (IsActive())
    {
        switch (GetTeamIndex())
        {
        case AXIS_TEAM_INDEX:
            NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.GER_backpack_established';
            break;
        case ALLIES_TEAM_INDEX:
            switch (AlliedNation)
            {
            case NATION_Britain:
                NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.BRIT_backpack_established';
                break;
            case NATION_Canada:
                NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.CAN_backpack_established';
                break;
            case NATION_USSR:
                NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.RUS_backpack_established';
                break;
            default:
                NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.USA_backpack_established';
                break;
            }
        default:
            break;
        }
    }
    else
    {
        switch (GetTeamIndex())
        {
        case AXIS_TEAM_INDEX:
            NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.GER_backpack';
            break;
        case ALLIES_TEAM_INDEX:
            switch (AlliedNation)
            {
            case NATION_Britain:
                NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.BRIT_backpack';
                break;
            case NATION_Canada:
                NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.CAN_backpack';
                break;
            case NATION_USSR:
                NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.RUS_backpack';
                break;
            default:
                NewStaticMesh = StaticMesh'DH_Construction_stc.Backpacks.USA_backpack';
                break;
            }
        default:
            break;
        }
    }

    SetStaticMesh(NewStaticMesh);
}

function OnTeamIndexChanged()
{
    UpdateAppearance();
}

simulated function string GetMapText()
{
    return string(SpawnsRemaining);
}

defaultproperties
{
    StaticMesh=StaticMesh'DH_Construction_stc.Backpacks.USA_backpack'
    DrawType=DT_StaticMesh
    TeamIndex=-1
    SquadIndex=-1
    RallyPointIndex=-1
    SpawnsRemaining=15
    CreationSound=Sound'Inf_Player.Gibimpact.Gibimpact'
    EncroachmentRadiusInMeters=25
    EncroachmentPenaltyBlockThreshold=10
    EncroachmentPenaltyOverrunThreshold=30
    OverrunRadiusInMeters=10
    EstablishmentRadiusInMeters=25
    EstablishmentCounterThreshold=30
    OverrunMinimumTimeSeconds=15
    SpawnAccrualThreshold=30
    bHidden=false
    bCanSendAbandonmentWarningMessage=true
    bCombatSpawn=true
    SpawnRadius=60.0
    SpawnLocationOffset=(Z=52)
    SpawnProtectionTime=1.0
    SpawnKillProtectionTime=8.0
}

