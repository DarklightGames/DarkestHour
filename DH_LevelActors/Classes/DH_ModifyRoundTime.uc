//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
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
var(DH_ModifyRoundTime) sound       Sound;                  //The sound to play when this actor is triggered.

event Trigger(Actor Other, Pawn EventInstigator)
{
    local   ROTeamGame              GameInstance;
    local   ROGameReplicationInfo   GameReplicationInfoInstance;
    local   float                   ElapsedTimeDelta;

    if (!Level.Game.IsInState('RoundInPlay'))
        return; //Don't modify time if it's not in play state

    GameInstance = ROTeamGame(Level.Game);
    GameReplicationInfoInstance = ROGameReplicationInfo(GameInstance.GameReplicationInfo);

    switch(RoundTimeOperator)
    {
        //Add X seconds to the round time.
        case RTO_Add:
            GameInstance.ElapsedTime -= Seconds;
            GameInstance.LastReinforcementTime[0] -= Seconds;
            GameInstance.LastReinforcementTime[1] -= Seconds;
            GameReplicationInfoInstance.ElapsedTime -= Seconds; //comment
            break;
        //Subtract X seconds from the round time.
        case RTO_Subtract:
            GameInstance.ElapsedTime += Seconds;
            GameInstance.LastReinforcementTime[0] += Seconds;
            GameInstance.LastReinforcementTime[1] += Seconds;
            GameReplicationInfoInstance.ElapsedTime += Seconds; //comment
            break;
        //Set round time to X seconds.
        case RTO_Set:
            ElapsedTimeDelta = (GameReplicationInfoInstance.RoundDuration + GameReplicationInfoInstance.RoundStartTime - Seconds) - GameInstance.ElapsedTime;
            GameInstance.ElapsedTime += ElapsedTimeDelta;
            GameInstance.LastReinforcementTime[0] += ElapsedTimeDelta;
            GameInstance.LastReinforcementTime[1] += ElapsedTimeDelta;
            GameReplicationInfoInstance.ElapsedTime += ElapsedTimeDelta; //comment
            break;
        default:
            break;
    }

    //If we want to broadcast the round time modification.
    if (bShowMessage)
        Level.Game.BroadcastLocalizedMessage(class'DH_ModifyRoundTimeMessage', 0, none, none, self);
}

defaultproperties
{
     Seconds=60
     bShowMessage=true
     bPlaySound=true
     Sound=Sound'Miscsounds.Music.notify_drum'
     Texture=Texture'Engine.S_Trigger'
}
