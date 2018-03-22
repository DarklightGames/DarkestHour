//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHSupplyVehicleMessage extends ROTouchMessagePlus
    abstract;

var localized string PromptMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController PC;

    PC = PlayerController(OptionalObject);

    return class'DarkestHourGame'.static.ParseLoadingHintNoColor(default.PromptMessage, PC);
}

defaultproperties
{
    PromptMessage="[%ROMANUALRELOAD%] to load supplies / [%ROMGOPERATION%] to unload supplies"
    PosY=0.85
    FontSize=-3
}

