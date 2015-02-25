//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHPlayer extends ROPlayer;

var int             RedeployTime;
var float           LastKilledTime; // The time at which last death occured
var byte            DesiredAmmoAmount;
var DHSpawnPoint    DesiredSpawnPoint;
var bool            bShouldAttemptAutoDeploy;

var vector  FlinchRotMag;
var vector  FlinchRotRate;
var float   FlinchRotTime;
var vector  FlinchOffsetMag;
var vector  FlinchOffsetRate;
var float   FlinchOffsetTime;

var float   MantleCheckTimer;   // Makes sure client doesn't try to start mantling without the server
var float   MantleFailTimer;    // Makes sure we don't get stuck floating in an object unable to end a mantle
var bool    bDidMantle;         // Is the mantle complete?
var bool    bIsInStateMantling; // Stop the client from exiting state until server has exited to avoid desync
var bool    bDidCrouchCheck;
var bool    bWaitingToMantle;
var bool    bLockJump;
var bool    bMantleDebug;
var int     MantleLoopCount;

var byte    MortarTargetIndex;
var vector  MortarHitLocation;

var int     SpawnPointIndex;
var int     VehiclePoolIndex;

var DHHintManager DHHintManager;

var float   MapVoteTime;

replication //THEEL: SpawnPointIndex does not need to be replicated to my knowledge
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        RedeployTime, SpawnPointIndex, VehiclePoolIndex;

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsInStateMantling, MortarTargetIndex, MortarHitLocation;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerThrowATAmmo, ServerLoadATAmmo, ServerThrowMortarAmmo, ServerSaveMortarTarget, ServerCancelMortarTarget,
        ServerLeaveBody, ServerChangeSpawn, ServerClearObstacle, ServerDebugObstacles, ServerDoLog, ServerAttemptDeployPlayer;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientProne, ClientToggleDuck, ClientConsoleCommand, ClientHandleDeath;
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
    DesiredSpawnPoint = none;
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

    // If we haven't picked a team, role and weapons yet, open the team pick menu
    if (!bWeaponsSelected)
    {
        ClientReplaceMenu("DH_Interface.DHGUITeamSelection");
    }
    else
    {
        ClientReplaceMenu("DH_Interface.DHDeployMenu");
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
        ViewShake(deltaTime);

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
            CameraSwivel.Yaw += 16.0 * DeltaTime * aTurn;
            CameraSwivel.Pitch += 16.0 * DeltaTime * aLookUp;
        }
        else
        {
            CameraDeltaRotation.Yaw += 32.0 * DeltaTime * aTurn;
            CameraDeltaRotation.Pitch += 32.0 * DeltaTime * aLookUp;
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
            else if (ROPwn != none && ROPwn.bRestingWeapon)
            {
                ViewRotation.Yaw += 16.0 * DeltaTime * aTurn;
                ViewRotation.Pitch += 16.0 * DeltaTime * aLookUp;
            }
            else
            {
                ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
                ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
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

        ViewShake(deltaTime);
        ViewFlash(deltaTime);

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
        for (i = 0; i < ArrayCount(GRI.AlliedRadios); ++i)
        {
            if (GRI.AlliedRadios[i] != none)
            {
                bFoundARadio = true;
                break;
            }
        }

        if (!bFoundARadio)
        {
            for (i = 0; i < ArrayCount(GRI.CarriedAlliedRadios); ++i)
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
        for (i = 0; i < ArrayCount(GRI.AxisRadios); ++i)
        {
            if (GRI.AxisRadios[i] != none)
            {
                bFoundARadio = true;
                break;
            }
        }

        if (!bFoundARadio)
        {
            for (i = 0; i < ArrayCount(GRI.CarriedAxisRadios); ++i)
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
        for (i = 0; i < ArrayCount(GRI.GermanMortarTargets); i++)
        {
            if (GRI.GermanMortarTargets[i].Controller == self && GRI.GermanMortarTargets[i].Time != 0.0 && Level.TimeSeconds - GRI.GermanMortarTargets[i].Time < 15.0)
            {
                // You cannot mark another mortar target yet
                ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 4);

                return;
            }
        }

        // Go through the roles and find a mortar operator role that has someone on it
        for (i = 0; i < ArrayCount(GRI.DHAxisRoles); i++)
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
        for (i = 0; i < ArrayCount(GRI.AlliedMortarTargets); i++)
        {
            if (GRI.AlliedMortarTargets[i].Controller == self && GRI.AlliedMortarTargets[i].Time != 0.0 && Level.TimeSeconds - GRI.AlliedMortarTargets[i].Time < 15.0)
            {
                ReceiveLocalizedMessage(class'DH_MortarTargetMessage', 4);

                return;
            }
        }

        for (i = 0; i < ArrayCount(GRI.DHAlliesRoles); i++)
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
        for (i = 0; i < ArrayCount(GRI.GermanMortarTargets); i++)
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
        for (i = 0; i < ArrayCount(GRI.AlliedMortarTargets); i++)
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
                    GroundPitch = FindStairRotation(deltaTime);
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
                    // Below is the only line this function changes. Theel: Reverted back as there is major bug where you can get under terrain
                    // Once we figure out how to fix that bug, this should be commented out again.
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
        FOVAngle -= (10.0 * DeltaTime * (FOVAngle - DesiredFOV)); //TODO: arbitrary number

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

// Modified to avoid "accessed none" errors
function bool HasSelectedTeam()
{
    return PlayerReplicationInfo != none && PlayerReplicationInfo.Team != none && PlayerReplicationInfo.Team.TeamIndex < 2;
}

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
            bBehindView = !bBehindView;
            ClientSetBehindView(bBehindView);
        }
    }
}

// Matt: DH version
// This would be incredibly useful but for some reason the debug spheres are not being drawn & I can't work out why ! Gets as far as calling DrawDebugSphere in Hud's DrawVehiclePointSphere
simulated exec function DriverCollisionDebug()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && ROHud(myHUD) != none)
    {
        ROHud(myHUD).bDebugDriverCollision = !ROHud(myHUD).bDebugDriverCollision;
        Log("bDebugDriverCollision =" @ ROHud(myHUD).bDebugDriverCollision);
    }
}

// Matt: DH version
simulated exec function PlayerCollisionDebug()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && ROHud(myHUD) != none)
    {
        ROHud(myHUD).bDebugPlayerCollision = !ROHud(myHUD).bDebugPlayerCollision;
        Log("bDebugPlayerCollision =" @ ROHud(myHUD).bDebugPlayerCollision);
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

    Level.Game.Broadcast(self, "DebugTreadVelocityScale=" $ TreadVelocityScale);
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

    Level.Game.Broadcast(self, "DebugWheelRotationScale=" $ WheelRotationScale);
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

function ServerChangeSpawn(int SpawnPointIndex, int VehiclePoolIndex)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G == none || G.SpawnManager == none)
    {
        return;
    }

    if (SpawnPointIndex != -1 && (SpawnPointIndex < 0 || SpawnPointIndex >= G.SpawnManager.GetSpawnPointCount()))
    {
        Error("Invalid spawn point index");
        self.SpawnPointIndex = -1; // reset spawn point index to null
    }

    if (VehiclePoolIndex != -1 && (VehiclePoolIndex < 0 || VehiclePoolIndex >= G.SpawnManager.GetVehiclePoolCount()))
    {
        Error("Invalid vehicle pool index");
        self.VehiclePoolIndex = -1; // reset vehicle pool index to null
    }

    self.SpawnPointIndex = SpawnPointIndex;
    self.VehiclePoolIndex = VehiclePoolIndex;
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

//Theel: Keep this function as it's used as a control to show communication page allowing fast muting of players
exec function CommunicationMenu()
{
    ClientReplaceMenu("ROInterface.ROCommunicationPage");
}

exec function DebugFOV()
{
    Level.Game.Broadcast(self, "FOV:" @ FovAngle);
}

function bool ServerAttemptDeployPlayer(optional DHSpawnPoint SP, optional byte MagCount)
{
    local rotator newRot, oldRot;
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo DHGRI;
    local DH_RoleInfo RI;
    local class<Inventory> PrimaryWep;
    local float mag;
    local vector oldDir;
    local Controller P;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
    DHGRI = DHGameReplicationInfo(GameReplicationInfo);

    if (PRI != none)
    {
        RI = DH_RoleInfo(PRI.RoleInfo);
    }
    if (RI != none)
    {
        PrimaryWep = RI.PrimaryWeapons[PrimaryWeapon].Item;
    }

    //Warn("=================== SERVER SIDE ATTEMPTING TO DEPLOY PLAYER ===================");

    if (PRI == none || DHGRI == none || Pawn != none)
    {
        Log("Failed at 0");
        return false;
    }

    // Confirm this player has a role && check if MagCount is valid based on role/weapon
    if (PRI.RoleInfo != none && PrimaryWep != none)
    {
        if (MagCount > class<DH_ProjectileWeapon>(PrimaryWep).default.MaxNumPrimaryMags || MagCount <= 0)
        {
            Log("Failed at 1");
            return false;
        }
    }
    else
    {
        Log("Failed at 2");
        return false;
    }

    // Check if player is ready to deploy
    if (LastKilledTime + RedeployTime - Level.TimeSeconds > 0) //Theel: May not be able to use Level.TimeSeconds anymore atleast for server check!
    {
        Log("Failed at 4");
        return false;
    }
    else
    {
        //Log("Server Says:" @ string(LastKilledTime + RedeployTime - Level.TimeSeconds) @ "left to spawn");
    }

    // Check if SP is valid
    if (!DHGRI.ValidateSpawnPoint(SP,PRI.Team.TeamIndex))
    {
        //Temp hack to allow spawning on all maps
        Level.Game.RestartPlayer(self);
    }
    else
    {
        SpawnPointIndex = DHGRI.GetSpawnPointIndex(SP);
        DarkestHourGame(Level.Game).DHRestartPlayer(self);
    }

    // Lets assume it worked and now lets tell the client the redeploy time
    RedeployTime = CalculateDeployTime(MagCount);

    // Set primary weapon ammo
    if (Pawn != none && MagCount != 0)
    {
        DH_Pawn(Pawn).SetAmmoPercent(MagCount);
    }
}

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

    if (RI != none && WeaponIndex == -1)
    {
        PrimaryWep = RI.PrimaryWeapons[PrimaryWeapon].Item;
    }
    else if (RI != none && RI.PrimaryWeapons[WeaponIndex].Item != none)
    {
        PrimaryWep = RI.PrimaryWeapons[WeaponIndex].Item;
    }

    // Make sure everything is set and no access nones
    if (PRI == none || RI == none || GRI == none || PrimaryWep == none)
    {
        Warn("Error in Calculating deploy time");
        return 0;
    }

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
    if ( P != Pawn )
        return;

    LastKilledTime = Level.TimeSeconds; // We don't pass a time, because we want client to set the time not the server!
    ClientHandleDeath(); //Tells client to set his last killed time, that he can't spawn yet, and to autodeploy if has desired spawn

    super.PawnDied(P); //Calls super in ROPlayer
}

simulated function ClientHandleDeath()
{
    if (DesiredSpawnPoint != none)
    {
        bShouldAttemptAutoDeploy = true;
    }
    LastKilledTime = Level.TimeSeconds; // We don't pass a time, because we want client to set the time not the server!
}

// THEEL this function is no longer being used, do something with it!
//Function should only be run on client and renamed proper
//This function is used to check if the client thinks it's ready to deploy or not
function CheckIfReadyToDeploy()
{
    local bool bDeployed;
    //bShould should prob be checked in hud, instead of constantly call this function
    // Don't try to auto deploy lots of times, if we aren't ready, or have a menu open
    if (!bShouldAttemptAutoDeploy || GUIController(Player.GUIController).ActivePage != none)
    {
        bShouldAttemptAutoDeploy = false;
        return;
    }
    bShouldAttemptAutoDeploy = false; //Theel: Do we need this?

    //If we have a desired spawn point set, we won't need to open menu and can send spawn request from here
    if (DesiredSpawnPoint != none && Pawn == none)
    {
        //Check if desired spawn is valid
        bDeployed = DHGameReplicationInfo(GameReplicationInfo).ValidateSpawnPoint(DesiredSpawnPoint, PlayerReplicationInfo.Team.TeamIndex);
        if (bDeployed)
        {
            ServerAttemptDeployPlayer(DesiredSpawnPoint, DesiredAmmoAmount);
        }
        else
        {
            //It wasn't valid so lets do nothing?  Theel: should we set desiredspawntpoint to none?  I think so
        }
    }
    //Open deploy menu if no menu is currently open and player failed to deploy
    if (!bDeployed && GUIController(Player.GUIController).ActivePage == none)
    {
        ClientReplaceMenu("DH_Interface.DHDeployMenu");
    }
}

//Temp function Theel will be using to get offset coordinates from nearby vehicle to create/adjust vehicle exit positions
exec function ExitPosTool()
{
    local ROVehicle NearbyVeh;
    local vector Offset;

    foreach RadiusActors(class'ROVehicle', NearbyVeh, 300.0, Pawn.Location)
    {
        Offset = (Pawn.Location - NearbyVeh.Location) << NearbyVeh.Rotation;

        Log("(X=" $ Round(Offset.X) $ ",Y=" $ Round(Offset.Y) $ ",Z=" $ Round(Offset.Z) $ ")");
    }
}

defaultproperties
{
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
    SpawnPointIndex=-1
    VehiclePoolIndex=-1
}
