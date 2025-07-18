//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_FriendlyReload extends DHScoreEvent;

static function DHScoreEvent_FriendlyReload Create()
{
    return new Class'DHScoreEvent_FriendlyReload';
}

defaultproperties
{
    HumanReadableName="Friendly Reload"
    Value=50
    CategoryClass=Class'DHScoreCategory_Support'
}

