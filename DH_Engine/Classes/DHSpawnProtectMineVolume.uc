class DHSpawnProtectMineVolume extends DHMineVolume;

// A mine volume that activates with a new spawn to protect it, but giving enemies already inside an initial safe period to clear the area, with regular warnings
// After the initial safe period the MV goes 'live' for those original enemies & reverts to being a normal killing mine volume
// Alternatively, leveller can set initial duration to zero, meaning protection isn't time-limited for enemies already inside MV, so they have to be winkled out
// Any new enemies who enter the MV don't get any safe period, it's live for them immediately (same applies to a protected enemy who exits & re-enters)

var     bool    bInTimedSafePeriod;     // mine volume is in a time-limited, initial safe period & at least 1 protected enemy is still inside
var     bool    bSetInitialProtection;  // we need to set up the initial protection for enemy pawns already inside the mine volume when it activated
var     bool    bSafePeriodWarningDue;  // a periodic warning is due for all protected pawns during a timed safe period
var     float   NextSafePeriodWarnTime; // the time that the next periodic warning is due during a timed safe period
var     int     SafeSecondsRemaining;   // how many seconds until end of a timed safe period

// Mine volume properties that the leveller can set (default values are set but the leveller can choose to override):
var()   float               TimedSafePeriodDuration;   // duration in seconds of timed safe period, giving enemies time to get out (if set to zero, protection isn't time-limited)
var()   float               SafePeriodWarnInterval;    // interval in seconds between warning messages during timed safe period
var()   localized string    SafePeriodWarningMessage;  // warning message to display during timed safe period, telling enemies they must get away from the new spawn
var()   localized string    SpawnMFActivatedMessage;   // notification message to enemy already inside mine volume when it activates & there's no time limit on their protection
var()   localized string    ExitedMinefieldMessage;    // notification message to a protected enemy who exits the spawn protection mine volume & so loses protection
var()   localized string    UnprotectedVehicleWarning; // warning message telling player that although they are protected, the vehicle they are in is not & will soon be blown up

// Modified to round off the specified TimedSafePeriodDuration, as a whole number will work better with the 1 second repeating timer
function PostBeginPlay()
{
    super.PostBeginPlay();

    TimedSafePeriodDuration = Round(TimedSafePeriodDuration);
}

// Modified to set up the initial safe period for any enemies already inside the mine volume
function Activate()
{
    if (!bActive)
    {
        bInTimedSafePeriod = TimedSafePeriodDuration > 0.0; // true unless leveller has specified no time limit on protection
        NextSafePeriodWarnTime = Level.TimeSeconds;
        bSetInitialProtection = true;

        super.Activate();

        bSetInitialProtection = false; // must only be true on the 1st call to FindPawns
    }
}

// Modified to handle the initial safe period for any enemies already inside the mine volume
function bool FindPawnsInMineVolume()
{
    local bool bFoundRelevantPawn;

    if (bInTimedSafePeriod)
    {
        // Check if initial timed safe period is over
        if (Level.TimeSeconds >= ActivationTime + TimedSafePeriodDuration)
        {
            bInTimedSafePeriod = false;
        }
        // Otherwise, check if next periodic safe warning is due
        else if (Level.TimeSeconds >= NextSafePeriodWarnTime)
        {
            bSafePeriodWarningDue = true;
            SafeSecondsRemaining = int(Round(ActivationTime + TimedSafePeriodDuration - Level.TimeSeconds));
            NextSafePeriodWarnTime += SafePeriodWarnInterval;
        }
    }

    // Call the super to run normal functionality to find & handle all enemies in the mine volume
    bFoundRelevantPawn = super.FindPawnsInMineVolume();

    if (bInTimedSafePeriod && !bFoundRelevantPawn)
    {
        bInTimedSafePeriod = false; // exit timed safe period if no enemies are left inside
    }

    bSafePeriodWarningDue = false; // reset for next time

    return bFoundRelevantPawn;
}

// Modified to display a notification message to a protected player who exits the mine volume & so loses protection
// The Super zeroes the player's MineAreaEnterTime, which has more utility in this subclass as that removes player's initial protection
function PawnExitedMineVolume(Pawn P, optional bool bStillInsideAnotherMineVolume)
{
    if (!P.IsA('Vehicle') && ProtectionActiveForPawn(P)) // don't send warning to vehicle pawn, otherwise its driver will get the warning twice
    {
        WarnPlayer(P, -2); // -2 is special switch value to display unique message
    }

    super.PawnExitedMineVolume(P, bStillInsideAnotherMineVolume);
}

// Modified to handle a player protected by the initial safe period for enemies who were already inside the mine volume
function bool RelevantPawnInMineVolume(Pawn P)
{
    local Vehicle Vehicle;

    // If mine volume just activated then we need to set up some protection for this player
    if (bSetInitialProtection)
    {
        SetProtectionForPawn(P);

        // If safe period is not time-limited, we give the player a single notification that a spawn minefield has activated & suggest he falls back
        // We return false because there'd be no need to keep a PainTimer running just for this player, as there'll be no further action while he's in the MV
        if (!bInTimedSafePeriod)
        {
            WarnPlayer(P, -1); // -1 is special switch value for unique message

            return false;
        }

        WarnPlayer(P, SafeSecondsRemaining);

        return true;
    }

    // If pawn is protected by the initial safe period
    if (ProtectionActiveForPawn(P))
    {
        if (bSafePeriodWarningDue)
        {
            WarnPlayer(P, SafeSecondsRemaining);
        }

        // If pawn is protected but is in a vehicle that is not, we give the player a special warning that the vehicle is 'live' & will blow up
        Vehicle = P.DrivenVehicle;

        if (VehicleWeaponPawn(Vehicle) != none)
        {
            Vehicle = VehicleWeaponPawn(Vehicle).VehicleBase;
        }

        if (Vehicle != none && !ProtectionActiveForPawn(Vehicle) && WarningDueForPawn(P))
        {
            WarnPlayer(P, -3); // -3 is special switch value for unique message
        }

        return bInTimedSafePeriod; // return false if safe period is not time-limited, as would be no need to keep a PainTimer running just for this player
    }

    // Run normal functionality for a player without initial protection
    return super.RelevantPawnInMineVolume(P);
}

// Modified to set up initial protection for a vehicle protected by the initial safe period for enemies who were already inside the mine volume
function bool RelevantVehicleInMineVolume(ROVehicle Vehicle)
{
    if (bSetInitialProtection)
    {
        SetProtectionForPawn(Vehicle);
    }

    return super.RelevantVehicleInMineVolume(Vehicle);
}

// New function to set up initial protection for pawn, by setting MineAreaEnterTime to future time when MV's timed safe period ends
// Works even if leveller has specified no time limit on initial protection (duration = 0), as ProtectionActiveForPawn() function uses this value as a special flag
function SetProtectionForPawn(Pawn P)
{
    P.MineAreaEnterTime = ActivationTime + TimedSafePeriodDuration;
}

// New function to check if pawn is protected by the initial safe period, as was inside when mine volume activated & protected period has not run out
// Uses (ActivationTime + TimedSafePeriodDuration) as a special flag, set by SetProtectionForPawn() function
function bool ProtectionActiveForPawn(Pawn P)
{
    return (bInTimedSafePeriod || TimedSafePeriodDuration == 0.0) && P.MineAreaEnterTime == (ActivationTime + TimedSafePeriodDuration);
}

// Modified so pawn is safe if it has protection from this mine volume
function bool PawnInMineVolumeTooLong(Pawn P)
{
    return super.PawnInMineVolumeTooLong(P) && !ProtectionActiveForPawn(P);
}

defaultproperties
{
    bInitiallyActive=false
    TimedSafePeriodDuration=60.0
    SafePeriodWarnInterval=10.0
    KillTime=15.0
    WarningMessageClass=class'DH_Engine.DHSpawnProtectMineVolMessage'
    SafePeriodWarningMessage="This is now an enemy controlled area! You have %remaining% seconds to return to your lines!"
    SpawnMFActivatedMessage="This is now an enemy controlled area, fall back!"
    ExitedMinefieldMessage="You have left enemy territory. Returning again will be considered desertion!"
    UnprotectedVehicleWarning="This vehicle has been spotted by the enemy!"
    WarningMessage="You have entered an enemy controlled area, fall back!"
}
