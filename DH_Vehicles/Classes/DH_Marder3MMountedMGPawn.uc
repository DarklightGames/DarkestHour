//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Marder3MMountedMGPawn extends DH_ROMountedTankMGPawn;

simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector  x, y, z;
    local vector  VehicleZ, CamViewOffsetWorld;
    local float   CamViewOffsetZAmount;
    local rotator WeaponAimRot;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = Gun.GetBoneRotation(CameraBone);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    CameraRotation =  WeaponAimRot;

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CameraLocation = Gun.GetBoneCoords('loader_cam').Origin;

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

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector  CameraLocation;
    local rotator CameraRotation;
    local Actor   ViewActor;
    local vector  GunOffset;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering())
        {
            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

            CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
            GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;

            // Make the first person gun appear lower when your sticking your head up
            GunOffset.Z += (((Gun.GetBoneCoords('firstperson_wep').Origin.Z - CameraLocation.Z) * 1.0));
            GunOffset += HUDOverlayOffset;

            // Not sure if we need this, but the HudOverlay might lose network relevancy if its location doesn't get updated - Ramm
            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));

            Canvas.DrawBoundActor(HUDOverlay, false, true, HUDOverlayFOV, CameraRotation, PC.ShakeRot * FirstPersonGunShakeScale, GunOffset * -1.0);
        }
    }
    else
    {
        ActivateOverlay(false);
    }

    if (PC != none)
    {
        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
        }
    }
}

defaultproperties
{
    UnbuttonedPositionIndex=0
    FirstPersonGunShakeScale=2.0
    WeaponFOV=60.0
    DriverPositions(0)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.Marder_M34_int',TransitionUpAnim="loader_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=true)
    DriverPositions(1)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.Marder_M34_int',TransitionDownAnim="loader_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=true)
    bMultiPosition=true
    GunClass=class'DH_Vehicles.DH_Marder3MMountedMG'
    bCustomAiming=true
    bHasAltFire=false
    CameraBone="loader_cam"
    bPCRelativeFPRotation=true
    bAllowViewChange=true
    DrivePos=(X=7.0,Z=-22.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VHalftrack_com_idle"
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-50.0,Y=25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    HUDOverlayClass=class'DH_Vehicles.DH_Stug3GOverlayMG'
    HUDOverlayFOV=45.0
    PitchUpLimit=6000
    PitchDownLimit=63500
}
