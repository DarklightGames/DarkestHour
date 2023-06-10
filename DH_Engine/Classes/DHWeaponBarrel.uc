//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponBarrel extends Actor
    notplaceable;

var     float       LevelTempCentigrade; // the temperature of the level we're playing in (all temps here are in centigrade)
var     float       Temperature;         // current barrel temp
var     float       SteamTemperature;    // temp barrel begins to steam
var     float       CriticalTemperature; // temp barrel steams a lot and cone-fire error introduced
var     float       FailureTemperature;  // temp at which barrel fails and unusable
var     float       FiringHeatIncrement; // increase in barrel temp per shot fired
var     float       BarrelTimerRate;     // how often to call the timer to handle barrel cooling
var     float       BarrelCoolingRate;   // rate at which barrel cools off (degrees per second)
var     bool        bBarrelSteamActive;  // if barrel passes SteamTemperature, we'll start steaming the barrel
var     bool        bBarrelDamaged;      // if barrel passes CriticalTemperature, becomes true and cone-fire error introduced
var     bool        bBarrelFailed;       // if barrel passes FailureTemperature, becomes true and barrel unusable
var     bool        bIsCurrentBarrel;    // this is the weapon's current barrel, not a spare

// Modified to set the LevelTempCentigrade & match barrel's starting temperature to that, & to start a repeating timer to handle barrel cooling & updating
simulated function PostBeginPlay()
{
    local int TempFahrenheit;

    super.PostBeginPlay();

    if (Role == ROLE_Authority && DarkestHourGame(Level.Game).LevelInfo != none)
    {
        TempFahrenheit = DarkestHourGame(Level.Game).LevelInfo.TempFahrenheit;
        LevelTempCentigrade = float(TempFahrenheit - 32) * 5.0 / 9.0;
        Temperature = LevelTempCentigrade;

        SetTimer(BarrelTimerRate, true);
    }
}

// Modified to make sure any steam effects are deactivated
simulated function Destroyed()
{
    if (bBarrelSteamActive)
    {
        if (DHProjectileWeapon(Owner)!= none)
        {
            DHProjectileWeapon(Owner).SetBarrelSteamActive(false);
        }
        else if (DHWeaponPickup(Owner) != none)
        {
            DHWeaponPickup(Owner).SetBarrelSteamActive(false);
        }
    }

    super.Destroyed();
}

// Sets whether this barrel is the current one in the weapon & updates its status
function SetCurrentBarrel(bool bIsCurrent)
{
    bIsCurrentBarrel = bIsCurrent;

    if (bIsCurrentBarrel)
    {
        UpdateBarrelStatus();
    }
}

// Increases barrel temperature whenever the weapon fires
function WeaponFired()
{
    Temperature += FiringHeatIncrement;
    UpdateBarrelStatus();
}

// Periodically lowers the barrel temp, but no further than the level's ambient temp
function Timer()
{
    if (Role == ROLE_Authority && Temperature != LevelTempCentigrade)
    {
        Temperature = FMax(LevelTempCentigrade, Temperature -= (BarrelCoolingRate * BarrelTimerRate));
        UpdateBarrelStatus();
    }
}

// Updates this barrel and the weapon's status
function UpdateBarrelStatus()
{
    local DHProjectileWeapon W;
    local DHWeaponPickup     PU;

    if (Role == ROLE_Authority)
    {
        bBarrelSteamActive = Temperature > SteamTemperature;
        bBarrelDamaged = Temperature > CriticalTemperature;

        if (!bBarrelFailed && Temperature > FailureTemperature) // no coming back from barrel failure
        {
            bBarrelFailed = true;
        }

        if (bIsCurrentBarrel)
        {
            W = DHProjectileWeapon(Owner);

            if (W != none)
            {
                if (W.bBarrelSteamActive != bBarrelSteamActive)
                {
                    W.SetBarrelSteamActive(bBarrelSteamActive);
                }

                if (W.bBarrelDamaged != bBarrelDamaged)
                {
                    W.SetBarrelDamaged(bBarrelDamaged);
                }

                if (W.bBarrelFailed != bBarrelFailed)
                {
                    W.SetBarrelFailed(bBarrelFailed);
                }

                if (W.BarrelTemperature != Temperature)
                {
                    W.SetBarrelTemperature(Temperature);
                }
            }
            else
            {
                PU = DHWeaponPickup(Owner);

                if (PU != none && PU.bBarrelSteamActive != bBarrelSteamActive)
                {
                    PU.SetBarrelSteamActive(bBarrelSteamActive);
                }
            }
        }
    }
}

defaultproperties
{
    SteamTemperature=180.0
    CriticalTemperature=230.0
    FailureTemperature=315.0
    BarrelCoolingRate=1.75
    FiringHeatIncrement=1.3
    BarrelTimerRate=3.0
    DrawType=DT_None
    bHidden=true
    bReplicateMovement=false
    RemoteRole=ROLE_None
    NetPriority=1.4
}
