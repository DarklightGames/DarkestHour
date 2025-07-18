//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Just a re-statement of ROResetGameMsg, but with better string localization.
//==============================================================================

class DHResetGameMsg extends ROCriticalMessage;

var localized string CountdownText;
var localized string GameRestartingText;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    if( Switch <= 10 )
	{
	    return Repl(default.CountdownText, "{seconds}", Switch);
	}
	else
	{
	    return default.GameRestartingText;
	}
}

defaultproperties
{
	bBeep=false
	CountdownText="The game will restart in {seconds} seconds"
	GameRestartingText="The game is now restarting"
    LifeTime=1
    bQuickFade=true
	QuickFadeTime=0.01
}
