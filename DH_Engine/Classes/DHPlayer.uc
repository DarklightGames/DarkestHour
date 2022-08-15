//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHPlayer extends ROPlayer
    dependson(DHSquadReplicationInfo);

const MORTAR_TARGET_TIME_INTERVAL = 5;
const SPAWN_KILL_RESPAWN_TIME = 2;
const DEATH_PENALTY_FACTOR = 10;
const SQUAD_SIGNALS_MAX = 4;

enum EMapMode
{
    MODE_Map,
    MODE_Squads
};

enum ERoleEnabledResult
{
    RER_Fatal,
    RER_Enabled,
    RER_Limit,
    RER_SquadOnly,
    RER_SquadLeaderOnly,
    RER_NonSquadLeaderOnly,
};

var     array<class<DHMapMarker> >                              PersonalMapMarkerClasses;
var     private array<DHGameReplicationInfo.MapMarker>          PersonalMapMarkers;
var     Hashtable_string_int                                    MapMarkerCooldowns;

var     input float             aBaseFire;
var     bool                    bToggleRun;          // user activated toggle run
var     bool                    bIsGagged;           // player is gagged from chatting

var     EMapMode                DeployMenuStartMode; // what the deploy menu is supposed to start out on
var     DH_LevelInfo            ClientLevelInfo;
var     DHHintManager           DHHintManager;
var     DHConstructionManager   ConstructionManager; // client only!
var     float                   MapVoteTime;
var     globalconfig bool       bLockTankOnEntry;    // option to automatically lock an armored vehicle on entering, providing it contains no other tank crew
var     globalconfig bool       bSpawnWithBayonet;   // option to automatically spawn with a bayonet attached if applicable
var     globalconfig int        CorpseStayTime;      // determines how long corpses should stay around (default 30)
var     int                     CorpseStayTimeMin;
var     int                     CorpseStayTimeMax;
var     globalconfig string     ROIDHash;            // client ROID hash (this gets set/updated when a player joins a server)
var     globalconfig bool       bDynamicFogRatio;    // client option to have their fog distance dynamic based on FPS and MinDesiredFPS
var     globalconfig int        MinDesiredFPS;       // client option used to calculate fog ratio when dynamic fog ratio is true

var     byte                    ArtillerySupportSquadIndex;

// View FOV
var     globalconfig float      ConfigViewFOV;       // allows player to set their own preferred view FOV, within acceptable limits
var     float                   ViewFOVMin;
var     float                   ViewFOVMax;

// Sway
var     float                   DHSwayElasticFactor;
var     float                   DHSwayDampingFactor;

// Mouse sensitivity
var     float                   DHStandardTurnSpeedFactor;
var     float                   DHHalfTurnSpeedFactor;
var     globalconfig float      DHISTurnSpeedFactor;        // 0.0 to 1.0
var     globalconfig float      DHScopeTurnSpeedFactor;     // 0.0 to 1.0

// Player flinch
var     vector                  FlinchRotMag;
var     vector                  FlinchRotRate;
var     float                   FlinchRotTime;
var     vector                  FlinchOffsetMag;
var     vector                  FlinchOffsetRate;
var     float                   FlinchOffsetTime;
var     float                   FlinchMaxOffset;
var     float                   FlinchMeterSwayMultiplier;
var     float                   FlinchMeterValue;
var     float                   FlinchMeterIncrement;
var     float                   FlinchMeterFallOffStrength;
var     float                   LastFlinchTime;

// Mantling
var     float                   MantleCheckTimer;           // makes sure client doesn't try to start mantling without the server
var     float                   MantleFailTimer;            // makes sure we don't get stuck floating in an object unable to end a mantle
var     bool                    bDidMantle;                 // is the mantle complete?
var     bool                    bDidCrouchCheck;
var     bool                    bWaitingToMantle;
var     bool                    bLockJump;
var     bool                    bMantleDebug;
var     int                     MantleLoopCount;

// Spawning
var     int                     SpawnPointIndex;
var     int                     VehiclePoolIndex;
var     bool                    bIsInSpawnMenu;             // player is in spawn menu and should not be auto-spawned
var     bool                    bSpawnedKilled;             // player was spawn killed (set to false, when the spawn time is reduced)
var     int                     NextSpawnTime;              // the next time the player will be able to spawn
var     int                     LastKilledTime;             // the time at which last death occured
var     int                     NextVehicleSpawnTime;       // the time at which a player can spawn a vehicle next (this gets set when a player spawns a vehicle)
var     int                     DHPrimaryWeapon;            // Picking up RO's slack, this should have been replicated from the outset
var     int                     DHSecondaryWeapon;
var     bool                    bSpawnParametersInvalidated;
var     int                     NextChangeTeamTime;         // the time at which a player can change teams next
                                                            // it resets whenever an objective is taken
// Weapon locking (punishment for spawn killing)
var     int                     WeaponUnlockTime;           // the time at which the player's weapons will be unlocked (being the round's future ElapsedTime in whole seconds)
var     int                     PendingWeaponLockSeconds;   // fix for problem where player re-joins server with saved weapon lock, but client doesn't yet have GRI
var     int                     WeaponLockViolations;       // the number of violations this player has, used to increase the locked period for multiple offences

// Squads
var     DHSquadReplicationInfo  SquadReplicationInfo;
var     bool                    bIgnoreSquadInvitations;
var     bool                    bIgnoreSquadLeaderVolunteerPrompts;
var     bool                    bIgnoreSquadMergeRequestPrompts;
var     int                     SquadMemberLocations[12];   // SQUAD_SIZE_MAX
var     int                     SquadLeaderLocations[8];    // TEAM_SQUADS_MAX
var     float                   NextSquadMergeRequestTimeSeconds;  // The time (relative to TimeSeconds) that this player can send another squad merge request.

// Squad assistant volunteers
var         bool                           bIgnoreSquadLeaderAssistantVolunteerPrompts;
var private array<DHPlayerReplicationInfo> SquadAssistantVolunteers;

var     DHCommandInteraction    CommandInteraction;

var     Actor                   LookTarget;

// Log File
var     FileLog                 ClientLogFile;

var     bool                    bHasReceivedSquadJoinRecommendationMessage; // True when we have displayed the "you should probably join a squad" message.

var     DHMapDatabase           MapDatabase;

// Squad Things
struct SquadSignal
{
    var class<DHSquadSignal> SignalClass;
    var vector Location;
    var float TimeSeconds;
};

var     SquadSignal             SquadSignals[SQUAD_SIGNALS_MAX];

// Squad Leader HUD Info
var     DHSquadReplicationInfo.RallyPointPlacementResult    RallyPointPlacementResult;
var     int                                                 NextSquadRallyPointTime;
var     byte                                                SquadRallyPointCount;

// This is used to skip ResetInput calls in the GUIController.
// Useful when you want to show a menu over top of the game (e.g. situation map)
// without interrupting player input.
var     bool                    bShouldSkipResetInput;

// Toggle Duck timing
var     float                   ToggleDuckIntervalSeconds;
var     float                   NextToggleDuckTimeSeconds;

// Spectating stuff
var     bool                    bSpectateAllowViewPoints;

var     DHScoreManager          ScoreManager;

// "Lazy" camera controls
var     bool                    bLazyCam;
var     float                   LazyCamLaziness;
var     rotator                 LazyCamRotationTarget;

// Surrender
var     bool                    bSurrendered;

// Admin-initialed paradrops
var     class<DHMapMarker>      ParadropMarkerClass;
var     float                   ParadropHeight;
var     float                   ParadropSpreadModifier;

// Spotting
var     DHSpottingMarker        SpottingMarker;
var     DHIQManager             IQManager;
var     int                     MinIQToGrowHead;
var     bool                    bIQManaged;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        SpawnPointIndex, VehiclePoolIndex, bSpawnParametersInvalidated,
        NextSpawnTime, NextVehicleSpawnTime, NextChangeTeamTime, LastKilledTime,
        DHPrimaryWeapon, DHSecondaryWeapon, bSpectateAllowViewPoints,
        SquadReplicationInfo, SquadMemberLocations, bSpawnedKilled,
        SquadLeaderLocations, bIsGagged,
        NextSquadRallyPointTime, SquadRallyPointCount,
        bSurrendered, bIQManaged, ArtillerySupportSquadIndex;

    reliable if (bNetInitial && bNetOwner && bNetDirty && Role == ROLE_Authority)
        MinIQToGrowHead;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetPlayerInfo, ServerSetIsInSpawnMenu, ServerSetLockTankOnEntry,
        ServerLoadATAmmo, ServerThrowMortarAmmo, ServerSetBayonetAtSpawn,
        ServerClearObstacle, ServerCutConstruction,
        ServerAddMapMarker, ServerRemoveMapMarker,
        ServerSquadCreate, ServerSquadRename,
        ServerSquadJoin, ServerSquadJoinAuto, ServerSquadLeave,
        ServerSquadInvite, ServerSquadPromote, ServerSquadKick, ServerSquadBan,
        ServerSquadMakeAssistant, ServerSendVote,
        ServerSquadSay, ServerCommandSay, ServerSquadLock, ServerSquadSignal,
        ServerSquadSpawnRallyPoint, ServerSquadDestroyRallyPoint, ServerSquadSwapRallyPoints,
        ServerSetPatronTier, ServerSquadLeaderVolunteer, ServerForgiveLastFFKiller,
        ServerSendSquadMergeRequest, ServerAcceptSquadMergeRequest, ServerDenySquadMergeRequest,
        ServerSquadVolunteerToAssist,
        ServerPunishLastFFKiller, ServerRequestArtillery, ServerCancelArtillery, /*ServerVote,*/
        ServerDoLog, ServerLeaveBody, ServerPossessBody, ServerDebugObstacles, ServerLockWeapons, // these ones in debug mode only
        ServerTeamSurrenderRequest, ServerParadropPlayer, ServerParadropSquad, ServerParadropTeam,
        ServerNotifyRoles, ServerSaveArtilleryTarget, ServerSaveArtillerySupportSquadIndex;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientProne, ClientToggleDuck, ClientLockWeapons,
        ClientAddHudDeathMessage, ClientFadeFromBlack, ClientProposeMenu,
        ClientConsoleCommand, ClientCopyToClipboard, ClientSaveROIDHash,
        ClientSquadInvite, ClientSquadSignal, ClientSquadLeaderVolunteerPrompt,
        ClientTeamKillPrompt, ClientOpenLogFile, ClientLogToFile, ClientCloseLogFile,
        ClientSquadAssistantVolunteerPrompt,
        ClientReceiveSquadMergeRequest, ClientSendSquadMergeRequestResult,
        ClientTeamSurrenderResponse,
        ClientReceiveVotePrompt, ClientSetMapMarkerClassLock,
        ClientAddPersonalMapMarker;

    unreliable if (Role < ROLE_Authority)
        VehicleVoiceMessage;
}

function ServerChangePlayerInfo(byte newTeam, byte newRole, byte NewWeapon1, byte NewWeapon2) { } // no longer used

// Modified to use DH's InputClass instead of the RO version
// Class is enforced here because InputClass is a config variable & so can easily be changed in the player's .ini file
event InitInputSystem()
{
    InputClass = class'DH_Engine.DHPlayerInput';

    super(UnrealPlayer).InitInputSystem();
}

// Allows the server to tell the client to set a personal map marker
simulated function ClientAddPersonalMapMarker(class<DHMapMarker> MapMarkerClass, vector MarkerLocation)
{
    local DHGameReplicationInfo GRI;
    local vector MapLocation;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none)
    {
        GRI.GetMapCoords(MarkerLocation, MapLocation.X, MapLocation.Y);
        AddPersonalMarker(MapMarkerClass, MapLocation.X, MapLocation.Y, MarkerLocation);
    }
}

// Modified to have client setup access to DH_LevelInfo so it can get info from it
// Also to set the default view FOV from the player's own setting for ConfigViewFOV
simulated event PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        SetDefaultViewFOV(); // do this before calling the Super, then other FOV settings get matched to it when the super calls FixFOV()
    }

    super.PostBeginPlay();

    VoiceChatCodec = "CODEC_96WB";

    // Make this only run by the owning client
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Find DH_LevelInfo and assign it to ClientLevelInfo, so client can access it
        foreach AllActors(class'DH_LevelInfo', ClientLevelInfo)
        {
            break;
        }
    }

    // This forces the player to choose a valid spectator mode instead of
    // immediately defaulting to "self" which has no contextual relevance when
    // you are a brand new player.
    if (Role == ROLE_Authority)
    {
        ServerChangeSpecMode();
    }

    if (Role == ROLE_Authority)
    {
        ScoreManager = new class'DHScoreManager';

        if (DarkestHourGame(Level.Game) != none && DarkestHourGame(Level.Game).bBigBalloony)
        {
            IQManager = Spawn(class'DHIQManager', self);
        }
    }

    MapMarkerCooldowns = class'Hashtable_string_int'.static.Create(256);
}

simulated function InitializeMapDatabase()
{
    // Initialize the map database (for local player only!)
    if (MapDatabase == none && Level.GetLocalPlayerController() == self)
    {
        MapDatabase = new class'DHMapDatabase';
        MapDatabase.Initialize();
    }
}

simulated event PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    // Make this only run by the owning client
    if (Role < ROLE_Authority)
    {
        ServerSetBayonetAtSpawn(bSpawnWithBayonet);
        SetLockTankOnEntry(bLockTankOnEntry);
    }
}

// Client to server function which tells the server the user's setting (also gets called from DHTab_GameSettings, if the user changes the setting mid-game)
function ServerSetBayonetAtSpawn(bool bBayonetAtSpawn)
{
    bSpawnWithBayonet = bBayonetAtSpawn;
}

// New function to set the normal view FOV for this player, based on their own
// config setting ption to pass in new FOV value, otherwise we just use the
// existing ConfigViewFOV. We only accept valid values of 80 to 100, otherwise
// we reset to the default value (stops players manually editing their .ini file
// to invalid values) Note we only ever use the class default.ConfigViewFOV
// value, as that allows us to use it in static functions where there may not be
// a DHPlayer instance
simulated static function SetDefaultViewFOV(optional float NewFOV)
{
    if (NewFOV > 0.0 && NewFOV != default.ConfigViewFOV)
    {
        default.ConfigViewFOV = NewFOV;
        StaticSaveConfig();
    }

    if (default.ConfigViewFOV < default.ViewFOVMin || default.ConfigViewFOV > default.ViewFOVMax)
    {
        ResetConfig("ConfigViewFOV"); // in an invalid value, reset to the default
    }

    if (default.ConfigViewFOV != default.DefaultFOV)
    {
        default.DefaultFOV = default.ConfigViewFOV;
    }
}

// Added so that the DH_LevelInfo can be retrieved easily on both the server and
// client from a DHPlayer instance.
simulated function DH_LevelInfo GetLevelInfo()
{
    local DarkestHourGame G;

    if (Level.NetMode != NM_DedicatedServer)
    {
        return ClientLevelInfo;
    }
    else
    {
        G = DarkestHourGame(Level.Game);

        if (G != none)
        {
            return G.DHLevelInfo;
        }
    }

    return none;
}

// Modified to add hacky fix for problem where player re-joins a server with an active weapon lock saved in his DHPlayerSession
// When that happens the weapon lock is passed to the client, but it doesn't yet have a GRI reference so it all goes wrong
// In that situation we record a PendingWeaponLockSeconds on client, then here we use it to set the weapon lock on client as soon as it receives the GRI
simulated function PostNetReceive()
{
    if (PendingWeaponLockSeconds > 0 && GameReplicationInfo != none)
    {
        LockWeapons(PendingWeaponLockSeconds);
        PendingWeaponLockSeconds = 0;
    }

    super.PostNetReceive();
}

// Modified so we don't disable PostNetReceive() until we've received the GRI, which allows PendingWeaponLockSeconds functionality to work
simulated function bool NeedNetNotify()
{
    return super.NeedNetNotify() || GameReplicationInfo == none;
}

// Modified to avoid "accessed none" error
event ClientReset()
{
    local Actor A;

    // Reset special timed actors on the client
    foreach AllActors(class'Actor', A)
    {
        if (A.IsA('ClientSpecialTimedSound') || A.IsA('KrivoiPlaneController'))
        {
            A.Reset();
        }
    }

    // Reset camera stuff
    bBehindView = false;
    bFixedCamera = false;
    SetViewTarget(self);
    SetViewDistance();

    if (PlayerReplicationInfo != none && PlayerReplicationInfo.bOnlySpectator) // added PRI != none
    {
        GotoState('Spectating');
    }
    else
    {
        GotoState('PlayerWaiting');
    }
}

// Modified so being in a shallow water volume doesn't send player into swimming state
function EnterStartState()
{
    local name NewState;

    if (Pawn.PhysicsVolume != none && Pawn.PhysicsVolume.bWaterVolume && !(Pawn.PhysicsVolume.IsA('DHWaterVolume') && DHWaterVolume(Pawn.PhysicsVolume).bIsShallowWater))
    {
        NewState = Pawn.WaterMovementState;
    }
    else
    {
        NewState = Pawn.LandMovementState;
    }

    if (Pawn.HeadVolume != none && Pawn.HeadVolume.bWaterVolume)
    {
        Pawn.BreathTime = Pawn.UnderWaterTime;
    }

    if (IsInState(NewState))
    {
        BeginState();
    }
    else
    {
        GotoState(NewState);
    }
}

// Calculate free-aim and process recoil
simulated function rotator FreeAimHandler(rotator NewRotation, float DeltaTime)
{
    local rotator NewPlayerRotation;
    local int     YawAdjust;
    local int     PitchAdjust;
    local rotator AppliedRecoil;

    if (Pawn == none || ROWeapon(Pawn.Weapon) == none || !ROWeapon(Pawn.Weapon).ShouldUseFreeAim())
    {
        LastFreeAimSuspendTime = Level.TimeSeconds;

        if (WeaponBufferRotation.Yaw != 0)
        {
            if (WeaponBufferRotation.Yaw > 32768)
            {
                WeaponBufferRotation.Yaw += YawTweenRate * DeltaTime;

                if (WeaponBufferRotation.Yaw > 65536)
                {
                    WeaponBufferRotation.Yaw = 0;
                }
            }
            else
            {
                WeaponBufferRotation.Yaw -= YawTweenRate * DeltaTime;

                if (WeaponBufferRotation.Yaw <  0)
                {
                    WeaponBufferRotation.Yaw = 0;
                }
            }
        }

        if (WeaponBufferRotation.Pitch != 0)
        {
            if (WeaponBufferRotation.Pitch > 32768)
            {
                WeaponBufferRotation.Pitch += PitchTweenRate * DeltaTime;

                if (WeaponBufferRotation.Pitch > 65536)
                {
                    WeaponBufferRotation.Pitch = 0;
                }
            }
            else
            {
                WeaponBufferRotation.Pitch -= PitchTweenRate * DeltaTime;

                if (WeaponBufferRotation.Pitch <  0)
                {
                    WeaponBufferRotation.Pitch = 0;
                }
            }
        }

        if (Level.TimeSeconds - LastRecoilTime <= RecoilSpeed)
        {
            NewRotation += (RecoilRotator/RecoilSpeed) * DeltaTime;
        }
        else
        {
            RecoilRotator = rot(0, 0, 0);
        }

        return NewRotation;
    }

    NewPlayerRotation = NewRotation;

    // Add the freeaim movement in
    if (!bHudLocksPlayerRotation)
    {
        WeaponBufferRotation.Yaw += FAAWeaponRotationFactor * DeltaTime * aTurn;
        WeaponBufferRotation.Pitch += FAAWeaponRotationFactor * DeltaTime * aLookUp;
    }

    if (Level.TimeSeconds - LastRecoilTime <= RecoilSpeed)
    {
        AppliedRecoil = (RecoilRotator/RecoilSpeed) * DeltaTime;
        WeaponBufferRotation += AppliedRecoil;
    }
    else
    {
        RecoilRotator = rot(0, 0, 0);
    }

    // Do the pitch and yaw limitation
    YawAdjust = WeaponBufferRotation.Yaw & 65535;

    if (YawAdjust > FreeAimMaxYawLimit && YawAdjust < FreeAimMinYawLimit)
    {
        if (YawAdjust - FreeAimMaxYawLimit < FreeAimMinYawLimit - YawAdjust)
        {
            YawAdjust = FreeAimMaxYawLimit;
        }
        else
        {
            YawAdjust = FreeAimMinYawLimit;
        }

        NewPlayerRotation.Yaw += AppliedRecoil.Yaw;
    }

    WeaponBufferRotation.Yaw = YawAdjust;

    PitchAdjust = WeaponBufferRotation.Pitch & 65535;

    if (PitchAdjust > FreeAimMaxPitchLimit && PitchAdjust < FreeAimMinPitchLimit)
    {
        if (PitchAdjust - FreeAimMaxPitchLimit < FreeAimMinPitchLimit - PitchAdjust)
        {
            PitchAdjust = FreeAimMaxPitchLimit;
        }
        else
        {
            PitchAdjust = FreeAimMinPitchLimit;
        }

        NewPlayerRotation.Pitch += AppliedRecoil.Pitch;
    }

    WeaponBufferRotation.Pitch = PitchAdjust;

    return NewPlayerRotation;
}

// Modified to optimise by usually avoiding lots of pointless tracing & calculations every time a human player fires, as this functionality is only relevant to bots
// bAimingHelp is false for humans, so so the complicated parent function always returns the Controller's rotation (or pawn's rotation if in behind view)
// But if we're aiming at a bot with certain types of weapons, the Super can be relevant because it results in the bot receiving a warning
// Nearly all the time though, that isn't the case and so there's no point doing traces & calcs to get a target for a warning that won't happen
function rotator AdjustAim(FireProperties FiredAmmunition, vector ProjStart, int AimError)
{
    // These are the rare situations where we call the Super as we may be aiming at a bot with a relevant weapon that could result in it receiving a warning
    if (Level.Game.NumBots > 0 &&       // only need to consider this if there are some bots in the game
        (FiredAmmunition.bInstantHit || // if we're using an instant hit weapon (very rare in DH), a targeted bot will get a warning when InstantWarnTarget() gets called
        (FiredAmmunition.ProjectileClass != none && class<ROBallisticProjectile>(FiredAmmunition.ProjectileClass) == none))) // a non-ballistic projectile warns a bot that gets
    {                                                                                                                        // recorded as the ShotTarget pawn in the Super
        return super.AdjustAim(FiredAmmunition, ProjStart, AimError);
    }

    // Otherwise just return the standard rotation, without traces or calcs
    if (bBehindView && Pawn != none)
    {
        return Pawn.Rotation;
    }

    return Rotation;
}

// Menu for the player's entire selection process
exec function PlayerMenu(optional int Tab)
{
    bPendingMapDisplay = false;

    if (PlayerReplicationInfo == none || PlayerReplicationInfo.Team == none)
    {
        ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
    }
    else
    {
        DeployMenuStartMode = MODE_Map;
        ClientReplaceMenu("DH_Interface.DHDeployMenu");
    }
}

exec function PlaceRallyPoint()
{
    ServerSquadSpawnRallyPoint();
}

exec function SquadJoinAuto()
{
    ServerSquadJoinAuto();
}

// Modified to remove pausing in singleplayer and to open the correct menu
function ShowMidGameMenu(bool bPause)
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        StopForceFeedback();
    }

    // Open correct menu
    if (bDemoOwner)
    {
        ClientOpenMenu(DemoMenuClass);
    }
    else
    {
        // If we haven't picked a team or is a spectator... open the team pick menu
        if (PlayerReplicationInfo == none || PlayerReplicationInfo.Team == none)
        {
            ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
        }
        else
        {
            DeployMenuStartMode = MODE_Map;
            ClientReplaceMenu("DH_Interface.DHDeployMenu");
        }
    }
}

// Override for player gag functionality
function bool AllowTextMessage(string Msg)
{
    local int i;

    if (PlayerReplicationInfo.bSilentAdmin || Level.NetMode == NM_Standalone || PlayerReplicationInfo.bAdmin)
    {
        return true;
    }

    if (Level.Pauser == none && Level.TimeSeconds - LastBroadcastTime < 2 || bIsGagged)
    {
        return false;
    }

    // If same text, then lower the allowed frequency
    if (Level.TimeSeconds - LastBroadcastTime < 5)
    {
        Msg = Left(Msg, Clamp(Len(Msg) - 4, 8, 64));

        for (i = 0; i < 4; ++i)
        {
            if (LastBroadcastString[i] ~= Msg)
            {
                return false;
            }
        }
    }
    for (i = 3; i > 0; --i)
    {
        LastBroadcastString[i] = LastBroadcastString[i-1];
    }

    LastBroadcastTime = Level.TimeSeconds;
    return true;
}

// Modified to prevent broadcast of public chat if "all chat" is disabled
exec function Say(string Msg)
{
    Msg = Left(Msg,128);

    // If all chat is not allowed, then don't broadcast (serversay) and tell the user
    if (DHGameReplicationInfo(GameReplicationInfo) != none && !DHGameReplicationInfo(GameReplicationInfo).bAllChatEnabled)
    {
        ReceiveLocalizedMessage(class'DHCommunicationMessage', 0); // "Public chat is currently disabled"
        return;
    }

    if (AllowTextMessage(Msg))
    {
        ServerSay(Msg);
    }
}

exec function VehicleSay(string Msg)
{
    if (Msg == "")
    {
        return;
    }

    super.VehicleSay(Msg);
}

// Overridden to increase max name length from 20 to 32 chars
function ChangeName(coerce string S)
{
    if (Len(S) > 32)
    {
        S = Left(S, 32);
    }

    ReplaceText(S, "\"", "");
    DarkestHourGame(Level.Game).ChangeName(self, S, true);
}

simulated function float GetFlinchMeterFalloff(float TimeSeconds)
{
    return (TimeSeconds ** 2.0) * FlinchMeterFallOffStrength;
}

// Give the player a quick flinch and blur effect
simulated function PlayerWhizzed(float DistSquared)
{
    local float Intensity;

    // The magic number below is 75% of the radius of DHBulletWhipAttachment squared (we don't want a flinch on the more distant shots)
    Intensity = 1.0 - (FMin(DistSquared, 16875.0) / 16875.0);

    // Falloff the FlichMeter based on how much time has passed since we last had flinch
    FlinchMeterValue -= GetFlinchMeterFalloff(Level.TimeSeconds - LastFlinchTime);
    FlinchMeterValue = FMax(0.0, FlinchMeterValue); // Make sure FlinchMeterValue is not below zero

    // Increment the FlichMeter with a maximum
    FlinchMeterValue = FMin(FlinchMeterValue + FlinchMeterIncrement, 1.0);

    // Intensity is affected by the FlinchMeterValue, the higher the FlinchMeterValue the lower the Intensity
    Intensity *= 1.0 - FlinchMeterValue;

    AddBlur(0.85, Intensity);
    PlayerFlinched(Intensity);
}

simulated function PlayerFlinched(float Intensity)
{
    local rotator AfterFlinchRotation;
    local float   FlinchRate, FlinchIntensity;

    if (!Pawn.bBipodDeployed)
    {
        FlinchIntensity = Intensity * FlinchMaxOffset;

        AfterFlinchRotation.Pitch = RandRange((FlinchIntensity / 2), FlinchIntensity);
        AfterFlinchRotation.Yaw = RandRange((FlinchIntensity / 2), FlinchIntensity);

        if (Rand(2) == 1)
        {
            AfterFlinchRotation.Pitch *= -1;
        }
        if (Rand(2) == 1)
        {
            AfterFlinchRotation.Yaw *= -1;
        }

        FlinchRate = 0.125;

        SetRecoil(AfterFlinchRotation, FlinchRate);
    }
    else
    {
        FlinchRotMag *= Intensity;
        FlinchOffsetMag *= Intensity;

        if (Rand(2) == 1)
        {
            FlinchRotMag.X *= -1.0;
            FlinchOffsetMag.X *= -1.0;
        }
        if (Rand(2) == 1)
        {
            FlinchRotMag.Z *= -1.0;
            FlinchOffsetMag.Z *= -1.0;
        }

        ShakeView(FlinchRotMag, FlinchRotRate, FlinchRotTime, FlinchOffsetMag, FlinchOffsetRate, FlinchOffsetTime);
    }

    LastFlinchTime = Level.TimeSeconds;
}

// Modified to prevent a mistakenly passed negative blur time, which causes the blur to 'freeze' indefinitely, until some other blur effect resets it
simulated function AddBlur(float NewBlurTime, float NewBlurScale)
{
    if (NewBlurTime > 0.0)
    {
        super.AddBlur(NewBlurTime, NewBlurScale);
    }
}

// LAZY CAM
exec function LazyCam(float Laziness)
{
    if (Level.NetMode != NM_Standalone && !PlayerReplicationInfo.bSilentAdmin && !PlayerReplicationInfo.bAdmin)
    {
        return;
    }

    if (Laziness == 0.0)
    {
        SetLazyCam(false);
    }
    else
    {
        SetLazyCam(true);
        LazyCamLaziness = Laziness;
    }
}

function SetLazyCam(bool bLazyCam)
{
    self.bLazyCam = bLazyCam;

    if (bLazyCam)
    {
        LazyCamRotationTarget = Rotation;
    }
}

// Updated to allow Yaw limits for mantling
// Also to disable sway on bolt rifles between shots (while weapon is lowered from face)
function UpdateRotation(float DeltaTime, float MaxPitch)
{
    local DHPawn    DHPwn;
    local ROWeapon  ROWeap;
    local DHProjectileWeapon  DHPW;
    local ROVehicle ROVeh;
    local rotator   NewRotation, ViewRotation;
    local float     TurnSpeedFactor;
    local Quat      A, B;

    if (Pawn != none)
    {
        DHPwn = DHPawn(Pawn);
        ROWeap = ROWeapon(Pawn.Weapon);
        DHPW = DHProjectileWeapon(Pawn.Weapon);
        ROVeh = ROVehicle(Pawn);
    }

    // Handle any sway if ironsighted
    if (bSway && Pawn != none && !Pawn.bBipodDeployed && ROWeap != none && ROWeap.bCanSway && ROWeap.bUsingSights && !ROWeap.bWaitingToBolt)
    {
        SwayHandler(DeltaTime);
    }
    else
    {
        SwayYaw = 0.0;
        SwayPitch = 0.0;
        WeaponSwayYawRate = 0.0;
        WeaponSwayPitchRate = 0.0;
        SwayTime = 0.0;
    }

    // View shake (& exit) if interpolating
    if (bInterpolating || (Pawn != none && Pawn.bInterpolating))
    {
        ViewShake(DeltaTime);

        return;
    }

    // Using FreeCam for better view control
    if (bFreeCam)
    {
        if (bHudLocksPlayerRotation)
        {
            // no camera change if we're locking rotation
        }
        else if (bFreeCamZoom)
        {
            CameraDeltaRad += DeltaTime * 0.25 * aLookUp;
        }
        else if (bFreeCamSwivel)
        {
            CameraSwivel.Yaw += DHHalfTurnSpeedFactor * DeltaTime * aTurn;
            CameraSwivel.Pitch += DHHalfTurnSpeedFactor * DeltaTime * aLookUp;
        }
        else
        {
            CameraDeltaRotation.Yaw += DHStandardTurnSpeedFactor * DeltaTime * aTurn;
            CameraDeltaRotation.Pitch += DHStandardTurnSpeedFactor * DeltaTime * aLookUp;
        }
    }
    else if (bLazyCam)
    {
        LazyCamRotationTarget.Yaw += FClamp(DeltaTime * aTurn * DHStandardTurnSpeedFactor, -10000.0, 10000.0);
        LazyCamRotationTarget.Pitch += FClamp(DeltaTime * aLookUp * DHStandardTurnSpeedFactor, -10000.0, 10000.0);

        A = QuatFromRotator(Rotation);
        B = QuatFromRotator(LazyCamRotationTarget);

        if (class'UQuaternion'.static.Angle(A, B) < class'UUnits'.static.DegreesToRadians(0.125))
        {
            ViewRotation = LazyCamRotationTarget;
        }
        else
        {
            ViewRotation = QuatToRotator(QuatSlerp(A, B, DeltaTime * ((1.0 - FClamp(LazyCamLaziness, 0.0, 1.0)) * 32.0)));
        }

        SetRotation(ViewRotation);

        ViewShake(DeltaTime);
        ViewFlash(DeltaTime);

        // Make pawn face towards new view rotation (applied only to a DHPawn as vehicles ignore FaceRotation)
        if (!bRotateToDesired && DHPwn != none && (!bFreeCamera || !bBehindView))
        {
            NewRotation = ViewRotation;
            NewRotation.Roll = Rotation.Roll;
            DHPwn.FaceRotation(NewRotation, DeltaTime);
        }
    }
    else
    {
        ViewRotation = Rotation;

        // Ensure we are not setting the pawn to a rotation beyond its desired
        if (Pawn != none && Pawn.Physics != PHYS_Flying)
        {
            if (Pawn.DesiredRotation.Roll < 65535 && (ViewRotation.Roll < Pawn.DesiredRotation.Roll || ViewRotation.Roll > 0))
            {
                ViewRotation.Roll = 0;
            }
            else if (Pawn.DesiredRotation.Roll > 0 && (ViewRotation.Roll > Pawn.DesiredRotation.Roll || ViewRotation.Roll < 65535))
            {
                ViewRotation.Roll = 0;
            }
        }

        // Save old rotation & do some resets
        DesiredRotation = ViewRotation;
        TurnTarget = none;
        bRotateToDesired = false;
        bSetTurnRot = false;

        // Calculate any turning speed adjustments
        if (DHPwn != none && DHPwn.bRestingWeapon)
        {
            TurnSpeedFactor = DHHalfTurnSpeedFactor; // start with lower look sensitivity for when resting weapon
        }
        else
        {
            TurnSpeedFactor = DHStandardTurnSpeedFactor;
        }

        if (DHPW != none && DHPW.bHasScope && DHPW.bUsingSights)
        {
            TurnSpeedFactor *= DHScopeTurnSpeedFactor; // reduce if player is using a sniper scope or binocs
        }
        else if (DHPwn != none)
        {
            if (DHPwn.bIronSights || DHPwn.bBipodDeployed)
            {
                TurnSpeedFactor *= DHISTurnSpeedFactor; // reduce if player is using ironsights or is bipod deployed
            }
        }
        else if (ROVeh != none && ROVeh.DriverPositions[ROVeh.DriverPositionIndex].bDrawOverlays && ROVeh.HUDOverlay == none
            && DHArmoredVehicle(ROVeh) != none && DHArmoredVehicle(ROVeh).PeriscopeOverlay != none)
        {
            TurnSpeedFactor *= DHISTurnSpeedFactor; // reduce if player is driving an armored vehicle & using a periscope
        }

        // Calculate base for new view rotation, factoring in any turning speed reduction & applying max value limits
        ViewRotation.Yaw += FClamp((TurnSpeedFactor * DeltaTime * aTurn), -10000.0, 10000.0);
        ViewRotation.Pitch += FClamp((TurnSpeedFactor * DeltaTime * aLookUp), -10000.0, 10000.0);

        if (Pawn != none && Pawn.Weapon != none && DHPwn != none)
        {
            ViewRotation = FreeAimHandler(ViewRotation, DeltaTime);
        }

        // Look directly at the look target
        if (LookTarget != none)
        {
            ViewRotation = rotator(Normal(LookTarget.Location - (Pawn.Location + Pawn.EyePosition())));
        }

        // Apply any pawn limits on pitch & yaw
        if (DHPwn != none)
        {
            if (DHPwn.Weapon != none)
            {
                ViewRotation = FreeAimHandler(ViewRotation, DeltaTime);
            }

            ViewRotation.Pitch = DHPwn.LimitPitch(ViewRotation.Pitch, DeltaTime);

            if (DHPwn.bBipodDeployed || DHPwn.bIsMantling || DHPwn.bIsDeployingMortar || DHPwn.bIsCuttingWire)
            {
                DHPwn.LimitYaw(ViewRotation.Yaw);
            }
        }
        else if (ROVeh != none)
        {
            ViewRotation.Pitch = ROVeh.LimitPawnPitch(ViewRotation.Pitch);
            ViewRotation.Yaw = ROVeh.LimitYaw(ViewRotation.Yaw);
        }

        // Apply any sway
        ViewRotation.Yaw += SwayYaw;
        ViewRotation.Pitch += SwayPitch;

        // Set new view rotation & do any view shake
        SetRotation(ViewRotation);

        ViewShake(DeltaTime);
        ViewFlash(DeltaTime);

        // Make pawn face towards new view rotation (applied only to a DHPawn as vehicles ignore FaceRotation)
        if (!bRotateToDesired && DHPwn != none && (!bFreeCamera || !bBehindView))
        {
            NewRotation = ViewRotation;
            NewRotation.Roll = Rotation.Roll;
            DHPwn.FaceRotation(NewRotation, DeltaTime);
        }
    }
}

function ServerSaveArtilleryTarget(vector Location)
{
    SavedArtilleryCoords = Location;
}

function ServerSaveArtillerySupportSquadIndex(int Index)
{
    ArtillerySupportSquadIndex = Index;
}

// This function checks if the player can call artillery on the selected target.
function bool IsArtilleryTargetValid(vector ArtilleryLocation)
{
    local DHVolumeTest VT;
    local bool         bValidTarget;

    VT = Spawn(class'DHVolumeTest', self,, ArtilleryLocation);

    if (VT != none)
    {
        bValidTarget = !VT.DHIsInNoArtyVolume(DHGameReplicationInfo(GameReplicationInfo));
        VT.Destroy();
    }

    return bValidTarget;
}

// Emptied out, as this funcionality has been moved to DHRadio.
function HitThis(ROArtilleryTrigger RAT) { return; }

// New function to determine if the player is operating a vehicle that is marked as artillery
// TODO: suggest exclude passenger positions, so riders don't see arty targets
simulated function bool IsInArtilleryVehicle()
{
    local DHVehicle V;
    local VehicleWeaponPawn VWP;

    V = DHVehicle(Pawn);
    VWP = VehicleWeaponPawn(Pawn);

    if (VWP != none)
    {
        V = DHVehicle(VWP.VehicleBase);
    }

    if (V != none)
    {
        return V.bIsArtilleryVehicle;
    }

    return false;
}

simulated function bool IsInSquad()
{
    return DHPlayerReplicationInfo(PlayerReplicationInfo) != none && DHPlayerReplicationInfo(PlayerReplicationInfo).IsInSquad();
}

simulated function bool IsSLorASL()
{
    return DHPlayerReplicationInfo(PlayerReplicationInfo) != none && DHPlayerReplicationInfo(PlayerReplicationInfo).IsSLorASL();
}

simulated function bool IsSL()
{
    return DHPlayerReplicationInfo(PlayerReplicationInfo) != none && DHPlayerReplicationInfo(PlayerReplicationInfo).IsSL();
}

simulated function bool IsASL()
{
    return DHPlayerReplicationInfo(PlayerReplicationInfo) != none && DHPlayerReplicationInfo(PlayerReplicationInfo).IsASL();
}


// Modified to use any distance fog setting for the zone we're in
simulated function float GetMaxViewDistance()
{
    if (Pawn != none && Pawn.Region.Zone != none && Pawn.Region.Zone.bDistanceFog)
    {
        return Pawn.Region.Zone.DistanceFogEnd;
    }

    return super.GetMaxViewDistance();
}

// Modified to handle separate MG & AT resupply as well as assisted AT loading
// Uses our pawn's AutoTraceActor instead of the HUD's NamedPlayer, which is deprecated (AutoTrace now registers DHPawns so this works fine)
exec function ThrowMGAmmo()
{
    local DHPawn MyPawn, OtherPawn;

    MyPawn = DHPawn(Pawn);

    if (MyPawn != none)
    {
        OtherPawn = DHPawn(MyPawn.AutoTraceActor);

        if (OtherPawn != none)
        {
            if (!MyPawn.bUsedCarriedMGAmmo && MyPawn.bCarriesExtraAmmo && OtherPawn.bWeaponNeedsResupply)
            {
                ServerThrowMGAmmo(OtherPawn);
            }

            if (OtherPawn.bWeaponNeedsReload)
            {
                ServerLoadATAmmo(OtherPawn);
            }
        }
        else if (DHMortarVehicle(MyPawn.AutoTraceActor) != none)
        {
            ServerThrowMortarAmmo(DHMortarVehicle(ROPawn(Pawn).AutoTraceActor));
        }
    }
}

function ServerThrowMGAmmo(Pawn Gunner)
{
    local DHPawn P;

    P = DHPawn(Pawn);

    if (P != none && Gunner != none)
    {
        P.TossAmmo(Gunner);
    }
}

function ServerThrowMortarAmmo(Pawn Gunner)
{
    local DHPawn P;
    local DHMortarVehicle M;

    P = DHPawn(Pawn);
    M = DHMortarVehicle(Gunner);

    if (P == none || M == none || M.OwningPawn == P)
    {
        return;
    }

    P.TossMortarVehicleAmmo(M);
}

function ServerLoadATAmmo(Pawn Gunner)
{
    local DHPawn P;

    P = DHPawn(Pawn);

    if (P != none && Gunner != none)
    {
        P.LoadWeapon(Gunner);
    }
}

// Modified to avoid unnecessary Pawn.SaveConfig(), which saved block of pointless vehicle config variables to user.ini file every time player used behind view in a vehicle
// Including TPCamDistance, which once saved in the .ini file will override any changes made in vehicle default properties
// Also bDesiredBehindView=true was saved in .ini if player exited game while in a vehicle in behind view, which then screwed up their rotation when entering that vehicle in future
// Instead we ResetConfig() for the vehicle class, in practice meaning clearing all saved config if no default config exists, so we always use the class default values in behind view
// And in vehicle's ClientKDriverEnter() we set bDesiredBehindView to false, to avoid possibility of rotation being screwed when entering a vehicle
function ClientSetBehindView(bool B)
{
    local bool bWasBehindView;

    bWasBehindView = bBehindView;
    bBehindView = B;
    CameraDist = default.CameraDist;

    if (bBehindView != bWasBehindView)
    {
        ViewTarget.POVChanged(self, true);
    }

    if (Vehicle(Pawn) != none)
    {
        Pawn.ResetConfig();
        Vehicle(Pawn).DesiredTPCamDistance = Vehicle(Pawn).TPCamDistance;
    }
}

// Modified to edit an if state in Timer()
auto state PlayerWaiting
{
    ignores SeePlayer, HearNoise, NotifyBump, TakeDamage, PhysicsVolumeChange, SwitchToBestWeapon;

    // In the else if() statement, PRI != none was added so if the player isn't knowledgeable of their PRI yet it doesn't even open a menu
    // This actually works quite well because now players will actually see the server's MOTD text
    simulated function Timer()
    {
        if (!bPendingMapDisplay || bDemoOwner)
        {
            SetTimer(0, false);
        }
        else if (Player != none && GUIController(Player.GUIController) != none && !GUIController(Player.GUIController).bActive && PlayerReplicationInfo != none)
        {
            bPendingMapDisplay = false;
            SetTimer(0, false);
            PlayerMenu();

            // We init the hint manager here because it needs to be
            // initialized after the Player variables have been set
            UpdateHintManagement(bShowHints);
        }
    }

    exec function Jump( optional float F )
    {
        TryToActivateSituationMap();
    }
}

state PlayerWalking
{
    ignores SeePlayer, HearNoise, Bump;

    // Modified to allow behind view, if server has called this (restrictions on use of behind view are handled in ServerToggleBehindView)
    function ClientSetBehindView(bool B)
    {
        global.ClientSetBehindView(B);
    }

    // Added a test for mantling
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector  OldAccel;
        local DHPawn P;

        P = DHPawn(Pawn);

        if (P == none)
        {
            return;
        }

        OldAccel = Pawn.Acceleration;

        if (Pawn.Acceleration != NewAccel)
        {
            Pawn.Acceleration = NewAccel;
        }

        Pawn.SetViewPitch(Rotation.Pitch);

        // Failsafe in case client passes mantle test but server fails, so client isn't left in limbo
        // Also triggers if player cancels mantle before the client has actually entered the mantling state
        if (Role < ROLE_Authority && bWaitingToMantle && Level.TimeSeconds > MantleFailTimer)
        {
            bWaitingToMantle = false;
            DHPawn(Pawn).ClientMantleFail();
        }

        if (bPressedJump && !bWaitingToMantle)
        {
            if (P.CanMantle(true))
            {
                if (Role == ROLE_Authority)
                {
                    GotoState('Mantling');
                }

                if (Role < ROLE_Authority)
                {
                    bWaitingToMantle = true;
                    MantleFailTimer = Level.TimeSeconds + 1.0;
                }

                return;
            }
            else
            {
                P.DoJump(bUpdating);
            }
        }

        if (Pawn.Physics != PHYS_Falling)
        {
            if (bDuck == 0)
            {
                Pawn.ShouldCrouch(false);
            }
            else if (Pawn.bCanCrouch)
            {
                Pawn.ShouldCrouch(true);
            }

            if (bCrawl == 0)
            {
                Pawn.ShouldProne(false);
            }
            else if (Pawn.bCanProne)
            {
                Pawn.ShouldProne(true);
            }
        }

        if (bDidMantle && Role < ROLE_Authority)
        {
            ClientMessage("processmove Vel:" @ Pawn.Velocity);
        }
    }

    // Client side
    function PlayerMove(float DeltaTime)
    {
        local vector          X, Y, Z, NewAccel;
        local eDoubleClickDir DoubleClickMove;
        local rotator         OldRotation, ViewRotation;
        local bool            bSaveJump;
        local DHPawn          P;

        P = DHPawn(Pawn);

        if (P == none)
        {
            GotoState('Dead'); // this was causing instant respawns in mp games

            return;
        }

        if (bHudCapturesMouseInputs)
        {
            HandleMousePlayerMove(DeltaTime);
        }

        // Probably want to move this elsewhere, but here will do for now
        if (Level.TimeSeconds - MantleCheckTimer > 0.125 && !P.bIsMantling)
        {
            P.HUDCheckMantle();
            MantleCheckTimer = Level.TimeSeconds;
        }

        P.HUDCheckDig();

        GetAxes(Pawn.Rotation, X, Y, Z);

        // Handle toggle run
        if (bToggleRun)
        {
            if (aForward == 6000.0 || aForward == -6000.0 || aStrafe != 0.0)
            {
                bToggleRun = false; // If any movement input (WASD), then cancel toggle run
            }
            else
            {
                aForward = 5999.9; // If toggle run, then make aForward as close as possible to 6000.0, but not
            }
        }

        // Calculate acceleration (movement)
        NewAccel = aForward * X + aStrafe * Y;
        NewAccel.Z = 0.0;

        if (VSizeSquared(NewAccel) < 1.0 || bWaitingToMantle || P.bIsDeployingMortar || P.bIsCuttingWire) // using VSizeSquared instead of VSize for more efficient processing
        {
            NewAccel = vect(0.0, 0.0, 0.0);
        }

        GroundPitch = 0;
        ViewRotation = Rotation;

        if (Pawn.Physics == PHYS_Walking)
        {
            // Take the bipod weapon out of deployed if the player tries to move
            if (Pawn.bBipodDeployed && NewAccel != vect(0.0, 0.0, 0.0) && Pawn.Weapon != none)
            {
//              ROBipodWeapon(Pawn.Weapon).ForceUndeploy(); // replaced by if/else below so it actually works with DH weapons
                if (DHBipodWeapon(Pawn.Weapon) != none)
                {
                    DHBipodWeapon(Pawn.Weapon).ForceUndeploy();
                }
                else if (DHBipodAutoWeapon(Pawn.Weapon) != none)
                {
                    DHBipodAutoWeapon(Pawn.Weapon).ForceUndeploy();
                }
            }

            // Tell pawn about any direction changes to give it a chance to play appropriate animation
            // If walking, look up/down stairs - unless player is rotating view
            if (bLook == 0 && ((Pawn.Acceleration != vect(0.0, 0.0, 0.0) && bSnapToLevel) || !bKeyboardLook))
            {
                if (bLookUpStairs || bSnapToLevel)
                {
                    GroundPitch = FindStairRotation(DeltaTime);
                    ViewRotation.Pitch = GroundPitch;
                }
            }
        }

        Pawn.CheckBob(DeltaTime, Y);

        // Update rotation
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime, 1.0);
        bDoubleJump = false;

        if (bPressedJump && Pawn.CannotJumpNow())
        {
            bSaveJump = true;
            bPressedJump = false;
        }
        else
        {
            bSaveJump = false;
        }

        if (Role < ROLE_Authority) // then save this move and replicate it
        {
            ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        }
        else
        {
            ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        }

        bPressedJump = bSaveJump;
    }

    // Modified so moving into a shallow water volume doesn't send player into swimming state
    function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (NewVolume != none && NewVolume.bWaterVolume)
        {
            if (!(NewVolume.IsA('DHWaterVolume') && DHWaterVolume(NewVolume).bIsShallowWater))
            {
                GotoState(Pawn.WaterMovementState);
            }
        }

        return false;
    }

    function EndState()
    {
        GroundPitch = 0;
        bToggleRun = false;

        if (Pawn != none)
        {
            if (bDuck == 0)
            {
                Pawn.ShouldCrouch(false);
            }

            if (bCrawl == 0)
            {
                Pawn.ShouldProne(false);
            }
        }

        if (Role < ROLE_Authority)
        {
            bWaitingToMantle = false;
        }
    }
}

state Mantling
{
    // For reasons unknown, native prediction on the server insists on altering the client's velocity once its animation finishes
    // This forcibly resets that velocity just long enough for the server to catch up and end the state
    event PlayerTick(float DeltaTime)
    {
        if (bDidMantle && Role < ROLE_Authority && Pawn.Velocity != vect(0.0, 0.0, 0.0))
        {
            Pawn.Velocity = vect(0.0, 0.0, 0.0);
        }

        global.PlayerTick(DeltaTime);
    }

    function Timer()
    {
        local DHPawn DHP;

        DHP = DHPawn(Pawn);

        if (DHP.Physics == PHYS_Walking)
        {
            // This is just in case we fall further than expected and are unable to set crouch in DHPawn.ResetRootBone()
            if (!bDidCrouchCheck && DHP.bCrouchMantle)
            {
                DHP.DoMantleCrouch();
                bDidCrouchCheck = true;
                SetTimer(0.15, false);
            }
            else
            {
                // Extremely important to not let the client exit the state before the server - BIG sync problems othewise
                if (Role == ROLE_Authority)
                {
                    GotoState('PlayerWalking');
                }
            }
        }
        else
        {
            // Wait for player to finish falling - if they don't do so within a set period, assume something's gone wrong and abort
            if (MantleLoopCount < 6)
            {
                SetTimer(0.1, false);
                MantleLoopCount++;
            }
            else
            {
                SetTimer(0.0, false);
                DHP.CancelMantle();

                if (Role == ROLE_Authority)
                {
                    GotoState('PlayerWalking');
                }

                bLockJump = true;

                return;
            }
        }
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local DHPawn DHP;

        DHP = DHPawn(Pawn);

        if (bPressedJump && !bLockJump)
        {
            SetTimer(0.0, false);
            DHP.CancelMantle();

            if (Role == ROLE_Authority)
            {
                GotoState('PlayerWalking');
            }

            bLockJump = true;

            return;
        }

        if (Pawn.Acceleration != NewAccel)
        {
            Pawn.Acceleration = NewAccel;
        }

        DHP.SetViewPitch(Rotation.Pitch);

        if (!bDidMantle && !bLockJump)
        {
            DHP.DoMantle(DeltaTime);
        }
    }

    function PlayerMove(float DeltaTime)
    {
        local vector          NewAccel;
        local eDoubleClickDir DoubleClickMove;
        local rotator         OldRotation, ViewRotation;
        local DHPawn          DHP;

        DHP = DHPawn(Pawn);

        ViewRotation = Rotation;

        if (!bDidMantle && DHP.bIsMantling)
        {
            NewAccel = DHP.NewAcceleration;
        }
        else
        {
            NewAccel = vect(0.0, 0.0, 0.0);
        }

        // Update rotation
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime, 1.0);

        if (bSprint > 0)
        {
            bSprint = 0;
        }

        if (Role < ROLE_Authority) // then save this move and replicate it
        {
            ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        }
        else
        {
            ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        }

        bPressedJump = false;
    }

    function BeginState()
    {
        if (bMantleDebug)
        {
            if (Role == ROLE_Authority)
            {
                ClientMessage("SERVER ENTER Controller Mantling state");
                Log("SERVER ENTER Controller Mantling state");
            }
            else
            {
                ClientMessage("CLIENT ENTER Controller Mantling state");
                Log("CLIENT ENTER Controller Mantling state");
            }
        }

        // If the client has failed the mantle check conditions but server has not, this should force it to bypass the start conditions & resync with the server
        if (Role < ROLE_Authority && !DHPawn(Pawn).bIsMantling)
        {
            DHPawn(Pawn).CanMantle(true, true);
        }

        bSprint = 0;
        DHPawn(Pawn).PreMantle();

        if (bLockJump)
        {
            bLockJump = false;
        }

        MantleLoopCount = 0;
    }

    function EndState()
    {
        local DHPawn P;

        if (bMantleDebug)
        {
            if (Role == ROLE_Authority)
            {
                ClientMessage("SERVER EXIT Controller Mantling state");
                Log("SERVER EXIT Controller Mantling state");
            }
            else
            {
                ClientMessage("CLIENT EXIT Controller Mantling state");
                Log("CLIENT EXIT Controller Mantling state");
            }
        }

        bDidMantle = false;
        bDidCrouchCheck = false;
        bLockJump = false;

        P = DHPawn(Pawn);

        if (P != none && P.bIsMantling)
        {
            P.CancelMantle();
        }

        if (bMantleDebug)
        {
            ClientMessage("------------- End Mantle Debug -------------");
            Log("------------- End Mantle Debug -------------");
        }
    }
}

state PlayerDriving
{
ignores SeePlayer, HearNoise, Bump;

    // Modified to ignore bDisableThrottle & bWantsToThrottle, which relate to waiting for crew & are now effectively deprecated
    function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
    {
        local Vehicle CurrentVehicle;

        CurrentVehicle = Vehicle(Pawn);

        // Set the throttle, steering etc for the vehicle based on the input provided
        if (CurrentVehicle != none)
        {
            CurrentVehicle.Throttle = FClamp(InForward / 5000.0, -1.0, 1.0);
            CurrentVehicle.Steering = FClamp(-InStrafe / 5000.0, -1.0, 1.0);
            CurrentVehicle.Rise = FClamp(InUp / 5000.0, -1.0, 1.0);
        }
    }

    // Modified to use DHArmoredVehicle instead of deprecated ROTreadCraft
    function PlayerMove(float DeltaTime)
    {
        local Vehicle          CurrentVehicle;
        local DHArmoredVehicle AV;
        local float            NewPing, AppliedThrottle;
        local bool             bIncrementalThrottle;

        CurrentVehicle = Vehicle(Pawn);

        if (CurrentVehicle != none)
        {
            AV = DHArmoredVehicle(Pawn);

            // Check whether player is using an incremental throttle, based on his settings & the type of vehicle
            if (AV != none)
            {
                bIncrementalThrottle = bInterpolatedTankThrottle;
            }
            else
            {
                bIncrementalThrottle = bInterpolatedVehicleThrottle;
            }
        }

        if (bHudCapturesMouseInputs)
        {
            HandleMousePlayerMove(DeltaTime);
        }

        // Update 'looking' rotation
        UpdateRotation(DeltaTime, 2.0);

        // TODO: Don't send things like aForward and aStrafe for gunners who don't need it - only servers can actually do the driving logic
        if (Role < ROLE_Authority)
        {
            if ((Level.TimeSeconds - LastPingUpdate) > 4.0 && PlayerReplicationInfo != none && !bDemoOwner)
            {
                LastPingUpdate = Level.TimeSeconds;
                NewPing = float(ConsoleCommand("GETPING"));

                if (ExactPing < 0.006)
                {
                    ExactPing = FMin(0.1, 0.001 * NewPing);
                }
                else
                {
                    ExactPing = (0.99 * ExactPing) + (0.0001 * NewPing);
                }

                PlayerReplicationInfo.Ping = Min(250.0 * ExactPing, 255);
                PlayerReplicationInfo.bReceivedPing = true;
                OldPing = ExactPing;
                ServerUpdatePing(1000 * ExactPing);
            }

            if (!bSkippedLastUpdate &&                              // in order to skip this update we must not have skipped the last one
                Player.CurrentNetSpeed < 10000 &&                   // and netspeed must be low
                (Level.TimeSeconds - ClientUpdateTime) < 0.0222 &&  // and time since last update must be short
                bPressedJump == bLastPressedJump &&                 // and update must not contain major changes
                (aUp - aLastUp) < 0.01 &&                           // "
                (aForward - aLastForward) < 0.01 &&                 // "
                (aStrafe - aLastStrafe) < 0.01                      // "
                )
            {
                bSkippedLastUpdate = true;

                return;
            }
            else
            {
                bSkippedLastUpdate = false;
                ClientUpdateTime = Level.TimeSeconds;

                // Save Move
                bLastPressedJump = bPressedJump;
                aLastUp = aUp;
                aLastForward = aForward;
                aLastStrafe = aStrafe;

                if (bIncrementalThrottle)
                {
                    if (aForward > 0.0)
                    {
                        CurrentVehicle.ThrottleAmount += DeltaTime * ThrottleChangeRate;
                    }
                    else if (aForward < 0.0)
                    {
                        CurrentVehicle.ThrottleAmount -= DeltaTime * ThrottleChangeRate;
                    }

                    CurrentVehicle.ThrottleAmount = FClamp(CurrentVehicle.ThrottleAmount, -6000.0, 6000.0);
                    AppliedThrottle = CurrentVehicle.ThrottleAmount;

                    // Stop if the throttle is below this amount
                    if (Abs(AppliedThrottle) < 500.0)
                    {
                        AppliedThrottle = 0.0;
                    }

                    // Brakes are on, so zero the throttle
                    if (aUp > 0.0)
                    {
                        AppliedThrottle = 0.0;
                        CurrentVehicle.ThrottleAmount = 0.0;
                    }

                    CurrentVehicle.Throttle = FClamp(AppliedThrottle / 5000.0, -1.0, 1.0);
                    CurrentVehicle.Steering = FClamp(-aStrafe / 5000.0, -1.0, 1.0);
                    CurrentVehicle.Rise = FClamp(aUp / 5000.0, -1.0, 1.0);

                    ServerDrive(AppliedThrottle, aStrafe, aUp, bPressedJump, (32767 & (Rotation.Pitch / 2)) * 32768 + (32767 & (Rotation.Yaw / 2)));
                }
                else
                {
                    if (CurrentVehicle != none)
                    {
                        CurrentVehicle.Throttle = FClamp(aForward / 5000.0, -1.0, 1.0);
                        CurrentVehicle.Steering = FClamp(-aStrafe / 5000.0, -1.0, 1.0);
                        CurrentVehicle.Rise = FClamp(aUp / 5000.0, -1.0, 1.0);
                    }

                    ServerDrive(aForward, aStrafe, aUp, bPressedJump, (32767 & (Rotation.Pitch / 2)) * 32768 + (32767 & (Rotation.Yaw / 2)));
                }
            }
        }
        else
        {
            if (bIncrementalThrottle)
            {
                if (aForward > 0.0)
                {
                    CurrentVehicle.ThrottleAmount += DeltaTime * ThrottleChangeRate;
                }
                else if (aForward < 0.0)
                {
                    CurrentVehicle.ThrottleAmount -= DeltaTime * ThrottleChangeRate;
                }

                CurrentVehicle.ThrottleAmount = FClamp(CurrentVehicle.ThrottleAmount, -6000.0, 6000.0);
                AppliedThrottle = CurrentVehicle.ThrottleAmount;

                // Stop if the throttle is below this amount
                if (Abs(AppliedThrottle) < 500.0)
                {
                    AppliedThrottle = 0.0;
                }

                // Brakes are on, so zero the throttle
                if (aUp > 0.0)
                {
                    AppliedThrottle = 0.0;
                    CurrentVehicle.ThrottleAmount = 0.0;
                }

                ProcessDrive(AppliedThrottle, aStrafe, aUp, bPressedJump);
            }
            else
            {
                ProcessDrive(aForward, aStrafe, aUp, bPressedJump);
            }
        }

        // If the vehicle is being controlled here, set replicated variables
        if (CurrentVehicle != none)
        {
            if (bFire == 0 && CurrentVehicle.bWeaponIsFiring)
            {
                CurrentVehicle.ClientVehicleCeaseFire(false);
            }

            if (bAltFire == 0 && CurrentVehicle.bWeaponIsAltFiring)
            {
                CurrentVehicle.ClientVehicleCeaseFire(true);
            }
        }
    }
}

state PlayerSwimming
{
ignores SeePlayer, HearNoise, Bump;

    // Modified so if player moves into a shallow water volume, they exit swimming state, same as if they move into a non-water volume
    function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        local vector CheckPoint, HitLocation, HitNormal;

        if (!NewVolume.bWaterVolume || (NewVolume.IsA('DHWaterVolume') && DHWaterVolume(NewVolume).bIsShallowWater)) // moving into shallow water volume also exits swimming state
        {
            Pawn.SetPhysics(PHYS_Falling);

            if (Pawn.Velocity.Z > 0.0)
            {
                if (Pawn.bUpAndOut && Pawn.CheckWaterJump(HitNormal)) // check for water jump
                {
                    // TODO: Fix jump out of water issue
                    Pawn.Velocity.Z = FMax(Pawn.JumpZ, 420.0) + 2.0 * Pawn.CollisionRadius; // set here so physics uses this for remainder of tick
                    GotoState(Pawn.LandMovementState);
                }
                else if (Pawn.Velocity.Z > 160.0 || !Pawn.TouchingWaterVolume())
                {
                    GotoState(Pawn.LandMovementState);
                }
                else // check if in deep water (positive trace means we're not)
                {
                    CheckPoint = Pawn.Location;
                    CheckPoint.Z -= Pawn.CollisionHeight + 6.0;

                    if (Trace(HitLocation, HitNormal, CheckPoint, Pawn.Location, false) != none)
                    {
                        GotoState(Pawn.LandMovementState);
                    }
                    else
                    {
                        Enable('Timer');
                        SetTimer(0.7, false);
                    }
                }
            }
        }
        else
        {
            Disable('Timer');
            Pawn.SetPhysics(PHYS_Swimming);
        }

        return false;
    }

    // Modified so landing in a shallow water volume doesn't send player into swimming state
    function bool NotifyLanded(vector HitNormal)
    {
        if (Pawn.PhysicsVolume != none && Pawn.PhysicsVolume.bWaterVolume && !(Pawn.PhysicsVolume.IsA('DHWaterVolume') && DHWaterVolume(Pawn.PhysicsVolume).bIsShallowWater))
        {
            Pawn.SetPhysics(PHYS_Swimming);
        }
        else
        {
            GotoState(Pawn.LandMovementState);
        }

        return bUpdating;
    }

    // Modified so moving into a shallow water volume also triggers NotifyPhysicsVolumeChange(), same as if they move into a non-water volume
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector OldAccel;
        local bool   bUpAndOut;

        OldAccel = Pawn.Acceleration;

        if (Pawn.Acceleration != NewAccel)
        {
            Pawn.Acceleration = NewAccel;
        }

        bUpAndOut = (Pawn.Acceleration.Z > 0.0 || Rotation.Pitch > 2048) && (vector(Rotation) Dot Pawn.Acceleration) > 0.0;

        if (Pawn.bUpAndOut != bUpAndOut)
        {
            Pawn.bUpAndOut = bUpAndOut;
        }

        if (!Pawn.PhysicsVolume.bWaterVolume || (Pawn.PhysicsVolume.IsA('DHWaterVolume') && DHWaterVolume(Pawn.PhysicsVolume).bIsShallowWater))
        {
            NotifyPhysicsVolumeChange(Pawn.PhysicsVolume);
        }
    }

    // Modified to use VSizeSquared instead of VSize for more efficient processing, as this is a many-times-a-second function
    function PlayerMove(float DeltaTime)
    {
        local vector  NewAccel, X, Y, Z;
        local rotator OldRotation;

        GetAxes(Rotation, X, Y, Z);

        // Update acceleration
        NewAccel = (aForward * X) + (aStrafe * Y) + (aUp * vect(0.0, 0.0, 1.0));

        if (VSizeSquared(NewAccel) < 1.0)
        {
            NewAccel = vect(0.0, 0.0, 0.0);
        }

        // Update bob
        Pawn.CheckBob(DeltaTime, Y);

        // Update rotation
        OldRotation = Rotation;
        UpdateRotation(DeltaTime, 2.0);

        // Now process this move (net client saves the move & replicates it)
        if (Role < ROLE_Authority)
        {
            ReplicateMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
        }
        else
        {
            ProcessMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
        }

        bPressedJump = false;
    }

    // Modified so if player is in a shallow water volume, they exit swimming state, same as if they are in a non-water volume
    function Timer()
    {
        if ((!Pawn.PhysicsVolume.bWaterVolume || (Pawn.PhysicsVolume.IsA('DHWaterVolume') && DHWaterVolume(Pawn.PhysicsVolume).bIsShallowWater)) && Role == ROLE_Authority)
        {
            GotoState(Pawn.LandMovementState);
        }

        Disable('Timer');
    }
}

state PlayerClimbing
{
ignores SeePlayer, HearNoise, Bump;

    // Modified so moving into a shallow water volume doesn't send player into swimming state
    function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (NewVolume != none && NewVolume.bWaterVolume && !(NewVolume.IsA('DHWaterVolume') && DHWaterVolume(NewVolume).bIsShallowWater) && Pawn != none)
        {
            GotoState(Pawn.WaterMovementState);
        }
        else
        {
            GotoState(Pawn.LandMovementState);
        }

        return false;
    }
}

// Modified so player can enter vehicle if looking at one of its vehicle weapons (generally a turret), not just its hull/base
// In particular this makes it much easier to enter AT guns, which can have a very small base & a large 'turret'
function ServerUse()
{
    local Vehicle   EntryVehicle;
    local Actor     LookedAtActor, A;

    if (Role < ROLE_Authority)
    {
        return;
    }

    if (Level.Pauser == PlayerReplicationInfo)
    {
        SetPause(false);

        return;
    }

    if (Pawn == none || !Pawn.bCanUse)
    {
        return;
    }

    // If player is in a vehicle, try to exit it
    if (Vehicle(Pawn) != none)
    {
        Vehicle(Pawn).KDriverLeave(false);

        return;
    }

    // Otherwise try to use any actor the player is looking at & is standing directly in front of
    if (ROPawn(Pawn) != none)
    {
        LookedAtActor = ROPawn(Pawn).AutoTraceActor;

        if (LookedAtActor != none)
        {
            if (LookedAtActor.IsA('DHCollisionMeshActor') && LookedAtActor.Owner != none)
            {
                LookedAtActor = LookedAtActor.Owner; // if looking at a collision static mesh actor, switch to the vehicle weapon or vehicle it represents
            }

            if (VehicleWeapon(LookedAtActor) != none && LookedAtActor.Base != none)
            {
                LookedAtActor = LookedAtActor.Base; // if looking at a vehicle weapon, switch to its vehicle base
            }

            // If player is looking at a vehicle, try to enter it
            if (ROVehicle(LookedAtActor) != none)
            {
                EntryVehicle = ROVehicle(LookedAtActor).FindEntryVehicle(Pawn);

                // End AT Rotation action if player is currently preforming one
                if (DHPawn(Pawn) != none && DHPawn(Pawn).GunToRotate != none)
                {
                    DHPawn(Pawn).GunToRotate.ServerExitRotation();
                    DHPawn(Pawn).SwitchToLastWeapon();
                }

                if (EntryVehicle != none && EntryVehicle.TryToDrive(Pawn))
                {
                    return;
                }
            }
            // Otherwise try to use whatever other actor player is looking at
            else
            {
                LookedAtActor.UsedBy(Pawn);

                return;
            }
        }
    }

    // Send the 'UsedBy' event to each actor the player is touching, including its Base
    foreach Pawn.TouchingActors(class'Actor', A)
    {
        if (!A.bCanAutoTraceSelect)
        {
            A.UsedBy(Pawn);
        }
    }

    if (Pawn.Base != none)
    {
        Pawn.Base.UsedBy(Pawn);
    }
}

// Reset bolt rifle sway values when we bolt it, since that's technically lowering it from the eye
simulated function ResetSwayAfterBolt()
{
    SwayYaw = 0.0;
    SwayPitch = 0.0;
    WeaponSwayYawRate = 0.0;
    WeaponSwayPitchRate = 0.0;
    SwayTime = 0.0;
}

simulated function bool IsArtilleryOperator()
{
    local DHRoleInfo RI;

    RI = DHRoleInfo(GetRoleInfo());

    return (RI != none && RI.bCanUseMortars) || IsInArtilleryVehicle();
}

simulated function bool IsArtillerySpotter()
{
    return IsSquadLeader();
}

simulated function bool IsRadioman()
{
    local DHRoleInfo RI;

    RI = DHRoleInfo(GetRoleInfo());

    return RI != none && RI.bCarriesRadio;
}

function ServerNotifyRoles(DHPlayerReplicationInfo.ERoleSelector RoleSelector, class<ROCriticalMessage> Message, int MessageIndex, optional Object OptionalObject)
{
    local int                     TeamIndex, SquadIndex;
    local Controller              C;
    local DHPlayer                OtherPlayer;
    local DHPlayerReplicationInfo PRI;

    TeamIndex = GetTeamNum();
    SquadIndex = GetSquadIndex();

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        OtherPlayer = DHPlayer(C);

        if (OtherPlayer == none || OtherPlayer == self || OtherPlayer.GetTeamNum() != TeamIndex)
        {
            continue;
        }

        PRI = DHPlayerReplicationInfo(OtherPlayer.PlayerReplicationInfo);

        if (PRI != none && PRI.CheckRole(RoleSelector))
        {
            OtherPlayer.ReceiveLocalizedMessage(Message, MessageIndex, PlayerReplicationInfo, OtherPlayer.PlayerReplicationInfo, OptionalObject);
        }
    }
}

function bool IsPositionOfArtillery(vector Position)
{
    local int i;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    for (i = 0; i < arraycount(GRI.DHArtillery); i++)
    {
        if (GRI.DHArtillery[i] != none &&
            GRI.DHArtillery[i].GetTeamIndex() == GetTeamNum() &&
            !GRI.DHArtillery[i].IsParadrop())
        {
            // to do: refactor checking if GRI.DHArtillery[i].Location == Position
            // GRI.DHArtillery[i].Location == Position is false because of round-up errors...
            if (VSize(GRI.DHArtillery[i].Location - Position) < 1)
            {
                return true;
            }
        }
    }
    return false;
}

function bool IsPositionOfParadrop(vector Position)
{
    local int i;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    for (i = 0; i < arraycount(GRI.DHArtillery); i++)
    {
        if (GRI.DHArtillery[i] != none &&
            GRI.DHArtillery[i].GetTeamIndex() == GetTeamNum() &&
            GRI.DHArtillery[i].IsParadrop())
        {
            if (VSize(GRI.DHArtillery[i].Location - Position) < 1)
            {
                // to do: refactor checking if GRI.DHArtillery[i].Location == Position
                // GRI.DHArtillery[i].Location == Position is false because of round-up errors...
                return true;
            }
        }
    }
    return false;
}

function int GetActiveOffMapSupportNumber()
{
    local int i, Counter;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    Counter = 0;
    for (i = 0; i < arraycount(GRI.DHArtillery); ++i)
    {
        if (GRI.DHArtillery[i] != none &&
            GRI.DHArtillery[i].GetTeamIndex() == GetTeamNum())
        {
            Counter++;
        }
    }
    return Counter;
}

// Modified to allow mortar operator to make a resupply request
function AttemptToAddHelpRequest(PlayerReplicationInfo PRI, int ObjID, int RequestType, optional vector RequestLocation)
{
    local DHRoleInfo RI;

    RI = DHRoleInfo(GetRoleInfo());

    // Only allow if requesting player is a leader role or if he's a machine gunner or mortar operator requesting resupply
    if (RI != none &&
        (RI.bIsLeader || (RequestType == 3 && (RI.bIsGunner || RI.bCanUseMortars))) &&
        ROGameReplicationInfo(GameReplicationInfo) != none &&
        PRI != none &&
        PRI.Team != none)
    {
        ROGameReplicationInfo(GameReplicationInfo).AddHelpRequest(PRI, ObjID, RequestType, RequestLocation); // add to team's HelpRequests array

        if (DarkestHourGame(Level.Game) != none)
        {
            DarkestHourGame(Level.Game).NotifyPlayersOfMapInfoChange(PRI.Team.TeamIndex, self); // notify team members to check their map
        }
    }
}

// For signal smoke grenade handling
function string GetSecGrenadeWeapon()
{
    local RORoleInfo RI;

    RI = GetRoleInfo();

    if (RI == none || GrenadeWeapon + 1 < 1)
    {
        return "";
    }

    return string(RI.Grenades[GrenadeWeapon + 1].Item);
}

function int GetSecGrenadeAmmo()
{
    local RORoleInfo RI;

    RI = GetRoleInfo();

    if (RI == none || GrenadeWeapon < 0 || RI.Grenades[GrenadeWeapon + 1].Item != none)
    {
        return -1;
    }

    return RI.Grenades[GrenadeWeapon + 1].Amount;
}

// Smooth field of view transition.
function AdjustView(float DeltaTime)
{
    if (FOVAngle != DesiredFOV)
    {
        FOVAngle -= FClamp(10.0 * DeltaTime, 0.0, 1.0) * (FOVAngle - DesiredFOV);

        if (Abs(FOVAngle - DesiredFOV) <= 0.0625)
        {
            FOVAngle = DesiredFOV;
        }
    }

    if (bZooming)
    {
        ZoomLevel = FMin(ZoomLevel + DeltaTime, DesiredZoomLevel);
        DesiredFOV = FClamp(90.0 - (ZoomLevel * 88.0), 1.0, 170.0);
    }
}

// Modified to avoid calling ResetFOV() if player is possessing a vehicle, because the vehicle will always set the FOV correctly anyway
// Fixes occasional network bug where ResetFOV() was received by a client AFTER vehicle had correctly set FOV, resulting in incorrect unmagnified view on a vehicle weapon
// Also a network optimisation as avoids a pointless replicated function call
function Possess(Pawn aPawn)
{
    local Pawn    OldPawn;
    local Vehicle V;

    if (PlayerReplicationInfo == none || PlayerReplicationInfo.bOnlySpectator || aPawn == none)
    {
        return;
    }

    OldPawn = Pawn;
    V = Vehicle(aPawn);

    if (V == none) // added this check to fix a bug & as a network optimisation
    {
        ResetFOV();
    }

    aPawn.PossessedBy(self); // if possessing vehicle, PossessedBy() calls ClientKDriverEnter() on owning client, so could use that to do other client stuff, avoiding further replicated functions?
    Pawn = aPawn;
    Pawn.bStasis = false;
    ResetTimeMargin(); // this gets called in Restart(), just after this, so appears unnecessary to have it here
    CleanOutSavedMoves(); // avoids replaying any moves prior to possession

    if (V != none && V.Driver != none)
    {
        PlayerReplicationInfo.bIsFemale = V.Driver.bIsFemale;
    }
    else
    {
        PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
    }

    ServerSetHandedness(Handedness);
    ServerSetAutoTaunt(bAutoTaunt); // this function has been emptied out in RO anyway
    Restart(); // this calls the replicated ClientRestart() function on the owning client
    StopViewShaking();

    // Stopped this replicated function being called when exiting a vehicle position, as it only resets bDuck & bCrawl, which aren't relevant in a vehicle
    // I'm sure we could optimise the network further by calling this from ClientRestart(), which is already being called on the owning client
    if (Vehicle(OldPawn) == none)
    {
        ClientResetMovement();
    }

    if (ROPawn(aPawn) != none)
    {
        ROPawn(aPawn).Setup(PawnSetupRecord, true);
    }
}

// Server call to client to force prone
function ClientProne()
{
    Prone();
}

// Modified to disallow this from being spammed without limits.
// As an added bonus, this solves a particular bug where players would end up
// in an odd state where their bipodded machine-guns would appear to be shooting
// blanks, likely as a result of a client-server state mismatch.
exec function ToggleDuck()
{
    if (Level.TimeSeconds >= NextToggleDuckTimeSeconds)
    {
        NextToggleDuckTimeSeconds = Level.TimeSeconds + ToggleDuckIntervalSeconds;

        super.ToggleDuck();
    }
}

// Server call to client to toggle duck
function ClientToggleDuck()
{
    ToggleDuck();
}

exec function ToggleRun()
{
    bToggleRun = !bToggleRun;
}

// Modified to network optimise by removing automatic call to replicated server function in a VehicleWeaponPawn
// Instead we let WVP's clientside IncrementRange() check that it's a valid operation before sending server call
exec function LeanRight()
{
    local DHPawn P;

    P = DHPawn(Pawn);

    if (P != none)
    {
        if (!P.bBipodDeployed)
        {
            P.LeanRight();
        }

        if (P.bLeanRight)
        {
            ServerLeanRight(true);
        }
    }
    else if (VehicleWeaponPawn(Pawn) != none)
    {
        VehicleWeaponPawn(Pawn).IncrementRange();
    }
}

exec function LeanLeft()
{
    local DHPawn P;

    P = DHPawn(Pawn);

    if (P != none)
    {
        if (!P.bBipodDeployed)
        {
            P.LeanLeft();
        }

        if (P.bLeanLeft)
        {
            ServerLeanLeft(true);
        }
    }
    else if (VehicleWeaponPawn(Pawn) != none && VehicleWeaponPawn(Pawn).Gun != none)
    {
        VehicleWeaponPawn(Pawn).Gun.DecrementRange();
    }
}

function ClientConsoleCommand(string Command, bool bWriteToLog)
{
    ConsoleCommand(Command, bWriteToLog);
}

simulated function NotifyHintRenderingDone()
{
    if (DHHintManager != none)
    {
        DHHintManager.NotifyHintRenderingDone();
    }
}

simulated function UpdateHintManagement(bool bUseHints)
{
    if (Level.GetLocalPlayerController() == self)
    {
        if (bUseHints && DHHintManager == none)
        {
            DHHintManager = Spawn(class'DHHintManager', self);

            if (DHHintManager == none)
            {
                Warn("Unable to spawn hint manager");
            }
        }
        else if (!bUseHints && DHHintManager != none)
        {
            DHHintManager.Destroy();
            DHHintManager = none;
        }

        if (!bUseHints && DHHud(myHUD) != none)
        {
            DHHud(myHUD).bDrawHint = false;
        }
    }
}

simulated function QueueHint(byte HintIndex, bool bForceNext)
{
    if (DHHintManager != none)
    {
        DHHintManager.QueueHint(HintIndex, bForceNext);
    }
}

// Modified to avoid "accessed none" errors
function bool CanRestartPlayer()
{
    local DHGameReplicationInfo DHGRI;

    DHGRI = DHGameReplicationInfo(GameReplicationInfo);

    if ((PlayerReplicationInfo != none && PlayerReplicationInfo.bOnlySpectator) || !bCanRespawn)
    {
        return false;
    }
    else if ((bIsInSpawnMenu && VehiclePoolIndex == -1) || !HasSelectedTeam() || !HasSelectedRole() || !HasSelectedWeapons() || !HasSelectedSpawn())
    {
        return false;
    }

    NextSpawnTime = GetNextSpawnTime(SpawnPointIndex, DHRoleInfo(GetRoleInfo()), VehiclePoolIndex);

    if (DHGRI.ElapsedTime < NextSpawnTime || DHGRI.ElapsedTime < DHGRI.SpawningEnableTime)
    {
        return false;
    }

    return true;
}

function bool HasSelectedSpawn()
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G != none && G.DHLevelInfo != none && G.DHLevelInfo.SpawnMode == ESM_DarkestHour)
    {
        return SpawnPointIndex != -1;
    }

    return true;
}

// Modified incase this ever gets called, make it 'replace' the deploy menu instead of old RoleMenu
simulated function ClientForcedTeamChange(int NewTeamIndex, int NewRoleIndex)
{
    // Store the new team and role info
    ForcedTeamSelectOnRoleSelectPage = NewTeamIndex;
    DesiredRole = NewRoleIndex;

    DeployMenuStartMode = MODE_Map;
    ClientReplaceMenu("DH_Interface.DHDeployMenu");
}

// Modified to avoid "accessed none" errors
function bool HasSelectedTeam()
{
    return PlayerReplicationInfo != none && PlayerReplicationInfo.Team != none && PlayerReplicationInfo.Team.TeamIndex < 2;
}

// Modified to fix nasty server crash and fix other bugs
function BecomeSpectator()
{
    if (Pawn != none)
    {
        Pawn.Suicide();
    }

    super.BecomeSpectator();
}

// Modified to call ToggleBehindView to avoid code repetition
exec function BehindView(bool B)
{
    if (B != bBehindView)
    {
        ToggleBehindView();
    }
}

// Modified to disallow behind view just because a player is a game admin (too open to abuse) & to deprecate use of vehicle's bAllowViewChange setting
// Not using DHDebugMode to enable this, as using behind view can cause crashes on busy maps
// To aid development & testing, a standalone PC or test server can easily be configured to allow behind view by adding bAllowBehindView=true to DarkestHour.ini file's [Engine.GameInfo] section
function ServerToggleBehindView()
{
    if (Level.NetMode == NM_Standalone || Level.Game.bAllowBehindView || PlayerReplicationInfo.bOnlySpectator)
    {
        ClientSetBehindView(!bBehindView); // a standalone or owning listen server will get this

        if (Viewport(Player) == none) // on a non-owning server, ClientSetBehindView() is sent to owning net client, so toggle server's local bBehindView setting
        {
            bBehindView = !bBehindView;
        }
    }
}

function ServerClearObstacle(int Index)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G != none && G.ObstacleManager != none)
    {
        G.ObstacleManager.ClearObstacle(Index);
    }
}

function ServerCutConstruction(DHConstruction C)
{
    if (C != none && Pawn != none)
    {
        C.CutConstruction(Pawn);
    }
}

// Keep this function as it's used as a control to show communication page allowing fast muting of players
exec function CommunicationMenu()
{
    ClientReplaceMenu("ROInterface.ROCommunicationPage");
}

// This function returns the time the player will be able to spawn next
// given some spawn parameters (DHRoleInfo and VehiclePoolIndex).
simulated function int GetNextSpawnTime(int SpawnPointIndex, DHRoleInfo RI, int VehiclePoolIndex)
{
    local int T;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (RI == none ||
        GRI == none ||
        PlayerReplicationInfo == none ||
        PlayerReplicationInfo.Team == none ||
        SpawnPointIndex < 0 ||
        SpawnPointIndex >= arraycount(GRI.SpawnPoints) ||
        GRI.SpawnPoints[SpawnPointIndex] == none)
    {
        return 0;
    }

    if (GRI.SpawnPoints[SpawnPointIndex].CanPlayerSpawnImmediately(self))
    {
        // Spawn point is allowing this player to spawn immediately!
        return -1;
    }

    // If player was spawn killed, set the respawn time to be the spawn kill respawn time
    if (bSpawnedKilled)
    {
        T = LastKilledTime + SPAWN_KILL_RESPAWN_TIME;
    }
    else
    {
        // LastKilledTime is 0 the first time a player joins a server, but if he leaves, the time is stored (using the sessions thing)
        // this means the player can pretty much spawn right away the first time connecting, but from then on he will be subject to the respawn time factors
        T = LastKilledTime + GRI.ReinforcementInterval[PlayerReplicationInfo.Team.TeamIndex] + RI.AddedRoleRespawnTime + GRI.SpawnPoints[SpawnPointIndex].GetSpawnTimePenalty();
    }

    if (VehiclePoolIndex != -1)
    {
        T = Max(T, GRI.VehiclePoolNextAvailableTimes[VehiclePoolIndex]);
        T = Max(T, NextVehicleSpawnTime);
    }

    return T;
}

// Modified to actually restart the sway process, not just stop it. This is only called when the player changes stances (crouch prone stand).
simulated function ResetSwayValues()
{
    SwayTime = 0.0;
}

// Calculate the weapon sway, modified for DH sway system (large sway from start, reduces, then averages)
simulated function SwayHandler(float DeltaTime)
{
    local DHPawn P;
    local DHWeapon W;
    local float  WeaponSwayYawAcc, WeaponSwayPitchAcc, StaminaFactor, TimeFactor, DeltaSwayYaw, DeltaSwayPitch, FlinchFactor;

    P = DHPawn(Pawn);

    if (P == none)
    {
        return;
    }

    W = DHWeapon(P.Weapon);

    if (W == none)
    {
        return;
    }

    SwayTime += DeltaTime;

    // Apply random sway movement periodically (using SwayClearTime as timer)
    if (SwayClearTime >= 0.025) // was 0.05
    {
        SwayClearTime = 0.0;
        WeaponSwayYawAcc = RandRange(-BaseSwayYawAcc, BaseSwayYawAcc);
        WeaponSwayPitchAcc = RandRange(-BaseSwayPitchAcc, BaseSwayPitchAcc);
    }
    else
    {
        SwayClearTime += DeltaTime;
        WeaponSwayYawAcc = 0.0;
        WeaponSwayPitchAcc = 0.0;
    }

    // Modify sway based on how long the player has been holding the weapon ironsighted
    StaminaFactor = ((P.default.Stamina - P.Stamina) / P.default.Stamina) * 0.5;
    TimeFactor = InterpCurveEval(SwayCurve, SwayTime);

    // Apply DH sway modifier
    TimeFactor *= W.SwayModifyFactor; // added option for weapon specific modifier

    WeaponSwayYawAcc = (TimeFactor * WeaponSwayYawAcc) + (StaminaFactor * WeaponSwayYawAcc);
    WeaponSwayPitchAcc = (TimeFactor * WeaponSwayPitchAcc) + (StaminaFactor * WeaponSwayPitchAcc);

    // Applied overall modifier for not moving
    if (P.bIsIdle)
    {
        WeaponSwayYawAcc *= W.SwayNotMovingModifier;
        WeaponSwayPitchAcc *= W.SwayNotMovingModifier;
    }

    // Reduce sway reduction if crouching, prone or resting the weapon (order in lowest first)
    if (P.bRestingWeapon)
    {
        WeaponSwayYawAcc *= W.SwayRestingModifier;
        WeaponSwayPitchAcc *= W.SwayRestingModifier;
    }
    else if (P.bIsCrawling)
    {
        WeaponSwayYawAcc *= W.SwayProneModifier;
        WeaponSwayPitchAcc *= W.SwayProneModifier;
    }
    else if (P.bIsCrouched)
    {
        WeaponSwayYawAcc *= W.SwayCrouchedModifier;
        WeaponSwayPitchAcc *= W.SwayCrouchedModifier;
    }

    // Increase sway if getting up from prone or if leaning
    if (P.IsProneTransitioning())
    {
        WeaponSwayYawAcc *= W.SwayTransitionModifier;
        WeaponSwayPitchAcc *= W.SwayTransitionModifier;
    }

    // Increase sway if leaning
    if (P.LeanAmount != 0.0)
    {
        WeaponSwayYawAcc *= W.SwayLeanModifier;
        WeaponSwayPitchAcc *= W.SwayLeanModifier;
    }

    // Increase sway if bayonet attached
    if (W.bBayonetMounted)
    {
        WeaponSwayYawAcc *= W.SwayBayonetModifier;
        WeaponSwayPitchAcc *= W.SwayBayonetModifier;
    }

    // Increase sway based on Flinch Meter
    FlinchFactor = FlinchMeterValue - GetFlinchMeterFalloff(Level.TimeSeconds - LastFlinchTime);

    if (FlinchFactor > 0.0)
    {
        WeaponSwayYawAcc *= 1.0 + (FlinchFactor * FlinchMeterSwayMultiplier);
        WeaponSwayPitchAcc *= 1.0 + (FlinchFactor * FlinchMeterSwayMultiplier);
    }

    // Add an elastic factor to get sway near the original aim-point, & a damping factor to keep elastic factor from causing wild oscillations
    WeaponSwayYawAcc = WeaponSwayYawAcc - (DHSwayElasticFactor * SwayYaw) - (DHSwayDampingFactor * WeaponSwayYawRate);
    WeaponSwayPitchAcc = WeaponSwayPitchAcc - (DHSwayElasticFactor * SwayPitch) - (DHSwayDampingFactor * WeaponSwayPitchRate);

    // If weapon is rested, SwayYaw & SwayPitch are zero
    if (P.bRestingWeapon)
    {
        SwayYaw = 0.0;
        SwayPitch = 0.0;
    }
    // Otherwise update SwayYaw & SwayPitch using basic equation of motion (deltaX = vt + 0.5 * a * t^2)
    else
    {
        DeltaSwayYaw = (WeaponSwayYawRate * DeltaTime) + (0.5 * WeaponSwayYawAcc * DeltaTime * DeltaTime);
        DeltaSwayPitch = (WeaponSwayPitchRate * DeltaTime) + (0.5 * WeaponSwayPitchAcc * DeltaTime * DeltaTime);

        SwayYaw += DeltaSwayYaw;
        SwayPitch += DeltaSwayPitch;
    }

    // Update new weapon sway sway speed (R = D*T)
    WeaponSwayYawRate += WeaponSwayYawAcc * DeltaTime;
    WeaponSwayPitchRate += WeaponSwayPitchAcc * DeltaTime;
}

// Modified to not allow IronSighting when transitioning to/from prone
exec simulated function ROIronSights()
{
    if (Pawn != none && Pawn.Weapon != none && !Pawn.IsProneTransitioning())
    {
        Pawn.Weapon.ROIronSights();
    }
}

// Client function to fade from black
function ClientFadeFromBlack(float time, optional bool bInvertFadeDirection)
{
    local ROHud H;

    H = ROHud(MyHud);

    if (H != none)
    {
        H.FadeToBlack(time, !bInvertFadeDirection);
    }
}

// Modified to allow for faster suiciding, annoying when it doesn't work in MP
// There might be some unknown problem that having such a low value can cause
// This might be a temporary function then that will need removed for non dev work
exec function Suicide()
{
    if (Pawn != none && Level.TimeSeconds - Pawn.LastStartTime > 1.0)
    {
        Pawn.Suicide();
    }
}

exec function SwitchTeam() { }
exec function ChangeTeam(int N) { }

// Modified to not join the opposite team if it fails to join the one passed (fixes a nasty exploit)
// This function verifies the spawn parameters (spawn point et al.) that
// are passed in, and sets them if they check out. If they don't check out, an
// error is thrown.
//
// TODO: This function is a fucking nightmare and needs to be refactored.
// Namely, the team selection should *not* be rolled into this function.
// It would be useful to roll up the "spawning parameters" (role, weapons,
// spawn point etc.) into a struct so that it's easier to understand what's
// going on.
function ServerSetPlayerInfo(byte newTeam, byte newRole, byte NewWeapon1, byte NewWeapon2, int NewSpawnPointIndex, int NewVehiclePoolIndex)
{
    local bool bDidFail;
    local DarkestHourGame Game;
    local DHRoleInfo RI;
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local byte OldTeamIndex;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    OldTeamIndex = GetTeamNum();

    // Attempt to change teams
    if (newTeam != 255)
    {
        if (NextChangeTeamTime >= GRI.ElapsedTime)
        {
            return;
        }

        // Spectate
        if (newTeam == 254)
        {
            BecomeSpectator();

            // Check if change was successful
            if (PlayerReplicationInfo == none || !PlayerReplicationInfo.bOnlySpectator)
            {
                if (PlayerReplicationInfo == none)
                {
                    ClientChangePlayerInfoResult(01);
                }
                else if (Level.Game.NumSpectators >= Level.Game.MaxSpectators)
                {
                    ClientChangePlayerInfoResult(02);
                }
                else if (IsInState('GameEnded'))
                {
                    ClientChangePlayerInfoResult(03);
                }
                else if (IsInState('RoundEnded'))
                {
                    ClientChangePlayerInfoResult(04);
                }
                else
                {
                    ClientChangePlayerInfoResult(99);
                }

                return;
            }
        }
        else
        {
            if (newTeam == 250) // auto select
            {
                if (PlayerReplicationInfo == none || PlayerReplicationInfo.bOnlySpectator)
                {
                    BecomeActivePlayer();
                }

                newTeam = ServerAutoSelectAndChangeTeam();
            }
            else if (ROTeamGame(Level.Game).PickTeam(newTeam, self) == newTeam)
            {
                if (PlayerReplicationInfo == none || PlayerReplicationInfo.bOnlySpectator)
                {
                    BecomeActivePlayer();
                }

                ServerChangeTeam(newTeam);
            }

            // Check if change failed and output results
            if (PlayerReplicationInfo == none ||
                PlayerReplicationInfo.Team == none ||
                PlayerReplicationInfo.Team.TeamIndex != newTeam)
            {
                if (PlayerReplicationInfo == none)
                {
                    ClientChangePlayerInfoResult(10);
                }
                else if (Level.Game.bMustJoinBeforeStart)
                {
                    ClientChangePlayerInfoResult(11);
                }
                else if (Level.Game.GetNumPlayers() >= Level.Game.MaxPlayers)
                {
                    ClientChangePlayerInfoResult(12);
                }
                else if (Level.Game.MaxLives > 0)
                {
                    ClientChangePlayerInfoResult(13);
                }
                else if (IsInState('GameEnded'))
                {
                    ClientChangePlayerInfoResult(14);
                }
                else if (IsInState('RoundEnded'))
                {
                    ClientChangePlayerInfoResult(15);
                }
                else if (Level.Game.bMustJoinBeforeStart && Level.Game.GameReplicationInfo.bMatchHasBegun)
                {
                    ClientChangePlayerInfoResult(16);
                }
                else if (ROTeamGame(Level.Game) != none && ROTeamGame(Level.Game).PickTeam(newTeam, self) != newTeam)
                {
                    if (ROTeamGame(Level.Game).bPlayersVsBots && Level.NetMode != NM_Standalone)
                    {
                        ClientChangePlayerInfoResult(17);
                    }
                    else
                    {
                        ClientChangePlayerInfoResult(18);
                    }
                }
                else
                {
                    ClientChangePlayerInfoResult(99);
                }

                return;
            }
        }
    }

    // Attempt to change role
    if (newRole != 255 && DesiredRole != NewRole)
    {
        ChangeRole(newRole);

        // Check if change was successful
        if (DesiredRole != newRole)
        {
            if (ROTeamGame(Level.Game) != none &&
                PlayerReplicationInfo != none &&
                PlayerReplicationInfo.Team != none &&
                ROTeamGame(Level.Game).RoleLimitReached(PlayerReplicationInfo.Team.TeamIndex, newRole))
            {
                ClientChangePlayerInfoResult(100);
            }
            else
            {
                ClientChangePlayerInfoResult(199);
            }

            return;
        }
    }

    // Set weapons
    ChangeWeapons(NewWeapon1, NewWeapon2, 0);

    // Team change event
    if (NewTeam != OldTeamIndex)
    {
        OnTeamChanged();
    }

    // Return result to client
    if (NewTeam == AXIS_TEAM_INDEX)
    {
        ClientChangePlayerInfoResult(97); // successfully picked axis team
    }
    else if (NewTeam == ALLIES_TEAM_INDEX)
    {
        ClientChangePlayerInfoResult(98); // successfully picked allies team
    }
    // TODO: doesn't appear necessary or useful to pass this new 96 success code for switching to a spectator (Matt, June 2017)
    // Only appears to require an override in DHGUITeamSelection.InternalOnMessage() to make it do exactly the same as if we just passed no.0 (as in RO for a spectator)
    else if (NewTeam == 254)
    {
        ClientChangePlayerInfoResult(96); // successfully picked spectator team
    }
    else
    {
        Game = DarkestHourGame(Level.Game);

        if (Game != none &&
            Game.DHLevelInfo != none &&
            Game.DHLevelInfo.SpawnMode == ESM_DarkestHour &&
            Game.SpawnManager != none)
        {
            // This map uses the DH deploy system, not an RO spawn room
            if (PlayerReplicationInfo != none && PlayerReplicationInfo.Team != none)
            {
                RI = DHRoleInfo(Game.GetRoleInfo(PlayerReplicationInfo.Team.TeamIndex, DesiredRole));
            }

            if (GRI != none && GRI.CanSpawnWithParameters(NewSpawnPointIndex, GetTeamNum(), DesiredRole, PRI.SquadIndex, NewVehiclePoolIndex, true))
            {
                if (NewVehiclePoolIndex != VehiclePoolIndex)
                {
                    // Vehicle pool changing, unreserve existing vehicle pool reservation (if it exists)
                    GRI.UnreserveVehicle(self);

                    if (!GRI.ReserveVehicle(self, NewVehiclePoolIndex))
                    {
                        bDidFail = true;
                    }
                }
            }

            if (!bDidFail)
            {
                SpawnPointIndex = NewSpawnPointIndex;
                NextSpawnTime = GetNextSpawnTime(SpawnPointIndex, RI, VehiclePoolIndex);

                bSpawnParametersInvalidated = false;

                // Everything is good
                ClientChangePlayerInfoResult(0);
            }
            else
            {
                SpawnPointIndex = default.SpawnPointIndex;
                VehiclePoolIndex = default.VehiclePoolIndex;
                NextSpawnTime = default.NextSpawnTime;

                // this needs commented on what it is doing, in fact most of this function does, very hard to follow
                ClientChangePlayerInfoResult(19);
            }
        }
        else
        {
            ClientChangePlayerInfoResult(0);
        }
    }
}

function OnTeamChanged()
{
    local DarkestHourGame G;
    local int TeamIndex;

    G = DarkestHourGame(Level.Game);

    if (G != none && G.VoteManager != none)
    {
        // Reset player's surrender status
        if (bSurrendered)
        {
            G.VoteManager.RemoveNomination(self, class'DHVoteInfo_TeamSurrender');
        }
    }

    // Update the player's linked score manager to their new team's score manager.
    if (ScoreManager != none)
    {
        TeamIndex = GetTeamNum();

        if (TeamIndex >= 0 && TeamIndex < arraycount(G.TeamScoreManagers))
        {
            ScoreManager.NextScoreManager = G.TeamScoreManagers[TeamIndex];
        }
        else
        {
            // Player joined spectators, clear the next score manager.
            ScoreManager.NextScoreManager = none;
        }
    }
}

// Overridden to fix accessed none errors
function EndZoom()
{
    if (myHUD != none && DesiredFOV != DefaultFOV)
    {
        myHUD.FadeZoom();
    }

    bZooming = false;
    DesiredFOV = DefaultFOV;
}

function Reset()
{
    super.Reset();

    WeaponUnlockTime = default.WeaponUnlockTime;
    WeaponLockViolations = default.WeaponLockViolations;
    NextSpawnTime = default.NextSpawnTime;
    SpawnPointIndex = default.SpawnPointIndex;
    VehiclePoolIndex = default.VehiclePoolIndex;
    NextChangeTeamTime = default.NextChangeTeamTime;
    LastKilledTime = default.LastKilledTime;
    NextVehicleSpawnTime = default.NextVehicleSpawnTime;
    FlinchMeterValue = 0.0;
    LastFlinchTime = 0.0;
}

function ServerSetIsInSpawnMenu(bool bIsInSpawnMenu)
{
    self.bIsInSpawnMenu = bIsInSpawnMenu;
}

// Modified to add 'Begin:' label, to avoid "label not found" error on ClientGotoState calls to send client to state 'Spectating' or 'PlayerWaiting' (both child states of this)
state BaseSpectating
{
Begin:
}

state DeadSpectating
{
    ignores SwitchWeapon, RestartLevel, ClientRestart, Suicide, ThrowWeapon, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange;

    function BeginState()
    {
        super.BeginState();

        if (!PlayerReplicationInfo.bOnlySpectator && bSpawnParametersInvalidated)
        {
            DeployMenuStartMode = MODE_Map;
            ClientProposeMenu("DH_Interface.DHDeployMenu");
        }
    }

    exec function Jump(optional float F)
    {
        TryToActivateSituationMap();
    }
}

state Dead
{
    ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon, NextWeapon, PrevWeapon;

    // Checks if there is a more desirable spawn point to use, and invalidates
    // the player's selected spawn point, forcing the user into the map upon death
    // to choose their spawn point.
    function MaybeInvalidateSpawnPoint(DHGameReplicationInfo GRI)
    {
        local int MaxDesirability;

        if (SpawnPointIndex == -1)
        {
            return;
        }

        GRI.GetMostDesirableSpawnPoint(self, MaxDesirability);

        if (GRI.SpawnPoints[SpawnPointIndex].GetDesirability() < MaxDesirability)
        {
            SpawnPointIndex = -1;
            bSpawnParametersInvalidated = true;
        }
    }

    function BeginState()
    {
        local DHGameReplicationInfo GRI;

        super.BeginState();

        if (Role == ROLE_Authority)
        {
            GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

            if (GRI != none)
            {
                LastKilledTime = GRI.ElapsedTime;

                MaybeInvalidateSpawnPoint(GRI);
            }

            if (IQManager != none)
            {
                IQManager.OnDeath();
            }

            // Apply personal message from server strings
            //ClientMessage(DarkestHourGame(Level.Game).GetServerMessage(PlayerReplicationInfo.Deaths - 1), 'ServerMessage');
        }
    }
}

// TODO: Check and confirm we actually need to override this
event ClientReplaceMenu(string Menu, optional bool bDisconnect, optional string Msg1, optional string Msg2)
{
    if (Player == none || (Player.Console != none && Player.Console.bTyping))
    {
        return;
    }

    if (!Player.GUIController.bActive)
    {
        if (!Player.GUIController.ReplaceMenu(Menu, Msg1, Msg2))
        {
            UnpressButtons();
        }
    }
    else
    {
        Player.GUIController.ReplaceMenu(Menu, Msg1, Msg2);
    }

    if (bDisconnect)
    {
        if (Player.Console != none)
        {
            Player.Console.DelayedConsoleCommand("Disconnect");
        }
        else
        {
            ConsoleCommand("Disconnect");
        }
    }
}

// Modified for DHObjectives
function vector GetObjectiveLocation(int Index)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none && GRI.DHObjectives[Index] != none)
    {
        return GRI.DHObjectives[Index].Location;
    }

    return vect(0.0, 0.0, 0.0);
}

// Modified to not have player automatically switch to best weapon when player requests to drop weapon
function ServerThrowWeapon()
{
    local vector TossVel;

    if (Pawn != none && Pawn.CanThrowWeapon())
    {
        TossVel = vector(GetViewRotation());
        TossVel = TossVel * ((Pawn.Velocity dot TossVel) + 150.0) + vect(0.0, 0.0, 100.0);
        Pawn.TossWeapon(TossVel);
    }
}

function PawnDied(Pawn P)
{
    local DarkestHourGame G;
    local DHGameReplicationInfo GRI;
    local DHRoleInfo RI;

    if (P == none)
    {
        return;
    }

    super.PawnDied(P);

    G = DarkestHourGame(Level.Game);
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (G != none && GRI != none)
    {
        RI = DHRoleInfo(G.GetRoleInfo(GetTeamNum(), DesiredRole));

        if (RI != none)
        {
            NextSpawnTime = GetNextSpawnTime(SpawnPointIndex, RI, VehiclePoolIndex);
        }
    }
}

// Emptied out as irrelevant to RO/DH (concerns UT2004 PowerUps) & can just cause "accessed none" log errors if keybound & used (if player in vehicle or has no inventory)
exec function PrevItem()
{
}

// Emptied out so human player doesn't receive "you picked up the [weapon name]" messages when they pick up a weapon
function HandlePickup(Pickup pick)
{
}

// Function emptied out as replaced by ClientAddHudDeathMessage()
function AddHudDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> DamageType)
{
}

// New function replacing RO's AddHudDeathMessage - only change is that it doesn't have the bNetOwner replication condition
// That seemed to sometimes prevent this replicated function being called on a net client, meaning that client didn't get the death message
// Also avoids showing a console death message at this stage - instead that gets handled in DHHud.AddDeathMessage() & is delayed until the screen DM is shown
simulated function ClientAddHudDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> DamageType)
{
    if (ROHud(myHud) != none)
    {
        ROHud(myHud).AddDeathMessage(Killer, Victim, DamageType);
    }
}

// Modified to avoid possible spamming of "accessed none" errors
function RORoleInfo GetRoleInfo()
{
    if (ROPlayerReplicationInfo(PlayerReplicationInfo) != none)
    {
        return ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo;
    }
}

// New function for server to tell client to copy string into it's clipboard
simulated function ClientCopyToClipboard(string Str)
{
    CopyToClipBoard(Str);
}

// Will have the client make a .txt file on their machine with the listplayers info in it, very useful to be able to copy ROIDs
function ServerListPlayers()
{
    local array<PlayerReplicationInfo> AllPRI;
    local int i;
    local string ParseString;

    if (Level.TimeSeconds - LastPlayerListTime < 0.9)
    {
        return;
    }

    LastPlayerListTime = Level.TimeSeconds;
    Level.Game.GameReplicationInfo.GetPRIArray(AllPRI);

    ClientOpenLogFile("listplayers"); //Open the logfile on the client

    for (i = 0; i < AllPRI.Length; ++i)
    {
        if (PlayerController(AllPRI[i].Owner) != none && AllPRI[i].PlayerName != "WebAdmin")
        {
            ClientMessage(Right("   " $ AllPRI[i].PlayerID, 3) $ ")" @ AllPRI[i].PlayerName @ " " $ PlayerController(AllPRI[i].Owner).GetPlayerIDHash());
            ParseString $= PlayerController(AllPRI[i].Owner).GetPlayerIDHash() @ AllPRI[i].PlayerName @ class'UString'.static.CRLF();
        }
        else
        {
            ClientMessage(Right("   " $ AllPRI[i].PlayerID, 3) $ ")" @ AllPRI[i].PlayerName);
        }

        ClientLogToFile(ParseString); //Write the name and ROID to the logfile
    }

    ClientCloseLogFile(); //Close and destroy the logfile
}

// Server to client function which has the client open a logfile with name = FileNameString
simulated function ClientOpenLogFile(String FileNameString)
{
    if (ClientLogFile == none)
    {
        ClientLogFile = Spawn(class'FileLog');

        if (ClientLogFile != none)
        {
            ClientLogFile.OpenLog(FileNameString, ".txt", true);
        }
    }
}

// Server to client function which will output a log file on the client with LogString outputted
simulated function ClientLogToFile(String LogString)
{
    if (ClientLogFile != none)
    {
        ClientLogFile.Logf(LogString);
    }
}

// Server to client function to tell the client to close/destroy the ClientLogFile
simulated function ClientCloseLogFile()
{
    if (ClientLogFile != none)
    {
        ClientLogFile.Destroy();
    }
}

// Similar to ClientOpenMenu(), but only opens menu if no menu is already open and the player isn't typing
event ClientProposeMenu(string Menu, optional string Msg1, optional string Msg2)
{
    // if player is typing don't open menu
    if (Player.Console.bTyping)
    {
        return;
    }

    // if player is in a menu don't open
    if (GUIController(Player.GUIController).ActivePage == none)
    {
        if (!Player.GUIController.OpenMenu(Menu, Msg1, Msg2))
        {
            UnPressButtons();
        }
    }
}

function ClientSaveROIDHash(string ROID)
{
    local HTTPRequest PatronRequest;
    local string PatronTier;

    ROIDHash = ROID;

    SaveConfig();

    // Get script based patron status (this should be removed once we fix the HTTP issue with MAC)
    PatronTier = class'DHAccessControl'.static.GetPatronTier(ROIDHash);

    // If we have script patron status, then set patron status on server
    if (PatronTier != "")
    {
        ServerSetPatronTier(PatronTier);
    }
    else // Else, check via HTTP request for patron status
    {
        PatronRequest = Spawn(class'HTTPRequest');
        PatronRequest.Method = "GET";
        PatronRequest.Host = "api.darklightgames.com";
        PatronRequest.Path = "/patrons/?search=" $ ROIDHash;
        PatronRequest.OnResponse = PatronRequestOnResponse;
        PatronRequest.Send();
    }
}

// Modified so if we just switched off manual reloading & player is in a cannon that's waiting to reload, we pass any different pending ammo type to the server
simulated function SetManualTankShellReloading(bool bUseManualReloading)
{
    local DHVehicleCannon Cannon;

    if (Role < ROLE_Authority && !bUseManualReloading && DHVehicleCannonPawn(Pawn) != none)
    {
        Cannon = DHVehicleCannonPawn(Pawn).Cannon;

        if (Cannon != none && Cannon.ReloadState == RL_Waiting)
        {
            Cannon.CheckUpdatePendingAmmo();
        }
    }

    super.SetManualTankShellReloading(bUseManualReloading);
}

// Modified to use DH cannon class & AttemptReload() function, instead of deprecated ROTankCannon & ServerManualReload()
function ServerSetManualTankShellReloading(bool bUseManualReloading)
{
    local DHVehicleCannon Cannon;

    bManualTankShellReloading = bUseManualReloading;

    // If we just switched off manual reloading & player is in a cannon that is waiting to reload, try to start a reload
    if (!bManualTankShellReloading && DHVehicleCannonPawn(Pawn) != none)
    {
        Cannon = DHVehicleCannonPawn(Pawn).Cannon;

        if (Cannon != none && Cannon.ReloadState == RL_Waiting)
        {
            Cannon.AttemptReload();
        }
    }
}

// New function to set the bLockTankOnEntry option, which is enabled/disabled from the game settings menu
simulated function SetLockTankOnEntry(bool bEnabled)
{
    local DHArmoredVehicle    AV;
    local DHVehicleWeaponPawn WP;

    bLockTankOnEntry = bEnabled;

    // If the option has just been enabled & the player is in a tank crew position in an armored vehicle, try to automatically lock it now
    if (Role == ROLE_Authority)
    {
        if (bLockTankOnEntry && Vehicle(Pawn) != none)
        {
            if (Pawn.IsA('DHArmoredVehicle'))
            {
                AV = DHArmoredVehicle(Pawn);
            }
            else if (Pawn.IsA('DHVehicleWeaponPawn'))
            {
                WP = DHVehicleWeaponPawn(Pawn);

                if (WP.bMustBeTankCrew)
                {
                    WP.GetArmoredVehicleBase(AV);
                }
            }

            // Player hasn't just entered vehicle, but the functionality is identical & UpdateVehicleLockOnPlayerEntering() will do what we need
            if (AV != none && !AV.bVehicleLocked)
            {
                AV.UpdateVehicleLockOnPlayerEntering(Vehicle(Pawn));
            }
        }
    }
    // Or of we're a net client, pass the new setting to the server
    else
    {
        ServerSetLockTankOnEntry(bLockTankOnEntry);
    }
}

// New client-to-server replicated function to set the bLockTankOnEntry option on a server
function ServerSetLockTankOnEntry(bool bEnabled)
{
    SetLockTankOnEntry(bEnabled);
}

// New function to put player into 'weapon lock' for a specified number of seconds, during which time he won't be allowed to fire
simulated function LockWeapons(int Seconds)
{
    if (Seconds > 0 && GameReplicationInfo != none)
    {
        WeaponUnlockTime = GameReplicationInfo.ElapsedTime + Seconds;

        // If this is the local player, release his fire buttons
        if (Viewport(Player) != none)
        {
            bFire = 0; // 'releases' fire button if being held down, which stops automatic weapon fire from continuing & avoids spamming repeated messages & buzz sounds
            bAltFire = 0;
        }
        // Or a server calls replicated function to do similar on an owning net client (passing seconds as a byte for efficient replication)
        else if (Role == ROLE_Authority)
        {
            ClientLockWeapons(Seconds); // Force weapon lock on client
        }
    }
    // Hacky fix for problem where player re-joins server with an active weapon lock saved in his DHPlayerSession, but client doesn't yet have GRI
    // If we don't yet have GRI, we record a PendingWeaponLockSeconds  on client, then PostNetReceive() uses it to set weapon lock as soon as it receives GRI
    else if (GameReplicationInfo == none)
    {
        PendingWeaponLockSeconds  = Seconds;
    }
}

// New server-to-client replicated function to put owning net player into 'weapon lock' for a specified number of seconds, during which time he won't be allowed to fire
simulated function ClientLockWeapons(byte Seconds)
{
    if (Role < ROLE_Authority)
    {
        LockWeapons(Seconds);
    }
}

// New function to check whether player's weapons are locked (due to spawn killing) but are now due to be unlocked
// Called from the 1 second timer running continually in the GameInfo & GRI actors (GRI for net clients)
simulated function CheckUnlockWeapons()
{
    if (WeaponUnlockTime > 0 && GameReplicationInfo != none && GameReplicationInfo.ElapsedTime >= WeaponUnlockTime)
    {
        WeaponUnlockTime = 0; // reset this now, as when set it effectively acts as a flag that weapons are locked
        ReceiveLocalizedMessage(class'DHWeaponsLockedMessage', 2); // "Your weapons are now unlocked"
    }
}

// New helper function to check whether player's weapons are locked due to spawn killing, so he's unable to fire, including warning message on screen.
// TODO: Make this return an enum as to the weapon lock reason and leave it up to the caller to send the messages.
simulated function bool AreWeaponsLocked(optional bool bNoScreenMessage)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none && (WeaponUnlockTime > GRI.ElapsedTime || GRI.bIsInSetupPhase))
    {
        if (!bNoScreenMessage)
        {
            if (GRI.bIsInSetupPhase)
            {
                ReceiveLocalizedMessage(class'DHWeaponsLockedMessage', 3,,, self); // "Your weapons are locked during the setup phase"
            }
            else
            {
                ReceiveLocalizedMessage(class'DHWeaponsLockedMessage', 1,,, self); // "Your weapons are locked for X seconds"
            }
        }

        return true;
    }

    return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New helper function to check whether debug execs can be run
simulated function bool IsDebugModeAllowed()
{
    return Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode();
}

// Modified to ignore the Super in ROPlayer, which mostly added repeated info (player name & our state), plus pretty useless bCrawl, all badly formatted
// And to also show the PlayerController's rotation & location
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    super(UnrealPlayer).DisplayDebug(Canvas, YL, YPos);

    Canvas.SetPos(4.0, YPos);
    Canvas.SetDrawColor(255, 0, 0);
    Canvas.DrawText("     Location:" @ Location @ " Rotation:" @ Rotation);
    YPos += YL;
    Canvas.SetPos(4.0, YPos);

    Canvas.SetPos(4.0, YPos);
    Canvas.SetDrawColor(0, 0, 255);
    Canvas.DrawText("     *******FlinchMeterValue*******:" @ FlinchMeterValue);
    YPos += YL;
    Canvas.SetPos(4.0, YPos);
}

// New debug exec to put self into 'weapon lock' for specified number of seconds
exec function DebugLockWeapons(int Seconds)
{
    if (IsDebugModeAllowed())
    {
        ServerLockWeapons(Seconds);
    }
}

function ServerLockWeapons(int Seconds)
{
    LockWeapons(Seconds);
}

// Modified to work in debug mode, as well as in single player
exec function FOV(float F)
{
    if (IsDebugModeAllowed())
    {
        DefaultFOV = FClamp(F, 1.0, 170.0);
        DesiredFOV = DefaultFOV;
    }
}

// New debug exec for an easy way to write to log in-game, on both server & client in multi-player
exec function DoLog(string LogMessage)
{
    // Note bSilentAdmin won't work on a net client as bSilentAdmin isn't replicated (unlike bAdmin), so client can't tell that player is logged in
    if (LogMessage != "" && (IsDebugModeAllowed() || (PlayerReplicationInfo.bAdmin || PlayerReplicationInfo.bSilentAdmin)))
    {
        Log(GetHumanReadableName() @ ":" @ LogMessage);

        if (Role < ROLE_Authority)
        {
            ServerDoLog(LogMessage);
        }
    }
}

function ServerDoLog(string LogMessage)
{
    if (LogMessage != "" && (IsDebugModeAllowed() || (PlayerReplicationInfo.bAdmin || PlayerReplicationInfo.bSilentAdmin)))
    {
        Log(GetHumanReadableName() @ ":" @ LogMessage);
    }
}

exec function DebugObstacles(optional int Option)
{
    local DHObstacleInfo OI;

    if (IsDebugModeAllowed())
    {
        foreach AllActors(class'DHObstacleInfo', OI)
        {
            Log("DHObstacleInfo.Obstacles.Length =" @ OI.Obstacles.Length);

            break;
        }

        ServerDebugObstacles(Option);
    }
}

function ServerDebugObstacles(optional int Option)
{
    if (IsDebugModeAllowed() && DarkestHourGame(Level.Game) != none)
    {
        DarkestHourGame(Level.Game).ObstacleManager.DebugObstacles(Option);
    }
}

// Debug exec for queued hints
exec function DebugHints()
{
    local DHHintManager.HintInfo Hint;
    local int i;

    if (IsDebugModeAllowed())
    {
        if (DHHintManager != none)
        {
            Log("DHHintManager: CurrentHintIndex =" @ DHHintManager.CurrentHintIndex @ " QueuedHintIndices.Length =" @ DHHintManager.QueuedHintIndices.Length
                @ " state =" @ DHHintManager.GetStateName());

            for (i = 0; i < DHHintManager.QueuedHintIndices.Length; ++i)
            {
                Hint = DHHintManager.GetHint(DHHintManager.QueuedHintIndices[i]);
                Log("QueuedHintIndices[" $ i $ "] =" @ DHHintManager.QueuedHintIndices[i] @ Left(Hint.Title, 40) @ Left(Hint.Text, 80));
            }

            for (i = 0; i < DHHintManager.HINT_COUNT; ++i)
            {
                if (DHHintManager.bUsedUpHints[i] == 1)
                {
                    Hint = DHHintManager.GetHint(i);
                    Log("bUsedUpHints[" $ i $ "] :" @ Left(Hint.Title, 40) @ Left(Hint.Text, 80));
                }
            }

            Log("=====================================================================================================");
        }
    }
}

// New debug exec to play a sound (playing sounds in RO editor often doesn't work, so this is just a way of trying out sounds)
exec function SoundPlay(string SoundName, optional float Volume)
{
    local sound SoundToPlay;

    if (IsDebugModeAllowed() && SoundName != "")
    {
        SoundToPlay = sound(DynamicLoadObject(SoundName, class'Sound'));

        if (SoundToPlay != none)
        {
            ClientPlaySound(SoundToPlay, Volume > 0.0, Volume);
            Log("Playing sound" @ SoundToPlay @ " Volume =" @ Volume @ " Duration =" @ GetSoundDuration(SoundToPlay));
        }
    }
}

// Modified to shift this functionality into DHHud, where it's directly relevant & where some necessary stuff is added to make this RO function work as designed
exec function PlayerCollisionDebug()
{
    if (DHHud(MyHud) != none)
    {
        DHHud(MyHud).PlayerCollisionDebug();
    }
}

// Modified to use DH version of debug mode
exec function ClearLines()
{
    if (IsDebugModeAllowed())
    {
        ClearStayingDebugLines();
    }
}

// New debug exec to clear debug tracer arrows
exec function ClearArrows()
{
    local RODebugTracer Tracer;

    if (IsDebugModeAllowed())
    {
        foreach DynamicActors(class'RODebugTracer', Tracer)
        {
            Tracer.Destroy();
        }
    }
}

// New exec that respawns the player, but leaves their old pawn body behind, frozen in the game
// Optional bKeepPRI means the old body copy keeps a reference to the player's PRI, so it still shows your name in HUD, with any resupply/reload message
// TODO: for some reason when you kill a 'LeaveBody' pawn that is not in a vehicle, the pawn actor does not get destroyed on the server
// Debugged as far as it entering state Dying & in its BeginState() the LifeSpan being set to 1.0 second on a dedicated server
// But something seems to override that as pawn isn't destroyed & if you log it later it has LifeSpan=0.0 (NB - it's still in state Dying, with no timer running)
exec function LeaveBody(optional bool bKeepPRI)
{
    local DHVehicleWeaponPawn WP;
    local DHVehicle           V;
    local Pawn                OldPawn;

    if (IsDebugModeAllowed() && Pawn != none)
    {
        // If player is in vehicle with an interior mesh, switch to default exterior mesh & play the appropriate animations to put vehicle & player in correct position
        V = DHVehicle(Pawn);

        if (V != none)
        {
            if (V.Mesh != V.default.Mesh)
            {
                V.LinkMesh(V.default.Mesh);
                V.SetPlayerPosition();
            }
        }
        else
        {
            WP = DHVehicleWeaponPawn(Pawn);

            if (WP != none && WP.Gun != none && WP.Gun.Mesh != WP.Gun.default.Mesh)
            {
                WP.Gun.LinkMesh(WP.Gun.default.Mesh);
                WP.SetPlayerPosition();
            }
        }

        OldPawn = Pawn;
        ServerLeaveBody(bKeepPRI);

        // Attempt to fix 'pin head', where pawn's head is shrunk to 10% by state Dead.BeginState() - but generally ineffective as happens before state Dead (ViewTarget is key)
        if (DHPawn(OldPawn) != none)
        {
            OldPawn.SetHeadScale(OldPawn.default.HeadScale);
        }
    }
}

function ServerLeaveBody(optional bool bKeepPRI)
{
    local Vehicle           V;
    local VehicleWeaponPawn WP;

    if (IsDebugModeAllowed() && Pawn != none)
    {
        Pawn.UnPossessed();

        if (bKeepPRI)
        {
            Pawn.PlayerReplicationInfo = PlayerReplicationInfo;
        }

        V = Vehicle(Pawn);

        if (V != none)
        {
            V.Throttle = 0.0;
            V.Steering = 0.0;
            V.Rise = 0.0;

            WP = VehicleWeaponPawn(V);

            // If player was in a VehicleWeapon, reset properties (similar to KdriverLeave & now DriverDied as well)
            // Resetting bActive is critical, otherwise weapon swings around when vehicle is driven
            if (WP != none && WP.Gun != none)
            {
                WP.Gun.bActive = false;
                WP.Gun.FlashCount = 0;
                WP.Gun.NetUpdateFrequency = WP.Gun.default.NetUpdateFrequency;
                WP.Gun.NetPriority = WP.Gun.default.NetPriority;
            }
        }
        else
        {
            Pawn.Velocity = vect(0.0, 0.0, 0.0);
            Pawn.SetPhysics(PHYS_None);
        }

        Pawn = none;
    }
}

// New exec, used with LeaveBody(), as a clientside fix for annoying bug where old pawn's head shrinks to 10% size! - can be used when head location accuracy is important
exec function FixPinHead()
{
    local ROPawn TargetPawn;

    if (IsDebugModeAllowed() && ROPawn(Pawn) != none)
    {
        TargetPawn = ROPawn(ROPawn(Pawn).AutoTraceActor);

        if (TargetPawn != none)
        {
            TargetPawn.SetHeadScale(TargetPawn.default.HeadScale);
        }
    }
}

// New exec that reverses LeaveBody(), allowing the player 'reclaim' their old pawn body (& killing off their current pawn)
exec function PossessBody()
{
    local Pawn   TargetPawn;

    if (IsDebugModeAllowed() && ROPawn(Pawn) != none)
    {
        TargetPawn = ROPawn(ROPawn(Pawn).AutoTraceActor);

        // Only proceed if body's PRI matches the player (so must have been their old body, left using bKeepPRI option), or if body belongs to no one
        if (TargetPawn != none && (TargetPawn.PlayerReplicationInfo == PlayerReplicationInfo || TargetPawn.PlayerReplicationInfo == none))
        {
            ServerPossessBody(TargetPawn);

            if (TargetPawn.PlayerReplicationInfo == PlayerReplicationInfo)
            {
                TargetPawn.bOwnerNoSee = TargetPawn.default.bOwnerNoSee; // have to set this clientside to stop it drawing the player's body in 1st person
            }
        }
    }
}

function ServerPossessBody(Pawn NewPawn)
{
    if (IsDebugModeAllowed() && NewPawn != none)
    {
        // If the pawn body is already associated with the player (shares PRI) then possess it & kill off current pawn
        if (NewPawn.PlayerReplicationInfo == PlayerReplicationInfo)
        {
            Pawn.Died(none, class'DamageType', vect(0.0, 0.0, 0.0));
            Unpossess();
            Possess(NewPawn);
        }
        // Otherwise, if pawn body 'belongs' to no one (no PRI) then associate it with the player, so his name & resupply status appears on the HUD
        // Then a repeat of PossessBody() will allow him to possess the 2nd time
        else if (NewPawn.PlayerReplicationInfo == none)
        {
            NewPawn.PlayerReplicationInfo = PlayerReplicationInfo;
        }
    }
}

// New debug exec to trigger or un-trigger a specified event
exec function DebugEvent(name EventToTrigger, optional bool bUntrigger)
{
    if (IsDebugModeAllowed() && EventToTrigger != '')
    {
        if (bUntrigger)
        {
            Log("DebugEvent: UN-triggering event" @ EventToTrigger);
            UnTriggerEvent(EventToTrigger, none, none);
        }
        else
        {
            Log("DebugEvent: triggering event" @ EventToTrigger);
            TriggerEvent(EventToTrigger, none, none);
        }
    }
}

// Used for finding pesky "raptor" actors sitting at world origin.
exec simulated function DebugRaptor()
{
    local Actor A;

    foreach AllActors(class'Actor', A)
    {
        if (A.Location == vect(0, 0, 0) &&
            A.DrawType == DT_Sprite &&
            !A.bHidden)
        {
            Log(A);
        }
    }
}

exec function GetMyLocation()
{
    local string s;

    if (IsDebugModeAllowed())
    {
        s = "(X=" $ ViewTarget.Location.X $ ",Y=" $ ViewTarget.Location.Y $ ",Z=" $ ViewTarget.Location.Z $ ")";
        player.console.Message(s, 1.0);
        CopyToClipBoard(s);
    }
}

exec function GetMyRotation()
{
    local string s;

    if (IsDebugModeAllowed())
    {
        s = "(Pitch=" $ Rotation.Pitch $ ",Yaw=" $ Rotation.Yaw $ ",Roll=" $ Rotation.Roll $ ")";
        player.console.Message(s, 1.0);
        CopyToClipBoard(s);
    }
}

exec function SetMyLocation(vector NewLocation)
{
    if (IsDebugModeAllowed())
    {
        ViewTarget.SetLocation(NewLocation);
    }
}

exec function SetMyRotation(rotator NewRotation)
{
    if (IsDebugModeAllowed())
    {
        SetRotation(NewRotation);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************** VEHICLE DEBUG EXEC FUNCTIONS  *************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New helper function to check whether debug execs can be run on a vehicle that we are in
// For convenience it also returns a reference to our DHVehicle base
// Avoids code repetition & nesting in lots of vehicle-related debug execs
simulated function bool IsVehicleDebugModeAllowed(out DHVehicle V)
{
    if (IsDebugModeAllowed())
    {
        V = DHVehicle(Pawn);

        if (V == none && VehicleWeaponPawn(Pawn) != none)
        {
            V = DHVehicle(VehicleWeaponPawn(Pawn).VehicleBase);
        }
    }

    return V != none;
}

// New debug exec to turn player's vehicle translucent, which is very useful for debugging things like vehicle hit points
exec function VehicleTranslucent(optional bool bRevert)
{
    local DHVehicle     V;
    local array<Shader> TranslucentSkins;
    local Material      NormalSkin;
    local int           Index, i, j;

    if (IsVehicleDebugModeAllowed(V))
    {
        // Re-skin the hull
        for (i = 0; i < V.Skins.Length; ++i)
        {
            if (V.Skins[i] != V.LeftTreadPanner && V.Skins[i] != V.RightTreadPanner) // ignore the treads as they are VariableTexPanners
            {
                if (!bRevert)
                {
                    Index = TranslucentSkins.Length;
                    TranslucentSkins[Index] = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                    TranslucentSkins[Index].Diffuse = V.default.Skins[i];
                    TranslucentSkins[Index].OutputBlending = OB_Translucent;
                    V.Skins[i] = TranslucentSkins[Index];
                }
                else
                {
                    if (Shader(V.Skins[i]) != none) // clean up the translucent skin objects we created
                    {
                        Shader(V.Skins[i]).Diffuse = none;
                        Level.ObjectPool.FreeObject(V.Skins[i]);
                    }

                    V.Skins[i] = V.default.Skins[i];
                }
            }
        }

        // Re-skin vehicle weapons
        for (j = 0; j < V.WeaponPawns.Length; ++j)
        {
            if (V.WeaponPawns[j] != none && V.WeaponPawns[j].Gun != none)
            {
                for (i = 0; i < V.WeaponPawns[j].Gun.Skins.Length; ++i)
                {
                    if (V.WeaponPawns[j].Gun.IsA('DHVehicleCannon') && i < V.CannonSkins.Length && V.CannonSkins[i] != none)
                    {
                        NormalSkin = V.CannonSkins[i];
                    }
                    else if (i == 0 && V.WeaponPawns[j].Gun.IsA('DHVehicleMG') && DHVehicleMG(V.WeaponPawns[j].Gun).bMatchSkinToVehicle)
                    {
                        NormalSkin = V.Skins[i];
                    }
                    else
                    {
                        NormalSkin = V.WeaponPawns[j].Gun.default.Skins[i];
                    }

                    if (!bRevert)
                    {
                        Index = TranslucentSkins.Length;
                        TranslucentSkins[Index] = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                        TranslucentSkins[Index].Diffuse = NormalSkin;
                        TranslucentSkins[Index].OutputBlending = OB_Translucent;
                        V.WeaponPawns[j].Gun.Skins[i] = TranslucentSkins[Index];
                    }
                    else
                    {
                        if (Shader(V.WeaponPawns[j].Gun.Skins[i]) != none)
                        {
                            Shader(V.WeaponPawns[j].Gun.Skins[i]).Diffuse = none;
                            Level.ObjectPool.FreeObject(V.WeaponPawns[j].Gun.Skins[i]);
                        }

                        V.WeaponPawns[j].Gun.Skins[i] = NormalSkin;
                    }
                }
            }
        }
    }
}

// New debug exec to show vehicle damage status
exec function LogVehDamage()
{
    local DHVehicle V;
    local string    DamageText;

    if (IsVehicleDebugModeAllowed(V))
    {
        DamageText = V.VehicleNameString @ "Health =" @ V.Health @ " EngineHealth =" @ V.EngineHealth
            @ " bLeftTrackDamaged =" @ V.bLeftTrackDamaged @ " bRightTrackDamaged =" @ V.bRightTrackDamaged @ " IsDisabled =" @ V.IsDisabled();

        Pawn.ClientMessage(DamageText);
        Log(DamageText);
    }
}

// New debug exec to log all vehicle base attachments
exec function LogVehAttach(optional bool bIncludeAttachedArray)
{
    local DHVehicle V;
    local int       i;

    if (IsVehicleDebugModeAllowed(V))
    {
        Log("-----------------------------------------------------------");
        Log(Caps(V.VehicleNameString) @ "ATTACHMENTS:");

        if (V.VehicleAttachments.Length > 0)
        {
            for (i = 0; i < V.VehicleAttachments.Length; ++i)
            {
                LogAttachment("VehicleAttachments[" $ i $ "] =", V.VehicleAttachments[i].Actor);
            }

            Log("-----------------------------------------------------------");
        }

        if (V.CollisionAttachments.Length > 0)
        {
            for (i = 0; i < V.CollisionAttachments.Length; ++i)
            {
                LogAttachment("CollisionAttachments[" $ i $ "] =", V.CollisionAttachments[i].Actor);
            }

            Log("-----------------------------------------------------------");
        }

        if (bIncludeAttachedArray && V.Attached.Length > 0)
        {
            for (i = 0; i < V.Attached.Length; ++i)
            {
                LogAttachment("Attached[" $ i $ "] =", V.Attached[i]);
            }

            Log("-----------------------------------------------------------");
        }
    }
}

// New helper function for 'LogAttached' debug exec
simulated function LogAttachment(string LogPrefix, Actor A)
{
    if (A == none)
    {
        Log(LogPrefix @ "None");
    }
    else if (A.DrawType == DT_StaticMesh)
    {
        Log(LogPrefix @ A.Tag @ " StaticMesh =" @ A.StaticMesh);
    }
    else
    {
        Log(LogPrefix @ A.Tag);
    }
}

// New debug exec to adjust the gear ratio settings, which largely govern the vehicle's speed (mainly GearRatios(4))
exec function SetGearRatio(byte Index, float NewValue)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && Index < arraycount(V.GearRatios))
    {
        Log(V.VehicleNameString @ "GearRatios[" $ Index $ "] =" @ NewValue @ "(was" @ V.GearRatios[Index] $ ")");
        V.GearRatios[Index] = NewValue;
    }
}

// New debug exec to adjust the TransRatio, which affects the vehicle's speed (along with GearRatios)
exec function SetTransRatio(float NewValue)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V))
    {
        Log(V.VehicleNameString @ "TransRatio =" @ NewValue @ "(was" @ V.TransRatio $ ")");
        V.TransRatio = NewValue;
    }
}

// New debug exec to set a vehicle's ExitPositions (use it in single player; it's too much hassle on a server)
exec function SetExitPos(byte Index, int NewX, int NewY, int NewZ)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && Index < V.ExitPositions.Length)
    {
        Log(V.VehicleNameString @ "ExitPositions[" $ Index $ "] =" @ NewX @ NewY @ NewZ @ "(was" @ V.ExitPositions[Index] $ ")");
        V.ExitPositions[Index].X = NewX;
        V.ExitPositions[Index].Y = NewY;
        V.ExitPositions[Index].Z = NewZ;
    }
}

// New debug exec to get offset coordinates from nearby vehicle(s) to create/adjust vehicle exit positions (only works in singleplayer)
exec function ExitPosTool()
{
    local ROVehicle NearbyVeh;
    local vector    Offset;

    if (IsDebugModeAllowed())
    {
        foreach RadiusActors(class'ROVehicle', NearbyVeh, 300.0, Pawn.Location)
        {
            Offset = (Pawn.Location - NearbyVeh.Location) << NearbyVeh.Rotation;
            Log("Vehicle:" @ NearbyVeh.GetHumanReadableName() @ "(X=" $ Round(Offset.X) $ ",Y=" $ Round(Offset.Y) $ ",Z=" $ Round(Offset.Z) $ ")");
        }
    }
}

// New debug exec to draw the location of a vehicle's exit positions, which are shown as different coloured cylinders
exec function DrawExits(optional bool bClearScreen)
{
    local DHVehicle V;
    local vector    ExitPosition, ZOffset, X, Y, Z;
    local color     C;
    local int       i;

    ClearLines();

    if (!bClearScreen && IsVehicleDebugModeAllowed(V))
    {
        ZOffset = class'DHPawn'.default.CollisionHeight * vect(0.0, 0.0, 0.5);
        GetAxes(V.Rotation, X, Y, Z);

        for (i = V.ExitPositions.Length - 1; i >= 0; --i)
        {
            if (i == 0)
            {
                C = class'HUD'.default.BlueColor; // driver
            }
            else
            {
                if (i - 1 < V.WeaponPawns.Length)
                {
                    if (DHVehicleCannonPawn(V.WeaponPawns[i - 1]) != none)
                    {
                        C = class'HUD'.default.RedColor; // commander
                    }
                    else if (DHVehicleMGPawn(V.WeaponPawns[i - 1]) != none)
                    {
                        C = class'HUD'.default.GoldColor; // machine gunner
                    }
                    else
                    {
                        C = class'HUD'.default.WhiteColor; // rider
                    }
                }
                else
                {
                    C = class'HUD'.default.GrayColor; // something outside of WeaponPawns array, so not representing a particular vehicle position
                }
            }

            ExitPosition = V.Location + (V.ExitPositions[i] >> V.Rotation) + ZOffset;
            class'DHLib'.static.DrawStayingDebugCylinder(V, ExitPosition, X, Y, Z, class'DHPawn'.default.CollisionRadius, class'DHPawn'.default.CollisionHeight, 10, C.R, C.G, C.B);
        }
    }
}

// New debug exec to adjust a vehicle's DrivePos (vehicle occupant positional offset from attachment bone)
exec function SetDrivePos(string NewX, string NewY, string NewZ)
{
    local Vehicle V;

    if (IsDebugModeAllowed())
    {
        V = Vehicle(Pawn);

        if (V != none && V.Driver != none)
        {
            Log(V.Tag @ " new DrivePos =" @ float(NewX) @ float(NewY) @ float(NewZ) @ "(was" @ V.DrivePos $ ")");
            V.DrivePos.X = float(NewX);
            V.DrivePos.Y = float(NewY);
            V.DrivePos.Z = float(NewZ);
            V.DetachDriver(V.Driver);
            V.AttachDriver(V.Driver);
        }
    }
}

// New debug exec to adjust a vehicle's DriveRot (vehicle occupant's rotation from attachment bone)
exec function SetDriveRot(int NewPitch, int NewYaw, int NewRoll)
{
    local Vehicle V;

    if (IsDebugModeAllowed())
    {
        V = Vehicle(Pawn);

        if (V != none && V.Driver != none)
        {
            Log(V.Tag @ " new DriveRot =" @ NewPitch @ NewYaw @ NewRoll @ "(was" @ V.DriveRot $ ")");
            V.DriveRot.Pitch = NewPitch;
            V.DriveRot.Yaw = NewYaw;
            V.DriveRot.Roll = NewRoll;
            V.DetachDriver(V.Driver);
            V.AttachDriver(V.Driver);
        }
    }
}

// New debug exec to change the player animation in a vehicle position
exec function SetDriveAnim(name NewAnim)
{
    local Vehicle V;

    if (IsDebugModeAllowed())
    {
        V = Vehicle(Pawn);

        if (V != none && V.Driver != none)
        {
            V.DriveAnim = NewAnim;
            V.Driver.StopAnimating(true);
            V.Driver.LoopAnim(V.DriveAnim);
        }
    }
}

// New debug exec to set a vehicle position's 1st person camera position offset
exec function SetCamPos(string NewX, string NewY, string NewZ)
{
    local Vehicle             V;
    local ROVehicleWeaponPawn WP;
    local vector              OldCamPos;

    if (IsDebugModeAllowed())
    {
        V = Vehicle(Pawn);

        if (V != none)
        {
            OldCamPos = V.FPCamPos;
            V.FPCamPos.X = float(NewX);
            V.FPCamPos.Y = float(NewY);
            V.FPCamPos.Z = float(NewZ);
            WP = ROVehicleWeaponPawn(V);

            if (WP != none && WP.bMultiPosition)
            {
                WP.DriverPositions[WP.DriverPositionIndex].ViewLocation = V.FPCamPos;
                Log(WP.Tag @ "DriverPositions[" $ WP.DriverPositionIndex $ "].ViewLocation =" @ WP.DriverPositions[WP.DriverPositionIndex].ViewLocation @ "(old was" @ OldCamPos $ ")");
            }
            else
            {
                Log(V.Tag @ "FPCamPos =" @ V.FPCamPos @ "(old was" @ OldCamPos $ ")");
            }
        }
    }
}

// New debug exec to set a vehicle's 3rd person camera distance
exec function VehCamDist(int NewDistance)
{
    local Vehicle V;

    if (IsDebugModeAllowed())
    {
        V = Vehicle(Pawn);

        if (V != none)
        {
            V.TPCamDistance = NewDistance;
            V.TPCamDistRange.Min = NewDistance;
            V.TPCamDistRange.Max = NewDistance;
            V.DesiredTPCamDistance = NewDistance;
        }
    }
}

// New debug exec to set a vehicle's 3rd person camera distance
exec function VehCamLookAt(int X, int Y, int Z)
{
    local Vehicle V;

    if (IsDebugModeAllowed())
    {
        V = Vehicle(Pawn);

        if (V != none)
        {
            V.TPCamLookat.X = X;
            V.TPCamLookat.Y = Y;
            V.TPCamLookat.Z = Z;
        }
    }
}

// New debug exec to enable/disable penetration debugging functionality for all armored vehicles
exec function DebugPenetration(bool bEnable)
{
    local class<DHArmoredVehicle> AVClass;
    local class<DHVehicleCannon>  VCClass;
    local DHArmoredVehicle        AV;
    local DHVehicleCannon         VC;
    local DHGameReplicationInfo   GRI;
    local int                     i;

    if (IsDebugModeAllowed())
    {
        if (!bEnable)
        {
            ClearStayingDebugLines();
        }

        // Change debug settings for current vehicles
        foreach DynamicActors(class'DHArmoredVehicle', AV)
        {
            AV.bDebugPenetration = bEnable;
            AV.bLogDebugPenetration = bEnable;
            AV.Class.default.bDebugPenetration = bEnable; // also change defaults so future spawned vehicles inherit the setting
            AV.Class.default.bLogDebugPenetration = bEnable;
        }

        foreach DynamicActors(class'DHVehicleCannon', VC)
        {
            VC.bDebugPenetration = bEnable;
            VC.bLogDebugPenetration = bEnable;
            VC.Class.default.bDebugPenetration = bEnable;
            VC.Class.default.bLogDebugPenetration = bEnable;
        }

        // Change default settings for all vehicles listed in the SpawnManager actor's vehicle pool list
        GRI = DHGameReplicationInfo(GameReplicationInfo);

        if (GRI != none)
        {
            for (i = 0; i < GRI.VEHICLE_POOLS_MAX; ++i)
            {
                AVClass = class<DHArmoredVehicle>(GRI.GetVehiclePoolVehicleClass(i));

                if (AVClass != none)
                {
                    AVClass.default.bDebugPenetration = bEnable;
                    AVClass.default.bLogDebugPenetration = bEnable;

                    if (AVClass.default.PassengerWeapons.Length > 0 && class<DHVehicleCannonPawn>(AVClass.default.PassengerWeapons[0].WeaponPawnClass) != none)
                    {
                        VCClass = class<DHVehicleCannon>(AVClass.default.PassengerWeapons[0].WeaponPawnClass.default.GunClass);

                        if (VCClass != none)
                        {
                            VCClass.default.bDebugPenetration = bEnable;
                            VCClass.default.bLogDebugPenetration = bEnable;
                        }
                    }
                }
            }
        }
    }
}

// New debug exec to adjust a vehicle's tread rotation direction
exec function SetTreadDir(int NewPitch, int NewYaw, int NewRoll)
{
    local DHVehicle V;
    local rotator   NewPanDirection;

    if (IsVehicleDebugModeAllowed(V) && V.bHasTreads)
    {
        Log(V.VehicleNameString @ "TreadPanDirection =" @ NewPitch @ NewYaw @ NewRoll @ "(was" @ V.LeftTreadPanDirection $ ")");
        NewPanDirection.Pitch = NewPitch;
        NewPanDirection.Yaw = NewYaw;
        NewPanDirection.Roll = NewRoll;
        V.LeftTreadPanner.PanDirection = NewPanDirection;
        V.RightTreadPanner.PanDirection = NewPanDirection;
    }
}

// New debug exec to adjust rotation speed of treads
exec function SetTreadSpeed(int NewValue, optional bool bAddToCurrentSpeed)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && V.bHasTreads)
    {
        if (NewValue == 0) // entering zero resets tread speed to vehicle's default value
        {
            NewValue = V.default.TreadVelocityScale;
        }
        else if (bAddToCurrentSpeed) // option to apply entered value as adjustment to existing tread speed, instead of as new setting, e.g. to increment or decrement speed gradually
        {
            NewValue += V.TreadVelocityScale;
        }

        Log(V.VehicleNameString @ "TreadVelocityScale =" @ NewValue @ "(was" @ V.TreadVelocityScale $ ")");
        V.TreadVelocityScale = NewValue;
    }
}

// New debug exec to adjust rotation speed of track wheels
exec function SetWheelSpeed(int NewValue, optional bool bAddToCurrentSpeed)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && V.bHasTreads)
    {
        if (NewValue == 0) // entering zero resets wheel speed to vehicle's default value
        {
            NewValue = V.default.WheelRotationScale;
        }
        else if (bAddToCurrentSpeed) // option to apply entered value as adjustment to existing wheel speed, instead of as new setting, e.g. to increment or decrement speed gradually
        {
            NewValue += V.WheelRotationScale;
        }

        Log(V.VehicleNameString @ "WheelRotationScale =" @ NewValue @ "(was" @ V.WheelRotationScale $ ")");
        V.WheelRotationScale = NewValue;
    }
}

// New debug exec to adjust the occupant positions in a vehicle's HUD overlay (the red dots)
exec function SetOccPos(byte Index, string NewX, string NewY)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && Index < V.VehicleHudOccupantsX.Length)
    {
        Log(V.VehicleNameString @ "VehicleHudOccupantsX[" $ Index $ "] =" @ float(NewX) @ "Y =" @ float(NewY) @ "(was" @ V.VehicleHudOccupantsX[Index] @ V.VehicleHudOccupantsY[Index]);
        V.VehicleHudOccupantsX[Index] = float(NewX);
        V.VehicleHudOccupantsY[Index] = float(NewY);
    }
}

// New debug exec to adjust the damaged tread indicators on a vehicle's HUD overlay
exec function SetHUDTreads(string NewPosX0, string NewPosX1, string NewPosY, string NewScale)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V))
    {
        Log(V.VehicleNameString @ "VehicleHudTreadsPosX[0] =" @ float(NewPosX0) @ "VehicleHudTreadsPosX[1] =" @ float(NewPosX1)
            @ "VehicleHudTreadsPosY =" @ float(NewPosY) @ "VehicleHudTreadsScale =" @ float(NewScale)
            @ "(was" @ V.VehicleHudTreadsPosX[0] @ V.VehicleHudTreadsPosX[1] @ V.VehicleHudTreadsPosY @ V.VehicleHudTreadsScale $ ")");

        V.VehicleHudTreadsPosX[0] = float(NewPosX0);
        V.VehicleHudTreadsPosX[1] = float(NewPosX1);
        V.VehicleHudTreadsPosY = float(NewPosY);
        V.VehicleHudTreadsScale = float(NewScale);
    }
}

// New debug exec to set a vehicle's exhaust emitter location
exec function SetExhPos(int Index, int NewX, int NewY, int NewZ)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && Index < V.ExhaustPipes.Length)
    {
        Log(V.VehicleNameString @ "ExhaustPipes[" $ Index $ "].ExhaustPosition =" @ NewX @ NewY @ NewZ @ "(was" @ V.ExhaustPipes[Index].ExhaustPosition $ ")");
        V.ExhaustPipes[Index].ExhaustPosition.X = NewX;
        V.ExhaustPipes[Index].ExhaustPosition.Y = NewY;
        V.ExhaustPipes[Index].ExhaustPosition.Z = NewZ;

        if (V.ExhaustPipes[Index].ExhaustEffect != none)
        {
            V.ExhaustPipes[Index].ExhaustEffect.SetLocation(V.Location + (V.ExhaustPipes[Index].ExhaustPosition >> V.Rotation));
            V.ExhaustPipes[Index].ExhaustEffect.SetBase(V);
        }
    }
}

// New debug exec to set exhaust emitter rotation
exec function SetExhRot(int Index, int NewPitch, int NewYaw, int NewRoll)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && Index < V.ExhaustPipes.Length)
    {
        Log(V.VehicleNameString @ "ExhaustPipes[" $ Index $ "].ExhaustRotation =" @ NewPitch @ NewYaw @ NewRoll @ "(was" @ V.ExhaustPipes[Index].ExhaustRotation $ ")");
        V.ExhaustPipes[Index].ExhaustRotation.Pitch = NewPitch;
        V.ExhaustPipes[Index].ExhaustRotation.Yaw = NewYaw;
        V.ExhaustPipes[Index].ExhaustRotation.Roll = NewRoll;

        if (V.bEmittersOn)
        {
            V.StartEmitters();
        }
    }
}

// New debug exec to adjust the radius of a vehicle's physics wheels
// Include no numbers to adjust all wheels, otherwise add index numbers of first & last wheels to adjust
exec function SetWheelRad(string NewValue, optional byte FirstWheelIndex, optional byte LastWheelIndex)
{
    local DHVehicle V;
    local int       i;

    if (IsVehicleDebugModeAllowed(V) && FirstWheelIndex < V.Wheels.Length)
    {
        if (LastWheelIndex == 0)
        {
            LastWheelIndex = V.Wheels.Length - 1;
        }

        for (i = FirstWheelIndex; i <= LastWheelIndex; ++i)
        {
            Log(V.VehicleNameString @ "Wheels[" $ i $ "].WheelRadius =" @ float(NewValue) @ "(was" @ V.Wheels[i].WheelRadius $ ")");
            V.Wheels[i].WheelRadius = float(NewValue);
        }
    }
}

// New debug exec to adjust the attachment bone offset of a vehicle's physics wheels
// Include no numbers to adjust all wheels, otherwise add index numbers of first & last wheels to adjust
exec function SetWheelOffset(string NewX, string NewY, string NewZ, optional byte FirstWheelIndex, optional byte LastWheelIndex)
{
    local DHVehicle V;
    local vector    NewBoneOffset;
    local int       i;

    if (IsVehicleDebugModeAllowed(V) && FirstWheelIndex < V.Wheels.Length)
    {
        NewBoneOffset.X = float(NewX);
        NewBoneOffset.Y = float(NewY);
        NewBoneOffset.Z = float(NewZ);

        if (LastWheelIndex == 0)
        {
            LastWheelIndex = V.Wheels.Length - 1;
        }

        for (i = FirstWheelIndex; i <= LastWheelIndex; ++i)
        {
            Log(V.VehicleNameString @ "Wheels[" $ i $ "].BoneOffset =" @ NewBoneOffset @ "(was" @ V.Wheels[i].BoneOffset $ ")");
            V.Wheels[i].WheelPosition += NewBoneOffset - V.Wheels[i].BoneOffset; // this updates a native code setting (experimentation showed it's a relative offset)
            V.Wheels[i].BoneOffset = NewBoneOffset;
        }
    }
}

// New debug exec to adjust maximum travel distance of the suspension of a vehicle's physics wheels
// Allows adjustment of individual wheels, but note that on entering a vehicle, native code calls SVehicleUpdateParams(), which will undo individual settings
// Settings for all wheels get matched to values of WheelSuspensionTravel & WheelSuspensionMaxRenderTravel, so if individual settings are required, SVehicleUpdateParams must be overridden
exec function SetSuspTravel(string NewValue, optional byte FirstWheelIndex, optional byte LastWheelIndex, optional bool bDontSetSuspensionTravel, optional bool bDontSetMaxRenderTravel)
{
    local DHVehicle V;
    local float     OldTravel, OldRenderTravel;
    local int       i;

    if (IsVehicleDebugModeAllowed(V) && FirstWheelIndex < V.Wheels.Length)
    {
        if (!bDontSetSuspensionTravel)
        {
            V.WheelSuspensionTravel = float(NewValue); // on re-entering the vehicle, all physics wheels will have this value set (same with max render travel), undoing any individual settings
        }

        if (!bDontSetMaxRenderTravel)
        {
            V.WheelSuspensionMaxRenderTravel = float(NewValue);
        }

        if (LastWheelIndex == 0)
        {
            LastWheelIndex = V.Wheels.Length - 1;
        }

        for (i = FirstWheelIndex; i <= LastWheelIndex; ++i)
        {
            OldTravel = V.Wheels[i].SuspensionTravel;
            OldRenderTravel = V.Wheels[i].SuspensionMaxRenderTravel;

            if (!bDontSetSuspensionTravel)
            {
                V.Wheels[i].SuspensionTravel = float(NewValue);
            }

            if (!bDontSetMaxRenderTravel)
            {
                V.Wheels[i].SuspensionMaxRenderTravel = float(NewValue);
            }

            Log(V.VehicleNameString @ "Wheels[" $ i $ "].SuspensionTravel =" @ V.Wheels[i].SuspensionTravel @ "(was" @ OldTravel $
                ") MaxRenderTravel =" @ V.Wheels[i].SuspensionMaxRenderTravel @ "(was" @ OldRenderTravel $ ")");
        }
    }
}

// New debug exec to adjust the positioning of a vehicle's suspension bones that support its physics wheels
// Allows adjustment of individual wheels, but note that on entering a vehicle, native code calls SVehicleUpdateParams(), which will undo individual settings
// Settings for all wheels get matched to values of WheelSuspensionOffset, so if individual settings are required, SVehicleUpdateParams must be overridden
exec function SetSuspOffset(string NewValue, optional byte FirstWheelIndex, optional byte LastWheelIndex)
{
    local DHVehicle V;
    local int       i;

    if (IsVehicleDebugModeAllowed(V) && FirstWheelIndex < V.Wheels.Length)
    {
        V.WheelSuspensionOffset = float(NewValue); // on re-entering the vehicle, all physics wheels get set to this property, undoing any individual settings

        if (LastWheelIndex == 0)
        {
            LastWheelIndex = V.Wheels.Length - 1;
        }

        for (i = FirstWheelIndex; i <= LastWheelIndex; ++i)
        {
            Log(V.VehicleNameString @ "Wheels[" $ i $ "].SuspensionOffset =" @ float(NewValue) @ "(was" @ V.Wheels[i].SuspensionOffset $ ")");
            V.Wheels[i].SuspensionOffset = float(NewValue);
        }
    }
}

// New debug exec to adjust a vehicle's mass
exec function SetMass(float NewValue)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V))
    {
        Log(V.VehicleNameString @ "VehicleMass =" @ NewValue @ "(old was" @ V.VehicleMass $ ")");
        V.VehicleMass = NewValue;
        V.KSetMass(NewValue);
    }
}

// New debug exec to show a vehicle's karma centre of mass offset
exec function DrawCOM(optional bool bClearScreen)
{
    local DHVehicle V;
    local vector    COM, X, Y, Z;

    ClearLines();

    if (!bClearScreen && IsVehicleDebugModeAllowed(V))
    {
        GetAxes(V.Rotation, X, Y, Z);
        V.KGetCOMPosition(COM);
        DrawStayingDebugLine(COM - (200.0 * X), COM + (200.0 * X), 255, 0, 0);
        DrawStayingDebugLine(COM - (200.0 * Y), COM + (200.0 * Y), 0, 255, 0);
        DrawStayingDebugLine(COM - (200.0 * Z), COM + (200.0 * Z), 0, 0, 255);
    }
}

// New debug exec to adjust a vehicle's karma centre of mass
exec function SetCOM(string NewX, string NewY, string NewZ)
{
    local DHVehicle V;
    local vector    COM, OldCOM;

    if (IsVehicleDebugModeAllowed(V))
    {
        V.KGetCOMOffset(OldCOM);
        COM.X = float(NewX);
        COM.Y = float(NewY);
        COM.Z = float(NewZ);
        V.KSetCOMOffset(COM);
        V.SetPhysics(PHYS_None);
        V.SetPhysics(PHYS_Karma);
        DrawCOM();
        Log(V.VehicleNameString @ "KCOMOffset =" @ COM @ "(old was" @ OldCOM $ ")");
    }
}

// New debug exec to adjust a vehicle's karma max angular speed (higher values make the vehicle slow when turning & make it feel "heavier")
exec function SetMaxAngSpeed(float NewValue)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && KarmaParams(V.KParams) != none)
    {
        Log(V.VehicleNameString @ "KMaxAngularSpeed =" @ NewValue @ "(old was" @ KarmaParams(V.KParams).KMaxAngularSpeed $ ")");
        KarmaParams(V.KParams).KMaxAngularSpeed = NewValue;
        V.SetPhysics(PHYS_None);
        V.SetPhysics(PHYS_Karma);
    }
}

// New debug exec to adjust a vehicle's karma angular damping
exec function SetAngDamp(float NewValue)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && KarmaParams(V.KParams) != none)
    {
        Log(V.VehicleNameString @ "KAngularDamping =" @ NewValue @ "(old was" @ KarmaParams(V.KParams).KAngularDamping $ ")");
        KarmaParams(V.KParams).KAngularDamping = NewValue;
        V.SetPhysics(PHYS_None);
        V.SetPhysics(PHYS_Karma);
    }
}

// New debug exec to adjust position & radius if vehicle hit points
exec function SetHitPoint(byte Index, string NewX, string NewY, string NewZ, optional string NewRadius, optional bool bIsDHNewHitPoint)
{
    local DHArmoredVehicle AV;
    local DHVehicle        V;

    if (IsVehicleDebugModeAllowed(V))
    {
        if (bIsDHNewHitPoint)
        {
            AV = DHArmoredVehicle(V);

            if (AV != none && Index < AV.NewVehHitpoints.Length)
            {
                if (!(float(NewRadius) > 0.0))
                {
                    NewRadius = string(AV.NewVehHitpoints[Index].PointRadius);
                }

                Log(AV.Tag @ "NewVehHitpoints[" $ Index $ "] Offset =" @ float(NewX) @ float(NewY) @ float(NewZ) @ " Radius =" @ float(NewRadius)
                    @ "(was" @ AV.NewVehHitpoints[Index].PointOffset $ ", radius" @ AV.NewVehHitpoints[Index].PointRadius $ ")");

                AV.NewVehHitpoints[Index].PointOffset.X = float(NewX);
                AV.NewVehHitpoints[Index].PointOffset.Y = float(NewY);
                AV.NewVehHitpoints[Index].PointOffset.Z = float(NewZ);
                AV.NewVehHitpoints[Index].PointRadius = float(NewRadius);
            }
        }
        else if (Index < V.VehHitpoints.Length)
        {
            if (!(float(NewRadius) > 0.0))
            {
                NewRadius = string(V.VehHitpoints[Index].PointRadius);
            }

            Log(V.Tag @ "VehHitpoints[" $ Index $ "] Offset =" @ float(NewX) @ float(NewY) @ float(NewZ) @ " Radius =" @ float(NewRadius)
                @ "(was" @ V.VehHitpoints[Index].PointOffset $ ", radius" @ V.VehHitpoints[Index].PointRadius $ ")");

            V.VehHitpoints[Index].PointOffset.X = float(NewX);
            V.VehHitpoints[Index].PointOffset.Y = float(NewY);
            V.VehHitpoints[Index].PointOffset.Z = float(NewZ);
            V.VehHitpoints[Index].PointRadius = float(NewRadius);
        }
    }
}

// New debug exec to adjust position of engine smoke/fire
exec function SetDEOffset(int NewX, int NewY, int NewZ, optional bool bEngineFire, optional string NewScale)
{
    local DHVehicle V;
    local vector    OldOffset;
    local float     OldScale;

    if (IsVehicleDebugModeAllowed(V) && Level.NetMode != NM_DedicatedServer)
    {
        OldOffset = V.DamagedEffectOffset;
        OldScale = V.DamagedEffectScale;

        // Only update offset if something has been entered (otherwise just entering "DEOffset" is quick way of triggering smoke effect at current position)
        if (NewX != 0 || NewY != 0 || NewZ != 0)
        {
            V.DamagedEffectOffset.X = NewX;
            V.DamagedEffectOffset.Y = NewY;
            V.DamagedEffectOffset.Z = NewZ;
        }

        // Option to re-scale effect
        if (float(NewScale) > 0.0)
        {
            V.DamagedEffectScale = float(NewScale);
        }

        // Log settings
        if (V.DamagedEffectOffset != OldOffset || V.DamagedEffectScale != OldScale)
        {
            Log(V.VehicleNameString @ "DamagedEffectOffset =" @ V.DamagedEffectOffset @ "scale =" @ V.DamagedEffectScale @ "(old was" @ OldOffset @ "scale =" @ OldScale $ ")");
        }
        else
        {
            Log(V.VehicleNameString @ "DamagedEffectOffset =" @ V.DamagedEffectOffset @ "scale =" @ V.DamagedEffectScale);
        }

        // Appears necessary to get native code to spawn a DamagedEffect if it doesn't already exist
        if (V.DamagedEffect == none)
        {
            V.DamagedEffectHealthSmokeFactor = 1.0;

            if (V.Health == V.HealthMax) // clientside Health hack to get native code to spawn DamagedEffect (it won't unless vehicle has taken some damage)
            {
                V.Health--;
            }
        }

        // Engine fire effect
        if (bEngineFire)
        {
            V.DamagedEffectHealthFireFactor = 1.0;
        }
        // Or if we don't want a fire effect but it's already burning, reset to smoking
        else if (V.DamagedEffectHealthFireFactor == 1.0)
        {
            V.DamagedEffectHealthFireFactor = V.default.DamagedEffectHealthFireFactor;

            if (V.DamagedEffect != none)
            {
                V.DamagedEffect.UpdateDamagedEffect(false, 0.0, false, false); // light smoke
            }
        }

        // Reposition any existing effect
        if (V.DamagedEffect != none)
        {
            V.DamagedEffect.SetBase(none);
            V.DamagedEffect.SetLocation(V.Location + (V.DamagedEffectOffset >> V.Rotation));
            V.DamagedEffect.SetBase(V);
            V.DamagedEffect.SetEffectScale(V.DamagedEffectScale);
        }
    }
}

// New debug exec to adjust the position of a vehicle's shadow so it looks right by adjusting the vertical position offset (ShadowZOffset) of attached ShadowProjector
exec function SetVehShadowHeight(float NewValue)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V) && DHShadowProjector(V.VehicleShadow) != none)
    {
        Log(V.VehicleNameString @ "ShadowZOffset =" @ NewValue @ "(was" @ V.ShadowZOffset $ ")");
        V.ShadowZOffset = NewValue;
        DHShadowProjector(V.VehicleShadow).ShadowZOffset = NewValue;
    }
}

// New debug exec to show & adjust the height bands of an armoured vehicle's hull armour sections, i.e. highest relative point (above mesh origin) for that armour section
// Spawns an angle plane attachment representing the height setting (run again with no side specified to remove this)
exec function SetArmorHeight(optional string Side, optional byte Index, optional float NewValue)
{
    local DHVehicle        V;
    local DHArmoredVehicle AV;
    local bool             bDontChangeValue;

    if (IsVehicleDebugModeAllowed(V) && V.IsA('DHArmoredVehicle'))
    {
        AV = DHArmoredVehicle(V);
        DestroyPlaneAttachments(AV); // remove any existing angle plane attachments

        if (NewValue == 999.0) // option to just display the existing height, not setting a new value (pass 999 as new height)
        {
            bDontChangeValue = true;
        }
        else if (Side ~= "A" || Side ~= "All") // option to display heights for this armor index position for all sides
        {
            Side = "All";
            bDontChangeValue = true;
        }

        if (Side ~= "F" || Side ~= "Front" || Side ~= "All")
        {
            ProcessSetArmorHeight(AV, AV.FrontArmor, Index, NewValue, "Front", 0, bDontChangeValue);
        }

        if (Side ~= "R" || Side ~= "Right" || Side ~= "All")
        {
            ProcessSetArmorHeight(AV, AV.RightArmor, Index, NewValue, "Right", 16384, bDontChangeValue);
        }

        if (Side ~= "B" || Side ~= "Back" || Side ~= "Rear" || Side ~= "All")
        {
            ProcessSetArmorHeight(AV, AV.RearArmor, Index, NewValue, "Rear", 32768, bDontChangeValue);
        }

        if (Side ~= "L" || Side ~= "Left" || Side ~= "All")
        {
            ProcessSetArmorHeight(AV, AV.LeftArmor, Index, NewValue, "Left", -16384, bDontChangeValue);
        }
    }
}

// New helper function for debug exec SetArmorHeight
function ProcessSetArmorHeight(DHVehicle V, out array<DHArmoredVehicle.ArmorSection> ArmorArray, byte Index, float NewValue, string SideText, int PlaneYaw, optional bool bDontChangeValue)
{
    local rotator PlaneRotation;

    // Option to just display the existing height, not setting a new value
    if (bDontChangeValue)
    {
        if (Index >= ArmorArray.Length - 1)
        {
            return; // invalid index no. (minus 1 because we don't draw a height plane for the highest armor band as it isn't supposed to have a max height)
        }

        Log(V.VehicleNameString $ ":" @ SideText $ "Armor[" $ Index $ "].MaxRelativeHeight =" @ ArmorArray[Index].MaxRelativeHeight
            $ ", thickness =" @ ArmorArray[Index].Thickness $ "mm, slope =" @ ArmorArray[Index].Slope @ "degrees");
    }
    // Default is to set a new max height value
    else
    {
        if (Index >= ArmorArray.Length)
        {
            ArmorArray.Length = Index + 1; // extend armor array if a higher index no. has been specified
        }

        Log(V.VehicleNameString $ ":" @ SideText $ "Armor[" $ Index $ "].MaxRelativeHeight =" @ NewValue @ "(was" @ ArmorArray[Index].MaxRelativeHeight
            $ "), thickness =" @ ArmorArray[Index].Thickness $ "mm, slope =" @ ArmorArray[Index].Slope @ "degrees");

        ArmorArray[Index].MaxRelativeHeight = NewValue;
    }

    // Display an angle plane showing the max height
    PlaneRotation.Yaw = PlaneYaw;
    PlaneRotation.Roll = 16384;
    SpawnPlaneAttachment(V, PlaneRotation, ArmorArray[Index].MaxRelativeHeight * vect(0.0, 0.0, 1.0));
}

// New debug exec to show & adjust a vehicle's TreadHitMaxHeight, which is the highest point (above the origin) where a side hit may damage treads
// Spawns an angle plane attachment representing the setting (repeat same setting, i.e. no change, to remove this)
exec function SetTreadHeight(float NewValue)
{
    local DHVehicle V;

    if (IsVehicleDebugModeAllowed(V))
    {
        Log(V.VehicleNameString @ "TreadHitMaxHeight =" @ NewValue @ "(was" @ V.TreadHitMaxHeight $ ")");
        DestroyPlaneAttachments(V); // remove any existing angle plane attachments

        if (NewValue != V.TreadHitMaxHeight)
        {
            V.TreadHitMaxHeight = NewValue;
            SpawnPlaneAttachment(V, rot(0, 16384, 16384), V.TreadHitMaxHeight * vect(0.0, 0.0, 1.0));
            SpawnPlaneAttachment(V, rot(0, -16384, 16384), V.TreadHitMaxHeight * vect(0.0, 0.0, 1.0));
        }
    }
}

// New debug exec to show and/or adjust the angle settings for the 4 corners of the hull or turret, used to calculate which side has been hit, in penetration & damage functions
// Angle plane attachments are spawned to represent the 4 angles, and they are listed on screen & in the log
// "DebugAngles FR 33" would set FrontRightAngle to 33 degrees, "DebugAngles off" clears any angle attachments, "DebugAngles" just lists the current angles
exec function DebugAngles(optional string Option, optional float NewAngle)
{
    local DHVehicle       V;
    local DHVehicleCannon Cannon;
    local Actor           BaseActor;
    local rotator         NewRotation;
    local string          AnglesList;

    if (IsVehicleDebugModeAllowed(V))
    {
        DestroyPlaneAttachments(V); // remove any existing angle plane attachments

        if (DHVehicleCannonPawn(Pawn) != none && DHVehicleCannonPawn(Pawn).Cannon != none)
        {
            Cannon = DHVehicleCannonPawn(Pawn).Cannon;
            BaseActor = Cannon;
        }
        else
        {
            BaseActor = V;
        }

        // Exit if selected the option to turn off angle plane attachments (various accepted keywords)
        if (Option ~= "Off" || Option ~= "False" || Option ~= "Disable" || Option ~= "0")
        {
            return;
        }

        // Set a new angle (accepts either "RL" or "BL" for rear/back left)
        if (NewAngle > 0.0 && NewAngle <= 360.0)
        {
            if (Option ~= "FR")
            {
                if (BaseActor == Cannon)
                {
                    Cannon.FrontRightAngle = NewAngle;
                }
                else
                {
                    V.FrontRightAngle = NewAngle;
                }
            }
            else if (Option ~= "RR" || Option ~= "BR")
            {
                if (BaseActor == Cannon)
                {
                    Cannon.RearRightAngle = NewAngle;
                }
                else
                {
                    V.RearRightAngle = NewAngle;
                }
            }
            else if (Option ~= "RL" || Option ~= "BL")
            {
                if (BaseActor == Cannon)
                {
                    Cannon.RearLeftAngle = NewAngle;
                }
                else
                {
                    V.RearLeftAngle = NewAngle;
                }
            }
            else if (Option ~= "FL")
            {
                if (BaseActor == Cannon)
                {
                    Cannon.FrontLeftAngle = NewAngle;
                }
                else
                {
                    V.FrontLeftAngle = NewAngle;
                }
            }
        }

        // Spawn new angle plane attachments
        if (BaseActor == Cannon)
        {
            NewRotation.Yaw = int(Cannon.FrontRightAngle * 65536.0 / 360.0);
            SpawnPlaneAttachment(V, NewRotation,, Cannon);
            NewRotation.Yaw = int(Cannon.RearRightAngle * 65536.0 / 360.0);
            SpawnPlaneAttachment(V, NewRotation,, Cannon);
            NewRotation.Yaw = int(Cannon.RearLeftAngle * 65536.0 / 360.0);
            SpawnPlaneAttachment(V, NewRotation,, Cannon);
            NewRotation.Yaw = int(Cannon.FrontLeftAngle * 65536.0 / 360.0);
            SpawnPlaneAttachment(V, NewRotation,, Cannon);
        }
        else
        {
            NewRotation.Yaw = int(V.FrontRightAngle * 65536.0 / 360.0);
            SpawnPlaneAttachment(V, NewRotation);
            NewRotation.Yaw = int(V.RearRightAngle * 65536.0 / 360.0);
            SpawnPlaneAttachment(V, NewRotation);
            NewRotation.Yaw = int(V.RearLeftAngle * 65536.0 / 360.0);
            SpawnPlaneAttachment(V, NewRotation);
            NewRotation.Yaw = int(V.FrontLeftAngle * 65536.0 / 360.0);
            SpawnPlaneAttachment(V, NewRotation);
        }

        // List the angles on screen & in the log
        if (BaseActor == Cannon)
        {
            AnglesList = "Cannon angles: FrontRightAngle =" @ Cannon.FrontRightAngle @ " RearRightAngle =" @ Cannon.RearRightAngle
                @ " RearLeftAngle =" @ Cannon.RearLeftAngle @ " FrontLeftAngle =" @ Cannon.FrontLeftAngle;
        }
        else
        {
            AnglesList = "Hull angles: FrontRightAngle =" @ V.FrontRightAngle @ " RearRightAngle =" @ V.RearRightAngle
                @ " RearLeftAngle =" @ V.RearLeftAngle @ " FrontLeftAngle =" @ V.FrontLeftAngle;
        }

        Pawn.ClientMessage(AnglesList);
        Log(AnglesList);
    }
}

// Helper function to spawn debug plane attachments
simulated function SpawnPlaneAttachment(DHVehicle V, rotator RelRotation, optional vector RelLocation, optional Actor BaseActor)
{
    local Actor Plane;

    if (V != none && Level.NetMode != NM_DedicatedServer)
    {
        if (BaseActor == none)
        {
            BaseActor = V;
        }

        Plane = Spawn(class'DH_Engine.DHDecoAttachment',,, BaseActor.Location);

        if (Plane != none)
        {
            if (VehicleWeapon(BaseActor) != none)
            {
                BaseActor.AttachToBone(Plane, VehicleWeapon(BaseActor).YawBone);
            }
            else
            {
                Plane.SetBase(BaseActor);
            }

            // Using DynamicLoadObject so we don't have DH_DebugTools static mesh file loaded all the time; just dynamically load on demand
            Plane.SetStaticMesh(StaticMesh(DynamicLoadObject("DH_DebugTools.Misc.DebugPlaneAttachment", class'StaticMesh')));
            Plane.SetRelativeRotation(RelRotation);
            Plane.SetRelativeLocation(RelLocation);
            V.VehicleAttachments.Length = V.VehicleAttachments.Length + 1;
            V.VehicleAttachments[V.VehicleAttachments.Length - 1].Actor = Plane;
        }
    }
}

// Helper function to destroy any debug plane attachments
simulated function DestroyPlaneAttachments(DHVehicle V)
{
    local StaticMesh PlaneStaticMesh;
    local int        i;

    if (V != none)
    {
        // Using DynamicLoadObject so we don't have DH_DebugTools static mesh file loaded all the time; just dynamically load on demand
        PlaneStaticMesh = StaticMesh(DynamicLoadObject("DH_DebugTools.Misc.DebugPlaneAttachment", class'StaticMesh'));

        for (i = V.VehicleAttachments.Length - 1; i >= 0; --i)
        {
            if (V.VehicleAttachments[i].Actor != none && V.VehicleAttachments[i].Actor.StaticMesh == PlaneStaticMesh)
            {
                V.VehicleAttachments[i].Actor.Destroy();
                V.VehicleAttachments.Remove(i, 1);
            }
        }
    }
}

// Emptied out as the system of using coded hit points to represent vehicle occupants has been abandoned
exec function DriverCollisionDebug()
{
}

// TEMPDEBUG (Matt, v8.0): for problem where player in any vehicle position is visibly attached in the wrong position
// The problem seems to be a net client very occasionally appears to get the player attached without the default PrePivot -42 Z adjustment to his RelativeLocation
// This leaves him about 0.7m higher than he should be, e.g. a buttoned up tank commander appearing in an odd pose above the hatch, or can also affect vehicle driver
exec function DebugDriverAttachment()
{
    local Vehicle V;

    V = Vehicle(Pawn);

    if (V != none && V.Driver != none)
    {
        Log(V.Tag @ "DebugDriverAttachment: RelativeLocation =" @ V.Driver.RelativeLocation @ ", DrivePos =" @ V.DrivePos
            @ ", PrePivot =" @ V.Driver.PrePivot @ ", default.PrePivot =" @ V.Driver.default.PrePivot);
    }
}

simulated function ClientTeamKillPrompt(string LastFFKillerString)
{
    class'DHTeamKillInteraction'.default.LastFFKillerName = LastFFKillerString;

    Player.InteractionMaster.AddInteraction("DH_Engine.DHTeamKillInteraction", Player);
}

function ServerSquadVolunteerToAssist()
{
    local int TeamIndex, SquadIndex;
    local DHPlayerReplicationInfo PRI, SLPRI;
    local DHPlayer SLPC;

    TeamIndex = GetTeamNum();
    SquadIndex = GetSquadIndex();

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    SLPRI = SquadReplicationInfo.GetSquadLeader(TeamIndex, SquadIndex);

    if (PRI == none || SLPRI == none)
    {
        return;
    }

    SLPC = DHPlayer(SLPRI.Owner);

    if (SLPC == none)
    {
        return;
    }

    if (SquadReplicationInfo.HasAssistant(TeamIndex, SquadIndex))
    {
        // Squad assistant already exists.
        return;
    }

    SLPC.ClientSquadAssistantVolunteerPrompt(TeamIndex, SquadIndex, PRI);
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// PARADROPS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// Moves the player to a specified location and gives him a parachute.
function Paradrop(vector DropLocation, optional float SpreadModifier, optional bool bForceOutOfVehicle)
{
    local Pawn PlayerPawn;
    local Vehicle DrivenVehicle;

    DrivenVehicle = Vehicle(Pawn);

    if (DrivenVehicle != none)
    {
        if (!bForceOutOfVehicle && !DrivenVehicle.IsA('DHATGun'))
        {
            return;
        }

        // Player is manning an AT gun, so we kick him out of it.
        DrivenVehicle.KDriverLeave(true);
    }

    PlayerPawn = DHPawn(Pawn);

    if (PlayerPawn != none)
    {
        PlayerPawn.SetLocation(DropLocation + RandRange(1.0, 2.0) * SpreadModifier * vector(RotRand()));
        DHPawn(PlayerPawn).GiveChute();
    }
}

function ParadropGroup(out array<DHPlayerReplicationInfo> PlayersToDrop, vector DropLocation, optional float SpreadModifier, optional bool bForceOutOfVehicle)
{
    local DHPlayer PC;
    local int i;

    for (i = 0; i < PlayersToDrop.Length; ++i)
    {
        PC = DHPlayer(PlayersToDrop[i].Owner);

        if (PC != none)
        {
            PC.Paradrop(DropLocation, SpreadModifier, bForceOutOfVehicle);
        }
    }
}

function ServerParadropPlayer(DHPlayerReplicationInfo PRI, vector DropLocation, optional float SpreadModifier, optional bool bForceOutOfVehicle)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC != none)
    {
        PC.Paradrop(DropLocation, SpreadModifier, bForceOutOfVehicle);
    }
}

function ServerParadropTeam(byte TeamIndex, vector DropLocation, optional float SpreadModifier, optional bool bForceOutOfVehicle)
{
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local array<DHPlayerReplicationInfo> PlayersToDrop;
    local int i;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    for (i = 0; i < GRI.PRIArray.Length; ++i)
    {
        PRI = DHPlayerReplicationInfo(GRI.PRIArray[i]);

        if (PRI != none && PRI.Team != none && PRI.Team.TeamIndex == TeamIndex)
        {
            PlayersToDrop[PlayersToDrop.Length] = PRI;
        }
    }

    ParadropGroup(PlayersToDrop, DropLocation, SpreadModifier, bForceOutOfVehicle);
}

function ServerParadropSquad(byte TeamIndex, int SquadIndex, vector DropLocation, optional float SpreadModifier, optional bool bForceOutOfVehicle)
{
    local array<DHPlayerReplicationInfo> PlayersToDrop;

    if (TeamIndex > 1 || SquadReplicationInfo == none)
    {
        return;
    }

    if (SquadIndex >= 0)
    {
        SquadReplicationInfo.GetMembers(TeamIndex, SquadIndex, PlayersToDrop);
    }
    else
    {
        SquadReplicationInfo.GetUnassignedPlayers(TeamIndex, PlayersToDrop);
    }

    ParadropGroup(PlayersToDrop, DropLocation, SpreadModifier, bForceOutOfVehicle);
}

simulated function bool GetMarkedParadropLocation(out vector ParadropLocation)
{
    local DHGameReplicationInfo.MapMarker ParadropMarker;

    ParadropMarker = FindPersonalMarker(ParadropMarkerClass);

    if (ParadropMarker.MapMarkerClass != none)
    {
        ParadropLocation = ParadropMarker.WorldLocation;
        ParadropLocation.Z = ParadropHeight;

        return true;
    }
}

simulated function bool GetSquadLeaderParadropLocation(out vector ParadropLocation, DHPlayerReplicationInfo SelectedPRI)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none || GetSquadIndex() < 0 || SquadMemberLocations[0] == 0)
    {
        return false;
    }

    // We use squad leader's quantized position since we don't need
    // precision here.
    class'UQuantize'.static.DequantizeClamped2DPose(SquadMemberLocations[0],
                                                    ParadropLocation.X,
                                                    ParadropLocation.Y);

    ParadropLocation = GRI.GetWorldCoords(ParadropLocation.X, ParadropLocation.Y);
    ParadropLocation.Z = ParadropHeight;

    return true;
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// START SQUAD FUNCTIONS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

simulated function ClientSquadInvite(string SenderName, string SquadName, int TeamIndex, int SquadIndex)
{
    if (!bIgnoreSquadInvitations)
    {
        class'DHSquadInviteInteraction'.default.SenderName = SenderName;
        class'DHSquadInviteInteraction'.default.SquadName = SquadName;
        class'DHSquadInviteInteraction'.default.TeamIndex = TeamIndex;
        class'DHSquadInviteInteraction'.default.SquadIndex = SquadIndex;

        Player.InteractionMaster.AddInteraction("DH_Engine.DHSquadInviteInteraction", Player);
    }
}

simulated function ClientSquadLeaderVolunteerPrompt(int TeamIndex, int SquadIndex, int ExpirationTime)
{
    if (!bIgnoreSquadLeaderVolunteerPrompts)
    {
        class'DHSquadLeaderVolunteerInteraction'.default.TeamIndex = TeamIndex;
        class'DHSquadLeaderVolunteerInteraction'.default.SquadIndex = SquadIndex;
        class'DHSquadLeaderVolunteerInteraction'.default.ExpirationTime = ExpirationTime;

        Player.InteractionMaster.AddInteraction("DH_Engine.DHSquadLeaderVolunteerInteraction", Player);
    }
}

simulated function ClientSquadAssistantVolunteerPrompt(int TeamIndex, int SquadIndex, DHPlayerReplicationInfo VolunteerPRI)
{
    local int VolunteerIndex, i;

    if (bIgnoreSquadLeaderAssistantVolunteerPrompts)
    {
        return;
    }

    VolunteerIndex = SquadAssistantVolunteers.Length;

    for (i = 0; i < SquadAssistantVolunteers.Length; ++i)
    {
        if (SquadAssistantVolunteers[i] == none)
        {
            VolunteerIndex = i;
        }
    }

    SquadAssistantVolunteers[VolunteerIndex] = VolunteerPRI;

    class'DHSquadLeaderAssistantVolunteerInteraction'.default.TeamIndex = TeamIndex;
    class'DHSquadLeaderAssistantVolunteerInteraction'.default.SquadIndex = SquadIndex;
    class'DHSquadLeaderAssistantVolunteerInteraction'.default.VolunteerIndex = VolunteerIndex;

    Player.InteractionMaster.AddInteraction("DH_Engine.DHSquadLeaderAssistantVolunteerInteraction", Player);
}

simulated function DHPlayerReplicationInfo GetSquadAssistantVolunteer(int VolunteerIndex)
{
    if (VolunteerIndex >= 0 && VolunteerIndex < SquadAssistantVolunteers.Length)
    {
        return SquadAssistantVolunteers[VolunteerIndex];
    }
}

simulated function RemoveSquadAssistantVolunteer(int VolunteerIndex)
{
    local int i;

    if (VolunteerIndex >= 0 && VolunteerIndex < SquadAssistantVolunteers.Length)
    {
        SquadAssistantVolunteers[VolunteerIndex] = none;
    }

    // Clear up the volunteer array if needed
    for (i = 0; i < SquadAssistantVolunteers.Length; ++i)
    {
        if (SquadAssistantVolunteers[i] != none) return;
    }

    SquadAssistantVolunteers.Length = 0;
}

exec function Speak(string ChannelTitle)
{
    local VoiceChatRoom VCR;
    local string ChanPwd;
    local DHVoiceReplicationInfo VRI;
    local DHPlayerReplicationInfo PRI;

    if (VoiceReplicationInfo == none || !VoiceReplicationInfo.bEnableVoiceChat  || !bVoiceChatEnabled)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    VRI = DHVoiceReplicationInfo(VoiceReplicationInfo);

    if (VRI == none && PRI == none)
    {
        return;
    }

    // Colin: Hard-coding this, unfortunately, because we need to have the
    // player be able to join just by executing "Speak Squad". We can't
    // depend on the name of the squad because it's not unique and is subject
    // to change, and we don't want to go passing around UUIDs when we can just
    // put in a sneaky little hack.
    if (ChannelTitle ~= VRI.SquadChannelName)
    {
        if (!PRI.IsInSquad())
        {
            if (ChatRoomMessageClass != none)
            {
                ClientMessage(ChatRoomMessageClass.static.AssembleMessage(16, ChannelTitle));
            }

            return;
        }

        VCR = VRI.GetSquadChannel(GetTeamNum(), PRI.SquadIndex);
    }
    else if (ChannelTitle ~= VRI.LocalChannelName)
    {
        VCR = VRI.GetChannel(PRI.PlayerName, PRI.Team.TeamIndex);
    }
    else if (ChannelTitle ~= VRI.UnassignedChannelName && PRI.IsInSquad())
    {
        // If we are trying to speak in unassigned but we are in a squad, then return out
        return;
    }
    else if (ChannelTitle ~= VRI.CommandChannelName && !PRI.CanAccessCommandChannel())
    {
        if (ChatRoomMessageClass != none)
        {
            ClientMessage(ChatRoomMessageClass.static.AssembleMessage(17, ChannelTitle));
        }

        // If we are trying to speak in command but we aren't a SL, then return out
        return;
    }
    else
    {
        // Check that we are a member of this room.
        VCR = VoiceReplicationInfo.GetChannel(ChannelTitle, GetTeamNum());
    }

    if (VCR == none || VCR.ChannelIndex < 0)
    {
        if (ChatRoomMessageClass != none)
        {
            ClientMessage(ChatRoomMessageClass.static.AssembleMessage(0, ChannelTitle));
        }

        return;
    }

    ChanPwd = FindChannelPassword(ChannelTitle);
    ServerSpeak(VCR.ChannelIndex, ChanPwd);
}

simulated function int GetSquadIndex()
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI != none)
    {
        return PRI.SquadIndex;
    }

    return -1;
}

simulated function int GetSquadMemberIndex()
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI != none)
    {
        return PRI.SquadMemberIndex;
    }

    return -1;
}

simulated function int GetRoleIndex()
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none)
    {
        return GRI.GetRoleIndexAndTeam(GetRoleInfo());
    }

    return -1;
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// START SQUAD FUNCTIONS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

function ServerSquadCreate()
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    G.SquadReplicationInfo.CreateSquad(DHPlayerReplicationInfo(PlayerReplicationInfo));
}

function ServerSquadLeave()
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    G.SquadReplicationInfo.LeaveSquad(DHPlayerReplicationInfo(PlayerReplicationInfo), true);
}

function ServerSquadJoin(int TeamIndex, int SquadIndex, optional bool bWasInvited)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    G.SquadReplicationInfo.JoinSquad(DHPlayerReplicationInfo(PlayerReplicationInfo), TeamIndex, SquadIndex, bWasInvited);
}

function ServerSquadJoinAuto()
{
    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.JoinSquadAuto(DHPlayerReplicationInfo(PlayerReplicationInfo));
    }
}

function ServerSquadInvite(DHPlayerReplicationInfo Recipient)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none && PRI.IsSquadLeader() && !Recipient.IsInSquad())
    {
        SquadReplicationInfo.InviteToSquad(PRI, GetTeamNum(), PRI.SquadIndex, Recipient);
    }
}

function ServerSquadKick(DHPlayerReplicationInfo MemberToKick)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.KickFromSquad(PRI, GetTeamNum(), PRI.SquadIndex, MemberToKick);
    }
}

function ServerSquadBan(DHPlayerReplicationInfo PlayerToBan)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.BanFromSquad(PRI, GetTeamNum(), PRI.SquadIndex, PlayerToBan);
    }
}

function ServerSquadMakeAssistant(DHPlayerReplicationInfo NewAssistant)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.SetAssistantSquadLeader(GetTeamNum(), GetSquadIndex(), NewAssistant);
    }
}

function ServerSquadLock(bool bIsLocked)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.SetSquadLocked(PRI, GetTeamNum(), PRI.SquadIndex, bIsLocked);
    }
}

function ServerSquadPromote(DHPlayerReplicationInfo NewSquadLeader)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.ChangeSquadLeader(PRI, GetTeamNum(), PRI.SquadIndex, NewSquadLeader);
    }
}

function ServerSquadSignal(class<DHSquadSignal> SignalClass, vector Location)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.SendSquadSignal(PRI, GetTeamNum(), PRI.SquadIndex, SignalClass, Location);
    }
}

function ServerSquadRename(string Name)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.SetName(GetTeamNum(), PRI.SquadIndex, Name);
    }
}

function bool ServerAddMapMarker(class<DHMapMarker> MapMarkerClass, float MapLocationX, float MapLocationY, vector WorldLocation)
{
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local vector MapLocation;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    MapLocation.X = MapLocationX;
    MapLocation.Y = MapLocationY;

    if (GRI != none)
    {
        return GRI.AddMapMarker(PRI, MapMarkerClass, MapLocation, WorldLocation) != -1;
    }

    return false;
}

function ServerRemoveMapMarker(int MapMarkerIndex)
{
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo.MapMarker MM;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (!GRI.GetMapMarker(GetTeamNum(), MapMarkerIndex, MM))
    {
        Log("Failed to get map marker!");
        return;
    }

    if (GRI != none && PRI != none && MM.MapMarkerClass.static.CanRemoveMarker(PRI, MM))
    {
        MM.MapMarkerClass.static.OnMapMarkerRemoved(self, MM);
        GRI.RemoveMapMarker(GetTeamNum(), MapMarkerIndex);
    }
}

function array<DHGameReplicationInfo.MapMarker> GetPersonalMarkers()
{
    return PersonalMapMarkers;
}

function DHGameReplicationInfo.MapMarker FindPersonalMarker(class<DHMapMarker> MapMarkerClass)
{
    local int i;
    local DHGameReplicationInfo.MapMarker Marker;

    for (i = 0; i < PersonalMapMarkers.Length; ++i)
    {
        if (PersonalMapMarkers[i].MapMarkerClass == MapMarkerClass)
        {
            return PersonalMapMarkers[i];
        }
    }

    return Marker; // dummy marker
}

function bool IsPersonalMarkerPlaced(class<DHMapMarker> MapMarkerClass)
{
    local int i;

    for (i = 0; i < PersonalMapMarkers.Length; ++i)
    {
        if (PersonalMapMarkers[i].MapMarkerClass == MapMarkerClass)
        {
            return true;
        }
    }
}

function AddPersonalMarker(class<DHMapMarker> MapMarkerClass, float MapLocationX, float MapLocationY, vector WorldLocation)
{
    local DHGameReplicationInfo GRI;
    local DHGameReplicationInfo.MapMarker PMM;
    local int i;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none || MapMarkerClass == none || MapMarkerClass.default.Scope != PERSONAL)
    {
        return;
    }

    switch (MapMarkerClass.default.OverwritingRule)
    {
        case UNIQUE_PER_GROUP:
            for (i = 0; i < PersonalMapMarkers.Length; ++i)
            {
                if (PersonalMapMarkers[i].MapMarkerClass.default.GroupIndex == MapMarkerClass.default.GroupIndex)
                {
                    PersonalMapMarkers.Remove(i, 1);
                    break;
                }
            }
            break;
        case UNIQUE:
            for (i = 0; i < PersonalMapMarkers.Length; ++i)
            {
                if (PersonalMapMarkers[i].MapMarkerClass == MapMarkerClass)
                {
                    PersonalMapMarkers.Remove(i, 1);
                    break;
                }
            }
            break;
        case OFF:
            break;
    }

    PMM.MapMarkerClass = MapMarkerClass;
    PMM.CreationTime = GRI.ElapsedTime;
    PMM.LocationX = byte(255.0 * FClamp(MapLocationX, 0.0, 1.0));
    PMM.LocationY = byte(255.0 * FClamp(MapLocationY, 0.0, 1.0));
    PMM.WorldLocation = WorldLocation;

    if (MapMarkerClass.default.LifetimeSeconds != -1)
    {
        PMM.ExpiryTime = GRI.ElapsedTime + MapMarkerClass.default.LifetimeSeconds;
    }
    else
    {
        PMM.ExpiryTime = -1;
    }

    PersonalMapMarkers.Insert(0, 1);
    PersonalMapMarkers[0] = PMM;
    MapMarkerClass.static.OnMapMarkerPlaced(self, PersonalMapMarkers[0]);
}

function RemovePersonalMarker(int Index)
{
    PersonalMapMarkers[Index].MapMarkerClass.static.OnMapMarkerRemoved(self, PersonalMapMarkers[Index]);
    PersonalMapMarkers.Remove(Index, 1);
}

simulated function ClientSquadSignal(class<DHSquadSignal> SignalClass, vector L)
{
    local int i;
    local int Index;

    Index = -1;

    if (SignalClass == none)
    {
        return;
    }

    if (SignalClass.default.bIsUnique)
    {
        // Go through all of the existing signals and see if one already exist.
        for (i = 0; i < arraycount(SquadSignals); ++i)
        {
            if (SquadSignals[i].SignalClass == SignalClass)
            {
                Index = i;
                break;
            }
        }
    }

    if (Index == -1)
    {
        // Go through the rest of the existing signal slots and see if any are empty or expired.
        for (i = 0; i < arraycount(SquadSignals); ++i)
        {
            if (!IsSquadSignalActive(i))
            {
                Index = i;
                break;
            }
        }
    }

    if (Index != -1)
    {
        SquadSignals[Index].SignalClass = SignalClass;
        SquadSignals[Index].Location = L;
        SquadSignals[Index].TimeSeconds = Level.TimeSeconds;
    }
}

simulated function bool IsSquadSignalActive(int i)
{
    return i >= 0 &&
           i < arraycount(SquadSignals) &&
           SquadSignals[i].SignalClass != none &&
           SquadSignals[i].Location != vect(0, 0, 0) &&
           Level.TimeSeconds - SquadSignals[i].TimeSeconds < SquadSignals[i].SignalClass.default.DurationSeconds;
}

function ServerSquadSpawnRallyPoint()
{
    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.SpawnRallyPoint(self);
    }
}

function ServerSquadDestroyRallyPoint(DHSpawnPoint_SquadRallyPoint SRP)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.DestroySquadRallyPoint(PRI, SRP);
    }
}

// TODO: this should be an RPC in SRI
function ServerSquadSwapRallyPoints()
{
    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.SwapRallyPoints(DHPlayerReplicationInfo(PlayerReplicationInfo));
    }
}

exec function SquadSay(string Msg)
{
    Msg = Left(Msg, 128);

    if (AllowTextMessage(Msg))
    {
        ServerSquadSay(Msg);
    }
}

exec function CommandSay(string Msg)
{
    Msg = Left(Msg, 128);

    if (AllowTextMessage(Msg))
    {
        ServerCommandSay(Msg);
    }
}

function ServerCommandSay(string Msg)
{
    local DarkestHourGame G;

    LastActiveTime = Level.TimeSeconds;

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        G.BroadcastCommand(self, Level.Game.ParseMessageString(Level.Game.BaseMutator, self, Msg) , 'CommandSay');
    }
}

function ServerVehicleSay(string Msg)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        G.BroadcastVehicle(self, Level.Game.ParseMessageString(Level.Game.BaseMutator, self, Msg) , 'VehicleSay');
    }
}

function ServerForgiveLastFFKiller()
{
    local DarkestHourGame G;
    local DHPlayer KillerPC;

    G = DarkestHourGame(Level.Game);

    if (G == none || !G.bForgiveFFKillsEnabled || LastFFKiller == none)
    {
        return;
    }

    Level.Game.BroadcastLocalizedMessage(Level.Game.default.GameMessageClass, 19, LastFFKiller, PlayerReplicationInfo);
    LastFFKiller.FFKills -= LastFFKillAmount;

    KillerPC = DHPlayer(LastFFKiller.Owner);

    // If LastFFKiller's weapons are locked, unlock that player's weapons
    if (KillerPC != none && KillerPC.AreWeaponsLocked(true))
    {
        KillerPC.LockWeapons(1); // Unlock weapons as soon as possible
        KillerPC.ReceiveLocalizedMessage(class'DHWeaponsLockedMessage', 2); // "Weapons are now unlocked"
    }

    // Set none as we have handled the current LastFFKiller
    LastFFKiller = none;
}

function ServerPunishLastFFKiller()
{
    local DHPlayer PC;

    if (LastFFKiller != none && LastFFKiller.Owner != none)
    {
        PC = DHPlayer(LastFFKiller.Owner);

        PC.ReceiveScoreEvent(class'DHScoreEvent_TeamKillPunish'.static.Create());
    }

    LastFFKiller = none;
}

function ServerSquadSay(string Msg)
{
    local DarkestHourGame G;

    // Forgive via typing
    if (Msg ~= "np" || Msg ~= "forgive" || Msg ~= "no prob" || Msg ~= "no problem")
    {
        ServerForgiveLastFFKiller();
    }

    LastActiveTime = Level.TimeSeconds;

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        G.BroadcastSquad(self, Level.Game.ParseMessageString(Level.Game.BaseMutator, self, Msg) , 'SquadSay');
    }
}

exec function SquadMenu()
{
    // Open deploy menu with squad tab active
    bPendingMapDisplay = false;

    // Tell the deploy menu to start up in squad mode
    DeployMenuStartMode = MODE_Squads;
    ClientReplaceMenu("DH_Interface.DHDeployMenu");
}

function OnCommandInteractionHidden()
{
    CommandInteraction = none;
}

function ShowCommandInteractionWithMenu(string MenuClassName, optional Object MenuObject, optional bool bShouldHideOnLeftMouseRelease)
{
    if (CommandInteraction != none)
    {
        CommandInteraction.TearDown();
    }

    CommandInteraction = DHCommandInteraction(Player.InteractionMaster.AddInteraction("DH_Engine.DHCommandInteraction", Player));

    if (CommandInteraction != none)
    {
        CommandInteraction.OnHidden = OnCommandInteractionHidden;
        CommandInteraction.bShouldHideOnLeftMouseRelease = bShouldHideOnLeftMouseRelease;
        CommandInteraction.PushMenu(MenuClassName, MenuObject);
    }
}

exec function ShowOrderMenu()
{
    local string MenuClassName;
    local Object MenuObject;

    if (CommandInteraction == none && Pawn != none && !IsDead() && GetCommandInteractionMenu(MenuClassName, MenuObject))
    {
        ShowCommandInteractionWithMenu(MenuClassName, MenuObject);
    }
}

// Returns the menu that should be displayed when ShowOrderMenu is called.
function bool GetCommandInteractionMenu(out string MenuClassName, out Object MenuObject)
{
    local DHPawn OtherPawn, P;
    local DHPlayerReplicationInfo PRI;
    local DHRadio Radio;
    local DHATGun Gun;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal;
    local Actor HitActor;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI == none)
    {
        return false;
    }

    if (DHPawn(Pawn) != none && DHPawn(Pawn).GunToRotate != none)
    {
        return false;
    }

    TraceStart = Pawn.Location + Pawn.EyePosition();
    TraceEnd = TraceStart + (GetMaxViewDistance() * vector(Rotation));

    foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        if (HitActor.IsA('DHRadio'))
        {
            Radio = DHRadio(HitActor);

            // Verify that we are capable of using the radio.
            if (Radio.GetRadioUsageError(Pawn) == ERROR_None)
            {
                MenuClassName = "DH_Engine.DHCommandMenu_Radio";
                MenuObject = Radio;
                return true;
            }
        }
        else if (HitActor.IsA('DHATGun'))
        {
            Gun = DHATGun(HitActor);
            P = DHPawn(Pawn);

            if (P != none && Gun != none && Gun.GetRotationError(P) != ERROR_TooFarAway && !Gun.bVehicleDestroyed)
            {
                // TODO: we need some sort of way to check if we're being auto-traced?
                // perhaps keep tabs on who the tracer was using timeseconds + pawn in the AT gun?
                MenuClassName = "DH_Engine.DHCommandMenu_ATGun";
                MenuObject = HitActor;
                return true;
            }
        }
        else if (HitActor.IsA('DHPawn'))
        {
            OtherPawn = DHPawn(HitActor);

            if (OtherPawn == Pawn)
            {
                continue;
            }

            if (OtherPawn.Radio != none)
            {
                // Verify that we are capable of using the radio.
                if (OtherPawn.Radio.GetRadioUsageError(Pawn) == ERROR_None)
                {
                    MenuClassName = "DH_Engine.DHCommandMenu_Radio";
                    MenuObject = OtherPawn.Radio;
                    return true;
                }
            }

            if (PRI.IsSquadLeader())
            {
                if (OtherPawn.GetTeamNum() == GetTeamNum())
                {
                    MenuObject = OtherPawn;
                }

                MenuClassName = "DH_Engine.DHCommandMenu_SquadLeader";
                return true;
            }
        }
    }

    if (PRI.IsSquadLeader())
    {
        MenuClassName = "DH_Engine.DHCommandMenu_SquadLeader";
        return true;
    }
    else if (PRI.bIsSquadAssistant)
    {
        MenuClassName = "DH_Engine.DHCommandMenu_SquadAssistant";
        return true;
    }
    else if (!PRI.IsInSquad())
    {
        MenuClassName = "DH_Engine.DHCommandMenu_LoneWolf";
        return true;
    }
    else if (PRI.IsPatron())
    {
        MenuClassName = "DH_Engine.DHCommandMenu_Patron";
        return true;
    }

    return false;
}

exec function HideOrderMenu()
{
    if (CommandInteraction != none)
    {
        CommandInteraction.Hide();
    }
}

function bool TeleportPlayer(vector SpawnLocation, rotator SpawnRotation)
{
    if (Pawn != none && Pawn.SetLocation(SpawnLocation))
    {
        Pawn.SetRotation(SpawnRotation);
        Pawn.SetViewRotation(SpawnRotation);
        Pawn.ClientSetRotation(SpawnRotation);

        return true;
    }

    return false;
}

// Modified to allow for switching to a channel the user is already a member of (for private channels)
function ServerSpeak(int ChannelIndex, optional string ChannelPassword)
{
    local VoiceChatRoom VCR;
    local int Index;

    if (VoiceReplicationInfo == none)
    {
        return;
    }

    VCR = VoiceReplicationInfo.GetChannelAt(ChannelIndex);

    if (VCR == none)
    {
        if (VoiceReplicationInfo.bEnableVoiceChat)
        {
            ChatRoomMessage(0, ChannelIndex);
        }
        else
        {
            ChatRoomMessage(15, ChannelIndex);
        }

        return;
    }

    if (!VCR.IsMember(PlayerReplicationInfo) && VCR.IsPublicChannel())
    {
        if (ServerJoinVoiceChannel(ChannelIndex, ChannelPassword) != JCR_Success)
        {
            return;
        }
    }

    Index = -1;
    ActiveRoom = VCR;
    Log(PlayerReplicationInfo.PlayerName @ "speaking on" @ VCR.GetTitle(), 'VoiceChat');
    ChatRoomMessage(9, ChannelIndex);
    ClientSetActiveRoom(VCR.ChannelIndex);
    Index = VCR.ChannelIndex;

    if (PlayerReplicationInfo != none)
    {
        PlayerReplicationinfo.ActiveChannel = Index;
    }
}

simulated event ChatRoomMessage(byte Result, int ChannelIndex, optional PlayerReplicationInfo RelatedPRI)
{
    local VoiceChatRoom     VCR;

    if (VoiceReplicationInfo != none && ChatRoomMessageClass != none)
    {
        VCR = VoiceReplicationInfo.GetChannelAt(ChannelIndex);

        if (VCR == none)
        {
            return;
        }

        // Do not send client message globally for each player (probably should be in the AssembleMessage() function, but want to avoid overriding that)
        if (Result == 11)
        {
            return;
        }

        if (!VCR.IsPrivateChannel())
        {
            ClientMessage(ChatRoomMessageClass.static.AssembleMessage(Result, VCR.GetTitle(), RelatedPRI));
        }
        else
        {
            ClientMessage(ChatRoomMessageClass.static.AssembleMessage(Result, class'DHVoiceReplicationInfo'.default.LocalChannelText, RelatedPRI));
        }
    }
}

// Modified to get the default channel as the player's personal local channel
simulated function string GetDefaultActiveChannel()
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI != none)
    {
        return PRI.PlayerName;
    }
    else
    {
        return super.GetDefaultActiveChannel();
    }
}

// Returns true if there are players to spectate.
function bool PlayersToSpectate()
{
    local Controller C;

    // Make sure there are players we can spectate. If not, leave the players
    // looking at their corpse.
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C != self && Level.Game.CanSpectate(self, PlayerReplicationInfo.bOnlySpectator, C))
        {
            return true;
        }
    }

    return false;
}

// Modified to eliminate a bug where the user could spectate controllers that
// didn't have pawns.
function ServerViewNextPlayer()
{
    local Controller C, NewTarget;
    local bool bFound, bRealSpec, bWasSpec;

    bRealSpec = PlayerReplicationInfo.bOnlySpectator;
    bWasSpec = !bBehindView && ViewTarget != Pawn && ViewTarget != self;
    PlayerReplicationInfo.bOnlySpectator = true;

    // This loop finds the next controller to view.
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.Pawn != none && Level.Game.CanSpectate(self, bRealSpec, C))
        {
            if (NewTarget == none)
            {
                // Set the new target to the first valid spectator thing that
                // we find. This is necessary so that we can effectively "loop"
                // once we've reached the end of the list.
                NewTarget = C;
            }

            if (bFound)
            {
                // We found our previous view target last iteration, so this
                // is the real deal now!
                NewTarget = C;
                break;
            }
            else
            {
                // Check if this controller is our current one, if it is, mark
                // bFound as true so that we can get a new target after.
                bFound = RealViewTarget == C || ViewTarget == C;
            }
        }
    }

    SetViewTarget(NewTarget);
    ClientSetViewTarget(NewTarget);

    bBehindView = true;

    if (ViewTarget == self || bWasSpec || ROTeamGame(Level.Game).bSpectateFirstPersonOnly)
    {
        bBehindView = false;
    }

    ClientSetBehindView(bBehindView);

    PlayerReplicationInfo.bOnlySpectator = bRealSpec;
}

simulated function int GetValidSpecModeCount()
{
    local ESpectatorMode Mode;
    local int Count;

    Mode = SPEC_Self;

    do
    {
        if (IsSpecModeValid(Mode))
        {
            ++Count;
        }

        Mode = ESpectatorMode((int(Mode) + 1) % 4);
    }
    until (Mode == SPEC_Self)

    return Count;
}

simulated function bool IsSpecModeValid(ESpectatorMode Mode)
{
    if (Mode == SPEC_Self)
    {
        return true;
        //return !bViewBlackOnDeadNotViewingPlayers && Pawn != none && PlayerReplicationInfo != none && !PlayerReplicationInfo.bOnlySpectator;
    }
    else if (Mode == SPEC_Roaming)
    {
        return !bViewBlackonDeadNotViewingPlayers && bAllowRoamWhileSpectating && (!IsDead() || (bAllowRoamWhileDeadSpectating && !bViewBlackWhenDead));
    }
    else if (Mode == SPEC_Players)
    {
        return PlayersToSpectate();
    }
    else if (Mode == SPEC_ViewPoints)
    {
        return !bViewBlackOnDeadNotViewingPlayers && bSpectateAllowViewPoints;
    }

    return false;
}

// Get the next valid spectator mode based on the servers settings
function ESpectatorMode GetNextValidSpecMode()
{
    local ESpectatorMode NextSpecMode;

    NextSpecMode = SpecMode;

    do
    {
        NextSpecMode = ESpectatorMode((int(NextSpecMode) + 1) % 4);

        if (IsSpecModeValid(NextSpecMode))
        {
            break;
        }
    }
    until (NextSpecMode == SpecMode)

    return NextSpecMode;
}

state Spectating
{
    ignores SwitchWeapon, RestartLevel, ClientRestart, Suicide, ThrowWeapon, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange;

    exec function Jump(optional float F)
    {
        TryToActivateSituationMap();
    }
}

exec function GiveCamera()
{
    Pawn.GiveWeapon("DH_Construction.DHCameraWeapon");
}

// Modified to fix "accessed none" errors when the ChatManager isn't set.
function ServerRequestBanInfo(int PlayerID)
{
    local array<PlayerController> Controllers;
    local PlayerController PC;
    local int i;

    if (Level != none && Level.Game != none)
    {
        Level.Game.GetPlayerControllerList(Controllers);

        for (i = 0; i < Controllers.Length; ++i)
        {
            PC = Controllers[i];

            // Don't send our own info
            if (PC == none || PC == self)
            {
                continue;
            }

            if (PlayerID == -1 || PC.PlayerReplicationInfo.PlayerID == PlayerID)
            {
                Log(Name @ "Sending BanInfo To Client PlayerID:" $ PC.PlayerReplicationInfo.PlayerID @ "Hash:" $ PC.GetPlayerIDHash() @ "Address:" $ PC.GetPlayerNetworkAddress(), 'ChatManager');

                if (ChatManager != none)
                {
                    ChatManager.TrackNewPlayer(PC.PlayerReplicationInfo.PlayerID, PC.GetPlayerIDHash(), PC.GetPlayerNetworkAddress());
                }

                ClientReceiveBan(PC.PlayerReplicationInfo.PlayerID $ Chr(27) $ PC.GetPlayerIDHash() $ Chr(27) $ PC.GetPlayerNetworkAddress());
            }
        }
    }
}

// TODO: this needs ot change!
function PatronRequestOnResponse(HTTPRequest Request, int Status, TreeMap_string_string Headers, string Content)
{
    local JSONParser Parser;
    local JSONObject O, Patron;
    local JSONArray Results;

    if (Status == 200)
    {
        Log("Patron status request success (" $ Status  $ ")");

        Parser = new class'JSONParser';
        O = Parser.ParseObject(Content);

        Results = O.Get("results").AsArray();

        if (Results.Size() == 1)
        {
            Patron = Results.Get(0).AsObject();

            if (Patron != none)
            {
                ServerSetPatronTier(Patron.Get("tier").AsString());
            }
        }
    }
}

// Client-to-server function that reports the player's patron tier to the server.
function ServerSetPatronTier(string PatronTier)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI != none)
    {
        PRI.PatronTier = GetPatronTier(PatronTier);
    }
}

function DHPlayerReplicationInfo.EPatronTier GetPatronTier(string Tier)
{
    switch (Tier)
    {
        case "lead":
            return PATRON_Lead;
        case "bronze":
            return PATRON_Bronze;
        case "silver":
            return PATRON_Silver;
        case "gold":
            return PATRON_Gold;
        default:
            return PATRON_None;
    }
}

// Client-to-server function when player wants to volunteer to be squad leader.
function ServerSquadLeaderVolunteer(int TeamIndex, int SquadIndex)
{
    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.VolunteerForSquadLeader(DHPlayerReplicationInfo(PlayerReplicationInfo), TeamIndex, SquadIndex);
    }
}

function ServerRequestArtillery(DHRadio Radio, int ArtilleryTypeIndex)
{
    if (Radio != none && Pawn != none)
    {
        Radio.RequestArtillery(Pawn, ArtilleryTypeIndex);
    }
}

function ServerCancelArtillery(DHRadio Radio, int ArtilleryTypeIndex)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].ArtilleryActor != none &&
        GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].ArtilleryActor.bCanBeCancelled &&
        GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].ArtilleryActor.Requester == self)
    {
        ReceiveLocalizedMessage(class'DHArtilleryMessage', 8,,, GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].ArtilleryActor.Class);

        GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].ArtilleryActor.Destroy();
    }
}

// Scoring
function ReceiveScoreEvent(DHScoreEvent ScoreEvent)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (ScoreManager != none && GRI != none)
    {
        ScoreManager.HandleScoreEvent(ScoreEvent, GRI);
    }
}

simulated function ClientTeamSurrenderResponse(int Result)
{
    local UT2K4GUIController GC;
    local GUIPage Page;

    // Find the currently open ROGUIRoleSelection menu and notify it
    GC = UT2K4GUIController(Player.GUIController);

    if (GC == none)
    {
        return;
    }

    Page = GC.FindMenuByClass(class'GUIPage');

    if (Page != none)
    {
        Page.OnMessage("NOTIFY_GUI_SURRENDER_RESULT", Result);
    }
}

function ServerTeamSurrenderRequest(optional bool bAskForConfirmation)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G == none || G.VoteManager == none)
    {
        return;
    }

    // Keep fighting
    if (bSurrendered)
    {
        G.VoteManager.RemoveNomination(self, class'DHVoteInfo_TeamSurrender');
        return;
    }

    // Surrender
    if (bAskForConfirmation)
    {
        if (class'DHVoteInfo_TeamSurrender'.static.CanNominate(self, G))
        {
            // Send the confirmation prompt
            ClientTeamSurrenderResponse(-1);
        }
    }
    else
    {
        G.VoteManager.AddNomination(self, class'DHVoteInfo_TeamSurrender');
    }
}

function ServerSendVote(int VoteId, int OptionIndex)
{
    local DarkestHourGame G;
    local DHVoteManager VM;

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        VM = G.VoteManager;

        if (VM != none)
        {
            VM.PlayerVoted(self, VoteId, OptionIndex);
        }
    }
}

simulated function ClientReceiveVotePrompt(class<DHVoteInfo> VoteInfoClass, int VoteId, optional string OptionalString)
{
    // TODO: display the interaction prompt!
    // TODO: how are we showing other interactions?
    class'DHVoteInteraction'.default.VoteInfoClass = VoteInfoClass;
    class'DHVoteInteraction'.default.VoteId = VoteId;

    Player.InteractionMaster.AddInteraction("DH_Engine.DHVoteInteraction", Player);
}

simulated function Destroyed()
{
    super.Destroyed();

    if (Role == ROLE_Authority)
    {
        ScoreManager = none;

        if (IQManager != none)
        {
            IQManager.Destroy();
        }
    }
}

// Functions emptied out as RO/DH doesn't use a LocalStatsScreen actor & these aren't used
function ServerUpdateStats(TeamPlayerReplicationInfo PRI);
function ServerUpdateStatArrays(TeamPlayerReplicationInfo PRI);
function ServerGetNextWeaponStats(TeamPlayerReplicationInfo PRI, int i);
function ServerGetNextVehicleStats(TeamPlayerReplicationInfo PRI, int i);
simulated function ClientSendWeapon(TeamPlayerReplicationInfo PRI, class<Weapon> W, int Kills, int Deaths, int DeathsHolding, int i);
simulated function ClientSendVehicle(TeamPlayerReplicationInfo PRI, class<Vehicle> V, int Kills, int Deaths, int DeathsDriving, int i);
simulated function ClientSendSprees(TeamPlayerReplicationInfo PRI,byte Spree0,byte Spree1,byte Spree2,byte Spree3,byte Spree4,byte Spree5);
simulated function ClientSendMultiKills(TeamPlayerReplicationInfo PRI, byte MultiKills0, byte MultiKills1, byte MultiKills2, byte MultiKills3, byte MultiKills4, byte MultiKills5, byte MultiKills6);
simulated function ClientSendCombos(TeamPlayerReplicationInfo PRI,byte Combos0, byte Combos1, byte Combos2, byte Combos3, byte Combos4);
simulated function ClientSendStats(TeamPlayerReplicationInfo PRI, int NewGoals, bool bNewFirstBlood, int Newkills, int NewSuicides,
    int NewFlagTouches, int NewFlagReturns, int NewFlakCount, int NewComboCount, int NewHeadCount, int NewRanOverCount);

// We're hijacking InventoryActivate (since it does literally nothing and is
// by default bound to the Enter key which is unused otherwise).
function bool TryToActivateSituationMap()
{
    local GUIController GUIController;
    local int MenuIndex;
    local DHHud HUD;

    HUD = DHHud(myHUD);

    if (HUD == none)
    {
        return false;
    }

    MenuIndex = -1;
    GUIController = GUIController(Player.GUIController);

    if (GUIController != none)
    {
        MenuIndex = GUIController.FindMenuIndexByName("DH_Interface.DHSituationMapGUIPage");
    }

    if (MenuIndex != -1)
    {
        QueueHint(52, false);
        QueueHint(53, false);

        GUIController.bActive = true;
        HUD.MouseInterfaceStartCapturing();
        HUD.bShowObjectives = true;
        bShouldSkipResetInput = true;

        GUIController.MouseX = GUIController.ResX / 2;
        GUIController.MouseY = GUIController.ResY / 2;

        return true;
    }

    return false;
}

exec function Jump(optional float F)
{
    if (!TryToActivateSituationMap())
    {
        super.Jump(F);
    }
}

//==============================================================================
// SQUAD MERGE REQUESTS
//==============================================================================
function ServerSendSquadMergeRequest(int RecipientSquadIndex)
{
    local DHSquadReplicationInfo.ESquadMergeRequestResult Result;

    if (SquadReplicationInfo != none)
    {
        Result = SquadReplicationInfo.SendSquadMergeRequest(self, GetTeamNum(), GetSquadIndex(), RecipientSquadIndex);

        ClientSendSquadMergeRequestResult(Result);
    }
}

function ServerAcceptSquadMergeRequest(int SquadMergeRequestID)
{
    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.AcceptSquadMergeRequest(self, SquadMergeRequestID);
    }
}

function ServerDenySquadMergeRequest(int SquadMergeRequestID)
{
    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.DenySquadMergeRequest(self, SquadMergeRequestID);
    }
}

function ClientReceiveSquadMergeRequest(int SquadMergeRequestID, string SenderPlayerName, string SenderSquadName)
{
    if (bIgnoreSquadMergeRequestPrompts)
    {
        ServerDenySquadMergeRequest(SquadMergeRequestID);
        return;
    }

    class'DHSquadMergeRequestInteraction'.default.SquadMergeRequestID = SquadMergeRequestID;
    class'DHSquadMergeRequestInteraction'.default.SenderPlayerName = SenderPlayerName;
    class'DHSquadMergeRequestInteraction'.default.SenderSquadName = SenderSquadName;

    Player.InteractionMaster.AddInteraction("DH_Engine.DHSquadMergeRequestInteraction", Player);
}

function ClientSendSquadMergeRequestResult(DHSquadReplicationInfo.ESquadMergeRequestResult Result)
{
    local UT2K4GUIController GUIController;
    local GUIPage Page;

    // Find the currently open ROGUIRoleSelection menu and notify it
    GUIController = UT2K4GUIController(Player.GUIController);

    if (GUIController == none)
    {
        return;
    }

    Page = GUIController.FindMenuByClass(class'GUIPage');

    if (Page != none)
    {
        Page.OnMessage("SQUAD_MERGE_REQUEST_RESULT", int(Result));
    }
}

simulated function bool IsSquadLeader()
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    return PRI != none && PRI.IsSquadLeader();
}

function ClientLocationalVoiceMessage(PlayerReplicationInfo Sender,
                                      PlayerReplicationInfo Recipient,
                                      name messagetype, byte messageID,
                                      optional Pawn senderPawn, optional vector senderLocation)
{
    local VoicePack Voice;
    local ROVoicePack V;
    local bool bIsTeamVoice;
    local class<ROVoicePack> ROV;
    local ROPlayerReplicationInfo PRI;

    if (Sender == none || Sender.VoiceType == none || Sender.Team == none || Player.Console == none || Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    // If the sender is receiving the sound then allow them to hear the
    // voicepack from their settings instead of the regular voicepack
    PRI = ROPlayerReplicationInfo(Sender);

    if (PRI != none && PRI.RoleInfo != none)
    {
        if (Level.GetLocalPlayerController().PlayerReplicationInfo.Team == none ||
            Sender.Team.TeamIndex == Level.GetLocalPlayerController().PlayerReplicationInfo.Team.TeamIndex)
        {
            ROV = class<ROVoicePack>(DynamicLoadObject(PRI.RoleInfo.AltVoiceType, class'Class'));
            bIsTeamVoice = true;
            V = Spawn(ROV, self);
        }
        else
        {
            ROV = class<ROVoicePack>(DynamicLoadObject(PRI.RoleInfo.VoiceType, class'Class'));
            V = Spawn(ROV, self);

            if (V != none)
            {
                V.bUseLocationalVoice = true;
                V.bIsFromDifferentTeam = true;
            }
        }

        if (V != none)
        {
            V.ClientInitializeLocational(Sender, Recipient, MessageType, MessageID, SenderPawn, SenderLocation);

            if (bIsTeamVoice)
            {
                if (MessageType == 'VEH_ORDERS' || MessageType == 'VEH_ALERTS' || MessageType == 'VEH_GOTO')
                {
                    VehicleVoiceMessage(Sender, V.getClientParsedMessage());
                }
                else if (MessageType == 'TAUNT')
                {
                    TeamMessage(Sender, V.getClientParsedMessage(), 'VOICESAY');
                }
                else
                {
                    TeamMessage(Sender, V.getClientParsedMessage(), 'VOICESAY');
                }
            }
        }
    }
    else
    {
        Voice = Spawn(Sender.VoiceType, self);

        if (Voice != none)
        {
            Log("Fallback: voice.ClientInitialize(Sender, Recipient, messagetype, messageID);");
            Voice.ClientInitialize(Sender, Recipient, MessageType, MessageID);
        }
    }
}

function VehicleVoiceMessage(PlayerReplicationInfo Sender, string Msg)
{
    local ROBroadcastHandler Handler;

    if (Level != none &&
        Level.Game != none &&
        Level.Game.BroadcastHandler != none &&
        Level.Game.BroadcastHandler.IsA('ROBroadcastHandler'))
    {
        Handler = ROBroadcastHandler(Level.Game.BroadcastHandler);
        Handler.BroadcastText(Sender, self, Msg, 'VehicleVoiceSay');
    }
}

function SendVoiceMessage(PlayerReplicationInfo Sender,
                          PlayerReplicationInfo Recipient,
                          name MessageType,
                          byte MessageID,
                          name BroadcastType,
                          optional Pawn SoundSender,
                          optional vector SenderLocation)
{
    local Controller P;
    local ROPlayer ROP;
    local ROBot ROB;
    local float DistanceToOther;
    local array<Controller> VehicleOccupants;
    local int i;

    if (!AllowVoiceMessage(MessageType))
    {
        return;
    }

    if (MessageType == 'VEH_ORDERS' || MessageType == 'VEH_ALERTS' || MessageType == 'VEH_GOTO')
    {
        SendVehicleVoiceMessage(Sender, Recipient, MessageType, MessageID, BroadcastType);
        ROP = ROPlayer(Sender.Owner);
        VehicleOccupants = GetBotVehicleOccupants(ROP);

        for (i = 0; i < VehicleOccupants.length; ++i)
        {
            ROB = ROBot(VehicleOccupants[i]);

            if (ROB != none)
            {
                ROB.BotVoiceMessage(MessageType, MessageID, self);
            }
        }

        return;
    }

    for (P = Level.ControllerList; P != none; P = P.NextController)
    {
        ROP = ROPlayer(P);

        if (ROP != none)
        {
            if (Pawn != none)
            {
                // do we want people who are dead to hear voice commands? - Antarian
                if (ROP.Pawn != none && Pawn != ROP.Pawn)
                {
                    DistanceToOther = VSize(Pawn.Location - ROP.Pawn.Location);

                    if (class'ROVoicePack'.static.isValidDistanceForMessageType(messagetype,distanceToOther))
                    {
                        if (ROP.PlayerReplicationInfo.Team.TeamIndex == PlayerReplicationInfo.Team.TeamIndex)
                        {
                            ROP.ClientLocationalVoiceMessage(Sender, Recipient, MessageType, MessageID, none, SenderLocation);
                        }
                        else
                        {
                            ROP.ClientLocationalVoiceMessage(Sender, Recipient, MessageType, MessageID, SoundSender, SenderLocation);
                        }
                    }
                }
                else
                {
                    // Sending to self
                   ROP.ClientLocationalVoiceMessage(Sender, Recipient, MessageType, MessageID, SoundSender, SenderLocation);
                }
            }
        }
        else if ((MessageType == 'ORDER' || MessageType == 'ATTACK' || MessageType == 'DEFEND') &&
                 (Recipient == none || Recipient == P.PlayerReplicationInfo ||
                 (Bot(P) != none && Bot(P).Squad != none && Bot(P).Squad.SquadLeader != none && Bot(P).Squad.SquadLeader.PlayerReplicationInfo == Recipient)))
        {
            P.BotVoiceMessage(MessageType, MessageID, self);
        }
    }

    // Lets make the bots attack/defend particular objectives
    if (MessageType == 'ATTACK' || MessageType == 'DEFEND')
    {
        if (Recipient == none)
        {
            ROTeamGame(Level.Game).SetTeamAIObjectives(messageID, PlayerReplicationInfo.Team.TeamIndex);
        }
        else
        {
            ROTeamGame(Level.Game).SetSquadObjectives(messageID, PlayerReplicationInfo.Team.TeamIndex, Recipient);
        }
    }

    // Add to 'help request' array if needed
    if (MessageType == 'ATTACK')
    {
        AttemptToAddHelpRequest(PlayerReplicationInfo, MessageID, 1, GetObjectiveLocation(MessageID)); // Send locations all the time (easier on hud drawing code)
    }
    else if (MessageType == 'DEFEND')
    {
        AttemptToAddHelpRequest(PlayerReplicationInfo, MessageID, 2, GetObjectiveLocation(MessageID)); // Ditto
    }
    else if (MessageType == 'HELPAT')
    {
        AttemptToAddHelpRequest(PlayerReplicationInfo, MessageID, 0, GetObjectiveLocation(MessageID)); // Idem
    }
    else if (MessageType == 'SUPPORT' && MessageID == 0) // need help at coords
    {
        if (Pawn != none)
        {
            AttemptToAddHelpRequest(PlayerReplicationInfo, MessageID, 4, Pawn.location);
        }
    }
    else if (MessageType == 'SUPPORT' && MessageID == 2) // need mg ammo
    {
        if (Pawn != none)
        {
            AttemptToAddHelpRequest(PlayerReplicationInfo, MessageID, 3, Pawn.location);
        }
    }
}

exec function TestIp(string IpAddress)
{
    if (Level.NetMode == NM_Standalone)
    {
        class'DHGeolocationService'.static.GetIpDataTest(self, IpAddress);
    }
}

exec function IpCache()
{
    if (Level.NetMode == NM_Standalone)
    {
        class'DHGeolocationService'.static.DumpCache();
    }
}

exec function SetCountry(string CountryCode)
{
    local DHPlayerReplicationInfo PRI;

    if (Level.NetMode == NM_Standalone)
    {
        PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

        PRI.CountryIndex = class'DHGeoLocationService'.static.GetCountryCodeIndex(CountryCode);
    }
}

exec function IpFuzz(int Iterations)
{
    local int Result;
    local string IpAddress, CountryCode;

    if (Level.NetMode == NM_Standalone)
    {
        if (Iterations == 0)
        {
            Iterations = 1000;
        }

        while (Iterations-- > 0)
        {
            IpAddress = Rand(256) $ "." $ Rand(256) $ "." $ Rand(256) $ "." $ Rand(256);
            CountryCode = class'DHGeolocationService'.default.CountryCodes[Rand(class'DHGeolocationService'.default.CountryCodes.Length)];

            class'DHGeolocationService'.static.AddIpCountryCode(IpAddress, CountryCode);

            // Once more to test that it can't be inserted twice!
            Result = class'DHGeolocationService'.static.AddIpCountryCode(IpAddress, CountryCode);

            if (Result != -1)
            {
                Warn("BAD RESULT" @ RESULT);
            }
        }

        class'DHGeolocationService'.static.StaticSaveConfig();
    }
}

simulated function GetEyeTraceLocation(out vector HitLocation, out vector HitNormal)
{
    local vector TraceStart, TraceEnd;
    local Actor A, HitActor;

    if (Pawn == none)
    {
        HitLocation = vect(0, 0, 0);
    }

    TraceStart = CalcViewLocation;
    TraceEnd = TraceStart + (vector(CalcViewRotation) * Pawn.Region.Zone.DistanceFogEnd);

    foreach TraceActors(class'Actor', A, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        if (A == Pawn ||
            A.IsA('ROBulletWhipAttachment') ||
            A.IsA('Volume'))
        {
            continue;
        }

        HitActor = A;

        break;
    }

    if (HitActor == none)
    {
        HitLocation = TraceEnd;
    }
}

simulated function bool CanUseFireSupportMenu()
{
    local DHPawn P;

    if (Pawn == none)
    {
        return false;
    }

    if (Pawn.IsA('Vehicle'))
    {
        P = DHPawn(Vehicle(Pawn).Driver);
    }
    else
    {
        P = DHPawn(Pawn);
    }

    return P != none && IsSquadLeader();
}

function AddMarker(class<DHMapMarker> MarkerClass, float MapLocationX, float MapLocationY, optional vector L)
{
    local DHGameReplicationInfo GRI;
    local vector                WorldLocation;
    local int                   MapMarkerPlacingLockTimeout;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    // NOTE: Using vect(0,0,0) as a "null" value might be unreliable.
    if (GRI != none && L == vect(0, 0, 0))
    {
        WorldLocation = GRI.GetWorldCoords(MapLocationX, MapLocationY);
    }
    else
    {
        WorldLocation = L;
    }

    if (MarkerClass.default.Cooldown > 0)
    {
        MapMarkerPlacingLockTimeout = GetLockingTimeout(MarkerClass);

        if (MapMarkerPlacingLockTimeout > 0)
        {
            ReceiveLocalizedMessage(class'DHFireSupportMessage', 1,,, class'UInteger'.static.Create(MapMarkerPlacingLockTimeout));
            return;
        }
    }

    if (MarkerClass.default.Scope == PERSONAL)
    {
        AddPersonalMarker(MarkerClass, MapLocationX, MapLocationY, WorldLocation);
    }
    else
    {
        ServerAddMapMarker(MarkerClass, MapLocationX, MapLocationY, WorldLocation);
    }
}

exec function DebugAddMapMarker(string MapMarkerClassName, int x, int y)
{
    local class<DHMapMarker> MapMarkerClass;
    local float xx, yy;

    if (IsDebugModeAllowed())
    {
        xx = float(x)/10;
        yy = float(y)/10;
        MapMarkerClass = class<DHMapMarker>(DynamicLoadObject("DH_Engine." $ MapMarkerClassName, class'Class'));
        Log("adding map marker: MapMarkerClass" @ MapMarkerClass @ "," @ xx @ "," @ yy);
        AddMarker(MapMarkerClass, xx, yy);
    }
}

function RemoveMarker(class<DHMapMarker> MarkerClass, optional int Index)
{
    if (Index < 0)
    {
        return;
    }

    if (MarkerClass.default.Scope == PERSONAL)
    {
        RemovePersonalMarker(Index);
    }
    else
    {
        ServerRemoveMapMarker(Index);
    }
}

exec simulated function ListWeapons()
{
    class'DHWeaponRegistry'.static.DumpToLog(self);
}

exec function DebugStartRound()
{
    local DHGameReplicationInfo GRI;
    local DHSetupPhaseManager SPM;

    if (IsDebugModeAllowed())
    {
        GRI = DHGameReplicationInfo(GameReplicationInfo);
        if (GRI == none || !GRI.bIsInSetupPhase)
        {
            return;
        }

        GRI.SpawningEnableTime = 0;

        foreach AllActors(class'DHSetupPhaseManager', SPM)
        {
            SPM.ModifySetupPhaseDuration(3, true);
        }
    }
}

function int GetLockingTimeout(class<DHMapMarker> MapMarkerClass)
{
    local DHGameReplicationInfo GRI;
    local int ExpiryTime;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if(MapMarkerClass.default.Cooldown > 0)
    {
        switch(MapMarkerClass.default.OverwritingRule)
        {
            case UNIQUE:
                MapMarkerCooldowns.Get("" $ MapMarkerClass, ExpiryTime);
                return ExpiryTime - GRI.ElapsedTime;
            case UNIQUE_PER_GROUP:
                // to do: implement an int->int hashmap & use it here
                MapMarkerCooldowns.Get("" $ MapMarkerClass.default.GroupIndex, ExpiryTime);
                return ExpiryTime - GRI.ElapsedTime;
        }
    }

    return 0;
}

function ClientSetMapMarkerClassLock(class <DHMapMarker> MapMarkerClass, int ExpiryTime)
{
    SetMapMarkerClassLock(MapMarkerClass, ExpiryTime);
}

function LockMapMarkerPlacing(class<DHMapMarker> MapMarkerClass)
{
    local int ExpiryTime;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (MapMarkerClass == none || GRI == none || MapMarkerClass.default.Cooldown <= 0)
    {
        return;
    }

    ExpiryTime = GRI.ElapsedTime + MapMarkerClass.default.Cooldown;

    if(MapMarkerClass.default.Scope != PERSONAL)
    {
        // We are on the server at this point, as this function is called from OnMapMarkerPlaced
        // which for non-personal markers is executed on the server.
        // Save the lock expiry time on the client.
        ClientSetMapMarkerClassLock(MapMarkerClass, ExpiryTime);
    }
    else
    {
        // We are on the client here anyway.
        SetMapMarkerClassLock(MapMarkerClass, ExpiryTime);
    }

    return;
}

function SetMapMarkerClassLock(class <DHMapMarker> MapMarkerClass, int ExpiryTime)
{
    switch (MapMarkerClass.default.OverwritingRule)
    {
        case UNIQUE:
            MapMarkerCooldowns.Put("" $ MapMarkerClass, ExpiryTime);
            break;
        case UNIQUE_PER_GROUP:
            MapMarkerCooldowns.Put("" $ MapMarkerClass.default.GroupIndex, ExpiryTime);
            break;
    }
}

exec function ToggleSelectedArtilleryTarget()
{
    local array<DHGameReplicationInfo.MapMarker> ArtilleryMarkers;
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local int i, NewSquadIndex;

    GRI = DHGameReplicationInfo(GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (GRI == none || PRI == none || SquadReplicationInfo == none || !PRI.IsArtilleryOperator())
    {
        return;
    }

    GRI.GetGlobalArtilleryMapMarkers(self, ArtilleryMarkers);

    if (ArtilleryMarkers.Length == 0)
    {
        // no artillery markers found, fall back to a neutral index
        ServerSaveArtillerySupportSquadIndex(255);
        return;
    }

    NewSquadIndex = ArtillerySupportSquadIndex + 1;

    // cycle through all squads in an increasing Round-Robin order
    // and check if there are available targets that can be selected
    while (NewSquadIndex != ArtillerySupportSquadIndex)
    {
        // look for a map marker made by the squad with the new squad index
        for (i = 0; i < ArtilleryMarkers.Length; i++)
        {
            if (NewSquadIndex == ArtilleryMarkers[i].SquadIndex)
            {
                // we found the marker we were looking for

                ServerSaveArtillerySupportSquadIndex(ArtilleryMarkers[i].SquadIndex);
                ClientPlaySound(Sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
                return;
            }
        }

        // no marker found for the new squad index
        // try the next squad
        NewSquadIndex = (NewSquadIndex + 1) % SquadReplicationInfo.TEAM_SQUADS_MAX;
    }
}

// Gets whether or not this player is able to change to this role.
function ERoleEnabledResult GetRoleEnabledResult(DHRoleInfo RI)
{
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo GRI;
    local int Count, BotCount, Limit;
    local bool bIsRoleLimitless;
    
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (RI == none || PRI == none || GRI == none) { return RER_Fatal; }

    GRI.GetRoleCounts(RI, Count, BotCount, Limit);

    if (GetRoleInfo() != RI && Limit > 0 && Count >= Limit && BotCount == 0)
    {
        return RER_Limit;
    }

    bIsRoleLimitless = (Limit == 255);

    if (GRI.GameType != none && GRI.GameType.default.bSquadSpecialRolesOnly)
    {
        if (!IsInSquad() && !bIsRoleLimitless && !RI.bExemptSquadRequirement)
        {
            return RER_SquadOnly;
        }

        if (IsInSquad() && ((RI.bRequiresSLorASL && !IsSLorASL()) || (RI.bRequiresSL && !IsSquadLeader())))
        {
            return RER_SquadLeaderOnly;
        }

        if (IsSquadLeader() && !RI.bCanBeSquadLeader)
        {
            return RER_NonSquadLeaderOnly;
        }
    }

    return RER_Enabled;
}

function DestroyShovelItem()
{
    local DHPawn P;
    local Weapon Inv;
    local Class<Weapon> ShovelClass;

    P = DHPawn(Pawn);
    ShovelClass = class<Weapon>(DynamicLoadObject("DH_Equipment.DHShovelItem", class'Class'));
    Inv = Weapon(P.FindInventoryType(ShovelClass));

    if (P != none && P.Weapon != none && ClassIsChildOf(P.Weapon.Class, ShovelClass))
    {
        // We are currently holding a shovel, let's put it away
        Inv.ClientWeaponThrown();
    }
    
     P.DeleteInventory(Inv);
}

defaultproperties
{
    CorpseStayTime=15
    CorpseStayTimeMin=5
    CorpseStayTimeMax=60

    // Sway values
    SwayCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=3.0,OutVal=0.33),(InVal=12.0,OutVal=0.25),(InVal=45.0,OutVal=0.33),(InVal=10000000000.0,OutVal=0.5)))
    DHSwayElasticFactor=8.0
    DHSwayDampingFactor=0.51
    BaseSwayYawAcc=600
    BaseSwayPitchAcc=500

    // Max turn speed values
    DHStandardTurnSpeedFactor=32.0
    DHHalfTurnSpeedFactor=16.0
    DHISTurnSpeedFactor=0.5
    DHScopeTurnSpeedFactor=0.2

    // Max flinch offset for close snaps
    FlinchMaxOffset=450.0

    // Flinch meter
    FlinchMeterSwayMultiplier=1.05
    FlinchMeterIncrement=0.08
    FlinchMeterFallOffStrength=0.04

    // Flinch from bullet snaps when deployed
    FlinchRotMag=(X=100.0,Y=0.0,Z=100.0)
    FlinchRotRate=(X=1000.0,Y=0.0,Z=1000.0)
    FlinchRotTime=1.0
    FlinchOffsetMag=(X=100.0,Y=0.0,Z=100.0)
    FlinchOffsetRate=(X=1000.0,Y=0.0,Z=1000.0)
    FlinchOffsetTime=1.0

    // FOV
    ViewFOVMin=80.0
    ViewFOVMax=100.0
    ConfigViewFOV=85.0

    // Admin-initialed paradrops
    ParadropMarkerClass=class'DH_Engine.DHMapMarker_AdminParadrop'
    ParadropHeight=10000
    ParadropSpreadModifier=600

    // Other values
    NextSpawnTime=15
    ROMidGameMenuClass="DH_Interface.DHDeployMenu"
    ChatRoomMessageClass="DH_Engine.DHChatRoomMessage"
    GlobalDetailLevel=5
    PlayerReplicationInfoClass=class'DH_Engine.DHPlayerReplicationInfo'
    InputClass=class'DH_Engine.DHPlayerInput'
    PawnClass=class'DH_Engine.DHPawn'
    SteamStatsAndAchievementsClass=none
    SpawnPointIndex=-1
    VehiclePoolIndex=-1
    SpectateSpeed=+1200.0
    MinDesiredFPS=+60

    DHPrimaryWeapon=-1
    DHSecondaryWeapon=-1

    VoiceChatCodec="CODEC_96WB"
    VoiceChatLANCodec="CODEC_96WB"

    ToggleDuckIntervalSeconds=0.5

    PersonalMapMarkerClasses(0)=class'DHMapMarker_Ruler'
    PersonalMapMarkerClasses(1)=class'DHMapMarker_AdminParadrop'

    MinIQToGrowHead=100
    ArtillerySupportSquadIndex=255
}
