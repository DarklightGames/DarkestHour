//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuH42MountedMGPawn extends DH_ROMountedTankMGPawn;

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx

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

// Commander cannot fire cannon when unbutonned
function Fire(optional float F)
{
    if (DriverPositionIndex == 1 && ROPlayer(Controller) != none)
    {
        return;
    }

    super.Fire(F);
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

        ROVehicle(GetVehicleBase()).MaybeDestroyVehicle();
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

// modification allowing dual-magnification optics is here (look for "GunsightPositions")
simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector x, y, z;
    local vector VehicleZ, CamViewOffsetWorld;
    local float CamViewOffsetZAmount;
    local coords CamBoneCoords;
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
        CamBoneCoords = Gun.GetBoneCoords(CameraBone);

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && DriverPositionIndex == 0 && !IsInState('ViewTransition'))
        {
            CameraLocation = CamBoneCoords.Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }
        else
        {
            CameraLocation = Gun.GetBoneCoords('loader_cam').Origin;
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

//Hacked in for Texture overlay
simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local float SavedOpacity;
    local float scale;

    local float ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    PC = PlayerController(Controller);
    if (PC == none)
    {
        super.RenderOverlays(Canvas);
        //Log("PanzerTurret PlayerController was none, returning");
        return;
    }
    else if (!PC.bBehindView)
    {
        // store old opacity and set to 1.0 for map overlay rendering
        SavedOpacity = Canvas.ColorModulate.W;
        Canvas.ColorModulate.W = 1.0;

        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        scale = Canvas.SizeY / 1200.0;

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            if (DriverPositionIndex == 0)
            {

             // Draw reticle
             ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
             OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
             OverlayCenterTexStart = (1 - OverlayCenterScale) * float(MGOverlay.USize) / 2;
             OverlayCenterTexSize =  float(MGOverlay.USize) * OverlayCenterScale;

             Canvas.SetPos(0, 0);
             Canvas.DrawTile(MGOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

             // reset HudOpacity to original value
             Canvas.ColorModulate.W = SavedOpacity;
            }
        }
    }

    if (PC != none)
        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
}

defaultproperties
{
    UnbuttonedPositionIndex=1
    OverlayCenterSize=0.700000
    MGOverlay=texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
    FirstPersonGunShakeScale=0.850000
    WeaponFOV=41.000000
    DriverPositions(0)=(ViewFOV=41.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer3_com_close",ViewPitchUpLimit=4500,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer3_com_open",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=true)
    bMultiPosition=true
    GunClass=class'DH_Vehicles.DH_StuH42MountedMG'
    bCustomAiming=true
    bHasAltFire=false
    CameraBone="Gun"
    bPCRelativeFPRotation=true
    bDesiredBehindView=false
    DrivePos=(Z=-9.000000)
    DriveAnim="VPanzer3_com_idle_close"
    EntryRadius=130.000000
    FPCamPos=(X=4.000000,Z=-1.500000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-50.000000,Y=25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    HUDOverlayFOV=45.000000
    PitchUpLimit=6000
    PitchDownLimit=63500
}
