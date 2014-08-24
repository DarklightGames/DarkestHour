//=============================================================================
// DHStringMessage
//=============================================================================
// New messages
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2003 Erik Christensen
//=============================================================================

class DHStringMessage extends LocalMessage;

//=============================================================================
// Functions
//=============================================================================

//-----------------------------------------------------------------------------
// AssembleString
//-----------------------------------------------------------------------------

static function string AssembleString(
    HUD myHUD,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional String MessageString
    )
{
    return MessageString;
}

//-----------------------------------------------------------------------------
// GetDHConsoleColor
//-----------------------------------------------------------------------------

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, int AlliedNationID, bool bSimpleColours)
{
    return default.DrawColor;
}


//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     bIsSpecial=false
     Lifetime=8
     PosY=0.700000
}
