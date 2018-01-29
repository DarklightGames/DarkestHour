//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHPlayerChatManager extends UnrealPlayerChatManager;

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions or StoredChatRestrictions arrays somehow being set at an extreme length
simulated function ChatDebug()
{
    local int i;

    for (i = 0; i < StoredChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "ChatDebug function reached 500 iterations looping through StoredChatRestrictions array with length of" @ StoredChatRestrictions.Length);
            break;
        }

        Log("StoredChatRestrictions[" $ i $ "] Hash:" @ StoredChatRestrictions[i].PlayerHash @ " Restriction:" $ StoredChatRestrictions[i].Restriction);
    }

    for (i = 0; i < ChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "ChatDebug function reached 500 iterations looping through ChatRestrictions array with length of" @ ChatRestrictions.Length);
            break;
        }

        LogChatRestriction(i);
    }
}

// Modified to prevent remote possibility of runaway loop due to StoredChatRestrictions array somehow being set at an extreme length
simulated protected function bool LoadChatBan(string PlayerHash, out byte OutRestriction)
{
    local int i;

    for (i = 0; i < StoredChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "LoadChatBan function reached 500 iterations looping through StoredChatRestrictions array with length of" @ StoredChatRestrictions.Length);
            break;
        }

        if (StoredChatRestrictions[i].PlayerHash == PlayerHash)
        {
            OutRestriction = StoredChatRestrictions[i].Restriction;

            return true;
        }
    }

    return false;
}

// Modified to prevent remote possibility of runaway loop due to StoredChatRestrictions array somehow being set at an extreme length
simulated protected function StoreChatBan(string PlayerHash, byte Restriction)
{
    local int i;

    // First, determine if this player is already in our list - if so, replace the restriction with the specified one
    for (i = 0; i < StoredChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "StoreChatBan function reached 500 iterations looping through StoredChatRestrictions array with length of" @ StoredChatRestrictions.Length);
            break;
        }

        if (StoredChatRestrictions[i].PlayerHash == PlayerHash)
        {
            break;
        }
    }

    if (i == StoredChatRestrictions.Length)
    {
        // If the restriction is 0, stop here - no restriction
        if (Restriction == 0)
        {
            return;
        }

        StoredChatRestrictions.Length = i + 1;
    }
    else if (Restriction == 0)
    {
        StoredChatRestrictions.Remove(i, 1);

        return;
    }

    Log("StoreChatBan PlayerHash:" @ PlayerHash @ " Restriction:" @ Restriction, 'ChatManager');
    StoredChatRestrictions[i].PlayerHash = PlayerHash;
    StoredChatRestrictions[i].Restriction = Restriction;
}

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions array somehow being set at an extreme length
simulated function TrackNewPlayer(int PlayerID, string PlayerHash, string PlayerAddress)
{
    local PlayerReplicationInfo PRI;
    local byte                  NewRestriction;
    local int                   i;

    if (PlayerOwner == none)
    {
        Log(Name @ "couldn't update server tracking - no PlayerOwner!", 'ChatManager');

        return;
    }

    Log(Name @ "___________________TrackNewPlayer PlayerID:" @ PlayerID @ " PlayerHash:" @ PlayerHash @ " PlayerAddress:" @ PlayerAddress, 'ChatManager');

    // First, check if we're already tracking this player
    for (i = 0; i < ChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "TrackNewPlayer function reached 500 iterations looping through ChatRestrictions array with length of" @ ChatRestrictions.Length);
            break;
        }

        if (ChatRestrictions[i].PlayerID == PlayerID)
        {
            break;
        }
    }

    if (i == ChatRestrictions.Length)
    {
        ChatRestrictions.Length = ChatRestrictions.Length + 1;
    }

    // Next, check if we've got this player's hash in our list of stored bans - if so, notify the server about our preference
    if (Role < ROLE_Authority && LoadChatBan(PlayerHash, NewRestriction))
    {
        PlayerOwner.ServerChatRestriction(PlayerID, NewRestriction);
    }
    else if (Level.NetMode == NM_ListenServer && PlayerOwner == Level.GetLocalPlayerController())
    {
        LoadChatBan(PlayerHash, NewRestriction);
    }

    // Now, add this player to the instance tracking
    ChatRestrictions[i].PlayerID = PlayerID;
    ChatRestrictions[i].PlayerHash = PlayerHash;
    ChatRestrictions[i].PlayerAddress = PlayerAddress;
    ChatRestrictions[i].Restriction = NewRestriction;

    // Finally, add this player's voice mask to the tracking info (only happens on server)
    // VoiceID is used to determine which players are in which channels
    PRI = PlayerOwner.GameReplicationInfo.FindPlayerByID(PlayerID);

    if (PRI != none)
    {
        ChatRestrictions[i].PlayerVoiceMask = PRI.VoiceID;
    }
}

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions array somehow being set at an extreme length
simulated function UnTrackPlayer(int PlayerID)
{
    local int i;

    Log("UnTrackPlayer:" @ PlayerID, 'ChatManager');

    // Remove this player from the ban tracking system
    for (i = 0; i < ChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "UnTrackPlayer function reached 500 iterations looping through ChatRestrictions array with length of" @ ChatRestrictions.Length);
            break;
        }

        if (ChatRestrictions[i].PlayerID == PlayerID)
        {
            ChatRestrictions.Remove(i, 1);

            return;
        }
    }

    Log("UnTrackPlayer couldn't find restriction for PlayerID:" @ PlayerID, 'ChatManager');
}

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions array somehow being set at an extreme length
function bool IsBanned(PlayerReplicationInfo PRI)
{
    local string PlayerHash;
    local int    i;

    PlayerHash = PlayerController(PRI.Owner).GetPlayerIDHash();
    Log(Name @ "IsBanned() PRI:" @ PRI.Name, 'ChatManager');

    for (i = 0; i < ChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "IsBanned function reached 500 iterations looping through ChatRestrictions array with length of" @ ChatRestrictions.Length);
            break;
        }

        if (ChatRestrictions[i].PlayerHash == PlayerHash)
        {
            Log(Name @ "IsBanned() found matching PlayerHash for" @ PlayerHash $ ":" $ i @ " Restriction:" @ ChatRestrictions[i].Restriction, 'ChatManager');

            return bool(ChatRestrictions[i].Restriction & BANNED);
        }
    }

    return false;
}

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions array somehow being set at an extreme length
simulated function bool SetRestriction(int Index, byte Type)
{
    if (!IsValid(Index))
    {
        // If we aren't currently tracking this player, and the restriction is none, don't add the restriction
        if (Type == 0)
        {
            return false;
        }

        Index = ChatRestrictions.Length;
        ChatRestrictions.Length = Index + 1;
    }
    // If the new restriction is the same as the current restriction, stop here
    else if (ChatRestrictions[Index].Restriction == Type)
    {
        return false;
    }

    ChatRestrictions[Index].Restriction = Type;

    return true;
}

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions array somehow being set at an extreme length
simulated function bool ClientIsBanned(string PlayerHash)
{
    local int i;

    if (PlayerHash == "")
    {
        return true;
    }

    for (i = 0; i < ChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "ClientIsBanned function reached 500 iterations looping through ChatRestrictions array with length of" @ ChatRestrictions.Length);
            break;
        }

        if (ChatRestrictions[i].PlayerHash == PlayerHash)
        {
            return bool(ChatRestrictions[i].Restriction & BANNED);
        }
    }

    return false;
}

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions array somehow being set at an extreme length
simulated protected function string GetPlayerHash(int PlayerID)
{
    local int i;

    if (PlayerID < 1)
    {
        return "";
    }

    for (i = 0; i < ChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "GetPlayerHash function reached 500 iterations looping through ChatRestrictions array with length of" @ ChatRestrictions.Length);
            break;
        }

        Log(Name @ "GetPlayerHash Match:" @ PlayerID @ " Test[" $ i $ "]:" @ ChatRestrictions[i].PlayerID);

        if (ChatRestrictions[i].PlayerID == PlayerID)
        {
            return ChatRestrictions[i].PlayerHash;
        }
    }

    return "";
}

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions array somehow being set at an extreme length
simulated protected function int GetIDIndex(int PlayerID)
{
    local int i;

    if (PlayerID < 1)
    {
        return -1;
    }

    for (i = 0; i < ChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "GetIDIndex function reached 500 iterations looping through ChatRestrictions array with length of" @ ChatRestrictions.Length);
            break;
        }

        if (ChatRestrictions[i].PlayerID == PlayerID)
        {
            return i;
        }
    }

    return -1;
}

// Modified to prevent remote possibility of runaway loop due to ChatRestrictions array somehow being set at an extreme length
simulated protected function int GetHashIndex(string PlayerHash)
{
    local int i;

    if (PlayerHash == "")
    {
        return -1;
    }

    for (i = 0; i < ChatRestrictions.Length; ++i)
    {
        if (i >= 500)
        {
            Warn(Name @ "GetHashIndex function reached 500 iterations looping through ChatRestrictions array with length of" @ ChatRestrictions.Length);
            break;
        }

        if (ChatRestrictions[i].PlayerHash == PlayerHash)
        {
            return i;
        }
    }

    return -1;
}

defaultproperties
{
}
