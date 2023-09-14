//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSpawnPointBase extends Actor
    abstract;

enum ESpawnPointBlockReason
{
    SPBR_None,
    SPBR_EnemiesNearby,
    SPBR_InObjective,
    SPBR_Full,
    SPBR_Burning,
    SPBR_Constructing,
    SPBR_MissingRequirement,
    SPBR_NotInSafeZone,
    SPBR_Waiting,
};

var ESpawnPointBlockReason  BlockReason; // any reason why spawn point can't be used currently

var protected DHGameReplicationInfo GRI; // just a convenient reference to the GRI actor

var     private bool    bIsActive;       // whether spawn point is currently active
var     private int     TeamIndex;       // which team this spawn point belongs to
var     int             SpawnPointIndex; // spawn point's index number in the GRI's SpawnPoints array
var     bool            bCombatSpawn;    // is a combat spawn point (MDV, squad rally, HQ)
var()   bool            bMainSpawn;      // is a main spawn for gametype: Advance
var()   bool            bAirborneSpawn;  // the spawn is located on a plane or in the air

var     string          SpawnPointStyle; // style name to use for spawnpoints (can be overriden in GetMapStyleName())

var     int             BaseSpawnTimePenalty;    // how many seconds a player will have to addtionally wait to spawn on this spawn point
var     float           SpawnProtectionTime;     // how many seconds a player will be invulnerable after spawning on this spawn point
var     float           SpawnKillProtectionTime; // how many seconds a kill on a player will be considered a spawn kill after spawning on this spawn point

// Parameters for spawning in a radius (NOTE: currently only works for infantry!)
var     vector          SpawnLocationOffset;
var     float           SpawnRadius;
var     int             SpawnRadiusSegmentCount;
var     bool            bShouldTraceCheckSpawnLocations;

var     bool            bShouldDelegateTimer;           // When true, the SetTimer loop will not be initiated on start-up, and it will be up to another area of the code to call the Timer logic manually.

// Spawn killing
var int     SpawnKillPenalty;
var int     SpawnKillPenaltyCounter;
var int     SpawnKillPenaltyForgivenessPerSecond;

// Encroachment
var bool    bCanBeEncroachedUpon;
var int     EncroachmentRadiusInMeters;                 // The distance, in meters, that enemies must be within to affect the EncroachmentPenaltyCounter
var int     EncroachmentPenaltyBlockThreshold;          // The value that EncroachmentPenaltyCounter must reach for the spawn point to be "blocked".
var int     EncroachmentPenaltyOverrunThreshold;        // The value that EncroachmentPenaltyCounter must reach for the spawn point to be "overrun".
var int     EncroachmentPenaltyMax;                     // The maximum value that EncroachmentPenaltyCounter can reach.
var int     EncroachmentPenaltyCounter;                 // Running counter of encroachment penalty.
var int     EncroachmentPenaltyForgivenessPerSecond;    // The number of points deducted from the encroachment penalty counter when there are no longer any encroaching enemies.
var int     EncroachmentSpawnTimePenalty;               // If being encroached upon, this amount of seconds will be added to the spawn timer
var int     EncroachmentEnemyCountMin;                  // The amount of enemies needed nearby to increment encroachment penalty counter
var bool    bCanEncroachmentOverrun;                    // When true, if the overrun timer exceeds EncroachmentPenaltyOverrunThreshold, OnOverrun will be called, destroying the spawn point.

var bool    bIsEncroachedUpon;                          // True if there are enemies encroaching upon the spawn point.

var bool    bIsLowPriority;                             // When true, this spawn point may be deleted in favor of spawning a newer high priority spawn point if the # of potential spawn points is reached.

// Map icon (used only for showing spotted spawn points)
var class<DHMapIconAttachment> MapIconAttachmentClass;
var DHMapIconAttachment        MapIconAttachment;

// Danger zone
var(DHDangerZone) float BaseInfluenceModifier;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        SpawnPointIndex, TeamIndex, BlockReason, bIsActive, bIsEncroachedUpon;
}

// Implemented to add this spawn point to the GRI's SpawnPoints array, setting the GRI reference & our index position in that array
simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        // Add this spawn point to the GRI's list of spawn points.
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        SpawnPointIndex = GRI.AddSpawnPoint(self);

        if (SpawnPointIndex == -1)
        {
            Error("Failed to add" @ self @ "to spawn point list!");
        }

        if (MapIconAttachmentClass != none)
        {
            MapIconAttachment = Spawn(MapIconAttachmentClass, self);

            if (MapIconAttachment != none)
            {
                MapIconAttachment.SetBase(self);
                MapIconAttachment.Setup();
            }
            else
            {
                MapIconAttachmentClass.static.OnError(ERROR_SpawnFailed);
            }
        }

        if (!bShouldDelegateTimer)
        {
            SetTimer(1.0, true);
        }
    }
}

function OnOverrunByEncroachment();

function Timer()
{
    local int EncroachingEnemiesCount;

    BlockReason = SPBR_None;

    // Encroachment
    if (bCanBeEncroachedUpon)
    {
        GetPlayerCountsWithinRadius(EncroachmentRadiusInMeters,,, EncroachingEnemiesCount);

        if (EncroachingEnemiesCount >= EncroachmentEnemyCountMin)
        {
            // There are enemies nearby, so increase the encroachment penalty
            // counter by the number of nearby enemies.
            EncroachmentPenaltyCounter += EncroachingEnemiesCount;
        }
        else
        {
            // There are no enemies nearby, decrease the penalty timer.
            EncroachmentPenaltyCounter -= EncroachmentPenaltyForgivenessPerSecond;
        }

        EncroachmentPenaltyCounter = Clamp(EncroachmentPenaltyCounter, 0, EncroachmentPenaltyMax);
        bIsEncroachedUpon = EncroachmentPenaltyCounter != 0;

        if (bCanEncroachmentOverrun && EncroachmentPenaltyCounter >= EncroachmentPenaltyOverrunThreshold)
        {
            OnOverrunByEncroachment();
            Destroy();
        }
        else if (EncroachmentPenaltyCounter >= EncroachmentPenaltyBlockThreshold)
        {
            // The encoroachment penalty counter has reached a point where we
            // are now blocking the spawn from being used until enemies are
            // cleared out.
            BlockReason = SPBR_EnemiesNearby;
        }
    }

    // Spawn kill penalty
    SpawnKillPenaltyCounter = Max(0, SpawnKillPenaltyCounter - SpawnKillPenaltyForgivenessPerSecond);

    if (SpawnKillPenaltyCounter > 0)
    {
        BlockReason = SPBR_EnemiesNearby;
    }
}

// Modified to deactivate spawn point so any players' spawns get invalidated if they are set to spawn here
event Destroyed()
{
    super.Destroyed();

    SetIsActive(false);

    if (MapIconAttachment != none)
    {
        MapIconAttachment.Destroy();
    }
}

// Override to provide the business logic that does the spawning
function bool PerformSpawn(DHPlayer PC)
{
    local DarkestHourGame G;
    local vector SpawnLocation;
    local rotator SpawnRotation;
    local Pawn P;

    G = DarkestHourGame(Level.Game);

    if (PC == none || PC.Pawn != none || G == none)
    {
        return false;
    }

    if (CanSpawnWithParameters(GRI, PC.GetTeamNum(), PC.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex) &&
        GetSpawnPosition(SpawnLocation, SpawnRotation, PC.VehiclePoolIndex))
    {
        P = G.SpawnPawn(PC, SpawnLocation, SpawnRotation, self);

        if (P != none)
        {
            OnPawnSpawned(P);
        }

        return P != none;
    }

    return false;
}

// Called when a spawn is spawned from this spawn point.
function OnPawnSpawned(Pawn P);

// Called when a pawn is spawn killed from this spawn point - override in child classes
function OnSpawnKill(Pawn VictimPawn, Controller KillerController);

// Override to specify which vehicles can spawn at this spawn point
simulated function bool CanSpawnVehicle(DHGameReplicationInfo GRI, int VehiclePoolIndex, optional bool bSkipTimeCheck);

// Override to limit certain roles from using this spawn point
simulated function bool CanSpawnRole(DHRoleInfo RI)
{
    return RI != none;
}

// Override to specify a different spawn pose, otherwise it just uses the spawn point's pose
function bool GetSpawnPosition(out vector SpawnLocation, out rotator SpawnRotation, int VehiclePoolIndex)
{
    local DHPawnCollisionTest CT;
    local vector              L;
    local float               Angle, AngleInterval;
    local int                 i, j, k;

    // TODO: The spawn radius only works for infantry spawns; in future it would
    // be handy to use a radius for vehicle spawns. Unfortunately this is less
    // reliable since the vehicle radii would have to be considerably larger
    // due to their larger and varied sizes.
    if (VehiclePoolIndex == -1 && SpawnRadius != 0.0)
    {
        AngleInterval = (Pi * 2) / SpawnRadiusSegmentCount;
        j = Rand(SpawnRadiusSegmentCount);

        for (i = 0; i < SpawnRadiusSegmentCount; ++i)
        {
            k = (i + j) % SpawnRadiusSegmentCount;
            Angle = AngleInterval * k;

            L = Location;
            L.X += Cos(Angle) * SpawnRadius;
            L.Y += Sin(Angle) * SpawnRadius;
            L.Z += 10.0 + class'DHPawn'.default.CollisionHeight / 2;

            // If enabled, this check ensures we don't spawn in a place that's
            // not visible from the origin. This stops a bug where players could
            // spawn inside of "hollow" static meshes or on the outside of
            // buildings when a rally point was placed on the inside of the
            // building.
            if (bShouldTraceCheckSpawnLocations && !FastTrace(L, Location))
            {
                continue;
            }

            CT = Spawn(class'DHPawnCollisionTest',,, L);

            if (CT != none)
            {
                break;
            }
        }

        if (CT != none)
        {
            SpawnLocation = L + SpawnLocationOffset;
            SpawnRotation = Rotation;
            CT.Destroy();

            return true;
        }
    }

    SpawnLocation = Location + SpawnLocationOffset;
    SpawnRotation = Rotation;

    return true;
}

simulated function bool IsVisibleToPlayer(DHPlayer PC)
{
    return IsVisibleTo(PC.GetTeamNum(), PC.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex);
}

// Returns true if the spawn point is "visible" to a player with the arguments provided
simulated function bool IsVisibleTo(int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex)
{
    if (self.TeamIndex != TeamIndex || !bIsActive)
    {
        return false;
    }

    if (BlockReason == SPBR_NotInSafeZone)
    {
        return false;
    }

    return true;
}

// A blocked spawn point is an active spawn point that, for whatever reason,
// is not currently available to be spawned on
simulated function bool IsBlocked()
{
    return BlockReason != SPBR_None;
}

// Returns true if the given arguments are satisfactory for spawning on this spawn point
simulated function bool CanSpawnWithParameters(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex, optional bool bSkipTimeCheck)
{
    if (GRI == none || self.TeamIndex != TeamIndex || !bIsActive || IsBlocked())
    {
        return false;
    }

    if (!CanSpawnRole(GRI.GetRole(TeamIndex, RoleIndex)))
    {
        return false;
    }

    if (VehiclePoolIndex >= 0 && !CanSpawnVehicle(GRI, VehiclePoolIndex, bSkipTimeCheck))
    {
        return false;
    }

    return true;
}

simulated function bool IsActive()
{
    return bIsActive;
}

function SetIsActive(bool bIsActive)
{
    local Controller C;
    local DHPlayer PC;

    self.bIsActive = bIsActive;

    if (!bIsActive)
    {
        // Invalidate spawns, if necessary.
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = DHPlayer(C);

            if (PC != none && PC.SpawnPointIndex == SpawnPointIndex)
            {
                PC.SpawnPointIndex = -1;
                PC.bSpawnParametersInvalidated = true;
            }
        }
    }
}

// Override to change the button style for display on the deploy menu.
simulated function string GetMapStyleName()
{
    if (bMainSpawn)
    {
        return "DHMainSpawnButtonStyle";
    }

    if (bAirborneSpawn)
    {
        return "DHParatroopersButtonStyle";
    }

    return SpawnPointStyle;
}

// Override to change the text displayed overtop of the spawn point icon on the map.
simulated function string GetMapText();

// TODO: I don't like this one bit! SEPARATE OUT INTO DIFFERENT FUNCTIONS
function GetPlayerCountsWithinRadius(float RadiusInMeters, optional int SquadIndex, optional out int SquadmateCount, optional out int EnemyCount, optional out int TeammateCount)
{
    local Pawn P;
    local DHPlayerReplicationInfo OtherPRI;

    SquadmateCount = 0;
    EnemyCount = 0;
    TeammateCount = 0;

    foreach RadiusActors(class'Pawn', P, class'DHUnits'.static.MetersToUnreal(RadiusInMeters))
    {
        if (P != none && !P.bHidden && !P.bDeleteMe && P.Health > 0 && P.PlayerReplicationInfo != none)
        {
            if (P.GetTeamNum() == TeamIndex)
            {
                TeammateCount += 1;

                OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

                if (OtherPRI != none && OtherPRI.SquadIndex == SquadIndex)
                {
                    SquadmateCount += 1;
                }
            }
            else if (Vehicle(P) == none)
            {
                EnemyCount += 1;
            }
        }
    }
}

// Override to add a spawn timer penalty for anyone spawning at this spawn point.
simulated function int GetSpawnTimePenalty()
{
    return BaseSpawnTimePenalty;
}

final simulated function int GetTeamIndex()
{
    return TeamIndex;
}

final function SetTeamIndex(int TeamIndex)
{
    if (self.TeamIndex != TeamIndex)
    {
        self.TeamIndex = TeamIndex;

        OnTeamIndexChanged();

        if (MapIconAttachment != none)
        {
            MapIconAttachment.SetTeamIndex(GetTeamIndex());
        }
    }
}

simulated function bool CanPlayerSpawnImmediately(DHPlayer PC)
{
    return false;
}

// Desirability of the spawn point. Higher value means more desireable.
// Used for determining whether or not to invalidate the player's spawn
// if a more desirable spawn point is available.
simulated function int GetDesirability()
{
    if (bMainSpawn)
    {
        // Main spawns are the least desirable spawns.
        return 0;
    }

    return 1;
}

function OnTeamIndexChanged();

defaultproperties
{
    SpawnPointStyle="DHSpawnButtonStyle"
    TeamIndex=-1
    SpawnProtectionTime=2.0
    SpawnKillProtectionTime=7.0
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bIsActive=false
    bHidden=true
    SpawnRadiusSegmentCount=8

    // Danger zone
    BaseInfluenceModifier=1
}
