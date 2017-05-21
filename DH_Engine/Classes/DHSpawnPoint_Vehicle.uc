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

var DHVehicle Vehicle;

function PostBeginPlay()
{
    super.PostBeginPlay();

    SetTimer(1.0, true);
}

function Timer()
{
    local Pawn        P;
    local DHObjective O;
    local int         j;

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
        for (j = 0; j < arraycount(GRI.DHObjectives); ++j)
        {
            O = GRI.DHObjectives[j];

            if (O != none && O.bActive && O.WithinArea(Vehicle))
            {
                BlockReason = SPBR_InObjective;

                break;
            }
        }

        // Check if a suitable entry vehicle is available for non-crew
        if (FindEntryVehicle(false) == none)
        {
            BlockReason = SPBR_Full;
        }
    }
}

simulated function bool CanSpawnWithParameters(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex)
{
    if (!super.CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex))
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

// Similar to FindEntryVehicle() function in a Vehicle class, it checks for a suitable vehicle position to enter, before we call TryToDrive() on the vehicle
// We need to do this, otherwise if we TryToDrive() a vehicle that already has a driver, we fail to enter that vehicle, so here we try to find an empty, valid weapon pawn to enter
// Deliberately ignores driver position, to discourage players from deploying into a spawn vehicle, which may be carefully positioned by the team, & immediately driving off in it
// Prioritises passenger positions over real weapon positions (MGs or cannons), so players deploying into spawn vehicle are less likely to be exposed & have a moment to orient themselves
private function Vehicle FindEntryVehicle(bool bCanBeTankCrew)
{
    local VehicleWeaponPawn        WP;
    local array<VehicleWeaponPawn> RealWeaponPawns;
    local int  i;

    if (Vehicle == none)
    {
        return none;
    }

    // Loop through the weapon pawns to check if we can enter one (but skip real weapon positions, like MGs & cannons, on this 1st pass, so we prioritise passenger slots)
    for (i = 0; i < Vehicle.WeaponPawns.Length; ++i)
    {
        WP = Vehicle.WeaponPawns[i];

        if (WP != none)
        {
            // If weapon pawn is not a passenger slot (i.e. it's an MG or cannon), skip it on this 1st pass, but record it to check later if we don't find a valid passenger slot
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

    // We didn't find a valid passenger slot, so now try any real weapon positions that we skipped on the 1st pass
    for (i = 0; i < RealWeaponPawns.Length; ++i)
    {
        WP = RealWeaponPawns[i];

        // Enter weapon pawn position if it's empty & player isn't barred by tank crew restriction
        if (WP.Driver == none && (bCanBeTankCrew || !WP.IsA('ROVehicleWeaponPawn') || !ROVehicleWeaponPawn(WP).bMustBeTankCrew))
        {
            return WP;
        }
    }

    return none; // there are no empty, usable vehicle positions
}

function bool PerformSpawn(DHPlayer PC)
{
    local Pawn       P;
    local Vehicle    EntryVehicle;
    local vector     Offset;
    local array<int> ExitPositionIndices;
    local int        i, RoleIndex;
    local DarkestHourGame G;
    local byte Team;

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

        // Spawn vehicle is the type that requires its engine to be off to allow players to deploy to it, so it will be stationary
        if (Vehicle.bEngineOff)
        {
            // Attempt to deploy at an exit position
            for (i = 0; i < ExitPositionIndices.Length; ++i)
            {
                if (PC.TeleportPlayer(Vehicle.Location + (Vehicle.ExitPositions[ExitPositionIndices[i]] >> Vehicle.Rotation) + Offset, Vehicle.Rotation))
                {
                    return true;
                }
            }
        }
        else
        {
            // Attempt to deploy into the vehicle
            EntryVehicle = FindEntryVehicle(PC.GetRoleInfo().bCanBeTankCrew);

            if (EntryVehicle != none && EntryVehicle.TryToDrive(PC.Pawn))
            {
                return true;
            }
        }
    }

    // Invalidate spawn point, reset spawn vehicle index, and zero out next
    // spawn time. Since next spawn time is set when player is reset above,
    // without this, the player would be forced to wait to spawn timer again.
    PC.bSpawnPointInvalidated = true;
    PC.SpawnPointIndex = -1;
    PC.NextSpawnTime = 0;

    // Attempting to deploy into or near the vehicle failed, so kill the player pawn we spawned earlier
    P = PC.Pawn;
    PC.UnPossess();
    P.Suicide();

    // This makes sure the player doesn't watch and hear himself die. A
    // dirty hack, but the alternative is much worse.
    PC.ServerNextViewPoint();

    return false;
}

simulated function string GetMapStyleName()
{
    if (IsBlocked())
    {
        return "DHSpawnVehicleBlockedButtonStyle";
    }
    else
    {
        return "DHSpawnVehicleButtonStyle";
    }
}

defaultproperties
{
    bCombatSpawn=true
}

