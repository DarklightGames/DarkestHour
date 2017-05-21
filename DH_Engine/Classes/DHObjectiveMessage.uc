//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHObjectiveMessage extends ROObjectiveMsg
    abstract;

var(Messages) localized string AxisNeutralized;
var(Messages) localized string AlliesNeutralized;

// Override to handle more messages
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string ObjectiveName;

    if (ROObjective(OptionalObject) != none)
    {
        ObjectiveName = ROObjective(OptionalObject).ObjName;

        switch (Switch)
        {
            case 0:
                return default.AxisCapture $ ObjectiveName;
            case 1:
                return default.AlliesCapture $ ObjectiveName;
            case 2:
                return default.AxisTriggeredMessage $ ObjectiveName;
            case 3:
                return default.AlliesTriggeredMessage $ ObjectiveName;
            case 4:
                return default.AxisNeutralized $ ObjectiveName;
            case 5:
                return default.AlliesNeutralized $ ObjectiveName;
        }
    }

    return "";
}

defaultproperties
{
    IconTexture=texture'DH_GUI_Tex.GUI.criticalmessages_icons'
    AxisNeutralized="The Axis forces have neutralized "
    AlliesNeutralized="The Allied forces have neutralized "
}
