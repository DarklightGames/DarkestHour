//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat1435MGPawn extends DHVehicleMGPawn;

var Actor TargetActor;
var StaticMesh TargetStaticMesh;

var bool bIsZoomed;
var float ZoomFOV;

simulated function Destroyed()
{
    if (TargetActor != none)
    {
        TargetActor.Destroy();
    }

    super.Destroyed();
}

simulated exec function SpawnRangeTarget()
{
    local Coords MuzzleCoords;
    local Vector Direction, TargetLocation;
    local DH_Fiat1435MG MG;
    MG = DH_Fiat1435MG(Gun);

    // TODO: spawn a target object at the range of the current range setting.
    //  Make sure it is in the direction of the gun, at the same height as the muzzle.
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

simulated function ROIronSights()
{
    local DHPlayer PC;

    if (!IsLocallyControlled())
    {
        return;
    }

    PC = DHPlayer(Controller);

    if (bIsZoomed)
    {
        PC.DesiredFOV = PC.DefaultFOV;
    }
    else
    {
        PC.DesiredFOV = ZoomFOV;
    }

    bIsZoomed = !bIsZoomed;
}

simulated exec function SetRangeTheta(float NewTheta)
{
    local DH_Fiat1435MG MG;
    MG = DH_Fiat1435MG(Gun);
    MG.RangeTable[MG.RangeIndex].AnimationTime = NewTheta;
    MG.UpdateRangeDriverFrameTarget();
}

simulated exec function DumpRangeTable()
{
    local int i;
    local DH_Fiat1435MG MG;

    MG = DH_Fiat1435MG(Gun);

    for (i = 0; i < MG.RangeTable.Length; ++i)
    {
        Log("RangeTable(" $ i $ ")=(Range=" $ MG.RangeTable[i].Range $ ",AnimationTime=" $ MG.RangeTable[i].AnimationTime $ ")");
    }
}

defaultproperties
{
    GunClass=class'DH_Guns.DH_Fiat1435MG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true
    bMultiPosition=true
    // Because of the way that explosives work, we must say that the driver is not exposed so that
    // he is not killed by explosives while buttoned up.
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_WC_1ST',bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_WC_1ST',TransitionUpAnim="cv33_turret_open",DriverTransitionAnim="cv33_gunner_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=16384,ViewNegativeYawLimit=-16384)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=1
    bDrawDriverInTP=true
    DrivePos=(X=0,Y=0,Z=58)
    DriveRot=(Pitch=0,Yaw=16384,Roll=0)
    BinocsDriveRot=(Pitch=0,Yaw=16384,Roll=0)
    DriveAnim="cv33_gunner_closed"
    
    // TODO: figure out what this is
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=2.5
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true

    GunsightCameraBone="GUNSIGHT_CAMERA_WC"
    CameraBone="GUNNER_CAMERA"

    //AnimationDrivers(0)=(Sequence="fiat1435_gunner_yaw_driver",Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=1),FrameCount=32)   // todo: fill in

    TargetStaticMesh=StaticMesh'DH_DebugTools.4MTARGET'

    ZoomFOV=65.0
}
