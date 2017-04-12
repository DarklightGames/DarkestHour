//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGameReplicationInfo extends ROGameReplicationInfo;

struct ArtilleryTarget
{
    var bool                    bIsActive;
    var DHPlayer                Controller;
    var byte                    TeamIndex;
    var vector                  Location;
    var vector                  HitLocation;
    var float                   Time;
    var bool                    bIsSmoke;   // TODO: convert to enum
};

struct SpawnVehicle
{
    var int             SpawnPointIndex;
    var int             VehiclePoolIndex;
    var Vehicle         Vehicle;
};

const RADIOS_MAX = 10;

var string              CurrentGameType;

var ROArtilleryTrigger  CarriedAlliedRadios[RADIOS_MAX];
var ROArtilleryTrigger  CarriedAxisRadios[RADIOS_MAX];

var int                 AlliedNationID;
var int                 AlliesVictoryMusicIndex;
var int                 AxisVictoryMusicIndex;

var int                 RoundEndTime;  // Length of a round in seconds (this can be modified at real time unlike RoundDuration, which it replaces)

const ROLES_MAX = 16;

var DHRoleInfo          DHAxisRoles[ROLES_MAX];
var DHRoleInfo          DHAlliesRoles[ROLES_MAX];

var byte                DHAlliesRoleLimit[ROLES_MAX];
var byte                DHAlliesRoleBotCount[ROLES_MAX];
var byte                DHAlliesRoleCount[ROLES_MAX];
var byte                DHAxisRoleLimit[ROLES_MAX];
var byte                DHAxisRoleBotCount[ROLES_MAX];
var byte                DHAxisRoleCount[ROLES_MAX];

const MORTAR_TARGETS_MAX = 2;

// The maximum distance an artillery strike can be away from a marked target for
// a hit indicator to show on the map
var float ArtilleryTargetDistanceThreshold;

var ArtilleryTarget        AlliedArtilleryTargets[MORTAR_TARGETS_MAX];
var ArtilleryTarget        GermanArtilleryTargets[MORTAR_TARGETS_MAX];

var int                 SpawnsRemaining[2];
var float               AttritionRate[2];
var float               CurrentAlliedToAxisRatio;

// NOTE: Vehicle pool and spawn point info is heavily fragmented due to the arbitrary variable size limit (255 bytes) that exists in UnrealScript
const VEHICLE_POOLS_MAX = 32;

// TODO: vehicle classes should have been made available in static data for client and server to read
var class<ROVehicle>    VehiclePoolVehicleClasses[VEHICLE_POOLS_MAX];
var byte                VehiclePoolIsActives[VEHICLE_POOLS_MAX];
var float               VehiclePoolNextAvailableTimes[VEHICLE_POOLS_MAX];
var byte                VehiclePoolActiveCounts[VEHICLE_POOLS_MAX];
var byte                VehiclePoolMaxActives[VEHICLE_POOLS_MAX];
var byte                VehiclePoolMaxSpawns[VEHICLE_POOLS_MAX];
var byte                VehiclePoolSpawnCounts[VEHICLE_POOLS_MAX];
var byte                VehiclePoolIsSpawnVehicles[VEHICLE_POOLS_MAX];
var byte                VehiclePoolReservationCount[VEHICLE_POOLS_MAX];
var int                 VehiclePoolIgnoreMaxTeamVehiclesFlags;

var byte                MaxTeamVehicles[2];
var byte                TeamVehicleCounts[2];

const SPAWN_POINTS_MAX = 63;

var DHSpawnPointBase   SpawnPoints[SPAWN_POINTS_MAX];

const OBJECTIVES_MAX = 32;

var DHObjective         DHObjectives[OBJECTIVES_MAX];

var bool                bUseDeathPenaltyCount;

var localized string    ForceScaleText;
var localized string    ReinforcementsInfiniteText;
var localized string    DeathPenaltyText;

const CONSTRUCTION_CLASSES_MAX = 32;

var private array<string>   ConstructionClassNames;
var class<DHConstruction>   ConstructionClasses[CONSTRUCTION_CLASSES_MAX];

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        RoundEndTime,
        SpawnsRemaining,
        DHAxisRoles,
        DHAlliesRoles,
        DHAlliesRoleLimit,
        DHAlliesRoleCount,
        DHAxisRoleLimit,
        DHAxisRoleCount,
        DHAlliesRoleBotCount,
        DHAxisRoleBotCount,
        CarriedAlliedRadios,
        CarriedAxisRadios,
        AlliedArtilleryTargets,
        GermanArtilleryTargets,
        VehiclePoolVehicleClasses,
        VehiclePoolIsActives,
        VehiclePoolNextAvailableTimes,
        VehiclePoolActiveCounts,
        VehiclePoolMaxActives,
        VehiclePoolMaxSpawns,
        VehiclePoolSpawnCounts,
        VehiclePoolIsSpawnVehicles,
        VehiclePoolReservationCount,
        VehiclePoolIgnoreMaxTeamVehiclesFlags,
        MaxTeamVehicles,
        DHObjectives,
        AttritionRate,
        bUseDeathPenaltyCount,
        CurrentGameType,
        CurrentAlliedToAxisRatio,
        TeamVehicleCounts,
        SpawnPoints,
        ConstructionClasses;

    reliable if (bNetInitial && (Role == ROLE_Authority))
        AlliedNationID, AlliesVictoryMusicIndex, AxisVictoryMusicIndex;
}

// Modified to build SpawnPoints array
// Also to nullify all water splash effects in WaterVolumes & FluidSurfaceInfos, as they clash with splash effects in projectile classes that are more specific to the projectile
// Another problem is a big splash effect was being played for every ejected bullet shell case that hit water, looking totally wrong for such a small, relatively slow object
simulated function PostBeginPlay()
{
    local WaterVolume      WV;
    local FluidSurfaceInfo FSI;
    local int              i;

    super.PostBeginPlay();

    foreach AllActors(class'WaterVolume', WV)
    {
        WV.PawnEntryActor = none;
        WV.PawnEntryActorName = "";
        WV.EntryActor = none;
        WV.EntryActorName = "";
        WV.EntrySound = none;
        WV.EntrySoundName = "";
        WV.ExitActor = none;
        WV.ExitSound = none;
        WV.ExitSoundName = "";
    }

    foreach AllActors(class'FluidSurfaceInfo', FSI)
    {
        FSI.TouchEffect = none;
    }

    for (i = 0; i < ConstructionClassNames.Length; ++i)
    {
        Log(ConstructionClassNames[i]);
        Log(DynamicLoadObject(ConstructionClassNames[i], class'class'));

        AddConstructionClass(class<DHConstruction>(DynamicLoadObject(ConstructionClassNames[i], class'class')));
    }
}

function int AddConstructionClass(class<DHConstruction> ConstructionClass)
{
    local int i;

    if (ConstructionClass != none)
    {
        for (i = 0; i < arraycount(ConstructionClasses); ++i)
        {
            if (ConstructionClasses[i] == none)
            {
                ConstructionClasses[i] = ConstructionClass;
                return i;
            }
        }
    }

    return -1;
}

//------------------------------------------------------------------------------
// Spawn Point Functions
//------------------------------------------------------------------------------

simulated function int AddSpawnPoint(DHSpawnPointBase SP)
{
    local int i;

    if (SP == none)
    {
        return -1;
    }

    for (i = 0; i < arraycount(SpawnPoints); ++i)
    {
        if (SP == SpawnPoints[i])
        {
            return -1;
        }
    }

    for (i = 0; i < arraycount(SpawnPoints); ++i)
    {
        if (SpawnPoints[i] == none)
        {
            SpawnPoints[i] = SP;
            return i;
        }
    }

    return -1;
}

simulated function DHSpawnPointBase GetSpawnPoint(int SpawnPointIndex)
{
    if (SpawnPointIndex < 0 || SpawnPointIndex >= arraycount(SpawnPoints))
    {
        return none;
    }

    return SpawnPoints[SpawnPointIndex];
}

simulated function bool IsRallyPointIndexValid(DHPlayer PC, byte RallyPointIndex, int TeamIndex)
{
    local DHSpawnPoint_SquadRallyPoint RP;
    local DHPlayerReplicationInfo PRI;

    if (PC == none || PC.SquadReplicationInfo == none)
    {
        return false;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    RP = PC.SquadReplicationInfo.RallyPoints[RallyPointIndex];

    if (RP == none || PRI == none || PRI.Team.TeamIndex != RP.TeamIndex || PRI.SquadIndex != RP.SquadIndex)
    {
        return false;
    }

    return true;
}

simulated function bool CanSpawnWithParameters(int SpawnPointIndex, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex)
{
    local DHSpawnPointBase SP;

    SP = GetSpawnPoint(SpawnPointIndex);

    if (SP == none)
    {
        return false;
    }

    return SP.CanSpawnWithParameters(self, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex);
}

simulated function bool CanSpawnVehicle(int VehiclePoolIndex)
{
    local class<ROVehicle> VC;

    if (VehiclePoolIndex < 0 || VehiclePoolIndex >= VEHICLE_POOLS_MAX)
    {
        return false;
    }

    VC = VehiclePoolVehicleClasses[VehiclePoolIndex];

    if (!IgnoresMaxTeamVehiclesFlags(VehiclePoolIndex) &&
        TeamVehicleCounts[VC.default.VehicleTeam] >= MaxTeamVehicles[VC.default.VehicleTeam])
    {
        return false;
    }

    if (!IsVehiclePoolActive(VehiclePoolIndex))
    {
        return false;
    }

    if (ElapsedTime < VehiclePoolNextAvailableTimes[VehiclePoolIndex])
    {
        return false;
    }

    if (VehiclePoolSpawnCounts[VehiclePoolIndex] >= VehiclePoolMaxSpawns[VehiclePoolIndex])
    {
        return false;
    }

    if (VehiclePoolActiveCounts[VehiclePoolIndex] >= VehiclePoolMaxActives[VehiclePoolIndex])
    {
        return false;
    }

    return true;
}

//------------------------------------------------------------------------------
// Vehicle Pool Functions
//------------------------------------------------------------------------------

function SetVehiclePoolIsActive(byte VehiclePoolIndex, bool bIsActive)
{
    local Controller C;
    local DHPlayer PC;

    if (bIsActive)
    {
        VehiclePoolIsActives[VehiclePoolIndex] = 1;
    }
    else
    {
        VehiclePoolIsActives[VehiclePoolIndex] = 0;

        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = DHPlayer(C);

            if (PC != none && PC.VehiclePoolIndex == VehiclePoolIndex)
            {
                PC.VehiclePoolIndex = -1;
                PC.bSpawnPointInvalidated = true;
            }
        }
    }
}

simulated function bool IsVehiclePoolInfinite(byte VehiclePoolIndex)
{
    return VehiclePoolMaxSpawns[VehiclePoolIndex] == 255;
}

simulated function bool IsVehiclePoolActive(byte VehiclePoolIndex)
{
    return VehiclePoolIsActives[VehiclePoolIndex] != 0;
}

simulated function bool IsVehiclePoolIndexValid(RORoleInfo RI, byte VehiclePoolIndex)
{
    local class<ROVehicle> VehicleClass;

    if (RI == none)
    {
        return false;
    }

    if (VehiclePoolIndex >= arraycount(VehiclePoolVehicleClasses))
    {
        return false;
    }

    if (!IsVehiclePoolActive(VehiclePoolIndex))
    {
        return false;
    }

    VehicleClass = VehiclePoolVehicleClasses[VehiclePoolIndex];

    if (VehicleClass == none)
    {
        return false;
    }

    if (VehicleClass.default.bMustBeTankCommander && !RI.bCanBeTankCrew)
    {
        return false;
    }

    if (VehicleClass.default.VehicleTeam != RI.Side)
    {
        return false;
    }

    return true;
}

simulated function byte GetVehiclePoolSpawnsRemaining(byte VehiclePoolIndex)
{
    if (IsVehiclePoolInfinite(VehiclePoolIndex))
    {
        return 255;
    }

    return VehiclePoolMaxSpawns[VehiclePoolIndex] - VehiclePoolSpawnCounts[VehiclePoolIndex];
}

simulated function class<Vehicle> GetVehiclePoolVehicleClass(int VehiclePoolIndex)
{
    if (VehiclePoolIndex == -1 || VehiclePoolIndex >= arraycount(VehiclePoolVehicleClasses))
    {
        return none;
    }

    return VehiclePoolVehicleClasses[VehiclePoolIndex];
}

simulated function byte GetVehiclePoolAvailableReservationCount(int VehiclePoolIndex)
{
    local int Active, MaxActive, ReservationCount, VehiclePoolSpawnsRemaning;

    Active = VehiclePoolActiveCounts[VehiclePoolIndex];
    MaxActive = VehiclePoolMaxActives[VehiclePoolIndex];
    ReservationCount = VehiclePoolReservationCount[VehiclePoolIndex];
    VehiclePoolSpawnsRemaning = GetVehiclePoolSpawnsRemaining(VehiclePoolIndex);

    return Min(VehiclePoolSpawnsRemaning, (MaxActive - Active) - ReservationCount);
}

simulated function bool IsVehiclePoolReservable(DHPlayer PC, DHRoleInfo RI, int VehiclePoolIndex)
{
    if (PC == none || (PC.Pawn != none && PC.Pawn.Health > 0))
    {
        // Alive players cannot reserve vehicles
        return false;
    }

    if (!IsVehiclePoolIndexValid(RI, VehiclePoolIndex))
    {
        // Invalid vehicle pool specified
        return false;
    }

    if (GetVehiclePoolAvailableReservationCount(VehiclePoolIndex) <= 0)
    {
        // All available vehicles have been reserved
        return false;
    }

    return true;
}

function bool ReserveVehicle(DHPlayer PC, int VehiclePoolIndex)
{
    if (VehiclePoolIndex != -1 && !IsVehiclePoolReservable(PC, DHRoleInfo(PC.GetRoleInfo()), VehiclePoolIndex))
    {
        return false;
    }

    PC.VehiclePoolIndex = VehiclePoolIndex;

    if (VehiclePoolIndex != -1)
    {
        ++VehiclePoolReservationCount[VehiclePoolIndex];
    }

    return true;
}

function UnreserveVehicle(DHPlayer PC)
{
    if (PC.VehiclePoolIndex != -1)
    {
        --VehiclePoolReservationCount[PC.VehiclePoolIndex];
    }

    PC.VehiclePoolIndex = -1;
}

// Finds the matching VehicleClass but also check the bIsSpawnVehicle setting also matches
// Vital as same VehicleClass may well be in the vehicles list twice, with one being a spawn vehicle & the other the ordinary version, e.g. a half-track & a spawn vehicle HT
simulated function byte GetVehiclePoolIndex(Vehicle V)
{
    local int i;

    if (V != none)
    {
        for (i = 0; i < arraycount(VehiclePoolVehicleClasses); ++i)
        {
            if (V.Class == VehiclePoolVehicleClasses[i] && !(DHVehicle(V) != none && DHVehicle(V).IsSpawnVehicle() != bool(VehiclePoolIsSpawnVehicles[i])))
            {
                return i;
            }
        }
    }

    return 255;
}

simulated function bool IgnoresMaxTeamVehiclesFlags(int VehiclePoolIndex)
{
    if (VehiclePoolIndex >= 0)
    {
        return (VehiclePoolIgnoreMaxTeamVehiclesFlags & (1 << VehiclePoolIndex)) != 0;
    }

    return false;
}

//------------------------------------------------------------------------------
// Roles
//------------------------------------------------------------------------------

simulated function DHRoleInfo GetRole(int TeamIndex, int RoleIndex)
{
    if (RoleIndex < 0 || RoleIndex >= arraycount(DHAxisRoles))
    {
        return none;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return DHAxisRoles[RoleIndex];
        case ALLIES_TEAM_INDEX:
            return DHAlliesRoles[RoleIndex];
    }

    return none;
}

simulated function int GetRoleIndexAndTeam(RORoleInfo RI, out byte Team)
{
    local int i;

    for (i = 0; i < arraycount(DHAxisRoles); ++i)
    {
        if (RI == DHAxisRoles[i])
        {
            Team = AXIS_TEAM_INDEX;

            return i;
        }
    }

    for (i = 0; i < arraycount(DHAlliesRoles); ++i)
    {
        if (RI == DHAlliesRoles[i])
        {
            Team = ALLIES_TEAM_INDEX;

            return i;
        }
    }

    Team = NEUTRAL_TEAM_INDEX;

    return -1;
}

simulated function GetRoleCounts(RORoleInfo RI, out int Count, out int BotCount, out int Limit)
{
    local int Index;
    local byte Team;

    Index = GetRoleIndexAndTeam(RI, Team);

    if (Index == -1)
    {
        return;
    }

    switch (Team)
    {
        case AXIS_TEAM_INDEX:
            Limit = DHAxisRoleLimit[Index];
            Count = DHAxisRoleCount[Index];
            BotCount = DHAxisRoleBotCount[Index];
            break;
        case ALLIES_TEAM_INDEX:
            Limit = DHAlliesRoleLimit[Index];
            Count = DHAlliesRoleCount[Index];
            BotCount = DHAlliesRoleBotCount[Index];
            break;
    }
}

function ClearAllArtilleryTargets()
{
    local int i;

    for (i = 0; i < arraycount(GermanArtilleryTargets); ++i)
    {
        GermanArtilleryTargets[i].bIsActive = false;
    }

    for (i = 0; i < arraycount(AlliedArtilleryTargets); ++i)
    {
        AlliedArtilleryTargets[i].bIsActive = false;
    }
}

function ClearArtilleryTarget(DHPlayer PC)
{
    local int i;

    if (PC == none)
    {
        return;
    }

    for (i = 0; i < arraycount(GermanArtilleryTargets); ++i)
    {
        if (GermanArtilleryTargets[i].Controller == PC)
        {
            GermanArtilleryTargets[i].bIsActive = false;
            break;
        }
    }

    for (i = 0; i < arraycount(AlliedArtilleryTargets); ++i)
    {
        if (AlliedArtilleryTargets[i].Controller == PC)
        {
            AlliedArtilleryTargets[i].bIsActive = false;
            break;
        }
    }
}

function AddCarriedRadioTrigger(ROArtilleryTrigger AT)
{
    local int i;

    if (AT == none)
    {
        return;
    }

    if (AT.TeamCanUse == AT_Axis || AT.TeamCanUse == AT_Both)
    {
        for (i = 0; i < arraycount(CarriedAxisRadios); ++i)
        {
            if (CarriedAxisRadios[i] == none)
            {
                CarriedAxisRadios[i] = AT;

                break;
            }
        }
    }

    if (AT.TeamCanUse == AT_Allies || AT.TeamCanUse == AT_Both)
    {
        for (i = 0; i < arraycount(CarriedAlliedRadios); ++i)
        {
            if (CarriedAlliedRadios[i] == none)
            {
                CarriedAlliedRadios[i] = AT;

                break;
            }
        }
    }
}

function RemoveCarriedRadioTrigger(ROArtilleryTrigger AT)
{
    local int i;

    if (AT == none)
    {
        return;
    }

    if (AT.TeamCanUse == AT_Axis || AT.TeamCanUse == AT_Both)
    {
        for (i = 0; i < arraycount(CarriedAxisRadios); ++i)
        {
            if (CarriedAxisRadios[i] == AT)
            {
                CarriedAxisRadios[i] = none;
            }
        }
    }

    if (AT.TeamCanUse == AT_Allies || AT.TeamCanUse == AT_Both)
    {
        for (i = 0; i < arraycount(CarriedAlliedRadios); ++i)
        {
            if (CarriedAlliedRadios[i] == AT)
            {
                CarriedAlliedRadios[i] = none;
            }
        }
    }
}

// Modified to avoid "accessed none" errors on PRI.Team
function AddRallyPoint(PlayerReplicationInfo PRI, vector NewLoc, optional bool bRemoveFromList)
{
    if (PRI != none && PRI.Team != none)
    {
        super.AddRallyPoint(PRI, NewLoc, bRemoveFromList);
    }
}

// Modified to avoid "accessed none" errors on PRI.Team
function AddHelpRequest(PlayerReplicationInfo PRI, int ObjectiveID, int RequestType, optional vector RequestLocation)
{
    if (PRI != none && PRI.Team != none)
    {
        super.AddHelpRequest(PRI, ObjectiveID, RequestType, RequestLocation);
    }
}

// Modified to fix incorrect RequestType used to identify resupply request (was 2, which is a defend objective request - should be 3)
function RemoveMGResupplyRequestFor(PlayerReplicationInfo PRI)
{
    local int i;

    if (PRI == none || PRI.Team == none)
    {
        return;
    }

    // Search request array to see if there's an MG resupply request for this player & clear it if there is
    if (PRI.Team.TeamIndex == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(AxisHelpRequests); ++i)
        {
            if (AxisHelpRequests[i].OfficerPRI == PRI && AxisHelpRequests[i].RequestType == 2)
            {
                AxisHelpRequests[i].OfficerPRI = none;
                AxisHelpRequests[i].RequestType = 255;
                break;
            }
        }
    }
    else if (PRI.Team.TeamIndex == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(AlliedHelpRequests); ++i)
        {
            if (AlliedHelpRequests[i].OfficerPRI == PRI && AlliedHelpRequests[i].RequestType == 2)
            {
                AlliedHelpRequests[i].OfficerPRI = none;
                AlliedHelpRequests[i].RequestType = 255;
                break;
            }
        }
    }
}

simulated function string GetTeamScaleString(int Team)
{
   local float     d;
   local int       i;

   if (Team == AXIS_TEAM_INDEX)
   {
       d = (1.0 - CurrentAlliedToAxisRatio) - (1.0 - (1.0 - CurrentAlliedToAxisRatio));
   }

   else if (Team == ALLIES_TEAM_INDEX)
   {
       d = CurrentAlliedToAxisRatio - (1.0 - CurrentAlliedToAxisRatio);
   }

   i = int(Round(d * 100));

   if (i > 0)
   {
       return "+" $ i $ "%";
   }
   else
   {
       return string(i) $ "%";
   }
}

defaultproperties
{
    AlliesVictoryMusicIndex=-1
    AxisVictoryMusicIndex=-1
    ArtilleryTargetDistanceThreshold=15088 //250 meters in UU
    ForceScaleText="Size"
    ReinforcementsInfiniteText="Infinite"
    DeathPenaltyText="Death Penalty"
    ConstructionClassNames(0)="DH_Constructions.DHConstruction_ConcertinaWire"
    ConstructionClassNames(1)="DH_Constructions.DHConstruction_Hedgehog"
    ConstructionClassNames(2)="DH_Constructions.DHConstruction_PlatoonHQ"
    ConstructionClassNames(3)="DH_Constructions.DHConstruction_Resupply"
    ConstructionClassNames(4)="DH_Constructions.DHConstruction_Sandbags"
    ConstructionClassNames(5)="DH_Constructions.DHConstruction_ATGun_Medium"
}

