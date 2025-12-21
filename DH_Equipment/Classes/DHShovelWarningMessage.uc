//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShovelWarningMessage extends ROCriticalMessage
    abstract;

var localized string CannotBeCrawling;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.CannotBeCrawling;
        default:
            return "";
    }
}

defaultproperties
{
    CannotBeCrawling="You cannot dig while crawling."
}

