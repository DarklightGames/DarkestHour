//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

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
    optional string MessageString
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
