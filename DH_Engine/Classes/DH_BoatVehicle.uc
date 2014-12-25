//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BoatVehicle extends ROWheeledVehicle;

#exec OBJ LOAD FILE=..\Textures\InterfaceArt_tex.utx

var()       name            DriverCameraBoneName;
var         vector          CameraBoneLocation;

var()       sound                       WashSound;
var()       name                        WashSoundBoneL;
var         ROSoundAttachment           WashSoundAttachL;
var()       name                        WashSoundBoneR;
var         ROSoundAttachment           WashSoundAttachR;

var()       sound                       EngineSound;
var()       name                        EngineSoundBone;
var         ROSoundAttachment           EngineSoundAttach;
var         float                       MotionSoundVolume;

var         sound                       DestroyedBurningSound;

var     Material  DestroyedVehicleTexture; // Matt: added to remove literal reference to Higgins boat
var     name      DestAnimName;
var     float     DestAnimRate;

var     float     PointValue;

struct ExitPositionPair
{
    var int Index;
    var float DistanceSquared;
};

var bool bDebugExitPositions;

static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

static final function InsertSortEPPArray(out array<ExitPositionPair> MyArray, int LowerBound, int UpperBound)
{
    local int InsertIndex, RemovedIndex;

    if (LowerBound < UpperBound)
    {
        for (RemovedIndex = LowerBound + 1; RemovedIndex <= UpperBound; ++RemovedIndex)
        {
            InsertIndex = RemovedIndex;

            while (InsertIndex > LowerBound && MyArray[InsertIndex - 1] > MyArray[RemovedIndex])
            {
                --InsertIndex;
            }

            if (RemovedIndex != InsertIndex)
            {
                MyArray.Insert(InsertIndex, 1);
                MyArray[InsertIndex] = MyArray[RemovedIndex + 1];
                MyArray.Remove(RemovedIndex + 1, 1);
            }
        }
    }
}

function bool PlaceExitingDriver()
{
    local int i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;
    local array<ExitPositionPair> ExitPositionPairs;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1, 1, 0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0, 0, 0.5);

    ExitPositionPairs.Length = ExitPositions.Length;

    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPositionPairs[i].Index = i;
        ExitPositionPairs[i].DistanceSquared = VSizeSquared(DrivePos - ExitPositions[i]);
    }

    InsertSortEPPArray(ExitPositionPairs, 0, ExitPositionPairs.Length - 1);

    if (bDebugExitPositions)
    {
        for (i = 0; i < ExitPositionPairs.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[ExitPositionPairs[i].Index] >> Rotation) + ZOffset;

            Spawn(class'RODebugTracer',,, ExitPosition);
        }
    }

    for (i = 0; i < ExitPositionPairs.Length; ++i)
    {
        ExitPosition = Location + (ExitPositions[ExitPositionPairs[i].Index] >> Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, Location + ZOffset, false, Extent) != none ||
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) != none)
        {
            continue;
        }

        if (Driver.SetLocation(ExitPosition))
        {
            return true;
        }
    }

    return false;
}

// Overridden to play the correct idle animation for the vehicle
simulated function PostBeginPlay()
{

    // RO functionality
    if (HasAnim(BeginningIdleAnim))
    {
        LoopAnim(BeginningIdleAnim);
    }

    SetTimer(1.0, false);
    // End RO functionality

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
            if (WashSoundAttachL == none)
            {
                    WashSoundAttachL = Spawn(class'ROSoundAttachment');
                    WashSoundAttachL.AmbientSound = WashSound;
                    WashSoundAttachL.SoundVolume = 75;
                    WashSoundAttachL.SoundRadius = 300;
                    AttachToBone(WashSoundAttachL, WashSoundBoneL);
            }
            if (WashSoundAttachR == none)
            {
                    WashSoundAttachR = Spawn(class'ROSoundAttachment');
                    WashSoundAttachR.AmbientSound = WashSound;
                    WashSoundAttachR.SoundVolume = 75;
                    WashSoundAttachR.SoundRadius = 300;
                    AttachToBone(WashSoundAttachR, WashSoundBoneR);
            }
            if (EngineSoundAttach == none)
            {
                    EngineSoundAttach = Spawn(class'ROSoundAttachment');
                    EngineSoundAttach.AmbientSound = EngineSound;
                    EngineSoundAttach.SoundVolume = 150;
                    EngineSoundAttach.SoundRadius = 1000;
                    AttachToBone(EngineSoundAttach, EngineSoundBone);
            }
    }
}

// DriverLeft() called by KDriverLeave()
function DriverLeft()
{
    // Not moving, so no motion sound
    MotionSoundVolume=0.0;
    UpdateMovementSound();
    super.DriverLeft();
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (DriverPositionIndex != SavedPositionIndex)
    {
        PreviousPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;
        NextViewPoint();
    }

    // Kill the engine sounds if the engine is dead
    if (EngineHealth <= 0)
    {
        if (IdleSound != none)
            IdleSound=none;

        if (StartUpSound != none)
            StartUpSound=none;

        if (ShutDownSound != none)
            ShutDownSound=none;

        if (AmbientSound != none)
            AmbientSound=none;

        if (EngineSound != none)
            EngineSound=none;
    }
}

// Overriden for locking the player to the camerabone
//altered slightly to allow change of camera bone name - Fennich
simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat CarQuat, LookQuat, ResultQuat;
    local vector VehicleZ, CamViewOffsetWorld, x, y, z;
    local float CamViewOffsetZAmount;

    GetAxes(PC.Rotation, x, y, z);
    ViewActor = self;

    if (bPCRelativeFPRotation)
    {
        CarQuat = QuatFromRotator(Rotation);
        CameraRotation = Normalize(PC.Rotation);
        LookQuat = QuatFromRotator(CameraRotation);
        ResultQuat = QuatProduct(LookQuat, CarQuat);
        CameraRotation = QuatToRotator(ResultQuat);
    }
    else
        CameraRotation = PC.Rotation;

    // Camera position is locked to car
    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;
    CameraBoneLocation = GetBoneCoords(DriverCameraBoneName).Origin;
    CameraLocation = CameraBoneLocation + (FPCamPos >> Rotation) + CamViewOffsetWorld;

    if (bFPNoZFromCameraPitch)
    {
        VehicleZ = vect(0, 0, 1) >> Rotation;
        CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
        CameraLocation -= CamViewOffsetZAmount * VehicleZ;
    }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

simulated function Destroyed()
{
    if (EngineSoundAttach != none)
        EngineSoundAttach.Destroy();
    if (WashSoundAttachL != none)
        WashSoundAttachL.Destroy();
    if (WashSoundAttachR != none)
        WashSoundAttachR.Destroy();

    super.Destroyed();
}

function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    if (Killer == none)
        return;

    DarkestHourGame(Level.Game).ScoreVehicleKill(Killer, self, PointValue);
}

simulated function UpdateMovementSound()
{
        if (EngineSoundAttach != none)
        {
             EngineSoundAttach.SoundVolume= MotionSoundVolume;
        }
}

simulated event DestroyAppearance()
{
    local int i;
    local KarmaParams KP;

    // For replication
    bDestroyAppearance = true;

    // Put brakes on
    Throttle=0;
    Steering=0;
    Rise=0;

    // Destroy the weapons
    if (Role == ROLE_Authority)
    {
        for (i = 0; i < Weapons.Length; i++)
        {
            if (Weapons[i] != none)
                Weapons[i].Destroy();
        }
        for (i = 0; i < WeaponPawns.Length; i++)
            WeaponPawns[i].Destroy();
    }

    Weapons.Length = 0;
    WeaponPawns.Length = 0;

    // Destroy the effects
    if (Level.NetMode != NM_DedicatedServer)
    {
        bNoTeamBeacon = true;

        for (i = 0; i < HeadlightCorona.Length; i++)
            HeadlightCorona[i].Destroy();
        HeadlightCorona.Length = 0;

        if (HeadlightProjector != none)
            HeadlightProjector.Destroy();

        for (i = 0; i < ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Destroy();
            }
        }
    }

    // Copy linear velocity from actor so it doesn't just stop.
    KP = KarmaParams(KParams);
    if (KP != none)
        KP.KStartLinVel = Velocity;

    if (DamagedEffect != none)
    {
        DamagedEffect.Kill();
    }

    //Become the dead vehicle mesh // Matt: removed as in this case we aren't switching to a destroyed static mesh
//  SetPhysics(PHYS_None);
//  KSetBlockKarma(false);
//  SetDrawType(DT_Mesh);
//  KSetBlockKarma(true);
//  SetPhysics(PHYS_Karma);
//  Skins.length = 1;
    NetPriority = 2;

    Skins[0] = DestroyedVehicleTexture;
    LoopAnim(DestAnimName, DestAnimRate);
}

function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float RandomExplModifier;

    RandomExplModifier = FRand();

    // Don't hurt us when we are destroying our own vehicle // why ?
    // if (!bSpikedVehicle)
    HurtRadius(ExplosionDamage * RandomExplModifier, ExplosionRadius * RandomExplModifier, ExplosionDamageType, ExplosionMomentum, Location);

    AmbientSound=DestroyedBurningSound; // test
    SoundVolume=255.0;
    SoundRadius=600.0;

    if (!bDisintegrateVehicle)
    {
        ExplosionCount++;

        if (Level.NetMode != NM_DedicatedServer)
            ClientVehicleExplosion(false);

        LinearImpulse = PercentMomentum * RandRange(DestructionLinearMomentum.Min, DestructionLinearMomentum.Max) * MomentumNormal;
        AngularImpulse = PercentMomentum * RandRange(DestructionAngularMomentum.Min, DestructionAngularMomentum.Max) * VRand();

        NetUpdateTime = Level.TimeSeconds - 1;
        KAddImpulse(LinearImpulse, vect(0, 0, 0));
        KAddAngularImpulse(AngularImpulse);
    }
}

defaultproperties
{
    DestroyedBurningSound=sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    //   MaxPitchSpeed=600.000000 // deprecated
    //   BoatFloatTraceDistance=10000.000000 // deprecated
    PointValue=1.000000
    ChangeUpPoint=1990.000000
    ChangeDownPoint=1000.000000
    SteerBoneName="steeringwheel"
    DustSlipRate=0.000000
    DustSlipThresh=100000.000000
    ViewShakeRadius=600.000000
    ViewShakeOffsetMag=(X=0.500000,Z=2.000000)
    ViewShakeOffsetFreq=7.000000
    DisintegrationHealth=-10000.000000
    DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
    DestructionAngularMomentum=(Max=150.000000)
    ExplosionSoundRadius=800.000000
    ExplosionDamage=300.000000
    ExplosionRadius=600.000000
    ImpactDamageMult=0.001000
    TimeTilDissapear=15.000000
    IdleTimeBeforeReset=30.000000
    InitialPositionIndex=0
    VehicleSpikeTime=15.000000
    VehHitpoints(0)=(PointBone="Driver")
    VehicleMass=12.000000
    bKeyVehicle=true
    bFPNoZFromCameraPitch=true
    CenterSpringForce="SpringONSSRV"
    VehiclePositionString="in a Boat"
    VehicleNameString="Boat"
    StolenAnnouncement="Shiver me timbers - some buggers gone and nicked me boat'"
    MaxDesireability=0.100000
    ObjectiveGetOutDist=1500.000000
    WaterDamage=0.000000
    bCanSwim=true
    GroundSpeed=200.000000
    WaterSpeed=200.000000
    PitchUpLimit=500
    PitchDownLimit=58000
    CollisionRadius=300.000000
    CollisionHeight=45.000000
    bDebugExitPositions=true
}
