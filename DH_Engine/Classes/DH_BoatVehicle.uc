//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BoatVehicle extends ROWheeledVehicle;

#exec OBJ LOAD FILE=..\Textures\InterfaceArt_tex.utx

var()   name                DriverCameraBoneName;
var     vector              CameraBoneLocation;

var()   sound               WashSound;
var()   name                WashSoundBoneL;
var     ROSoundAttachment   WashSoundAttachL;
var()   name                WashSoundBoneR;
var     ROSoundAttachment   WashSoundAttachR;

var()   sound               EngineSound;
var()   name                EngineSoundBone;
var     ROSoundAttachment   EngineSoundAttach;
var     float               MotionSoundVolume;

var     sound               DestroyedBurningSound;
var     Material            DestroyedVehicleTexture;
var     name                DestAnimName;
var     float               DestAnimRate;

var     float               PointValue;

var     bool                bDebugExitPositions;

function bool PlaceExitingDriver()
{
    local int    i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Debug exits // Matt: uses abstract class default, allowing bDebugExitPositions to be toggled for all DH_ROWheeledVehicles
    if (class'DH_ROWheeledVehicle'.default.bDebugExitPositions)
    {
        for (i = 0; i < ExitPositions.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

            Spawn(class'DH_DebugTracer', , , ExitPosition);
        }
    }

    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

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
    if (HasAnim(BeginningIdleAnim))
    {
        LoopAnim(BeginningIdleAnim);
    }

    SetTimer(1.0, false);

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (WashSoundAttachL == none)
        {
            WashSoundAttachL = Spawn(class'ROSoundAttachment');
            WashSoundAttachL.AmbientSound = WashSound;
            WashSoundAttachL.SoundVolume = 75;
            WashSoundAttachL.SoundRadius = 300.0;
            AttachToBone(WashSoundAttachL, WashSoundBoneL);
        }

        if (WashSoundAttachR == none)
        {
            WashSoundAttachR = Spawn(class'ROSoundAttachment');
            WashSoundAttachR.AmbientSound = WashSound;
            WashSoundAttachR.SoundVolume = 75;
            WashSoundAttachR.SoundRadius = 300.0;
            AttachToBone(WashSoundAttachR, WashSoundBoneR);
        }

        if (EngineSoundAttach == none)
        {
            EngineSoundAttach = Spawn(class'ROSoundAttachment');
            EngineSoundAttach.AmbientSound = EngineSound;
            EngineSoundAttach.SoundVolume = 150;
            EngineSoundAttach.SoundRadius = 1000.0;
            AttachToBone(EngineSoundAttach, EngineSoundBone);
        }
    }
}

function DriverLeft()
{
    // Not moving, so no motion sound
    MotionSoundVolume = 0.0;
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

// Overridden for locking the player to the camerabone // altered slightly to allow change of camera bone name - Fennich
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat   CarQuat, LookQuat, ResultQuat;
    local vector VehicleZ, CamViewOffsetWorld, x, y, z;
    local float  CamViewOffsetZAmount;

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
    {
        CameraRotation = PC.Rotation;
    }

    // Camera position is locked to vehicle
    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;
    CameraBoneLocation = GetBoneCoords(DriverCameraBoneName).Origin;
    CameraLocation = CameraBoneLocation + (FPCamPos >> Rotation) + CamViewOffsetWorld;

    if (bFPNoZFromCameraPitch)
    {
        VehicleZ = vect(0.0, 0.0, 1.0) >> Rotation;
        CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
        CameraLocation -= CamViewOffsetZAmount * VehicleZ;
    }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

simulated function Destroyed()
{
    if (EngineSoundAttach != none)
    {
        EngineSoundAttach.Destroy();
    }

    if (WashSoundAttachL != none)
    {
        WashSoundAttachL.Destroy();
    }

    if (WashSoundAttachR != none)
    {
        WashSoundAttachR.Destroy();
    }

    super.Destroyed();
}

function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    if (Killer == none)
    {
        return;
    }

    DarkestHourGame(Level.Game).ScoreVehicleKill(Killer, self, PointValue);
}

simulated function UpdateMovementSound()
{
    if (EngineSoundAttach != none)
    {
        EngineSoundAttach.SoundVolume = MotionSoundVolume;
    }
}

// Modified to avoid switching to static mesh DestroyedVehicleMesh, instead switching the boat skin to a DestroyedVehicleTexture & playing a destroyed animation
simulated event DestroyAppearance()
{
    local int         i;
    local KarmaParams KP;

    bDestroyAppearance = true; // for replication

    // Put brakes on
    Throttle = 0.0;
    Steering = 0.0;
    Rise     = 0.0;

    // Destroy the vehicle weapons
    if (Role == ROLE_Authority)
    {
        for (i = 0; i < WeaponPawns.Length; i++)
        {
            if (WeaponPawns[i] != none)
            {
                WeaponPawns[i].Destroy();
            }
        }
    }

    WeaponPawns.Length = 0;

    // Destroy the effects
    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Destroy();
            }
        }
    }

    // Copy linear velocity from actor so it doesn't just stop
    KP = KarmaParams(KParams);

    if (KP != none)
    {
        KP.KStartLinVel = Velocity;
    }

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
    NetPriority = 2.0;

    Skins[0] = DestroyedVehicleTexture;
    LoopAnim(DestAnimName, DestAnimRate);
}

function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float  RandomExplModifier;

    RandomExplModifier = FRand();
    HurtRadius(ExplosionDamage * RandomExplModifier, ExplosionRadius * RandomExplModifier, ExplosionDamageType, ExplosionMomentum, Location);

    AmbientSound = DestroyedBurningSound;
    SoundVolume = 255;
    SoundRadius = 600.0;

    if (!bDisintegrateVehicle)
    {
        ExplosionCount++;

        if (Level.NetMode != NM_DedicatedServer)
        {
            ClientVehicleExplosion(false);
        }

        LinearImpulse = PercentMomentum * RandRange(DestructionLinearMomentum.Min, DestructionLinearMomentum.Max) * MomentumNormal;
        AngularImpulse = PercentMomentum * RandRange(DestructionAngularMomentum.Min, DestructionAngularMomentum.Max) * VRand();

        NetUpdateTime = Level.TimeSeconds - 1.0;
        KAddImpulse(LinearImpulse, vect(0.0, 0.0, 0.0));
        KAddAngularImpulse(AngularImpulse);
    }
}

// Overridden to eliminate "Waiting for additional crewmembers" message
function bool CheckForCrew()
{
    return true;
}

defaultproperties
{
    DestroyedBurningSound=sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    PointValue=1.0
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    SteerBoneName="steeringwheel"
    DustSlipRate=0.0
    DustSlipThresh=100000.0
    ViewShakeRadius=600.0
    ViewShakeOffsetMag=(X=0.5,Z=2.0)
    ViewShakeOffsetFreq=7.0
    DisintegrationHealth=-10000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    ExplosionSoundRadius=800.0
    ExplosionDamage=300.0
    ExplosionRadius=600.0
    ImpactDamageMult=0.001
    TimeTilDissapear=15.0
    IdleTimeBeforeReset=30.0
    InitialPositionIndex=0
    VehicleSpikeTime=15.0
    VehHitpoints(0)=(PointBone="Driver")
    VehicleMass=12.0
    bKeyVehicle=true
    bFPNoZFromCameraPitch=true
    CenterSpringForce="SpringONSSRV"
    VehiclePositionString="in a Boat"
    StolenAnnouncement="Shiver me timbers - some buggers gone and nicked me boat'"
    MaxDesireability=0.1
    ObjectiveGetOutDist=1500.0
    WaterDamage=0.0
    bCanSwim=true
    GroundSpeed=200.0
    WaterSpeed=200.0
    PitchUpLimit=500
    PitchDownLimit=58000
    CollisionRadius=300.0
    CollisionHeight=45.0
    bDebugExitPositions=true
}
