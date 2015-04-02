//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPlayer extends ROPlayer;

var     int                     RedeployTime;
var     float                   LastKilledTime;             // the time at which last death occured
var     byte                    DesiredAmmoAmount;
var     bool                    bShouldAttemptAutoDeploy;
var     bool                    bSwappedTeams;
var     DHHintManager           DHHintManager;
var     float                   MapVoteTime;
var     DH_LevelInfo            ClientLevelInfo;

// DH sway values
var     protected InterpCurve   BobCurve;                   // the amount of weapon bob to apply based on an input time in ironsights
var     protected float         DHSwayElasticFactor;
var     protected float         DHSwayDampingFactor;

// Rotation clamp values
var     protected float         DHSprintMaxTurnSpeed;
var     protected float         DHProneMaxTurnSpeed;
var     protected float         DHStandardTurnSpeedFactor;
var     protected float         DHHalfTurnSpeedFactor;

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

var     byte                    MortarTargetIndex;
var     vector                  MortarHitLocation;

var     byte                    SpawnPointIndex;
var     byte                    SpawnVehicleIndex;
var     byte                    VehiclePoolIndex;
var     vehicle                 MyLastVehicle;              // used for vehicle spawning to remember last vehicle player spawned (only used by server)

// Debug:
var     bool                    bSkyOff;                    // flags that the sky has been turned off (like "show sky" console command in single player)
var     SkyZoneInfo             SavedSkyZone;               // saves the original SkyZone for the player's current ZoneInfo, so it can be restored when the sky is turned back on

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        RedeployTime, SpawnPointIndex, VehiclePoolIndex, SpawnVehicleIndex;

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsInStateMantling, MortarTargetIndex, MortarHitLocation;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerThrowATAmmo, ServerLoadATAmmo, ServerThrowMortarAmmo, ServerSaveMortarTarget, ServerCancelMortarTarget,
        ServerLeaveBody, ServerClearObstacle, ServerDebugObstacles, ServerDoLog, ServerAttemptDeployPlayer, ServerSetPlayerInfo;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientProne, ClientToggleDuck, ClientConsoleCommand, ClientHandleDeath, ClientFadeFromBlack;
}

function ServerChangePlayerInfo(byte newTeam, byte newRole, byte newWeapon1, byte newWeapon2) {} // No longer used

// Modified to have client setup access to DH_LevelInfo so it can get info from it
simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    // Make this only run by the owning client
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Find DH_LevelInfo and assign it to ClientLevelInfo, so client can access it
        foreach self.AllActors(class'DH_LevelInfo', ClientLevelInfo)
            break;
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

    //Reset deploy stuff
    RedeployTime = default.RedeployTime;
    LastKilledTime = 0;
    DesiredAmmoAmount = 0;
    bShouldAttemptAutoDeploy = false;

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
    // Try to move these to class variables so they aren't created every tick
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

    // If we haven't picked a team, role and weapons yet, or is a spectator... open the team pick menu
    if (!bWeaponsSelected)
    {
        ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
    }
    else if (PlayerReplicationInfo.Team == none)
    {
        ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
    }
    else if (PlayerReplicationInfo.Team != none && PlayerReplicationInfo.Team.TeamIndex == 254)
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
        StopForceFeedback();

    // Open correct menu
    if (bDemoOwner)
    {
        ClientOpenMenu(DemoMenuClass);
    }
    else
    {
        // If we haven't picked a team, role and weapons yet, or is a spectator... open the team pick menu
        if (!bWeaponsSelected)
        {
            ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
        }
        else if (PlayerReplicationInfo.Team == none)
        {
            ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
        }
        else if (PlayerReplicationInfo.Team != none && PlayerReplicationInfo.Team.TeamIndex == 254)
        {
            ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
        }
        else
        {
            ClientOpenMenu(ROMidGameMenuClass);
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
    local DH_Pawn   ROPwn;
    local ROWeapon  ROWeap;

    // Lets avoid casting 20 times every tick - Ramm
    ROPwn = DH_Pawn(Pawn);

    if (Pawn != none)
    {
        ROWeap = ROWeapon(Pawn.Weapon);
    }

    if (bSway && Pawn != none && !Pawn.bBipodDeployed && Pawn.Weapon != none && Pawn.Weapon.bCanSway && Pawn.Weapon.bUsingSights && !ROWeap.bWaitingToBolt)
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
    if (bFreeCam == true)
    {
        if (bHudLocksPlayerRotation)
        {
            // No camera change if we're locking rotation
        }
        else if (bFreeCamZoom == true)
        {
            CameraDeltaRad += DeltaTime * 0.25 * aLookUp;
        }
        else if (bFreeCamSwivel == true)
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

        if (bTurnToNearest != 0)
        {
            TurnTowardNearestEnemy();
        }
        else if (bTurn180 != 0)
        {
            TurnAround();
        }
        else
        {
            TurnTarget = none;
            bRotateToDesired = false;
            bSetTurnRot = false;

            if (bHudLocksPlayerRotation)
            {
                // No camera change if we're locking rotation
            }
            else if (ROPwn != none && ROPwn.bIsCrawling)
            {
                // Clamp the rotational change for prone
                ViewRotation.Yaw += FClamp((DHHalfTurnSpeedFactor * DeltaTime * aTurn), -DHProneMaxTurnSpeed, DHProneMaxTurnSpeed);
                ViewRotation.Pitch += FClamp((DHHalfTurnSpeedFactor * DeltaTime * aLookUp), -DHProneMaxTurnSpeed, DHProneMaxTurnSpeed);
            }
            else if (ROPwn != none && ROPwn.bIsSprinting)
            {
                // Clamp the rotational change for sprint
                ViewRotation.Yaw += FClamp((DHHalfTurnSpeedFactor * DeltaTime * aTurn), -DHSprintMaxTurnSpeed, DHSprintMaxTurnSpeed);
                ViewRotation.Pitch += FClamp((DHHalfTurnSpeedFactor * DeltaTime * aLookUp), -DHSprintMaxTurnSpeed, DHSprintMaxTurnSpeed);
            }
            else if (ROPwn != none && ROPwn.bRestingWeapon)
            {
                ViewRotation.Yaw += DHHalfTurnSpeedFactor * DeltaTime * aTurn;
                ViewRotation.Pitch += DHHalfTurnSpeedFactor * DeltaTime * aLookUp;
            }
            else
            {
                ViewRotation.Yaw += DHStandardTurnSpeedFactor * DeltaTime * aTurn;
                ViewRotation.Pitch += DHStandardTurnSpeedFactor * DeltaTime * aLookUp;
            }

            if (Pawn != none && Pawn.Weapon != none && ROPwn != none)
            {
                ViewRotation = FreeAimHandler(ViewRotation, DeltaTime);
            }
        }

        if (ROPwn != none)
        {
            ViewRotation.Pitch = ROPwn.LimitPitch(ViewRotation.Pitch, DeltaTime);
        }

        if (ROPwn != none && (ROPwn.bBipodDeployed || ROPwn.bIsMantling || ROPwn.bIsDeployingMortar || ROPwn.bIsCuttingWire))
        {
            ROPwn.LimitYaw(ViewRotation.Yaw);
        }

        // Limit Pitch and yaw for the ROVehicles - Ramm
        if (Pawn != none && Pawn.IsA('ROVehicle'))
        {
            ROVeh = ROVehicle(Pawn);

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

/* ======================================================================================================================= *
* ServerSaveArtilleryPosition()
*   Sends out a trace to find the saved artillery coordinates, then verifies that the coordinates are in a valid location.
*   Sends a confirmation or denial message to the player. Client calls this function on the server.
*
* modified by: Ramm 10/21/04
*===================================== =================================================================================== */
function ServerSaveArtilleryPosition()
{
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo PRI;
    local Actor        HitActor;
    local vector       HitLocation, HitNormal, StartTrace;
    local Material     HitMaterial;
    local int          TraceDist, i;
    local ROVolumeTest RVT;
    local rotator      AimRot;
    local bool         bFoundARadio;
    local DH_RoleInfo  RI;

    if (DH_Pawn(Pawn) == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    RI = DH_Pawn(Pawn).GetRoleInfo();

    if (PRI == none || PRI.RoleInfo == none || RI == none || !RI.bIsArtilleryOfficer)
    {
        return;
    }

    GRI = DHGameReplicationInfo(GameReplicationInfo);

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

    if (!bFoundARadio)
    {
        ReceiveLocalizedMessage(class'ROArtilleryMsg', 9);

        return;
    }

    // If you don't have binocs can't call arty strike
    if (Pawn.Weapon != none && Pawn.Weapon.IsA('BinocularsItem'))
    {
        TraceDist = GetMaxViewDistance();
        StartTrace = Pawn.Location + Pawn.EyePosition();
        AimRot = Rotation;
    }
    else if (Pawn.IsA('ROVehicleWeaponPawn'))
    {
        TraceDist = GetMaxViewDistance();
        AimRot = ROVehicleWeaponPawn(Pawn).CustomAim;
        StartTrace = ROVehicleWeaponPawn(Pawn).GetViewLocation() + 500.0 * vector(AimRot);
    }
    else
    {
       return;
    }

    HitActor = Trace(HitLocation, HitNormal, StartTrace + TraceDist * vector(AimRot), StartTrace, true,, HitMaterial);

    RVT = Spawn(class'ROVolumeTest', self,, HitLocation);

    if ((RVT != none && RVT.IsInNoArtyVolume()) || HitActor == none || HitNormal == vect(0.0, 0.0, -1.0))
    {
        ReceiveLocalizedMessage(class'ROArtilleryMsg', 5);
        RVT.Destroy();

        return;
    }

    RVT.Destroy();

    ReceiveLocalizedMessage(class'ROArtilleryMsg', 0);

    SavedArtilleryCoords = HitLocation;
}

// Spawn the artillery strike at the appropriate position
function ServerArtyStrike()
{
    local vector                SpawnLocation;
    local ROGameReplicationInfo GRI;
    local DH_ArtillerySpawner   Spawner;

    GRI = ROGameReplicationInfo(GameReplicationInfo);

    SpawnLocation = SavedArtilleryCoords;
    SpawnLocation.Z = GRI.NorthEastBounds.Z;

    Spawner = Spawn(class'DH_ArtillerySpawner', self, , SpawnLocation, rotator(PhysicsVolume.Gravity));

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
            return 65536;

        case VDL_Medium_2000m:
            return 131072;

        case VDL_High_3000m:
            return 196608;

        case VDL_Extreme_4000m:
            return 262144;

        default:
            return 65536;
    }
}

function ServerCancelMortarTarget()
{
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local bool bTargetCancelled;

    // Null target index - no target to cancel
    if (MortarTargetIndex == 255)
    {
        ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 7);

        return;
    }

    if (GameReplicationInfo != none)
    {
        GRI = DHGameReplicationInfo(GameReplicationInfo);
    }

    if (PlayerReplicationInfo != none)
    {
        PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    }

    if (GetTeamNum() == 0)
    {
        if (Level.TimeSeconds - GRI.GermanMortarTargets[MortarTargetIndex].Time < 15)
        {
            // You cannot cancel your mortar target yet
            ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 5);

            return;
        }
        else
        {
            GRI.GermanMortarTargets[MortarTargetIndex].bCancelled = 1;
            MortarTargetIndex = 255; // reset our mortar target index to null value
            bTargetCancelled = true;
        }
    }
    else
    {
        if (Level.TimeSeconds - GRI.AlliedMortarTargets[MortarTargetIndex].Time < 15)
        {
            // You cannot cancel your mortar target yet
            ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 5);

            return;
        }
        else
        {
            GRI.AlliedMortarTargets[MortarTargetIndex].bCancelled = 1;
            MortarTargetIndex = 255; // reset our mortar target index to null value
            bTargetCancelled = true;
        }
    }

    if (bTargetCancelled)
    {
        // [DH]Basnett has cancelled a mortar target
        Level.Game.BroadcastLocalizedMessage(class'DH_MortarTargetMessage', 3, PRI);
    }
    else
    {
        // You have no mortar target to cancel
        ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 7);
    }
}

function ServerSaveMortarTarget()
{
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo PRI;
    local DH_Pawn      P;
    local Actor        HitActor;
    local vector       HitLocation, HitNormal, TraceStart, TraceEnd;
    local ROVolumeTest VT;
    local int          TeamIndex, i;
    local bool         bMortarsAvailable, bMortarTargetMarked;

    TeamIndex = GetTeamNum();
    P = DH_Pawn(Pawn);
    GRI = DHGameReplicationInfo(GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    TraceStart = Pawn.Location + Pawn.EyePosition();
    TraceEnd = TraceStart + (vector(Rotation) * GetMaxViewDistance());
    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true,,);

    VT = Spawn(class'ROVolumeTest', self,, HitLocation);

    // Check that the artillery target is not in a no artillery volume
    if ((VT != none && VT.IsInNoArtyVolume()) || HitActor == none)
    {
        // Invalid mortar target
        ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 0);
        VT.Destroy();

        return;
    }

    VT.Destroy();

    // Check that there are mortar operators available and that we haven't set a mortar target in the last 30 seconds
    if (TeamIndex == 0) // axis
    {
        for (i = 0; i < arraycount(GRI.GermanMortarTargets); ++i)
        {
            if (GRI.GermanMortarTargets[i].Controller == self && GRI.GermanMortarTargets[i].Time != 0.0 && Level.TimeSeconds - GRI.GermanMortarTargets[i].Time < 15.0)
            {
                // You cannot mark another mortar target yet
                ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 4);

                return;
            }
        }

        // Go through the roles and find a mortar operator role that has someone on it
        for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
        {
            if (GRI.DHAxisRoles[i]!= none && GRI.DHAxisRoles[i].bCanUseMortars && GRI.DHAxisRoleCount[i] > 0)
            {
                // Mortar operator available!
                bMortarsAvailable = true;
                break;
            }
        }
    }
    else
    {
        for (i = 0; i < arraycount(GRI.AlliedMortarTargets); ++i)
        {
            if (GRI.AlliedMortarTargets[i].Controller == self && GRI.AlliedMortarTargets[i].Time != 0.0 && Level.TimeSeconds - GRI.AlliedMortarTargets[i].Time < 15.0)
            {
                ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 4);

                return;
            }
        }

        for (i = 0; i < arraycount(GRI.DHAlliesRoles); ++i)
        {
            if (GRI.DHAlliesRoles[i] != none && GRI.DHAlliesRoles[i].bCanUseMortars && GRI.DHAlliesRoleCount[i] > 0)
            {
                bMortarsAvailable = true;
                break;
            }
        }
    }

    if (!bMortarsAvailable)
    {
        // No mortar operators available
        ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 1);

        return;
    }

    // Zero out the z coordinate for 2D distance checking on round hits
    HitLocation.Z = 0.0;

    if (TeamIndex == 0) // axis
    {
        for (i = 0; i < arraycount(GRI.GermanMortarTargets); ++i)
        {
            if (GRI.GermanMortarTargets[i].Controller == none || GRI.GermanMortarTargets[i].Controller == self)
            {
                GRI.GermanMortarTargets[i].Controller = self;
                GRI.GermanMortarTargets[i].HitLocation = vect(0.0, 0.0, 0.0);
                GRI.GermanMortarTargets[i].Location = HitLocation;
                GRI.GermanMortarTargets[i].Time = Level.TimeSeconds;
                GRI.GermanMortarTargets[i].bCancelled = 0;
                MortarTargetIndex = i;
                bMortarTargetMarked = true;
                break;
            }
        }
    }
    else // allies
    {
        for (i = 0; i < arraycount(GRI.AlliedMortarTargets); ++i)
        {
            if (GRI.AlliedMortarTargets[i].Controller == none || GRI.AlliedMortarTargets[i].Controller == self)
            {
                GRI.AlliedMortarTargets[i].Controller = self;
                GRI.AlliedMortarTargets[i].HitLocation = vect(0.0, 0.0, 0.0);
                GRI.AlliedMortarTargets[i].Location = HitLocation;
                GRI.AlliedMortarTargets[i].Time = Level.TimeSeconds;
                GRI.AlliedMortarTargets[i].bCancelled = 0;
                MortarTargetIndex = i;
                bMortarTargetMarked = true;
                break;
            }
        }
    }

    if (bMortarTargetMarked)
    {
        // [DH]Basnett has marked a mortar target
        Level.Game.BroadcastLocalizedMessage(class'DH_MortarTargetMessage', 2, PlayerReplicationInfo,,);
    }
    else
    {
        // There are too many active mortar targets
        ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 6);
    }
}

// Overridden to handle separate MG and AT resupply as well as assisted AT loading
exec function ThrowMGAmmo()
{
    if (DH_Pawn(Pawn) == none)
    {
        return;
    }

    if (DHHud(myHud).NamedPlayer != none)
    {
        if (DH_Pawn(Pawn).bCanATReload)
        {
            ServerLoadATAmmo(DHHud(myHud).NamedPlayer);
        }
        else if (DH_Pawn(Pawn).bCanATResupply && DH_Pawn(Pawn).bHasATAmmo)
        {
            ServerThrowATAmmo(DHHud(myHud).NamedPlayer);
        }
        else if (DH_Pawn(Pawn).bCanMGResupply && (DH_Pawn(Pawn).bHasMGAmmo))
        {
            ServerThrowMGAmmo(DHHud(myHud).NamedPlayer);
        }
        else if (DH_Pawn(Pawn).bCanMortarResupply && (DH_Pawn(Pawn).bHasMortarAmmo))
        {
            ServerThrowMortarAmmo(DHHud(myHud).NamedPlayer);
        }
    }
}

function ServerThrowMGAmmo(Pawn Gunner)
{
    DH_Pawn(Pawn).TossAmmo(Gunner);
}

function ServerThrowATAmmo(Pawn Gunner)
{
    DH_Pawn(Pawn).TossAmmo(Gunner, true);
}

function ServerThrowMortarAmmo(Pawn Gunner)
{
    if (DH_MortarVehicle(Gunner) != none)
    {
        DH_Pawn(Pawn).TossMortarVehicleAmmo(DH_MortarVehicle(Gunner));
    }
    else if (DH_Pawn(Gunner) != none)
    {
        DH_Pawn(Pawn).TossMortarAmmo(DH_Pawn(Gunner));
    }
}

function ServerLoadATAmmo(Pawn Gunner)
{
    DH_Pawn(Pawn).LoadWeapon(Gunner);
}

state PlayerWalking
{
    function Timer()
    {
        // Handle check if we should try to enter spawned vehicle
        if (MyLastVehicle != none)
        {
            ClientFadeFromBlack(4.0);

            if (Pawn != none)
            {
                MyLastVehicle.TryToDrive(Pawn);
            }
            MyLastVehicle = none; // Remove it even if it failed
        }
    }

    // Matt: modified to allow behind view in debug mode
    function ClientSetBehindView(bool B)
    {
        if (B && Role < ROLE_Authority && !class'DH_LevelInfo'.static.DHDebugMode()) // added !DHDebugMode
        {
            ServerCancelBehindview();

            return;
        }

        super(PlayerController).ClientSetBehindView(B);
    }

    // Added a test for mantling
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector  OldAccel;
        local DH_Pawn P;

        P = DH_Pawn(Pawn);

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
            DH_Pawn(Pawn).ClientMantleFail();
        }

        if (bPressedJump && !bWaitingToMantle)
        {
            if (P.CanMantle(true))
            {
                if (Role == ROLE_Authority)
                {
                    GoToState('Mantling');
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
        local DH_Pawn         P;

        P = DH_Pawn(Pawn);

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
                if (DH_BipodWeapon(Pawn.Weapon) != none)
                {
                    DH_BipodWeapon(Pawn.Weapon).ForceUndeploy();
                }
                else if (DH_BipodAutoWeapon(Pawn.Weapon) != none)
                {
                    DH_BipodAutoWeapon(Pawn.Weapon).ForceUndeploy();
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

            // Not sure if we need this or not - Ramm
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
        local DH_Pawn DHP;

        DHP = DH_Pawn(Pawn);

        if (DHP.Physics == PHYS_Walking)
        {
            // This is just in case we fall further than expected and are unable to set crouch in DH_Pawn.ResetRootBone()
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
        local DH_Pawn DHP;

        DHP = DH_Pawn(Pawn);

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
        local DH_Pawn         DHP;

        DHP = DH_Pawn(Pawn);

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
        if (Role < ROLE_Authority && !DH_Pawn(Pawn).bIsMantling)
        {
            DH_Pawn(Pawn).CanMantle(true, true);
        }

        bSprint = 0;
        DH_Pawn(Pawn).PreMantle();

        if (bLockJump)
        {
            bLockJump = false;
        }

        MantleLoopCount = 0;
    }

    function EndState()
    {
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

        if (DH_Pawn(Pawn).bIsMantling)
        {
            DH_Pawn(Pawn).CancelMantle();
        }

        if (bMantleDebug && Pawn.IsLocallyControlled())
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
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo DH_PRI;
    local DH_RoleInfo             RI;

    DH_PRI = DHPlayerReplicationInfo(PRI);
    RI = DH_RoleInfo(DH_PRI.RoleInfo);

    if (DH_PRI == none || RI == none)
    {
        return;
    }

    // Check if caller is a leader
    if (!RI.bIsSquadLeader)
    {
        // If not, check if we're a MG requesting ammo
        // Basnett, added mortar operators requesting resupply.
        if (RequestType != 3 || (!RI.bIsGunner && !RI.bCanUseMortars)) // && !DH_PRI.DHRoleInfo.bIsATGunner)
        {
            return;
        }
    }

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none)
    {
        GRI.AddHelpRequest(PRI, ObjID, RequestType, RequestLocation);

        // Notify team members to check their map
        if (DH_PRI.Team != none)
        {
            DarkestHourGame(Level.Game).NotifyPlayersOfMapInfoChange(DH_PRI.Team.TeamIndex, self);
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
        FOVAngle -= (FClamp(10.0 * DeltaTime, 0.0, 1.0) * (FOVAngle - DesiredFOV)); //TODO: arbitrary number

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
    if ((PlayerReplicationInfo != none && PlayerReplicationInfo.bOnlySpectator) || !bCanRespawn)
    {
        return false;
    }
    else if (!HasSelectedTeam() || !HasSelectedRole() || !HasSelectedWeapons())
    {
        return false;
    }

    return true;
}

// Modified incase this ever gets called, make it open the deploy menu instead of old RoleMenu
simulated function ClientForcedTeamChange(int NewTeamIndex, int NewRoleIndex)
{
    // Store the new team and role info
    ForcedTeamSelectOnRoleSelectPage = NewTeamIndex;
    DesiredRole = NewRoleIndex;

    // Open the Deploy menu
    ClientOpenMenu("DH_Interface.DHDeployMenu");
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
        ReceiveLocalizedMessage(class'ROArtilleryMsg', 3,,, self);

        if (PawnTeam ==  0)
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
        if (PawnTeam ==  0)
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
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 6);
        }
        else if (TimeTilNextStrike >= 20)
        {
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 7);
        }
        else if (TimeTilNextStrike >= 0)
        {
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 8);
        }
        else
        {
            ReceiveLocalizedMessage(class'ROArtilleryMsg', 2);
        }
    }
}

// Matt: modified to call ToggleBehindView to avoid code repetition
exec function BehindView(bool B)
{
    if (B != bBehindView)
    {
        ToggleBehindView();
    }
}

// Matt: modified to avoid wasteful call to server if we know behind view isn't allowed (note can't do other checks here, as client can't access GameInfo's bAllowBehindView)
exec function ToggleBehindView()
{
    if (Vehicle(Pawn) == none || Vehicle(Pawn).bAllowViewChange || class'DH_LevelInfo'.static.DHDebugMode()) // allow vehicles to limit view changes
    {
        ServerToggleBehindview();
    }
}

// Modified to allow behind view if we are in DHDebugMode (during development only) & to disallow behind view just because a player is a game admin
function ServerToggleBehindView()
{
    if (Level.NetMode == NM_Standalone || Level.Game.bAllowBehindView || PlayerReplicationInfo.bOnlySpectator || class'DH_LevelInfo'.static.DHDebugMode())
    {
        if (Vehicle(Pawn) == none || Vehicle(Pawn).bAllowViewChange || class'DH_LevelInfo'.static.DHDebugMode()) // allow vehicles to limit view changes
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

// DH version, but only showing the vehicle occupant ('Driver') hit points, not the vehicle's special hit points for engine & ammo stores
simulated exec function DriverCollisionDebug()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && ROHud(myHUD) != none)
    {
        ROHud(myHUD).bDebugDriverCollision = !ROHud(myHUD).bDebugDriverCollision;
        SetSkyOff(ROHud(myHUD).bDebugDriverCollision);
    }
}

// New exec showing vehicle special hit points for engine (blue) & ammo stores (red), plus a DHTreadCraft's extra hit points (gold for gun traverse/pivot, pink for periscopes)
simulated exec function VehicleHitPointDebug()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && DHHud(myHUD) != none)
    {
        DHHud(myHUD).bDebugVehicleHitPoints = !DHHud(myHUD).bDebugVehicleHitPoints;
        SetSkyOff(DHHud(myHUD).bDebugVehicleHitPoints);
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
    else if (bSkyOff && !(ROHud(myHUD) != none && (ROHud(myHUD).bDebugDriverCollision || ROHud(myHUD).bDebugPlayerCollision || (DHHud(myHUD) != none && DHHud(myHUD).bDebugVehicleHitPoints))))
    {
        bSkyOff = false;
        PlayerReplicationInfo.PlayerZone.SkyZone = SavedSkyZone;
    }
}

// Matt: DH version
exec function ClearLines()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ClearStayingDebugLines();
    }
}

// Matt: new exec
exec function ClearArrows()
{
    local RODebugTracer Tracer;

    if (class'DH_LevelInfo'.static.DHDebugMode())
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

    foreach AllActors(class'ROTreadCraft', V)
    {
        if (TreadVelocityScale == -1)
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

simulated exec function DebugTreadVelocityScaleIncrement()
{
    local ROTreadCraft V;

    foreach AllActors(class'ROTreadCraft', V)
    {
        V.TreadVelocityScale += 1.0;
    }
}

simulated exec function DebugTreadVelocityScaleDecrement()
{
    local ROTreadCraft V;

    foreach AllActors(class'ROTreadCraft', V)
    {
        V.TreadVelocityScale -= 1.0;
    }
}

simulated exec function DebugWheelRotationScale(int WheelRotationScale)
{
    local ROTreadCraft V;

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

exec function LeaveBody()
{
    ServerLeaveBody();
}

function ServerLeaveBody()
{
    Pawn.UnPossessed();
    Pawn.SetPhysics(PHYS_None);
    Pawn.Velocity = vect(0.0, 0.0, 0.0);
    Pawn = none;
}

exec function DebugRoundPause()
{
    DarkestHourGame(Level.Game).RoundDuration = 9999999;
    DHGameReplicationInfo(DarkestHourGame(Level.Game).GameReplicationInfo).RoundDuration = 9999999;
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
    ServerDebugObstacles(Option);
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

exec function DebugFOV()
{
    Level.Game.Broadcast(self, "FOV:" @ FovAngle);
}

// Theel TODO: Revise if statements (combine and optimize this function)
function bool ServerAttemptDeployPlayer(byte MagCount, optional bool bROSpawn)
{
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo DHGRI;
    local DH_RoleInfo RI;
    local class<Inventory> PrimaryWep;
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    DHGRI = DHGameReplicationInfo(GameReplicationInfo);

    if (PRI != none)
    {
        RI = DH_RoleInfo(PRI.RoleInfo);
    }

    if (RI != none && PrimaryWeapon > 0 && PrimaryWeapon < arraycount(RI.PrimaryWeapons))
    {
        PrimaryWep = RI.PrimaryWeapons[PrimaryWeapon].Item;
    }

    // Check if the player is on Axis / Allies and not spectator or something
    if (PRI.Team == none)
    {
        Log("Failed at team check");

        return false;
    }

    if (PRI == none || DHGRI == none || Pawn != none)
    {
        Log("Failed at 0");

        return false;
    }

    // Confirm this player has a role
    if (PRI.RoleInfo == none)
    {
        Log("Failed at RoleInfo check");

        return false;
    }

    // Make sure player's team matches the player's role's team
    if (PRI.RoleInfo.Side != GetTeamNum())
    {
        Log("RoleInfoTeam:" @ int(PRI.RoleInfo.Side) @ "PlayerTeam:" @ GetTeamNum());
        Log("Failed at RoleTeam vs PlayerTeam check");
        return false;
    }

    if (MagCount != 0 && PrimaryWep != none && MagCount > class<DH_ProjectileWeapon>(PrimaryWep).default.MaxNumPrimaryMags)
    {
        Log("Failed at 1 MagCount is:" @ MagCount);

        return false;
    }

    // Check if player is ready to deploy
    if (LastKilledTime + RedeployTime - Level.TimeSeconds > 0)
    {
        Log("Failed at 4");

        return false;
    }

    // Check if SP is valid
    if (DHGRI.IsSpawnPointIndexValid(SpawnPointIndex, PRI.Team.TeamIndex))
    {
        G.DeployRestartPlayer(self, true);
    }
    else if (DHGRI.CanSpawnAtVehicle(SpawnVehicleIndex, self))
    {
        G.DeployRestartPlayer(self, true);
    }
    else
    {
        if (bROSpawn)
        {
            G.DeployRestartPlayer(self, true, true);
        }
        else
        {
            Warn("Neither SpawnPointIndex or SpawnVehicleIndex is set!!!");
        }
    }

    if (Pawn != none)
    {
        if (MagCount != 0 && DH_Pawn(Pawn) != none)
        {
            DH_Pawn(Pawn).SetAmmoPercent(MagCount);
        }

        RedeployTime = CalculateDeployTime(MagCount); // Calculate and set server/client redeploy time

        if (MyLastVehicle != none && self.IsInState('PlayerWalking'))
        {
            SetTimer(1.0, false); // 1 second delay before attempting to drive again
            ClientFadeFromBlack(0.0, true); // Black out
        }
        else
        {
            ClientFadeFromBlack(3.0);
        }

        return true;
    }

    return false;
}

// This function returns the redeploy time of this player with it's current role, weapon, ammo, equipement, etc.
// Pass this function with MagCount = -1 to have the function use Desired variable in this class
simulated function int CalculateDeployTime(int MagCount, optional RORoleInfo RInfo, optional int WeaponIndex)
{
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo   GRI;
    local DH_RoleInfo             RI;
    local class<Inventory>        PrimaryWep;
    local int MinValue, MidValue, MaxValue, AmmoTimeMod, NewDeployTime;
    local float TD, D, P;

    GRI = DHGameReplicationInfo(GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI != none && RInfo == none)
    {
        RI = DH_RoleInfo(PRI.RoleInfo);
    }
    else
    {
        RI = DH_RoleInfo(RInfo);
    }

    if (RI != none && (WeaponIndex == -1 || WeaponIndex > arraycount(RI.PrimaryWeapons)) && RI.PrimaryWeapons[PrimaryWeapon].Item != none)
    {
        PrimaryWep = RI.PrimaryWeapons[PrimaryWeapon].Item;
    }
    else if (RI != none && RI.PrimaryWeapons[WeaponIndex].Item != none)
    {
        PrimaryWep = RI.PrimaryWeapons[WeaponIndex].Item;
    }

    // Make sure everything is set and no access nones
    if (PRI == none || RI == none || GRI == none)
    {
        Warn("Error in Calculating deploy time");
        return 0;
    }
    else if (PrimaryWep != none)
    {
        // If MagCount wasn't passed, lets use desired ammo amount
        if (MagCount == -1)
        {
            MagCount = DesiredAmmoAmount;
        }

        // Calculate the min,mid,max for determining how to adjust AmmoTimeMod
        MinValue = RI.MinStartAmmo * class<DH_ProjectileWeapon>(PrimaryWep).default.MaxNumPrimaryMags / 100;
        MidValue = RI.DefaultStartAmmo * class<DH_ProjectileWeapon>(PrimaryWep).default.MaxNumPrimaryMags / 100;
        MaxValue = RI.MaxStartAmmo * class<DH_ProjectileWeapon>(PrimaryWep).default.MaxNumPrimaryMags / 100;

        // Set AmmoTimeMod based on MagCount
        if (MagCount == MidValue)
        {
            AmmoTimeMod = 0;
        }
        else if (MagCount > MidValue)
        {
            TD = MaxValue - MidValue;
            D = MagCount - MidValue;
            P = D / TD;
            AmmoTimeMod = int(P * RI.MaxAmmoTimeMod);
        }
        else if (MagCount < MidValue)
        {
            TD = MidValue - MinValue;
            D = MidValue - MagCount;
            P = D / TD;
            AmmoTimeMod = int(P * RI.MinAmmoTimeMod);
        }
    }

    NewDeployTime = GRI.ReinforcementInterval[PRI.Team.TeamIndex] + RI.DeployTimeMod + AmmoTimeMod;

    if (NewDeployTime < 0)
    {
        NewDeployTime = 0;
    }

    return NewDeployTime;
}

function PawnDied(Pawn P)
{
    //Make sure the pawn that died is our pawn, not some random other pawn
    if (P != Pawn)
    {
        return;
    }

    LastKilledTime = Level.TimeSeconds; // We don't pass a time, because we want client to set the time not the server!

    ClientHandleDeath(); //Tells client to set his last killed time, that he can't spawn yet, and to autodeploy if has desired spawn

    super.PawnDied(P); //Calls super in ROPlayer
}


simulated function ClientHandleDeath()
{
    // Theel: This needs to be a smarter check!
    if (SpawnPointIndex != 255)
    {
        bShouldAttemptAutoDeploy = true;
    }

    LastKilledTime = Level.TimeSeconds; // We don't pass a time, because we want client to set the time not the server!
}

// This function is called from DHHud to deploy the player when their deploy time hits zero and they are waiting in the HUD
// Theel: this function needs to be made smarter
// This function need a lot of work / clean up
simulated function CheckToAutoDeploy()
{
    local bool bDeployed; // Poor name for variable
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    bShouldAttemptAutoDeploy = false;

    //If player is in a menu, don't try to deploy
    if (GUIController(Player.GUIController).ActivePage != none)
    {
        return;
    }

    //If we have a desired spawn point set, we won't need to open menu and can send spawn request from here
    if (SpawnPointIndex != 255 && Pawn == none)
    {
        //Check if desired spawn is valid
        bDeployed = GRI.IsSpawnPointIndexValid(SpawnPointIndex, PlayerReplicationInfo.Team.TeamIndex);

        if (bDeployed)
        {
            ServerAttemptDeployPlayer(DesiredAmmoAmount);

            return;
        }
        else
        {
            // Can't change this value like this
            SpawnPointIndex = 255;
        }
    }

    //Open deploy menu if no menu is currently open and player doesn't have a valid spawn point selected
    if (!bDeployed && GUIController(Player.GUIController).ActivePage == none)
    {
        ClientReplaceMenu("DH_Interface.DHDeployMenu");
    }
}

// Function to get offset coordinates from nearby vehicle(s) to create/adjust vehicle exit positions (Only works in singleplayer)
exec function ExitPosTool()
{
    local ROVehicle NearbyVeh;
    local vector Offset;

    if (Level.NetMode == NM_Standalone)
    {
        foreach RadiusActors(class'ROVehicle', NearbyVeh, 300.0, Pawn.Location)
        {
            Offset = (Pawn.Location - NearbyVeh.Location) << NearbyVeh.Rotation;

            Log("Vehicle:" @ NearbyVeh.GetHumanReadableName() @ "(X=" $ Round(Offset.X) $ ",Y=" $ Round(Offset.Y) $ ",Z=" $ Round(Offset.Z) $ ")");
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
    local float WeaponSwayYawAcc;
    local float WeaponSwayPitchAcc;
    local float DeltaSwayYaw;
    local float DeltaSwayPitch;
    local float timeFactor;
    local float bobFactor;
    local float staminaFactor;
    local DH_Pawn P;

    P = DH_Pawn(Pawn);

    if (P == None )
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
    timeFactor = InterpCurveEval(SwayCurve, SwayTime);

    // Get bobfactor based on bob curve
    bobFactor = InterpCurveEval(BobCurve, SwayTime);

    // Handle timefactor modifier & weapon bob for weapon type
    if (DHWeapon(P.Weapon) != none)
    {
        timeFactor *= DHWeapon(P.Weapon).SwayModifyFactor;
        P.IronSightBobFactor = bobFactor * DHWeapon(P.Weapon).BobModifyFactor;
    }

    // Add modifiers to sway for time in iron sights and stamina
    WeaponSwayYawAcc = (timeFactor * WeaponSwayYawAcc) + (staminaFactor * WeaponSwayYawAcc);
    WeaponSwayPitchAcc = (timeFactor * WeaponSwayPitchAcc) + (staminaFactor * WeaponSwayPitchAcc);

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

    if (P.LeanAmount != 0)
    {
        WeaponSwayYawAcc *= 1.45;
        WeaponSwayPitchAcc *= 1.45;
    }

    // Add a elastic and damping factor to get sway near the original aim-point and from causing wild oscillations
    WeaponSwayYawAcc = WeaponSwayYawAcc - (DHSwayElasticFactor*SwayYaw) - (DHSwayDampingFactor*WeaponSwayYawRate);
    WeaponSwayPitchAcc = WeaponSwayPitchAcc - (DHSwayElasticFactor*SwayPitch) - (DHSwayDampingFactor*WeaponSwayPitchRate);

    // Calculation for motion
    DeltaSwayYaw = (WeaponSwayYawRate * DeltaTime) + (0.5*WeaponSwayYawAcc*DeltaTime*DeltaTime);
    DeltaSwayPitch = (WeaponSwayPitchRate * DeltaTime) + (0.5*WeaponSwayPitchAcc*DeltaTime*DeltaTime);

    // Add actual sway
    SwayYaw += DeltaSwayYaw;
    SwayPitch += DeltaSwayPitch;

    if (P.bRestingWeapon)
    {
        SwayYaw = 0;
        SwayPitch = 0;
    }

    // Update new sway velocity (R = D*T)
    WeaponSwayYawRate += WeaponSwayYawAcc * DeltaTime;
    WeaponSwayPitchRate += WeaponSwayPitchAcc * DeltaTime;
}

// Modified to not allow IronSighting when transitioning to/from prone
simulated exec function ROIronSights()
{
    if( Pawn != none && Pawn.Weapon != none && !Pawn.IsProneTransitioning())
    {
        Pawn.Weapon.ROIronSights();
    }
}

// Client function to fade from black
function ClientFadeFromBlack(float time, optional bool bInvertFadeDirection)
{
    ROHud(MyHud).FadeToBlack(time, !bInvertFadeDirection);
}

// Modified to allow for faster suiciding, annoying when it doesn't work in MP
// There might be some unknown problem that having such a low value can cause
// This might be a temporary function then that will need removed for non dev work
exec function Suicide()
{
    if ((Pawn != None) && (Level.TimeSeconds - Pawn.LastStartTime > 1))
    {
        Pawn.Suicide();
    }
}

exec function SwitchTeam(){} // Disabled
exec function ChangeTeam( int N ){} // Disabled

// Modified to not join the opposite team if it fails to join the one passed (fixes a nasty exploit)
function ServerSetPlayerInfo(byte newTeam, byte newRole, byte newWeapon1, byte newWeapon2, byte NewSpawnPointIndex, byte NewVehiclePoolIndex, byte NewSpawnVehicleIndex)
{
    local DarkestHourGame DHG;

    DHG = DarkestHourGame(Level.Game);

    // This map uses the DH deploy system, not an RO spawn room
    if (DHG != none && DHG.DHLevelInfo != none && DHG.DHLevelInfo.SpawnMode != ESM_RedOrchestra)
    {
        // We need a SpawnManager !
        if (DHG.SpawnManager == none)
        {
            return;
        }

        // Invalid SpawnPointIndex - exit function
        if (NewSpawnPointIndex >= DHG.SpawnManager.GetSpawnPointCount() && NewSpawnPointIndex != 255) // 255 is the 'do nothing' passed value of SpawnPointIndex, which is acceptable
        {
            Warn("Invalid spawn point index" @ NewSpawnPointIndex);
            ClientChangePlayerInfoResult(19);
            SpawnPointIndex = 255; // reset spawn point index to null

            return;
        }

        // Invalid VehiclePoolIndex
        if (NewVehiclePoolIndex >= DHG.SpawnManager.GetVehiclePoolCount() && NewVehiclePoolIndex != 255)
        {
            Warn("Invalid vehicle pool index" @ NewVehiclePoolIndex);
            ClientChangePlayerInfoResult(20);
            VehiclePoolIndex = 255; // reset vehicle pool index to null
            //return;
        }

        // Invalid SpawnVehicleIndex
        if (NewSpawnVehicleIndex >= DHG.SpawnManager.GetSpawnVehicleCount() && NewSpawnVehicleIndex != 255)
        {
            Warn("Invalid spawn vehicle index" @ NewSpawnVehicleIndex);
            ClientChangePlayerInfoResult(21);
            SpawnVehicleIndex = 255; // reset spawn vehicle index to null
            //return;
        }

        SpawnPointIndex = NewSpawnPointIndex;
        VehiclePoolIndex = NewVehiclePoolIndex;
        SpawnVehicleIndex = NewSpawnVehicleIndex;
    }

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
                DesiredRole = -1;
                CurrentRole = -1;
                DesiredAmmoAmount = 0;
                SpawnPointIndex = 255;
                SpawnVehicleIndex = 255;
                VehiclePoolIndex = 255;
                MyLastVehicle = none;
                DesiredPrimary = 0;
                DesiredSecondary = 0;
                DesiredGrenade = 0;
            }

            // Check if change failed and output results
            if (PlayerReplicationInfo == none || PlayerReplicationInfo.Team == none || PlayerReplicationInfo.Team.TeamIndex != newTeam)
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
    if (newRole != 255)
    {
        ChangeRole(newRole);

        // Check if change was successful
        if (DesiredRole != newRole)
        {
            if (ROTeamGame(Level.Game) != none && PlayerReplicationInfo != none && PlayerReplicationInfo.Team != none &&
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

    ChangeWeapons(newWeapon1, newWeapon2, 0);

    // Success!
    if (newTeam == AXIS_TEAM_INDEX)
    {
        ClientChangePlayerInfoResult(97); // successfully picked axis team
    }
    else if (newTeam == ALLIES_TEAM_INDEX)
    {
        ClientChangePlayerInfoResult(98); // successfully picked allies team
    }
    else
    {
        ClientChangePlayerInfoResult(00);
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
    DHSprintMaxTurnSpeed=225.0
    DHProneMaxTurnSpeed=170.0
    DHStandardTurnSpeedFactor=32.0
    DHHalfTurnSpeedFactor=16.0

    // Other values
    RedeployTime=15
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
    PawnClass=class'DH_Engine.DH_Pawn'
    SpawnPointIndex=255
    VehiclePoolIndex=255
}
