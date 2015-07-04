//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleCannonPawn extends ROTankCannonPawn
    abstract;

// General
var     DHVehicleCannon     Cannon;           // just a reference to the DH cannon actor, for convenience & to avoid lots of casts
var     name        PlayerCameraBone;         // just to avoid using literal references to 'Camera_com' bone & allow extra flexibility
var     texture     AltAmmoReloadTexture;     // used to show coaxial MG reload progress on the HUD, like the cannon reload
var     bool        bNeedToInitializeDriver;  // clientside flag that we need to do some player set up, once we receive the Driver actor

// Position stuff
var     int         InitialPositionIndex;     // initial player position on entering
var     int         UnbuttonedPositionIndex;  // lowest position number where player is unbuttoned
var     int         PeriscopePositionIndex;   // index position of commander's periscope
var     int         GunsightPositions;        // the number of gunsight positions - 1 for normal optics or 2 for dual-magnification optics
var     int         RaisedPositionIndex;      // lowest position where commander is raised up (unbuttoned in enclosed turret, or standing in open turret or on AT gun)
var     float       ViewTransitionDuration;   // used to control the time we stay in state ViewTransition

// Gunsight or periscope overlay
var     bool        bShowRangeRing;       // show range ring (used in German tank sights)
var     bool        bShowRangeText;       // show current range setting text
var     TexRotator  ScopeCenterRotator;
var     float       ScopeCenterScale;
var     int         CenterRotationFactor;
var     float       OverlayCenterSize;    // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var     float       OverlayCenterScale;
var     float       OverlayCenterTexStart;
var     float       OverlayCenterTexSize;
var     float       OverlayCorrectionX;   // scope center correction in pixels, in case an overlay is off-center by pixel or two
var     float       OverlayCorrectionY;
var     texture     PeriscopeOverlay;

// Damage modelling stuff
var     bool        bTurretRingDamaged;
var     bool        bGunPivotDamaged;
var     bool        bOpticsDamaged;
var     texture     DestroyedScopeOverlay;

// Manual & powered turret movement
var     bool        bManualTraverseOnly;
var     sound       ManualRotateSound;
var     sound       ManualPitchSound;
var     sound       ManualRotateAndPitchSound;
var     sound       PoweredRotateSound;
var     sound       PoweredPitchSound;
var     sound       PoweredRotateAndPitchSound;
var     float       ManualMinRotateThreshold;
var     float       ManualMaxRotateThreshold;
var     float       PoweredMinRotateThreshold;
var     float       PoweredMaxRotateThreshold;

// NEW DH CODE: Illuminated sights
//var   texture     NormalCannonScopeOverlay;
//var   texture     LitCannonScopeOverlay; // a ClientLightOverlay() server-to-client function was planned
//var   bool        bOpticsLit;
//var   bool        bHasLightedOptics;

// Debugging help
var     bool        bDebugSights;        // shows centering cross in tank sight for testing purposes
var     bool        bDebuggingText;      // on screen messages if damage prevents turret or gun from moving properly
var     bool        bDebugExitPositions; // spawns a debug tracer at each player exit position
var     bool        bDebugCamera;        // in behind view, draws a red dot at current camera location with a line showing camera rotation

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bTurretRingDamaged, bGunPivotDamaged;
//      UnbuttonedPositionIndex;      // Matt: removed as never changes & doesn't need to be replicated
//      bOpticsDamaged; // bOpticsLit // Matt: removed as not even used clientside

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerLogCannon, // DEBUG (temp)
        ServerToggleDebugExits; // only during development
//      ServerChangeDriverPos      // Matt: removed function
//      ServerToggleExtraRoundType // Matt: removed function as is pointless - normal RO ServerToggleRoundType can be called; it's only the functionality in Gun.ToggleRoundType() that changes
//      DamageCannonOverlay        // Matt: removed as isn't called by client

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientDamageCannonOverlay,
        ClientLogCannon; // DEBUG (temp)
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to match RaisedPositionIndex to UnbuttonedPositionIndex by default, & to calculate & set CannonScopeOverlay variables once instead of every DrawHUD
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (RaisedPositionIndex == -1) // default value -1 signifies match to UPI, just to save having to set it in most vehicles (set RPI in vehicle subclass def props if different)
    {
        RaisedPositionIndex = UnbuttonedPositionIndex;
    }

    if (Level.NetMode != NM_DedicatedServer && CannonScopeOverlay != none)
    {
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1.0 - OverlayCenterScale) * Float(CannonScopeOverlay.USize) / 2.0;
        OverlayCenterTexSize =  Float(CannonScopeOverlay.USize) * OverlayCenterScale;
    }
}

// Modified to make sure net clients get the cannon & player in the correct position when vehicle is replicated to client
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role < ROLE_Authority && bDriving)
    {
        bNeedToInitializeDriver = true;
    }
}

// Matt: new function to do any extra set up in the cannon classes (called from PostNetReceive on net client or from AttachToVehicle on standalone or server)
// Crucially, we know that we have VehicleBase & Gun when this function gets called, so we can reliably do stuff that needs those actors
// Using it to reliably initialize the manual/powered turret settings when vehicle spawns, knowing we'll have relevant actors
simulated function InitializeCannon()
{
    Cannon = DHVehicleCannon(Gun);

    if (Cannon != none)
    {
        Cannon.InitializeCannon(self);
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owned DHVehicleCannon, so lots of things are not going to work!");
    }

    if (DHArmoredVehicle(VehicleBase) != none)
    {
        SetManualTurret(DHArmoredVehicle(VehicleBase).bEngineOff);
    }
    else
    {
        SetManualTurret(true);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Matt: modified to call InitializeCannon when we've received both the replicated Gun & VehicleBase actors (just after vehicle spawns via replication), which has 2 benefits:
// 1. Do things that need one or both of those actor refs, controlling common problem of unpredictability of timing of receiving replicated actor references
// 2. To do any extra set up in the cannon classes, which can easily be subclassed for anything that is vehicle specific
simulated function PostNetReceive()
{
    local int i;

    // Player has changed position
    if (DriverPositionIndex != SavedPositionIndex && Gun != none && bMultiPosition)
    {
        LastPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;

        // Matt: added 'if' to avoid duplication/conflict with SetPlayerPosition(), which now handles the starting anims when vehicle replicates to a net client
        // Also no point playing transition anim if there's no 'Driver' (if he's just left, the BeginningIdleAnim will play)
        if (Driver != none && bInitializedVehicleGun)
        {
            NextViewPoint();
        }
    }

    // Initialize the cannon (added VehicleBase != none, so we guarantee that VB is available to InitializeCannon)
    if (!bInitializedVehicleGun && Gun != none && VehicleBase != none)
    {
        bInitializedVehicleGun = true;
        InitializeCannon();
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

    // Initialize the 'Driver'
    if (bNeedToInitializeDriver && Driver != none && Gun != none)
    {
        bNeedToInitializeDriver = false;
        SetPlayerPosition();
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  VIEW/DISPLAY  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified so player's view turns with a turret, to properly handle vehicle roll, to handle dual-magnification optics,
// to handle FPCamPos camera offset for any position (not just overlays), & to optimise & simplify generally
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat    RelativeQuat, VehicleQuat, NonRelativeQuat;
    local rotator BaseRotation;
    local bool    bOnGunsight, bCameraRotationNotRelative, bOffsetFromBaseRotation;

    ViewActor = self;

    if (PC == none || Gun == none)
    {
        return;
    }

    // If player is on gunsight, use CameraBone for camera location & use cannon's aim for camera rotation
    if (DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition') && CameraBone !='') // GunsightPositions may be 2 for dual-magnification optics
    {
        bOnGunsight = true;
        CameraLocation = Gun.GetBoneCoords(CameraBone).Origin;
        CameraRotation = Gun.CurrentAim;
    }
    // Otherwise use PlayerCameraBone for camera location & use PC's rotation for camera rotation (unless camera is locked during a transition)
    else
    {
        CameraLocation = Gun.GetBoneCoords(PlayerCameraBone).Origin;

        // If camera is locked during a current transition, lock rotation to PlayerCameraBone
        if (bLockCameraDuringTransition && IsInState('ViewTransition'))
        {
            CameraRotation = Gun.GetBoneRotation(PlayerCameraBone);
            bCameraRotationNotRelative = true; // this rotation isn't relative to the vehicle
        }
        // Otherwise, player can look around, e.g. cupola, periscope, unbuttoned or binoculars
        else
        {
            CameraRotation = PC.Rotation;

            // If there's a camera position offset, we'll need to make that relative to the vehicle (note Gun.Rotation is same as vehicle base)
            if (FPCamPos != vect(0.0, 0.0, 0.0))
            {
                bOffsetFromBaseRotation = true;
                BaseRotation = Gun.Rotation;
            }

            // If vehicle has a turret, add turret's yaw to player's relative rotation, so player's view turns with the turret
            if (Cannon != none && Cannon.bHasTurret)
            {
                CameraRotation.Yaw += Cannon.CurrentAim.Yaw;

                if (bOffsetFromBaseRotation) // also factor turret yaw into BaseRotation, if we're going to be applying a camera position offset
                {
                    BaseRotation.Yaw += Cannon.CurrentAim.Yaw;
                }
            }
        }
    }

    // If CameraRotation is currently relative to vehicle, now factor in the vehicle's rotation (note Gun.Rotation is same as vehicle base)
    if (!bCameraRotationNotRelative)
    {
        RelativeQuat = QuatFromRotator(Normalize(CameraRotation));
        VehicleQuat = QuatFromRotator(Gun.Rotation);
        NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
        CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));
    }

    // Custom aim update
    if (bOnGunsight)
    {
        PC.WeaponBufferRotation.Yaw = CameraRotation.Yaw;
        PC.WeaponBufferRotation.Pitch = CameraRotation.Pitch;
    }

    // Adjust camera location for any offset positioning (FPCamPos is set from any ViewLocation in DriverPositions)
    if (bOffsetFromBaseRotation)
    {
        CameraLocation = CameraLocation + (FPCamPos >> BaseRotation);
    }
    else if (FPCamPos != vect(0.0, 0.0, 0.0))
    {
        CameraLocation = CameraLocation + (FPCamPos >> CameraRotation);
    }

    // Finalise the camera with any shake
    CameraLocation = CameraLocation + (PC.ShakeOffset >> PC.Rotation);
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Modified to remove irrelevant stuff about driver weapon crosshair & to optimise
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local vector           CameraLocation;
    local rotator          CameraRotation;
    local Actor            ViewActor;
    local float            SavedOpacity, PosX, PosY, ScreenRatio, XL, YL, MapX, MapY;
    local int              RotationFactor;
    local color            SavedColor, WhiteColor;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && (!IsInState('ViewTransition') || DriverPositions[LastPositionIndex].bDrawOverlays))
        {
            if (HUDOverlay == none)
            {
                // Save current HUD opacity & then set up for drawing overlays
                SavedOpacity = C.ColorModulate.W;
                C.ColorModulate.W = 1.0;
                C.DrawColor.A = 255;
                C.Style = ERenderStyle.STY_Alpha;

                // Draw gunsights
                if (DriverPositionIndex < GunsightPositions)
                {
                    // Debug - draw cross on the center of the screen
                    if (bDebugSights)
                    {
                        PosX = C.SizeX / 2.0;
                        PosY = C.SizeY / 2.0;
                        C.SetPos(0.0, 0.0);
                        C.DrawVertical(PosX - 1.0, PosY - 3.0);
                        C.DrawVertical(PosX, PosY - 3.0);
                        C.SetPos(0.0, PosY + 3.0);
                        C.DrawVertical(PosX - 1.0, PosY - 3.0);
                        C.DrawVertical(PosX, PosY - 3.0);
                        C.SetPos(0.0, 0.0);
                        C.DrawHorizontal(PosY - 1.0, PosX - 3.0);
                        C.DrawHorizontal(PosY, PosX - 3.0);
                        C.SetPos(PosX + 3.0, 0.0);
                        C.DrawHorizontal(PosY - 1.0, PosX - 3.0);
                        C.DrawHorizontal(PosY, PosX - 3.0);
                    }

                    // Draw the gunsight overlays
                    if (CannonScopeOverlay != none)
                    {
                        ScreenRatio = float(C.SizeY) / float(C.SizeX);
                        C.SetPos(0.0, 0.0);

                        C.DrawTile(CannonScopeOverlay, C.SizeX, C.SizeY, OverlayCenterTexStart - OverlayCorrectionX,
                            OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0, OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);
                    }

                    if (CannonScopeCenter != none)
                    {
                        if (Gun != none && Gun.ProjectileClass != none)
                        {
                            C.SetPos(0.0, Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * C.ClipY);
                        }
                        else
                        {
                            C.SetPos(ScopePositionX * C.ClipY / ScreenRatio / OverlayCenterScale - (C.ClipX / OverlayCenterScale - C.ClipX) / 2.0,
                                ScopePositionY * C.ClipY / ScreenRatio / OverlayCenterScale - C.ClipY * (1.0 / ScreenRatio / OverlayCenterScale - 1.0) / 2.0);
                        }

                        C.DrawTile(CannonScopeCenter, C.SizeX, C.SizeY, OverlayCenterTexStart - OverlayCorrectionX,
                            OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0, OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);
                    }

                    C.SetPos(0.0, Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * C.ClipY);

                    if (bShowRangeRing && Gun != none)
                    {
                        // Draw the range ring
                        PosX = (float(C.SizeX) - float(C.SizeY) * 4.0 / OverlayCenterScale / 3.0) / 2.0;
                        PosY = (float(C.SizeY) - float(C.SizeY) * 4.0 / OverlayCenterScale / 3.0) / 2.0;

                        C.SetPos(OverlayCorrectionX + PosX + (C.SizeY * (1.0 - ScopeCenterScale) * 4.0 / OverlayCenterScale / 3.0 / 2.0),
                            OverlayCorrectionY + C.SizeY * (1.0 - ScopeCenterScale * 4.0 / OverlayCenterScale / 3.0) / 2.0);

                        if (Gun.CurrentRangeIndex < 20)
                        {
                           RotationFactor = Gun.CurrentRangeIndex * CenterRotationFactor;
                        }
                        else
                        {
                           RotationFactor = (CenterRotationFactor * 20) + (((Gun.CurrentRangeIndex - 20) * 2) * CenterRotationFactor);
                        }

                        ScopeCenterRotator.Rotation.Yaw = RotationFactor;

                        C.DrawTileScaled(ScopeCenterRotator, C.SizeY / 512.0 * ScopeCenterScale * 4.0 / OverlayCenterScale / 3.0,
                            C.SizeY / 512.0 * ScopeCenterScale * 4.0 / OverlayCenterScale / 3.0);
                    }

                    // Draw the range setting
                    if (bShowRangeText && Gun != none)
                    {
                        C.Style = ERenderStyle.STY_Normal;
                        SavedColor = C.DrawColor;
                        WhiteColor = class'Canvas'.static.MakeColor(255, 255, 255, 175);
                        C.DrawColor = WhiteColor;
                        MapX = RangePositionX * C.ClipX;
                        MapY = RangePositionY * C.ClipY;
                        C.SetPos(MapX, MapY);
                        C.Font = class'ROHUD'.static.GetSmallMenuFont(C);
                        C.StrLen(Gun.GetRange() @ RangeText, XL, YL);
                        C.DrawTextJustified(Gun.GetRange() @ RangeText, 2, MapX, MapY, MapX + XL, MapY + YL);
                        C.DrawColor = SavedColor;
                    }
                }
                // Draw periscope overlay
                else if (DriverPositionIndex == PeriscopePositionIndex)
                {
                    DrawPeriscopeOverlay(C);
                }
                // Draw binoculars overlay
                else if (DriverPositionIndex == BinocPositionIndex)
                {
                    DrawBinocsOverlay(C);
                }

                C.ColorModulate.W = SavedOpacity; // reset HUD opacity to original value
            }
            // Draw any HUD overlay
            else if (!Level.IsSoftwareRendering())
            {
                CameraRotation = PC.Rotation;
                SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
                HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                HUDOverlay.SetRotation(CameraRotation);
                C.DrawActor(HUDOverlay, false, false, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, VehicleBase, self);
        }
    }
    else if (HUDOverlay != none)
    {
        ActivateOverlay(false);
    }

    // Debug option to show camera location & rotation in behind viewred dot (inside white sphere to make more visible) & camera rotation as red line (needs "show sky" in console)
    if (bDebugCamera && PC != none && PC.bBehindView && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()))
    {
        SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
        DrawDebugSphere(CameraLocation, 1.0, 4, 255, 0, 0);       // camera location shown as very small red sphere, like a large dot
        DrawDebugSphere(CameraLocation, 10.0, 10, 255, 255, 255); // larger white sphere to make actual camera location more visible, especially if it's inside the mesh

        if (DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition') && CameraBone !='') // only draw camera rotation if on gunsight
        {
            DrawDebugLine(CameraLocation, CameraLocation + (60.0 * vector(CameraRotation)), 255, 0, 0);
        }
    }
}

// New function to draw any textured commander's periscope overlay
simulated function DrawPeriscopeOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = float(C.SizeY) / float(C.SizeX);
    C.SetPos(0.0, 0.0);

    C.DrawTile(PeriscopeOverlay, C.SizeX, C.SizeY, 0.0, (1.0 - ScreenRatio) * float(PeriscopeOverlay.VSize) / 2.0,
        PeriscopeOverlay.USize, float(PeriscopeOverlay.VSize) * ScreenRatio);
}

// Modified to simply draw the BinocsOverlay, without additional drawing
simulated function DrawBinocsOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = Float(C.SizeY) / Float(C.SizeX);
    C.SetPos(0.0, 0.0);
    C.DrawTile(BinocsOverlay, C.SizeX, C.SizeY, 0.0, (1.0 - ScreenRatio) * Float(BinocsOverlay.VSize) / 2.0, BinocsOverlay.USize, Float(BinocsOverlay.VSize) * ScreenRatio);
}

// Modified to switch to external mesh & unzoomed FOV for behind view, plus handling of relative/non-relative turret rotation
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local rotator ViewRotation;

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            // Behind view, so if player is on the gunsight, make him face the same direction as the cannon
            if (DriverPositionIndex < GunsightPositions)
            {
                MatchRotationToGunAim();
            }

            // Switching to behind view, so make rotation non-relative to vehicle
            FixPCRotation(PC);
            SetRotation(PC.Rotation);

            // Switch to external vehicle mesh & unzoomed view
            SwitchMesh(-1); // -1 signifies switch to default external mesh
            PC.SetFOV(PC.DefaultFOV);
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
            ViewRotation = PC.Rotation;

            // Remove any turret yaw from player's rotation, as in 1st person view the turret yaw will be added by SpecialCalcFirstPersonView()
            if (Cannon.bHasTurret)
            {
                ViewRotation.Yaw -= Cannon.CurrentAim.Yaw;
            }

            PC.SetRotation(rotator(vector(ViewRotation) << Gun.Rotation));
            SetRotation(PC.Rotation);

            // Switch back to position's normal vehicle mesh, view FOV & 1st person camera offset
            if (DriverPositions.Length > 0)
            {
                SwitchMesh(DriverPositionIndex);
                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }
            else
            {
                PC.SetFOV(WeaponFOV);
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

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* FIRING & AMMO  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to use CanFire() & to avoid obsolete RO functionality in ROTankCannonPawn & optimise what remains
function Fire(optional float F)
{
    if (CanFire() && Cannon != none)
    {
        if (Cannon.CannonReloadState == CR_ReadyToFire && Cannon.bClientCanFireCannon)
        {
            super(VehicleWeaponPawn).Fire(F);
        }
        else if (Cannon.CannonReloadState == CR_Waiting && Cannon.HasAmmo(Cannon.GetPendingRoundIndex()) && ROPlayer(Controller) != none && ROPlayer(Controller).bManualTankShellReloading)
        {
            Cannon.ServerManualReload();
        }
    }
}

// Modified to check CanFire(), to skip over obsolete RO functionality in ROTankCannonPawn, & to add dry-fire sound if trying to fire empty MG
function AltFire(optional float F)
{
    if (!bHasAltFire || !CanFire() || Gun == none)
    {
        return;
    }

    if (Gun.ReadyToFire(true))
    {
        VehicleFire(true);
        bWeaponIsAltFiring = true;

        if (!bWeaponIsFiring && IsHumanControlled())
        {
            Gun.ClientStartFire(Controller, true);
        }
    }
    else if (Gun.FireCountdown <= Gun.AltFireInterval) // means that coaxial MG isn't reloading (or at least has virtually completed its reload)
    {
        PlaySound(Cannon.NoMGAmmoSound, SLOT_None, 1.5,, 25.0,, true);
    }
}

// New function, checked by Fire() so we prevent firing while moving between view points or when on periscope or binoculars
function bool CanFire()
{
    return (!IsInState('ViewTransition') && DriverPositionIndex != PeriscopePositionIndex && DriverPositionIndex != BinocPositionIndex) || ROPlayer(Controller) == none;
}

// simulated exec function SwitchFireMode()
// Matt: TODO - add some kind of clientside eligibility check to stop player spamming server with invalid ServerToggleRoundType() calls
// Maybe just change PendingProjClass clientside & only update to server when it needs it, i.e. after firing or starting a reload (similar to what I've done with RangeIndex in DHRocketWeapon)
// Server only needs PendingProjectileClass in ServerManualReload, AttemptFire & SpawnProjectile & clientside it's only used by/replicated to an owning net client

// Re-stated here just to make into simulated functions, so modified LeanLeft & LeanRight exec functions in DHPlayer can call this on the client as a pre-check
simulated function IncrementRange()
{
    if (Gun != none)
    {
        Gun.IncrementRange();
    }
}

simulated function DecrementRange()
{
    if (Gun != none)
    {
        Gun.DecrementRange();
    }
}

// Modified to prevent attempting reload if don't have ammo
simulated exec function ROManualReload()
{
    if (Cannon != none && Cannon.CannonReloadState == CR_Waiting && Cannon.HasAmmo(Cannon.GetPendingRoundIndex()) && ROPlayer(Controller) != none && ROPlayer(Controller).bManualTankShellReloading)
    {
        Cannon.ServerManualReload();
    }
}

// Modified to use new ResupplyAmmo() in the VehicleWeapon classes, instead of GiveInitialAmmo()
function bool ResupplyAmmo()
{
    return Cannon != none && Cannon.ResupplyAmmo();
}

// New function, used by HUD to show coaxial MG reload progress, like the cannon reload
function float GetAltAmmoReloadState()
{
    local float ProportionOfReloadRemaining;

    if (Gun == none)
    {
        return 1.0;
    }
    else if (Gun.FireCountdown <= Gun.AltFireInterval)
    {
        return 0.0;
    }
    else
    {
        if (Cannon == none)
        {
            return 1.0;
        }

        ProportionOfReloadRemaining = Gun.FireCountdown / GetSoundDuration(Cannon.ReloadSound);

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
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE ENTRY  ******************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to remove obsolete stuff & duplication from the Supers, & to use the vehicle's VehicleTeam to determine the team
function bool TryToDrive(Pawn P)
{
    // Deny entry if vehicle has driver or is dead, or if player is crouching or on fire or reloading a weapon (plus several very obscure other reasons)
    if (Driver != none || Health <= 0 || P == none || (DHPawn(P) != none && DHPawn(P).bOnFire) || (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none || !P.Controller.bIsPlayer || P.DrivenVehicle != none || P.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    if (VehicleBase != none)
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
        if (!P.IsHumanControlled() && VehicleBase.Driver == none)
        {
            return VehicleBase.TryToDrive(P);
        }
    }

    // Vehicle can only be used by tank crew & player is not a tanker role, so next check if there are any available rider positions before denying entry
    if (bMustBeTankCrew && !(ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none
        && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew) && P.IsHumanControlled())
    {
        DenyEntry(P, 0); // not qualified to operate vehicle

        return false;
    }

    // Passed all checks, so allow player to enter the vehicle
    if (bEnterringUnlocks && bTeamLocked)
    {
        bTeamLocked = false;
    }

    KDriverEnter(P);

    return true;
}

// Modified to try to start an MG reload if coaxial MG is out of ammo, to show any damaged gunsight, & to use InitialPositionIndex instead of assuming start in position zero
function KDriverEnter(Pawn P)
{
    super.KDriverEnter(P);

    DriverPositionIndex = InitialPositionIndex;
    LastPositionIndex = InitialPositionIndex;

    // If coaxial MG is out of ammo, start an MG reload
    // Note we don't need to consider cannon reload, as an empty cannon will already be on a repeating reload timer (or waiting for key press if player uses manual reloading)
    if (bHasAltFire && Cannon != none && !Cannon.HasAmmo(3) && Role == ROLE_Authority)
    {
        Cannon.HandleReload();
    }

    if (bOpticsDamaged)
    {
        ClientDamageCannonOverlay();
    }
}

// Modified to handle InitialPositionIndex instead of assuming start in position zero, to start facing same way as cannon, & to consolidate & optimise the Supers
simulated function ClientKDriverEnter(PlayerController PC)
{
    if (bMultiPosition)
    {
        SavedPositionIndex = InitialPositionIndex;
        PendingPositionIndex = InitialPositionIndex;
        Gotostate('EnteringVehicle');
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

// Modified to handle InitialPositionIndex instead of assuming start in position zero
// Also so cannon retains its aimed direction when player enters & may switch to internal mesh
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

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** COMMANDER VIEW POINTS  ***************************** //
///////////////////////////////////////////////////////////////////////////////////////

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

// Modified to call NextViewPoint() for all modes, including dedicated server
// New player hit detection system (basically using normal hit detection as for an infantry player pawn) relies on server playing same animations as net clients
// Server also needs to be in state ViewTransition when player is unbuttoning to prevent player exiting until fully unbuttoned
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;
            NextViewPoint();
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;
            NextViewPoint();
        }
    }
}

// Modified to enter state ViewTransition for all modes except dedicated server where player is only moving between unexposed positions (so can't be shot & server doesn't need anims)
// Avoids calling AnimateTransition() & instead uses state ViewTransition in all relevant situations, as ViewTransition controls timing of enabling/disabling player hit detection
simulated function NextViewPoint()
{
    if (Level.NetMode != NM_DedicatedServer || DriverPositions[DriverPositionIndex].bExposed || DriverPositions[LastPositionIndex].bExposed)
    {
        GotoState('ViewTransition');
    }
}

// Emptied out as no longer used (see NextViewPoint() above)
simulated function AnimateTransition()
{
}

// Modified to enable or disable player's hit detection when moving to or from an exposed position, to use Sleep to control exit from state,
// to improve timing of FOV & camera position changes, to avoid switching mesh, FOV & camera position if in behind view,
// to match rotation to gun's aim when coming up off the gunsight, to add better handling of locked camera
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        StoredVehicleRotation = VehicleBase.Rotation;

        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
            // Switch to mesh for new position as may be different
            SwitchMesh(DriverPositionIndex);

            // Set any zoom & camera offset for new position - but only if moving to less zoomed position, otherwise we wait until end of transition to do it
            WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

            if (WeaponFOV > DriverPositions[LastPositionIndex].ViewFOV)
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }

            // If player is moving up from gunsight, make him face the same direction as the cannon (feels more natural to come up from the gun)
            if (LastPositionIndex < GunsightPositions && DriverPositionIndex >= GunsightPositions && !PlayerController(Controller).bBehindView)
            {
                MatchRotationToGunAim();
            }
        }

        if (Driver != none)
        {
            // If moving to an exposed position, enable the player's hit detection
            if (DriverPositions[DriverPositionIndex].bExposed && !DriverPositions[LastPositionIndex].bExposed && bKeepDriverAuxCollision && Driver.IsA('ROPawn'))
            {
                ROPawn(Driver).ToggleAuxCollision(true);
            }

            // Play any transition animation for the player
            if (Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }

        // Play any transition animation for the cannon itself & set a duration to control when we exit this state
        ViewTransitionDuration = 0.0; // start with zero in case we don't have a transition animation

        if (LastPositionIndex < DriverPositionIndex)
        {
            if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                ViewTransitionDuration = Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim);
            }
        }
        else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
        {
            Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
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
        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
            // Set any zoom & camera offset for new position, if we've moved to a more (or equal) zoomed position (if not, we've already done this at start of transition)
            if (WeaponFOV <= DriverPositions[LastPositionIndex].ViewFOV)
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }

            // If camera was locked to PlayerCameraBone during button/unbutton transition, match rotation to that now, so the view can't snap to another rotation
            if (bLockCameraDuringTransition && ((DriverPositionIndex == UnbuttonedPositionIndex && LastPositionIndex < UnbuttonedPositionIndex)
                || (LastPositionIndex == UnbuttonedPositionIndex && DriverPositionIndex < UnbuttonedPositionIndex)) && ViewTransitionDuration > 0.0)
            {
                SetRotation(rot(0, 0, 0));
                Controller.SetRotation(Rotation);
            }
        }

        // If moving to an unexposed position, disable the player's hit detection
        if (!DriverPositions[DriverPositionIndex].bExposed && DriverPositions[LastPositionIndex].bExposed && bKeepDriverAuxCollision && ROPawn(Driver) != none)
        {
            ROPawn(Driver).ToggleAuxCollision(false);
        }
    }

Begin:
    HandleTransition();
    Sleep(ViewTransitionDuration);
    GotoState('');
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE EXIT  ********************************* //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add clientside checks before sending the function call to the server
simulated function SwitchWeapon(byte F)
{
    local VehicleWeaponPawn WeaponPawn;
    local bool              bMustBeTankerToSwitch;
    local byte              ChosenWeaponPawnIndex;

    if (Role == ROLE_Authority) // if we're not a net client, skip clientside checks & jump straight to the server function call
    {
        ServerChangeDriverPosition(F);
    }

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

        // Stop call to server if weapon position already has a human player
        // Note we don't try to stop call to server if weapon pawn doesn't exist, as it may not on net client, but will get replicated if player enters position on server
        if (ChosenWeaponPawnIndex < VehicleBase.WeaponPawns.Length)
        {
            WeaponPawn = VehicleBase.WeaponPawns[ChosenWeaponPawnIndex];

            if (WeaponPawn != none && WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
            {
                return;
            }
            else if (WeaponPawn == none && class<ROPassengerPawn>(VehicleBase.PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass) == none) // TEMP DEBUG
                Log(Tag @ Caps("SwitchWeapon would have prevented switch to WeaponPawns[" $ ChosenWeaponPawnIndex $ "] as WP doesn't exist on client"));
        }

        if (class<ROVehicleWeaponPawn>(VehicleBase.PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass).default.bMustBeTankCrew)
        {
            bMustBeTankerToSwitch = true;
        }
    }

    // Stop call to server if player has selected a tank crew role but isn't a tanker
    if (bMustBeTankerToSwitch && !(Controller != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) != none
        && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        DenyEntry(self, 0); // not qualified to operate vehicle

        return;
    }

    ServerChangeDriverPosition(F);
}

// Modified to prevent 'teleporting' outside to external rider position while buttoned up inside vehicle
function ServerChangeDriverPosition(byte F)
{
    if (!StopExitToRiderPosition(F - 2)) // pressing 1 to switch to driver's position means F-2 becomes 255 (as a byte), which doesn't count as a blocked rider position
    {
        super.ServerChangeDriverPosition(F);
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

// Modified to remove overlap with KDriverLeave(), moving common features into DriverLeft(), which gets called by both functions
function DriverDied()
{
    super(Vehicle).DriverDied(); // need to skip over Super in ROVehicleWeaponPawn (& Super in VehicleWeaponPawn adds nothing)

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

// Modified so mesh rotation is matched in all net modes, not just standalone as in the RO original (not sure why they did that)
// Also to remove playing BeginningIdleAnim as that now gets done for all net modes in DrivingStatusChanged()
simulated state LeavingVehicle
{
    simulated function HandleExit()
    {
        SwitchMesh(-1); // -1 signifies switch to default external mesh
    }
}

// Modified to play idle animation for all modes, so other net players see things like closed hatches & also any collision stuff is re-set (including on server)
simulated event DrivingStatusChanged()
{
    super.DrivingStatusChanged();

    if (!bDriving && Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
    {
        Gun.PlayAnim(Gun.BeginningIdleAnim);
    }
}

// New function to check if player can exit, displaying an "unbutton hatch" message if he can't (just saves repeating code in different functions)
simulated function bool CanExit()
{
    if (DriverPositionIndex < UnbuttonedPositionIndex || (IsInState('ViewTransition') && DriverPositionIndex == UnbuttonedPositionIndex))
    {
        ReceiveLocalizedMessage(class'DHVehicleMessage', 4,,, Controller); // must unbutton the hatch

        return false;
    }

    return true;
}

// New function to check if player is trying to 'teleport' outside to external rider position while buttoned up (just saves repeating code in different functions)
simulated function bool StopExitToRiderPosition(byte ChosenWeaponPawnIndex)
{
    local DHArmoredVehicle AV;

    AV = DHArmoredVehicle(VehicleBase);

    return AV != none && AV.bMustUnbuttonToSwitchToRider && AV.bAllowRiders &&
        ChosenWeaponPawnIndex >= AV.FirstRiderPositionIndex && ChosenWeaponPawnIndex < AV.PassengerWeapons.Length && !CanExit();
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
function bool PlaceExitingDriver()
{
    local int    i, StartIndex;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

    if (Driver == none || VehicleBase == none)
    {
        return false;
    }

    Extent = Driver.GetCollisionExtent();
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Debug exits - uses DHVehicleCannonPawn class default, allowing bDebugExitPositions to be toggled for all cannon pawns
    if (class'DHVehicleCannonPawn'.default.bDebugExitPositions)
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

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to call same function on VehicleWeapon class so it pre-caches its Skins array (the RO class missed calling the Super to do that), & also to add extra material properties
static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(default.CannonScopeOverlay);
    L.AddPrecacheMaterial(default.CannonScopeCenter);
    L.AddPrecacheMaterial(default.BinocsOverlay);
    L.AddPrecacheMaterial(default.AmmoShellTexture);
    L.AddPrecacheMaterial(default.AmmoShellReloadTexture);
    L.AddPrecacheMaterial(default.AltAmmoReloadTexture);

    default.GunClass.static.StaticPrecache(L);
}

// Modified to add extra material properties
simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(default.CannonScopeOverlay);
    Level.AddPrecacheMaterial(default.CannonScopeCenter);
    Level.AddPrecacheMaterial(default.BinocsOverlay);
    Level.AddPrecacheMaterial(default.AmmoShellTexture);
    Level.AddPrecacheMaterial(default.AmmoShellReloadTexture);
    Level.AddPrecacheMaterial(default.AltAmmoReloadTexture);
}

// Modified to call InitializeCannon to do any extra set up in the cannon classes
// This is where we do it for standalones or servers (note we can't do it in PostNetBeginPlay because VehicleBase isn't set until this function is called)
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    super.AttachToVehicle(VehiclePawn, WeaponBone);

    if (Role == ROLE_Authority)
    {
        InitializeCannon();
    }
}

// New function to set correct initial position of player & cannon on a net client, when this actor is replicated
simulated function SetPlayerPosition()
{
    local name VehicleAnim, PlayerAnim;
    local int  i;

    // Fix driver attachment position - on replication, AttachDriver() only works if client has received cannon actor, which it may not have yet
    // Client then receives Driver attachment and RelativeLocation through replication, but this is unreliable & sometimes gives incorrect positioning
    // As a fix, if player pawn has flagged bNeedToAttachDriver (meaning attach failed), we call AttachDriver() here to make sure client has correct positioning
    if (DHPawn(Driver) != none && DHPawn(Driver).bNeedToAttachDriver)
    {
        DetachDriver(Driver); // just in case Driver is attached at this point, possibly incorrectly
        AttachDriver(Driver);
        DHPawn(Driver).bNeedToAttachDriver = false;
    }

    // Put cannon & player in correct animation pose - if player not in initial position, we need to recreate the up/down anims that will have played to get there
    if (DriverPositionIndex != InitialPositionIndex)
    {
        if (DriverPositionIndex > InitialPositionIndex)
        {
            // Step down through each position until we find the 'most recent' transition up anim & player transition anim (or have reached the initial position)
            for (i = DriverPositionIndex; i > InitialPositionIndex && (VehicleAnim == ''|| PlayerAnim == ''); --i)
            {
                if (VehicleAnim == '' && DriverPositions[i - 1].TransitionUpAnim != '')
                {
                    VehicleAnim = DriverPositions[i - 1].TransitionUpAnim;
                }

                // DriverTransitionAnim only relevant if there is also one in the position below
                if (PlayerAnim == '' && DriverPositions[i].DriverTransitionAnim != '' && DriverPositions[i - 1].DriverTransitionAnim != '')
                {
                    PlayerAnim = DriverPositions[i].DriverTransitionAnim;
                }
            }
        }
        else
        {
            // Step up through each position until we find the 'most recent' transition down anim & player transition anim (or have reached the initial position)
            for (i = DriverPositionIndex; i < InitialPositionIndex && (VehicleAnim == ''|| PlayerAnim == ''); ++i)
            {
                if (VehicleAnim == '' && DriverPositions[i + 1].TransitionDownAnim != '')
                {
                    VehicleAnim = DriverPositions[i + 1].TransitionDownAnim;
                }

                // DriverTransitionAnim only relevant if there is also one in the position above
                if (PlayerAnim == '' && DriverPositions[i].DriverTransitionAnim != '' && DriverPositions[i + 1].DriverTransitionAnim != '')
                {
                    PlayerAnim = DriverPositions[i].DriverTransitionAnim;
                }
            }
        }

        // Play the animations but freeze them at the end of the anim, so they effectively become an idle anim
        // These transitions already happened - we're playing catch up after actor replication, to recreate the position the player & cannon are already in
        if (VehicleAnim != '' && Gun != none && Gun.HasAnim(VehicleAnim))
        {
            Gun.PlayAnim(VehicleAnim);
            Gun.SetAnimFrame(1.0);
        }

        if (PlayerAnim != '' && Driver != none && !bHideRemoteDriver && bDrawDriverinTP && Driver.HasAnim(PlayerAnim))
        {
            // When vehicle replicates to net client, StartDriving() event gets called on player pawn if vehicle has a 'Driver'
            // StartDriving() plays DriveAnim on the driver, which is for the usual initial driver position, but that would override our correct PlayerAnim here
            // So if player pawn hasn't already played DriveAnim, set a flag to stop it playing DriveAnim in StartDriving(), although only this 1st time
            if (DHPawn(Driver) != none && !DHPawn(Driver).bClientPlayedDriveAnim)
            {
                DHPawn(Driver).bClientSkipDriveAnim = true;
            }

            Driver.StopAnimating(true); // stops the player's looping DriveAnim, otherwise it can blend with the new anim
            Driver.PlayAnim(PlayerAnim);
            Driver.SetAnimFrame(1.0);
        }
    }
}

// New function to toggle between manual/powered turret settings - called from PostNetReceive on vehicle clients, instead of constantly checking in Tick()
simulated function SetManualTurret(bool bManual)
{
    if (bManual || bManualTraverseOnly)
    {
        RotateSound = ManualRotateSound;
        PitchSound = ManualPitchSound;
        RotateAndPitchSound = ManualRotateAndPitchSound;
        MinRotateThreshold = ManualMinRotateThreshold;
        MaxRotateThreshold = ManualMaxRotateThreshold;

        if (Cannon != none)
        {
            Cannon.RotationsPerSecond = Cannon.ManualRotationsPerSecond;
        }
    }
    else
    {
        RotateSound = PoweredRotateSound;
        PitchSound = PoweredPitchSound;
        RotateAndPitchSound = PoweredRotateAndPitchSound;
        MinRotateThreshold = PoweredMinRotateThreshold;
        MaxRotateThreshold = PoweredMaxRotateThreshold;

        if (Cannon != none)
        {
            Cannon.RotationsPerSecond = Cannon.PoweredRotationsPerSecond;
        }
    }
}

// Modified to allow turret traverse or elevation seizure if turret ring or pivot are damaged
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    if (bTurretRingDamaged)
    {
        if (bGunPivotDamaged)
        {
            if (bDebuggingText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Gun & turret disabled");
            }

            super.HandleTurretRotation(DeltaTime, 0.0, 0.0);
        }
        else
        {
            if (bDebuggingText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Turret disabled");
            }

            super.HandleTurretRotation(DeltaTime, 0.0, PitchChange);
        }
    }
    else if (bGunPivotDamaged)
    {
        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Gun pivot disabled");
        }

        super.HandleTurretRotation(DeltaTime, YawChange, 0.0);
    }
    else // no damage
    {
        super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);
    }
}

// Modified to add in the scope turn speed factor if the player is using binoculars
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local float   TurnSpeedFactor;
    local rotator NewRotation;

    if ((DriverPositionIndex == PeriscopePositionIndex || DriverPositionIndex == BinocPositionIndex) && DHPlayer(Controller) != none)
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
}

// Modified so we don't limit view pitch if in behind view
// Also to correct apparent error in ROVehicleWeaponPawn, where PitchDownLimit was being used instead of DriverPositions[x].ViewPitchDownLimit in multi position weapon
function int LocalLimitPitch(int pitch)
{
    pitch = pitch & 65535;

    if (IsHumanControlled() && PlayerController(Controller).bBehindView)
    {
        return pitch;
    }

    if (DriverPositions.Length > 0)
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

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  MISCELLANEOUS ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New function to damage gunsight optics
function DamageCannonOverlay()
{
    ClientDamageCannonOverlay();
    bOpticsDamaged = true;
}

simulated function ClientDamageCannonOverlay()
{
    CannonScopeOverlay = DestroyedScopeOverlay;
}

// New function to handle switching between external & internal mesh, including copying cannon's aimed direction to new mesh (just saves code repetition)
simulated function SwitchMesh(int PositionIndex)
{
    local mesh    NewMesh;
    local rotator TurretYaw, TurretPitch;

    if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && Gun != none)
    {
        // If switching to a valid driver position, get its PositionMesh
        if (PositionIndex >= 0 && PositionIndex < DriverPositions.Length)
        {
            NewMesh = DriverPositions[PositionIndex].PositionMesh;
        }
        // Else switch to default external mesh (pass PositionIndex of -1 to signify this, as it's an invalid position)
        else
        {
            NewMesh = Gun.default.Mesh;
        }

        // Only switch mesh if we actually have a different new mesh
        if (NewMesh != Gun.Mesh && NewMesh != none)
        {
            if (bCustomAiming)
            {
                // Save old mesh rotation
                TurretYaw.Yaw = Gun.Rotation.Yaw - CustomAim.Yaw; // Gun's rotation is same as vehicle base
                TurretPitch.Pitch = Gun.Rotation.Pitch - CustomAim.Pitch;

                // Switch to the new mesh
                Gun.LinkMesh(NewMesh);

                // Now make the new mesh you swap to have the same rotation as the old one
                Gun.SetBoneRotation(Gun.YawBone, TurretYaw);
                Gun.SetBoneRotation(Gun.PitchBone, TurretPitch);
            }
            else
            {
                Gun.LinkMesh(NewMesh);
            }
        }
    }
}

// New function to adjust rotation so player faces same direction as cannon, either relative or independent to vehicle rotation (note owning net client will update rotation back to server)
// Note we don't actually match rotation to cannon's current aim like we do with an MG, because rotation of turret already gets added in SpecialCalcFirstPersonView()
simulated function MatchRotationToGunAim(optional Controller C)
{
    if (C == none)
    {
        C = Controller;
    }

    SetRotation(rot(0, 0, 0));

    if (C != none)
    {
        C.SetRotation(Rotation);
    }
}

// Modified so PC's rotation, which was relative to vehicle, gets set to the correct non-relative rotation on exit, including turret rotation
// Doing this in a more obvious way here avoids the previous workaround in ClientKDriverLeave, which matched the cannon pawn's rotation to the vehicle
simulated function FixPCRotation(PlayerController PC)
{
    local rotator ViewRelativeRotation;

    if (Gun != none && PC != none)
    {
        ViewRelativeRotation = PC.Rotation;

        // If the vehicle has a turret, add turret's yaw to player's relative rotation
        if (Cannon != none && Cannon.bHasTurret)
        {
            ViewRelativeRotation.Yaw += Cannon.CurrentAim.Yaw;
        }

        PC.SetRotation(rotator(vector(ViewRelativeRotation) >> Gun.Rotation)); // Gun's rotation is same as vehicle base
    }
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

///////////////////////////////////////////////////////////////////////////////////////
//  ****************************** EXEC FUNCTIONS  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New exec function to toggle between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && DriverPositions.Length > 0)
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

// Modified to work with DHDebugMode & restricted to changing view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Gun != none) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
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

// New exec function that allows debugging exit positions to be toggled for all cannon pawns
exec function ToggleDebugExits()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DHVehicleCannonPawn'.default.bDebugExitPositions = !class'DHVehicleCannonPawn'.default.bDebugExitPositions;
        Log("DHVehicleCannonPawn.bDebugExitPositions =" @ class'DHVehicleCannonPawn'.default.bDebugExitPositions);
    }
}

// New exec to toggle camera debug (location & rotation) for this cannon
exec function ToggleCameraDebug()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bDebugCamera = !bDebugCamera;
        Log(Tag @ "bDebugCamera =" @ bDebugCamera);
    }
}

exec function LogCannon() // DEBUG x 3 (Matt: use if you ever find you can't fire cannon or do a reload, when you should be able to)
{
    Log("CLIENT:" @ Tag @ " CannonReloadState =" @ GetEnum(enum'ECannonReloadState', Cannon.CannonReloadState) @ " bClientCanFireCannon =" @ Cannon.bClientCanFireCannon
        @ " ProjectileClass =" @ Cannon.ProjectileClass);
    Log("CLIENT: PrimaryAmmoCount() =" @ Cannon.PrimaryAmmoCount() @ " ViewTransition =" @ IsInState('ViewTransition') @ " DriverPositionIndex =" @ DriverPositionIndex
        @ " Controller =" @ Controller.Tag);
    if (Role < ROLE_Authority) ServerLogCannon();
}
function ServerLogCannon()
{
    ClientLogCannon(Cannon.CannonReloadState, Cannon.bClientCanFireCannon, Cannon.ProjectileClass, Cannon.PrimaryAmmoCount(), IsInState('ViewTransition'), DriverPositionIndex, Controller.Tag);
}
simulated function ClientLogCannon(int CannonReloadState, bool bClientCanFireCannon, Class ProjectileClass, int PrimaryAmmoCount, bool bIsInViewTrans, int SDriverPositionIndex, name ControllerTag)
{
    Log("SERVER:" @ Tag @ " CannonReloadState =" @ GetEnum(enum'ECannonReloadState', CannonReloadState) @ " bClientCanFireCannon =" @ bClientCanFireCannon @ " ProjectileClass =" @ ProjectileClass);
    Log("SERVER: PrimaryAmmoCount() =" @ PrimaryAmmoCount @ " ViewTransition =" @ bIsInViewTrans @ " DriverPositionIndex =" @ SDriverPositionIndex @ " Controller =" @ ControllerTag);
}

defaultproperties
{
    bKeepDriverAuxCollision=true // Matt: necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    UnbuttonedPositionIndex=2
    PeriscopePositionIndex=-1 // -1 signifies no periscope by default
    GunsightPositions=1
    RaisedPositionIndex=-1    // -1 signifies to match the RPI to the UnbuttonedPositionIndex by default
    OverlayCenterSize=0.9
    PlayerCameraBone="Camera_com"
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    ManualPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    ManualMinRotateThreshold=0.25
    ManualMaxRotateThreshold=2.5
    PoweredMinRotateThreshold=0.15
    PoweredMaxRotateThreshold=1.75
    MaxRotateThreshold=1.5
    AltAmmoReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Y=0.0,Z=0.0)
    TPCamWorldOffset=(X=0.0,Y=0.0,Z=120.0)

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & may be hard coded into functionality:
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=false
    FPCamViewOffset=(X=0.0,Y=0.0,Z=0.0)
    bDesiredBehindView=false
}
