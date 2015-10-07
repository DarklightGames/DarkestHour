//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ModifyRoundTime extends DH_ModifyActors;

var(DH_ModifyRoundTime) enum ERoundTimeOperator
{
    RTO_Add,
    RTO_Subtract,
    RTO_Set
}                                   RoundTimeOperator;      //Add, Subtract or Set
var(DH_ModifyRoundTime) int         Seconds;                //The amount of seconds to add to, subtract from or set the round time.
var(DH_ModifyRoundTime) bool        bShowMessage;           //Whether or not to display a message when this actor is triggered.
var(DH_ModifyRoundTime) bool        bPlaySound;             //Whether or not to play a sound when this actor is triggered.
var(DH_ModifyRoundTime) sound       sound;                  //The sound to play when this actor is triggered.

event Trigger(Actor Other, Pawn EventInstigator)
{
    DarkestHourGame(Level.Game).ModifyRoundTime(Seconds, RoundTimeOperator);
}

defaultproperties
{
    Seconds=60
    bShowMessage=true
    bPlaySound=true
    sound=sound'Miscsounds.Music.notify_drum'
    Texture=texture'Engine.S_Trigger'
}
