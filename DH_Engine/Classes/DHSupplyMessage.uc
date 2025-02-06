//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSupplyMessage extends ROGameMessage;

var localized string    SuppliesUnloaded;
var localized string    SuppliesLoaded;
var localized string    VehicleFull;
var localized string    VehicleEmpty;
var localized string    NoSupplyCaches;
var localized string    SupplyCacheEmpty;
var localized string    SupplyCacheFull;
var localized string    SupplyCacheFallbackName;
var localized string    SuppliesRefunded;

static function string GetStringFromSwitch(int Switch)
{
    switch (Switch)
    {
        case 0:
            return default.SuppliesUnloaded;
        case 1:
            return default.SuppliesLoaded;
        case 2:
            return default.VehicleFull;
        case 3:
            return default.NoSupplyCaches;
        case 4:
            return default.VehicleEmpty;
        case 5:
            return default.SupplyCacheEmpty;
        case 6:
            return default.SupplyCacheFull;
        case 7:
            return default.SuppliesRefunded;
    }
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int Switch1, SupplyCount;
    local DHConstructionSupplyAttachment CSA;
    local string S;

    class'UInteger'.static.ToShorts(Switch, Switch1, SupplyCount);
    CSA = DHConstructionSupplyAttachment(OptionalObject);

    S = Repl(GetStringFromSwitch(Switch1), "{0}", SupplyCount);

    if (CSA != none)
    {
        S = Repl(S, "{1}", CSA.GetHumanReadableName());
    }
    else
    {
        S = Repl(S, "{1}", default.SupplyCacheFallbackName);
    }

    return S;
}

defaultproperties
{
    SuppliesUnloaded="{0} supplies have been unloaded from the vehicle to a nearby {1}"
    SuppliesLoaded="{0} supplies have been loaded into the vehicle from a nearby {1}"
    VehicleFull="The vehicle's supply cache is full."
    NoSupplyCaches="There are no nearby supply caches."
    VehicleEmpty="The vehicle's supply cache is empty."
    SupplyCacheEmpty="The nearby supply cache is empty."
    SupplyCacheFull="The nearby supply cache is full."
    SupplyCacheFallbackName="supply cache"
    SuppliesRefunded="{0} supplies have been refunded to nearby caches."
}

