//=============================================================================
// DH_MGBarrel
//=============================================================================
// this is the base MG barrel class.
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - Jeffrey "Antarian" Nakai & John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_MGBarrel extends Actor;

//=============================================================================
// Variables
//=============================================================================

var     float       DH_MGCelsiusTemp;           // current barrel temp
var     float       DH_MGSteamTemp,              // temp barrel begins to steam
                    DH_MGCriticalTemp,          // temp barrel steams alot and conefire error introduced
                    DH_MGFailTemp,              // temp at which barrel fails and unusable
                    BarrelCoolingRate,          // rate/second the barrel cools at
                    FiringHeatIncrement;        // deg C/shot the barrel heat is increased

var     bool        bBarrelFailed,              // if barrel passes ROMGFailTemp, becomes true and barrel unusable
                    bBarrelSteaming,            // if barrel passes ROMGSteamTemp, we'll start steaming the barrel
                    bBarrelDamaged;             // if barrel passes ROMGCriticalTemp, becomes true and conefire error introduced

var     int         LevelCTemp;                 //  The temperature of the level we're playing in

var     float       BarrelTimerRate;            // How fast to call the timer for this barrel. We don't really need to cool the Barrel every tick

//=============================================================================
// Functions
//=============================================================================
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if ((Role == ROLE_Authority) && (DarkestHourGame(Level.Game).LevelInfo != none))
    {
        LevelCTemp = FtoCelsiusConversion(DarkestHourGame(Level.Game).LevelInfo.TempFahrenheit);
        DH_MGCelsiusTemp = LevelCTemp;
        //log("ROMGBarrel::PostBeginPlay - ROMGCelsiusTemp is "$ROMGCelsiusTemp);
    }
}

simulated function Destroyed()
{
    // if the barrel is destroyed and is steaming, de-activate the steam effect
    if (bBarrelSteaming)
        DH_MGBase(Owner).ToggleBarrelSteam(false);

    if (bBarrelDamaged)
        DH_MGBase(Owner).bBarrelDamaged = false;

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
    NewCTemp = NewCTemp/9.0;
    //log("ROMGBarrel::FtoCelsiusConversion - NewCTemp is "$NewCTemp);

    return NewCTemp;
}

//------------------------------------------------------------------------------
// WeaponFired(RO) - This is a server-side function that will handle
//  barrel heating whenver the mg fires
//------------------------------------------------------------------------------
function WeaponFired()
{
    // Increment the barrel temp by 1 deg C for firing
    DH_MGCelsiusTemp += FiringHeatIncrement;

    // Only CheckBarrelSteaming if the barrel isn't steaming yet
    if (!bBarrelSteaming && (DH_MGCelsiusTemp > DH_MGSteamTemp))
    {
        bBarrelSteaming = true;
        DH_MGBase(Owner).ToggleBarrelSteam(bBarrelSteaming);
    }

    if (DH_MGCelsiusTemp > DH_MGFailTemp)
    {
        bBarrelFailed = true;
    }

    UpdateBarrelStatus();

    //log("ROMGCelsiusTemp on the server is "$ROMGCelsiusTemp);
    //log("bBarrelFailed is "$bBarrelFailed);
}

// Will update this barrel and the weapons's barrel status
function UpdateBarrelStatus()
{
    if (bBarrelFailed)
    {
        if (DH_MGbase(Owner) != none)
            DH_MGbase(Owner).bBarrelFailed = true;
    }

    if (!bBarrelSteaming && (DH_MGCelsiusTemp > DH_MGSteamTemp))
    {
        bBarrelSteaming = true;
        DH_MGBase(Owner).ToggleBarrelSteam(bBarrelSteaming);
    }

    if (!bBarrelDamaged && (DH_MGCelsiusTemp > DH_MGCriticalTemp))
    {
        bBarrelDamaged = true;
        DH_MGBase(Owner).bBarrelDamaged = true;
    }
}

// Will update this barrel status when it's not currently in use without affecting the weapon
function UpdateSpareBarrelStatus()
{
    if (!bBarrelSteaming && (DH_MGCelsiusTemp > DH_MGSteamTemp))
    {
        bBarrelSteaming = true;
    }

    if (!bBarrelDamaged && (DH_MGCelsiusTemp > DH_MGCriticalTemp))
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
            DH_MGBase(Owner).ToggleBarrelSteam(true);

        // if the barrel is being put on and is damaged, set the weapon to have
        // a damaged barrel
        if (bBarrelDamaged)
            DH_MGBase(Owner).bBarrelDamaged = true;

        SetTimer(BarrelTimerRate, true);
    }

    //------------------------------------------------------------------------------
    // Timer - This is a server-side function that will handle barrel heat
    //  related operations such as barrel steaming and cone fire activation calls
    //------------------------------------------------------------------------------
    function Timer()
    {
        // make sure this is done on the authority
        // if temp is at the level temp, don't bother with anything else
        if ((Role < ROLE_Authority) || (DH_MGCelsiusTemp == LevelCTemp))
        {
            return;
        }

        // lower the barrel temp or set to Level ambient temp if it goes below
        if (DH_MGCelsiusTemp > LevelCTemp)
        {
            //log("In ROMGBarrel tick, time is "$level.timeseconds$" ROMGCelsiusTemp is "$ROMGCelsiusTemp);
            DH_MGCelsiusTemp -= (BarrelTimerRate * BarrelCoolingRate);
        }
        else if (DH_MGCelsiusTemp < LevelCTemp)
        {
            DH_MGCelsiusTemp = LevelCTemp;
        }

        if (bBarrelSteaming && (DH_MGCelsiusTemp < DH_MGSteamTemp))
        {
            bBarrelSteaming = false;
            DH_MGBase(Owner).ToggleBarrelSteam(bBarrelSteaming);
        }

        // Questionable, once the barrel is damaged, does it ever really get better again?
        if (bBarrelDamaged && (DH_MGCelsiusTemp < DH_MGCriticalTemp))
        {
            bBarrelDamaged = false;
            DH_MGBase(Owner).bBarrelDamaged = false;
        }
    }
}

//------------------------------------------------------------------------------
// Allows Barrel heat to continue to be tracked, but without the steam or cone
//  fire toggling calls to the MG
//------------------------------------------------------------------------------
state BarrelOff
{
    function BeginState()
    {
        // if the barrel is being removed and is steaming, shut off the steam
        // emitter
        if (bBarrelSteaming)
        {
            DH_MGBase(Owner).ToggleBarrelSteam(false);
        }

        SetTimer(BarrelTimerRate, true);
    }

    function Timer()
    {
        // make sure this is done on the authority
        if ((Role < ROLE_Authority) || (DH_MGCelsiusTemp == LevelCTemp))
        {
            return;
        }

        // lower the barrel temp or set to Level ambient temp if it goes below
        if (DH_MGCelsiusTemp > LevelCTemp)
        {
            //log("In ROMGBarrel tick, time is "$level.timeseconds$" ROMGCelsiusTemp is "$ROMGCelsiusTemp);
            DH_MGCelsiusTemp -= (BarrelTimerRate * BarrelCoolingRate);
        }

        else if (DH_MGCelsiusTemp < LevelCTemp)
        {
            DH_MGCelsiusTemp = LevelCTemp;
        }

        if (bBarrelSteaming && (DH_MGCelsiusTemp < DH_MGSteamTemp))
        {
            bBarrelSteaming = false;
        }

        if (bBarrelDamaged && (DH_MGCelsiusTemp < DH_MGCriticalTemp))
        {
            bBarrelDamaged = false;
        }
    }
}

defaultproperties
{
     DH_MGSteamTemp=225.000000
     DH_MGCriticalTemp=250.000000
     DH_MGFailTemp=275.000000
     BarrelCoolingRate=1.000000
     FiringHeatIncrement=1.000000
     BarrelTimerRate=0.100000
     DrawType=DT_none
     bHidden=true
     bReplicateMovement=false
     RemoteRole=ROLE_none
     NetPriority=1.400000
}
