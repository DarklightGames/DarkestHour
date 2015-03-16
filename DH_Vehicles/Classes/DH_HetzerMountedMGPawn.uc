//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HetzerMountedMGPawn extends DH_ROMountedTankMGPawn;

// Can't fire unless buttoned up & controlling the remote MG
function bool CanFire()
{
    return DriverPositionIndex < UnbuttonedPositionIndex && !IsInState('ViewTransition');
}

// So that MG reloads on pressing 'reload' key (which calls this function)
exec function ROManualReload()
{
    local DH_HetzerMountedMG MG;

    MG = DH_HetzerMountedMG(Gun);

    if (MG != none && MG.NumMags > 0 && (MG.MGReloadState == MG_Waiting || MG.MGReloadState == MG_ReadyToFire))
    {
        if (DriverPositionIndex >= UnbuttonedPositionIndex && !IsInState('ViewTransition'))
        {
            MG.ServerManualReload();
        }
        else
        {
            ReceiveLocalizedMessage(class'DH_HetzerVehicleMessage', 1); // "You must open the hatch to reload the MG"
        }
    }
}

// Modified to replicate the MG's current reload state (the basis of this is in ROTankCannonPawn)
function KDriverEnter(Pawn P)
{
    super(VehicleWeaponPawn).KDriverEnter(P);

    if (Gun != none && DH_HetzerMountedMG(Gun) != none)
    {
        DH_HetzerMountedMG(Gun).ClientSetReloadState(DH_HetzerMountedMG(Gun).MGReloadState);
    }
}

// Modified to prevent the player from unbuttoning if the MG is not turned sideways (otherwise it will be blocking the hatch, due to hetzer's small size)
simulated function NextWeapon()
{
    if (Abs(Gun.CurrentAim.Yaw) < (10700) || Abs(Gun.CurrentAim.Yaw) > (22700))
    {
        PlayerController(Controller).ReceiveLocalizedMessage(class'DH_HetzerVehicleMessage', 3); // "The MG is blocking the hatch - turn it sideways to open"

        return;
    }

    super.NextWeapon();
}

// Modified to run state 'ViewTransition' on server when buttoning up, so transition down anim plays on server & puts loader's collision box in correct position
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
            // Run the state on the server whenever we're unbuttoning in order to prevent early exit
            else if (Level.NetMode == NM_DedicatedServer)
            {
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                {
                    GoToState('ViewTransition');
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
            // Added this section to run the state 'ViewTransition' on the server when buttoning up
            else if (Level.NetMode == NM_DedicatedServer)
            {
                if (LastPositionIndex == UnbuttonedPositionIndex)
                {
                    GoToState('ViewTransition');
                }
            }
        }
    }
}

// Modified so if player buttons up & is now on the gun, rotation is set to match the direction MG is facing (after looking around while unbuttoned)
simulated state ViewTransition
{
    simulated function EndState()
    {
        super.EndState();

        if (DriverPositionIndex < UnbuttonedPositionIndex)
        {
            MatchRotationToGunAim();
        }
    }
}

// Modified from StuH so that unbuttoned player can look around, similar to a CannonPawn
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector  x, y, z;
    local vector  VehicleZ, CamViewOffsetWorld;
    local float   CamViewOffsetZAmount;
    local coords  CamBoneCoords;
    local rotator WeaponAimRot;
    local quat    AQuat, BQuat, CQuat;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = Gun.GetBoneRotation(CameraBone);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    // In StuH the camera rotation always =WeaponAimRot - this modification only does that if player is buttoned up & controlling remote MG
    if (DriverPositionIndex < UnbuttonedPositionIndex && !IsInState('ViewTransition'))
    {
        CameraRotation =  WeaponAimRot;
    }
    // Will now use this 'free look around' code when unbuttoned, similar to a tank cannon pawn
    else if (bPCRelativeFPRotation)
    {
        // First, rotate the headbob by the PlayerController's rotation (looking around)
        AQuat = QuatFromRotator(PC.Rotation);
        BQuat = QuatFromRotator(HeadRotationOffset - ShiftHalf);
        CQuat = QuatProduct(AQuat,BQuat);

        // Then, rotate that by the vehicle's rotation to get the final rotation
        AQuat = QuatFromRotator(VehicleBase.Rotation);
        BQuat = QuatProduct(CQuat,AQuat);

        // Finally make it back into a rotator
        CameraRotation = QuatToRotator(BQuat);
    }
    else
    {
        CameraRotation = PC.Rotation;
    }

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CamBoneCoords = Gun.GetBoneCoords(CameraBone);

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && DriverPositionIndex == 0 && !IsInState('ViewTransition'))
        {
            CameraLocation = CamBoneCoords.Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }
        else
        {
//          CameraLocation = Gun.GetBoneCoords('loader_cam').Origin; // replaced by extended line below, making use of ViewLocation camera adjustment in DriverPosition 1
            CameraLocation = Gun.GetBoneCoords('loader_cam').Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0.0, 0.0, 1.0) >> WeaponAimRot;
            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }
    else
    {
        CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0.0, 0.0, 1.0) >> Rotation;
            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

// Modified to use hetzer's 4 part MG rleoad process
function float GetAmmoReloadState()
{
    if (DH_HetzerMountedMG(Gun) != none)
    {
        switch (DH_HetzerMountedMG(Gun).MGReloadState)
        {
            case MG_ReadyToFire:    return 0.00;
            case MG_Waiting:
            case MG_Empty:
            case MG_ReloadedPart1:  return 1.00;
            case MG_ReloadedPart2:  return 0.65;
            case MG_ReloadedPart3:  return 0.45;
            case MG_ReloadedPart4:  return 0.25;
        }
    }

    return 0.0;
}

defaultproperties
{
    OverlayCenterSize=0.7
    MGOverlay=texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
    FirstPersonGunShakeScale=0.85
    WeaponFOV=41.0
    DriverPositions(0)=(ViewFOV=41.0,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_mg',TransitionUpAnim="loader_open",DriverTransitionAnim="VT60_com_close",ViewPitchUpLimit=4500,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=5.0,Z=8.0),ViewFOV=80.0,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_mg',TransitionDownAnim="loader_close",DriverTransitionAnim="VT60_com_open",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    bMultiPosition=true
    GunClass=class'DH_Vehicles.DH_HetzerMountedMG'
    bCustomAiming=true
    bHasAltFire=false
    CameraBone="Gun"
    bPCRelativeFPRotation=true
    bDesiredBehindView=false
    bFPNoZFromCameraPitch=true
    DrivePos=(X=17.0,Y=6.0,Z=-1.5)
    DriveAnim="VT60_com_idle_close"
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-50.0,Y=25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
}
