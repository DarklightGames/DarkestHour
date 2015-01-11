//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonPawn extends ROTankCannonPawn
    abstract;

struct ExitPositionPair
{
    var int Index;
    var float DistanceSquared;
};

// Position stuff
var()   float   OverlayCenterScale;
var     int         InitialPositionIndex;    // initial commander position on entering
var     int         UnbuttonedPositionIndex; // lowest position number where player is unbuttoned
var()   int         PeriscopePositionIndex;
var     int         GunsightPositions;       // the number of gunsight positions - 1 for normal optics or 2 for dual-magnification optics

// Gunsight overlay
var     bool        bShowRangeText;       // show current range setting text
var     TexRotator  ScopeCenterRotator;
var()   float       ScopeCenterScale;
var()   int         CenterRotationFactor;
var()   float       OverlayCenterSize;    // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var()   float       OverlayCorrectionX;   // scope center correction in pixels, in case an overlay is off-center by pixel or two
var()   float       OverlayCorrectionY;

// Other HUD stuff
var     texture     AltAmmoReloadTexture; // used to show coaxial MG reload progress on the HUD, like the cannon reload

// Damage modelling stuff
var     bool        bTurretRingDamaged;
var     bool        bGunPivotDamaged;
var     bool        bOpticsDamaged;
var     texture     DestroyedScopeOverlay;

// Manual & powered turret movement
var     bool        bManualTraverseOnly; // TEST - not used - but can perhaps make use of in a different on/off system that doesn't use Tick
var     sound       ManualRotateSound;
var     sound       ManualPitchSound;
var     sound       ManualRotateAndPitchSound;
var     sound       PoweredRotateSound;
var     sound       PoweredPitchSound;
var     sound       PoweredRotateAndPitchSound;
var     float       ManualMinRotateThreshold;
var     float       ManualMaxRotateThreshold;
var     float       PoweredMinRotateThreshold;
var     float       PoweredMaxRotateThreshold;

// NEW DH CODE: Illuminated sights
//var   texture     NormalCannonScopeOverlay;
//var   texture     LitCannonScopeOverlay;
//var   bool        bOpticsLit;
//var   bool        bHasLightedOptics;

// Debugging help
var()   bool        bShowCenter;    // shows centering cross in tank sight for testing purposes
var     bool        bDebuggingText; // on screen messages if damage prevents turret or gun from moving properly
var     bool        bDebugExitPositions;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        UnbuttonedPositionIndex; // Matt: this never changes & doesn't need to be replicated - check later & possibly remove

    // Variables the server will replicate to all clients
    reliable if (Role == ROLE_Authority)
        bTurretRingDamaged, bGunPivotDamaged, bOpticsDamaged; // bOpticsLit // Matt: not sure any of these are used clientside - check later & possibly remove

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleExtraRoundType, ServerChangeDriverPos, DamageCannonOverlay, ServerToggleDebugExits, ServerToggleDriverDebug; // Matt: don't think DamageCannonOverlay is called by client - check later & possibly remove

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientDamageCannonOverlay; // ClientLightOverlay
}

static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

// http://wiki.beyondunreal.com/Legacy:Insertion_Sort
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

// Overridden to stop the game playing silly buggers with exit positions while moving and breaking my damage code
function bool PlaceExitingDriver()
{
    local int i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;
    local array<ExitPositionPair> ExitPositionPairs;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    if (VehicleBase == none)
    {
        return false;
    }

    ExitPositionPairs.Length = VehicleBase.ExitPositions.Length;

    for (i = 0; i < VehicleBase.ExitPositions.Length; ++i)
    {
        ExitPositionPairs[i].Index = i;
        ExitPositionPairs[i].DistanceSquared = VSizeSquared(DrivePos - VehicleBase.ExitPositions[i]);
    }

    InsertSortEPPArray(ExitPositionPairs, 0, ExitPositionPairs.Length - 1);

    // Debug exits // Matt: uses abstract class default, allowing bDebugExitPositions to be toggled for all cannon pawns
    if (class'DH_ROTankCannonPawn'.default.bDebugExitPositions)
    {
        for (i = 0; i < ExitPositionPairs.Length; ++i)
        {
            ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[ExitPositionPairs[i].Index] >> VehicleBase.Rotation) + ZOffset;

            Spawn(class'DH_DebugTracer', , , ExitPosition);
        }
    }

    for (i = 0; i < ExitPositionPairs.Length; ++i)
    {
        ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[ExitPositionPairs[i].Index] >> VehicleBase.Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, VehicleBase.Location + ZOffset, false, Extent) != none ||
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
// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
simulated function PostBeginPlay()
{
    local vector Offset, Loc;

    super.PostBeginPlay();

    Offset.Z += 250.0;
    Loc = GetBoneCoords('com_player').ZAxis;

    ExitPositions[0] = Loc + Offset;
    ExitPositions[1] = ExitPositions[0];

    bTurretRingDamaged = false;
    bGunPivotDamaged = false;
}

simulated exec function SwitchFireMode()
{
    if (DH_ROTankCannon(Gun) != none && DH_ROTankCannon(Gun).bMultipleRoundTypes)
    {
        if (ROPlayer(Controller) != none)
        {
            ROPlayer(Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
        }

        ServerToggleExtraRoundType();
    }
}

function ServerToggleExtraRoundType()
{
    if (ROTankCannon(Gun) != none)
    {
        ROTankCannon(Gun).ToggleRoundType();
    }
}

// New function to damage gunsight optics
function DamageCannonOverlay()
{
    ClientDamageCannonOverlay();
    bOpticsDamaged = true;
}

simulated function ClientDamageCannonOverlay()
{
    CannonScopeOverlay = DestroyedScopeOverlay;
}

// Modified to allow turret traverse or elevation seizure if turret ring or pivot are damaged
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    if (!bTurretRingDamaged && !bGunPivotDamaged)
    {
        super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);
    }
    else if (bTurretRingDamaged && bGunPivotDamaged)
    {
        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Gun & turret disabled");
        }

        super.HandleTurretRotation(DeltaTime, 0.0, 0.0);
    }
    else if (!bTurretRingDamaged && bGunPivotDamaged)
    {
        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Gun disabled");
        }

        super.HandleTurretRotation(DeltaTime, YawChange, 0.0);
    }
    else if (bTurretRingDamaged && !bGunPivotDamaged)
    {
        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Turret disabled");
        }

        super.HandleTurretRotation(DeltaTime, 0.0, PitchChange);
    }
}

// Modified to handle dual-magnification optics (DPI < GunsightPositions), & to apply FPCamPos to all positions not just overlay positions
simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector  x, y, z, VehicleZ, CamViewOffsetWorld;
    local float   CamViewOffsetZAmount;
    local coords  CamBoneCoords;
    local rotator WeaponAimRot;
    local quat    AQuat, BQuat, CQuat;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = rotator(vector(Gun.CurrentAim) >> Gun.Rotation);
    WeaponAimRot.Roll =  GetVehicleBase().Rotation.Roll;

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    // This makes the camera stick to the cannon, but you have no control
    if (DriverPositionIndex < GunsightPositions)
    {
        CameraRotation = WeaponAimRot;
        CameraRotation.Roll = 0; // make the cannon view have no roll
    }
    else if (bPCRelativeFPRotation)
    {
        // First, rotate the headbob by the PlayerController's rotation (looking around)
        AQuat = QuatFromRotator(PC.Rotation);
        BQuat = QuatFromRotator(HeadRotationOffset - ShiftHalf);
        CQuat = QuatProduct(AQuat,BQuat);

        // Then, rotate that by the vehicles rotation to get the final rotation
        AQuat = QuatFromRotator(GetVehicleBase().Rotation);
        BQuat = QuatProduct(CQuat,AQuat);

        // Finally, make it back into a rotator
        CameraRotation = QuatToRotator(BQuat);
    }
    else
    {
        CameraRotation = PC.Rotation;
    }

    if (IsInState('ViewTransition') && bLockCameraDuringTransition)
    {
        CameraRotation = Gun.GetBoneRotation('Camera_com');
    }

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CamBoneCoords = Gun.GetBoneCoords(CameraBone);

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition'))
        {
            CameraLocation = CamBoneCoords.Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }
        else
        {
            CameraLocation = Gun.GetBoneCoords('Camera_com').Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
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

simulated function DrawBinocsOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = Float(Canvas.SizeY) / Float(Canvas.SizeX);
    Canvas.SetPos(0.0, 0.0);
    Canvas.DrawTile(BinocsOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1.0 - ScreenRatio) * Float(BinocsOverlay.VSize) / 2.0, BinocsOverlay.USize, Float(BinocsOverlay.VSize) * ScreenRatio);
}

// Recalls that optics are still non-functioning when players jump in and out
function KDriverEnter(Pawn P)
{
    super.KDriverEnter(P);

    if (bOpticsDamaged)
    {
        ClientDamageCannonOverlay();
    }
}

// Modified to handle InitialPositionIndex instead of assuming start in position zero
simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
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

// Modified to handle InitialPositionIndex instead of assuming start in position zero
simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    PendingPositionIndex = InitialPositionIndex;
    ServerChangeDriverPos();
}

// Overridden to set exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

    super.ClientKDriverLeave(PC);
}

function ServerChangeDriverPos()
{
    DriverPositionIndex = InitialPositionIndex;
}

// Modified to prevent exit if not unbuttoned (& also to reset to InitialPositionIndex instead of zero)
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
        DriverPositionIndex = InitialPositionIndex;
        LastPositionIndex = InitialPositionIndex;

        bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);

        ROVehicle(GetVehicleBase()).MaybeDestroyVehicle();

        return bSuperDriverLeave;
    }
}

// Modified to reset to InitialPositionIndex instead of zero
function DriverDied()
{
    DriverPositionIndex = InitialPositionIndex;

    super.DriverDied();

    DH_ROTreadCraft(GetVehicleBase()).MaybeDestroyVehicle();

    // Kill the rotation sound if the driver dies but the vehicle doesn't
    if (GetVehicleBase().Health > 0)
    {
        SetRotatingStatus(0);
    }
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
            // Run the state on the server whenever we're unbuttoning in order to prevent early exit
            else if (Level.NetMode == NM_DedicatedServer)
            {
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                {
                    GoToState('ViewTransition');
                }
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
            {
                Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }
        }

        if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
        {
            Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
        }

        WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

        FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;

        if (DriverPositionIndex != 0)
        {
            if (DriverPositions[DriverPositionIndex].bDrawOverlays)
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
            }
            else
            {
                PlayerController(Controller).DesiredFOV = WeaponFOV;
            }
        }

        if (LastPositionIndex < DriverPositionIndex)
        {
            if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim, 1.0), false);
            }
            else
            {
                GotoState('');
            }
        }
        else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
        {
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
        {
            GotoState('');
        }
    }

    simulated function EndState()
    {
        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
        }
    }

Begin:
    HandleTransition();
    Sleep(0.2);
}

// Modified so mesh rotation is matched in all net modes, not just standalone as in the RO original (not sure why they did that)
simulated state LeavingVehicle
{
    simulated function HandleExit()
    {
        local rotator TurretYaw, TurretPitch;

        if (Gun != none)
        {
            // Save old mesh rotation
            TurretYaw.Yaw = GetVehicleBase().Rotation.Yaw - CustomAim.Yaw;
            TurretPitch.Pitch = GetVehicleBase().Rotation.Pitch - CustomAim.Pitch;

            Gun.LinkMesh(Gun.default.Mesh);

            // Now make the new mesh you swap to have the same rotation as the old one
            Gun.SetBoneRotation(Gun.YawBone, TurretYaw);
            Gun.SetBoneRotation(Gun.PitchBone, TurretPitch);
        }

        if (Gun.HasAnim(Gun.BeginningIdleAnim))
        {
            Gun.PlayAnim(Gun.BeginningIdleAnim);
        }
    }
}

// New function, checked by Fire() so we prevent firing while moving between view points or when on periscope or binoculars
function bool CanFire()
{
    return !IsInState('ViewTransition') && DriverPositionIndex != PeriscopePositionIndex && DriverPositionIndex != BinocPositionIndex && ROPlayer(Controller) != none;
}

function Fire(optional float F)
{
    if (!CanFire())
    {
        return;
    }

    super.Fire(F);
}

function AltFire(optional float F)
{
    if (!CanFire())
    {
        return;
    }

    super.AltFire(F);
}

// Modified to prevent moving to another vehicle position while moving between view points
function ServerChangeDriverPosition(byte F)
{
    if (IsInState('ViewTransition'))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
}

function bool ResupplyAmmo()
{
    if (DH_ROTankCannon(Gun) != none && DH_ROTankCannon(Gun).ResupplyAmmo())
    {
        return true;
    }

    return false;
}

// Matt: used by HUD to show coaxial MG reload progress, like the cannon reload
function float GetAltAmmoReloadState()
{
    local float ProportionOfReloadRemaining;

    if (Gun.FireCountdown <= Gun.AltFireInterval)
    {
        return 0.0;
    }
    else
    {
        ProportionOfReloadRemaining = Gun.FireCountdown / GetSoundDuration(ROTankCannon(Gun).ReloadSound);

        if (ProportionOfReloadRemaining >= 0.75)
        {
            return 1.0;
        }
        else if (ProportionOfReloadRemaining >= 0.5)
        {
            return 0.65;
        }
        else if (ProportionOfReloadRemaining >= 0.25)
        {
            return 0.45;
        }
        else
        {
            return 0.25;
        }
    }
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

// Matt: modified to switch to external mesh & default FOV for behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local int i;

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            if (bPCRelativeFPRotation)
            {
                PC.SetRotation(rotator(vector(PC.Rotation) >> Rotation));
            }

            if (bMultiPosition)
            {
                for (i = 0; i < DriverPositions.Length; i++)
                {
                    DriverPositions[i].PositionMesh = Gun.default.Mesh;
                    DriverPositions[i].ViewFOV = PC.DefaultFOV;
                    DriverPositions[i].ViewPitchUpLimit = 65535;
                    DriverPositions[i].ViewPitchDownLimit = 1;
                }

                if ((Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer) 
                    && DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
                {
                    Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
                }

                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            }
            else
            {
                PC.SetFOV(PC.DefaultFOV);
                Gun.PitchUpLimit = 65535;
                Gun.PitchDownLimit = 1;
            }

            Gun.bLimitYaw = false;
        }

        bOwnerNoSee = false;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = !bDrawDriverInTP;
        }

        if (PC == Controller) // no overlays for spectators
        {
            ActivateOverlay(false);
        }
    }
    else
    {
        if (bPCRelativeFPRotation)
        {
            PC.SetRotation(rotator(vector(PC.Rotation) << Rotation));
        }

        if (bBehindViewChanged)
        {
            if (bMultiPosition)
            {
                for (i = 0; i < DriverPositions.Length; i++)
                {
                    DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
                    DriverPositions[i].ViewFOV = default.DriverPositions[i].ViewFOV;
                    DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                    DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;            
                }

                if ((Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer) 
                    && DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
                {
                    Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
                }

                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }
            else
            {
                PC.SetFOV(WeaponFOV);
                Gun.PitchUpLimit = Gun.default.PitchUpLimit;
                Gun.PitchDownLimit = Gun.default.PitchDownLimit;
            }

            Gun.bLimitYaw = Gun.default.bLimitYaw;
        }

        bOwnerNoSee = !bDrawMeshInFP;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = Driver.default.bOwnerNoSee;
        }

        if (bDriving && PC == Controller) // no overlays for spectators
        {
            ActivateOverlay(true);
        }
    }
}

// Matt: toggles between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && bMultiPosition)
    {
        if (Gun.Mesh == default.DriverPositions[DriverPositionIndex].PositionMesh)
        {
            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].PositionMesh = Gun.default.Mesh;
            }
        }
        else
        {
            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
            }
        }

        Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
    }
}

// Matt: DH version but keeping it just to view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    local int i;

    if (class'DH_LevelInfo'.static.DHDebugMode() && Gun != none) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
    {
        if (Gun.bLimitYaw == Gun.default.bLimitYaw && Gun.PitchUpLimit == Gun.default.PitchUpLimit && Gun.PitchDownLimit == Gun.default.PitchDownLimit)
        {
            Gun.bLimitYaw = false;
            Gun.PitchUpLimit = 65535;
            Gun.PitchDownLimit = 1;

            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].ViewPitchUpLimit = 65535;
                DriverPositions[i].ViewPitchDownLimit = 1;            
            }
        }
        else 
        {
            Gun.bLimitYaw = Gun.default.bLimitYaw;
            Gun.PitchUpLimit = Gun.default.PitchUpLimit;
            Gun.PitchDownLimit = Gun.default.PitchDownLimit;

            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;            
            }
        }
    }
}
// Matt: allows 'Driver' (commander) debugging to be toggled for all cannon pawns
exec function ToggleDriverDebug()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDriverDebug();
    }
}

function ServerToggleDriverDebug()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DH_ROTankCannon'.default.bDriverDebugging = !class'DH_ROTankCannon'.default.bDriverDebugging;
        Log("DH_ROTankCannon.bDriverDebugging =" @ class'DH_ROTankCannon'.default.bDriverDebugging);
    }
}

// Matt: allows debugging exit positions to be toggled for all cannon pawns
exec function ToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DH_ROTankCannonPawn'.default.bDebugExitPositions = !class'DH_ROTankCannonPawn'.default.bDebugExitPositions;
        Log("DH_ROTankCannonPawn.bDebugExitPositions =" @ class'DH_ROTankCannonPawn'.default.bDebugExitPositions);
    }
}

defaultproperties
{
    bShowRangeText=true
    GunsightPositions=1
    UnbuttonedPositionIndex=2
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    ManualPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    ManualMinRotateThreshold=0.25
    ManualMaxRotateThreshold=2.5
    PoweredMinRotateThreshold=0.15
    PoweredMaxRotateThreshold=1.75
    RotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    PitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    MaxRotateThreshold=1.5
    bDesiredBehindView=false
    PeriscopePositionIndex=-1
    AltAmmoReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
}
