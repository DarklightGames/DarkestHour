//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_Suicide extends DHScoreEvent;

static function DHScoreEvent_Suicide Create()
{
    return new Class'DHScoreEvent_Suicide';
}

defaultproperties
{
    HumanReadableName="Suicide"
    Value=-100
    CategoryClass=Class'DHScoreCategory_Combat'
}

