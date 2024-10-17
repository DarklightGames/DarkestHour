//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSquadTypeUnassigned extends Object
    abstract;


var           Material Image;
var           string Hint;
var           string Caption;
var           int Limit;

static function string GetSquadAbbreviation(DHPlayerReplicationInfo PRI)
{
    if (PRI == none || PRI.SquadIndex < 0 || PRI.SquadMemberIndex < 0)
    {
        return "";
    }


    // if (IsLogi())
    // {
    //     return default.AbbreviationLogi;
    // }
    // else if (IsSquadLeader())
    // {
    //     return default.AbbreviationSquadLeader;
    // }
    // else if (bIsSquadAssistant)
    // {
    //     return default.AbbreviationAssistant;
    // }
    // else if (IsInSquad())
    // {
    //     return string(SquadMemberIndex + 1);
    // }

    return "";
}


defaultproperties
{
    Image = Material'DH_GUI_Tex.DeployMenu.StopWatch';
    Hint = "Unassigned Players";
    Caption = "Unassigned Players";
    Limit=1
}
