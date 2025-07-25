//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHRoleInfo extends RORoleInfo
    showcategories(Events)
    placeable
    abstract;

struct RolePawn
{
    var() class<Pawn>       PawnClass;              // possible pawn class for this role
    var() float             Weight;                 // weighting to be assigned to this choice if randomly selected from a list
};

var()   array<RolePawn>     RolePawns;              // list of possible pawn classes for this role, selected randomly (with weighting) if more than 1
var     array<float>        HeadgearProbabilities;  // chance of each Headgear type being randomly selected (linked to Headgear array in RORoleInfo)

var     bool                bCanUseMortars;         // role has functionality of a mortar operator
var     bool                bCanCarryExtraAmmo;     // role can carry extra ammo
var     bool                bSpawnWithExtraAmmo;    // role spawns with extra ammo
var     bool                bCarriesRadio;          // role can carry radios
var     bool                bCanPickupWeapons;

var     bool                bExemptSquadRequirement;// this role will be exempt from the requirement of being in a squad to select
var     bool                bRequiresSLorASL;       // player must be a SL or ASL to select this role, only applies when gametype has bSquadSpecialRolesOnly=true
var     bool                bRequiresSL;
var     bool                bCanBeSquadLeader;      // squad leaders can take this role (disabled for special weapon roles!)

var     int                 AddedRoleRespawnTime;   // extra time in seconds before re-spawning

var()   bool                bStartsLocked;          // Role is locked at the start of the game.
var     bool                bIsLocked;              // If true, role is locked and cannot be selected. Can be unlocked via DH_ModifyRole events.

enum EHandType
{
    HAND_Automatic,     // Checks the season, if it's winter, gloves, otherwise bare.
    HAND_Bare,
    HAND_Gloved,
    HAND_Custom
};

var()   EHandType           HandType;
var     Material            BareHandTexture;            // the hand texture this role should use
var     Material            GlovedHandTexture;
var()   Material            CustomHandTexture;

struct SBackpack
{
    var class<DHBackpack> BackpackClass;
    var float             Probability;
    var Vector            LocationOffset;
    var Rotator           RotationOffset;
};

var array<SBackpack> Backpacks;

replication
{
    reliable if (Role == ROLE_Authority)
        bIsLocked;
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    bIsLocked = bStartsLocked;
}

// Modified to include GivenItems array, & to just call StaticPrecache on the DHWeapon item (which now handles all related pre-caching)
// Also to avoid pre-cache stuff on a server & avoid accessed none errors
simulated function HandlePrecache()
{
    local xUtil.PlayerRecord PR;
    local class<DHWeapon>    GivenItemClass;
    local int                i;

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
            if (GivenItems[i] != "")
            {
                GivenItemClass = class<DHWeapon>(DynamicLoadObject(GivenItems[i], Class'class'));

                if (GivenItemClass != none)
                {
                    GivenItemClass.static.StaticPrecache(Level);
                }
            }
        }

        for (i = 0; i < default.Headgear.Length; ++i)
        {
            default.Headgear[i].static.StaticPrecache(Level);
        }

        for (i = 0; i < default.Backpacks.Length; ++i)
        {
            default.Backpacks[i].BackpackClass.static.StaticPrecache(Level);
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
        if (default.Models[i] != "")
        {
            PR = Class'xUtil'.static.FindPlayerRecord(default.Models[i]);

            if (PR.MeshName != "")
            {
                DynamicLoadObject(PR.MeshName, Class'Mesh');
            }

            if (PR.BodySkinName != "")
            {
                Level.ForceLoadTexture(Texture(DynamicLoadObject(PR.BodySkinName, Class'Material')));
            }

            if (PR.FaceSkinName != "")
            {
                Level.ForceLoadTexture(Texture(DynamicLoadObject(PR.FaceSkinName, Class'Material')));
            }
        }
    }

    if (default.VoiceType != "")
    {
        DynamicLoadObject(default.VoiceType, Class'Class');
    }

    if (default.AltVoiceType != "")
    {
        DynamicLoadObject(default.AltVoiceType, Class'Class');
    }
}

static function string GetPawnClass()
{
    local int i;
    local float w, WeightTotal;

    if (default.RolePawnClass == "" && default.RolePawns.Length > 0)
    {
        for (i = 0; i < default.RolePawns.Length; ++i)
        {
            WeightTotal += FMax(0, default.RolePawns[i].Weight);
        }

        w = FRand() * WeightTotal;

        for (i = 0; i < default.RolePawns.Length - 1; ++i)
        {
            w -= FMax(0, default.RolePawns[i].Weight);

            if (w < 0)
            {
                return string(default.RolePawns[i].PawnClass);
            }
       }

       return string(default.RolePawns[default.RolePawns.Length - 1].PawnClass);
    }

    return default.RolePawnClass;
}

// TODO: Refactor offset stuff!
function class<DHBackpack> GetBackpack(out Vector LocationOffset, out Rotator RotationOffset)
{
    local float R, ProbabilitySum;
    local int   i;

    if (Backpacks.Length == 0)
    {
        return none;
    }

    if (Backpacks.Length == 1)
    {
        LocationOffset = Backpacks[0].LocationOffset;
        RotationOffset = Backpacks[0].RotationOffset;
        return Backpacks[0].BackpackClass;
    }

    R = FRand();

    for (i = 0; i < Backpacks.Length; ++i)
    {
        ProbabilitySum += Backpacks[i].Probability;

        if (R <= ProbabilitySum)
        {
            LocationOffset = Backpacks[0].LocationOffset;
            RotationOffset = Backpacks[0].RotationOffset;

            return Backpacks[i].BackpackClass;
        }
    }

    return none;

}

function class<ROHeadgear> GetHeadgear()
{
    local float R, ProbabilitySum;
    local int   i;

    if (Headgear.Length == 0)
    {
        return none;
    }

    if (Headgear.Length == 1)
    {
        return Headgear[0];
    }

    R = FRand();

    for (i = 0; i < Headgear.Length; ++i)
    {
        ProbabilitySum += HeadgearProbabilities[i];

        if (R <= ProbabilitySum)
        {
            return Headgear[i];
        }
    }

    // This fallback is here since it's technically possible for the sum of all probabilities
    // to be less than 1.0, which screws up the above calculation.
    return Headgear[0];
}

simulated function Material GetHandTexture(DH_LevelInfo LI)
{
    local EHandType HT;
    local Material HandTexture;

    HT = HandType;

    if (HT == HAND_Automatic)
    {
        if (LI != none && LI.Season == SEASON_Winter)
        {
            HT = HAND_Gloved;
        }
        else
        {
            HT = HAND_Bare;
        }
    }

    switch (HT)
    {
        case HAND_Gloved:
            HandTexture = GlovedHandTexture;
            break;
        case HAND_Custom:
            HandTexture = CustomHandTexture;
            break;
        case HAND_Bare:
        default:
            HandTexture = BareHandTexture;
            break;
    }

    if (HandTexture == none)
    {
        // If the hand texture somehow ends up being null, just use
        // bare hand texture that we know is set in DHRoleInfo.
        HandTexture = default.BareHandTexture;
    }

    return HandTexture;
}

simulated function Reset()
{
    super.Reset();

    bIsLocked = bStartsLocked;
}

// New function to check whether a CharacterName for a player record is valid for this role
// Note that player records are not used in new DH system, resulting in a null value being passed into this function & we return true if role has no defined Models array
simulated function bool IsValidCharacterName(string InCharacterName)
{
    local int i;

    // If role has no defined Models (e.g. using new DH system) return true if a null CharacterName has been passed
    if (default.Models.Length == 0)
    {
        return InCharacterName == "";
    }

    // Otherwise check whether passed CharacterName is in Models array
    for (i = 0; i < default.Models.Length; ++i)
    {
        if (default.Models[i] == InCharacterName)
        {
            return true;
        }
    }

    return false;
}

simulated static function string GetDisplayName()
{
    if (Class'DHPlayer'.default.bUseNativeRoleNames)
    {
        return default.AltName;
    }
    else
    {
        return default.MyName;
    }
}

simulated function bool IsLimited()
{
    return Limit != 255;
}

defaultproperties
{
    Limit=255 // unlimited (0 is now deactivated)
    HeadgearProbabilities(0)=1.0
    bCanCarryExtraAmmo=true
    bSpawnWithExtraAmmo=false
    BareHandTexture=Texture'Weapons1st_tex.hands'
    GlovedHandTexture=Texture'Weapons1st_tex.hands_gergloves'
    HandType=Hand_Bare
    bCanPickupWeapons=true
    bCanBeSquadLeader=true
    // In order to replicate the locked state of the role, we need to enable property replication and ensure
    // that the actor is always relevant. We'll also tone down the update frequency from 10 to 2 to reduce network load.
    bSkipActorPropertyReplication=false
    bAlwaysRelevant=true
    NetUpdateFrequency=2
}
