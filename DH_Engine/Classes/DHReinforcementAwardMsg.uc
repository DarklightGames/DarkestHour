//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHReinforcementAwardMsg extends ROGameMessage
    abstract;

var localized string ObjectiveString;
var localized string ReinforcementAward;
var localized string ReinforcementLoss;
var localized string ReinforcementAttrition;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    local DHObjective Obj;
    local string ObjString, MsgString;

    ObjString = default.ObjectiveString;
    Obj = DHObjective(OptionalObject);

    if (Obj != none)
    {
        ObjString = Obj.ObjName;
    }

    switch (Switch)
    {
        case 0:
            return "";
        default:
            MsgString = Repl(default.ReinforcementAward, "{0}", Switch);
            MsgString = Repl(MsgString, "{1}", ObjString);
            break;
    }

    return MsgString;
}

defaultproperties
{
    ObjectiveString="an objective"
    ReinforcementAward="Your team was awarded {0} reinforcements for capturing {1}!"
    ReinforcementLoss="Your team lost {0} reinforcements for losing {1}!"
    ReinforcementAttrition="Your team is losing significant reinforcemetns from attrition!!!"
}
