//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHRoleInfo extends RORoleInfo
    placeable
    abstract;

struct RolePawn
{
    var class<Pawn>     PawnClass; // possible pawn class for this role
    var float           Weight;    // weighting to be assigned to this choice if randomly selected from a list
};

var     array<RolePawn>     RolePawns;              // list of possible pawn classes for this role, selected randomly (with weighting) if more than 1
var     array<float>        HeadgearProbabilities;  // chance of each Headgear type being randomly selected (linked to Headgear array in RORoleInfo)

var     bool                bIsArtilleryOfficer;    // role has functionality of an artillery officer
var     bool                bCanUseMortars;         // role has functionality of a mortar operator
var     bool                bIsMortarObserver;      // role has functionality of a mortar observer

var()   int                 AddedReinforcementTime; // optional extra time in seconds before re-spawning

function PostBeginPlay()
{
    if (DarkestHourGame(Level.Game) != none)
    {
        DarkestHourGame(Level.Game).AddRole(self);
    }

    HandlePrecache();
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
                GivenItemClass = class<DHWeapon>(DynamicLoadObject(GivenItems[i], class'class'));

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
            PR = class'xUtil'.static.FindPlayerRecord(default.Models[i]);

            if (PR.MeshName != "")
            {
                DynamicLoadObject(PR.MeshName, class'Mesh');
            }

            if (PR.BodySkinName != "")
            {
                Level.ForceLoadTexture(texture(DynamicLoadObject(PR.BodySkinName, class'Material')));
            }

            if (PR.FaceSkinName != "")
            {
                Level.ForceLoadTexture(texture(DynamicLoadObject(PR.FaceSkinName, class'Material')));
            }
        }
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

    return none;
}

// New function to check whether a CharacterName for a player record is valid for this role
// Note that player records are not used in new DH system, resulting in a null value being passed into this function & we return true if role has no defined Models array
simulated function bool IsValidCharacterName(string InCharacterName)
{
    local int i;

    // If role has no defined Models (e.g. using new DH system) return true if a null CharacterName has been passed
    if (default.Models.Length == 0)
    {
        if (InCharacterName != "") log(name @ "IsValidCharacterName: no Models array so returning FALSE for passed CharacterName" @ InCharacterName @ "!!!"); // TEMPDEBUG (Matt)

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

    log(name @ "IsValidCharacterName: returning FALSE for passed CharacterName" @ InCharacterName @ "which is not in the Models array !!!"); // TEMPDEBUG (Matt)

    return false;
}

defaultproperties
{
    Limit=255 // unlimited (0 is now deactivated)
    AddedReinforcementTime=0
    HeadgearProbabilities(0)=1.0
}
