//==============================================================================
// DH_StuH42MountedMG
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German SturmHaubitze 42 Ausf.G assault gun - remote MG34
//==============================================================================
class DH_StuH42MountedMGPawn extends DH_ROMountedTankMGPawn;


#exec OBJ LOAD FILE=..\textures\DH_VehicleOptics_tex.utx

var     int             InitialPositionIndex; // Initial Gunner Position
var     int             UnbuttonedPositionIndex; // Lowest pos number where player is unbuttoned


// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
simulated function PostBeginPlay()
{
    local vector Offset;
    local vector Loc;

    Super.PostBeginPlay();

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
        if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone ||  Level.Netmode == NM_ListenServer)
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

/* PointOfView()
We don't ever want to allow behindview. It doesn't work with our system - Ramm
*/
simulated function bool PointOfView()
{
    return false;
}


// Overriden to handle mesh swapping when entering the vehicle
simulated function ClientKDriverEnter(PlayerController PC)
{
    Gotostate('EnteringVehicle');
    super.ClientKDriverEnter(PC);

//    log("clientK DriverPos "$DriverPositionIndex);
//  log("clientK PendingPos "$PendingPositionIndex);

    PendingPositionIndex = InitialPositionIndex;
    ServerChangeDriverPos();
    HUDOverlayOffset=default.HUDOverlayOffset;
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    Gotostate('LeavingVehicle');

    Super.ClientKDriverLeave(PC);
}

// Overridden to stop the game dumping players off the tank when they exit while moving
function bool PlaceExitingDriver()
{
    local int i;
    local vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

    Extent = Driver.default.CollisionRadius * vect(1,1,0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0,0,0.5);

    //avoid running driver over by placing in direction perpendicular to velocity
/*  if (VehicleBase != none && VSize(VehicleBase.Velocity) > 100)
    {
        tryPlace = Normal(VehicleBase.Velocity cross vect(0,0,1)) * (VehicleBase.CollisionRadius * 1.25);
        if (FRand() < 0.5)
            tryPlace *= -1; //randomly prefer other side
        if ((VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location + tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == none && Driver.SetLocation(VehicleBase.Location + tryPlace + ZOffset))
             || (VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location - tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == none && Driver.SetLocation(VehicleBase.Location - tryPlace + ZOffset)))
            return true;
    }*/

    for(i=0; i<ExitPositions.Length; i++)
    {
        if (bRelativeExitPos)
        {
            if (VehicleBase != none)
                tryPlace = VehicleBase.Location + (ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;
                else if (Gun != none)
                    tryPlace = Gun.Location + (ExitPositions[i] >> Gun.Rotation) + ZOffset;
                else
                    tryPlace = Location + (ExitPositions[i] >> Rotation);
            }
        else
            tryPlace = ExitPositions[i];

        // First, do a line check (stops us passing through things on exit).
        if (bRelativeExitPos)
        {
            if (VehicleBase != none)
            {
                if (VehicleBase.Trace(HitLocation, HitNormal, tryPlace, VehicleBase.Location + ZOffset, false, Extent) != none)
                    continue;
            }
            else
                if (Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != none)
                    continue;
        }

        // Then see if we can place the player there.
        if (!Driver.SetLocation(tryPlace))
            continue;

        return true;
    }
    return false;
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

            if (Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
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

            if (Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer)
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

        if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
                Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
        }

         // bDrawDriverinTP=true;//Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);

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
                SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim, 1.0),false);
            }
            else
                GotoState('');
        }
        else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
        {
//              if (IsLocallyControlled())
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
            SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionDownAnim, 1.0),false);
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
        Super.RenderOverlays(Canvas);
        //log("PanzerTurret PlayerController was none, returning");
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
    /*
    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering())
        {
            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

            CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
            CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;

            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
            HUDOverlay.SetRotation(CameraRotation);
            Canvas.DrawActor(HUDOverlay, false, true, HUDOverlayFOV);
        }
    }
    else
        ActivateOverlay(false);
    */
    if (PC != none)
        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
}

defaultproperties
{
     UnbuttonedPositionIndex=1
     OverlayCenterSize=0.700000
     MGOverlay=Texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
     FirstPersonGunShakeScale=0.850000
     WeaponFov=41.000000
     DriverPositions(0)=(ViewFOV=41.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer3_com_close",ViewPitchUpLimit=4500,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer3_com_open",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=true)
     bMultiPosition=true
     GunClass=Class'DH_Vehicles.DH_StuH42MountedMG'
     bCustomAiming=true
     bHasAltFire=false
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bDesiredBehindView=false
     DrivePos=(Z=-9.000000)
     DriveAnim="VPanzer3_com_idle_close"
     ExitPositions(0)=(X=-60.000000,Y=80.000000,Z=100.000000)
     ExitPositions(1)=(X=-60.000000,Y=-80.000000,Z=100.000000)
     EntryRadius=130.000000
     FPCamPos=(X=4.000000,Z=-1.500000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-50.000000,Y=25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="on a StuH42 Ausf.G MG34"
     VehicleNameString="StuH42 Ausf.G MG34"
     HUDOverlayFOV=45.000000
     PitchUpLimit=6000
     PitchDownLimit=63500
}
