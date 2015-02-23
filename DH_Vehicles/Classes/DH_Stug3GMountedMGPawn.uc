//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Stug3GMountedMGPawn extends DH_ROMountedTankMGPawn;

var     int             InitialPositionIndex; // Initial Gunner Position
var     int             UnbuttonedPositionIndex; // Lowest pos number where player is unbuttoned

// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
simulated function PostBeginPlay()
{
    local vector Offset;
    local vector Loc;

    super.PostBeginPlay();

    Offset.Z += 220;
    Loc = GetBoneCoords('loader_player').ZAxis;

    ExitPositions[0] = Loc + Offset;
    ExitPositions[1] = ExitPositions[0];
}

simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
            //if (DriverPositions[0].PositionMesh != none)
            //  LinkMesh(DriverPositions[0].PositionMesh);
        if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone ||  Level.NetMode == NM_ListenServer)
        {
            if (DriverPositions[InitialPositionIndex].PositionMesh != none && Gun != none)
            {
                Gun.LinkMesh(DriverPositions[InitialPositionIndex].PositionMesh);
            }
        }

        if (Gun.HasAnim(Gun.BeginningIdleAnim))
        {
            Gun.PlayAnim(Gun.BeginningIdleAnim);
        }

        WeaponFOV = DriverPositions[InitialPositionIndex].ViewFOV;
        PlayerController(Controller).SetFOV(WeaponFOV);

        FPCamPos = DriverPositions[InitialPositionIndex].ViewLocation;
    }

Begin:
    HandleEnter();
    Sleep(0.2);
    GotoState('');
}

simulated function bool PointOfView()
{
    return false;
}

// Overridden to handle mesh swapping when entering the vehicle
simulated function ClientKDriverEnter(PlayerController PC)
{
    GotoState('EnteringVehicle');

    super.ClientKDriverEnter(PC);

    PendingPositionIndex = InitialPositionIndex;
    ServerChangeDriverPos();

    HUDOverlayOffset=default.HUDOverlayOffset;
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    GotoState('LeavingVehicle');

    super.ClientKDriverLeave(PC);
}

function bool KDriverLeave(bool bForceLeave)
{
    local bool bSuperDriverLeave;

    if (!bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')))
    {
        Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4);
        return false;
    }
    else
    {
        DriverPositionIndex=InitialPositionIndex;
        bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);

        VehicleBase.MaybeDestroyVehicle();
        return bSuperDriverLeave;
    }
}

function ServerChangeDriverPos()
{
    DriverPositionIndex = InitialPositionIndex;
}

// Overridden here to force the server to go to state "ViewTransition", used to prevent players exiting before the unbutton anim has finished
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

            if (Level.NetMode == NM_DedicatedServer)
            {
                // Run the state on the server whenever we're unbuttoning in order to prevent early exit
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                    GoToState('ViewTransition');
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
        }
     }
}

simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        StoredVehicleRotation = VehicleBase.Rotation;

        if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
                Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
        }

        //bDrawDriverinTP=true; //Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);

        if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim)
            && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
        {
            Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
        }

        WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

        FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
        //FPCamViewOffset = DriverPositions[DriverPositionIndex].ViewOffset; // depractated

        if (DriverPositionIndex != 0)
        {
            if (DriverPositions[DriverPositionIndex].bDrawOverlays)
                PlayerController(Controller).SetFOV(WeaponFOV);
            else
                PlayerController(Controller).DesiredFOV = WeaponFOV;
        }

        if (LastPositionIndex < DriverPositionIndex)
        {
            if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
            {
//                  if (IsLocallyControlled())
                    Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim, 1.0), false);
            }
            else
                GotoState('');
        }
        else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
        {
//              if (IsLocallyControlled())
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
            SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionDownAnim, 1.0), false);
        }
        else
        {
            GotoState('');
        }
    }

    simulated function Timer()
    {
        GotoState('');
    }

    simulated function AnimEnd(int channel)
    {
        if (IsLocallyControlled())
            GotoState('');
    }

    simulated function EndState()
    {
        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            //PlayerController(Controller).SetRotation(Gun.GetBoneRotation('Camera_com'));
        }
    }

Begin:
    HandleTransition();
    Sleep(0.2);
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
        //limit view of gunner while inside tank
        if (DriverPositionIndex == 0 && !IsInState('ViewTransition'))
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = 0;
            ROPlayer(Controller).WeaponBufferRotation.Pitch = 0;
        }
        else
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
            ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
        }
    }

    CameraRotation = WeaponAimRot;

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
        //limit view of gunner while inside tank
        if (DriverPositionIndex == 0 && !IsInState('ViewTransition'))
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = 0;
            ROPlayer(Controller).WeaponBufferRotation.Pitch = 0;
        }
        else
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
            ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
        }
    }
}

// Gunner cannot fire MG when he is buttoned inside tank (because he's not mounted on the damn gun!)
function Fire(optional float F)
{
    if (DriverPositionIndex == 0 && ROPlayer(Controller) != none)
    {
        return;
    }

    super.Fire(F);
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    local vector GunOffset;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering() && DriverPositionIndex > 0)
        {

            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
            CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
            GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;

            // Make the first person gun appear lower when your sticking your head up
            GunOffset.z += (((Gun.GetBoneCoords('firstperson_wep').Origin.Z - CameraLocation.Z) * 3));
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
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
}

defaultproperties
{
    UnbuttonedPositionIndex=1
    FirstPersonGunShakeScale=2.0
    WeaponFOV=72.0
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_ext',TransitionUpAnim="loader_unbutton",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionUpAnim="loader_open",TransitionDownAnim="loader_button",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionDownAnim="loader_close",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=true)
    bMultiPosition=true
    GunClass=class'DH_Vehicles.DH_Stug3GMountedMG'
    bCustomAiming=true
    bHasAltFire=false
    CameraBone="loader_cam"
    bPCRelativeFPRotation=true
    bDesiredBehindView=false
    DrivePos=(X=16.0,Z=20.0)
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
