//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_RoleInfo extends RORoleInfo
    placeable
    abstract;

var     bool    bIsATGunner;         // enable player to request AT resupply.
var     bool    bCanUseMortars;      // enable player to use mortars.
var     bool    bIsSquadLeader;
var     bool    bIsMortarObserver;
var     bool    bIsArtilleryOfficer;

var()   float   DefaultStartAmmo;    // % of ammo role will default to (0.0 to 100.0)
var()   float   MinStartAmmo;        // min % of ammo role can use (0.0 to 100.0)
var()   float   MaxStartAmmo;        // max % of ammo role can use (0.0 to 100.0)

var()   int     DeployTimeMod;       // role modification to team's base deploy time (in seconds)
var()   int     MinAmmoTimeMod;      // mod for selecting the least ammo (in seconds)
var()   int     MaxAmmoTimeMod;      // mod for selecting the most ammo (in seconds)

var()   bool    bCarriesATAmmo;      // enable player to carry rocket anti-tank ammunition.
var()   bool    bCarriesMortarAmmo;  // enable player to carry mortar ammunition.

var array<float> HeadgearProbabilities;

function PostBeginPlay()
{
    if (DarkestHourGame(Level.Game) != none)
    {
        DarkestHourGame(Level.Game).AddRole(self);
    }

    HandlePrecache();
}

function class<ROHeadgear> GetHeadgear()
{
    local int           i;
    local float         r, ProbabilitySum;

    if (Headgear.Length == 1)
    {
        return Headgear[0];
    }

    r = FRand();

    for (i = 0; i < Headgear.Length; ++i)
    {
        ProbabilitySum += HeadgearProbabilities[i];

        if (r <= ProbabilitySum)
        {
            return Headgear[i];
        }
    }

    return none;
}

defaultproperties
{
    DefaultStartAmmo=70.0
    MinStartAmmo=30.0
    MaxStartAmmo=100.0
    DeployTimeMod=0
    MinAmmoTimeMod=-5
    MaxAmmoTimeMod=25
    HeadgearProbabilities(0)=1.0
    HeadgearProbabilities(1)=0.0
    HeadgearProbabilities(2)=0.0
    HeadgearProbabilities(3)=0.0
    HeadgearProbabilities(4)=0.0
    HeadgearProbabilities(5)=0.0
    HeadgearProbabilities(6)=0.0
    HeadgearProbabilities(7)=0.0
    HeadgearProbabilities(8)=0.0
    bCarriesATAmmo=true
    bCarriesMortarAmmo=true
    bCarriesMGAmmo=true
}
