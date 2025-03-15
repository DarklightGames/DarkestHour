//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_Vehicle extends DHConstruction
    dependson(DH_LevelInfo)
    abstract
    notplaceable;

var class<DHVehicle>        VehicleClass;

enum ESeasonFilterOperation
{
    SFO_Any,
    SFO_None
};

struct SeasonFilter
{
    var array<DH_LevelInfo.ESeason> Seasons;
    var ESeasonFilterOperation      Operation;
};

// Options for the vehicle class. Used to store variants and skin variants.
// Note that for simplicity's sake we assume that the entries are stored in ascending order of variants.
struct SVehicleClass
{
    var class<DHVehicle>    VehicleClass;
    var int                 VariantIndex;

    // If this is empty, the variant is always available.
    // Otherwise, the entry will only be available if it is one of the seasons listed.
    var array<SeasonFilter>  SeasonFilters;
};

var array<SVehicleClass>    VehicleClasses;

var DHVehicle               Vehicle;

// The mesh to use when the vehicle is being constructed.
// If not set, the vehicle's default mesh will be used.
var Mesh                    ConstructionBaseMesh;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        VehicleClass;
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    // Skins are not replicated, therefore we need to update client's appearance here.
    if (Role < ROLE_Authority)
    {
        UpdateSkins();
    }
}

function Destroyed()
{
    super.Destroyed();

    if (Vehicle != none)
    {
        Vehicle.Destroy();
    }
}

function OnPlaced()
{
    super.OnPlaced();

    VehicleClass = GetVehicleClass(GetContext());
}

simulated function OnConstructed()
{
    if (Role == ROLE_Authority)
    {
        if (VehicleClass != none)
        {
            Vehicle = Spawn(VehicleClass,,, Location, Rotation);

            GotoState('Dummy');
        }
    }
}

simulated state Dummy
{
    function BeginState()
    {
        SetTimer(1.0, true);
    }

    function Timer()
    {
        if (Vehicle == none)
        {
            Destroy();
        }
    }
}

// TODO: do we put this in the vehicle itself???
function static UpdateProxy(DHActorProxy AP)
{
    local int i, j;
    local DHActorProxyAttachment APA;
    local class<DHVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(AP.GetContext());

    if (VehicleClass != none)
    {
        VehicleClass.static.UpdateProxy(AP);
    }
}

static function string GetMenuName(DHActorProxy.Context Context)
{
    local class<DHVehicle> VC;

    VC = GetVehicleClass(Context);

    if (VC == none)
    {
        return "";
    }

    return VC.default.VehicleNameString;
}

simulated function UpdateSkins()
{
    local int j;

    // Apply any skins that the vehicle has.
    for (j = 0; j < VehicleClass.default.Skins.Length; ++j)
    {
        if (VehicleClass.default.Skins[j] != none)
        {
            Skins[j] = VehicleClass.default.Skins[j];
        }
    }
}

function UpdateAppearance()
{
    SetDrawType(DT_Mesh);

    if (ConstructionBaseMesh != none)
    {
        LinkMesh(ConstructionBaseMesh);
    }
    else
    {
        LinkMesh(VehicleClass.default.Mesh);

        if (HasAnim(VehicleClass.default.BeginningIdleAnim))
        {
            PlayAnim(VehicleClass.default.BeginningIdleAnim);
        }

        if (Role == ROLE_Authority)
        {
            UpdateSkins();
        }
    }

    SetCollisionSize(VehicleClass.default.CollisionRadius, VehicleClass.default.CollisionHeight);
}

function static GetCollisionSize(DHActorProxy.Context Context, out float NewRadius, out float NewHeight)
{
    local class<DHVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(Context);

    if (VehicleClass != none)
    {
        NewRadius = VehicleClass.default.CollisionRadius;
        NewHeight = VehicleClass.default.CollisionHeight;
        return;
    }

    // If we couldn't get the vehicle class, just fall back on to the original method.
    super.GetCollisionSize(Context, NewRadius, NewHeight);
}

// Returns the default skin index for the construction variant.
// Used to provide a more season-specific variant if one is available.
static function int GetDefaultSkinIndexForVariant(DHActorProxy.Context Context, int VariantIndex)
{
    local int i, j, k, DefaultIndex;
    local array<int> Indices;

    Indices = GetAvailableIndicesForVariant(Context, VariantIndex);

    for (i = 0; i < Indices.Length; ++i)
    {
        // We want to find the first entry with a POSITIVE season filter (SFO_Any) that passes, if any.
        // In other words, we don't want to use _excluded_ skins, only _included_ ones.
        // The main use case here is for winter camo skins, since they shouldn't appear in other
        // seasons, but need to be the default in winter.
        for (j = 0; j < default.VehicleClasses[Indices[i]].SeasonFilters.Length; ++j)
        {
            if (default.VehicleClasses[Indices[i]].SeasonFilters[j].Operation == SFO_Any)
            {
                if (IsEntryAvailable(Context, Indices[i]))
                {
                    return i;
                }
            }
        }
    }

    return 0;
}

// Gets the number of variants for the construction.
// Note that this function assumes that the entries are stored in ascending order of variants.
// If this is not the case, the function will return an incorrect value.
static function int GetVariantCount()
{
    local int i, Count, LastVariantIndex;

    LastVariantIndex = -1;

    for (i = 0; i < default.VehicleClasses.Length; ++i)
    {
        if (default.VehicleClasses[i].VariantIndex != LastVariantIndex)
        {
            LastVariantIndex = default.VehicleClasses[i].VariantIndex;
            ++Count;
        }
    }

    return Count;
}

static function array<int> GetAvailableVariantIndices(DHActorProxy.Context Context)
{
    local int i;
    local array<int> Indices;

    for (i = 0; i < default.VehicleClasses.Length; ++i)
    {
        if (IsEntryAvailable(Context, i))
        {
            class'UArray'.static.IAddUnique(Indices, default.VehicleClasses[i].VariantIndex);
        }
    }

    return Indices;
}

// Returns the raw indices of available skins for the specified variant.
static function array<int> GetAvailableIndicesForVariant(DHActorProxy.Context Context, int VariantIndex)
{
    local int i;
    local array<int> Indices;

    Indices = GetAvailableVariantIndices(Context);

    VariantIndex = Indices[VariantIndex % Indices.Length];

    Indices.Length = 0;

    for (i = 0; i < default.VehicleClasses.Length; ++i)
    {
        if (default.VehicleClasses[i].VariantIndex == VariantIndex && IsEntryAvailable(Context, i))
        {
            class'UArray'.static.IAddUnique(Indices, i);
        }
    }

    return Indices;
}

// Override to get a different vehicle class based on scenario (eg. snow camo etc.)
static function class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    local array<int> Indices;
    local int i;

    // Count the number of variants.
    Indices = GetAvailableVariantIndices(Context);

    if (Indices.Length == 0)
    {
        // Shouldn't happen, but just in case.
        Warn("No variants found for construction " @ default.Class);
        return none;
    }

    // Get the avaiable skin indices for the variant.
    Indices = GetAvailableIndicesForVariant(Context, Indices[Context.VariantIndex % Indices.Length]);

    if (Indices.Length == 0)
    {
        // Shouldn't happen, but just in case.
        Warn("No entries found for construction " @ default.Class @ " with variant index " @ Context.VariantIndex);
        return none;
    }

    return default.VehicleClasses[Indices[Context.SkinIndex % Indices.Length]].VehicleClass;
}

// Returns whether the entry is available based on the season.
static function bool IsEntryAvailable(DHActorProxy.Context Context, int Index)
{
    local int i, j;
    local bool bHasAny;
    
    if (default.VehicleClasses[Index].SeasonFilters.Length == 0)
    {
        // If the season filter list is empty, the entry is always available.
        return true;
    }

    // Otherwise, the entry is available if the current season is in the list.
    for (i = 0; i < default.VehicleClasses[Index].SeasonFilters.Length; ++i)
    {
        switch (default.VehicleClasses[Index].SeasonFilters[i].Operation)
        {
            case SFO_Any:
                bHasAny = false;
                for (j = 0; j < default.VehicleClasses[Index].SeasonFilters[i].Seasons.Length; ++j)
                {
                    if (default.VehicleClasses[Index].SeasonFilters[i].Seasons[j] == Context.LevelInfo.Season)
                    {
                        bHasAny = true;
                        break;
                    }
                }
                if (!bHasAny)
                {
                    return false;
                }
                break;
            case SFO_None:
                for (j = 0; j < default.VehicleClasses[Index].SeasonFilters[i].Seasons.Length; ++j)
                {
                    if (default.VehicleClasses[Index].SeasonFilters[i].Seasons[j] == Context.LevelInfo.Season)
                    {
                        return false;
                    }
                }
                break;
        }

        return true;
    }

    return false;
}

static function RuntimeData CreateProxyRuntimeData(DHConstructionProxy CP)
{
    local DHConstructionProxy.Context Context;
    local RuntimeData RuntimeData;
    local array<int> Indices;

    RuntimeData = super.CreateProxyRuntimeData(CP);

    Context = CP.GetContext();

    // NOTE: The `.Length` call cannot be done directly on the function call because
    // it will always return 0. This is a bug in UnrealScript.
    Indices = GetAvailableVariantIndices(Context);
    RuntimeData.bHasVariants = Indices.Length > 1;

    Indices = GetAvailableIndicesForVariant(Context, CP.VariantIndex);
    RuntimeData.bHasSkins = Indices.Length > 1;

    return RuntimeData;
}

static function bool ShouldShowOnMenu(DHActorProxy.Context Context)
{
    if (GetVehicleClass(Context) != none)
    {
        return super.ShouldShowOnMenu(Context);
    }
    else
    {
        return false;
    }
}

defaultproperties
{
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'
    bDestroyOnConstruction=false
    BrokenLifespan=0.0
    ConstructionVerb="emplace"
    GroupClass=class'DHConstructionGroup_Guns'
    bCanBeDamaged=false
    CompletionPointValue=100
    bCanOnlyPlaceOnTerrain=false
    Stages(0)=(Progress=0)
}
