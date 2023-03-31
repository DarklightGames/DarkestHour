//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int Switch1, SupplyCount;
    local DHConstructionSupplyAttachment CSA;
    local string S;

    class'UInteger'.static.ToShorts(Switch, Switch1, SupplyCount);
    CSA = DHConstructionSupplyAttachment(OptionalObject);

    switch (Switch1)
    {
        case 0:
            S = default.SuppliesUnloaded;
            break;
        case 1:
            S = default.SuppliesLoaded;
            break;
        case 2:
            S = default.VehicleFull;
            break;
        case 3:
            S = default.NoSupplyCaches;
            break;
        case 4:
            S = default.VehicleEmpty;
            break;
        case 5:
            S = default.SupplyCacheEmpty;
            break;
        case 6:
            S = default.SupplyCacheFull;
            break;
        default:
            break;
    }

    S = Repl(S, "{0}", SupplyCount);

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
}

