//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyRoundTime extends DH_ModifyActors;

var(DH_ModifyRoundTime) enum ERoundTimeOperator
{
    RTO_Add,
    RTO_Subtract,
    RTO_Set
}                                   RoundTimeOperator;      //Add, Subtract or Set
var(DH_ModifyRoundTime) int         Seconds;                //The amount of seconds to add to, subtract from or set the round time.

event Trigger(Actor Other, Pawn EventInstigator)
{
    DarkestHourGame(Level.Game).ModifyRoundTime(Seconds, RoundTimeOperator);
}

defaultproperties
{
    Seconds=60
    Texture=Texture'Engine.S_Trigger'
}
