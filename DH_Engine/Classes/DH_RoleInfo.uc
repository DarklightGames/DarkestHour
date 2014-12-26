//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_RoleInfo extends RORoleInfo
    placeable
    abstract;

var     bool    bIsATGunner;            // Enable player to request AT resupply.
var     bool    bCanUseMortars;         // Enable player to use mortars.
var     bool    bIsSquadLeader;
var     bool    bIsMortarObserver;
var     bool    bIsArtilleryOfficer;

var()   bool    bCarriesATAmmo;         // Enable player to carry rocket anti-tank ammunition.
var()   bool    bCarriesMortarAmmo;     // Enable player to carry mortar ammunition.

var array<float> HeadgearProbabilities;

function PostBeginPlay()
{
    if (DarkestHourGame(Level.Game) != none)
        DarkestHourGame(Level.Game).AddRole(self);

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
    HeadgearProbabilities(0)=1.0
    HeadgearProbabilities(1)=0.0
    HeadgearProbabilities(2)=0.0
    HeadgearProbabilities(3)=0.0
    HeadgearProbabilities(4)=0.0
    HeadgearProbabilities(5)=0.0
    HeadgearProbabilities(6)=0.0
    HeadgearProbabilities(7)=0.0
    HeadgearProbabilities(8)=0.0
    Texture=texture'DHEngine_Tex.RoleInfo'
    bCarriesATAmmo=true
    bCarriesMortarAmmo=true
    bCarriesMGAmmo=true
}
