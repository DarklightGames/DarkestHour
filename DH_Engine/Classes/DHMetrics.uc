//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMetrics extends Actor
    notplaceable;

var private Hashtable_string_Object         Players;
var private array<DHMetricsRound>           Rounds;
var private array<DHMetricsTextMessage>     TextMessages;

function PostBeginPlay()
{
    super.PostBeginPlay();

    Players = Class'Hashtable_string_Object'.static.Create(128);
}

// Called at the end to clean up all data (finalize sessions etc.)
function Finalize()
{
    local Object Object;
    local HashtableIterator_string_Object PlayersIterator;
    local DHMetricsPlayer MP;

    PlayersIterator = Players.CreateIterator();

    // Finalize sessions.
    while (PlayersIterator.Next(, Object))
    {
        MP = DHMetricsPlayer(Object);

        if (MP != none && MP.Sessions[0].EndedAt == none)
        {
            MP.Sessions[0].EndedAt = Class'DateTime'.static.Now(self);
        }
    }
}

function WriteToFile()
{
    local Object Object;
    local HashtableIterator_string_Object PlayersIterator;
    local JSONObject Root;
    local array<DHMetricsPlayer> PlayersArray;
    local FileLog F;
    local DHGameReplicationInfo GRI;

    Finalize();

    PlayersIterator = Players.CreateIterator();

    // Players
    while (PlayersIterator.Next(, Object))
    {
        PlayersArray[PlayersArray.Length] = DHMetricsPlayer(Object);
    }

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    // Rounds
    Root = (new Class'JSONObject')
        .Put("players", Class'JSONArray'.static.FromSerializables(PlayersArray))
        .Put("rounds", Class'JSONArray'.static.FromSerializables(Rounds))
        .Put("text_messages", Class'JSONArray'.static.FromSerializables(TextMessages))
        .PutString("version", Class'DHBuildManifest'.default.Version.ToString())
        .Put("server", (new Class'JSONObject')
            .PutString("name", Level.Game.GameReplicationInfo.ServerName))
        .Put("map", (new Class'JSONObject')
            .PutString("name", Class'DHLib'.static.GetMapName(Level))
            .PutInteger("offset", GRI.OverheadOffset)
            .Put("bounds", (new Class'JSONObject')
                .PutVector("ne", GRI.NorthEastBounds)
                .PutVector("sw", GRI.SouthWestBounds)));

    F = Spawn(Class'FileLog');
    F.OpenLog(Class'DateTime'.static.Now(self).IsoFormat(), "json");
    Class'UFileLog'.static.Logf(F, Root.Encode());
    F.CloseLog();
    F.Destroy();
}

function OnRoundBegin()
{
    local DHMetricsRound Round;

    Round = new Class'DHMetricsRound';
    Round.StartedAt = Class'DateTime'.static.Now(Level);
    Rounds.Insert(0, 1);
    Rounds[0] = Round;
}

function OnRoundEnd(int Winner)
{
    if (Rounds.Length == 0)
    {
        return;
    }

    Rounds[0].EndedAt = Class'DateTime'.static.Now(self);
    Rounds[0].Winner = Winner;

    // TODO: are all player sessions ended at the time we expect? do we need to
    // manually write session endings?
}

function OnPlayerClientGUIDReceived(PlayerController PC, GUID ClientGUID)
{
    local Object O;
    local DHMetricsPlayer P;

    Players.Get(PC.GetPlayerIDHash(), O);

    if (O == none)
    {
        return;
    }

    P = DHMetricsPlayer(O);

    Class'UArray'.static.SAddUnique(P.ClientGUIDs, Caps(Class'MD5Hash'.static.GetHashString(ClientGUID)));
}

function OnPlayerLogin(PlayerController PC)
{
    local Object O;
    local DHMetricsPlayer P;

    if (!Players.Get(PC.GetPlayerIDHash(), O))
    {
        P = new Class'DHMetricsPlayer';
        P.ID = PC.GetPlayerIDHash();

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

    // Finalize existing sessions if they were for some reason not finalized to begin with.
    if (P.Sessions.Length > 0 && P.Sessions[0].EndedAt == none)
    {
        P.Sessions[0].EndedAt = Class'DateTime'.static.Now(self);
    }

    // Add a new session to the front of the sessions list.
    P.Sessions.Insert(0, 1);
    P.Sessions[0] = new Class'DHMetricsPlayerSession';
    P.Sessions[0].StartedAt = Class'DateTime'.static.Now(self);
    P.Sessions[0].NetworkAddress = Class'INet4Address'.static.TrimPort(PC.GetPlayerNetworkAddress());
}

function OnPlayerLogout(DHPlayer PC)
{
    local Object O;
    local DHMetricsPlayer P;

    if (PC == none)
    {
        return;
    }

    // NOTE: We use ROIDHash because calling GetPlayerIDHash results in some sort of unusable UUID.
    Players.Get(PC.ROIDHash, O);
    P = DHMetricsPlayer(O);

    if (P != none)
    {
        // Mark the end of the player's current session.
        P.Sessions[0].EndedAt = Class'DateTime'.static.Now(self);
    }
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

function OnTextMessage(PlayerController PC, string Type, string Message)
{
    local DHMetricsTextMessage TextMessage;
    local DHPlayerReplicationInfo PRI;

    if (PC == none || Type == "None" || Message == "")
    {
        return;
    }

    TextMessage = new Class'DHMetricsTextMessage';
    TextMessage.Type = Type;
    TextMessage.Message = Message;
    TextMessage.ROID = PC.GetPlayerIDHash();
    TextMessage.SentAt = Class'DateTime'.static.Now(self);
    TextMessage.TeamIndex = PC.GetTeamNum();

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI != none)
    {
        TextMessage.SquadIndex = PRI.SquadIndex;
    }

    TextMessages[TextMessages.Length] = TextMessage;
}

function OnConstructionBuilt(DHConstruction Construction, int RoundTime)
{
    local DHMetricsConstruction C;

    if (Rounds.Length == 0 || Construction == none || Construction.InstigatorController == none)
    {
        return;
    }

    C = new Class'DHMetricsConstruction';
    C.TeamIndex = Construction.InstigatorController.GetTeamNum();
    C.ConstructionClass = Construction.Class;
    C.Location = Construction.Location;
    C.RoundTime = RoundTime;
    C.PlayerID = Construction.InstigatorController.GetPlayerIDHash();

    Rounds[0].Constructions[Rounds[0].Constructions.Length] = C;
}

function OnPlayerFragged(PlayerController Killer, PlayerController Victim, class<DamageType> DamageType, Vector HitLocation, int HitIndex, int RoundTime)
{
    local DHMetricsFrag F;
    local DHVehicle KillerVehicle, VictimVehicle;

    if (Killer == none || Victim == none || DamageType == none || Rounds.Length == 0)
    {
        return;
    }

    F = new Class'DHMetricsFrag';
    F.DamageType = DamageType;
    F.HitIndex  = HitIndex;
    F.RoundTime = RoundTime;

    // Killer
    F.KillerID = Killer.GetPlayerIDHash();
    F.KillerTeam = Killer.GetTeamNum();

    if (Killer.Pawn != none)
    {
        F.KillerLocation = Killer.Pawn.Location;
        F.KillerPawn = Killer.Pawn.Class;

        KillerVehicle = Class'DHVehicle'.static.GetDrivenVehicleBase(Killer.Pawn);

        if (KillerVehicle != none)
        {
            F.KillerVehicle = KillerVehicle.Class;
        }
    }

    // Victim
    F.VictimID = Victim.GetPlayerIDHash();
    F.VictimTeam = Victim.GetTeamNum();
    F.VictimLocation = HitLocation;

    if (Victim.Pawn != none)
    {
        F.VictimPawn = Victim.Pawn.Class;

        VictimVehicle = Class'DHVehicle'.static.GetDrivenVehicleBase(Victim.Pawn);

        if (VictimVehicle != none)
        {
            F.VictimVehicle = VictimVehicle.Class;
        }
    }

    Rounds[0].Frags[Rounds[0].Frags.Length] = F;
}

function OnVehicleFragged(PlayerController Killer, DHVehicle Vehicle, class<DamageType> DamageType, Vector HitLocation, int RoundTime)
{
    local DHMetricsVehicleFrag F;
    local DHVehicle KillerVehicle;

    if (Killer == none || Vehicle == none || DamageType == none || Rounds.Length == 0)
    {
        return;
    }

    F = new Class'DHMetricsVehicleFrag';
    F.DamageType = DamageType;
    F.RoundTime = RoundTime;

    // Killer
    F.KillerID = Killer.GetPlayerIDHash();
    F.KillerTeam = Killer.GetTeamNum();

    if (Killer.Pawn != none)
    {
        F.KillerLocation = Killer.Pawn.Location;
        F.KillerPawn = Killer.Pawn.Class;

        KillerVehicle = Class'DHVehicle'.static.GetDrivenVehicleBase(Killer.Pawn);

        if (KillerVehicle != none)
        {
            F.KillerVehicle = KillerVehicle.Class;
        }
    }

    // Destroyed vehicle
    F.Vehicle = Vehicle.Class;
    F.VehicleTeam = Vehicle.GetTeamNum();
    F.VehicleLocation = HitLocation;

    Rounds[0].VehicleFrags[Rounds[0].VehicleFrags.Length] = F;
}

function OnObjectiveCaptured(int ObjectiveIndex, int TeamIndex, int RoundTime, array<string> PlayerIDs)
{
    local DHMetricsCapture C;

    if (Rounds.Length == 0)
    {
        return;
    }

    C = new Class'DHMetricsCapture';
    C.ObjectiveIndex = ObjectiveIndex;
    C.TeamIndex = TeamIndex;
    C.PlayerIDs = PlayerIDs;
    C.RoundTime = RoundTime;

    Rounds[0].Captures[Rounds[0].Captures.Length] = C;
}

function OnRallyPointCreated(DHSpawnPoint_SquadRallyPoint RP)
{
    local DHMetricsRallyPoint MRP;

    if (Rounds.Length == 0)
    {
        return;
    }

    MRP = new Class'DHMetricsRallyPoint';
    MRP.TeamIndex = RP.GetTeamIndex();
    MRP.SquadIndex = RP.SquadIndex;
    MRP.PlayerID = RP.InstigatorController.ROIDHash;
    MRP.Location = RP.Location;
    MRP.CreatedAt = Class'DateTime'.static.Now(self);

    RP.MetricsObject = MRP;

    Rounds[0].RallyPoints[Rounds[0].RallyPoints.Length] = MRP;
}

// Adds a generic JSONObject event.
function AddEvent(string Type, JSONObject Data)
{
    if (Rounds.Length == 0 || Type == "" || Data == none)
    {
        return;
    }

    Rounds[0].Events[Rounds[0].Events.Length] = (new Class'JSONObject')
        .PutString("type", Type)
        .Put("data", Data);
}

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=true
}

