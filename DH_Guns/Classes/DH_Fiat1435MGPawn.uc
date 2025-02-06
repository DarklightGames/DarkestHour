//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// TODO: A lot of the special functionality should be moved to a separate
//  subclass so that we can reuse all the new systems on other mounted MGs.
//==============================================================================

class DH_Fiat1435MGPawn extends DHVehicleMGPawn
    abstract;

// Debugging
var Actor TargetActor;
var StaticMesh TargetStaticMesh;

// Zooming
var bool bIsZoomed;
var() float ZoomFOV;

// Reload
var() name  ReloadCameraBone;

// First Person Hands
var DHFirstPersonHands  HandsActor;
var Mesh                HandsMesh;
var() name              HandsReloadSequence;
var name                HandsAttachBone;

// TODO: maybe use a state while reloading to make this easier to manage.

simulated function Destroyed()
{
    if (TargetActor != none)
    {
        TargetActor.Destroy();
    }

    if (HandsActor != none)
    {
        HandsActor.Destroy();
    }

    super.Destroyed();
}

simulated function InitializeHands()
{
    if (HandsActor != none)
    {
        HandsActor.Destroy();
    }

    HandsActor = Spawn(class'DHFirstPersonHands', self);
    HandsActor.LinkMesh(HandsMesh);
    HandsActor.PlayAnim('IDLE');
    HandsActor.SetSkins(DHPlayer(Controller));
    // HandsActor.SetDrawScale(1.5); // TODO: not sure why this is necessary.

    Gun.AttachToBone(HandsActor, HandsAttachBone);

    HandsActor.SetRelativeLocation(vect(0, 0, 0));
    HandsActor.SetRelativeRotation(rot(0, 0, 0));
}

simulated function ClientKDriverEnter(PlayerController PC)
{
    local DH_Fiat1435MG MG;

    super.ClientKDriverEnter(PC);

    if (IsLocallyControlled())
    {
        InitializeHands();

        MG = DH_Fiat1435MG(Gun);

        if (MG != none)
        {
            MG.UpdateClip();
        }
    }
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    super.ClientKDriverLeave(PC);

    if (HandsActor != none)
    {
        HandsActor.Destroy();
        HandsActor = none;
    }
}

simulated function SetIsZoomed(bool bNewIsZoomed)
{
    local DHPlayer PC;

    // Only the local player can change the zoom state.
    if (!IsLocallyControlled() || bIsZoomed == bNewIsZoomed)
    {
        return;
    }

    PC = DHPlayer(Controller);

    if (bNewIsZoomed)
    {
        PC.DesiredFOV = ZoomFOV;
    }
    else
    {
        PC.DesiredFOV = PC.DefaultFOV;
    }

    bIsZoomed = bNewIsZoomed;
}

simulated function ToggleZoom()
{
    if (IsReloading())
    {
        // Don't allow the player to toggle the zoom while reloading.
        return;
    }

    SetIsZoomed(!bIsZoomed);
}

simulated function ROIronSights()
{
    ToggleZoom();
}

simulated function PlayHandsReloadAnim()
{
    if (HandsActor == none)
    {
        return;
    }

    HandsActor.PlayAnim(HandsReloadSequence);
}

simulated function bool IsReloading()
{
    local DH_Fiat1435MG MG;

    MG = DH_Fiat1435MG(Gun);

    return MG != none && MG.IsReloading();
}

simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local float T;
    local DH_Fiat1435MG VW;
    local Coords ReloadCameraCoords;
    local Vector ReloadCameraLocation;
    local Rotator ReloadCameraRotation;

    super.SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

    if (IsReloading())
    {
        VW = DH_Fiat1435MG(Gun);

        ReloadCameraCoords = VW.GetBoneCoords(ReloadCameraBone);
        ReloadCameraLocation = ReloadCameraCoords.Origin;
        ReloadCameraRotation = QuatToRotator(
            class'UQuaternion'.static.FromAxes(ReloadCameraCoords.XAxis, ReloadCameraCoords.YAxis, ReloadCameraCoords.ZAxis)
        );

        T = class'UInterp'.static.LerpBilateral(Level.TimeSeconds, VW.ReloadStartTimeSeconds, VW.ReloadEndTimeSeconds, VW.ReloadCameraTweenTime);
        T = class'UInterp'.static.SmoothStep(T, 0.0, 1.0);

        CameraLocation = class'UVector'.static.VLerp(T, CameraLocation, ReloadCameraLocation);
        CameraRotation = QuatToRotator(QuatSlerp(QuatFromRotator(CameraRotation), QuatFromRotator(ReloadCameraRotation), T));
    }
}

// Despite the name, this function is used to update the gun's rotation.
public function UpdateRocketAcceleration(Float DeltaTime, Float YawChange, Float PitchChange)
{
    PitchChange *= 0.5;

    // If we are reloading, don't allow the player to rotate the gun.
    if (IsReloading())
    {
        PitchChange = 0;
        YawChange = 0;
    }

    if (bIsZoomed)
    {
        YawChange *= 0.5;
        PitchChange *= 0.5;
    }

    super.UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);
}

// Pitch is handled with W/S keys.
function HandleTurretRotation(Float DeltaTime, Float YawChange, Float PitchChange)
{
    UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

    if (IsHumanControlled())
    {
        PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
        PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

// Debugging functions.
simulated exec function SpawnRangeTarget()
{
    local Coords MuzzleCoords;
    local Vector Direction, TargetLocation;
    local DH_Fiat1435MG MG;

    if (Level.NetMode != NM_Standalone && !class'DH_LevelInfo'.static.DHDebugMode())
    {
        return;
    }
    
    MG = DH_Fiat1435MG(Gun);

    if (Gun == none)
    {
        return;
    }

    MuzzleCoords = Gun.GetBoneCoords(Gun.WeaponFireAttachmentBone);

    Direction = MuzzleCoords.XAxis;
    Direction.Z = 0;
    Direction = Normal(Direction);

    if (TargetActor != none)
    {
        TargetActor.Destroy();
    }

    TargetLocation = MuzzleCoords.Origin + (Direction * class'DHUnits'.static.MetersToUnreal(MG.RangeTable[MG.RangeIndex].Range));

    TargetActor = Spawn(class'DHRangeTargetActor', self,, TargetLocation, rotator(-Direction));
    TargetActor.SetStaticMesh(TargetStaticMesh);
}

simulated exec function SetRangeTheta(float NewTheta)
{
    local DH_Fiat1435MG MG;
    MG = DH_Fiat1435MG(Gun);

    if (Level.NetMode != NM_Standalone && !class'DH_LevelInfo'.static.DHDebugMode())
    {
        return;
    }

    MG.RangeTable[MG.RangeIndex].AnimationTime = NewTheta;
    MG.UpdateRangeDriverFrameTarget();
}

simulated exec function DumpRangeTable()
{
    local int i;
    local DH_Fiat1435MG MG;

    if (Level.NetMode != NM_Standalone && !class'DH_LevelInfo'.static.DHDebugMode())
    {
        return;
    }

    MG = DH_Fiat1435MG(Gun);

    for (i = 0; i < MG.RangeTable.Length; ++i)
    {
        Log("RangeTable(" $ i $ ")=(Range=" $ MG.RangeTable[i].Range $ ",AnimationTime=" $ MG.RangeTable[i].AnimationTime $ ")");
    }
}

defaultproperties
{
    HandsMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_HANDS'
    HandsAttachBone="HANDS_ATTACHMENT"

    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true
    bMultiPosition=true
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    DrivePos=(X=-15.5622,Y=0,Z=29.7831)
    DriveRot=(Pitch=0,Yaw=0,Roll=0)
    BinocsDriveRot=(Pitch=0,Yaw=16384,Roll=0)
    DriveAnim="cv33_gunner_closed"  // TODO: replace
    bHideMuzzleFlashAboveSights=true

    CameraBone="GUNNER_CAMERA"
    ReloadCameraBone="RELOAD_CAMERA"

    AnimationDrivers(0)=(Sequence="fiat1435_gunner_yaw_driver",FrameCount=20,Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=0))

    TargetStaticMesh=StaticMesh'DH_DebugTools.4MTARGET'
    ZoomFOV=60.0

    TPCamLookat=(Z=-70.0)
}
