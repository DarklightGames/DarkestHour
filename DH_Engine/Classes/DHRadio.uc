//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHRadio extends Actor;

var int                 TeamIndex;
var float               ResponseDelaySeconds;
var float               UsageDistanceMaximumMeters;

var float               ResponseSoundVolume;
var float               ResponseSoundRadius;

// Map icon
var bool                bShouldShowOnSituationMap;
var Material            MapIconMaterial;

var DHArtilleryRequest  Request;

// A reference to the pawn that carries this radio (used for scoring).
var DHPawn              Carrier;

// Used to signal to the client that the radio cannot be used.
var protected bool      bIsBusy;

var class<LocalMessage> ArtilleryMessageClass;

enum ERadioUsageError
{
    ERROR_None,
    ERROR_NotOwned,
    ERROR_NotQualified,
    ERROR_NoTarget,
    ERROR_Busy,
    ERROR_TooFarAway,
    ERROR_Fatal
};

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, bIsBusy, bShouldShowOnSituationMap, Carrier;
}

function PostBeginPlay()
{
    local DHGameReplicationInfo GRI;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (GRI != none)
        {
            GRI.AddRadio(self);
        }
    }
}

function Reset()
{
    super.Reset();

    Request = none;

    if (Carrier != none)
    {
        Destroy();
    }
}

simulated function bool IsBusy()
{
    return bIsBusy;
}

state Busy
{
    function BeginState()
    {
        if (Role == ROLE_Authority)
        {
            bIsBusy = true;
        }
    }
}

simulated function ERadioUsageError GetRadioUsageError(Pawn User)
{
    local DHPawn P;
    local DHRoleInfo RI;
    local DHPlayerReplicationInfo PRI;
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;

    P = DHPawn(User);

    if (P == none || P.Health <= 0 || Carrier == P)
    {
        return ERROR_Fatal;
    }

    RI = P.GetRoleInfo();
    PRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    PC = DHPlayer(P.Controller);

    if (RI == none || PRI == none || PC == none)
    {
        return ERROR_Fatal;
    }

    if (TeamIndex != NEUTRAL_TEAM_INDEX && TeamIndex != PC.GetTeamNum())
    {
        return ERROR_NotOwned;
    }

    if (!IsPlayerQualified(PC))
    {
        return ERROR_NotQualified;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    // SavedArtilleryCoords is saved in DHCommandMenu_FireSupport.OnSelect()
    if (PC.SavedArtilleryCoords == vect(0, 0, 0) && PC.GetActiveOffMapSupportNumber() == 0)
    {
        return ERROR_NoTarget;
    }

    if (bIsBusy || (GRI != none && GRI.bIsInSetupPhase))
    {
        return ERROR_Busy;
    }

    if (VSize(P.Location - Location) > class'DHUnits'.static.MetersToUnreal(UsageDistanceMaximumMeters))
    {
        return ERROR_TooFarAway;
    }

    return ERROR_None;
}

simulated function bool IsPlayerQualified(DHPlayer PC)
{
    return PC != none && PC.IsSquadLeader();
}

function RequestArtillery(Pawn Sender, int ArtilleryTypeIndex)
{
    local DHPlayer PC;

    PC = DHPlayer(Sender.Controller);

    if (PC == none || GetRadioUsageError(Sender) != ERROR_None)
    {
        return;
    }

    Request = new class'DHArtilleryRequest';
    Request.TeamIndex = PC.GetTeamNum();
    Request.Sender = PC;
    Request.ArtilleryTypeIndex = ArtilleryTypeIndex;
    Request.Location = PC.SavedArtilleryCoords;

    GotoState('Requesting');
}

simulated function Destroyed()
{
    super.Destroyed();

    if (Request != none)
    {
        Request.Sender = none;
    }
}

auto state Idle
{
    function BeginState()
    {
        if (Role == ROLE_Authority)
        {
            bIsBusy = false;
        }
    }
}

state Requesting extends Busy
{
    function BeginState()
    {
        local DH_LevelInfo LI;
        local Sound RequestSound;

        super.BeginState();

        LI = class'DH_LevelInfo'.static.GetInstance(Level);

        if (LI == none)
        {
            return;
        }

        if (Request == none ||
            Request.Sender == none ||
            Request.ArtilleryTypeIndex < 0 ||
            Request.ArtilleryTypeIndex >= LI.ArtilleryTypes.Length ||
            LI.ArtilleryTypes[Request.ArtilleryTypeIndex].ArtilleryClass == none ||
            LI.ArtilleryTypes[Request.ArtilleryTypeIndex].TeamIndex != Request.Sender.GetTeamNum())
        {
            return;
        }

        // "Requesting {name}."
        Request.Sender.ReceiveLocalizedMessage(class'DHArtilleryMessage', 0,,, Request.GetArtilleryClass());

        // Play request sound.
        RequestSound = GetRequestSound(Request.TeamIndex, LI);

        if (Request.Sender.Pawn != none)
        {
            Request.Sender.Pawn.PlaySound(RequestSound, SLOT_None, 3.0, false, 100.0, 1.0, true);  // TODO: magic numbers
        }

        // Wait for duration of request sound plus delay, then move to Responding state.
        SetTimer(GetSoundDuration(RequestSound) + ResponseDelaySeconds, false);
    }

    function Timer()
    {
        GotoState('Responding');
    }
}

state Responding extends Busy
{
    function BeginState()
    {
        local SoundGroup ResponseSound;
        local DarkestHourGame.ArtilleryResponse Response;
        local DH_LevelInfo LI;
        local DHGameReplicationInfo GRI;
        local vector MapLocation;

        super.BeginState();

        LI = class'DH_LevelInfo'.static.GetInstance(Level);

        if (LI == none)
        {
            return;
        }

        // Make the artillery request.
        Response = DarkestHourGame(Level.Game).RequestArtillery(Request);

        // Determine the response sound from the response type.
        if (Response.Type == RESPONSE_OK)
        {
            GRI = DHGameReplicationInfo(Request.Sender.GameReplicationInfo);
            GRI.GetMapCoords(Request.Location, MapLocation.X, MapLocation.Y);

            // "Artillery strike confirmed."
            Request.Sender.ReceiveLocalizedMessage(class'DHArtilleryMessage', 1,,, Request.GetArtilleryClass());
            ResponseSound = GetConfirmSound(Request.TeamIndex, LI);
        }
        else
        {
            // Request was denied, send the user a message indicating the reason.
            switch (Response.Type)
            {
                case RESPONSE_Unavailable:
                    // "{name} unavailable at this time."
                    Request.Sender.ReceiveLocalizedMessage(ArtilleryMessageClass, 5,,, Request.GetArtilleryClass());
                    break;
                case RESPONSE_Exhausted:
                    // "{name}s have been exhausted."
                    Request.Sender.ReceiveLocalizedMessage(ArtilleryMessageClass, 4,,, Request.GetArtilleryClass());
                    break;
                case RESPONSE_BadLocation:
                    // "Invalid target location for {name}."
                    Request.Sender.ReceiveLocalizedMessage(ArtilleryMessageClass, 6,,, Request.GetArtilleryClass());
                    break;
                case RESPONSE_NoTarget:
                    // "No target location."
                    Request.Sender.ReceiveLocalizedMessage(ArtilleryMessageClass, 9,,, Request.GetArtilleryClass());
                    break;
                case RESPONSE_TooSoon:
                    // "{name}s are currently in use, try again soon."
                    Request.Sender.ReceiveLocalizedMessage(ArtilleryMessageClass, 3,,, Request.GetArtilleryClass());
                    break;
                case RESPONSE_NotQualified:
                    Request.Sender.ReceiveLocalizedMessage(ArtilleryMessageClass, 7,,, Request.GetArtilleryClass());
                    break;
                default:
                    // "{name} denied."
                    Request.Sender.ReceiveLocalizedMessage(ArtilleryMessageClass, 2,,, Request.GetArtilleryClass());
                    break;
            }

            ResponseSound = GetDenySound(Request.TeamIndex, LI);
        }

        // Play the response sound.
        PlaySound(ResponseSound, SLOT_None, ResponseSoundVolume, false, ResponseSoundRadius,, true);

        // Wait for the duration of the response sound, then move to the Idle state.
        SetTimer(FMax(1.0, GetSoundDuration(ResponseSound)), false);

        // Free request object.
        Request = None;
    }

    function Timer()
    {
        GotoState('Idle');
    }
}

simulated function NotifySelected(Pawn User)
{
    local ERadioUsageError Error;

    Error = GetRadioUsageError(User);

    switch (Error)
    {
        case ERROR_None:
            // "Press [%USE%] to request artillery"
            User.ReceiveLocalizedMessage(class'DHRadioTouchMessage', 0,,, User.Controller);
            break;
        case ERROR_NotQualified:
            // "You are not qualified to use this radio"
            User.ReceiveLocalizedMessage(class'DHRadioTouchMessage', 1);
            break;
        case ERROR_NoTarget:
            // "No artillery target marked"
            User.ReceiveLocalizedMessage(class'DHRadioTouchMessage', 2);
            break;
        case ERROR_NotOwned:
            // "You cannot use enemy radios"
            User.ReceiveLocalizedMessage(class'DHRadioTouchMessage', 3);
            break;
        case ERROR_Busy:
            // "Radio is currently in use"
            User.ReceiveLocalizedMessage(class'DHRadioTouchMessage', 4);
            break;
        case ERROR_Fatal:
            // For debugging purposes only!
            User.ReceiveLocalizedMessage(class'DHRadioTouchMessage', 5);
            break;
        default:
            break;
    }
}

// TODO: The way that RO and DH have traditionally handled "teams" is terrible
// and results in nonsense like this needing to be coded up.
function class<DHVoicePack> GetVoicePack(int TeamIndex, DH_LevelInfo LI)
{
    return LI.GetTeamNationClass(TeamIndex).default.VoicePackClass;
}

function SoundGroup GetRequestSound(int TeamIndex, DH_LevelInfo LI)
{
    return GetVoicePack(TeamIndex, LI).default.RadioRequestSound;
}

function SoundGroup GetConfirmSound(int TeamIndex, DH_LevelInfo LI)
{
    return GetVoicePack(TeamIndex, LI).default.RadioResponseConfirmSound;
}

function SoundGroup GetDenySound(int TeamIndex, DH_LevelInfo LI)
{
    return GetVoicePack(TeamIndex, LI).default.RadioResponseDenySound;
}

defaultproperties
{
    bCanAutoTraceSelect=true
    bAutoTraceNotify=true
    bCollideActors=true
    bCollideWorld=false
    bUseCylinderCollision=true
    bIgnoreEncroachers=true
    bIgnoreVehicles=true
    bHidden=false

    Physics=PHYS_None
    DrawType=DT_None
    DrawScale=1.0
    CollisionRadius=32.0
    CollisionHeight=32.0

    TeamIndex=2 // NEUTRAL_TEAM_INDEX
    bAlwaysRelevant=true
    RemoteRole=ROLE_DumbProxy
    ResponseDelaySeconds=2.0
    AmbientSound=Sound'DH_SundrySounds.Radio.RadioStatic'

    ResponseSoundRadius=100.0
    ResponseSoundVolume=3.0

    ArtilleryMessageClass=class'DHArtilleryMessage'

    UsageDistanceMaximumMeters=2.0

    MapIconMaterial=none    // TODO: fill this in
    bShouldShowOnSituationMap=true
}
