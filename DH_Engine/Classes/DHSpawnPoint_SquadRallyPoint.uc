//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSpawnPoint_SquadRallyPoint extends DHSpawnPointBase
    notplaceable;

var DHSquadReplicationInfo SRI;                 // Convenience variable to access the SquadReplicationInfo.
var int SquadIndex;                             // The squad index of the squad that owns this rally point.
var int RallyPointIndex;                        // The index into SRI.RallyPoints.
var int SpawnsRemaining;                        // The amount of spawns remaining on the rally point.

// Creation
var float CreatedTimeSeconds;                   // The time (relative to Level.TimeSeconds) that this rally point was created
var sound CreationSound;                        // Sound that is played when the squad rally point is first placed.

// Establishment
var int   EstablishmentRadiusInMeters;          // The distance, in meters, that squadmates and enemies must be within to influence the EstablishmentCounter.
var float EstablishmentStartTimeSeconds;        // The value of Level.TimeSeconds when this rally point began Establishment.
var float EstablishmentCounter;                 // Running counter to keep track of Establishment status.
var float EstablishmentCounterThreshold;        // The value that EstablishmentCounter must reach for the rally point to be "established".

// Overrun
var int   OverrunRadiusInMeters;                // The distance, in meters, that enemies must be within to immediately overrun a rally point.
var float OverrunMinimumTimeSeconds;            // The number of seconds a rally point must be "alive" for in order to be overrun by enemies. (To stop squad rally points being used as "enemy radar".

// Abandonment
var bool bCanSendAbandonmentWarningMessage;     // Whether or not we should send the abandonment message the next time the squad rally point has no teammates nearby while establishing

// Accrual timer (used for adding available spawns at regular intervals)
var int SpawnAccrualTimer;
var int SpawnAccrualThreshold;

// Health
var int Health;

// Instigator
var DHPlayer InstigatorController;

// Metrics
var DHMetricsRallyPoint MetricsObject;

// Objective
var ROObjective Objective;
var bool bIsInActiveObjective;
var bool bIsExposed;
var int InActiveObjectivePenaltySeconds;
var int IsExposedPenaltySeconds;

// Attachments
var class<DHResupplyAttachment>         ResupplyAttachmentClass;
var DHResupplyAttachment                ResupplyAttachment;
var DHResupplyStrategy.EResupplyType    ResupplyType;
var float                               ResupplyAttachmentCollisionRadius;
var float                               ResupplyAttachmentCollisionHeight;
var float                               ResupplyTime;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        SquadIndex, RallyPointIndex, SpawnsRemaining, bIsInActiveObjective, bIsExposed;
}

function Reset()
{
    // TODO: set destroyed reason?
    Destroy();
}

function PostBeginPlay()
{
    local int i;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        if (MapIconAttachment != none)
        {
            MapIconAttachment.IsInDangerZone = IsExposed;
        }

        SRI = DarkestHourGame(Level.Game).SquadReplicationInfo;

        CreatedTimeSeconds = Level.TimeSeconds;

        if (SRI == none)
        {
            Destroy();
        }

        PlaySound(CreationSound, SLOT_None, 4.0,, 60.0,, true);

        if (GRI != none)
        {
            for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
            {
                if (GRI.DHObjectives[i] != none && GRI.DHObjectives[i].WithinArea(self))
                {
                    // We'll make a bold assumption that it's not really possible
                    // to be in multiple objectives at once and just stop at one.
                    Objective = GRI.DHObjectives[i];

                    break;
                }
            }
        }
    }
}

auto state Constructing
{
    function Timer()
    {
        local int SquadmateCount;
        local int EnemyCount;
        local bool bIsBeingAbandoned;

        global.Timer();

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
            bIsBeingAbandoned = true;
            EstablishmentCounter -= 1;
        }

        if (EstablishmentCounter >= EstablishmentCounterThreshold)
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

                if (MetricsObject != none)
                {
                    if (bIsBeingAbandoned)
                    {
                        MetricsObject.DestroyedReason = REASON_Abandoned;
                    }
                    else
                    {
                        MetricsObject.DestroyedReason = REASON_Encroached;
                    }
                }

                Destroy();
            }
        }
    }

Begin:
    EstablishmentStartTimeSeconds = Level.TimeSeconds;
}

function Timer()
{
    local int OverrunningEnemiesCount;

    super.Timer();

    if (bDeleteMe)
    {
        // Rally point is already slated to be deleted.
        return;
    }

    GetPlayerCountsWithinRadius(OverrunRadiusInMeters,,, OverrunningEnemiesCount);

    // Destroy the rally point immediately if there are enemies within a
    // very short distance.
    if (OverrunningEnemiesCount >= 1)
    {
        // "A squad rally point has been overrun by enemies."
        SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 54);

        if (MetricsObject != none)
        {
            MetricsObject.DestroyedReason = REASON_Overrun;
        }

        Destroy();
    }

    // Update the "in active objective" status.
    bIsInActiveObjective = Objective != none && Objective.IsActive();
}

state Active
{
    event BeginState()
    {
        SetIsActive(true);

        AwardScoreOnEstablishment();

        UpdateAppearance();

        if (MetricsObject != none)
        {
            MetricsObject.bIsEstablished = true;
        }

        OnUpdated();

        ResupplyAttachment = Spawn(ResupplyAttachmentClass, self);

        if (ResupplyAttachment != none)
        {
            ResupplyAttachment.SetResupplyType(ResupplyType);
            ResupplyAttachment.SetTeamIndex(GetTeamIndex());
            ResupplyAttachment.SetSquadIndex(SquadIndex);
            ResupplyAttachment.SetCollisionSize(ResupplyAttachmentCollisionRadius, ResupplyAttachmentCollisionHeight);
            ResupplyAttachment.SetBase(self);
            ResupplyAttachment.UpdateTime = ResupplyTime;
            ResupplyAttachment.ResupplyStrategy.bGivesExtraAmmo = false;
        }
        else
        {
            Warn("Failed to spawn resupply attachment!");
        }
    }
}

function OnOverrunByEncroachment()
{
    // "A squad rally point has been overrun by enemies."
    SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 54);

    if (MetricsObject != none)
    {
        MetricsObject.DestroyedReason = REASON_Encroached;
    }

    Destroy();
}

function SetIsActive(bool bIsActive)
{
    super.SetIsActive(bIsActive);

    if (SRI != none && bIsActive)
    {
        SRI.OnSquadRallyPointActivated(self);
    }
}

function OnUpdated()
{
    UpdateExposedStatus();

    if (SRI != none)
    {
        SRI.OnSquadRallyPointUpdated(self);
    }
}

function UpdateExposedStatus()
{
    bIsExposed = GRI != none && GRI.IsInDangerZone(Location.X, Location.Y, GetTeamIndex());

    if (MapIconAttachment != none)
    {
        MapIconAttachment.Updated();
    }
}

simulated function bool IsExposed()
{
    return bIsExposed;
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

function OnPawnSpawned(Pawn P)
{
    SpawnsRemaining -= 1;

    if (InstigatorController != none &&
        InstigatorController != P.Controller &&
        InstigatorController.GetTeamNum() == GetTeamIndex() &&
        InstigatorController.GetSquadIndex() == SquadIndex)
    {
        InstigatorController.ReceiveScoreEvent(class'DHScoreEvent_SquadRallyPointSpawn'.static.Create());
    }

    if (MetricsObject != none)
    {
        ++MetricsObject.SpawnCount;
    }

    if (SpawnsRemaining <= 0)
    {
        // "A squad rally point has been exhausted."
        SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 46);

        if (MetricsObject != none)
        {
            MetricsObject.DestroyedReason = REASON_Exhausted;
        }

        Destroy();
    }
}

function OnSpawnKill(Pawn VictimPawn, Controller KillerController)
{
    if (KillerController != none && KillerController.GetTeamNum() != GetTeamIndex())
    {
        // "A squad rally point has been overrun by enemies."
        SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 54);

        if (MetricsObject != none)
        {
            MetricsObject.DestroyedReason = REASON_SpawnKill;
        }

        Destroy();
    }
}

function UpdateAppearance()
{
    local DarkestHourGame G;
    local StaticMesh NewStaticMesh;
    local class<DHNation> NationClass;

    G = DarkestHourGame(Level.Game);

    if (G == none || G.DHLevelInfo == none)
    {
        return;
    }

    NationClass = G.DHLevelInfo.GetTeamNationClass(GetTeamIndex());

    if (NationClass == none)
    {
        return;
    }

    if (IsActive())
    {
        NewStaticMesh = NationClass.default.RallyPointStaticMeshActive;
    }
    else
    {
        NewStaticMesh = NationClass.default.RallyPointStaticMesh;
    }

    SetStaticMesh(NewStaticMesh);
}

function OnTeamIndexChanged()
{
    local bool bIsInFriendlyTerritory;

    UpdateAppearance();

    if (IsInState('Constructing'))
    {
        bIsInFriendlyTerritory = GRI.IsInDangerZone(Location.X, Location.Y, int(!bool(GetTeamIndex())));

        if (bIsInFriendlyTerritory)
        {
            EstablishmentCounterThreshold = default.EstablishmentCounterThreshold * 0.5;
        }
    }
}

simulated function string GetMapText()
{
    return string(SpawnsRemaining);
}

simulated function int GetSpawnTimePenalty()
{
    local int SpawnTimePenalty;

    SpawnTimePenalty = BaseSpawnTimePenalty;

    if (bIsEncroachedUpon)
    {
        SpawnTimePenalty += EncroachmentSpawnTimePenalty;
    }

    if (bIsInActiveObjective)
    {
        SpawnTimePenalty += InActiveObjectivePenaltySeconds;
    }

    if (bIsExposed)
    {
        SpawnTimePenalty += IsExposedPenaltySeconds;
    }

    return SpawnTimePenalty;
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    if (EventInstigator == none || EventInstigator.GetTeamNum() == GetTeamIndex())
    {
        // You cannot damage your own rally points.
        return;
    }

    Health -= Damage;

    if (Health <= 0)
    {
        // "A squad rally point has been destroyed."
        SRI.BroadcastSquadLocalizedMessage(GetTeamIndex(), SquadIndex, SRI.SquadMessageClass, 68);

        if (MetricsObject != none)
        {
            MetricsObject.DestroyedReason = REASON_Damaged;
        }

        Destroy();
    }
}

// Give nearby squadmates points for helping establish the rally point.
function AwardScoreOnEstablishment()
{
    local Pawn P;
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local int EstablisherCount;

    EstablisherCount = 1;

    foreach RadiusActors(class'Pawn', P, class'DHUnits'.static.MetersToUnreal(EstablishmentRadiusInMeters))
    {
        if (P != none && !P.bDeleteMe && P.Health > 0 && P.PlayerReplicationInfo != none && P.GetTeamNum() == GetTeamIndex())
        {
            PC = DHPlayer(P.Controller);

            if (PC != none)
            {
                PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

                // Don't award the SL himself, he gets his own award.
                if (PRI != none && !PRI.IsSquadLeader() && PC.GetSquadIndex() == SquadIndex)
                {
                    PC.ReceiveScoreEvent(class'DHScoreEvent_SquadRallyPointEstablishedAssist'.static.Create());

                    ++EstablisherCount;
                }
            }
        }
    }

    if (MetricsObject != none)
    {
        MetricsObject.EstablisherCount = EstablisherCount;
    }
}

function Destroyed()
{
    if (SRI != none)
    {
        SRI.OnSquadRallyPointDestroyed(self);
    }

    super.Destroyed();

    if (MetricsObject != none)
    {
        MetricsObject.DestroyedAt = class'DateTime'.static.Now(self);
    }

    if (ResupplyAttachment != none)
    {
        ResupplyAttachment.Destroy();
    }
}

simulated function bool CanPlayerSpawnImmediately(DHPlayer PC)
{
    return PC != none
        && PC.IsSquadLeader()
        && SpawnsRemaining == 1
        && PC.SquadReplicationInfo != none
        && PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex()) > 1;
}

simulated function int GetDesirability()
{
    return 4;
}

defaultproperties
{
    SpawnPointStyle="DHRallyPointButtonStyle"

    StaticMesh=StaticMesh'DH_Construction_stc.Backpacks.USA_backpack'
    DrawType=DT_StaticMesh
    TeamIndex=-1
    SquadIndex=-1
    RallyPointIndex=-1
    CreationSound=Sound'Inf_Player.Gibimpact.Gibimpact'
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_SpawnPoint_SquadRallyPoint'

    bCanBeEncroachedUpon=true
    EncroachmentRadiusInMeters=50
    EncroachmentPenaltyMax=30
    EncroachmentPenaltyBlockThreshold=15
    EncroachmentPenaltyOverrunThreshold=30
    EncroachmentSpawnTimePenalty=15
    EncroachmentEnemyCountMin=3
    EncroachmentPenaltyForgivenessPerSecond=5
    bCanEncroachmentOverrun=true

    InActiveObjectivePenaltySeconds=15
    IsExposedPenaltySeconds=15

    OverrunRadiusInMeters=15
    EstablishmentRadiusInMeters=25
    EstablishmentCounterThreshold=10
    OverrunMinimumTimeSeconds=15
    SpawnAccrualThreshold=30
    bHidden=false
    bCanSendAbandonmentWarningMessage=true
    bCombatSpawn=true
    SpawnRadius=60.0
    SpawnLocationOffset=(Z=52)
    SpawnProtectionTime=1.0
    SpawnKillProtectionTime=8.0
    bShouldTraceCheckSpawnLocations=true
    Health=150
    bShouldDelegateTimer=true
    bCanBeDamaged=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=false
    bBlockProjectiles=true
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
    bBlockKarma=false

    // Attachments
    ResupplyAttachmentClass=class'DHResupplyAttachment'
    ResupplyType=RT_Mortars
    ResupplyAttachmentCollisionRadius=300
    ResupplyAttachmentCollisionHeight=100
    ResupplyTime=30
}
