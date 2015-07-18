//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flakvierling38CannonPawn extends DHATGunCannonPawn;

// Emptied out as shells inherits RangeSettings from Sd.Kfz.234/1 armored car, but flakvierling has no range settings on the gunsight:
function IncrementRange();
function DecrementRange();

// Modified to update sight & aiming wheel rotation, if gun has moved
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

    if (Level.NetMode != NM_DedicatedServer && ((YawChange != 0.0 && !bTurretRingDamaged) || (PitchChange != 0.0 && !bGunPivotDamaged)) && DH_Flakvierling38Cannon(Gun) != none)
    {
        DH_Flakvierling38Cannon(Gun).UpdateSightAndWheelRotation();
    }
}

// Matt: hack solution to workaround maddening problem in single player or on listen server, where view yaw on gunsight is wrong & high pitch even starts to turn the gun !
// Problem is in calculation of CameraRotation when on gunsights, so this hack reverts back to an old, inferior calculation to apply vehicle's rotation, without using quats
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
    if (DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition') && CameraBone !='')
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
            bCameraRotationNotRelative = true;
        }
        // Otherwise, player can look around
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
        // Hack so in single player or on listen server, we use this old, inferior calculation
        if ((Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && bOnGunsight)
        {
            CameraRotation = rotator(vector(CameraRotation) >> Gun.Rotation);
            CameraRotation.Roll =  VehicleBase.Rotation.Roll;
        }
        else
        {
            RelativeQuat = QuatFromRotator(Normalize(CameraRotation));
            VehicleQuat = QuatFromRotator(Gun.Rotation);
            NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
            CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));
        }
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

defaultproperties
{
    OverlayCenterSize=1.0
    CannonScopeOverlay=texture'DH_Artillery_tex.ATGun_Hud.Flakvierling38_sight'
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    RaisedPositionIndex=2
    DriverPositions(0)=(ViewLocation=(X=30.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret',TransitionUpAnim="optic_out",DriverTransitionAnim="Vt3485_driver_idle_close",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret',TransitionUpAnim="lookover_up",TransitionDownAnim="optic_in",DriverTransitionAnim="Vt3485_driver_idle_close",bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret',TransitionDownAnim="lookover_down",DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=18.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_Flakvierling38Cannon'
    CameraBone="Camera_com"
    DriveAnim="Vt3485_driver_idle_close"
}
