//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPlayer extends ROPlayer
    dependson(DHSquadReplicationInfo);

var     DHHintManager           DHHintManager;
var     float                   MapVoteTime;
var     DH_LevelInfo            ClientLevelInfo;

// DH sway values
var     InterpCurve             BobCurve;                   // the amount of weapon bob to apply based on an input time in ironsights
var     float                   DHSwayElasticFactor;
var     float                   DHSwayDampingFactor;

// Rotation clamp values
var     float                   DHStandardTurnSpeedFactor;
var     float                   DHHalfTurnSpeedFactor;
var     globalconfig float      DHISTurnSpeedFactor;        // 0.0 to 1.0
var     globalconfig float      DHScopeTurnSpeedFactor;     // 0.0 to 1.0

// Client ROID hash (this gets set/updated when a player joins a server)
var     globalconfig string     ROIDHash;

var     vector                  FlinchRotMag;
var     vector                  FlinchRotRate;
var     float                   FlinchRotTime;
var     vector                  FlinchOffsetMag;
var     vector                  FlinchOffsetRate;
var     float                   FlinchOffsetTime;

var     float                   MantleCheckTimer;           // makes sure client doesn't try to start mantling without the server
var     float                   MantleFailTimer;            // makes sure we don't get stuck floating in an object unable to end a mantle
var     bool                    bDidMantle;                 // is the mantle complete?
var     bool                    bIsInStateMantling;         // stop the client from exiting state until server has exited to avoid desync
var     bool                    bDidCrouchCheck;
var     bool                    bWaitingToMantle;
var     bool                    bLockJump;
var     bool                    bMantleDebug;
var     int                     MantleLoopCount;

// Mortars
var     byte                    MortarTargetIndex;

// Debug:
var     bool                    bSkyOff;                    // flags that the sky has been turned off (like "show sky" console command in single player)
var     SkyZoneInfo             SavedSkyZone;               // saves the original SkyZone for the player's current ZoneInfo, so it can be restored when the sky is turned back on

// Spawning
var     byte                    SpawnPointIndex;
var     byte                    SpawnVehicleIndex;
var     byte                    VehiclePoolIndex;
var     bool                    bIsInSpawnMenu;             // player is in spawn menu and should not be auto-spawned
var     int                     NextSpawnTime;              // the next time the player will be able to spawn
var     int                     LastKilledTime;             // the time at which last death occured
var     int                     NextVehicleSpawnTime;       // the time at which a player can spawn a vehicle next (this gets set when a player spawns a vehicle)

var     int                     DHPrimaryWeapon;            // Picking up RO's slack, this should have been replicated from the outset
var     int                     DHSecondaryWeapon;

var     bool                    bSpawnPointInvalidated;

var     float                   NextChangeTeamTime;         // the time at which a player can change teams next (updated in Level.Game.ChangeTeam)

// Squads
var     DHSquadReplicationInfo  SquadReplicationInfo;
var     bool                    bIgnoreSquadInvitations;
var     vector                  SquadMemberPositions[12];   // SQUAD_SIZE_MAX

var     DHCommandInteraction SquadOrderInteraction;

const MORTAR_TARGET_TIME_INTERVAL = 5;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        NextSpawnTime, SpawnPointIndex, VehiclePoolIndex, SpawnVehicleIndex,
        DHPrimaryWeapon, DHSecondaryWeapon,
        bSpawnPointInvalidated, NextVehicleSpawnTime, LastKilledTime,
        MortarTargetIndex, SquadReplicationInfo, SquadMemberPositions;

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsInStateMantling;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerLoadATAmmo, ServerThrowMortarAmmo,
        ServerSaveMortarTarget, ServerSetPlayerInfo, ServerClearObstacle,
        ServerLeaveBody, ServerPossessBody, ServerDebugObstacles, ServerDoLog, // these ones in debug mode only
        ServerSquadCreate, ServerSquadLeave, ServerSquadJoin, ServerSquadSay,
        SeverSquadJoinAuto, ServerSquadInvite, ServerSquadKick, ServerSquadPromote,
        ServerSquadCommandeer, ServerSquadLock, ServerSquadOrder;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientCopyToClipboard, ClientProposeMenu, ClientSaveROIDHash,
        ClientProne, ClientToggleDuck, ClientConsoleCommand,
        ClientFadeFromBlack, ClientAddHudDeathMessage, ClientSquadInvite;

    // Variables the owning client will replicate to the server
    reliable if (Role < ROLE_Authority)
        ServerSetIsInSpawnMenu;
}

function ServerChangePlayerInfo(byte newTeam, byte newRole, byte NewWeapon1, byte NewWeapon2) { } // No longer used

// Modified to bypass RO design
event InitInputSystem()
{
    super(UnrealPlayer).InitInputSystem();
}

// Modified to have client setup access to DH_LevelInfo so it can get info from it
simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    // Make this only run by the owning client
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Find DH_LevelInfo and assign it to ClientLevelInfo, so client can access it
        foreach self.AllActors(class'DH_LevelInfo', ClientLevelInfo)
        {
            break;
        }
    }
}

// Matt: modified to avoid "accessed none" error
event ClientReset()
{
    local Actor A;

    // Reset client special timed sounds on the client
    foreach AllActors(class'Actor', A)
    {
        if (A.IsA('ClientSpecialTimedSound') || A.IsA('KrivoiPlaneController'))
        {
            A.Reset();
        }
    }

    //Reset camera stuff
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
        WeaponBufferRotation.Yaw += (FAAWeaponRotationFactor * DeltaTime * aTurn);
        WeaponBufferRotation.Pitch += (FAAWeaponRotationFactor * DeltaTime * aLookUp);
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

// Menu for the player's entire selection process
exec function PlayerMenu(optional int Tab)
{
    bPendingMapDisplay = false;

    if (!bWeaponsSelected)
    {
        ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
    }
    else
    {
        ClientReplaceMenu("DH_Interface.DHDeployMenu");
    }
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
        // If we haven't picked a team, role and weapons yet, or is a spectator... open the team pick menu
        if (!bWeaponsSelected ||
            PlayerReplicationInfo.Team == none ||
            PlayerReplicationInfo.Team.TeamIndex == 254)
        {
            ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
        }
        else
        {
            ClientReplaceMenu(ROMidGameMenuClass);
        }
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
        S = left(S, 32);
    }

    ReplaceText(S, "\"", "");
    DarkestHourGame(Level.Game).ChangeName(self, S, true);
}

// Give the player a quick flinch and blur effect
simulated function PlayerWhizzed(float DistSquared)
{
    local float Intensity;

    Intensity = 1.0 - ((FMin(DistSquared, 160000.0)) / 160000.0); // this is not the full size of the cylinder, we don't want a flinch on the more distant shots

    AddBlur(0.75, Intensity);
    PlayerFlinched(Intensity);
}

simulated function PlayerFlinched(float Intensity)
{
    local rotator AfterFlinchRotation;
    local float   FlinchRate, FlinchIntensity;
    local int     MaxFlinch;

    if (!Pawn.bBipodDeployed)
    {
        MaxFlinch = 150.0; // max distance that flinch can ever move

        FlinchIntensity = Intensity * MaxFlinch;

        AfterFlinchRotation.Pitch = RandRange(FlinchIntensity, MaxFlinch);
        AfterFlinchRotation.Yaw = RandRange(FlinchIntensity, MaxFlinch);

        if (Rand(2) == 1)
        {
            AfterFlinchRotation.Pitch *= -1;
        }
        if (Rand(2) == 1)
        {
            AfterFlinchRotation.Yaw *= -1;
        }

        FlinchRate = 0.075;

        SetRecoil(AfterFlinchRotation,FlinchRate);
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
}

// Updated to allow Yaw limits for mantling
// Also to disable sway on bolt rifles between shots (while weapon is lowered from face)
function UpdateRotation(float DeltaTime, float maxPitch)
{
    local rotator   NewRotation, ViewRotation;
    local ROVehicle ROVeh;
    local DHPawn    DHPwn;
    local ROWeapon  ROWeap;
    local float     TurnSpeedFactor;

    DHPwn = DHPawn(Pawn);
    ROVeh = ROVehicle(Pawn);

    if (Pawn != none)
    {
        ROWeap = ROWeapon(Pawn.Weapon);
    }

    if (bSway && Pawn != none && !Pawn.bBipodDeployed && Pawn.Weapon != none && Pawn.Weapon.bCanSway && Pawn.Weapon.bUsingSights && ROWeap != none && !ROWeap.bWaitingToBolt)
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

    if (bInterpolating || (Pawn != none && Pawn.bInterpolating))
    {
        ViewShake(DeltaTime);

        return;
    }

    // Added FreeCam control for better view control
    if (bFreeCam)
    {
        if (bHudLocksPlayerRotation)
        {
            // No camera change if we're locking rotation
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
    else
    {
        ViewRotation = Rotation;

        if (Pawn != none && Pawn.Physics != PHYS_Flying)
        {
            // Ensure we are not setting the pawn to a rotation beyond its desired
            if (Pawn.DesiredRotation.Roll < 65535 && (ViewRotation.Roll < Pawn.DesiredRotation.Roll || ViewRotation.Roll > 0))
            {
                ViewRotation.Roll = 0;
            }
            else if (Pawn.DesiredRotation.Roll > 0 && (ViewRotation.Roll > Pawn.DesiredRotation.Roll || ViewRotation.Roll < 65535))
            {
                ViewRotation.Roll = 0;
            }
        }

        DesiredRotation = ViewRotation; // save old rotation

        TurnTarget = none;
        bRotateToDesired = false;
        bSetTurnRot = false;

        // Begin handling turning speed
        TurnSpeedFactor = DHStandardTurnSpeedFactor;

        // Lower look sensitivity for when resting weapon
        if (DHPwn != none && DHPwn.bRestingWeapon)
        {
            TurnSpeedFactor = DHHalfTurnSpeedFactor;
        }

        // if sniper scope or binoc
        if (ROWeap != none &&
            (ROWeap.bPlayerViewIsZoomed || (ROWeap.IsA('DHBinocularsItem') && ROWeap.bPlayerViewIsZoomed)))
        {
            TurnSpeedFactor *= DHScopeTurnSpeedFactor;
        }
        else if (DHPwn != none && (DHPwn.bIronSights || DHPwn.bBipodDeployed))
        {
            TurnSpeedFactor *= DHISTurnSpeedFactor;
        }

        // Handle viewrotation
        ViewRotation.Yaw += FClamp((TurnSpeedFactor * DeltaTime * aTurn), -10000.0, 10000.0);
        ViewRotation.Pitch += FClamp((TurnSpeedFactor * DeltaTime * aLookUp), -10000.0, 10000.0);

        if (Pawn != none && Pawn.Weapon != none && DHPwn != none)
        {
            ViewRotation = FreeAimHandler(ViewRotation, DeltaTime);
        }

        if (DHPwn != none)
        {
            ViewRotation.Pitch = DHPwn.LimitPitch(ViewRotation.Pitch, DeltaTime);
        }

        if (DHPwn != none && (DHPwn.bBipodDeployed || DHPwn.bIsMantling || DHPwn.bIsDeployingMortar || DHPwn.bIsCuttingWire))
        {
            DHPwn.LimitYaw(ViewRotation.Yaw);
        }

        // Limit Pitch and yaw for the ROVehicles
        if (ROVeh != none)
        {
            ViewRotation.Yaw = ROVeh.LimitYaw(ViewRotation.Yaw);
            ViewRotation.Pitch = ROVeh.LimitPawnPitch(ViewRotation.Pitch);
        }

        ViewRotation.Yaw += SwayYaw;
        ViewRotation.Pitch += SwayPitch;

        SetRotation(ViewRotation);

        ViewShake(DeltaTime);
        ViewFlash(DeltaTime);

        NewRotation = ViewRotation;

        NewRotation.Roll = Rotation.Roll;

        if (!bRotateToDesired && Pawn != none && (!bFreeCamera || !bBehindView))
        {
            Pawn.FaceRotation(NewRotation, DeltaTime);
        }
    }
}

function ServerSaveArtilleryPosition()
{
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo PRI;
    local DHRoleInfo   RI;
    local DHVolumeTest RVT;
    local Actor        HitActor;
    local Material     HitMaterial;
    local vector       HitLocation, HitNormal, StartTrace;
    local rotator      AimRot;
    local int          TraceDist, i;
    local bool         bFoundARadio;

    if (DHPawn(Pawn) != none && Pawn.Weapon != none && Pawn.Weapon.IsA('DHBinocularsItem'))
    {
        RI = DHPawn(Pawn).GetRoleInfo();
        PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
        GRI = DHGameReplicationInfo(GameReplicationInfo);
    }

    if (RI != none && RI.bIsArtilleryOfficer && PRI != none && PRI.RoleInfo != none && GRI != none)
    {
        // If a player tries to mark artillery on a level with no arty for their team, give them a message
        if (PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(GRI.AlliedRadios); ++i)
            {
                if (GRI.AlliedRadios[i] != none)
                {
                    bFoundARadio = true;
                    break;
                }
            }

            if (!bFoundARadio)
            {
                for (i = 0; i < arraycount(GRI.CarriedAlliedRadios); ++i)
                {
                    if (GRI.CarriedAlliedRadios[i] != none)
                    {
                        bFoundARadio = true;
                        break;
                    }
                }
            }
        }
        else if (PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(GRI.AxisRadios); ++i)
            {
                if (GRI.AxisRadios[i] != none)
                {
                    bFoundARadio = true;
                    break;
                }
            }

            if (!bFoundARadio)
            {
                for (i = 0; i < arraycount(GRI.CarriedAxisRadios); ++i)
                {
                    if (GRI.CarriedAxisRadios[i] != none)
                    {
                        bFoundARadio = true;
                        break;
                    }
                }
            }
        }

        if (bFoundARadio)
        {
            TraceDist = GetMaxViewDistance();
            StartTrace = Pawn.Location + Pawn.EyePosition();
            AimRot = Rotation;

            HitActor = Trace(HitLocation, HitNormal, StartTrace + TraceDist * vector(AimRot), StartTrace, true,, HitMaterial);

            RVT = Spawn(class'DHVolumeTest', self,, HitLocation);

            if ((RVT == none || !RVT.IsInNoArtyVolume()) && HitActor != none && HitNormal != vect(0.0, 0.0, -1.0))
            {
                ReceiveLocalizedMessage(class'ROArtilleryMsg', 0); // position saved
                SavedArtilleryCoords = HitLocation;
            }
            else
            {
                ReceiveLocalizedMessage(class'ROArtilleryMsg', 5); // invalid target
            }

            RVT.Destroy();
        }
        else
        {
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 9); // no arty support (actually means there's no radio in the level to call arty)
        }
    }
}

// Spawn the artillery strike at the appropriate position
function ServerArtyStrike()
{
    local vector                SpawnLocation;
    local ROGameReplicationInfo GRI;
    local DHArtillerySpawner    Spawner;

    GRI = ROGameReplicationInfo(GameReplicationInfo);

    SpawnLocation = SavedArtilleryCoords;
    SpawnLocation.Z = GRI.NorthEastBounds.Z;

    Spawner = Spawn(class'DHArtillerySpawner', self,, SpawnLocation, rotator(PhysicsVolume.Gravity));

    if (Spawner == none)
    {
        Log("Error spawning artillery shell spawner");
    }
    else
    {
        Spawner.OriginalArtyLocation = SavedArtilleryCoords;
    }
}

simulated function float GetMaxViewDistance()
{
    if (Pawn != none && Pawn.Region.Zone != none && Pawn.Region.Zone.bDistanceFog)
    {
        return Pawn.Region.Zone.DistanceFogEnd;
    }

    switch (Level.ViewDistanceLevel)
    {
        case VDL_Default_1000m:
            return 65536.0;

        case VDL_Medium_2000m:
            return 131072.0;

        case VDL_High_3000m:
            return 196608.0;

        case VDL_Extreme_4000m:
            return 262144.0;

        default:
            return 65536.0;
    }
}

function ServerSaveMortarTarget(bool bIsSmoke)
{
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo PRI;
    local DHPawn       P;
    local Actor        HitActor;
    local vector       HitLocation, HitNormal, TraceStart, TraceEnd;
    local DHVolumeTest VT;
    local int          TeamIndex, i;
    local bool         bMortarsAvailable, bMortarTargetMarked;

    TeamIndex = GetTeamNum();
    P = DHPawn(Pawn);
    GRI = DHGameReplicationInfo(GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    TraceStart = Pawn.Location + Pawn.EyePosition();
    TraceEnd = TraceStart + (vector(Rotation) * GetMaxViewDistance());
    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true,,);

    VT = Spawn(class'DHVolumeTest', self,, HitLocation);

    // Check that the artillery target is not in a no artillery volume
    if ((VT != none && VT.IsInNoArtyVolume()) || HitActor == none)
    {
        // Invalid mortar target
        ReceiveLocalizedMessage(class'DHMortarTargetMessage', 0);
        VT.Destroy();

        return;
    }

    VT.Destroy();

    // Check that there are mortar operators available and that we haven't set a mortar target in the last 30 seconds
    if (TeamIndex == AXIS_TEAM_INDEX) // axis
    {
        for (i = 0; i < arraycount(GRI.GermanMortarTargets); ++i)
        {
            if (GRI.GermanMortarTargets[i].Controller == self &&
                Level.TimeSeconds - GRI.GermanMortarTargets[i].Time < MORTAR_TARGET_TIME_INTERVAL)
            {
                // You cannot mark another mortar target yet
                ReceiveLocalizedMessage(class'DHMortarTargetMessage', 4);

                return;
            }
        }

        // Go through the roles and find a mortar operator role that has someone on it
        for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
        {
            if (GRI.DHAxisRoles[i]!= none &&
                GRI.DHAxisRoles[i].bCanUseMortars &&
                GRI.DHAxisRoleCount[i] > 0)
            {
                // Mortar operator available!
                bMortarsAvailable = true;
                break;
            }
        }
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.AlliedMortarTargets); ++i)
        {
            if (GRI.AlliedMortarTargets[i].Controller == self &&
                Level.TimeSeconds - GRI.AlliedMortarTargets[i].Time < MORTAR_TARGET_TIME_INTERVAL)
            {
                ReceiveLocalizedMessage(class'DHMortarTargetMessage', 4);

                return;
            }
        }

        for (i = 0; i < arraycount(GRI.DHAlliesRoles); ++i)
        {
            if (GRI.DHAlliesRoles[i] != none &&
                GRI.DHAlliesRoles[i].bCanUseMortars &&
                GRI.DHAlliesRoleCount[i] > 0)
            {
                bMortarsAvailable = true;
                break;
            }
        }
    }

    if (!bMortarsAvailable)
    {
        // No mortar operators available
        ReceiveLocalizedMessage(class'DHMortarTargetMessage', 1);

        return;
    }

    // Zero out the z coordinate for 2D distance checking on round hits
    HitLocation.Z = 0.0;

    if (TeamIndex == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.GermanMortarTargets); ++i)
        {
            if (GRI.GermanMortarTargets[i].Controller == none ||
                GRI.GermanMortarTargets[i].Controller == self)
            {
                GRI.GermanMortarTargets[i].bIsActive = true;
                GRI.GermanMortarTargets[i].Controller = self;
                GRI.GermanMortarTargets[i].HitLocation = vect(0.0, 0.0, 0.0);
                GRI.GermanMortarTargets[i].Location = HitLocation;
                GRI.GermanMortarTargets[i].Time = Level.TimeSeconds;
                GRI.GermanMortarTargets[i].bIsSmoke = bIsSmoke;
                MortarTargetIndex = i;
                bMortarTargetMarked = true;
                break;
            }
        }
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.AlliedMortarTargets); ++i)
        {
            if (GRI.AlliedMortarTargets[i].Controller == none ||
                GRI.AlliedMortarTargets[i].Controller == self)
            {
                GRI.AlliedMortarTargets[i].bIsActive = true;
                GRI.AlliedMortarTargets[i].Controller = self;
                GRI.AlliedMortarTargets[i].HitLocation = vect(0.0, 0.0, 0.0);
                GRI.AlliedMortarTargets[i].Location = HitLocation;
                GRI.AlliedMortarTargets[i].Time = Level.TimeSeconds;
                GRI.AlliedMortarTargets[i].bIsSmoke = bIsSmoke;
                MortarTargetIndex = i;
                bMortarTargetMarked = true;
                break;
            }
        }
    }

    if (bMortarTargetMarked)
    {
        // [DH]Basnett has marked a mortar target
        if (bIsSmoke)
        {
            Level.Game.BroadcastLocalizedMessage(class'DHMortarTargetMessage', 3, PlayerReplicationInfo,,);
        }
        else
        {
            Level.Game.BroadcastLocalizedMessage(class'DHMortarTargetMessage', 2, PlayerReplicationInfo,,);
        }
    }
    else
    {
        // There are too many active mortar targets
        ReceiveLocalizedMessage(class'DHMortarTargetMessage', 6);
    }
}

// Overridden to handle separate MG and AT resupply as well as assisted AT loading
exec function ThrowMGAmmo()
{
    local Actor HitActor;
    local DHPawn MyPawn, OtherPawn;
    local DHMortarVehicle M;
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;
    local float TraceDistance;

    MyPawn = DHPawn(Pawn);

    if (MyPawn == none)
    {
        return;
    }

    TraceDistance = class'DHUnits'.static.MetersToUnreal(2);
    TraceStart = MyPawn.Location + MyPawn.EyePosition();
    TraceEnd = TraceStart + (vector(Rotation) * TraceDistance);

    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

    if (HitActor == none)
    {
        return;
    }

    OtherPawn = DHPawn(HitActor);
    M = DHMortarVehicle(HitActor);

    if (OtherPawn != none)
    {
        Log("MyPawn.bUsedCarriedMGAmmo" @ MyPawn.bUsedCarriedMGAmmo);
        Log("OtherPawn.bWeaponNeedsResupply" @ OtherPawn.bWeaponNeedsResupply);
        Log("OtherPawn.bWeaponNeedsReload" @ OtherPawn.bWeaponNeedsReload);

        if (!MyPawn.bUsedCarriedMGAmmo && OtherPawn.bWeaponNeedsResupply)
        {
            ServerThrowMGAmmo(OtherPawn);
        }

        if (OtherPawn.bWeaponNeedsReload)
        {
            ServerLoadATAmmo(OtherPawn);
        }
    }
    else if (M != none)
    {
        ServerThrowMortarAmmo(M);
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

    if (P == none || M == none)
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

// Matt: modified to avoid unnecessary Pawn.SaveConfig(), which saved block of pointless vehicle config variables to user.ini file every time player used behind view in a vehicle
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

state PlayerWalking
{
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

        GetAxes(Pawn.Rotation, X, Y, Z);

        // Update acceleration
        NewAccel = aForward * X + aStrafe * Y;
        NewAccel.Z = 0.0;

        if (VSize(NewAccel) < 1.0 || bWaitingToMantle || P.bIsDeployingMortar || P.bIsCuttingWire)
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
//              ROBipodWeapon(Pawn.Weapon).ForceUndeploy(); // Matt: replaced by if/else below so it actually works with DH weapons
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

    function EndState()
    {
        GroundPitch = 0;

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

        super.PlayerTick(DeltaTime);
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

        if (bMantleDebug && Pawn != none && Pawn.IsLocallyControlled())
        {
            ClientMessage("------------- End Mantle Debug -------------");
            Log("------------- End Mantle Debug -------------");
        }
    }
}

// Matt: modified to ignore bDisableThrottle & bWantsToThrottle, which relate to waiting for crew & are now effectively deprecated
state PlayerDriving
{
    // Set the throttle, steering etc for the vehicle based on the input provided
    function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
    {
        local Vehicle CurrentVehicle;

        CurrentVehicle = Vehicle(Pawn);

        if (CurrentVehicle != none)
        {
            CurrentVehicle.Throttle = FClamp(InForward / 5000.0, -1.0, 1.0);
            CurrentVehicle.Steering = FClamp(-InStrafe / 5000.0, -1.0, 1.0);
            CurrentVehicle.Rise = FClamp(InUp / 5000.0, -1.0, 1.0);
        }
    }
}

// Overrided for the awkward "jump" out of water
state PlayerSwimming
{
ignores SeePlayer, HearNoise, Bump;

    function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        local Actor  HitActor;
        local vector HitLocation, HitNormal, CheckPoint;

        if (!NewVolume.bWaterVolume)
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
                else // check if in deep water
                {
                    CheckPoint = Pawn.Location;
                    CheckPoint.Z -= (Pawn.CollisionHeight + 6.0);
                    HitActor = Trace(HitLocation, HitNormal, CheckPoint, Pawn.Location, false);

                    if (HitActor != none)
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

// Called server-side by SendVoiceMessage()
function AttemptToAddHelpRequest(PlayerReplicationInfo PRI, int ObjID, int RequestType, optional vector RequestLocation)
{
    local DHGameReplicationInfo     GRI;
    local DHRoleInfo                RI;
    local DarkestHourGame           G;
    local DHPlayerReplicationInfo   DHPRI;

    DHPRI = DHPlayerReplicationInfo(PRI);

    if (DHPRI == none)
    {
        return;
    }

    RI = DHRoleInfo(DHPRI.RoleInfo);

    // Check if caller is a leader
    if (RI == none || !RI.bIsSquadLeader || RequestType != 3 || (!RI.bIsGunner && !RI.bCanUseMortars))
    {
        // If not, check if we're a MG requesting ammo
        // Basnett, added mortar operators requesting resupply.
        return;
    }

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none && PRI != none && PRI.bIsSpectator && PRI.Team != none)
    {
        GRI.AddHelpRequest(PRI, ObjID, RequestType, RequestLocation);

        G = DarkestHourGame(Level.Game);

        if (G != none)
        {
            // Notify team members to check their map
            G.NotifyPlayersOfMapInfoChange(PRI.Team.TeamIndex, self);
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
        FOVAngle -= (FClamp(10.0 * DeltaTime, 0.0, 1.0) * (FOVAngle - DesiredFOV));

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

// Server call to client to force prone
function ClientProne()
{
    Prone();
}

// Server call to client to toggle duck
function ClientToggleDuck()
{
    ToggleDuck();
}

// Matt: modified to network optimise by removing automatic call to replicated server function in a VehicleWeaponPawn
// Instead we let WVP's clientside IncrementRange() check that it's a valid operation before sending server call
exec function LeanRight()
{
    if (ROPawn(Pawn) != none)
    {
        if (!Pawn.bBipodDeployed)
        {
            ROPawn(Pawn).LeanRight();
        }

        ServerLeanRight(true);
    }
    else if (VehicleWeaponPawn(Pawn) != none)
    {
        VehicleWeaponPawn(Pawn).IncrementRange();
    }
}

exec function LeanLeft()
{
    if (ROPawn(Pawn) != none)
    {
        if (!Pawn.bBipodDeployed)
        {
            ROPawn(Pawn).LeanLeft();
        }

        ServerLeanLeft(true);
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
    else if ((bIsInSpawnMenu && VehiclePoolIndex == 255) || !HasSelectedTeam() || !HasSelectedRole() || !HasSelectedWeapons() || !HasSelectedSpawn())
    {
        return false;
    }
    else if (DHGRI.ElapsedTime < NextSpawnTime)
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
        return SpawnPointIndex != 255 || SpawnVehicleIndex != 255;
    }

    return true;
}

// Modified incase this ever gets called, make it 'replace' the deploy menu instead of old RoleMenu
simulated function ClientForcedTeamChange(int NewTeamIndex, int NewRoleIndex)
{
    // Store the new team and role info
    ForcedTeamSelectOnRoleSelectPage = NewTeamIndex;
    DesiredRole = NewRoleIndex;

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

function HitThis(ROArtilleryTrigger RAT)
{
    local DarkestHourGame       DHG;
    local ROGameReplicationInfo GRI;
    local DHArtilleryTrigger    DHAT;
    local int TimeTilNextStrike, PawnTeam;

    if (RAT == none)
    {
        return;
    }

    DHG = DarkestHourGame(Level.Game);

    if (DHG == none)
    {
        return;
    }

    GRI = ROGameReplicationInfo(GameReplicationInfo);
    PawnTeam = Pawn.GetTeamNum();

    if (GRI.bArtilleryAvailable[Pawn.GetTeamNum()] > 0)
    {
        ReceiveLocalizedMessage(class'ROArtilleryMsg', 3,,, self); // strike confirmed

        if (PawnTeam == 0)
        {
            RAT.PlaySound(RAT.GermanConfirmSound, SLOT_None, 3.0, false, 100, 1.0, true);
        }
        else
        {
            RAT.PlaySound(RAT.RussianConfirmSound, SLOT_None, 3.0, false, 100, 1.0, true);
        }

        GRI.LastArtyStrikeTime[PawnTeam] = GRI.ElapsedTime;
        GRI.TotalStrikes[PawnTeam]++;

        DHAT = DHArtilleryTrigger(RAT);

        if (DHAT != none && DHAT.Carrier != none)
        {
            DHG.ScoreRadioUsed(DHAT.Carrier.Controller);
        }

        ServerArtyStrike();

        DHG.NotifyPlayersOfMapInfoChange(PawnTeam, self);
    }
    else
    {
        if (PawnTeam == 0)
        {
            RAT.PlaySound(RAT.GermanDenySound, SLOT_None, 3.0, false, 100, 1.0, true);
        }
        else
        {
            RAT.PlaySound(RAT.RussianDenySound, SLOT_None, 3.0, false, 100, 1.0, true);
        }

        TimeTilNextStrike = (GRI.LastArtyStrikeTime[PawnTeam] + ROTeamGame(Level.Game).LevelInfo.GetStrikeInterval(PawnTeam)) - GRI.ElapsedTime;

        if (GRI.TotalStrikes[PawnTeam] >= GRI.ArtilleryStrikeLimit[PawnTeam])
        {
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 6); // out of arty
        }
        else if (TimeTilNextStrike >= 20)
        {
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 7); // try again later
        }
        else if (TimeTilNextStrike >= 0)
        {
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 8); // try again soon
        }
        else
        {
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 2); // arty denied
        }
    }
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
        if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
        {
            ClientSetBehindView(!bBehindView);
        }
        else
        {
            bBehindView = !bBehindView;
            ClientSetBehindView(bBehindView);
        }
    }
}

// Matt: DH version, including to hide the sky, which is necessary to allow the crucial debug spheres to get drawn
simulated exec function PlayerCollisionDebug()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && ROHud(myHUD) != none)
    {
        ROHud(myHUD).bDebugPlayerCollision = !ROHud(myHUD).bDebugPlayerCollision;
        SetSkyOff(ROHud(myHUD).bDebugPlayerCollision);
    }
}

simulated exec function VehicleCamDistance(int NewDistance)
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && ROHud(myHUD) != none)
    {
        //Get the current vehicle the player is in
        if (Pawn.IsA('Vehicle'))
        {
            //Change the instance's TPCamDistance
            Vehicle(Pawn).TPCamDistance = NewDistance;
            Vehicle(Pawn).TPCamDistRange.Min = NewDistance;
            Vehicle(Pawn).TPCamDistRange.Max = NewDistance;
        }
    }
}

// DH version, but only showing the vehicle occupant ('Driver') hit points, not the vehicle's special hit points for engine & ammo stores
simulated exec function DriverCollisionDebug()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && ROHud(myHUD) != none)
    {
        ROHud(myHUD).bDebugDriverCollision = !ROHud(myHUD).bDebugDriverCollision;
        SetSkyOff(ROHud(myHUD).bDebugDriverCollision);
    }
}

// New exec showing all vehicle's special hit points for engine (blue) & ammo stores (red), plus DHArmoredVehicle's extra hit points (gold for gun traverse/pivot, pink for periscopes)
simulated exec function VehicleHitPointDebug()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && DHHud(myHUD) != none)
    {
        DHHud(myHUD).bDebugVehicleHitPoints = !DHHud(myHUD).bDebugVehicleHitPoints;
        SetSkyOff(DHHud(myHUD).bDebugVehicleHitPoints);
    }
}

// New exec showing all vehicle's physics wheels (the Wheels array of invisible wheels that drive & steer vehicle, even ones with treads)
simulated exec function VehicleWheelDebug()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && DHHud(myHUD) != none)
    {
        DHHud(myHUD).bDebugVehicleWheels = !DHHud(myHUD).bDebugVehicleWheels;
        SetSkyOff(DHHud(myHUD).bDebugVehicleWheels);
    }
}

// New function to hide or restore the sky, used by debug functions that use DrawDebugX native functions, that won't draw unless the sky is off
// Console command "show sky" toggles the sky on/off, but it only works in single player, so this allows these debug options to work in multiplayer
simulated function SetSkyOff(bool bHideSky)
{
    // Hide the sky
    if (bHideSky)
    {
        if (!bSkyOff)
        {
            bSkyOff = true;
            SavedSkyZone = PlayerReplicationInfo.PlayerZone.SkyZone;
            PlayerReplicationInfo.PlayerZone.SkyZone = none;
        }
    }
    // Restore the sky, but only if we have no other similar debug functionality enabled
    else if (bSkyOff && !(ROHud(myHUD) != none && (ROHud(myHUD).bDebugDriverCollision || ROHud(myHUD).bDebugPlayerCollision
        || (DHHud(myHUD) != none && (DHHud(myHUD).bDebugVehicleHitPoints || DHHud(myHUD).bDebugVehicleWheels)))))
    {
        bSkyOff = false;
        PlayerReplicationInfo.PlayerZone.SkyZone = SavedSkyZone;
    }
}

// Matt: DH version
exec function ClearLines()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        ClearStayingDebugLines();
    }
}

// Matt: new exec
exec function ClearArrows()
{
    local RODebugTracer Tracer;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        foreach DynamicActors(class'RODebugTracer', Tracer)
        {
            Tracer.Destroy();
        }
    }
}

simulated exec function DebugTreadVelocityScale(float TreadVelocityScale)
{
    local ROTreadCraft V;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        foreach AllActors(class'ROTreadCraft', V)
        {
            if (TreadVelocityScale == -1.0)
            {
                V.TreadVelocityScale = V.default.TreadVelocityScale;
            }
            else
            {
                V.TreadVelocityScale = TreadVelocityScale;
            }
        }

        Level.Game.Broadcast(self, "DebugTreadVelocityScale = " $ TreadVelocityScale);
    }
}

simulated exec function DebugTreadVelocityScaleIncrement()
{
    local ROTreadCraft V;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        foreach AllActors(class'ROTreadCraft', V)
        {
            V.TreadVelocityScale += 1.0;
        }
    }
}

simulated exec function DebugTreadVelocityScaleDecrement()
{
    local ROTreadCraft V;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        foreach AllActors(class'ROTreadCraft', V)
        {
            V.TreadVelocityScale -= 1.0;
        }
    }
}

simulated exec function DebugWheelRotationScale(int WheelRotationScale)
{
    local ROTreadCraft V;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        foreach AllActors(class'ROTreadCraft', V)
        {
            if (WheelRotationScale == -1)
            {
                V.WheelRotationScale = V.default.WheelRotationScale;
            }
            else
            {
                V.WheelRotationScale = WheelRotationScale;
            }
        }

        Level.Game.Broadcast(self, "DebugWheelRotationScale = " $ WheelRotationScale);
    }
}

// New debug exec to adjust the occupant positions in the vehicle HUD overlay (the red dots)
// Pass new X & Y float values scaled by 1000, which allows precision to 3 decimal places
exec function SetOccPos(int Index, int NewX, int NewY)
{
    local ROVehicle V;
    local float     X, Y;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        V = ROVehicle(Pawn);

        if (V == none && VehicleWeaponPawn(Pawn) != none)
        {
            V = VehicleWeaponPawn(Pawn).VehicleBase;
        }

        if (V != none)
        {
            X = float(NewX) / 1000.0;
            Y = float(NewY) / 1000.0;
            Log(V.VehicleNameString @ "VehicleHudOccupantsX[" $ Index $ "] =" @ X @ "Y =" @ Y @ "(was" @ V.VehicleHudOccupantsX[Index] @ V.VehicleHudOccupantsY[Index]);
            V.VehicleHudOccupantsX[Index] = X;
            V.VehicleHudOccupantsY[Index] = Y;
        }
    }
}

// New exec that respawns the player, but leaves their old pawn body behind, frozen in the game
// Optional bKeepPRI means the old body copy keeps a reference to the player's PRI, so it still shows your name in HUD, with any resupply/reload message
exec function LeaveBody(optional bool bKeepPRI)
{
    local ROVehicleWeaponPawn WP;
    local ROVehicle           V;
    local Pawn                OldPawn;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Pawn != none)
    {
        // If player is in vehicle with an interior mesh, switch to default exterior mesh & play the appropriate animations to put vehicle & player in correct position
        V = ROVehicle(Pawn);

        if (V != none)
        {
            if (V.Mesh != V.default.Mesh)
            {
                V.LinkMesh(V.default.Mesh);

                if (DHWheeledVehicle(V) != none)
                {
                    DHWheeledVehicle(V).SetPlayerPosition();
                }
                else if (DHArmoredVehicle(V) != none)
                {
                    DHArmoredVehicle(V).SetPlayerPosition();
                }
            }
        }
        else
        {
            WP = ROVehicleWeaponPawn(Pawn);

            if (WP != none && WP.Gun != none && WP.Gun.Mesh != WP.Gun.default.Mesh)
            {
                WP.Gun.LinkMesh(WP.Gun.default.Mesh);

                if (DHVehicleCannonPawn(WP) != none)
                {
                    DHVehicleCannonPawn(WP).SetPlayerPosition();
                }
                else if (DHVehicleMGPawn(WP) != none)
                {
                    DHVehicleMGPawn(WP).SetPlayerPosition();
                }
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

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Pawn != none)
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
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && DHHud(myHud) != none && DHHud(myHud).NamedPlayer != none)
    {
        DHHud(myHud).NamedPlayer.SetHeadScale(DHHud(myHud).NamedPlayer.default.HeadScale);
    }
}

// New exec that reverses LeaveBody(), allowing the player 'reclaim' their old pawn body (& killing off their current pawn)
exec function PossessBody()
{
    local Pawn   TargetPawn;
    local vector HitLocation, HitNormal, ViewPos;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Pawn != none)
    {
        ViewPos = Pawn.Location + Pawn.BaseEyeHeight * vect(0.0, 0.0, 1.0);
        TargetPawn = Pawn(Trace(HitLocation, HitNormal, ViewPos + 1600.0 * vector(Rotation), ViewPos, true));

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
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && NewPawn != none)
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

function ServerClearObstacle(int Index)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G != none && G.ObstacleManager != none)
    {
        G.ObstacleManager.ClearObstacle(Index);
    }
}

exec function DebugObstacles(optional int Option)
{
    local DHObstacleInfo OI;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
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
    DarkestHourGame(Level.Game).ObstacleManager.DebugObstacles(Option);
}

// Matt: added for easy way to write to log in-game, during testing or development
exec function DoLog(string LogMessage)
{
    if (LogMessage != "" && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode() || (PlayerReplicationInfo.bAdmin || PlayerReplicationInfo.bSilentAdmin)))
    {
        Log(PlayerReplicationInfo.PlayerName @ ":" @ LogMessage);

        if (Role < ROLE_Authority)
        {
            ServerDoLog(LogMessage);
        }
    }
}

function ServerDoLog(string LogMessage)
{
    if (LogMessage != "" && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode() || (PlayerReplicationInfo.bAdmin || PlayerReplicationInfo.bSilentAdmin)))
    {
        Log(PlayerReplicationInfo.PlayerName @ ":" @ LogMessage);
    }
}

// Keep this function as it's used as a control to show communication page allowing fast muting of players
exec function CommunicationMenu()
{
    ClientReplaceMenu("ROInterface.ROCommunicationPage");
}

// This function returns the time the player will be able to spawn next
// given some spawn parameters (DHRoleInfo and VehiclePoolIndex).
simulated function int GetNextSpawnTime(DHRoleInfo RI, byte VehiclePoolIndex)
{
    local int T;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (RI == none || GRI == none || PlayerReplicationInfo == none || PlayerReplicationInfo.Team == none)
    {
        return 0;
    }

    T = LastKilledTime + GRI.ReinforcementInterval[PlayerReplicationInfo.Team.TeamIndex] + RI.AddedReinforcementTime;

    if (VehiclePoolIndex != 255)
    {
        T = Max(T, GRI.VehiclePoolNextAvailableTimes[VehiclePoolIndex]);
        T = Max(T, NextVehicleSpawnTime);
    }

    return T;
}

// Function to get offset coordinates from nearby vehicle(s) to create/adjust vehicle exit positions (Only works in singleplayer)
exec function ExitPosTool()
{
    local ROVehicle NearbyVeh;
    local vector Offset;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        foreach RadiusActors(class'ROVehicle', NearbyVeh, 300.0, Pawn.Location)
        {
            Offset = (Pawn.Location - NearbyVeh.Location) << NearbyVeh.Rotation;

            Log("Vehicle:" @ NearbyVeh.GetHumanReadableName() @ "(X=" $ Round(Offset.X) $ ",Y=" $ Round(Offset.Y) $ ",Z=" $ Round(Offset.Z) $ ")");
        }
    }
}

// New debug exec to make bots spawn
// Team is 0 for axis, 1 for allies, 2 for both
// Num is optional & limits the number of bots that will be spawned (if not entered, zero is passed & gets used to signify no limit on numbers)
exec function DebugSpawnBots(int Team, optional int Num, optional int Distance)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        if (DarkestHourGame(Level.Game) != none)
        {
            DarkestHourGame(Level.Game).SpawnBots(self, Team, Num, Distance);
        }
    }
}

exec function DebugSpawnVehicle(string VehicleClass, int Distance, optional int SetAsCrew)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        if (DarkestHourGame(Level.Game) != none)
        {
            DarkestHourGame(Level.Game).SpawnVehicle(self, VehicleClass, Distance, SetAsCrew);
        }
    }
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
    local float  WeaponSwayYawAcc, WeaponSwayPitchAcc, TimeFactor, BobFactor, StaminaFactor, DeltaSwayYaw, DeltaSwayPitch;

    P = DHPawn(Pawn);

    if (P == none)
    {
        return;
    }

    StaminaFactor = ((P.default.Stamina - P.Stamina) / P.default.Stamina) * 0.5; //50% stamina factor
    SwayTime += DeltaTime;

    if (SwayClearTime >= 0.025)
    {
        SwayClearTime = 0.0;
        WeaponSwayYawAcc = RandRange(-baseSwayYawAcc, baseSwayYawAcc);
        WeaponSwayPitchAcc = RandRange(-baseSwayPitchAcc, baseSwayPitchAcc);
    }
    else
    {
        WeaponSwayYawAcc = 0.0;
        WeaponSwayPitchAcc = 0.0;
        SwayClearTime += DeltaTime;
    }

    // Get timefactor based on sway curve
    TimeFactor = InterpCurveEval(SwayCurve, SwayTime);

    // Get bobfactor based on bob curve
    BobFactor = InterpCurveEval(BobCurve, SwayTime);

    // Handle timefactor modifier & weapon bob for weapon type
    if (DHWeapon(P.Weapon) != none)
    {
        TimeFactor *= DHWeapon(P.Weapon).SwayModifyFactor;
        //P.IronSightBobFactor = BobFactor * DHWeapon(P.Weapon).BobModifyFactor;
    }

    // Add modifiers to sway for time in iron sights and stamina
    WeaponSwayYawAcc = (TimeFactor * WeaponSwayYawAcc) + (StaminaFactor * WeaponSwayYawAcc);
    WeaponSwayPitchAcc = (TimeFactor * WeaponSwayPitchAcc) + (StaminaFactor * WeaponSwayPitchAcc);

    // Sway reduction for crouching, prone, and resting the weapon
    if (P.bRestingWeapon)
    {
        WeaponSwayYawAcc *= 0.1;
        WeaponSwayPitchAcc *= 0.1;
    }
    else if (P.bIsCrouched)
    {
        WeaponSwayYawAcc *= 0.5;
        WeaponSwayPitchAcc *= 0.5;
    }
    else if (P.bIsCrawling)
    {
        WeaponSwayYawAcc *= 0.25;
        WeaponSwayPitchAcc *= 0.25;
    }

    if (P.IsProneTransitioning())
    {
        WeaponSwayYawAcc *= 4.5;
        WeaponSwayPitchAcc *= 4.5;
    }

    if (P.LeanAmount != 0.0)
    {
        WeaponSwayYawAcc *= 1.45;
        WeaponSwayPitchAcc *= 1.45;
    }

    // Add a elastic and damping factor to get sway near the original aim-point and from causing wild oscillations
    WeaponSwayYawAcc = WeaponSwayYawAcc - (DHSwayElasticFactor * SwayYaw) - (DHSwayDampingFactor * WeaponSwayYawRate);
    WeaponSwayPitchAcc = WeaponSwayPitchAcc - (DHSwayElasticFactor * SwayPitch) - (DHSwayDampingFactor * WeaponSwayPitchRate);

    // Calculation for motion
    DeltaSwayYaw = (WeaponSwayYawRate * DeltaTime) + (0.5 * WeaponSwayYawAcc * DeltaTime * DeltaTime);
    DeltaSwayPitch = (WeaponSwayPitchRate * DeltaTime) + (0.5 * WeaponSwayPitchAcc * DeltaTime * DeltaTime);

    // Add actual sway
    SwayYaw += DeltaSwayYaw;
    SwayPitch += DeltaSwayPitch;

    if (P.bRestingWeapon)
    {
        SwayYaw = 0.0;
        SwayPitch = 0.0;
    }

    // Update new sway velocity (R = D*T)
    WeaponSwayYawRate += WeaponSwayYawAcc * DeltaTime;
    WeaponSwayPitchRate += WeaponSwayPitchAcc * DeltaTime;
}

// Modified to not allow IronSighting when transitioning to/from prone
simulated exec function ROIronSights()
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
    if (Pawn != none && Level.TimeSeconds - Pawn.LastStartTime > 1)
    {
        Pawn.Suicide();
    }
}

exec function SwitchTeam() { }
exec function ChangeTeam(int N) { }

// Modified to not join the opposite team if it fails to join the one passed (fixes a nasty exploit)
// Colin: This function verifies the spawn parameters (spawn point et al.) that
// are passed in, and sets them if they check out. If they don't check out, an
// error is thrown.
function ServerSetPlayerInfo(byte newTeam, byte newRole, byte NewWeapon1, byte NewWeapon2, byte NewSpawnPointIndex, byte NewVehiclePoolIndex, byte NewSpawnVehicleIndex)
{
    local bool bDidFail;
    local DarkestHourGame Game;
    local DHRoleInfo RI;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    // Attempt to change teams
    if (newTeam != 255)
    {
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

                // Because we switched teams we should reset current role, desired role, etc.
                ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo = none;
                DesiredRole = -1;
                CurrentRole = -1;
                SpawnPointIndex = 255;
                SpawnVehicleIndex = 255;
                GRI.UnreserveVehicle(self);
                DesiredPrimary = 0;
                DesiredSecondary = 0;
                DesiredGrenade = 0;
                bSpawnPointInvalidated = false;
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
                else if (Level.Game.NumPlayers >= Level.Game.MaxPlayers)
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

    // return result to client
    if (NewTeam == AXIS_TEAM_INDEX)
    {
        ClientChangePlayerInfoResult(97);   // successfully picked axis team
    }
    else if (NewTeam == ALLIES_TEAM_INDEX)
    {
        ClientChangePlayerInfoResult(98);   // successfully picked allies team
    }
    else if (NewTeam == 254)
    {
        ClientChangePlayerInfoResult(96);   // successfully picked spectator team
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

            if (GRI != none && GRI.AreSpawnSettingsValid(GetTeamNum(), RI, NewSpawnPointIndex, NewVehiclePoolIndex, NewSpawnVehicleIndex))
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
                SpawnVehicleIndex = NewSpawnVehicleIndex;
                NextSpawnTime = GetNextSpawnTime(RI, VehiclePoolIndex);

                bSpawnPointInvalidated = false;

                ClientChangePlayerInfoResult(0);
            }
            else
            {
                SpawnPointIndex = default.SpawnPointIndex;
                VehiclePoolIndex = default.VehiclePoolIndex;
                SpawnVehicleIndex = default.SpawnVehicleIndex;
                NextSpawnTime = default.NextSpawnTime;

                ClientChangePlayerInfoResult(19);
            }
        }
        else
        {
            ClientChangePlayerInfoResult(0);
        }
    }
}

// Overriden to fix accessed none errors
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

    NextSpawnTime = default.NextSpawnTime;
    SpawnPointIndex = default.SpawnPointIndex;
    SpawnVehicleIndex = default.SpawnVehicleIndex;
    VehiclePoolIndex = default.VehiclePoolIndex;
    LastKilledTime = default.LastKilledTime;
    NextVehicleSpawnTime = default.NextVehicleSpawnTime;
    MortarTargetIndex = default.MortarTargetIndex;
}

function ServerSetIsInSpawnMenu(bool bIsInSpawnMenu)
{
    self.bIsInSpawnMenu = bIsInSpawnMenu;
}

// Matt: just added Begin: label, to avoid "label not found" error on ClientGotoState calls to send client to state 'Spectating' or 'PlayerWaiting' (both child states of this)
state BaseSpectating
{
Begin:
}

state DeadSpectating
{
    function BeginState()
    {
        super.BeginState();

        if (!PlayerReplicationInfo.bOnlySpectator && bSpawnPointInvalidated)
        {
            ClientProposeMenu("DH_Interface.DHDeployMenu");
        }
    }
}

state Dead
{
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
            }
        }
    }
}

// TODO: Check and confirm we actually need to override this
event ClientReplaceMenu(string Menu, optional bool bDisconnect, optional string Msg1, optional string Msg2)
{
    if (Player.Console != none && Player.Console.bTyping)
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

    if (GRI == none && GRI.DHObjectives[Index] != none)
    {
        return GRI.DHObjectives[Index].Location;
    }

    return vect(0.0, 0.0, 0.0);
}

// Modified to not have player automatically switch to best weapon when player requests to drop weapon
function ServerThrowWeapon()
{
    local Vector TossVel;

    if (Pawn.CanThrowWeapon())
    {
        TossVel = vector(GetViewRotation());
        TossVel = TossVel * ((Pawn.Velocity dot TossVel) + 150.0) + vect(0.0, 0.0, 100.0);
        Pawn.TossWeapon(TossVel);
    }
}

function PawnDied(Pawn P)
{
    local DarkestHourGame G;
    local DHRoleInfo      RI;

    if (P == none)
    {
        return;
    }

    super.PawnDied(P);

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        RI = DHRoleInfo(G.GetRoleInfo(GetTeamNum(), DesiredRole));

        if (RI != none)
        {
            NextSpawnTime = GetNextSpawnTime(RI, VehiclePoolIndex);
        }
    }
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

// Modified to avoid possible spamming of "accessed none" errors
function RORoleInfo GetRoleInfo()
{
    if (ROPlayerReplicationInfo(PlayerReplicationInfo) != none)
    {
        return ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo;
    }
}

// New debug exec to adjust DrivePos (vehicle occupant positional offset from attachment bone)
exec function SetDrivePos(int NewX, int NewY, int NewZ, optional bool bScaleOneTenth)
{
    local Vehicle V;
    local vector  OldDrivePos;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        V = Vehicle(Pawn);

        if (V != none && V.Driver != none)
        {
            OldDrivePos = V.DrivePos;

            if (bScaleOneTenth) // option allowing accuracy to .1 Unreal units, by passing floats as ints scaled by 10 (e.g. pass 55 for 5.5)
            {
                V.DrivePos.X = Float(NewX) / 10.0;
                V.DrivePos.Y = Float(NewY) / 10.0;
                V.DrivePos.Z = Float(NewZ) / 10.0;
            }
            else
            {
                V.DrivePos.X = NewX;
                V.DrivePos.Y = NewY;
                V.DrivePos.Z = NewZ;
            }

            V.DetachDriver(V.Driver);
            V.AttachDriver(V.Driver);
            Log(V.Tag @ " new DrivePos =" @ V.DrivePos @ "(was" @ OldDrivePos $ ")");
        }
    }
}

// Debug exec for queued hints
function exec DebugHints()
{
    local DHHintManager.HintInfo Hint;
    local int i;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
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

// Debug exec to play a sound (playing sounds in RO editor often doesn't work, so this is just a way of trying out sounds)
exec function SoundPlay(string SoundName, optional float Volume)
{
    local sound SoundToPlay;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && SoundName != "")
    {
        SoundToPlay = sound(DynamicLoadObject(SoundName, class'Sound'));

        if (SoundToPlay != none)
        {
            ClientPlaySound(SoundToPlay, Volume > 0.0, Volume);
            Log("Playing sound" @ SoundToPlay @ " Volume =" @ Volume);
        }
    }
}

// Override to have the list of players copied into the clipboard of the player whom typed "ListPlayers"
// The player can then use a regular expression find/replace to split the single line string into multiple lines, with ease of access to the ROIDs
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

    for (i = 0; i < AllPRI.Length; ++i)
    {
        if( PlayerController(AllPRI[i].Owner) != none && AllPRI[i].PlayerName != "WebAdmin")
        {
            ClientMessage(Right("   "$AllPRI[i].PlayerID, 3)$")"@AllPRI[i].PlayerName@" "$PlayerController(AllPRI[i].Owner).GetPlayerIDHash());
            ParseString $= PlayerController(AllPRI[i].Owner).GetPlayerIDHash() @ AllPRI[i].PlayerName @ Chr(0xA);
        }
        else
        {
            ClientMessage(Right("   "$AllPRI[i].PlayerID, 3)$")"@AllPRI[i].PlayerName);
        }
    }

    ClientCopyToClipboard(ParseString);
}

// New function for server to tell client to copy string into it's clipboard
function ClientCopyToClipboard(string Str)
{
    CopyToClipBoard(Str);
}

// Similar to ClientOpenMenu(), but only opens menu if no menu is already open and the player isn't typing
event ClientProposeMenu(string Menu, optional string Msg1, optional string Msg2)
{
    Log("ClientProposeMenu has been called, checking if the user is typing or not");

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
    ROIDHash = ROID;
    SaveConfig();
}

// Modified to work in debug mode, as well as in single player
exec function FOV(float F)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        DefaultFOV = FClamp(F, 1.0, 170.0);
        DesiredFOV = DefaultFOV;
    }
}

simulated function ClientJoinSquadResult(DHSquadReplicationInfo.ESquadError Error)
{
}

simulated function ClientLeaveSquadResult(DHSquadReplicationInfo.ESquadError Error)
{
}

simulated function ClientChangeSquadLeaderResult(DHSquadReplicationInfo.ESquadError Error)
{
}

simulated function ClientCreateSquadResult(DHSquadReplicationInfo.ESquadError Error)
{
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

    // Colin: Hard-coding this, unfortunately, because we need to have the
    // player be able to join just by executing "Speak Squad". We can't
    // depend on the name of the squad because it's not unique and is subject
    // to change, and we don't want to go passing around UUIDs when we can just
    // put in a sneaky little hack.
    if (ChannelTitle ~= "SQUAD")
    {
        VRI = DHVoiceReplicationInfo(VoiceReplicationInfo);

        if (VRI != none)
        {
            VCR = VRI.GetSquadChannel(GetTeamNum(), PRI.SquadIndex);

            if (VCR == none)
            {
                return;
            }
        }
    }
    else
    {
        // Check that we are a member of this room.
        VCR = VoiceReplicationInfo.GetChannel(ChannelTitle, GetTeamNum());
    }

    if (VCR == none && ChatRoomMessageClass != none)
    {
        ClientMessage(ChatRoomMessageClass.static.AssembleMessage(0, ChannelTitle));

        return;
    }

    if (VCR.ChannelIndex >= 0)
    {
        ChanPwd = FindChannelPassword(ChannelTitle);

        ServerSpeak(VCR.ChannelIndex, ChanPwd);
    }
    else if (ChatRoomMessageClass != none)
    {
        ClientMessage(ChatRoomMessageClass.static.AssembleMessage(0, ChannelTitle));
    }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// START SQUAD DEBUG FUNCTIONS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

simulated exec function SquadCreate()
{
    ServerSquadCreate();
}

function ServerSquadCreate()
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    G.SquadReplicationInfo.CreateSquad(DHPlayerReplicationInfo(PlayerReplicationInfo));
}

simulated exec function SquadLeave()
{
    ServerSquadLeave();
}

function ServerSquadLeave()
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    G.SquadReplicationInfo.LeaveSquad(DHPlayerReplicationInfo(PlayerReplicationInfo));
}

simulated exec function SquadJoin(int SquadIndex)
{
    ServerSquadJoin(GetTeamNum(), SquadIndex);
}

function ServerSquadJoin(int TeamIndex, int SquadIndex, optional bool bWasInvited)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    G.SquadReplicationInfo.JoinSquad(DHPlayerReplicationInfo(PlayerReplicationInfo), TeamIndex, SquadIndex, bWasInvited);
}

simulated exec function SquadLog()
{
    local int i, j;
    local DHSquadReplicationInfo SRI;
    local array<DHPlayerReplicationInfo> SquadMembers;

    SRI = SquadReplicationInfo;

    if (SRI == none)
    {
        return;
    }

    Log("+=============+");
    Log("| Axis Squads |");
    Log("+=============+");

    for (i = 0; i < SRI.GetTeamSquadLimit(AXIS_TEAM_INDEX); ++i)
    {
        if (!SRI.IsSquadActive(AXIS_TEAM_INDEX, i))
        {
            continue;
        }

        Log("[" $ i $ "]" @ SRI.GetSquadName(AXIS_TEAM_INDEX, i));
        Log("----------------");

        SquadMembers.Length = 0;
        SRI.GetMembers(AXIS_TEAM_INDEX, i, SquadMembers);

        for (j = 0; j < SquadMembers.Length; ++j)
        {
            if (SquadMembers[j] != none)
            {
                Log("  (" $ j $ ")" @ SquadMembers[j].PlayerName);
            }
        }
    }

    Log("+===============+");
    Log("| Allied Squads |");
    Log("+===============+");

    for (i = 0; i < SRI.GetTeamSquadLimit(ALLIES_TEAM_INDEX); ++i)
    {
        if (!SRI.IsSquadActive(ALLIES_TEAM_INDEX, i))
        {
            continue;
        }

        Log("[" $ i $ "]" @ SRI.GetSquadName(ALLIES_TEAM_INDEX, i));
        Log("----------------");

        SquadMembers.Length = 0;
        SRI.GetMembers(ALLIES_TEAM_INDEX, i, SquadMembers);

        for (j = 0; j < SquadMembers.Length; ++j)
        {
            if (SquadMembers[j] != none)
            {
                Log("  (" $ j $ ")" @ SquadMembers[j].PlayerName);
            }
        }
    }
}

simulated exec function SquadJoinAuto()
{
    SeverSquadJoinAuto();
}

function SeverSquadJoinAuto()
{
    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.JoinSquadAuto(DHPlayerReplicationInfo(PlayerReplicationInfo));
    }
}

simulated exec function SquadInvite(string PlayerName)
{
    ServerSquadInvite(PlayerName);
}

function ServerSquadInvite(string PlayerName)
{
    local int i;
    local DHPlayerReplicationInfo PRI, Recipient;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    for (i = 0; i < GameReplicationInfo.PRIArray.Length; ++i)
    {
        if (PlayerName ~= GameReplicationInfo.PRIArray[i].PlayerName)
        {
            Recipient = DHPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
            break;
        }
    }

    if (SquadReplicationInfo != none && PRI != none && PRI.IsInSquad())
    {
        SquadReplicationInfo.InviteToSquad(DHPlayerReplicationInfo(PlayerReplicationInfo), GetTeamNum(), PRI.SquadIndex, Recipient);
    }
}

simulated exec function SquadKick(string PlayerName)
{
    ServerSquadKick(PlayerName);
}

function ServerSquadKick(string PlayerName)
{
    local int i;
    local DHPlayerReplicationInfo PRI, MemberToKick;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    for (i = 0; i < GameReplicationInfo.PRIArray.Length; ++i)
    {
        if (PlayerName ~= GameReplicationInfo.PRIArray[i].PlayerName)
        {
            MemberToKick = DHPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
            break;
        }
    }

    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.KickFromSquad(PRI, GetTeamNum(), PRI.SquadIndex, MemberToKick);
    }
}

simulated exec function SquadLock(bool bIsLocked)
{
    ServerSquadLock(bIsLocked);
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

simulated exec function SquadCommandeer()
{
    ServerSquadCommandeer();
}

function ServerSquadCommandeer()
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.CommandeerSquad(PRI, GetTeamNum(), PRI.SquadIndex);
    }
}

simulated exec function SquadPromote(string PlayerName)
{
    ServerSquadPromote(PlayerName);
}

function ServerSquadPromote(string PlayerName)
{
    local int i;
    local DHPlayerReplicationInfo PRI, NewSquadLeader;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    for (i = 0; i < GameReplicationInfo.PRIArray.Length; ++i)
    {
        if (PlayerName ~= GameReplicationInfo.PRIArray[i].PlayerName)
        {
            NewSquadLeader = DHPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
            break;
        }
    }

    if (SquadReplicationInfo != none && PRI != none)
    {
        SquadReplicationInfo.ChangeSquadLeader(PRI, GetTeamNum(), PRI.SquadIndex, NewSquadLeader);
    }
}

function ServerSquadOrder(DHSquadReplicationInfo.ESquadOrderType Type, optional vector Location)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (SquadReplicationInfo == none || PRI == none)
    {
        return;
    }

    SquadReplicationInfo.SetSquadOrder(PRI, GetTeamNum(), PRI.SquadIndex, Type, Location);
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// END SQUAD DEBUG FUNCTIONS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

exec function SquadSay(string Msg)
{
    Msg = Left(Msg, 128);

    if (AllowTextMessage(Msg))
    {
        ServerSquadSay(Msg);
    }
}

function ServerSquadSay(string Msg)
{
    local DarkestHourGame G;

    // Colin: We'll preserve this teamkill forgiveness logic because people will
    // probably be confused if typing "np" only works in Say or TeamSay.
    if (ROTeamGame(Level.Game) != none &&
        ROTeamGame(Level.Game).bForgiveFFKillsEnabled &&
        LastFFKiller != none &&
        (Msg ~= "np" || Msg ~= "forgive" || Msg ~= "no prob" || Msg ~= "no problem"))
    {
        Level.Game.BroadcastLocalizedMessage(Level.Game.default.GameMessageClass, 19, LastFFKiller, PlayerReplicationInfo);
        LastFFKiller.FFKills -= LastFFKillAmount;
        LastFFKiller = none;
    }

    LastActiveTime = Level.TimeSeconds;

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        G.BroadcastSquad(self, Level.Game.ParseMessageString(Level.Game.BaseMutator, self, Msg) , 'SquadSay');
    }
}

exec function ShowOrderMenu()
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI != none && PRI.IsSquadLeader())
    {
        SquadOrderInteraction = DHCommandInteraction(Player.InteractionMaster.AddInteraction("DH_Engine.DHCommandInteraction", Player));
        SquadOrderInteraction.PushMenu("DH_Engine.DHCommandMenu_SquadLeader");
    }
}

exec function HideOrderMenu()
{
    // TODO: on death, hide order menu
    if (SquadOrderInteraction != none)
    {
        SquadOrderInteraction.Hide();
    }
}

defaultproperties
{
    // Sway values
    SwayCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=3.0,OutVal=0.3),(InVal=12.0,OutVal=0.25),(InVal=45.0,OutVal=0.4),(InVal=10000000000.0,OutVal=0.5)))
    BobCurve=(Points=((InVal=0.0,OutVal=0.8),(InVal=3.0,OutVal=0.2),(InVal=12.0,OutVal=0.15),(InVal=45.0,OutVal=0.2),(InVal=10000000000.0,OutVal=0.25)))
    DHSwayElasticFactor=8.0;
    DHSwayDampingFactor=0.51;
    baseSwayYawAcc=600
    baseSwayPitchAcc=500

    // Max turn speed values
    DHStandardTurnSpeedFactor=32.0
    DHHalfTurnSpeedFactor=16.0
    DHISTurnSpeedFactor=0.5
    DHScopeTurnSpeedFactor=0.2

    // Other values
    NextSpawnTime=15
    FlinchRotMag=(X=100.0,Y=0.0,Z=100.0)
    FlinchRotRate=(X=1000.0,Y=0.0,Z=1000.0)
    FlinchRotTime=1.0
    FlinchOffsetMag=(X=100.0,Y=0.0,Z=100.0)
    FlinchOffsetRate=(X=1000.0,Y=0.0,Z=1000.0)
    FlinchOffsetTime=1.0
    MortarTargetIndex=255
    ROMidGameMenuClass="DH_Interface.DHDeployMenu"
    GlobalDetailLevel=5
    DesiredFOV=90.0
    DefaultFOV=90.0
    PlayerReplicationInfoClass=class'DH_Engine.DHPlayerReplicationInfo'
    InputClass=class'DH_Engine.DHPlayerInput'
    PawnClass=class'DH_Engine.DHPawn'
    SpawnPointIndex=255
    VehiclePoolIndex=255
    SpawnVehicleIndex=255

    DHPrimaryWeapon=-1
    DHSecondaryWeapon=-1
}

