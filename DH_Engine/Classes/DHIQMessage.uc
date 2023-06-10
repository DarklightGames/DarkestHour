//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHIQMessage extends LocalMessage
    abstract;

var localized string LeaderAWOLMessage;
var localized string MemberAWOLMessage;
var localized string NotInSquadMessage;

var localized array<string> Congratulations;

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string MessageBody, MessageEnd;

    if (default.Congratulations.Length >= 1)
    {
        MessageEnd = default.Congratulations[Rand(default.Congratulations.Length - 1)];
    }

    switch (S)
    {
        case 1:
            MessageBody = default.LeaderAWOLMessage;
            break;
        case 2:
            MessageBody = default.MemberAWOLMessage;
            break;
        case 3:
            MessageBody = default.NotInSquadMessage;
            break;
        default:
            return "";
    }

    return "Intellect is growing:" @ MessageBody @ MessageEnd;
}

defaultproperties
{
    DrawColor=(R=255,G=85,B=221,A=255)

    LeaderAWOLMessage="You're neglecting your squad and your supply lines."
    MemberAWOLMessage="You're abandoning your squad."
    NotInSquadMessage="You're not in a squad."

    Congratulations(0)="Wow! Such smarts!"
    Congratulations(1)="Amazing!"
    Congratulations(2)="You're a tactical genius!"
    Congratulations(3)="Well done!"
    Congratulations(4)="Absolute madman!"
    Congratulations(6)="Brilliant!"
    Congratulations(7)="You're the smartest!"

    bIsSpecial=false
    bIsConsoleMessage=true
    LifeTime=8.0
}
