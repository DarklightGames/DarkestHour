//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetrics extends Actor;

var private Hashtable_string_Object Players;
var private array<DHMetricsFrag>    Frags;
var private array<DHMetricsCapture> Captures;
var private DateTime                RoundStartTime;
var private DateTime                RoundEndTime;

function PostBeginPlay()
{
    super.PostBeginPlay();

    Players = class'Hashtable_string_Object'.static.Create(128);
}

function string Dump()
{
    local Object Object;
    local HashtableIterator_string_Object PlayersIterator;
    local JSONObject Root;
    local array<DHMetricsPlayer> PlayersArray;
    local FileLog F;

    PlayersIterator = Players.CreateIterator();

    // Players
    while (PlayersIterator.Next(, Object))
    {
        PlayersArray[PlayersArray.Length] = DHMetricsPlayer(Object);
    }

    // Frags
    Root = (new class'JSONObject')
        .Put("server", (new class'JSONObject')
            .PutString("name", Level.Game.GameReplicationInfo.ServerName))
        .PutString("map", class'DHLib'.static.GetMapName(Level))
        .PutString("round_start", RoundStartTime.IsoFormat())
        .PutString("round_end", RoundEndTime.IsoFormat())
        .Put("players", class'JSONArray'.static.FromSerializables(PlayersArray))
        .Put("frags", class'JSONArray'.static.FromSerializables(Frags))
        .Put("captures", class'JSONArray'.static.FromSerializables(Captures));

    StopWatch(false);

    F = Spawn(class'FileLog');
    F.OpenLog(class'DateTime'.static.Now(self).IsoFormat(), "log");
    class'UFileLog'.static.Logf(F, Root.Encode());
    F.CloseLog();
    F.Destroy();

    StopWatch(true);

    return Root.Encode();
}

function OnRoundBegin()
{
    RoundStartTime = class'DateTime'.static.Now(self);

    Frags.Length = 0;
}

function OnRoundEnd(int WinnerTeamIndex)
{
    RoundEndTime = class'DateTime'.static.Now(self);

    Dump();
}

function OnPlayerLogin(PlayerController PC)
{
    local Object O;
    local DHMetricsPlayer P;

    if (!Players.Get(PC.GetPlayerIDHash(), O))
    {
        P = new class'DHMetricsPlayer';
        P.ID = PC.GetPlayerIDHash();
        P.NetworkAddress = PC.GetPlayerNetworkAddress();
        Players.Put(P.ID, P);
    }
    else
    {
        P = DHMetricsPlayer(O);

        if (P == none)
        {
            return;
        }
    }

    OnPlayerChangeName(PC);
}

function OnPlayerChangeName(PlayerController PC)
{
    local int i;
    local Object O;
    local DHMetricsPlayer P;
    local bool bNameExists;

    if (PC == none || !Players.Get(PC.GetPlayerIDHash(), O))
    {
        return;
    }

    P = DHMetricsPlayer(O);

    if (P == none)
    {
        return;
    }

    for (i = 0; i < P.Names.Length; ++i)
    {
        if (P.Names[i] == PC.PlayerReplicationInfo.PlayerName)
        {
            bNameExists = true;
        }
    }

    if (!bNameExists)
    {
        P.Names[P.Names.Length] = PC.PlayerReplicationInfo.PlayerName;
    }
}

function OnPlayerFragged(PlayerController Killer, PlayerController Victim, class<DamageType> DamageType, vector HitLocation, int HitIndex, int RoundTime)
{
    local DHMetricsFrag F;
    local vector KillerLocation;

    if (Killer == none || Victim == none || DamageType == none)
    {
        return;
    }

    if (Killer.Pawn != none)
    {
        KillerLocation = Killer.Pawn.Location;
    }

    F = new class'DHMetricsFrag';
    F.KillerID = Killer.GetPlayerIDHash();
    F.VictimID = Victim.GetPlayerIDHash();
    F.KillerLocation = KillerLocation;
    F.DamageType = DamageType;
    F.VictimLocation = HitLocation;
    F.HitIndex  = HitIndex;
    F.RoundTime = RoundTime;

    Frags[Frags.Length] = F;
}

function OnObjectiveCaptured(int ObjectiveIndex, int TeamIndex, int RoundTime, array<string> PlayerIDs)
{
    local DHMetricsCapture C;

    C = new class'DHMetricsCapture';
    C.ObjectiveIndex = ObjectiveIndex;
    C.TeamIndex = TeamIndex;
    C.PlayerIDs = PlayerIDs;
    C.RoundTime = RoundTime;

    Captures[Captures.Length] = C;
}

