//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHReinforcementMsg extends DHFriendlyInformationMsg
    abstract;

#exec OBJ LOAD FILE=..\Sounds\DH_SundrySounds.uax

var localized string ReinforcementsRemaining;
var localized string ReinforcementsDepleted;

// Modified to play a sound to go with screen screen message
static function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    P.ClientPlaySound(Sound'DH_SundrySounds.Messages.ReinforcementsLow',,, SLOT_Interface);

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
}
