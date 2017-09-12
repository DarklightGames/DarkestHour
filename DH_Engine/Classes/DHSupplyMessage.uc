//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSupplyMessage extends ROGameMessage;

var localized string SuppliesDroppedMessage;

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
            S = default.SuppliesDroppedMessage;
            S = Repl(S, "{0}", SupplyCount);
            S = Repl(S, "{1}", CSA.GetHumanReadableName());
            return S;
            break;
        default:
            break;
    }
}

defaultproperties
{
    SuppliesDroppedMessage="{0} supplies have been dropped off at {1}"
}

