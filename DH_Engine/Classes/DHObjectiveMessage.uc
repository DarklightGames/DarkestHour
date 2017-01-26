//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHObjectiveMessage extends ROObjectiveMsg
    abstract;

var(Messages) localized string AxisNeutralized;
var(Messages) localized string AlliesNeutralized;

// Override to handle more messages
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (ROObjective(OptionalObject) == none)
    {
        return "";
    }

    switch (Switch)
    {
        case 0:
            return default.AxisCapture $ ROObjective(OptionalObject).ObjName;
        case 1:
            return default.AlliesCapture $ ROObjective(OptionalObject).ObjName;
        case 2:
            return default.AxisTriggeredMessage $ ROObjective(OptionalObject).ObjName;
        case 3:
            return default.AlliesTriggeredMessage $ ROObjective(OptionalObject).ObjName;
        case 4:
            return default.AxisNeutralized $ ROObjective(OptionalObject).ObjName;
        case 5:
            return default.AlliesNeutralized $ ROObjective(OptionalObject).ObjName;
    }
}

defaultproperties
{
    iconTexture=texture'DH_GUI_Tex.GUI.criticalmessages_icons'
    AxisNeutralized="The Axis forces have neutralized "
    AlliesNeutralized="The Allied forces have neutralized "
}
