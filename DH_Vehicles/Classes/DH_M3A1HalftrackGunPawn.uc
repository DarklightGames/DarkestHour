//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M3A1HalftrackGunPawn extends DH_ROMountedTankMGPawn;

/* PointOfView()
We don't ever want to allow behindview. It doesn't work with our system - Ramm
*/
simulated function bool PointOfView()
{
    return false;
}

simulated function ClientKDriverEnter(PlayerController PC)
{
    Gotostate('EnteringVehicle');

    super.ClientKDriverEnter(PC);

    HUDOverlayOffset=default.HUDOverlayOffset;
}

simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector x, y, z;
    local vector VehicleZ, CamViewOffsetWorld;
    local float CamViewOffsetZAmount;
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
        CameraLocation = Gun.GetBoneCoords('Camera_com').Origin;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0,0,1) >> WeaponAimRot;

            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }
    else
    {
        CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0,0,1) >> Rotation;
            CamViewOffsetZAmount = CamViewOffsetWorld Dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

function UpdateRocketAcceleration(float deltaTime, float YawChange, float PitchChange)
{
    local rotator NewRotation;

    NewRotation = Rotation;
    NewRotation.Yaw += 32.0 * deltaTime * YawChange;
    NewRotation.Pitch += 32.0 * deltaTime * PitchChange;
    NewRotation.Pitch = LimitPitch(NewRotation.Pitch);

    SetRotation(NewRotation);

    UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);

    if (ROPlayer(Controller) != none)
    {
         ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
         ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    local vector GunOffset;

    PC = PlayerController(Controller);

    // Zap the lame crosshair - Ramm
/*  if (IsLocallyControlled() && Gun != none && Gun.bCorrectAim)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
        Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
    }  */


    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering())
        {

            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

            CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
            GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;

            // Make the first person gun appear lower when your sticking your head up
 //           GunOffset.z += (((Gun.GetBoneCoords('1stperson_wep').Origin.Z - CameraLocation.Z) * 3));
            GunOffset.z += (((Gun.GetBoneCoords('1stperson_wep').Origin.Z - CameraLocation.Z) * 1));    //****************************************************
            GunOffset += HUDOverlayOffset;

            // Not sure if we need this, but the HudOverlay might lose network relevancy if its location doesn't get updated - Ramm
            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));

            Canvas.DrawBoundActor(HUDOverlay, false, true,HUDOverlayFOV,CameraRotation,PC.ShakeRot*FirstPersonGunShakeScale,GunOffset*-1);
         }
    }
    else
        ActivateOverlay(false);

    if (PC != none)
        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
}

// Hack - Turn off the muzzle flash in first person when your head is sticking up since it doesn't look right
simulated state ViewTransition
{
    simulated function BeginState()
    {
        if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositionIndex > 0)
            {
              Gun.AmbientEffectEmitter.bHidden = true;
            }
        }

        super.BeginState();
    }

    simulated function EndState()
    {
        if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositionIndex == 0)
            {
              Gun.AmbientEffectEmitter.bHidden = false;
            }
        }

        super.EndState();
    }
}

// Overridden to give players the same momentum as their vehicle had when exiting
// Adds a little height kick to allow for hacked in damage system
function bool KDriverLeave(bool bForceLeave)
{
    local vector OldVel;
    local bool   bSuperDriverLeave;

    OldVel = Velocity;

    bSuperDriverLeave = super.KDriverLeave(bForceLeave);

    OldVel.Z += 50;
    Instigator.Velocity = OldVel;

    return bSuperDriverLeave;
}

defaultproperties
{
     FirstPersonGunShakeScale=0.750000
     WeaponFov=60.000000
     DriverPositions(0)=(ViewFOV=60.000000,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',TransitionUpAnim="com_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bExposed=true)
     DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',TransitionDownAnim="com_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bExposed=true)
     bMultiPosition=true
     bMustBeTankCrew=false
     GunClass=class'DH_Vehicles.DH_M3A1HalftrackGun'
     bCustomAiming=true
     PositionInArray=0
     bHasAltFire=false
     CameraBone="Camera_com"
     bDesiredBehindView=false
     DrivePos=(Y=-5.000000,Z=14.000000)
     DriveRot=(Yaw=16384)
     DriveAnim="VHalftrack_com_idle"
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="on a M3A1 Halftrack .30 Cal"
     VehicleNameString="M3A1 Halftrack .30 Cal"
     HUDOverlayClass=class'DH_Vehicles.DH_M3A1HalftrackMGOverlay'
     HUDOverlayOffset=(X=-2.000000)
     HUDOverlayFOV=35.000000
     bKeepDriverAuxCollision=true
     PitchUpLimit=4000
     PitchDownLimit=60000
}
