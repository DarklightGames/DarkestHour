//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMetrics extends Actor;

var private TreeMap_string_Object   Players;
var private array<DHMetricsFrag>    Frags;

function PostBeginPlay()
{
    super.PostBeginPlay();

    Players = new class'TreeMap_string_Object';
}

function string Dump()
{
    local int i, j;
    local array<string> Keys;
    local Object O;
    local DHMetricsPlayer P;
    local JSONObject Root;
    local JSONObject PlayersObject;
    local JSONArray NamesArray;
    local JSONObject PlayerObject;
    local JSONObject ServerObject;
    local JSONArray FragsArray;

    Root = new class'JSONObject';

    // Server
    ServerObject = new class'JSONObject';

    ServerObject.Put("name", class'JSONString'.static.Create(Level.Game.GameReplicationInfo.ServerName));

    Root.Put("server", ServerObject);

    // Players
    PlayersObject = new class'JSONObject';

    Keys = Players.GetKeys();

    for (i = 0; i < Keys.Length; ++i)
    {
        PlayerObject = new class'JSONObject';
        NamesArray = new class'JSONArray';

        Players.Get(Keys[i], O);

        P = DHMetricsPlayer(O);

        if (P == none)
        {
            continue;
        }

        for (j = 0; j < P.Names.Length; ++j)
        {
            NamesArray.Add(class'JSONString'.static.Create(P.Names[j]));
        }

        PlayerObject.Put("names", NamesArray);
        PlayerObject.Put("ip", class'JSONString'.static.Create(P.NetworkAddress));

        PlayersObject.Put(Keys[i], PlayerObject);
    }

    Root.Put("players", PlayersObject);

    // Frags
    FragsArray = new class'JSONArray';

    for (i = 0; i < Frags.Length; ++i)
    {
        if (Frags[i] != none)
        {
            FragsArray.Add(Frags[i].EncodeJSON());
        }
    }

    Root.Put("frags", FragsArray);

    return Root.Encode();
}

function OnPlayerLogin(PlayerController PC)
{
    local Object O;
    local DHMetricsPlayer P;

    Level.Game.Broadcast(self, "OnPlayerLogin" @ PC);

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

function OnPlayerFragged(PlayerController Killer, PlayerController Victim, class<DamageType> DamageType, vector HitLocation, int HitIndex)
{
    local DHMetricsFrag F;

    F = new class'DHMetricsFrag';

    F.KillerID = Killer.GetPlayerIDHash();
    F.VictimID = Victim.GetPlayerIDHash();
    F.DamageType = DamageType;
    F.VictimLocation = HitLocation;
    F.HitIndex  = HitIndex;

    Frags[Frags.Length] = F;
}

