//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyReinforcements extends DH_ModifyActors;

var()   bool            bModifyIfDepleted;
var()   ROSideIndex     TeamToModify; //Neutral will modify both teams
var()   bool            UseRandomness;
var()   int             RandomPercent; // 100 for always succeed, 0 for always fail
var()   int             ModifyNum;
var()   NumModifyType   HowToModify;
var()   bool            bUseTeamMessage; //Default = true
var() localized string  Message; //Message to send to team when door is opened
var()   name            MessageType; //Say,TeamSay,SayDead,TeamSayDead,VehicleSay,CriticalEvent,DeathMessage,
var()   sound           sound; //sound to play when door is opened

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;
    local ROSideIndex ActualSideToModify;
    local DHGameReplicationInfo DHGRI;
    local DarkestHourGame DHGame;
    local Controller        C;
    local PlayerController  P;

    if (UseRandomness)
    {
        RandomNum = Rand(100);  //Gets a random # between 0 & 99
        if (RandomPercent < RandomNum)
            return; //Leave script randomly failed
    }
    //Setup reference to the GameType
    DHGame = DarkestHourGame(Level.Game);
    DHGRI = DHGameReplicationInfo(DHGame.GameReplicationInfo);

    //Because we might be changing which side to modify based on bModifyIfDepleted and if a team is out of reinforcements or not
    //We want to have another local variable so we can change the TeamToModify based on the checks
    ActualSideToModify = TeamToModify;

    if (!bModifyIfDepleted)
    {
        switch (ActualSideToModify)
        {
            case AXIS:
                if (DHGRI.SpawnsRemaining[AXIS_TEAM_INDEX] <= 0)
                {
                    return;
                }
            break;
            case ALLIES:
                if (DHGRI.SpawnsRemaining[ALLIES_TEAM_INDEX] <= 0)
                {
                    return;
                }
            break;
            case NEUTRAL:
                if (DHGRI.SpawnsRemaining[AXIS_TEAM_INDEX] <= 0)
                {
                    ActualSideToModify = ALLIES;
                }

                if (DHGRI.SpawnsRemaining[ALLIES_TEAM_INDEX] <= 0)
                {
                    ActualSideToModify = AXIS;
                }
            break;
        }
    }

    //Notify the players that they were reinforced
    if (bUseTeamMessage)
    {
        if (ActualSideToModify == NEUTRAL)
        {
            Level.Game.Broadcast(self, Message, MessageType);
        }
        else
        {
            for (C = Level.ControllerList; C != none; C = C.NextController)
            {
                P = PlayerController(C);
                if (P != none && P.GetTeamNum() == ActualSideToModify)
                {
                    P.TeamMessage(C.PlayerReplicationInfo, Message, MessageType);
                    p.PlayAnnouncement(sound, 1, true);
                }
            }
        }
    }

    switch (HowToModify)
    {
        case NMT_Add:
            if (ActualSideToModify == NEUTRAL)
            {
                DHGame.ModifyReinforcements(AXIS_TEAM_INDEX, ModifyNum);
                DHGame.ModifyReinforcements(ALLIES_TEAM_INDEX, ModifyNum);
            }
            else
            {
                DHGame.ModifyReinforcements(ActualSideToModify, ModifyNum);
            }
        break;
        case NMT_Subtract:
            if (ActualSideToModify == NEUTRAL)
            {
                DHGame.ModifyReinforcements(AXIS_TEAM_INDEX, -ModifyNum);
                DHGame.ModifyReinforcements(ALLIES_TEAM_INDEX, -ModifyNum);
            }
            else
            {
                DHGame.ModifyReinforcements(ActualSideToModify, -ModifyNum);
            }
        break;
        case NMT_Set:
            if (ActualSideToModify == NEUTRAL)
            {
                DHGame.ModifyReinforcements(AXIS_TEAM_INDEX, ModifyNum, true);
                DHGame.ModifyReinforcements(ALLIES_TEAM_INDEX, ModifyNum, true);
            }
            else
            {
                DHGame.ModifyReinforcements(ActualSideToModify, ModifyNum, true);
            }
        break;
        default:
        break;
    }
}

defaultproperties
{
    bModifyIfDepleted=true
    bUseTeamMessage=true
    messagetype="CriticalEvent"
    Sound=Sound'Miscsounds.Music.notify_drum'
}
