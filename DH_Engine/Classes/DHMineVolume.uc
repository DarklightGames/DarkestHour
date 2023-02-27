//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMineVolume extends ROMineVolume;

// Theel: Actors that are bStatic=true are not iterated with events and thus cannot be triggered, this is why the genius you are, added level actors to change them
// Just use level actors to modify volumes!!!!!!!!!!!!!!!!!!!!!!!
// YOU LOSE GOOD DAY SIR

/**
Matt's explanation of several nasty bugs in ROMineVolume, especially when mine volume is activated during the round, e.g. by a spawn:

1.  Enemy players & vehicles already inside a MV when it activates are ignored because they don't trigger a Touch event, as they never crossed the MV's border.
    Without a Touch, those enemy pawns don't record a MineAreaEnterTime, which instead will remain either zero or some time way back (from entering an earlier MV).
    At MV activation, no PainTimer is spawned to keep checking who is inside the MV. A PT only spawns if any new enemy enters the MV.
    The 1st thing that a new PT does is cause the immediate death of every enemy who was already inside the MV !
    That happens because PT checks their MineAreaEnterTime, which was never set by this MV, so it thinks the pawn has been inside the MV for a very long time !

    Solution: when MV is activated, check for enemies already inside & if any are present then record a MineAreaEnterTime for them & set a PainTimer.

2.  Players who enter MV in a vehicle, or are in one when MV activates, don't trigger a Touch event for their player pawn, as they're controlling a Vehicle or VehicleWeaponPawn.
    Without a Touch, those pawns don't record a MineAreaEnterTime, which instead will remain either zero or some time way back (from entering an earlier MV).
    This means anyone exiting a vehicle into a MV gets instantly killed, even if they've only been there a short time.
    That happens because PT checks their MineAreaEnterTime, which was never set by this MV, so it thinks the pawn has been inside the MV for a very long time !

    Solution: when a vehicle enters the MV or we find a vehicle in the MV, loop through all occupants & record MineAreaEnterTime for all player pawns.

3.  A much less serious problem is that players who enter a vehicle or switch positions in a vehicle do receive a Touch because their player pawn is temporarily made
    collidable during the enter/switching process. This means they get a new MineAreaEnterTime recorded each time. A player will still die 'on time' if they stay in
    the vehicle, but if they exit before the vehicle blows up the re-set of their enter time prolongs their survival time in the MV.

    Solution: check pawn's DrivenVehicle is none before accepting it as valid Touch & recording MineAreaEnterTime (pawn will have a DrivenVehicle if just entered or switched)

4.  Another much less serious problem is that vehicle occupants other than the driver do not receive any MV warnings.
    The vehicle itself does trigger Touch if it enters the MV, so the driver only will get warnings because he is controlling the vehicle pawn.
    But VehicleWeaponPawns don't have collision & so don't trigger Touch, meaning their controllers get nothing.

    Solution: when a vehicle enters the MV or we find a vehicle in the MV, loop through all occupants & give a warning to any players.
*/

var()   bool                    bInitiallyActive;    // leveler can set MV to be inactive at start of round, so it can be activated later by an event
var()   bool                    bIsAlsoNoArtyVolume; // leveler can set this volume to also function like a no arty volume, stopping artillery/mortars rounds from being effective
var     float                   ActivationTime;      // time this MV was activated - used in workaround fix to bug if player teleports into MV, & also useful in subclasses
var     class<ROMineFieldMsg>   WarningMessageClass; // local message class to use for warning messages, so can be replaced by custom messages in a subclass

var int                             Index;           // Where our activation state is stored in DHGRI.DHMineVolumeIsActives
var private DHGameReplicationInfo   GRI;

// Modified to skip over the Super in ROMineVolume as it was always activating the mine volume & instead we need to use our bInitiallyActive setting
// We don't need to do anything here as we can leave it to Reset(), which gets called whenever a new round starts, otherwise we just duplicate the same functionality here
function PostBeginPlay()
{
    if (Role == ROLE_Authority)
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
    }

    super(Volume).PostBeginPlay();
}

// Modified to activate or deactivate the mine volume based on the leveller's setting of bInitiallyActive
// Called whenever a new round starts, including the ResetGame option
function Reset()
{
    if (bInitiallyActive)
    {
        bActive = false; // so that Activate() will 'reactivate' the MV if reset when it is already active
        Activate();
    }
    else
    {
        Deactivate();
    }
}

// Modified to set up the mine volume, including finding any relevant pawns already inside the MV (doing that here fixes a major bug from ROMineVolume)
function Activate()
{
    if (!bActive)
    {
        bActive = true;

        GRI.DHMineVolumeIsActives[Index] = 1;

        ActivationTime = Level.TimeSeconds;
        Enable('Touch');
        Enable('UnTouch');

        if (PainTimer != none) // in case active MV gets reactivated (e.g. by ResetGame), let's destroy any PainTimer & re-spawn it so timing is re-set
        {
            PainTimer.Destroy();
        }

        if (FindPawnsInMineVolume())
        {
            PainTimer = Spawn(class'DHAccurateVolumeTimer', self);
        }
    }
}

// Modified to disable Touch & UnTouch events to save unnecessary processing, & to destroy any PainTimer
function Deactivate()
{
    if (bActive)
    {
        bActive = false;

        GRI.DHMineVolumeIsActives[Index] = 0;

        Disable('Touch');
        Disable('UnTouch');

        if (PainTimer != none)
        {
            PainTimer.Destroy();
        }
    }
}

// Modified to use new FindPawnsInMineVolume() function to find & handle any relevant pawns inside the mine volume
function TimerPop(VolumeTimer T)
{
    if (!bActive || T != PainTimer || !FindPawnsInMineVolume())
    {
        T.Destroy();
    }
}

// New function to find & handle any relevant pawns inside the mine volume
// Crucially it is now called when the MV is activated, as well as from each TimerPop() called periodically by the PainTimer
function bool FindPawnsInMineVolume()
{
    local Pawn P;
    local bool bFoundRelevantPawn;

    foreach TouchingActors(class'Pawn', P)
    {
        if (IsARelevantPawn(P))
        {
            if (P.IsA('ROVehicle'))
            {
                if (RelevantVehicleInMineVolume(ROVehicle(P)))
                {
                    bFoundRelevantPawn = true;
                }
            }
            else if (RelevantPawnInMineVolume(P))
            {
                bFoundRelevantPawn = true;
            }
        }
    }

    return bFoundRelevantPawn; // return true if we found at least 1 relevant pawn, meaning the PainTimer will be spawned/continued to keep checking for enemies
}

// Modified to call generic ProcessTouch() event, which handles any player entering or exiting the mine volume
// This native event is called whenever any actor enters the MV (including being spawned within it)
event Touch(Actor Other)
{
    ProcessTouch(Other);
}

// Modified to call generic ProcessTouch() event, which handles any player entering or exiting the mine volume
// This native event is called whenever any actor exits the MV
event UnTouch(Actor Other)
{
    ProcessTouch(Other, true); // true signifies Other has UnTouched this mine volume, not Touched it
}

// New function for generic processing of either Touch() or UnTouch() events, to handle a pawn entering or exiting the mine volume
// For all relevant players entering/exiting the MV, including all occupants of a vehicle, it calls either PawnEnteredMineVolume() or PawnExitedMineVolume()
function ProcessTouch(Actor Other, optional bool bUnTouch)
{
    local Pawn         P;
    local ROVehicle    Vehicle;
    local ROMineVolume MV;
    local bool         bStillInsideAnotherMineVolume;
    local int          i;

    P = Pawn(Other);

    if (P == none || !bActive || Role < ROLE_Authority)
    {
        return;
    }

    // Exiting/entering a vehicle or switching vehicle positions causes player pawn to receive Touch/UnTouch & we can't allow that to count as entering/leaving the MV
    // As a workaround fix we can check if pawn has a DrivenVehicle - if so it must mean player has just exited/entered vehicle or switched positions, so we do nothing
    if (P.DrivenVehicle != none)
    {
        return;
    }

    // Mine volume has been entered/exited by a player or vehicle on a team that this mine volume is set up to kill
    if (IsARelevantPawn(P))
    {
        if (bUnTouch)
        {
            // If pawn has exited this MV, check it isn't still inside another active MV - if it is, we do nothing more (e.g. don't zero pawn's MineAreaEnterTime)
            // This can happen where MVs overlap, especially boundary MVs around map edges
            foreach TouchingActors(class'ROMineVolume', MV)
            {
                if (MV != self && MV.bActive)
                {
                    bStillInsideAnotherMineVolume = true;
                }
            }

            PawnExitedMineVolume(P, bStillInsideAnotherMineVolume);
        }
        else
        {
            PawnEnteredMineVolume(P);
        }

        Vehicle = ROVehicle(P);

        // If pawn is a vehicle, loop through all vehicle positions & handle any occupants
        if (Vehicle != none)
        {
            P = Vehicle.Driver;

            do
            {
                if (P != none)
                {
                    if (bUnTouch)
                    {
                        PawnExitedMineVolume(P, bStillInsideAnotherMineVolume);
                    }
                    else
                    {
                        PawnEnteredMineVolume(P);
                    }
                }

                if (i < Vehicle.WeaponPawns.Length && Vehicle.WeaponPawns[i] != none)
                {
                    P = Vehicle.WeaponPawns[i].Driver; // set up the next occupant for the next iteration
                }

                i++;
            }
            until (i > Vehicle.WeaponPawns.Length)
        }

        // If player entered MV, make sure we have a PainTimer running
        if (PainTimer == none && !bUnTouch)
        {
            PainTimer = Spawn(class'DHAccurateVolumeTimer', self);
        }
    }
}

// New function called when pawn enters mine volume, where we record pawn's enter time & give player an initial warning
function PawnEnteredMineVolume(Pawn P)
{
    if (!P.IsA('Vehicle')) // don't send warning to vehicle pawn, otherwise its driver will get the warning twice
    {
        WarnPlayer(P);
    }

    P.MineAreaEnterTime = Level.TimeSeconds;
}

// New function called when pawn exits mine volume, where we zero the pawn's recorded enter time
// This ensures pawns never enter a MV with a misleading enter time from another MV
// Also useful so we can detect a pawn that has teleported inside MV, as its enter time will be zero & so before MV's ActivationTimefunction
// May be flagged that the pawn is still inside another, overlapping active MV, which can happen especially on overlapping map boundary MVs
// In which case we don't zero pawn's enter time (may then seem pointless even calling this function, but it can be subclassed for additional exiting functionality)
function PawnExitedMineVolume(Pawn P, optional bool bStillInsideAnotherMineVolume)
{
    if (!bStillInsideAnotherMineVolume)
    {
        P.MineAreaEnterTime = 0.0;
    }
}

// New function to Handle a player that has been found inside mine volume (may include warning, recording enter time or destruction)
// Returns true to confirm this player counts as a relevant pawn unless we kill him, in which case pawn will no longer exist & we ignore it
function bool RelevantPawnInMineVolume(Pawn P)
{
    if (WarningDueForPawn(P))
    {
        WarnPlayer(P);
    }

    // Workaround fix to a problem where player teleports into a spawn vehicle, which means they don't get a Touch & so don't get a valid enter time recorded
    // If pawn's enter time is before this MV's ActivationTime then it cannot be valid, meaning pawn must have just teleported inside MV, so we record current time
    // Note we now zero the enter time whenever a pawn exits a MV, so // Useful so we can detect a pawn that has teleported inside MV, as its enter time will be zero & so before the ActivationTime
    if (P.MineAreaEnterTime < ActivationTime)
    {
        P.MineAreaEnterTime = Level.TimeSeconds;

        return true;
    }

    // Check whether the pawn has been in the MV too long & needs to be killed
    if (PawnInMineVolumeTooLong(P))
    {
        KillPawn(P);

        return false;
    }

    return true;
}

// New function to Handle a vehicle that has been found inside mine volume, including any occupants (may include warning, recording enter time or destruction)
// Returns true to confirm vehicle counts as a relevant pawn unless we destroy it, in which case pawn will no longer exist & we ignore it
function bool RelevantVehicleInMineVolume(ROVehicle Vehicle)
{
    local bool bVehicleBeingDestroyed;
    local Pawn Occupant;
    local int  i;

    bVehicleBeingDestroyed = PawnInMineVolumeTooLong(Vehicle); // if vehicle is going to get blown up then for now just set a flag so we can handle warnings

    // Loop through all vehicle positions & handle any occupants
    Occupant = Vehicle.Driver;

    do
    {
        if (Occupant != none)
        {
            if (bVehicleBeingDestroyed) // if vehicle is going to be destroyed then just give live minefield warning so they know what happened
            {
                WarnPlayer(Occupant);
            }
            else
            {
                RelevantPawnInMineVolume(Occupant);
            }
        }

        if (i < Vehicle.WeaponPawns.Length && Vehicle.WeaponPawns[i] != none)
        {
            Occupant = Vehicle.WeaponPawns[i].Driver; // set up the next occupant for the next iteration
        }

        i++;
    }
    until (i > Vehicle.WeaponPawns.Length)

    // If vehicle's time is up, blow it up now that we've warned the occupants
    if (bVehicleBeingDestroyed)
    {
        KillPawn(Vehicle);

        return false;
    }

    return true;
}

// New function to show a player the specified minefield warning message
function WarnPlayer(Pawn P, optional int Switch)
{
    if (P != none)
    {
        P.MineAreaWarnTime = Level.TimeSeconds;

        // For vehicle occupants other than the driver, we send the message to their VehicleWeaponPawn ('DrivenVehicle'), as they aren't controlling their player pawn
        if (P.Controller == none && P.DrivenVehicle != none)
        {
            P = P.DrivenVehicle;
        }

        P.ReceiveLocalizedMessage(WarningMessageClass, Switch,,, self);
    }
}

// New function to kill a pawn as it has been inside the mine volume too long
function KillPawn(Pawn P)
{
    if (ExplosionSound != none)
    {
        PlaySound(ExplosionSound,, 2.5 * TransientSoundVolume);
    }

    P.TakeDamage(Damage, none, Location, vect(0.0, 0.0, 0.0), DamageType);
    Spawn(class'GrenadeExplosion',,, P.Location - (P.CollisionHeight * vect(0.0, 0.0, 1.0)));
}

// New function to check if the pawn is a player or vehicle on a team that this mine volume is set up to kill
function bool IsARelevantPawn(Pawn P)
{
    local int PawnTeam;

    if (P == none || P.bDeleteMe || P.Health <= 0)
    {
        return false;
    }

    if (MineKillStyle == KS_ALL)
    {
        return true;
    }

    // If pawn is a vehicle we want its Team number, not its VehicleTeam - because Team is updated if the vehicle has been stolen, while VehicleTeam remains constant
    // That means we can't use GetTeamNum() as that returns the VehicleTeam, which would mean captured enemy cars or trucks would blow up even if driven by friendlies !
    // But have to check vehicle has been entered, otherwise its Team has never been set & will be default zero
    if (ROVehicle(P) != none && ROVehicle(P).bDriverAlreadyEntered)
    {
        PawnTeam = ROVehicle(P).Team;
    }
    // But for vehicles that haven't been entered (& so can't have been captured), GetTeamNum returns the default VehicleTeam, which is fine.
    // GetTeamNum also works for non-vehicle pawns as it tries a range of options to get the PRI & returns PRI.Team.TeamIndex
    else
    {
        PawnTeam = P.GetTeamNum();
    }

    return (PawnTeam == AXIS_TEAM_INDEX && MineKillStyle == KS_Axis) || (PawnTeam == ALLIES_TEAM_INDEX && MineKillStyle == KS_Allies);
}

// New function to check if pawn has been inside the mine volume too long & is going to get blown up (added for readability in other functions)
function bool PawnInMineVolumeTooLong(Pawn P)
{
    return (Level.TimeSeconds - P.MineAreaEnterTime) >= KillTime;
}

// New function to check whether a warning message is due (added for readability in other functions)
function bool WarningDueForPawn(Pawn P)
{
    return (Level.TimeSeconds - P.MineAreaWarnTime) >= WarnInterval;
}

defaultproperties
{
    bInitiallyActive=true // normal minefield will always be active, but leveller can override this option to start deactivated & be activated by a future event
    WarningMessageClass=class'ROEngine.ROMineFieldMsg' // the standard RO 'live' minefield warning
    RemoteRole=ROLE_DumbProxy
}
