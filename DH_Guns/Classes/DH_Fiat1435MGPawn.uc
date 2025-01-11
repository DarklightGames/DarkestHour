//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// TODO: A lot of the special functionality should be moved to a separate
//  subclass so that we can reuse all the new systems on other mounted MGs.
//==============================================================================

class DH_Fiat1435MGPawn extends DHVehicleMGPawn;

// Debugging
var Actor TargetActor;
var StaticMesh TargetStaticMesh;

// Zooming
var bool bIsZoomed;
var() float ZoomFOV;

// Reload
var() name  ReloadCameraBone;

// First Person Hands
var DHMortarHandsActor  HandsActor;
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

    HandsActor = Spawn(class'DHMortarHandsActor', self);
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
    super.ClientKDriverEnter(PC);

    if (IsLocallyControlled())
    {
        InitializeHands();
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
    // If we are reloading, don't allow the player to rotate the gun.
    if (IsReloading())
    {
        YawChange = 0;
        PitchChange = 0;
    }

    if (bIsZoomed)
    {
        YawChange *= 0.5;
        PitchChange *= 0.5;
    }

    super.UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);
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
    HandsReloadSequence="RELOAD_WC"

    GunClass=class'DH_Guns.DH_Fiat1435MG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true
    bMultiPosition=true
    // Because of the way that explosives work, we must say that the driver is not exposed so that
    // he is not killed by explosives while buttoned up.
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_WC_1ST',bExposed=true)
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    DrivePos=(X=0,Y=0,Z=58)
    DriveRot=(Pitch=0,Yaw=16384,Roll=0)
    BinocsDriveRot=(Pitch=0,Yaw=16384,Roll=0)
    DriveAnim="cv33_gunner_closed"
    bHideMuzzleFlashAboveSights=true

    GunsightCameraBone="GUNSIGHT_CAMERA_WC"
    CameraBone="GUNNER_CAMERA"
    ReloadCameraBone="RELOAD_CAMERA"

    //AnimationDrivers(0)=(Sequence="fiat1435_gunner_yaw_driver",Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=1),FrameCount=32)   // todo: fill in

    TargetStaticMesh=StaticMesh'DH_DebugTools.4MTARGET'
    ZoomFOV=60.0

    TPCamLookat=(Z=-70.0)
}
