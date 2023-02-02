//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ChurchillMountedMGPawn extends DHVehicleMGPawn; // TODO: make this extra functionality generic in DHVehicleMGPawn and/or DHVehicleWeaponPawn

var     int         PeriscopePositionIndex;
var     texture     PeriscopeOverlay;

// Can't fire if on binoculars or if moving between positions
function bool CanFire()
{
    return (DriverPositionIndex != BinocPositionIndex && !IsInState('ViewTransition')) || !IsHumanControlled();
}

// Modified to only use the position 0 for the gunsight, as player can fire the gun in other 'look around' positions (also some redundancy removed)
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat RelativeQuat, VehicleQuat, NonRelativeQuat;

    ViewActor = self;

    if (PC == none || Gun == none)
    {
        return;
    }

    // Player is on the gunsight, so use GunsightCameraBone & use MG's aim for camera rotation
    if (DriverPositionIndex == 0 && !IsInState('ViewTransition'))
    {
        CameraLocation = Gun.GetBoneCoords(GunsightCameraBone).Origin;
        CameraRotation = Gun.CurrentAim;
    }
    // Otherwise, player can look around, so use CameraBone & use PC's rotation for camera rotation
    else
    {
        CameraLocation = Gun.GetBoneCoords(CameraBone).Origin;
        CameraRotation = PC.Rotation;
    }

    // CameraRotation is currently relative to vehicle, so now factor in the vehicle's rotation (note Gun.Rotation is same as vehicle base)
    RelativeQuat = QuatFromRotator(Normalize(CameraRotation));
    VehicleQuat = QuatFromRotator(Gun.Rotation);
    NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
    CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));

    // Adjust camera location for any offset positioning
    if (FPCamPos != vect(0.0, 0.0, 0.0))
    {
        if (DriverPositionIndex == 0 && !IsInState('ViewTransition'))
        {
            CameraLocation += FPCamPos >> CameraRotation;
        }
        else if (!IsInState('ViewTransition')) // added check to stop periscope offset being applied while transitioning from periscope to gunsight
        {
            CameraLocation += FPCamPos >> Gun.Rotation;
        }
    }

    // Finalise the camera with any shake
    CameraLocation += PC.ShakeOffset >> PC.Rotation;
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Modified to handle drawing periscope overlay (also some redundancy removed)
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local float            SavedOpacity;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            // Save current HUD opacity & then set up for drawing overlays
            SavedOpacity = C.ColorModulate.W;
            C.ColorModulate.W = 1.0;
            C.DrawColor.A = 255;
            C.Style = ERenderStyle.STY_Alpha;

            if (DriverPositionIndex == 0)
            {
                DrawGunsightOverlay(C);
            }
            else if (DriverPositionIndex == PeriscopePositionIndex)
            {
                DrawPeriscopeOverlay(C);
            }
            else if (DriverPositionIndex == BinocPositionIndex)
            {
                DrawBinocsOverlay(C);
            }

            C.ColorModulate.W = SavedOpacity; // reset HUD opacity to original value
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, VehicleBase, self);
        }
    }
}

// New function to draw periscope overlay (from DHVehicleCannonPawn)
simulated function DrawPeriscopeOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = float(C.SizeY) / float(C.SizeX);
    C.SetPos(0.0, 0.0);
    C.DrawTile(PeriscopeOverlay, C.SizeX, C.SizeY, 0.0, (1.0 - ScreenRatio) * float(PeriscopeOverlay.VSize) / 2.0, PeriscopeOverlay.USize, float(PeriscopeOverlay.VSize) * ScreenRatio);
}

// Modified so when unbuttoned, the MG only moves with player's view if it's within the gun's traverse limits (player's view may look wider than this)
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local DHPlayer PC;
    local float    MaxChange;
    local bool     bMoveTheMG;

    PC = DHPlayer(Controller);

    if (PC == none || Gun == none)
    {
        return;
    }

    // If player can fire the MG, we apply his ironsight turn speed reduction so it feels the same as aiming the infantry version of the same MG
    if (CanFire())
    {
        YawChange *= PC.DHISTurnSpeedFactor;
        PitchChange *= PC.DHISTurnSpeedFactor;

        // Limit rotation speed of MG to it's specified RotationsPerSecond, so 1st person movement matches 3rd person limits
        MaxChange = Gun.RotationsPerSecond * 2048.0;
        YawChange = FClamp(YawChange, -MaxChange, MaxChange);
        PitchChange = FClamp(PitchChange, -MaxChange, MaxChange);

        // When unbuttoned, stop MG moving with player's view if his view moves away from the gun (e.g. looking wider than its traverse limit or looking away on binocs)
        // When his view then moves back to the gun he takes control of its aim again & it moves normally (the 100 rotational UU is a tolerated difference threshold)
        if (DriverPositionIndex < UnbuttonedPositionIndex || Abs(Rotation.Yaw - Gun.CurrentAim.Yaw) < 100)
        {
            bMoveTheMG = true;
        }
    }
    // If player is using binoculars, we apply his scope turn speed reduction
    else if (DriverPositionIndex == BinocPositionIndex)
    {
        YawChange *= PC.DHScopeTurnSpeedFactor;
        PitchChange *= PC.DHScopeTurnSpeedFactor;
    }

    // Update native custom aim (even if we stop the MG from moving, a null custom aim update is necessary)
    if (bMoveTheMG)
    {
        UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);
    }
    else
    {
        UpdateSpecialCustomAim(DeltaTime, 0.0, 0.0);
    }

    PC.WeaponBufferRotation.Yaw = CustomAim.Yaw;
    PC.WeaponBufferRotation.Pitch = CustomAim.Pitch;

    super(VehicleWeaponPawn).UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange); // updates weapon pawn's rotation
}

// Modified so if player unbuttons, coming off periscope where he had a fixed view, we match his view rotation back to direction MG is facing
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        super.HandleTransition();

        if (DriverPositionIndex == UnbuttonedPositionIndex && LastPositionIndex == PeriscopePositionIndex && IsFirstPerson())
        {
            SetRotation(Gun.CurrentAim);
        }
    }
}

// Modified to include any overlay position, which for this MG includes the periscope position as well as the gunsight & binoculars
simulated function bool ShouldViewSnapInPosition(byte PositionIndex)
{
    return super(DHVehicleWeaponPawn).ShouldViewSnapInPosition(PositionIndex);
//  return DriverPositions[PositionIndex].bDrawOverlays && (PositionIndex == 0 || PositionIndex == PeriscopePositionIndex || PositionIndex == BinocPositionIndex); // would be a 'pure' override
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ChurchillMountedMG'
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=44.74,ViewLocation=(X=10.0,Y=-7.0,Z=0.0),TransitionUpAnim="MG_periscope_in",ViewPitchDownLimit=65535,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=10.0,Y=1.0,Z=11.5),TransitionUpAnim="MG_hatch_open",TransitionDownAnim="MG_periscope_out",ViewPitchDownLimit=65535,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=2000,bDrawOverlays=true)
    DriverPositions(2)=(TransitionDownAnim="MG_hatch_close",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=59000,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=59000,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=2
    BinocPositionIndex=3
    bDrawDriverInTP=true
    DriveAnim="VPanzer3_driver_idle_open"
    CameraBone="camera_MG"
    GunsightCameraBone="MG_pivot"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.British.BesaMG_sight'
    GunsightSize=0.469 // 21 degrees visible FOV at 1.9x magnification (No.50 x1.9 Mk IS sight)
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_Allied'
}
