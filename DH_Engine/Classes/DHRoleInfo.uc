//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHRoleInfo extends RORoleInfo
    placeable
    abstract;

var     bool    bIsATGunner;         // enable player to request AT resupply.
var     bool    bCanUseMortars;      // enable player to use mortars.
var     bool    bIsSquadLeader;
var     bool    bIsMortarObserver;
var     bool    bIsArtilleryOfficer;

var()   float   DefaultStartAmmoPercent;    // % of ammo role will default to (0.0 to 100.0)
var()   float   MinStartAmmoPercent;        // min % of ammo role can use (0.0 to 100.0)
var()   float   MaxStartAmmoPercent;        // max % of ammo role can use (0.0 to 100.0)

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

// Modified to include GivenItems array, to just call StaticPrecache on the DHWeapon item (which now handles all related pre-caching), & to avoid pre-cache stuff on a server
simulated function HandlePrecache()
{
    local xUtil.PlayerRecord PR;
    local int i;

    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < arraycount(PrimaryWeapons); ++i)
        {
            if (class<DHWeapon>(PrimaryWeapons[i].Item) != none)
            {
                class<DHWeapon>(PrimaryWeapons[i].Item).static.StaticPrecache(Level);
            }
        }

        for (i = 0; i < arraycount(SecondaryWeapons); ++i)
        {
            if (class<DHWeapon>(SecondaryWeapons[i].Item) != none)
            {
                class<DHWeapon>(SecondaryWeapons[i].Item).static.StaticPrecache(Level);
            }
        }

        for (i = 0; i < arraycount(Grenades); ++i)
        {
            if (class<DHWeapon>(Grenades[i].Item) != none)
            {
                class<DHWeapon>(Grenades[i].Item).static.StaticPrecache(Level);
            }
        }

        for (i = 0; i < GivenItems.Length; ++i)
        {
            if (class<DHWeapon>(DynamicLoadObject(GivenItems[i], class'class')) != none)
            {
                class<DHWeapon>(DynamicLoadObject(GivenItems[i], class'class')).static.StaticPrecache(Level);
            }
        }

        for (i = 0; i < default.Headgear.Length; ++i)
        {
            default.Headgear[i].static.StaticPrecache(Level);
        }

        if (default.DetachedArmClass != none)
        {
            default.DetachedArmClass.static.PrecacheContent(Level);
        }

        if (default.DetachedLegClass != none)
        {
            default.DetachedLegClass.static.PrecacheContent(Level);
        }
    }

    for (i = 0; i < default.Models.Length; ++i)
    {
        PR = class'xUtil'.static.FindPlayerRecord(default.Models[i]);
        DynamicLoadObject(PR.MeshName, class'Mesh');
        Level.ForceLoadTexture(texture(DynamicLoadObject(PR.BodySkinName, class'Material')));
        Level.ForceLoadTexture(texture(DynamicLoadObject(PR.FaceSkinName, class'Material')));
    }

    if (default.VoiceType != "")
    {
        DynamicLoadObject(default.VoiceType, class'Class');
    }

    if (default.AltVoiceType != "")
    {
        DynamicLoadObject(default.AltVoiceType, class'Class');
    }
}

function class<ROHeadgear> GetHeadgear()
{
    local int           i;
    local float         R, ProbabilitySum;

    if (Headgear.Length == 1)
    {
        return Headgear[0];
    }

    R = FRand();

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
    DefaultStartAmmoPercent=0.7
    MinStartAmmoPercent=0.3
    MaxStartAmmoPercent=1.0
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
