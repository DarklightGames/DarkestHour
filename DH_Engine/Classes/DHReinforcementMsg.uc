//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHReinforcementMsg extends DHFriendlyInformationMsg
    abstract;

var localized string ReinforcementsRemaining;
var localized string ReinforcementsDepleted;
var Sound MessageSound;

// Modified to play a sound to go with screen screen message
static function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    P.ClientPlaySound(default.MessageSound,,, SLOT_Interface);

    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.ReinforcementsDepleted;
        default:
            return Repl(default.ReinforcementsRemaining, "{0}", Switch);
    }
}

defaultproperties
{
    ReinforcementsRemaining="Your team has {0}% reinforcements remaining!"
    ReinforcementsDepleted="Your team has ran out of reinforcements!"
    MessageSound=Sound'DH_SundrySounds.ReinforcementsLow'
}
