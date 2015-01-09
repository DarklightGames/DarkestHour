//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MGBarrel extends Actor;

var     float       Temperature;           // current barrel temp
var     float       DH_MGSteamTemp,              // temp barrel begins to steam
                    CriticalTemperature,          // temp barrel steams alot and conefire error introduced
                    FailureTemperature,              // temp at which barrel fails and unusable
                    BarrelCoolingRate,          // rate/second the barrel cools at
                    FiringHeatIncrement;        // deg C/shot the barrel heat is increased
var     bool        bBarrelFailed,              // if barrel passes ROMGFailTemp, becomes true and barrel unusable
                    bBarrelSteaming,            // if barrel passes ROMGSteamTemp, we'll start steaming the barrel
                    bBarrelDamaged;             // if barrel passes ROMGCriticalTemp, becomes true and conefire error introduced
var     int         LevelCTemp;                 //  The temperature of the level we're playing in
var     float       BarrelTimerRate;            // How fast to call the timer for this barrel. We don't really need to cool the Barrel every tick

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority && DarkestHourGame(Level.Game).LevelInfo != none)
    {
        LevelCTemp = FtoCelsiusConversion(DarkestHourGame(Level.Game).LevelInfo.TempFahrenheit);

        Temperature = LevelCTemp;
    }
}

simulated function Destroyed()
{
    // if the barrel is destroyed and is steaming, de-activate the steam effect
    if (bBarrelSteaming)
    {
        DH_ProjectileWeapon(Owner).ToggleBarrelSteam(false);
    }

    if (bBarrelDamaged)
    {
        DH_ProjectileWeapon(Owner).bBarrelDamaged = false;
    }

    super.Destroyed();
}

//------------------------------------------------------------------------------
// FtoCelciusConversion(RO) - This is executed on the authority, used to set the
//  MG C temp using the map ambient Fahrenheit temp
//------------------------------------------------------------------------------
function float FtoCelsiusConversion(INT Fahrenheit)
{
    local float NewCTemp;

    Fahrenheit -= 32;
    NewCTemp = Fahrenheit * 5.0;
    NewCTemp = NewCTemp / 9.0;

    return NewCTemp;
}

//------------------------------------------------------------------------------
// WeaponFired(RO) - This is a server-side function that will handle
//  barrel heating whenver the mg fires
//------------------------------------------------------------------------------
function WeaponFired()
{
    // Increment the barrel temp by 1 deg C for firing
    Temperature += FiringHeatIncrement;

    // Only CheckBarrelSteaming if the barrel isn't steaming yet
    if (!bBarrelSteaming && (Temperature > DH_MGSteamTemp))
    {
        bBarrelSteaming = true;

        DH_ProjectileWeapon(Owner).ToggleBarrelSteam(bBarrelSteaming);
    }

    if (Temperature > FailureTemperature)
    {
        bBarrelFailed = true;
    }

    UpdateBarrelStatus();
}

// Will update this barrel and the weapons's barrel status
function UpdateBarrelStatus()
{
    local DH_ProjectileWeapon W;

    W = DH_ProjectileWeapon(Owner);

    if (W == none)
    {
        return;
    }

    if (bBarrelFailed)
    {
        W.bBarrelFailed = true;
    }

    if (!bBarrelSteaming && (Temperature > DH_MGSteamTemp))
    {
        bBarrelSteaming = true;

        W.ToggleBarrelSteam(bBarrelSteaming);
    }

    if (!bBarrelDamaged && (Temperature > CriticalTemperature))
    {
        bBarrelDamaged = true;
        W.bBarrelDamaged = true;
    }
}

// Will update this barrel status when it's not currently in use without affecting the weapon
function UpdateSpareBarrelStatus()
{
    if (!bBarrelSteaming && (Temperature > DH_MGSteamTemp))
    {
        bBarrelSteaming = true;
    }

    if (!bBarrelDamaged && (Temperature > CriticalTemperature))
    {
        bBarrelDamaged = true;
    }
}

state BarrelInUse
{
    function BeginState()
    {
        // if the barrel is being put on and is steaming, turn on the steam emitter
        if (bBarrelSteaming)
        {
            DH_ProjectileWeapon(Owner).ToggleBarrelSteam(true);
        }

        // if the barrel is being put on and is damaged, set the weapon to have a damaged barrel
        if (bBarrelDamaged)
        {
            DH_ProjectileWeapon(Owner).bBarrelDamaged = true;
        }

        SetTimer(BarrelTimerRate, true);
    }

    //------------------------------------------------------------------------------
    // Timer - This is a server-side function that will handle barrel heat
    // related operations such as barrel steaming and cone fire activation calls
    //------------------------------------------------------------------------------
    function Timer()
    {
        local DH_ProjectileWeapon W;

        // make sure this is done on the authority
        // if temp is at the level temp, don't bother with anything else
        if (Role < ROLE_Authority || Temperature == LevelCTemp)
        {
            return;
        }

        W = DH_ProjectileWeapon(Owner);

        if (W == none)
        {
            return;
        }

        // lower the barrel temp or set to Level ambient temp if it goes below
        if (Temperature > LevelCTemp)
        {
            Temperature -= (BarrelTimerRate * BarrelCoolingRate);
        }
        else if (Temperature < LevelCTemp)
        {
            Temperature = LevelCTemp;
        }

        if (bBarrelSteaming && (Temperature < DH_MGSteamTemp))
        {
            bBarrelSteaming = false;

            W.ToggleBarrelSteam(bBarrelSteaming);
        }

        // Questionable, once the barrel is damaged, does it ever really get better again?
        if (bBarrelDamaged && (Temperature < CriticalTemperature))
        {
            bBarrelDamaged = false;

            W.bBarrelDamaged = false;
        }
    }
}

//------------------------------------------------------------------------------
// Allows Barrel heat to continue to be tracked, but without the steam or cone
// fire toggling calls to the MG
//------------------------------------------------------------------------------
state BarrelOff
{
    function BeginState()
    {
        // if the barrel is being removed and is steaming, shut off the steam
        // emitter
        if (bBarrelSteaming)
        {
            DH_ProjectileWeapon(Owner).ToggleBarrelSteam(false);
        }

        SetTimer(BarrelTimerRate, true);
    }

    function Timer()
    {
        // make sure this is done on the authority
        if (Role < ROLE_Authority || Temperature == LevelCTemp)
        {
            return;
        }

        // lower the barrel temp or set to Level ambient temp if it goes below
        if (Temperature > LevelCTemp)
        {
            Temperature -= (BarrelTimerRate * BarrelCoolingRate);
        }

        else if (Temperature < LevelCTemp)
        {
            Temperature = LevelCTemp;
        }

        if (bBarrelSteaming && (Temperature < DH_MGSteamTemp))
        {
            bBarrelSteaming = false;
        }

        if (bBarrelDamaged && (Temperature < CriticalTemperature))
        {
            bBarrelDamaged = false;
        }
    }
}

defaultproperties
{
    DH_MGSteamTemp=225.000000
    CriticalTemperature=250.000000
    FailureTemperature=275.000000
    BarrelCoolingRate=1.000000
    FiringHeatIncrement=1.000000
    BarrelTimerRate=0.100000
    DrawType=DT_none
    bHidden=true
    bReplicateMovement=false
    RemoteRole=ROLE_None
    NetPriority=1.400000
}
