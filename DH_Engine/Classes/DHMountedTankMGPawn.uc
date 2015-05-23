//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMountedTankMGPawn extends ROMountedTankMGPawn
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx

// General
var     DHMountedTankMG  MGun;                   // just a reference to the DH MG actor, for convenience & to avoid lots of casts
var     texture     VehicleMGReloadTexture;      // used to show reload progress on the HUD, like a tank cannon reload
var     name        GunsightCameraBone;          // optional separate camera bone for the MG gunsights
var     name        FirstPersonGunRefBone;       // static gun bone used as reference point to adjust 1st person view HUDOverlay offset, if gunner can raise his head above sights
var     float       FirstPersonOffsetZScale;     // used with HUDOverlay to scale how much lower the 1st person gun appears when player raises his head above it
var     bool        bHideMuzzleFlashAboveSights; // workaround (hack really) to turn off muzzle flash in 1st person when player raises head above sights, as it sometimes looks wrong

// Position stuff
var     int         InitialPositionIndex;        // initial player position on entering
var     int         UnbuttonedPositionIndex;     // lowest position number where player is unbuttoned
var     float       ViewTransitionDuration;      // used to control the time we stay in state ViewTransition
var     bool        bPlayerCollisionBoxMoves;    // player's collision box moves with animations (e.g. raised/lowered on unbuttoning/buttoning), so we need to play anims on server

// Gunsight
var     float       OverlayCenterSize;           // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var     float       OverlayCenterTexStart;
var     float       OverlayCenterTexSize;
var     float       OverlayCorrectionX;
var     float       OverlayCorrectionY;

// Debugging help
var     bool        bDebugExitPositions;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleDebugExits; // only during development
}

// Matt: modified to call InitializeMG when we've received both the replicated Gun & VehicleBase actors (just after vehicle spawns via replication), which has 2 benefits:
// 1. Do things that need one or both of those actor refs, controlling common problem of unpredictability of timing of receiving replicated actor references
// 2. To do any extra set up in the MG classes, which can easily be subclassed for anything that is vehicle specific
simulated function PostNetReceive()
{
    local int i;

    // Player has changed position
    if (DriverPositionIndex != SavedPositionIndex && Gun != none && bMultiPosition)
    {
        if (Driver == none && DriverPositionIndex > 0 && !IsLocallyControlled() && Level.NetMode == NM_Client)
        {
            // do nothing
        }
        else
        {
            LastPositionIndex = SavedPositionIndex;
            SavedPositionIndex = DriverPositionIndex;
            NextViewPoint();
        }
    }

    // Initialize the MG (added VehicleBase != none, so we guarantee that VB is available to InitializeMG)
    if (!bInitializedVehicleGun && Gun != none && VehicleBase != none)
    {
        bInitializedVehicleGun = true;
        InitializeMG();
    }

    // Initialize the vehicle base
    if (!bInitializedVehicleBase && VehicleBase != none)
    {
        bInitializedVehicleBase = true;

        // On client, this actor is destroyed if becomes net irrelevant - when it respawns, empty WeaponPawns array needs filling again or will cause lots of errors
        if (VehicleBase.WeaponPawns.Length > 0 && VehicleBase.WeaponPawns.Length > PositionInArray &&
            (VehicleBase.WeaponPawns[PositionInArray] == none || VehicleBase.WeaponPawns[PositionInArray].default.Class == none))
        {
            VehicleBase.WeaponPawns[PositionInArray] = self;

            return;
        }

        for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
        {
            if (VehicleBase.WeaponPawns[i] != none && (VehicleBase.WeaponPawns[i] == self || VehicleBase.WeaponPawns[i].Class == class))
            {
                return;
            }
        }

        VehicleBase.WeaponPawns[PositionInArray] = self;
    }

    // Matt: if this is a single position MG & we've initialized the vehicle weapon & vehicle base, we can now switch off PostNetReceive
    if (!bMultiPosition && bInitializedVehicleGun && bInitializedVehicleBase)
    {
        bNetNotify = false;
    }
}

// Modified to call InitializeMG to do any extra set up in the MG classes
// This is where we do it for standalones or servers (note we can't do it in PostNetBeginPlay because VehicleBase isn't set until this function is called)
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    super.AttachToVehicle(VehiclePawn, WeaponBone);

    if (Role == ROLE_Authority)
    {
        InitializeMG();
    }
}

// Matt: new function to do any extra set up in the MG classes (called from PostNetReceive on net client or from AttachToVehicle on standalone or server)
// Crucially, we know that we have VehicleBase & Gun when this function gets called, so we can reliably do stuff that needs those actors
simulated function InitializeMG()
{
    MGun = DHMountedTankMG(Gun);

    if (MGun != none)
    {
        MGun.InitializeMG(self);
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owned DHMountedTankMG, so lots of things are not going to work!");
    }
}

// Modified to calculate & set texture MGOverlay variables once instead of every DrawHUD
simulated function PostBeginPlay()
{
    local float OverlayCenterScale;

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer && MGOverlay != none)
    {
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1.0 - OverlayCenterScale) * Float(MGOverlay.USize) / 2.0;
        OverlayCenterTexSize =  Float(MGOverlay.USize) * OverlayCenterScale;
    }
}

// Modified to remove obsolete stuff & duplication from the Supers, & to use the vehicle's VehicleTeam to determine the team
function bool TryToDrive(Pawn P)
{
    if (VehicleBase != none && P != none)
    {
        // Trying to enter a vehicle that isn't on our team
        if (P.GetTeamNum() != VehicleBase.VehicleTeam) // VehicleTeam reliably gives the team, even if vehicle hasn't yet been entered
        {
            if (VehicleBase.Driver == none)
            {
                return VehicleBase.TryToDrive(P);
            }

            DenyEntry(P, 1); // can't use enemy vehicle

            return false;
        }

        // Bot tries to enter the VehicleBase if it has no driver
        if (VehicleBase.Driver == none && !P.IsHumanControlled())
        {
            return VehicleBase.TryToDrive(P);
        }
    }

    return super(Vehicle).TryToDrive(P); // the Supers in ROVehicleWeaponPawn & VehicleWeaponPawn contain lots of duplication
}

// Modified so that if MG is reloading when player enters, we update the reload start time, or if MG is out of ammo, we try to start a reload
// Also to use InitialPositionIndex instead of assuming start in position zero
function KDriverEnter(Pawn P)
{
    local float PercentageOfReloadDone;

    DriverPositionIndex = InitialPositionIndex;
    LastPositionIndex = InitialPositionIndex;

    super(VehicleWeaponPawn).KDriverEnter(P); // skip over Super in ROMountedTankMGPawn as it sets rotation we now want to avoid

    if (MGun != none)
    {
        // If MG is reloading, we pass the reload start time (indirectly), so client can calculate reload progress to display on HUD
        if (MGun.bReloading)
        {
            PercentageOfReloadDone = Byte(100.0 * (Level.TimeSeconds - MGun.ReloadStartTime) / MGun.ReloadDuration);
            MGun.ClientHandleReload(PercentageOfReloadDone);
        }
        // If MG is out of ammo, try to start a reload
        else if (!MGun.HasAmmo(0))
        {
            MGun.HandleReload();
        }
    }
}

// Modified to use InitialPositionIndex instead of assuming start in position zero, & to match rotation to MG's aim, & to consolidate & optimise the Supers)
simulated function ClientKDriverEnter(PlayerController PC)
{
    if (bMultiPosition)
    {
        Gotostate('EnteringVehicle');
        SavedPositionIndex = InitialPositionIndex;
        PendingPositionIndex = InitialPositionIndex;
    }
    else if (PC != none)
    {
        PC.SetFOV(WeaponFOV); // not needed if bMultiPosition, as gets set in EnteringVehicle
    }

    // Matt: appears to do nothing as not used anywhere in Unrealscript, but must be used by native code as if removed we get unwanted camera swivelling effect on entering
    // Also in HandleTransition(), but I can't see it's having an effect there
    StoredVehicleRotation = VehicleBase.Rotation;

    super(Vehicle).ClientKDriverEnter(PC);

    MatchRotationToGunAim(PC);
}

// Modified so MG retains its aimed direction when player enters & may switch to internal mesh, & to handle InitialPositionIndex instead of assuming start in position zero
simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
        SwitchMesh(InitialPositionIndex);

        if (Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
        {
            Gun.PlayAnim(Gun.BeginningIdleAnim); // shouldn't actually be necessary, but a reasonable fail-safe
        }

        FPCamPos = DriverPositions[InitialPositionIndex].ViewLocation;
        WeaponFOV = DriverPositions[InitialPositionIndex].ViewFOV;

        if (IsHumanControlled())
        {
            PlayerController(Controller).SetFOV(WeaponFOV);
        }
    }
}

// Modified to prevent exit if not unbuttoned & to give player the same momentum as the vehicle when exiting
// Also to remove overlap with DriverDied(), moving common features into DriverLeft(), which gets called by both functions
function bool KDriverLeave(bool bForceLeave)
{
    local vector ExitVelocity;

    if (!bForceLeave)
    {
        if (!CanExit()) // bForceLeave means so player is trying to exit not just switch position, so no risk of locking someone in one slot
        {
            return false;
        }

        ExitVelocity = Velocity;
        ExitVelocity.Z += 60.0; // add a little height kick to allow for hacked in damage system
    }

    if (super(VehicleWeaponPawn).KDriverLeave(bForceLeave))
    {
        if (!bForceLeave)
        {
            Instigator.Velocity = ExitVelocity;
        }

        return true;
    }

    return false;
}

// Modified so MG retains its aimed direction when player exits & may switch back to external mesh
// Also to remove playing BeginningIdleAnim as now that's played on all net modes in DrivingStatusChanged()
simulated state LeavingVehicle
{
    simulated function HandleExit()
    {
        SwitchMesh(-1); // -1 signifies switch to default external mesh
    }
}

// Modified to remove overlap with KDriverLeave(), moving common features into DriverLeft(), which gets called by both functions
function DriverDied()
{
    super(Vehicle).DriverDied();

    if (VehicleBase != none && VehicleBase.Health > 0)
    {
        SetRotatingStatus(0); // kill the rotation sound if the driver dies but the vehicle doesn't
    }

    DriverLeft(); // fix Unreal bug (as done in ROVehicle), as DriverDied should call DriverLeft, the same as KDriverLeave does
}

// Modified to add common features from KDriverLeave() & DriverDied(), which both call this function, & to reset to InitialPositionIndex instead of zero
function DriverLeft()
{
    if (bMultiPosition)
    {
        DriverPositionIndex = InitialPositionIndex;
        LastPositionIndex = InitialPositionIndex;
    }

    VehicleBase.MaybeDestroyVehicle(); // set spiked vehicle timer if it's an empty, disabled vehicle

    DrivingStatusChanged(); // the Super from Vehicle
}

// Modified to play idle animation for all net players, so they see closed hatches & any animated collision boxes are re-set (also server if collision is animated)
simulated event DrivingStatusChanged()
{
    super.DrivingStatusChanged();

    if (!bDriving && (Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves) && Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
    {
        Gun.PlayAnim(Gun.BeginningIdleAnim);
    }
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
function bool PlaceExitingDriver()
{
    local int    i, StartIndex;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    if (VehicleBase == none)
    {
        return false;
    }

    // Debug exits - uses DHMountedTankMGPawn class default, allowing bDebugExitPositions to be toggled for all MG pawns
    if (class'DHMountedTankMGPawn'.default.bDebugExitPositions)
    {
        for (i = 0; i < VehicleBase.ExitPositions.Length; ++i)
        {
            ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

            Spawn(class'DHDebugTracer',,, ExitPosition);
        }
    }

    i = Clamp(PositionInArray + 1, 0, VehicleBase.ExitPositions.Length - 1);
    StartIndex = i;

    while (i >= 0 && i < VehicleBase.ExitPositions.Length)
    {
        ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, VehicleBase.Location + ZOffset, false, Extent) == none &&
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) == none &&
            Driver.SetLocation(ExitPosition))
        {
            return true;
        }

        ++i;

        if (i == StartIndex)
        {
            break;
        }
        else if (i == VehicleBase.ExitPositions.Length)
        {
            i = 0;
        }
    }

    return false;
}

// Modified to update custom aim for MGs that use it, but only if the player is actually controlling the MG, i.e. CanFire()
// Also to add in the ironsights turn speed factor if the player is controlling the MG
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local float   TurnSpeedFactor;
    local rotator NewRotation;

    if (CanFire() && DHPlayer(Controller) != none)
    {
        TurnSpeedFactor = DHPlayer(Controller).DHISTurnSpeedFactor;
        YawChange *= TurnSpeedFactor;
        PitchChange *= TurnSpeedFactor;
    }

    NewRotation = Rotation;
    NewRotation.Yaw += 32.0 * DeltaTime * YawChange;
    NewRotation.Pitch += 32.0 * DeltaTime * PitchChange;
    NewRotation.Pitch = LimitPitch(NewRotation.Pitch);

    SetRotation(NewRotation);

    if (bCustomAiming && CanFire())
    {
        UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);

        if (IsHumanControlled())
        {
            PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
            PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
        }
    }
}

// Modified to optimise & make into generic function to handle all MG types
simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector           CameraLocation, GunOffset, x, y, z;
    local rotator          CameraRotation;
    local Actor            ViewActor;
    local float            SavedOpacity, ScreenRatio;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (!bMultiPosition || (DriverPositions[DriverPositionIndex].bDrawOverlays && (!IsInState('ViewTransition') || DriverPositions[LastPositionIndex].bDrawOverlays)))
        {
            // Draw any HUD overlay
            if (HUDOverlay != none)
            {
                if (!Level.IsSoftwareRendering())
                {
                    CameraRotation = PC.Rotation;
                    SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
                    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);

                    // Make the first person gun appear lower when your sticking your head up
                    if (FirstPersonGunRefBone != '')
                    {
                        GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;
                        GunOffset.Z += (((Gun.GetBoneCoords(FirstPersonGunRefBone).Origin.Z - CameraLocation.Z) * FirstPersonOffsetZScale));
                        GunOffset += HUDOverlayOffset;
                        HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                        Canvas.DrawBoundActor(HUDOverlay, false, true, HUDOverlayFOV, CameraRotation, PC.ShakeRot * FirstPersonGunShakeScale, GunOffset * -1.0);
                    }
                    else
                    {
                        CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
                        HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                        HUDOverlay.SetRotation(CameraRotation);
                        Canvas.DrawActor(HUDOverlay, false, true, HUDOverlayFOV);
                    }
                }
            }
            // Draw gunsight overlay
            else if (MGOverlay != none)
            {
                // Save current HUD opacity & then set up for drawing overlays
                SavedOpacity = Canvas.ColorModulate.W;
                Canvas.ColorModulate.W = 1.0;
                Canvas.DrawColor.A = 255;
                Canvas.Style = ERenderStyle.STY_Alpha;

                ScreenRatio = Float(Canvas.SizeY) / Float(Canvas.SizeX);
                Canvas.SetPos(0.0, 0.0);

                Canvas.DrawTile(MGOverlay, Canvas.SizeX, Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX,
                    OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0, OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

                Canvas.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
        }
    }
    else if (HUDOverlay != none)
    {
        ActivateOverlay(false);
    }
}

// Modified to make into a generic function, avoiding need for overrides in subclasses
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local name    WeaponCameraBone;
    local vector  CamViewOffsetWorld, VehicleZ, x, y, z;
    local float   CamViewOffsetZAmount;
    local rotator WeaponAimRot;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    // If this MG uses custom aiming & the player is on the gun, we'll select the relevant camera bone
    if (bCustomAiming && CanFire() && Gun != none)
    {
        if (GunsightCameraBone != '')
        {
            WeaponCameraBone = GunsightCameraBone;
        }
        else if (CameraBone != '')
        {
            WeaponCameraBone = CameraBone;
        }
    }

    // If we've identified a suitable camera bone, we now use that to set our camera rotation & location
    if (WeaponCameraBone != '')
    {
        WeaponAimRot = Gun.GetBoneRotation(WeaponCameraBone);
        PC.WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        PC.WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;

        CameraRotation = WeaponAimRot;
        CameraLocation = Gun.GetBoneCoords(WeaponCameraBone).Origin;
    }
    // Otherwise we'll use the PC's rotation for our camera rotation
    else
    {
        // If PC's rotation is relative to the vehicle, we need to factor in the vehicle's rotation
        // Matt: don't need the fancy quat stuff; this 1 line handles it (think quats are needed to combine 2 rotators without losing roll, but these rotators don't have roll anyway)
        if (bPCRelativeFPRotation && VehicleBase != none)
        {
            CameraRotation = rotator(vector(PC.Rotation) >> Gun.Rotation);
        }
        // Or if PC isn't relative to the vehicle, we can simply use the unadjusted PC rotation
        else
        {
            CameraRotation = PC.Rotation;
        }

        // Set our camera location using the camera bone if we have one
        if (CameraBone != '' && Gun != none)
        {
            CameraLocation = Gun.GetBoneCoords(CameraBone).Origin;
        }
        // Or a fallback in case we don't have a camera bone or VehicleWeapon
        else
        {
            CameraLocation = GetCameraLocationStart();
        }
    }

    // Adjust camera location for any offset positioning
    CamViewOffsetWorld = (FPCamViewOffset + FPCamPos) >> CameraRotation;
    CameraLocation = CameraLocation + CamViewOffsetWorld;

    // Remove any vehicle-space Z due to FPCamViewOffset (so looking up and down doesn't change camera Z relative to vehicle) // Matt: doubt this is doing anything for us
    if (bFPNoZFromCameraPitch)
    {
        VehicleZ = vect(0.0, 0.0, 1.0) >> CameraRotation;
        CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
        CameraLocation -= CamViewOffsetZAmount * VehicleZ;
    }

    // Finalise the camera with any shake
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}
// New function, checked by Fire() to see if we are in an eligible firing position (subclass as required)
function bool CanFire()
{
    return true;
}

// Modified to prevent fire based on CanFire() & to add dry-fire effects if trying to fire empty MG
function Fire(optional float F)
{
    if (!CanFire() || Gun == none)
    {
        return;
    }

    if (Gun.ReadyToFire(false))
    {
        VehicleFire(false);
        bWeaponIsFiring = true;

        if (IsHumanControlled())
        {
            Gun.ClientStartFire(Controller, false);
        }
    }
    else if (MGun != none && !MGun.bReloading)
    {
        Gun.ShakeView(false);
        PlaySound(MGun.NoAmmoSound, SLOT_None, 1.5,, 25.0,, true);
    }
}

// Emptied out as MG has no alt fire mode, so just ensures nothing happens
function AltFire(optional float F)
{
}

// Modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
simulated function NextWeapon()
{
    if (DriverPositionIndex < DriverPositions.Length - 1 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex + 1;
        ServerChangeViewPoint(true);
    }
}

simulated function PrevWeapon()
{
    if (DriverPositionIndex > 0 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex -1;
        ServerChangeViewPoint(false);
    }
}

// Modified so server goes to state ViewTransition when unbuttoning, preventing player exiting until fully unbuttoned
// Also so that server plays animations if player has moving collision box
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (Level.NetMode == NM_DedicatedServer)
            {
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                {
                    GotoState('ViewTransition');
                }
                else if (bPlayerCollisionBoxMoves)
                {
                    AnimateTransition();
                }
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (bPlayerCollisionBoxMoves && Level.NetMode == NM_DedicatedServer) // only if player has moving collision box
            {
                AnimateTransition();
            }
        }
    }
}

// Modified to use Sleep to control exit from state (including on server), to avoid unnecessary stuff on a server, & to improve timing of FOV & camera position changes
// Also to add generic support for workaround (hack really) to turn off muzzle flash in 1st person when player raises head above sights, as it sometimes looks wrong
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            StoredVehicleRotation = VehicleBase.Rotation;

            // Switch to mesh for new position as may be different
            SwitchMesh(DriverPositionIndex);

            // If the option is flagged, turn off muzzle flash if player has raised head above sights
            if (bHideMuzzleFlashAboveSights && DriverPositionIndex > 0)
            {
                Gun.AmbientEffectEmitter.bHidden = true;
            }

            // Set any zoom & camera offset for new position - but only if moving to less zoomed position, otherwise we wait until end of transition to do it
            if (IsHumanControlled())
            {
                WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

                if (WeaponFOV > DriverPositions[LastPositionIndex].ViewFOV)
                {
                    PlayerController(Controller).SetFOV(WeaponFOV);
                    FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
                }
            }

            // Play any transition animation for the player
            if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }

        ViewTransitionDuration = 0.0; // start with zero in case we don't have a transition animation

        // Play any transition animation for the MG itself
        // On dedicated server we only want to run this section, to set Sleep duration to control leaving state (or play button/unbutton anims if player's collision box moves)
        if (LastPositionIndex < DriverPositionIndex)
        {
            if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
            {
                if (Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves)
                {
                    Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                }

                ViewTransitionDuration = Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim);
            }
        }
        else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
        {
            if (Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves)
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
            }

            ViewTransitionDuration = Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionDownAnim);
        }
    }

    // Emptied out so that Sleep is the sole timing for exiting this state
    simulated function AnimEnd(int channel)
    {
    }

    // Reverted to global Timer as Sleep is now the sole means of exiting this state
    simulated function Timer()
    {
        global.Timer();
    }

    simulated function EndState()
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            // Set any zoom & camera offset for new position, if moved to a more (or equal) zoomed position (if not, we've already done this at start of transition)
            if (WeaponFOV <= DriverPositions[LastPositionIndex].ViewFOV && IsHumanControlled())
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }

            // Re-enable muzzle flash if it has previously been turned off when player raised head above sights
            if (bHideMuzzleFlashAboveSights && DriverPositionIndex == 0 && Gun != none && 
                (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer))
            {
                Gun.AmbientEffectEmitter.bHidden = false;
            }
        }
    }

Begin:
    HandleTransition();
    Sleep(ViewTransitionDuration);
    GotoState('');
}

// Modified to avoid playing unnecessary DriverTransitionAnim on dedicated server, as this function may be called on server to move player's collision box
simulated function AnimateTransition()
{
    if (Level.NetMode != NM_DedicatedServer && Driver != none &&
        Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
    {
        Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
    }

    if (LastPositionIndex < DriverPositionIndex)
    {
        if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
        {
            Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
        }
    }
    else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
    {
        Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
    }
}

// Modified to add clientside checks before sending the function call to the server
simulated function SwitchWeapon(byte F)
{
    local ROVehicleWeaponPawn WeaponPawn;
    local bool                bMustBeTankerToSwitch;
    local byte                ChosenWeaponPawnIndex;

    if (VehicleBase == none)
    {
        return;
    }

    // Trying to switch to driver position
    if (F == 1)
    {
        // Stop call to server as there is already a human driver
        if (VehicleBase.Driver != none && VehicleBase.Driver.IsHumanControlled())
        {
            return;
        }

        if (VehicleBase.bMustBeTankCommander)
        {
            bMustBeTankerToSwitch = true;
        }
    }
    // Trying to switch to non-driver position
    else
    {
        ChosenWeaponPawnIndex = F - 2;

        // Stop call to server if player has selected an invalid weapon position or the current position
        // Note that if player presses 0, which is invalid choice, the byte index will end up as 254 & so will still fail this test (which is what we want)
        if (ChosenWeaponPawnIndex >= VehicleBase.PassengerWeapons.Length || ChosenWeaponPawnIndex == PositionInArray)
        {
            return;
        }

        // Stop call to server if player selected a rider position but is buttoned up (no 'teleporting' outside to external rider position)
        if (StopExitToRiderPosition(ChosenWeaponPawnIndex))
        {
            return;
        }

        // Get weapon pawn
        if (ChosenWeaponPawnIndex < VehicleBase.WeaponPawns.Length)
        {
            WeaponPawn = ROVehicleWeaponPawn(VehicleBase.WeaponPawns[ChosenWeaponPawnIndex]);
        }

        if (WeaponPawn != none)
        {
            // Stop call to server as weapon position already has a human player
            if (WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
            {
                return;
            }

            if (WeaponPawn.bMustBeTankCrew)
            {
                bMustBeTankerToSwitch = true;
            }
        }
        // Stop call to server if weapon pawn doesn't exist, UNLESS PassengerWeapons array lists it as a rider position
        // This is because our new system means rider pawns won't exist on clients unless occupied, so we have to allow this switch through to server
        else if (class<ROPassengerPawn>(VehicleBase.PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass) == none)
        {
            return;
        }
    }

    // Stop call to server if player has selected a tank crew role but isn't a tanker
    if (bMustBeTankerToSwitch && (Controller == none || ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) == none ||
        ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        DenyEntry(self, 0); // not qualified to operate vehicle

        return;
    }

    ServerChangeDriverPosition(F);
}

// Modified to prevent 'teleporting' outside to external rider position while buttoned up inside vehicle
function ServerChangeDriverPosition(byte F)
{
    if (StopExitToRiderPosition(F - 2))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// New function to check if player can exit, displaying an "unbutton hatch" message if he can't (just saves repeating code in different functions)
simulated function bool CanExit()
{
    if (DriverPositionIndex < UnbuttonedPositionIndex || (IsInState('ViewTransition') && DriverPositionIndex == UnbuttonedPositionIndex))
    {
        if (DriverPositions.Length > UnbuttonedPositionIndex) // means it is possible to unbutton
        {
            ReceiveLocalizedMessage(class'DHVehicleMessage', 4); // must unbutton the hatch
        }
        else
        {
            if (DHTreadCraft(VehicleBase) != none && DHTreadCraft(VehicleBase).DriverPositions.Length > DHTreadCraft(VehicleBase).UnbuttonedPositionIndex) // means driver has hatch
            {
                ReceiveLocalizedMessage(class'DHVehicleMessage', 10); // must exit through driver's or commander's hatch
            }
            else
            {
                ReceiveLocalizedMessage(class'DHVehicleMessage', 5); // must exit through commander's hatch
            }
        }

        return false;
    }

    return true;
}

// New function to check if player is trying to 'teleport' outside to external rider position while buttoned up (just saves repeating code in different functions)
simulated function bool StopExitToRiderPosition(byte ChosenWeaponPawnIndex)
{
    local DHTreadCraft TreadCraft;

    TreadCraft = DHTreadCraft(VehicleBase);

    return TreadCraft != none && TreadCraft.bMustUnbuttonToSwitchToRider && TreadCraft.bAllowRiders &&
        ChosenWeaponPawnIndex >= TreadCraft.FirstRiderPositionIndex && ChosenWeaponPawnIndex < TreadCraft.PassengerWeapons.Length && !CanExit();
}

// New function to handle switching between external & internal mesh, including copying MG's aimed direction to new mesh (just saves code repetition)
simulated function SwitchMesh(int PositionIndex)
{
    local mesh    NewMesh;
    local rotator MGYaw, MGPitch;

    if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && Gun != none)
    {
        // If switching to a valid driver position, get its PositionMesh
        if (PositionIndex >= 0 && PositionIndex < DriverPositions.Length)
        {
            if (DriverPositions[PositionIndex].PositionMesh != none)
            {
                NewMesh = DriverPositions[PositionIndex].PositionMesh;
            }
        }
        // Else switch to default external mesh (pass PositionIndex of -1 to signify this, as it's an invalid position)
        else
        {
            NewMesh = Gun.default.Mesh;
        }

        // Only switch mesh if we actually have a different new mesh
        if (NewMesh != Gun.Mesh && NewMesh != none)
        {
            // Switch to the new mesh
            Gun.LinkMesh(NewMesh);

            // Now make the new mesh you swap to have the same rotation as the old one
            if (VehicleBase != none)
            {
                // If one bone is used for both yaw & pitch, we just update all rotation for that one bone
                if (Gun.YawBone == Gun.PitchBone)
                {
                    Gun.SetBoneRotation(Gun.YawBone, Gun.CurrentAim * -1.0);
                }
                // Otherwise we have to update the yaw & pitch bones separately
                else
                {
                    MGYaw.Yaw = -Gun.CurrentAim.Yaw;
                    MGPitch.Pitch = -Gun.CurrentAim.Pitch;
                    Gun.SetBoneRotation(Gun.YawBone, MGYaw);
                    Gun.SetBoneRotation(Gun.PitchBone, MGPitch);
                }
            }
        }
    }
}

// New function to match rotation to MG's current aim, either relative or independent to vehicle rotation (note owning net client will update rotation back to server)
simulated function MatchRotationToGunAim(optional Controller C)
{
    if (Gun != none)
    {
        if (C == none)
        {
            C = Controller;
        }

        if (bPCRelativeFPRotation)
        {
            SetRotation(Gun.CurrentAim);
        }
        else
        {
            SetRotation(rotator(vector(Gun.CurrentAim) >> Gun.Rotation)); // note Gun.Rotation is effectively same as vehicle base's rotation
        }

        if (C != none)
        {
            C.SetRotation(Rotation);
        }
    }
}

// Modified so if PC's rotation was relative to vehicle (bPCRelativeFPRotation), it gets set to the correct non-relative rotation on exit
// Doing this in a more obvious way here avoids the previous workaround in ClientKDriverLeave, which matched the MG pawn's rotation to the vehicle
simulated function FixPCRotation(PlayerController PC)
{
    PC.SetRotation(rotator(vector(PC.Rotation) >> Gun.Rotation)); // was >> Rotation, i.e. MG pawn's rotation (note Gun.Rotation is effectively same as vehicle base's rotation)
}

// Modified to correct error in ROVehicleWeaponPawn, where PitchDownLimit was being used instead of DriverPositions[x].ViewPitchDownLimit in a multi position weapon
function int LocalLimitPitch(int pitch)
{
    pitch = pitch & 65535;

    if (bMultiPosition)
    {
        if (pitch > DriverPositions[DriverPositionIndex].ViewPitchUpLimit && pitch < DriverPositions[DriverPositionIndex].ViewPitchDownLimit)
        {
            if (pitch - DriverPositions[DriverPositionIndex].ViewPitchUpLimit < DriverPositions[DriverPositionIndex].ViewPitchDownLimit - pitch)
            {
                pitch = DriverPositions[DriverPositionIndex].ViewPitchUpLimit;
            }
            else
            {
                pitch = DriverPositions[DriverPositionIndex].ViewPitchDownLimit;
            }
        }
    }
    else
    {
        if (pitch > PitchUpLimit && pitch < PitchDownLimit)
        {
            if (pitch - PitchUpLimit < PitchDownLimit - pitch)
            {
                pitch = PitchUpLimit;
            }
            else
            {
                pitch = PitchDownLimit;
            }
        }
    }

    return pitch;
}

// Modified to use new ResupplyAmmo() in the VehicleWeapon classes, instead of GiveInitialAmmo()
function bool ResupplyAmmo()
{
    return MGun != none && MGun.ResupplyAmmo();
}

// New function, used by HUD to show coaxial MG reload progress, like the cannon reload
function float GetAmmoReloadState()
{
    local float ProportionOfReloadRemaining;

    if (MGun != none)
    {
        if (MGun.ReadyToFire(false))
        {
            return 0.0;
        }
        else if (MGun.bReloading)
        {
            ProportionOfReloadRemaining = 1.0 - ((Level.TimeSeconds - MGun.ReloadStartTime) / MGun.ReloadDuration);

            if (ProportionOfReloadRemaining >= 0.75)
            {
                return 1.0;
            }
            else if (ProportionOfReloadRemaining >= 0.5)
            {
                return 0.65;
            }
            else if (ProportionOfReloadRemaining >= 0.25)
            {
                return 0.45;
            }
            else
            {
                return 0.25;
            }
        }
        else
        {
            return 1.0; // must be totally out of ammo, so HUD will draw ammo icon all in red to indicate that MG can't be fired
        }
    }
}

// Modified to call same function on VehicleWeapon class so it pre-caches its Skins array (the RO class missed calling the Super to do that), & also to add an extra material property
static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(default.MGOverlay);
    L.AddPrecacheMaterial(default.VehicleMGReloadTexture);

    default.GunClass.static.StaticPrecache(L);
}

// Modified to add an extra material property
simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(default.MGOverlay);
    Level.AddPrecacheMaterial(default.VehicleMGReloadTexture);
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

// Matt: modified to switch to external mesh & default FOV for behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local int i;

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            // Switching to behind view, so make rotation non-relative to vehicle
            if (bPCRelativeFPRotation)
            {
                FixPCRotation(PC);
                SetRotation(PC.Rotation);
            }

            if (DriverPositions.Length > 0)
            {
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].PositionMesh = Gun.default.Mesh;
                    DriverPositions[i].ViewFOV = PC.DefaultFOV;
                    DriverPositions[i].ViewPositiveYawLimit = 65535;
                    DriverPositions[i].ViewNegativeYawLimit = -65535;
                    DriverPositions[i].ViewPitchUpLimit = 65535;
                    DriverPositions[i].ViewPitchDownLimit = 1;
                }

                SwitchMesh(DriverPositionIndex);

                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            }
            else
            {
                PC.SetFOV(PC.DefaultFOV);
                Gun.bLimitYaw = false;
                PitchUpLimit = 65535;
                PitchDownLimit = 1;
            }
        }

        bOwnerNoSee = false;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = !bDrawDriverInTP;
        }

        if (PC == Controller)
        {
            ActivateOverlay(false);
        }
    }
    else
    {
        if (bBehindViewChanged)
        {
            // Switching back from behind view, so make rotation relative to vehicle again
            if (bPCRelativeFPRotation)
            {
                PC.SetRotation(rotator(vector(PC.Rotation) << Gun.Rotation));
                SetRotation(PC.Rotation);
            }

            if (DriverPositions.Length > 0)
            {
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
                    DriverPositions[i].ViewFOV = default.DriverPositions[i].ViewFOV;
                    DriverPositions[i].ViewPositiveYawLimit = default.DriverPositions[i].ViewPositiveYawLimit;
                    DriverPositions[i].ViewNegativeYawLimit = default.DriverPositions[i].ViewNegativeYawLimit;
                    DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                    DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;
                }

                SwitchMesh(DriverPositionIndex);

                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }
            else
            {
                PC.SetFOV(WeaponFOV);
                Gun.bLimitYaw = Gun.default.bLimitYaw;
                PitchUpLimit = default.PitchUpLimit;
                PitchDownLimit = default.PitchDownLimit;
            }
        }

        bOwnerNoSee = !bDrawMeshInFP;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = Driver.default.bOwnerNoSee;
        }

        if (bDriving && PC == Controller)
        {
            ActivateOverlay(true);
        }
    }
}

// Matt: toggles between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && bMultiPosition)
    {
        if (Gun.Mesh == default.DriverPositions[DriverPositionIndex].PositionMesh)
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = Gun.default.Mesh;
            }
        }
        else
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
            }
        }

        SwitchMesh(DriverPositionIndex);
    }
}

// Matt: DH version but keeping it just to view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    local int i;

    if (class'DH_LevelInfo'.static.DHDebugMode() && Gun != none) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
    {
        if (Gun.bLimitYaw == Gun.default.bLimitYaw && PitchUpLimit == default.PitchUpLimit && PitchDownLimit == default.PitchDownLimit)
        {
            Gun.bLimitYaw = false;
            Gun.PitchUpLimit = 65535;
            Gun.PitchDownLimit = 1;
            Gun.CustomPitchUpLimit = 65535;
            Gun.CustomPitchDownLimit = 1;
            PitchUpLimit = 65535;
            PitchDownLimit = 1;

            if (DriverPositions.Length > 0)
            {
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].ViewPositiveYawLimit = 65535;
                    DriverPositions[i].ViewNegativeYawLimit = -65535;
                    DriverPositions[i].ViewPitchUpLimit = 65535;
                    DriverPositions[i].ViewPitchDownLimit = 1;
                }
            }
        }
        else
        {
            Gun.bLimitYaw = Gun.default.bLimitYaw;
            Gun.PitchUpLimit = Gun.default.PitchUpLimit;
            Gun.PitchDownLimit = Gun.default.PitchDownLimit;
            Gun.CustomPitchUpLimit = Gun.default.CustomPitchUpLimit;
            Gun.CustomPitchDownLimit = Gun.default.CustomPitchDownLimit;
            PitchUpLimit = default.PitchUpLimit;
            PitchDownLimit = default.PitchDownLimit;

            if (DriverPositions.Length > 0)
            {
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].ViewPositiveYawLimit = default.DriverPositions[i].ViewPositiveYawLimit;
                    DriverPositions[i].ViewNegativeYawLimit = default.DriverPositions[i].ViewNegativeYawLimit;
                    DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                    DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;
                }
            }
        }
    }
}

// Allows debugging exit positions to be toggled for all MG pawns
exec function ToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DHMountedTankMGPawn'.default.bDebugExitPositions = !class'DHMountedTankMGPawn'.default.bDebugExitPositions;
        Log("DHMountedTankMGPawn.bDebugExitPositions =" @ class'DHMountedTankMGPawn'.default.bDebugExitPositions);
    }
}

defaultproperties
{
    UnbuttonedPositionIndex=1
    OverlayCenterSize=1.0
    MGOverlay=none // to remove default from ROMountedTankMGPawn - set this in subclass if texture sight overlay used
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
    bZeroPCRotOnEntry=false // Matt: we're now calling MatchRotationToGunAim() on entering, so no point zeroing rotation
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Y=0.0,Z=0.0)
    TPCamWorldOffset=(X=0.0,Y=0.0,Z=120.0)
}
