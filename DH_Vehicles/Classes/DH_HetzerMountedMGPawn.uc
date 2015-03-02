//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HetzerMountedMGPawn extends DH_ROMountedTankMGPawn;

var    int    UnbuttonedPositionIndex; // Matt: lowest position number where player is unbuttoned

// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
simulated function PostBeginPlay() // Matt: modified to lower the loader's exit position above the roof
{
    local vector Offset;
    local vector Loc;

    super.PostBeginPlay();

    Offset.Z += 150; // Matt: this was 220 but the exit was a long way above the roof
    Loc = GetBoneCoords('loader_player').ZAxis;

    ExitPositions[0] = Loc + Offset;
    ExitPositions[1] = ExitPositions[0];
}

// Matt: modified to prevent MG firing if player is unbuttoned or in the process of unbuttoning or buttoning up (with custom message)
function Fire(optional float F)
{
    if ((DriverPositionIndex >= UnbuttonedPositionIndex || IsInState('ViewTransition')) && ROPlayer(Controller) != none)
    {
        PlayerController(Controller).ReceiveLocalizedMessage(class'DH_HetzerVehicleMessage', 2); // "You cannot fire the MG while unbuttoned"
        return;
    }

    super.Fire(F);
}

// Matt: added so that MG reloads on pressing 'reload' key (which calls this function)
simulated exec function ROManualReload()
{
    if (Gun != none && DH_HetzerMountedMG(gun) != none)
    {
        if (DriverPositionIndex >= UnbuttonedPositionIndex && !IsInState('ViewTransition'))
            DH_HetzerMountedMG(gun).ServerManualReload();
        else
            PlayerController(Controller).ReceiveLocalizedMessage(class'DH_HetzerVehicleMessage', 1); // "You must open the hatch to reload the MG"
    }
}

// Matt: modified to replicate the MG's current reload state (the basis of this is in ROTankCannonPawn)
// Matt: also so rotation is set to Gun.CurrentAim, which makes player face the way the MG is facing, relative to the tank's rotation (then bPCRelativeFPRotation works correctly, including player exit direction)
function KDriverEnter(Pawn P)
{
    local rotator NewRotation;

    super(VehicleWeaponPawn).KDriverEnter(P);

    NewRotation = Gun.CurrentAim;
    NewRotation.Pitch = LimitPitch(NewRotation.Pitch);
    SetRotation(NewRotation);

    if (Gun != none && DH_HetzerMountedMG(gun) != none)
        DH_HetzerMountedMG(gun).ClientSetReloadState(DH_HetzerMountedMG(gun).MGReloadState);
}

// Matt: modified so rotation is set to Gun.CurrentAim, which makes the player face the way the MG is facing, relative to the tank's rotation
// then bPCRelativeFPRotation works correctly, including player exit direction
simulated function ClientKDriverEnter(PlayerController PC)
{
    local rotator NewRotation;

    super(ROVehicleWeaponPawn).ClientKDriverEnter(PC);

    PC.SetFOV(WeaponFOV);
    NewRotation = Gun.CurrentAim;
    NewRotation.Pitch = LimitPitch(NewRotation.Pitch);
    SetRotation(NewRotation);
}

// Matt: modified to prevent tank crew from switching to rider positions unless unbuttoned
function ServerChangeDriverPosition(byte F)
{
    // Matt: if trying to switch to vehicle position 4 or 5, which are the rider positions, and player is buttoned up or in the process of buttoning/ubuttoning
    if (F > 3 && (DriverPositionIndex < UnbuttonedPositionIndex || IsInState('ViewTransition')))
    {
        Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4); // "You Must Unbutton the Hatch to Exit"
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// Matt: was in StuH (taken from DH_ROTankCannonPawn) - I've modified to play idle animation on the server as a workaround to stop the collision box glitch on the roof
function bool KDriverLeave(bool bForceLeave)
{
    local bool bSuperDriverLeave;

    if (!bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')))
    {
        Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4); // "You Must Unbutton the Hatch to Exit"
        return false;
    }

    DriverPositionIndex = 0;
    bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);
    VehicleBase.MaybeDestroyVehicle();

    if (bSuperDriverLeave && Gun.HasAnim(Gun.BeginningIdleAnim)) // Matt: added to play idle animation on the server to stop the collision box glitch on the roof
        Gun.PlayAnim(Gun.BeginningIdleAnim);

    return bSuperDriverLeave;
}

// Matt: modified to prevent the player from unbuttoning if the MG is not turned sideways (otherwise it will be blocking the hatch, due to hetzer's small size)
simulated function NextWeapon()
{
//    Matt: these values correspond, in clockface directions, to "if Yaw < 1:58 or Yaw > 4:09", plus the reverse of those
    if (abs(Gun.CurrentAim.Yaw) < (10700) || abs(Gun.CurrentAim.Yaw) > (22700))
    {
        PlayerController(Controller).ReceiveLocalizedMessage(class'DH_HetzerVehicleMessage', 3); // "The MG is blocking the hatch - turn it sideways to open"
        return;
    }

    super.NextWeapon();
}

// Matt: modified to run the state 'ViewTransition' on the server when buttoning up, so the transition down anim plays on the server & puts the loader's collision box in correct position
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

            if (Level.NetMode == NM_DedicatedServer) // Matt: added this section to run the state 'ViewTransition' on the server when buttoning up
            {
                if (LastPositionIndex == UnbuttonedPositionIndex)
                    GoToState('ViewTransition');
            }
         }
    }
}

// Matt: modified so that when buttoning up the pawn rotation is set to match the direction the MG is facing
simulated state ViewTransition
{
    simulated function AnimEnd(int channel)
    {
        if (IsLocallyControlled()) // Matt: the StuH (taking the function from DH_ROTankCannonPawn) just adds this 'if'
            GotoState('');
    }

       simulated function EndState()
    {
        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);

            // Matt: added this so that when buttoning up the rotation is re-set to the direction the MG is facing (after looking around unbuttoned)
            if (DriverPositionIndex < UnbuttonedPositionIndex)
                SetRotation(Gun.CurrentAim);
        }
    }
}

// Matt: modified from StuH so that unbuttoned player can look around, similar to a CannonPawn
simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector x, y, z;
    local vector VehicleZ, CamViewOffsetWorld;
    local float CamViewOffsetZAmount;
    local coords CamBoneCoords;
    local rotator WeaponAimRot;
    local quat AQuat, BQuat, CQuat;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = Gun.GetBoneRotation(CameraBone);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    // Matt: in StuH the camera rotation always =WeaponAimRot - this modification only does that if player is buttoned up and controlling the remote MG
    if (DriverPositionIndex < UnbuttonedPositionIndex && !IsInState('ViewTransition'))
        CameraRotation =  WeaponAimRot;

    else if (bPCRelativeFPRotation) // Matt: will now use this 'free look around' code when unbuttoned, similar to a tank cannon pawn
    {
        //__________________________________________
        // First, Rotate the headbob by the player
        // controllers rotation (looking around) ---
        AQuat = QuatFromRotator(PC.Rotation);
        BQuat = QuatFromRotator(HeadRotationOffset - ShiftHalf);
        CQuat = QuatProduct(AQuat,BQuat);
        //__________________________________________
        // Then, rotate that by the vehicles rotation
        // to get the final rotation ---------------
        AQuat = QuatFromRotator(VehicleBase.Rotation);
        BQuat = QuatProduct(CQuat,AQuat);
        //__________________________________________
        // Make it back into a rotator!
        CameraRotation = QuatToRotator(BQuat);
    }
    else
        CameraRotation = PC.Rotation;

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
//            CameraLocation = Gun.GetBoneCoords('loader_cam').Origin; // Matt: replaced by the extended line below, which makes use of a ViewLocation camera adjutment in DriverPosition 1
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

//Hacked in for Texture overlay (Matt: this is from StuH, unaltered)
simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local float    SavedOpacity;
    local float    scale;

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
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
}

// Matt: modified so that the new functionality (from StuH) that moves the MG, only happens if the player is buttoned up
function UpdateRocketAcceleration(float deltaTime, float YawChange, float PitchChange)
{
    super.UpdateRocketAcceleration(deltaTime, YawChange, PitchChange); // Matt: call the Super to replace unnecessary several lines in original function

    // Matt: this 'if' prevents the MG from moving if the player is unbuttoned or in the process of buttoning or unbuttoning
    if (DriverPositionIndex < UnbuttonedPositionIndex && !IsInState('ViewTransition'))
    {
        UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);

        if (ROPlayer(Controller) != none)
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
            ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
        }
    }
}

defaultproperties
{
    UnbuttonedPositionIndex=1
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
    HUDOverlayFOV=45.0
}
