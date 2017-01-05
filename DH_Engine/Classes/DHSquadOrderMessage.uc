//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSquadOrderMessage extends ROCriticalMessage
    abstract;

var localized string WaitText;
var localized string AttackText;
var localized string DefendText;

var sound AttackSound;
var sound DefendSound;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.WaitText;
        case 1:
            return default.AttackText;
        case 2:
            return default.DefendText;
        default:
            return "";
    }
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    switch (Switch)
    {
        case 1:
            P.PlayAnnouncement(default.AttackSound, 1, true);
            break;
        case 2:
            P.PlayAnnouncement(default.DefendSound, 1, true);
            break;
        default:
            return;
    }
}

defaultproperties
{
    WaitText="Please wait before making a new order"
    AttackText="Squad has a new attack order"
    DefendText="Squad has a new defend order"
}
