//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ModifyReinforcements extends DH_ModifyActors;

var()   bool            bRespawnPlayersRandomly;
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
    local int RandomNum, ReinforceNum;
    local ROTeamGame ROTeamGameRep;
    local Controller        C;
    local PlayerController  P;

    if (UseRandomness)
    {
        RandomNum = Rand(101);  //Gets a random # between 0 & 100
        if (RandomPercent <= RandomNum)
            return; //Leave script randomly failed
    }
    //Setup reference to the GameType
    ROTeamGameRep = ROTeamGame(Level.Game);

    //Add check if spawncount is greater than spawnlimit
    //We do this because the game will spawn an entire team initially in the round and can go above spawnlimit
    if (ROTeamGameRep.SpawnCount[AXIS_TEAM_INDEX] >= ROTeamGameRep.LevelInfo.Axis.SpawnLimit)
    {
        if (!bModifyIfDepleted)
            return; //return since reinforcements have been depleted

        ROTeamGameRep.SpawnCount[AXIS_TEAM_INDEX] = ROTeamGameRep.LevelInfo.Axis.SpawnLimit;
    }

    if (ROTeamGameRep.SpawnCount[ALLIES_TEAM_INDEX] >= ROTeamGameRep.LevelInfo.Allies.SpawnLimit)
    {
        if (!bModifyIfDepleted)
            return; //return since reinforcements have been depleted

        ROTeamGameRep.SpawnCount[ALLIES_TEAM_INDEX] = ROTeamGameRep.LevelInfo.Allies.SpawnLimit;
    }

    //Notify the players that they were reinforced
    if (bUseTeamMessage)
    {
        if (TeamToModify == NEUTRAL)
        {
            Level.Game.Broadcast(self, Message, MessageType);
        }
        else
        {
            for (C = Level.ControllerList; C != none; C = C.NextController)
            {
                P = PlayerController(C);
                if (P != none && P.GetTeamNum() == TeamToModify)
                {
                    P.TeamMessage(C.PlayerReplicationInfo, Message, MessageType);
                    p.PlayAnnouncement(sound, 1, true);
                }
            }
        }
    }

    ReinforceNum = ModifyNum;
    //Start adding the reinforcements
    if (bRespawnPlayersRandomly)
    {
        ReinforceNum = AddRespawnsRandomly(); //Try to respawn the PCs randomly, returns # if not enough dead to respawn
        if (ReinforceNum <= 0) //if no need to add reinforcements to the pool we can leave function
            return;
            //SendReinforcementMessage(i, 1);
    }

    switch (HowToModify)
    {
        case NMT_Add: //Because SpawnCount goes up, to add reinforcements you must subtract from SpawnCount
            if (TeamToModify == NEUTRAL){
                ROTeamGameRep.SpawnCount[AXIS_TEAM_INDEX] -= ReinforceNum;
                ROTeamGameRep.SpawnCount[ALLIES_TEAM_INDEX] -= ReinforceNum;
            }
            else
                ROTeamGameRep.SpawnCount[TeamToModify] -= ReinforceNum;
        break;
        case NMT_Subtract:
            if (TeamToModify == NEUTRAL){
                ROTeamGameRep.SpawnCount[AXIS_TEAM_INDEX] += ReinforceNum;
                ROTeamGameRep.SpawnCount[ALLIES_TEAM_INDEX] += ReinforceNum;
            }
            else
                ROTeamGameRep.SpawnCount[TeamToModify] += ReinforceNum;
        break;
        case NMT_Set:
            if (TeamToModify == AXIS){
                ROTeamGameRep.SpawnCount[AXIS_TEAM_INDEX] = ROTeamGameRep.LevelInfo.Axis.SpawnLimit - ReinforceNum;
            }
            else if (TeamToModify == Allies){
                ROTeamGameRep.SpawnCount[ALLIES_TEAM_INDEX] = ROTeamGameRep.LevelInfo.Allies.SpawnLimit - ReinforceNum;
            }
            else
            {
                ROTeamGameRep.SpawnCount[AXIS_TEAM_INDEX] = ROTeamGameRep.LevelInfo.Axis.SpawnLimit - ReinforceNum;
                ROTeamGameRep.SpawnCount[ALLIES_TEAM_INDEX] = ROTeamGameRep.LevelInfo.Allies.SpawnLimit - ReinforceNum;
            }
        break;
        default:
        break;
    }
}

function int AddRespawnsRandomly()
{
    local   int                         i, RandomNum;
    local   array<Controller>           lDeadPCList;
    local   Controller                  C;
    local   ROTeamGame                  ROGame;

    //Construct the local Dead PC list
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (!C.bIsPlayer || C.Pawn != none || C.PlayerReplicationInfo == none || C.PlayerReplicationInfo.Team == none || C.PlayerReplicationInfo.Team.TeamIndex != TeamToModify)
            continue;

        if (ROPlayer(C) != none && ROPlayer(C).CanRestartPlayer())
            lDeadPCList.Insert(0, 1); //Adds a new spot at index for the lDeadPCList
            lDeadPCList[0] = C; //Sets the Player Controller in the lDeadPCList
            //RestartPlayer(P);
    }

    ROGame = ROTeamGame(Level.Game);

    //Go through the local proper PC dead list and respawn them
    for (i = 0; i < lDeadPCList.Length; ++i)
    {
        RandomNum = rand(lDeadPCList.Length);
        ROGame.RestartPlayer(lDeadPCList[randomnum]);
        lDeadPCList.Remove(randomnum, 1);

        if (i >= ModifyNum)
            return 0;
    }
    return ModifyNum - i;
}

defaultproperties
{
    bModifyIfDepleted=true
    bUseTeamMessage=true
    messagetype="CriticalEvent"
    Sound=sound'Miscsounds.Music.notify_drum'
}
