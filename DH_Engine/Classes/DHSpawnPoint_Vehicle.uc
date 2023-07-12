//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// This is a spawn point that gets attached to "spawn vehicles" like the
// halftracks.
//==============================================================================

class DHSpawnPoint_Vehicle extends DHSpawnPointBase
    notplaceable;

const SPAWN_VEHICLES_BLOCK_RADIUS = 2048.0;

var     DHVehicle   Vehicle;        // Reference to the owning vehicle.
var     bool        bIsTemporary;   // When true, this is a "temporary" spawn point that will be destroyed soon.

var     bool        bHasSpawnKillPenalty;
var     int         SpawnKillPenalty;
var     int         SpawnKillPenaltyCounter;
var     float       CreatedTimeSeconds;

replication
{
    reliable if (Role == ROLE_Authority && bNetDirty)
        bIsTemporary;
}

// Modified to start a repeating timer to keep checking whether this spawn vehicle can be deployed into
function PostBeginPlay()
{
    super.PostBeginPlay();

    CreatedTimeSeconds = Level.TimeSeconds;

    SetTimer(1.0, true);
}

function OnSpawnKill(Pawn VictimPawn, Controller KillerController)
{
    if (bHasSpawnKillPenalty)
    {
        SpawnKillPenaltyCounter += default.SpawnKillPenalty;
    }
}

function DHSpawnPointBase.ESpawnPointBlockReason GetSpawnPointBlockReason()
{
    local int i;
    local DHObjective O;
    local Pawn P;
    local DHGameReplicationInfo GRI;
    local bool bIsInSafeZone;
    local bool bIsNewSpawn;

    if (Vehicle.IsVehicleBurning())
    {
        return SPBR_Burning;
    }

    // Check to ensure that we are in our team's safe zone.
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    // Check that we are not inside the danger zone.
    if (GRI.IsInDangerZone(Location.X, Location.Y, GetTeamIndex()))
    {
        return SPBR_EnemiesNearby;
    }

    if (bIsTemporary)
    {
        // For temporary spawn vehicles, we need to ensure that we are either a brand new
        // vehicle or we are in our team's safe zone.
        const NEW_SPAWN_THRESHOLD = 20.0;
        bIsNewSpawn = (Level.TimeSeconds - CreatedTimeSeconds) < NEW_SPAWN_THRESHOLD;
        bIsInSafeZone = GRI.IsInDangerZone(Location.X, Location.Y, int(!bool(GetTeamIndex())));

        if (!GRI.bIsInSetupPhase && !bIsNewSpawn && !bIsInSafeZone)
        {
            return SPBR_NotInSafeZone;
        }
    }

    // Check that we aren't blocked because of a recent spawn kill
    if (SpawnKillPenaltyCounter > 0)
    {
        return SPBR_EnemiesNearby;
    }

    // Check whether this spawn vehicle is inside an active objective
    for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
    {
        O = GRI.DHObjectives[i];

        if (O != none && O.bActive && O.WithinArea(Vehicle))
        {
            return SPBR_InObjective;
        }
    }

    // Check whether there is an enemy pawn within blocking distance of this spawn vehicle
    foreach Vehicle.RadiusActors(class'Pawn', P, SPAWN_VEHICLES_BLOCK_RADIUS)
    {
        if (P.Controller != none && Vehicle.GetTeamNum() != P.GetTeamNum())
        {
            return SPBR_EnemiesNearby;
        }
    }

    // Check whether a suitable vehicle position is available
    // The 'false' means we ignore positions that can only be used by tank crew - this is a global check, so we can only check positions that any player could use
    // Rarely going to be an issue, as a tank used as a spawn vehicle is rare, perhaps never, but the functionality does allow for it
    // But it does mean that if a tank is used as a spawn vehicle, it will only be shown as 'deployable' if there is a rider position free
    if (FindEntryVehicle(false) == none)
    {
        return SPBR_Full;
    }

    return SPBR_None;
}

// Implemented to regularly check & update whether this spawn vehicle can be deployed into
function Timer()
{
    if (Role == ROLE_Authority && Vehicle != none)
    {
        if (SpawnKillPenaltyCounter > 0)
        {
            SpawnKillPenaltyCounter -= 1;
        }

        BlockReason = GetSpawnPointBlockReason();
    }
}

// Modified to make sure we have a vehicle & it's on the same team
simulated function bool CanSpawnWithParameters(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex, optional bool bSkipTimeCheck)
{
    if (!super.CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex, bSkipTimeCheck))
    {
        return false;
    }

    if (Role == ROLE_Authority && (Vehicle == none || Vehicle.default.VehicleTeam != TeamIndex))
    {
        return false;
    }

    return true;
}

// Similar to FindEntryVehicle() function in a Vehicle class, it tries to find a suitable, valid vehicle position for player to enter
// Deliberately ignores driver position, to discourage players from deploying into a spawn vehicle (often carefully positioned by the team) & immediately driving off in it
// Prioritises passenger positions over real weapons (MGs or cannons), so player deploying into spawn vehicle is less likely to be exposed & will have a moment to orient themselves
private function Vehicle FindEntryVehicle(bool bCanEnterTankCrewPositions)
{
    local array<VehicleWeaponPawn> RealWeaponPawns;
    local VehicleWeaponPawn        WP;
    local int                      i;

    if (Vehicle == none)
    {
        return none;
    }

    // First loop through the weapon pawns to try to find an empty passenger position to enter
    // For now we ignore real weapon positions, like MGs & cannons, so we prioritise entering passenger slots
    for (i = 0; i < Vehicle.WeaponPawns.Length; ++i)
    {
        WP = Vehicle.WeaponPawns[i];

        if (WP != none)
        {
            // If weapon pawn isn't a passenger position, ignore it on this 1st pass, but record it to check later if we don't find a valid passenger slot
            if (!WP.IsA('DHPassengerPawn'))
            {
                RealWeaponPawns[RealWeaponPawns.Length] = WP;
            }
            // Enter a passenger position if it's empty
            else if (WP.Driver == none)
            {
                return WP;
            }
        }
    }

    // We didn't find an empty passenger slot, so now try to find an empty, valid real weapon position to enter (which we skipped on the 1st pass)
    for (i = 0; i < RealWeaponPawns.Length; ++i)
    {
        WP = RealWeaponPawns[i];

        // Enter weapon pawn position if it's empty & player isn't barred by tank crew restriction
        if (WP.Driver == none && (bCanEnterTankCrewPositions || !(WP.IsA('ROVehicleWeaponPawn') && ROVehicleWeaponPawn(WP).bMustBeTankCrew)))
        {
            return WP;
        }
    }

    return none; // there are no empty, usable vehicle positions
}

// Overridden to handle spawning the player into, or near to, our spawn vehicle
function bool PerformSpawn(DHPlayer PC)
{
    local RORoleInfo RoleInfo;
    local Vehicle    EntryVehiclePosition;
    local Pawn       P;
    local vector     Offset;
    local array<int> ExitPositionIndices;
    local int        RoleIndex, i;
    local bool       bCanEnterTankCrewPositions;

    if (PC == none || GRI == none || Vehicle == none)
    {
        return false;
    }

    // Spawn player pawn in black room & make sure it was successful
    if (PC.Pawn == none && DarkestHourGame(Level.Game) != none)
    {
        DarkestHourGame(Level.Game).DeployRestartPlayer(PC, false, true);
    }

    if (PC.Pawn == none)
    {
        return false;
    }

    RoleInfo = PC.GetRoleInfo();
    RoleIndex = GRI.GetRoleIndexAndTeam(RoleInfo);

    // Check if we can deploy into or near the vehicle
    if (CanSpawnWithParameters(GRI, PC.GetTeamNum(), RoleIndex, PC.GetSquadIndex(), PC.VehiclePoolIndex))
    {
        // Its engine is off & it will be stationary, so attempt to deploy next to vehicle, at a random exit position
        if (Vehicle.bEngineOff)
        {
            ExitPositionIndices = class'UArray'.static.Range(0, Vehicle.ExitPositions.Length - 1);
            class'UArray'.static.IShuffle(ExitPositionIndices); // randomise exit locations
            Offset.Z = PC.PawnClass.default.CollisionHeight * 0.5;

            for (i = 0; i < ExitPositionIndices.Length; ++i)
            {
                if (PC.TeleportPlayer(Vehicle.Location + (Vehicle.ExitPositions[ExitPositionIndices[i]] >> Vehicle.Rotation) + Offset, Vehicle.Rotation))
                {
                    OnPawnSpawned(PC.Pawn);
                    return true;
                }
            }
        }
        // Otherwise vehicle may be moving, so attempt to deploy into the vehicle
        else
        {
            bCanEnterTankCrewPositions = RoleInfo.bCanBeTankCrew && !Vehicle.AreCrewPositionsLockedForPlayer(PC.Pawn, true);
            EntryVehiclePosition = FindEntryVehicle(bCanEnterTankCrewPositions);

            if (EntryVehiclePosition != none && EntryVehiclePosition.TryToDrive(PC.Pawn))
            {
                OnPawnSpawned(PC.Pawn);
                return true;
            }
        }
    }

    // We failed to deploy, so invalidate spawn point & reset spawn vehicle index & next spawn time
    // Since next spawn time is set when player is reset above, without this the player would be forced to wait to spawn timer again
    PC.bSpawnParametersInvalidated = true;
    PC.SpawnPointIndex = -1;
    PC.NextSpawnTime = 0;

    // Kill the player pawn we spawned earlier
    P = PC.Pawn;
    PC.UnPossess();
    P.Suicide();

    // This makes sure the player doesn't watch and hear himself die
    // A dirty hack, but the alternative is much worse
    PC.ServerNextViewPoint();

    return false;
}

defaultproperties
{
    SpawnPointStyle="DHSpawnVehicleButtonStyle"
    bCombatSpawn=true
    bIsLowPriority=true
    bHasSpawnKillPenalty=true
    SpawnKillPenalty=30
}
