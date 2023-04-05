//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AdvTimer extends DH_LevelActors;

var() localized string  Message;     // message to send to a team when interval is reached
var() localized string  EndMessage;  // message to send to team when end is reached
var()   name            MessageType; // Say, TeamSay, SayDead, TeamSayDead, VehicleSay, CriticalEvent, DeathMessage
var()   ROSideIndex     MessageTeam, EndMessageTeam;
var()   int             TimeMin, TimeMax, MessageIntervalTime;
var     int             TimeElapsed, TimeActual;
var()   bool            bAutoStart, bRepeatTimer, bUseMessage, bUseEndMessage, bFireOnce;
var     bool            bFired;
var()   name            nEventToTrigger;

function Reset()
{
    GotoState('Initialize'); //cancels the Timing Timer (allowing for resetgame)
    bFired = false;
    TimeElapsed = 0;
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    if (!IsInState('Timing'))
    {
        GotoState('Timing'); // Not Timing? Then start
    }
    else
    {
        GotoState('Initialize'); // Timing? Then let's stop & only restart if bAutoStart is true
    }
}

auto state Initialize
{
    function BeginState()
    {
        if (bAutoStart)
        {
            GotoState('Timing');
        }
    }
}

state Timing
{
    function BeginState()
    {
        TimeActual = RandRange(TimeMin, TimeMax);
        TimeElapsed = 0;

        if (!bFireOnce || (bFireOnce && !bFired))
        {
            bFired = true;
            SetTimer(1.0, true);
        }
    }

    function Timer()
    {
        local PlayerController PC;
        local Controller        C;
        local int               r, TimerLeft, MinutesLeft;
        local string            SecondsLeft;

        TimeElapsed++; //Increment time elapsed by 1

        //Timer is over lets do the work
        if (TimeElapsed >= TimeActual)
        {
            TriggerEvent(nEventToTrigger, self, none); //Triggers the event

            if (bUseEndMessage)
            {
                if (EndMessageTeam == NEUTRAL)
                {
                    Level.Game.Broadcast(self, EndMessage, MessageType);
                }
                else
                {
                    for (C = Level.ControllerList; C != none; C = C.NextController)
                    {
                        PC = PlayerController(C);

                        if (PC != none && PC.GetTeamNum() == EndMessageTeam)
                            PC.TeamMessage(C.PlayerReplicationInfo, EndMessage, MessageType);
                    }
                }
            }

            if (bRepeatTimer && !bFireOnce)
            {
                TimeActual = RandRange(TimeMin, TimeMax);
                TimeElapsed = 0;
                SetTimer(1.0, true); // recalls timer if repeat is true
            }
            else
            {
                GotoState('Done'); //Leave timer as we don't want to repeat & timer is up
            }
        }
        else
        {
            if (bUseMessage && (TimeElapsed % MessageIntervalTime == 0)) //If use interval message and is it time to show it?
            {
                TimerLeft = TimeActual - TimeElapsed;

                MinutesLeft = TimerLeft / 60;
                r = TimerLeft - (MinutesLeft * 60);

                if (r < 10)
                    SecondsLeft = "0" $ string(r);
                else
                    SecondsLeft = string(r);

                if (MessageTeam == NEUTRAL)
                {
                    Level.Game.Broadcast(self, MinutesLeft $ ":" $ SecondsLeft @ Message, MessageType);
                }
                else
                {
                    for (C = Level.ControllerList; C != none; C = C.NextController)
                    {
                        PC = PlayerController(C);

                        if (PC != none && PC.GetTeamNum() == MessageTeam)
                            PC.TeamMessage(C.PlayerReplicationInfo, MinutesLeft $ ":" $ SecondsLeft @ Message, MessageType);
                    }
                }
            }
        }
    }
}

state Done
{
}

defaultproperties
{
    Texture=Texture'DHEngine_Tex.ClockTimer'
    messagetype="CriticalEvent"
    TimeMin=30
    TimeMax=30
    MessageIntervalTime=15
}
