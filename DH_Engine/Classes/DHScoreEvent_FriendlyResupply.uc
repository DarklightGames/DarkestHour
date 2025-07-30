//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_FriendlyResupply extends DHScoreEvent;

static function DHScoreEvent_FriendlyResupply Create()
{
    return new Class'DHScoreEvent_FriendlyResupply';
}

defaultproperties
{
    HumanReadableName="Friendly Resupply"
    Value=50
    CategoryClass=Class'DHScoreCategory_Support'
}

