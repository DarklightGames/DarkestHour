//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================
// This is a spawn point that gets attached to "spawn vehicles" like the
// halftracks.
//==============================================================================

class DHSpawnPoint_Vehicle extends DHSpawnPointBase
    notplaceable;

const SPAWN_VEHICLES_BLOCK_RADIUS = 2048.0;

var     DHVehicle   Vehicle;

// Modified to start a repeating timer to keep checking whether this spawn vehicle can be deployed into
function PostBeginPlay()
{
    super.PostBeginPlay();

    SetTimer(1.0, true);
}

// Implemented to regularly check & update whether this spawn vehicle can be deployed into
function Timer()
{
    local Pawn        P;
    local DHObjective O;
    local int         i;

    if (Role == ROLE_Authority)
    {
        BlockReason = SPBR_None;

        // Check whether there is an enemy pawn within blocking distance of this spawn vehicle
        foreach Vehicle.RadiusActors(class'Pawn', P, SPAWN_VEHICLES_BLOCK_RADIUS)
        {
            if (P != none && P.Controller != none)
            {
                if (Vehicle.GetTeamNum() != P.GetTeamNum())
                {
                    BlockReason = SPBR_EnemiesNearby;

                    break;
                }
            }
        }

        // Check whether this spawn vehicle is inside an active objective
        for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
        {
            O = GRI.DHObjectives[i];

            if (O != none && O.bActive && O.WithinArea(Vehicle))
            {
                BlockReason = SPBR_InObjective;

                break;
            }
        }

        // Check if a suitable vehicle position is available for non-crew to enter
        if (FindEntryVehicle(false) == none)
        {
            BlockReason = SPBR_Full;
        }
    }
}

// Modified to make sure we have a vehicle & it's on the same team
simulated function bool CanSpawnWithParameters(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex, optional bool bSkipTimeCheck)
{
    if (!super.CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex, bSkipTimeCheck))
    {
        return false;
    }

    if (Role == ROLE_Authority)
    {
        if (Vehicle == none || Vehicle.default.VehicleTeam != TeamIndex)
        {
            return false;
        }
    }

    return true;
}

// Similar to FindEntryVehicle() function in a Vehicle class, it tries to find a suitable, valid vehicle position for player to enter
// We need to do this, otherwise if we TryToDrive() a vehicle that already has a driver, we'll fail to enter it at all, so here we try to find an empty, valid weapon pawn
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
            // If weapon pawn isn't a passenger position, skip it on this 1st pass, but record it to check later if we don't find a valid passenger slot
            if (!WP.IsA('DHPassengerPawn'))
            {
                RealWeaponPawns[RealWeaponPawns.Length] = WP;
                continue;
            }

            // Enter weapon pawn position if it's empty & player isn't barred by tank crew restriction
            if (WP.Driver == none && (bCanBeTankCrew || !WP.IsA('ROVehicleWeaponPawn') || !ROVehicleWeaponPawn(WP).bMustBeTankCrew))
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

// Implemented to handle spawning the player into, or near to, our spawn vehicle
function bool PerformSpawn(DHPlayer PC)
{
    local Pawn       P;
    local Vehicle    EntryVehicle;
    local vector     Offset;
    local array<int> ExitPositionIndices;
    local int        i, RoleIndex;
    local DarkestHourGame G;
    local byte Team;
    local bool       bCanEnterTankCrewPositions;

    G = DarkestHourGame(Level.Game);

    if (PC == none || GRI == none || Vehicle == none || G == none)
    {
        return false;
    }

    // Spawn player pawn in black room & make sure it was successful
    if (PC.Pawn == none)
    {
        G.DeployRestartPlayer(PC, false, true);
    }

    if (PC.Pawn == none)
    {
        return false;
    }

    Offset = PC.PawnClass.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    RoleIndex = GRI.GetRoleIndexAndTeam(PC.GetRoleInfo(), Team);

    // Check if we can deploy into or near the vehicle
    if (CanSpawnWithParameters(GRI, PC.GetTeamNum(), RoleIndex, PC.GetSquadIndex(), PC.VehiclePoolIndex))
    {
        // Randomise exit locations
        ExitPositionIndices = class'UArray'.static.Range(0, Vehicle.ExitPositions.Length - 1);
        class'UArray'.static.IShuffle(ExitPositionIndices);

        // Its engine is off & it will be stationary, so attempt to deploy next to vehicle, at a random exit position
        if (Vehicle.bEngineOff)
        {
            for (i = 0; i < ExitPositionIndices.Length; ++i)
            {
                if (PC.TeleportPlayer(Vehicle.Location + (Vehicle.ExitPositions[ExitPositionIndices[i]] >> Vehicle.Rotation) + Offset, Vehicle.Rotation))
                {
                    return true;
                }
            }
        }
        // Otherwise vehicle may be moving, so attempt to deploy into the vehicle
        else
        {
            // Attempt to deploy into the vehicle
            bCanEnterTankCrewPositions = PC.GetRoleInfo().bCanBeTankCrew && !Vehicle.AreCrewPositionsLockedForPlayer(PC.Pawn, true);
            EntryVehicle = FindEntryVehicle(bCanEnterTankCrewPositions);

            if (EntryVehicle != none && EntryVehicle.TryToDrive(PC.Pawn))
            {
                return true;
            }
        }
    }

    // We failed to deploy, so invalidate spawn point & reset spawn vehicle index & next spawn time
    // Since next spawn time is set when player is reset above, without this the player would be forced to wait to spawn timer again
    PC.bSpawnPointInvalidated = true;
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

simulated function string GetMapStyleName()
{
    return "DHSpawnVehicleButtonStyle";
}

defaultproperties
{
    bCombatSpawn=true
}
