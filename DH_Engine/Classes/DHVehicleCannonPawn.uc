//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleCannonPawn extends DHVehicleWeaponPawn
    abstract;

var DHVehicleCannon Cannon;                      // just a convenience to save an awful lot of casts

// Player view positions
var     int         GunsightPositions;           // the number of gunsight positions - 1 for normal optics or 2 for dual-magnification optics
var     int         PeriscopePositionIndex;      // index position of commander's periscope
var     int         IntermediatePositionIndex;   // optional 'intermediate' animation position, i.e. between closed & open/raised positions (used to play special firing anim)
var     int         RaisedPositionIndex;         // lowest position where commander is raised up (unbuttoned in enclosed turret, or standing in open turret or on AT gun)

// Camera & display
var     name        PlayerCameraBone;            // just to avoid using literal references to 'Camera_com' bone & allow extra flexibility
var     bool        bCamOffsetRelToGunPitch;     // camera position offset (ViewLocation) is always relative to cannon's pitch, e.g. for open sights in some AT guns
var     bool        bLockCameraDuringTransition; // lock the camera's rotation to the camera bone during transitions
var     texture     PeriscopeOverlay;            // overlay for commander's periscope
var     float       PeriscopeSize;               // so we can adjust the "exterior" FOV of the periscope overlay, just like Gunsights, if needed
var     texture     AltAmmoReloadTexture;        // used to show coaxial MG reload progress on the HUD, like the cannon reload

// Gunsight overlay
var     texture             CannonScopeCenter;          // gunsight reticle overlay (really only for a moving range indicator, but many DH sights use a pretty pointless 2nd static overlay)
var     float               RangePositionX;             // X & Y positioning of range text (0.0 to 1.0)
var     float               RangePositionY;
var     localized string    RangeText;                  // metres or yards
var     bool                bIsPeriscopicGunsight;      // cannon uses a periscopic gunsight instead of the more common coaxially mounted telescopic sight

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

// Damage
var     bool        bTurretRingDamaged;
var     bool        bGunPivotDamaged;
var     bool        bOpticsDamaged;
var     texture     DestroyedGunsightOverlay;

// Debug
var     bool        bDebugSights; // shows centering cross in gunsight for testing purposes

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bTurretRingDamaged, bGunPivotDamaged;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientDamageCannonOverlay;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to match RaisedPositionIndex to UnbuttonedPositionIndex by default
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (RaisedPositionIndex == -1) // default value -1 signifies match to UPI, just to save having to set it in most vehicles (set RPI in vehicle subclass def props if different)
    {
        RaisedPositionIndex = UnbuttonedPositionIndex;
    }
}

exec function SetCamPos(int X, int Y, int Z)
{
    if (IsDebugModeAllowed())
    {
        FPCamPos.X = X;
        FPCamPos.Y = Y;
        FPCamPos.Z = Z;
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
    local bool    bOnGunsight;

    ViewActor = self;

    if (PC == none || VehWep == none)
    {
        return;
    }

    // GET CAMERA ROTATION
    // If player is on gunsight, use CameraBone for camera rotation (its rotation will follow the cannon's aim)
    if (DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition')) // GunsightPositions may be 2 for dual-magnification optics
    {
        bOnGunsight = true;
        CameraRotation = VehWep.GetBoneRotation(CameraBone);
    }
    else if (DriverPositionIndex == SpottingScopePositionIndex && !IsInState('ViewTransition'))
    {
        // TODO: set the camera location and LOCK the camera pitch to zero, somehow
        bOnGunsight = true;
        CameraRotation = VehWep.GetBoneRotation(VehWep.YawBone);
        CameraRotation.Pitch = 0;
    }
    // Or if camera is locked during a current transition, use PlayerCameraBone for camera rotation
    else if (bLockCameraDuringTransition && IsInState('ViewTransition'))
    {
        CameraRotation = VehWep.GetBoneRotation(PlayerCameraBone);
    }
    // Otherwise player can look around (e.g. cupola, periscope, unbuttoned or binoculars), so use PC's rotation for camera rotation
    else
    {
        CameraRotation = PC.Rotation;

        // If vehicle has a turret, add turret's yaw to player's relative rotation, so player's view turns with the turret
        if (VehWep.bHasTurret)
        {
            CameraRotation.Yaw += VehWep.CurrentAim.Yaw;
        }

        // Now factor in the vehicle's rotation, to give us a world rotation for the camera
        RelativeQuat = QuatFromRotator(Normalize(CameraRotation));
        VehicleQuat = QuatFromRotator(VehWep.Rotation); // note VehWep.Rotation is same as vehicle base
        NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
        CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));
    }

    // GET CAMERA LOCATION
    // If player is on a gunsight, use CameraBone for camera location, unless it's a perscopic gunsight (which is fixed in position & doesn't move with gun pitch)
    if (bOnGunsight && !bIsPeriscopicGunsight)
    {
        CameraLocation = VehWep.GetBoneCoords(CameraBone).Origin;
    }
    // Otherwise use PlayerCameraBone for camera location
    else
    {
        CameraLocation = VehWep.GetBoneCoords(PlayerCameraBone).Origin;
    }

    // Adjust camera location for any offset positioning (note FPCamPos is set from any ViewLocation in DriverPositions)
    if (FPCamPos != vect(0.0, 0.0, 0.0))
    {
        if ((bOnGunsight && !bIsPeriscopicGunsight) || (bLockCameraDuringTransition && IsInState('ViewTransition')))
        {
            CameraLocation += FPCamPos >> CameraRotation;
        }
        // In a 'look around' position, we need to make camera offset relative to the vehicle, not the way the player is facing
        else
        {
            BaseRotation = VehWep.Rotation;

            if (VehWep.bHasTurret)
            {
                BaseRotation.Yaw += VehWep.CurrentAim.Yaw; // TODO: think this is wrong; can't just add relative yaw/pitch to non-relative veh rotation?

                if (bCamOffsetRelToGunPitch)
                {
                    BaseRotation.Pitch += VehWep.CurrentAim.Pitch;
                }
            }

            CameraLocation += FPCamPos >> BaseRotation;
        }
    }

    // Finalise the camera with any shake
    CameraLocation += PC.ShakeOffset >> PC.Rotation;
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Modified to fix bug where any HUDOverlay would be destroyed if function called before net client received Controller reference through replication
// Also to remove irrelevant stuff about crosshair & to optimise
simulated function DrawHUD(Canvas C)
{
    local DHPlayer                  PC;
    local float                     SavedOpacity;
    local DHPlayerReplicationInfo   PRI;

    PC = DHPlayer(Controller);

    if (PC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PC != none && !PC.bBehindView && PRI != none)
    {
        // Player is in a position where an overlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            if (HUDOverlay == none)
            {
                // Save current HUD opacity & then set up for drawing a texture overlay
                SavedOpacity = C.ColorModulate.W;
                C.ColorModulate.W = 1.0;
                C.DrawColor.A = 255;
                C.Style = ERenderStyle.STY_Alpha;

                if (DriverPositionIndex < GunsightPositions)   // TODO: this variable (GunsightPositions) is TERRIBLE
                {
                    // Draw the gunsight overlay
                    DrawGunsightOverlay(C);
                }
                else if (DriverPositionIndex == SpottingScopePositionIndex)
                {
                    DrawSpottingScopeOverlay(C);
                }
                else if (DriverPositionIndex == PeriscopePositionIndex)
                {
                    // Draw periscope overlay
                    DrawPeriscopeOverlay(C);
                }
                else if (DriverPositionIndex == BinocPositionIndex)
                {
                    // Draw binoculars overlay
                    DrawBinocsOverlay(C);
                }

                C.ColorModulate.W = SavedOpacity; // reset HUD opacity to original value
            }
            // Draw any HUD overlay
            else if (!Level.IsSoftwareRendering())
            {
                HUDOverlay.SetLocation(PC.CalcViewLocation + (HUDOverlayOffset >> PC.CalcViewRotation));
                HUDOverlay.SetRotation(PC.CalcViewRotation);
                C.DrawActor(HUDOverlay, false, false, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, VehicleBase, self);
        }
    }
}

// New function to draw the gunsight overlay plus any additional overlay for aiming reticle - using a different drawing method to RO
// The setting for GunsightSize is used to calculate how much of the gunsight texture to draw, with 1.0 meaning it's expanded to fill the screen width
// The DrawTile arguments are manipulated so whole screen gets drawn over, without need for separately drawing black rectangles to fill the edges, as in RO
// This reduces drawing the gunsight overlay to one draw, & tests show this is much faster
simulated function DrawGunsightOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;
    local float PosX, PosY;

    if (GunsightOverlay != none)
    {
        // The drawn portion of the gunsight texture is 'zoomed' in or out to suit the desired scaling
        // This is inverse to the specified GunsightSize, i.e. the drawn portion is reduced to 'zoom in', so sight is drawn bigger on screen
        // The draw start position (in the texture, not the screen position) is often negative, meaning it starts drawing from outside of the texture edges
        // Draw areas outside the texture edges are drawn black, so this handily blacks out all the edges around the scaled gunsight, in 1 draw operation
        TextureSize = float(GunsightOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / GunsightSize * 0.955; // width based on vehicle's GunsightSize (0.955 factor widens visible FOV to full screen for 'standard' overlay if GS=1.0)
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX); // height proportional to width, maintaining screen aspect ratio
        TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0) - OverlayCorrectionX;
        TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0) - OverlayCorrectionY;

        // Draw the gunsight overlay
        C.SetPos(0.0, 0.0);

        C.DrawTile(GunsightOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);

        // Draw any gunsight aiming reticle
        if (CannonScopeCenter != none)
        {
            C.SetPos(0.0, 0.0);
            C.DrawTile(CannonScopeCenter, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
        }

        DrawGunsightRangeSetting(C);

        // Debug - draw cross on center of screen to check sight overlay is properly centred
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
    }
}

// Draw range setting in text, if cannon has range settings.
function DrawGunsightRangeSetting(Canvas C)
{
    local float XL, YL, MapX, MapY;
    local color SavedColor, WhiteColor;

    if (Cannon == none || Cannon.RangeSettings.Length <= 0)
    {
        return;
    }

    C.Style = ERenderStyle.STY_Normal;
    SavedColor = C.DrawColor;
    WhiteColor = class'Canvas'.static.MakeColor(255, 255, 255, 175);
    C.DrawColor = WhiteColor;
    MapX = RangePositionX * C.ClipX;
    MapY = RangePositionY * C.ClipY;
    C.SetPos(MapX, MapY);
    C.Font = class'ROHUD'.static.GetSmallMenuFont(C);
    C.StrLen(Cannon.GetRange() @ RangeText, XL, YL);
    C.DrawTextJustified(Cannon.GetRange() @ RangeText, 2, MapX, MapY, MapX + XL, MapY + YL);
    C.DrawColor = SavedColor;
}

// New function to draw any textured commander's periscope overlay; modified 2019 to act like Gunsight draw function, since we may eventually have ballistic periscopes
simulated function DrawPeriscopeOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;

    if (PeriscopeOverlay != none)
    {
        // The drawn portion of the gunsight texture is 'zoomed' in or out to suit the desired scaling
        // This is inverse to the specified GunsightSize, i.e. the drawn portion is reduced to 'zoom in', so sight is drawn bigger on screen
        // The draw start position (in the texture, not the screen position) is often negative, meaning it starts drawing from outside of the texture edges
        // Draw areas outside the texture edges are drawn black, so this handily blacks out all the edges around the scaled gunsight, in 1 draw operation
        TextureSize = float(PeriscopeOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / PeriscopeSize * 0.955; // width based on vehicle's GunsightSize (0.955 factor widens visible FOV to full screen for 'standard' overlay if GS=1.0)
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX); // height proportional to width, maintaining screen aspect ratio
        TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0) - OverlayCorrectionX;
        TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0) - OverlayCorrectionY;

        // Draw the periscope overlay
        C.SetPos(0.0, 0.0);

        C.DrawTile(PeriscopeOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
    }
}

// Modified so player faces forwards if he's on the gunsight when switching to behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    if (PC != none && PC.bBehindView && bBehindViewChanged && DriverPositionIndex < GunsightPositions)
    {
        PC.SetRotation(rot(0, 0, 0));
    }

    super.POVChanged(PC, bBehindViewChanged);
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* FIRING & AMMO  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified so net client passes any changed pending ammo type to server (optimises network as avoids server update each time player toggles ammo, doing it only when needed)
// Also so fire button triggers a manual cannon reload if players uses the manual reloading option & the cannon is waiting to start reloading
function Fire(optional float F)
{
    local DHPlayer PC;

    if (Role < ROLE_Authority || Level.NetMode == NM_Standalone)
    {
        if (DriverPositionIndex == BinocPositionIndex)
        {
            PC = DHPlayer(Controller);

            if (PC != none && PC.CanUseFireSupportMenu())
            {
                PC.ShowCommandInteractionWithMenu("DH_Engine.DHCommandMenu_FireSupport", none, true);
                return;
            }
        }
    }

    if (!CanFire() || ArePlayersWeaponsLocked() || Cannon == none || Cannon.bDebugRangeAutomatically)
    {
        return;
    }

    if (Cannon.ReadyToFire(false))
    {
        if (Role < ROLE_Authority && !Cannon.PlayerUsesManualReloading()) // no update if manual reloading (update on manual reload instead)
        {
            Cannon.CheckUpdatePendingAmmo();
        }

        super(Vehicle).Fire(F);

        if (IsHumanControlled())
        {
            Cannon.ClientStartFire(Controller, false);
        }
    }
    else
    {
        ROManualReload(); // only actually tries a manual reload if player uses that option (ROML function contains exactly the same checks we'd otherwise duplicate here)
    }
}

// Implemented to handle coaxial MG fire, including dry-fire sound if trying to fire it when empty (but not if actively reloading)
// Checks that player is in a valid firing position & his weapons aren't locked due to spawn killing
function AltFire(optional float F)
{
    if (!bHasAltFire || !CanFire() || ArePlayersWeaponsLocked() || Cannon == none)
    {
        return;
    }

    if (Cannon.ReadyToFire(true))
    {
        VehicleFire(true);
        bWeaponIsAltFiring = true;

        if (!bWeaponIsFiring && IsHumanControlled())
        {
            Cannon.ClientStartFire(Controller, true);
        }
    }
    // Dry fire effect for empty coax, unless it is reloading
    else if (Cannon.AltReloadState == RL_Waiting || Cannon.bAltReloadPaused)
    {
        Cannon.DryFireEffects(true);
    }
}

// Implemented unused (in a vehicle) 'Deploy' keybind command to fire a smoke launcher
// Checks that player is in a valid firing position & his weapons aren't locked due to spawn killing
exec function Deploy()
{
    if (CanFire() && !ArePlayersWeaponsLocked() && Cannon != none)
    {
        Cannon.AttemptFireSmokeLauncher();
    }
}

// Modified to avoid cannon fire impulse if in gunsight setting mode (a debug mode)
event ApplyFireImpulse(bool bAlt)
{
    if (!(Cannon != none && Cannon.bDebugRangeManually && !Cannon.bDebugRangeAutomatically) || bAlt)
    {
        super.ApplyFireImpulse(bAlt);
    }
}

// New functions to adjust either the rotation or range setting of any adjustable smoke launcher
exec function IncreaseSmokeLauncherSetting()
{
    if (Cannon != none)
    {
        Cannon.AdjustSmokeLauncher(true);
    }
}

exec function DecreaseSmokeLauncherSetting()
{
    if (Cannon != none)
    {
        Cannon.AdjustSmokeLauncher(false);
    }
}

// Modified to prevent firing while player is on, or transitioning away from, periscope or binoculars
function bool CanFire()
{
    return (DriverPositionIndex != PeriscopePositionIndex && DriverPositionIndex != BinocPositionIndex
        && !(IsInState('ViewTransition') && (LastPositionIndex == PeriscopePositionIndex || LastPositionIndex == BinocPositionIndex)))
        || !IsHumanControlled();
}

// Modified (from deprecated ROTankCannonPawn) to keep ammo changes clientside as a network optimisation (only pass to server when it needs the change, not every key press)
exec function SwitchFireMode()
{
    if (Cannon != none && Cannon.bMultipleRoundTypes && !Cannon.bDebugRangeAutomatically)
    {
        Cannon.ToggleRoundType();
    }
}

// Modified to prevent attempting reload if don't have ammo (saves replicated function call to server) & to use reference to DHVehicleCannon instead of deprecated ROTankCannon
// Also for net client to pass any changed pending ammo type to server (optimises network as avoids update to server each time player toggles ammo, doing it only when needed)
exec simulated function ROManualReload()
{
    if (Cannon == none || !Cannon.HasAmmoToReload(Cannon.LocalPendingAmmoIndex))
    {
        return;
    }

    if ((Cannon.ReloadState == RL_Waiting && Cannon.PlayerUsesManualReloading()) ||
        (Cannon.ReloadState == RL_ReadyToFire && Cannon.LocalPendingAmmoIndex != Cannon.GetAmmoIndex()))
    {
        if (Role < ROLE_Authority || Level.NetMode == NM_Standalone)
        {
            Cannon.CheckUpdatePendingAmmo();
        }

        Cannon.ServerManualReload();
    }
}

// Modified to include coaxial MG & smoke launcher, packing the combined cannon, coax & smoke launcher reload states for replication to net client
function CheckResumeReloadingOnEntry()
{
    local byte OldReloadState, OldAltReloadState, OldSmokeLauncherReloadState;

    // Reloading
    if (Cannon != none && Cannon.bMultiStageReload)
    {
        // Save current reload states so we can tell if they are changed by attempted reloading
        OldReloadState = Cannon.ReloadState;
        OldAltReloadState = Cannon.AltReloadState;
        OldSmokeLauncherReloadState = Cannon.SmokeLauncherReloadState;

        // Try to resume any paused cannon reload, or start a new reload if in waiting state & the player does not use manual reloading
        if (Cannon.ReloadState < RL_ReadyToFire || (Cannon.ReloadState == RL_Waiting && !Cannon.PlayerUsesManualReloading()))
        {
            Cannon.AttemptReload();
        }

        // If coaxial MG isn't loaded then try to start/resume a reload
        if (bHasAltFire && Cannon.AltReloadState != RL_ReadyToFire)
        {
            Cannon.AttemptAltReload();
        }

        // If smoke launcher isn't loaded then try to start/resume a reload
        if (Cannon.SmokeLauncherClass != none && Cannon.SmokeLauncherReloadState != RL_ReadyToFire)
        {
            Cannon.AttemptSmokeLauncherReload();
        }

        // Replicate the weapon's current reload state, unless attempted reloading changed the state, in which case it will have already done this
        if (Cannon.ReloadState == OldReloadState && Cannon.AltReloadState == OldAltReloadState && Cannon.SmokeLauncherReloadState == OldSmokeLauncherReloadState)
        {
            Cannon.PassReloadStateToClient();
        }
    }
}

// New function, used by HUD to show coaxial MG reload progress, like a cannon reload
function float GetAltAmmoReloadState()
{
    if (Cannon != none)
    {
        if (Cannon.AltReloadState == RL_ReadyToFire)
        {
            return 0.0;
        }
        else if (Cannon.AltReloadState == RL_Waiting || Cannon.AltReloadState == RL_ReloadingPart1)
        {
            return 1.0;
        }

        return Cannon.AltReloadStages[Cannon.AltReloadState].HUDProportion;
    }

    return 0.0;
}

// New function, used by HUD to show smoke launcher reload progress, like a cannon reload
function float GetSmokeLauncherAmmoReloadState()
{
    if (Cannon != none && Cannon.SmokeLauncherClass != none)
    {
        if (Cannon.SmokeLauncherClass.default.bCanBeReloaded)
        {
            if (Cannon.SmokeLauncherReloadState == RL_ReadyToFire)
            {
                return 0.0;
            }
            else if (Cannon.SmokeLauncherReloadState == RL_Waiting || Cannon.SmokeLauncherReloadState == RL_ReloadingPart1)
            {
                return 1.0;
            }

            return Cannon.SmokeLauncherClass.static.GetReloadHUDProportion(Cannon.SmokeLauncherReloadState);
        }
        // If smoke launcher(s) are a type that can't be reloaded, the reload state never changes
        // So check if out of smoke launcher ammo & if so then show in red, as with other weapons
        else if (!Cannon.HasAmmo(Cannon.SMOKELAUNCHER_AMMO_INDEX))
        {
            return 1.0;
        }
    }

    return 0.0;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************* ENTRY, CHANGING VIEW & EXIT  ************************* //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to set a damaged gunsight
function KDriverEnter(Pawn P)
{
    super.KDriverEnter(P);

    if (bOpticsDamaged)
    {
        ClientDamageCannonOverlay();
    }
}

simulated function bool HasSpottingScope()
{
    return SpottingScopePositionIndex != -1;
}

// Modified so listen server re-sets pending ammo if another player has changed loaded ammo type since host player was last in this cannon,
// and so net client autocannon always goes to state 'EnteringVehicle' even for a single position cannon, which makes certain pending ammo settings are correct
simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    if (HasSpottingScope())
    {
        if (DHPlayer(PC) != none)
        {
            // Queue the hint for spotting scopes
            DHPlayer(PC).QueueHint(49, false);
        }
    }

    if (Cannon != none)
    {
        // Listen server host player re-sets pending ammo settings if another player has changed the loaded ammo type since he was last in this cannon
        // If current ammo has changed, any previous choice of pending ammo probably no longer makes sense & needs to be discarded (similar to net client in PostNetReceive)
        if (Level.NetMode == NM_ListenServer)
        {
            if (Cannon.ProjectileClass != Cannon.SavedProjectileClass)
            {
                Cannon.LocalPendingAmmoIndex = Cannon.GetAmmoIndex();
                Cannon.ServerPendingAmmoIndex = Cannon.LocalPendingAmmoIndex;
            }
        }
        // A single position autocannon goes to state 'EnteringVehicle' - really obscure but avoids problem if another player has changed pending ammo (see notes in 'EnteringVehicle')
        else if (!bMultiPosition && Role < ROLE_Authority && Cannon.bUsesMags)
        {
            GotoState('EnteringVehicle');
        }
    }
}

// Modified so an autocannon net client always replicates its LocalPendingAmmoIndex to server when player enters
// Necessary as it's possible another player changed pending ammo & updated that to server, as autocannon updates any change in pending after each shot, not just when starting a reload
// We do it here to take advantage of brief Sleep in state code, meaning server has had time to replicate ProjectileClass to new owning client (a little hacky, but necessary & works)
// ClientKDriverEnter would be the obvious choice, but client is only just becoming owner of this cannon, triggering replication of proj class, & that doesn't happen in time for CKDE
simulated state EnteringVehicle
{
ignores SwitchFireMode; // added so no possibility of switching while entering

Begin:
    if (bMultiPosition) // added 'if' because it's now possible a single position autocannon has been sent to this state (very obscure, but being thorough!)
    {
        HandleEnter();
    }

    Sleep(0.2);

    if (Role < ROLE_Authority && Cannon != none && Cannon.bUsesMags) // added for autocannon to always replicate its LocalPendingAmmoIndex to server
    {
        Cannon.CheckUpdatePendingAmmo(true);
    }

    GotoState('');
}

// Modified so set view rotation when player moves away from a position where his view was locked to a bone's rotation
// Stops camera snapping to a strange rotation as view rotation reverts to pawn/PC rotation, which has been redundant & could have wandered meaninglessly via mouse movement
simulated state ViewTransition
{
    // Modified so player faces forwards when coming up off the gunsight
    simulated function HandleTransition()
    {
        super.HandleTransition();

        if (LastPositionIndex < GunsightPositions && DriverPositionIndex >= GunsightPositions && IsFirstPerson())
        {
            SetInitialViewRotation();
        }
    }

    // Modified so if camera was locked to PlayerCameraBone during transition animation, we now match rotation to that bone's final rotation
    simulated function EndState()
    {
        local rotator NewRotation;

        super.EndState();

        if (bLockCameraDuringTransition && ViewTransitionDuration > 0.0 && IsFirstPerson())
        {
            NewRotation = rotator(vector(VehWep.GetBoneRotation(PlayerCameraBone)) << VehWep.Rotation); // get camera bone rotation, made relative to vehicle

            if (VehWep.bHasTurret) // if vehicle has a turret, remove turret's yaw from relative rotation
            {
                NewRotation.Yaw -= VehWep.CurrentAim.Yaw;
            }

            SetRotation(NewRotation); // note that an owning net client will update this back to the server
            Controller.SetRotation(NewRotation); // also set controller rotation as that's what's relevant if player exited mid-transition & that caused us to leave this state
        }
    }
}

// Modified to include a periscope overlay position & to allow for a cannon having more than 1 gunsight position
simulated function bool ShouldViewSnapInPosition(byte PositionIndex)
{
    return DriverPositions[PositionIndex].bDrawOverlays && (PositionIndex < GunsightPositions || PositionIndex == PeriscopePositionIndex || PositionIndex == BinocPositionIndex || PositionIndex == SpottingScopePositionIndex);
}

// Modified so if player exits while on the gunsight, his view rotation is zeroed so he exits facing forwards
// Necessary because while on gunsight his view rotation is locked to gunsight camera bone, but pawn/PC rotation can wander meaninglessly via mouse movement
// Also so listen server host player records currently loaded ammo type on exiting
// This is so if host player re-enters this cannon he will know if another player has since loaded different ammo
// If loaded ammo changes, any previous choice of pending ammo to load will probably no longer make sense & have to be discarded
simulated function ClientKDriverLeave(PlayerController PC)
{
    if (DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition') && PC != none)
    {
        PC.SetRotation(rot(0, 0, 0)); // note that an owning net client will update this back to the server
    }

    super.ClientKDriverLeave(PC);

    if (Level.NetMode == NM_ListenServer && Cannon != none)
    {
        Cannon.SavedProjectileClass = Cannon.ProjectileClass;
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add extra material properties
static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    if (default.CannonScopeCenter != none)
    {
        L.AddPrecacheMaterial(default.CannonScopeCenter);
    }

    if (default.DestroyedGunsightOverlay != none)
    {
        L.AddPrecacheMaterial(default.DestroyedGunsightOverlay);
    }

    if (default.PeriscopeOverlay != none)
    {
        L.AddPrecacheMaterial(default.PeriscopeOverlay);
    }

    if (default.AmmoShellTexture != none)
    {
        L.AddPrecacheMaterial(default.AmmoShellTexture);
    }

    if (default.AmmoShellReloadTexture != none)
    {
        L.AddPrecacheMaterial(default.AmmoShellReloadTexture);
    }

    if (default.AltAmmoReloadTexture != none)
    {
        L.AddPrecacheMaterial(default.AltAmmoReloadTexture);
    }
}

// Modified to add extra material properties
simulated function UpdatePrecacheMaterials()
{
    super.UpdatePrecacheMaterials();

    Level.AddPrecacheMaterial(CannonScopeCenter);
    Level.AddPrecacheMaterial(DestroyedGunsightOverlay);
    Level.AddPrecacheMaterial(PeriscopeOverlay);
    Level.AddPrecacheMaterial(AmmoShellTexture);
    Level.AddPrecacheMaterial(AmmoShellReloadTexture);
    Level.AddPrecacheMaterial(AltAmmoReloadTexture);
}

// Modified as per deprecated ROTankCannonPawn
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    super.AttachToVehicle(VehiclePawn, WeaponBone);

    if (VehiclePawn != none && VehiclePawn.bDefensive)
    {
        bDefensive = true;
    }
}

// Modified to set a convenient reference to our DHVehicleCannon actor, just to save lots of casting in this class
simulated function InitializeVehicleWeapon()
{
    Cannon = DHVehicleCannon(Gun);

    if (Cannon == none)
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owned DHVehicleCannon, so lots of things are not going to work!");
    }

    super.InitializeVehicleWeapon();
}

// Modified to reliably initialize the manual/powered turret settings when vehicle spawns
simulated function InitializeVehicleAndWeapon()
{
    super.InitializeVehicleAndWeapon();

    if (DHArmoredVehicle(VehicleBase) != none)
    {
        SetManualTurret(DHArmoredVehicle(VehicleBase).bEngineOff);
    }
    else
    {
        SetManualTurret(true);
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

// Modified (from deprecated ROTankCannonPawn) to allow turret traverse or elevation seizure if turret ring or pivot are damaged
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    if (Cannon != none && Cannon.bUseTankTurretRotation)
    {
        if (Cannon.bDebugRangeAutomatically)
        {
            YawChange = 0.0;
            PitchChange = 0.0;
        }
        else
        {
            if (bTurretRingDamaged)
            {
                YawChange = 0.0;
            }

            if (bGunPivotDamaged)
            {
                PitchChange = 0.0;
            }
        }

        UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

        if (IsHumanControlled())
        {
            PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
            PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
        }

        if (Level.NetMode != NM_DedicatedServer &&
            ((YawChange != 0.0 && !bTurretRingDamaged) || (PitchChange != 0.0 && !bGunPivotDamaged)))
        {
            Cannon.UpdateGunWheels();
        }
    }
}

// Modified to add in the scope turn speed factor if the player is using periscope or binoculars
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local float TurnSpeedFactor;

    if ((DriverPositionIndex == PeriscopePositionIndex || DriverPositionIndex == BinocPositionIndex) && DHPlayer(Controller) != none)
    {
        TurnSpeedFactor = DHPlayer(Controller).DHScopeTurnSpeedFactor;
        YawChange *= TurnSpeedFactor;
        PitchChange *= TurnSpeedFactor;
    }

    super.UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);
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

// New replicated server-to-client function to damage gunsight optics
simulated function ClientDamageCannonOverlay()
{
    GunsightOverlay = DestroyedGunsightOverlay;
}

// Modified to use DHArmoredVehicle instead of deprecated ROTreadCraft
function float ModifyThreat(float Current, Pawn Threat)
{
    local vector to, t;
    local float  r;

    if (Vehicle(Threat) != none)
    {
        Current += 0.2;

        if (DHArmoredVehicle(Threat) != none)
        {
            Current += 0.2;

            // Big bonus points for perpendicular tank targets
            to = Normal(Threat.Location - Location);
            to.z = 0.0;
            t = Normal(vector(Threat.Rotation));
            t.z = 0.0;
            r = to dot t;

            if ((r >= 0.90630 && r < -0.73135) || (r >= -0.73135 && r < 0.90630))
            {
                Current += 0.3;
            }
        }
        else if (ROWheeledVehicle(Threat) != none && ROWheeledVehicle(Threat).bIsAPC)
        {
            Current += 0.1;
        }
    }
    else
    {
        Current += 0.25;
    }

    return Current;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New debug exec to set the coaxial MG's positional offset vector
exec function SetAltFireOffset(string NewX, string NewY, string NewZ)
{
    if (IsDebugModeAllowed() && Gun != none)
    {
        Log(Gun.Tag @ "AltFireOffset =" @ float(NewX) @ float(NewY) @ float(NewZ) @ "(was" @ Gun.AltFireOffset $ ")");
        Gun.AltFireOffset.X = float(NewX);
        Gun.AltFireOffset.Y = float(NewY);
        Gun.AltFireOffset.Z = float(NewZ);

        if (Gun.AmbientEffectEmitter != none)
        {
            Gun.AmbientEffectEmitter.SetRelativeLocation(Gun.AltFireOffset);
        }
    }
}

// New debug exec to set the coaxial MG's launch position optional X offset
exec function SetAltFireSpawnOffset(float NewValue)
{
    if (IsDebugModeAllowed() && Cannon != none)
    {
        Log(Cannon.Tag @ "AltFireSpawnOffsetX =" @ NewValue @ "(was" @ Cannon.AltFireSpawnOffsetX $ ")");
        Cannon.AltFireSpawnOffsetX = NewValue;
    }
}

// New debug exec to toggle bDebugRangeManually, allowing manual calibration of range settings
exec function DebugRange()
{
    if (IsDebugModeAllowed() && Cannon != none)
    {
        Cannon.bDebugRangeManually = !Cannon.bDebugRangeManually;
        Log(Cannon.Tag @ "bDebugRangeManually =" @ Cannon.bDebugRangeManually);
    }
}

// New debug exec to automatically calibrate the current range setting
exec function AutoDebugRange()
{
    if (Cannon != none)
    {
        // If already in this debug mode, running this console command again exits it & destroys the target wall
        if (Cannon.bDebugRangeAutomatically)
        {
            Cannon.bDebugRangeAutomatically = false;
            Cannon.DestroyDebugTargetWall();
        }
        else if (IsDebugModeAllowed())
        {
            Cannon.BeginAutoDebugRange();
        }
    }
}

// New debug exec to set the launch position for a smoke launcher
exec function SetSLFireOffset(string NewX, string NewY, string NewZ)
{
    if (IsDebugModeAllowed() && Cannon != none)
    {
        class'DHVehicleSmokeLauncher'.static.SetFireOffset(Cannon, NewX, NewY, NewZ);
    }
}

// New debug exec to toggle bDebugSights mode, which draws a crosshair on the sights at the exact centre point, to check sights are properly centred
exec function DebugSights()
{
    if (IsDebugModeAllowed())
    {
        bDebugSights = !bDebugSights;
        Log(Tag @ "bDebugSights =" @ bDebugSights);
    }
}

// New debug execs that allow easy tuning of impulse settings for ejected shell cases triggered by an animation notify, which govern how it moves
exec function ShellImpulse(string NewX, string NewY, string NewZ)
{
    if (float(NewX) != 0.0 || float(NewY) != 0.0 || float(NewZ) != 0.0)
    {
        Log("DHAnimNotify_SpawnKActor: DebugImpulse =" @ float(NewX) @ float(NewY) @ float(NewZ) @ " (was" @ class'DHAnimNotify_SpawnKActor'.default.DebugImpulse $ ")");
        class'DHAnimNotify_SpawnKActor'.default.DebugImpulse.X = float(NewX);
        class'DHAnimNotify_SpawnKActor'.default.DebugImpulse.Y = float(NewY);
        class'DHAnimNotify_SpawnKActor'.default.DebugImpulse.Z = float(NewZ);
        class'DHAnimNotify_SpawnKActor'.default.bDebug = true;
    }
    else
    {
        class'DHAnimNotify_SpawnKActor'.default.bDebug = false;
    }
}

exec function ShellAngImpulse(string NewX, string NewY, string NewZ)
{
    if (float(NewX) != 0.0 || float(NewY) != 0.0 || float(NewZ) != 0.0)
    {
        Log("DHAnimNotify_SpawnKActor: DebugAngularImpulse =" @ float(NewX) @ float(NewY) @ float(NewZ) @ " (was" @ class'DHAnimNotify_SpawnKActor'.default.DebugAngularImpulse $ ")");
        class'DHAnimNotify_SpawnKActor'.default.DebugAngularImpulse.X = float(NewX);
        class'DHAnimNotify_SpawnKActor'.default.DebugAngularImpulse.Y = float(NewY);
        class'DHAnimNotify_SpawnKActor'.default.DebugAngularImpulse.Z = float(NewZ);
        class'DHAnimNotify_SpawnKActor'.default.bDebug = true;
    }
    else
    {
        class'DHAnimNotify_SpawnKActor'.default.bDebug = false;
    }
}

exec function LogCannon() // DEBUG (Matt: please use & report the logged result if you ever find you can't fire cannon, coax or SL, or do a reload, when you should be able to)
{
    Log("LOGCANNON: Gun =" @ Gun.Tag @ " VehWep =" @ VehWep.Tag @ " VehWep.WeaponPawn =" @ VehWep.WeaponPawn.Tag @ " Gun.Owner =" @ Gun.Owner.Tag);
    Log("Controller =" @ Controller.Tag @ " DriverPositionIndex =" @ DriverPositionIndex @ " ViewTransition =" @ IsInState('ViewTransition'));
    Log("ReloadState =" @ GetEnum(enum'EReloadState', VehWep.ReloadState) @ " bReloadPaused =" @ VehWep.bReloadPaused
        @ " ProjectileClass =" @ VehWep.ProjectileClass @ " HasAmmoToReload() =" @ VehWep.HasAmmoToReload(VehWep.GetAmmoIndex()));
    Log("AmmoIndex =" @ VehWep.GetAmmoIndex() @ " LocalPendingAmmoIndex =" @ Cannon.LocalPendingAmmoIndex
        @ " ServerPendingAmmoIndex =" @ Cannon.ServerPendingAmmoIndex @ " PrimaryAmmoCount() =" @ VehWep.PrimaryAmmoCount());

    if (bHasAltFire)
    {
        Log("AltReloadState =" @ GetEnum(enum'EReloadState', Cannon.AltReloadState) @ " bAltReloadPaused =" @ Cannon.bAltReloadPaused
            @ " AltAmmoCharge =" @ VehWep.AltAmmoCharge @ " NumMGMags =" @ VehWep.NumMGMags);
    }

    if (Cannon.SmokeLauncherClass != none)
    {
        Log("SmokeLauncherReloadState =" @ GetEnum(enum'EReloadState', Cannon.SmokeLauncherReloadState) @ " bSmokeLauncherReloadPaused =" @ Cannon.bSmokeLauncherReloadPaused
            @ " NumSmokeLauncherRounds =" @ Cannon.NumSmokeLauncherRounds);
    }
}

exec function CalibrateFire(int MilsMin, int MilsMax)
{
    local int Mils;
    local DHBallisticProjectile BP;

    if (Level.NetMode == NM_Standalone)
    {
        for (Mils = MilsMin; Mils < MilsMax; Mils += 10)
        {
            VehWep.CurrentAim.Pitch = class'UUnits'.static.MilsToUnreal(Mils);
            VehWep.CurrentAim.Yaw = 0;

            VehWep.CalcWeaponFire(false);
            BP = DHBallisticProjectile(VehWep.SpawnProjectile(VehWep.ProjectileClass, false));

            if (BP != none)
            {
                BP.bIsCalibrating = true;
                BP.LifeStart = Level.TimeSeconds;
                BP.DebugMils = Mils;
                BP.StartLocation = BP.Location;
            }
        }
    }
}

exec function CorrectX(float NewValue)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        Log(Name @ "OverlayCorrectionX =" @ NewValue @ "(was" @ OverlayCorrectionX $ ")");
        OverlayCorrectionX = NewValue;
    }
}

exec function CorrectY(float NewValue)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        Log(Name @ "OverlayCorrectionY =" @ NewValue @ "(was" @ OverlayCorrectionY $ ")");
        OverlayCorrectionY = NewValue;
    }
}

exec function SetPrimaryAmmo(int Value)
{
    if (IsDebugModeAllowed() && Cannon != none)
    {
        Cannon.MainAmmoChargeExtra[0] = Value;
        Log(Cannon.Tag @ ".MainAmmoChargeExtra[0] =" @ Cannon.MainAmmoChargeExtra[0]);
    }
}

defaultproperties
{
    // Positions & entry
    PositionInArray=0
    bMustBeTankCrew=true
    bMultiPosition=true
    GunsightPositions=1
    UnbuttonedPositionIndex=2
    PeriscopePositionIndex=-1    // -1 signifies no periscope by default
    BinocPositionIndex=3
    IntermediatePositionIndex=-1 // -1 signifies no intermediate position by default
    RaisedPositionIndex=-1       // -1 signifies to match the RPI to the UnbuttonedPositionIndex by default

    // Camera & HUD
    CameraBone="Gun"
    PlayerCameraBone="Camera_com"
    AltAmmoReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
    HudName="Cmdr"

    // Gunsight overlay
    GunsightSize=0.5
    RangeText="metres"
    RangePositionX=0.16
    RangePositionY=0.2

    //Periscope overlay
    PeriscopeSize=0.955 //default for most peri's

    // Turret/cannon movement
    MaxRotateThreshold=1.5
    ManualMinRotateThreshold=0.25
    ManualMaxRotateThreshold=2.5
    PoweredMinRotateThreshold=0.15
    PoweredMaxRotateThreshold=1.75

    // Movement sounds
    bSpecialRotateSounds=true
    ManualRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    ManualPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    ManualRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    SoundVolume=130

    // Weapon fire
    bHasAltFire=true
    bHasFireImpulse=true
    FireImpulse=(X=-90000.0,Y=0.0,Z=0.0)
}
