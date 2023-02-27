//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHChatRoomMessage extends ChatRoomMessage;

var localized string CannotJoinSquadChannelText;
var localized string CannotJoinCommandChannelText;

static function string AssembleMessage(int Index, string ChannelTitle, optional PlayerReplicationInfo RelatedPRI)
{
    local string Text;

    if (Index >= 0 && Index < arraycount(default.ChatRoomString))
    {
        return super.AssembleMessage(Index, ChannelTitle, RelatedPRI);
    }

    switch (Index)
    {
        case 16:
            Text = default.CannotJoinSquadChannelText;
            break;
        case 17:
            Text = default.CannotJoinCommandChannelText;
            break;
        default:
            Warn("Invalid message index");
            return "";
    }

    return Repl(Text, "%title%", ChannelTitle);
}

defaultproperties
{
    CannotJoinSquadChannelText="Couldn't join channel `%title%`. You must to be in a squad."
    CannotJoinCommandChannelText="Couldn't join channel `%title%`. You must be a squad leader or an assistant, and your squad must have at least 2 members."
}
