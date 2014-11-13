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

var     bool    bShowRangeText; //turn the Range scale text on/off
var()   bool    bShowCenter; // AB
var()   bool    bDebugSightMover; // AB

var()   float   OverlayCenterScale;
var()   float   OverlayCenterSize;    // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width

var()   float   OverlayCorrectionX;
var()   float   OverlayCorrectionY;

var()   int     PeriscopePositionIndex;
var     int     GunsightPositions;  // number of gunsight positions, 1 for normal optics, 2 for dual-magnification optics
var     name    GunsightOpticsName;
var     int     InitialPositionIndex; // Initial Gunner Position
var     int     UnbuttonedPositionIndex; // Lowest pos number where player is unbuttoned

var  texture     AltAmmoReloadTexture; // used to show coaxial MG reload progress on the HUD, like the cannon reload

// NEW DH CODE: Damage modelling stuff
var     texture DestroyedScopeOverlay;
var     bool    bTurretRingDamaged;
var     bool    bGunPivotDamaged;
var     bool    bOpticsDamaged;

// NEW DH CODE: Manual Turret switching
var     bool    bManualTraverseOnly;

var     sound   ManualRotateSound;
var     sound   ManualPitchSound;
var     sound   ManualRotateAndPitchSound;
var     sound   PoweredRotateSound;
var     sound   PoweredPitchSound;
var     sound   PoweredRotateAndPitchSound;
var     float   ManualMinRotateThreshold;
var     float   ManualMaxRotateThreshold;
var     float   PoweredMinRotateThreshold;
var     float   PoweredMaxRotateThreshold;

// NEW DH CODE: Illuminated Sights
//var     texture NormalCannonScopeOverlay;
//var     texture LitCannonScopeOverlay;
//var     bool    bOpticsLit;
//var     bool    bHasLightedOptics;

//Debugging help
var     bool    bDrawPenetration;
var     bool    bDebuggingText;
var     bool    bPenetrationText;
var     bool    bLogPenetration;
var     bool    bDebugExitPositions;

static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

//http://wiki.beyondunreal.com/Legacy:Insertion_Sort
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

            if ( RemovedIndex != InsertIndex )
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

    Extent = Driver.default.CollisionRadius * vect(1, 1, 0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0, 0, 0.5);

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

    if (bDebugExitPositions)
    {
        for (i = 0; i < ExitPositionPairs.Length; ++i)
        {
            ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[ExitPositionPairs[i].Index] >> VehicleBase.Rotation) + ZOffset;

            Spawn(class'RODebugTracer',,,ExitPosition);
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

//=============================================================================
// replication
//=============================================================================
replication
{
    reliable if (bNetDirty && Role==ROLE_Authority)
        UnbuttonedPositionIndex;

    // functions called by client on server
    reliable if (Role<ROLE_Authority)
        ServerToggleExtraRoundType, ServerChangeDriverPos, DamageCannonOverlay; //

    // Functions called by server on client
    reliable if (Role==ROLE_Authority)
        bTurretRingDamaged, bGunPivotDamaged, bOpticsDamaged, ClientDamageCannonOverlay; //bOpticsLit, ClientLightOverlay

}

// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
simulated function PostBeginPlay()
{
    local vector Offset;
    local vector Loc;

    super.PostBeginPlay();

    Offset.Z += 250; //220
    Loc = GetBoneCoords('com_player').ZAxis;

    ExitPositions[0] = Loc + Offset;
    ExitPositions[1] = ExitPositions[0];

    bTurretRingDamaged=false;
    bGunPivotDamaged=false;
}

simulated exec function SwitchFireMode()
{
    if (Gun != none && DH_ROTankCannon(Gun) != none && DH_ROTankCannon(Gun).bMultipleRoundTypes)
    {
        if (Controller != none && ROPlayer(Controller) != none)
            ROPlayer(Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick',false,,SLOT_Interface);

        ServerToggleExtraRoundType();
    }
}

function ServerToggleExtraRoundType()
{
    if (Gun != none && ROTankCannon(Gun) != none)
    {
        ROTankCannon(Gun).ToggleRoundType();
    }
}
/*
// Overridden to switch to toggled turrets
simulated exec function Deploy()
{

    if (bTurretRingDamaged)
    return;

    if (Gun != none && DH_ROTankCannon(Gun) != none && !bManualTraverseOnly && !bEngineOff )
    {
        if (Controller != none && ROPlayer(Controller) != none)
            ROPlayer(Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick',false,,SLOT_Interface);

        if (DH_ROTankCannon(Gun).bManualTurret)
        {
            ToggleTurretMode(true);

            if (Role < ROLE_Authority)
                ServerToggleTurretMode(true);
        }
        else
        {
            ToggleTurretMode(false);

            if (Role < ROLE_Authority)
                ServerToggleTurretMode(false);
        }
    }
}

simulated function ToggleTurretMode(bool bPowerOn)
{
     if (Gun != none && DH_ROTankCannon(Gun) != none)
     {
        if (bPowerOn)
        {
            DH_ROTankCannon(Gun).bManualTurret=false;
            bTurretPowerOn=true;
        }
        else
        {
            DH_ROTankCannon(Gun).bManualTurret=true;
            bTurretPowerOn=false;
        }
    }
}
 */

// Server side
simulated function DamageCannonOverlay()
{
     ClientDamageCannonOverlay();
     bOpticsDamaged=true;
}

simulated function ClientDamageCannonOverlay()
{
    CannonScopeOverlay=DestroyedScopeOverlay;
}

// Override HandleTurretRotation to allow turret traverse seizure if turret ring is struck
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    if (bTurretRingDamaged && bGunPivotDamaged)
    {
       if (bDebuggingText && Role == ROLE_Authority)
          Level.Game.Broadcast(self, "Gun & Turret disabled");
       super.HandleTurretRotation(DeltaTime,0,0);
    }
    else if (!bTurretRingDamaged && bGunPivotDamaged)
    {
       if (bDebuggingText && Role == ROLE_Authority)
          Level.Game.Broadcast(self, "Gun disabled");
       super.HandleTurretRotation(DeltaTime,YawChange,0);
    }
    else if (bTurretRingDamaged && !bGunPivotDamaged)
    {
       if (bDebuggingText && Role == ROLE_Authority)
          Level.Game.Broadcast(self, "Turret disabled");
       super.HandleTurretRotation(DeltaTime,0,PitchChange);
    }
    else if (!bTurretRingDamaged && !bGunPivotDamaged)
     super.HandleTurretRotation(DeltaTime,YawChange,PitchChange);
}

//AB CODE
// modification allowing dual-magnification optics is here (look for "GunsightPositions")
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
        CameraRotation =  WeaponAimRot;
        // Make the cannon view have no roll
        CameraRotation.Roll = 0;
        //CameraRotation.Pitch -= ROTankCannon(Gun).AddedPitch; // AB
    }
    else if (bPCRelativeFPRotation)
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
        AQuat = QuatFromRotator(GetVehicleBase().Rotation);
        BQuat = QuatProduct(CQuat,AQuat);
        //__________________________________________
        // Make it back into a rotator!
        CameraRotation = QuatToRotator(BQuat);
    }
    else
        CameraRotation = PC.Rotation;

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
            CameraLocation = Gun.GetBoneCoords('Camera_com').Origin;
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

//AB CODE
simulated function DrawBinocsOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
    Canvas.SetPos(0,0);
    Canvas.DrawTile(BinocsOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1 - ScreenRatio) * float(BinocsOverlay.VSize) / 2, BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio);
}

// Recalls that optics are still non-functioning when players jump in and out
function KDriverEnter(Pawn P)
{

     super.KDriverEnter(P);

     if (bOpticsDamaged)
        ClientDamageCannonOverlay();
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

// Overriden to handle mesh swapping when entering the vehicle
simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

//    log("clientK DriverPos "$DriverPositionIndex);
//  log("clientK PendingPos "$PendingPositionIndex);

    /*
    DHPlayer(PC).QueueHint(41, true);
    */

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
        LastPositionIndex=InitialPositionIndex;

        bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);

        DH_ROTreadCraft(GetVehicleBase()).MaybeDestroyVehicle();
        return bSuperDriverLeave;
    }
}

function DriverDied()
{
    DriverPositionIndex=InitialPositionIndex;
    super.DriverDied();
    DH_ROTreadCraft(GetVehicleBase()).MaybeDestroyVehicle();

    // Kill the rotation sound if the driver dies but the vehicle doesnt
    if (GetVehicleBase().Health > 0)
        SetRotatingStatus(0);
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

simulated state LeavingVehicle
{
    simulated function HandleExit()
    {
        local rotator TurretYaw, TurretPitch;
        // Make the new mesh you swap to have the same rotation as the old one

        if (Gun != none)
        {
            TurretYaw.Yaw = GetVehicleBase().Rotation.Yaw - CustomAim.Yaw;
            TurretPitch.Pitch = GetVehicleBase().Rotation.Pitch - CustomAim.Pitch;

            Gun.LinkMesh(Gun.Default.Mesh);

            Gun.SetBoneRotation(Gun.YawBone, TurretYaw);
            Gun.SetBoneRotation(Gun.PitchBone, TurretPitch);
        }

        //LinkMesh(Default.Mesh);

        if (Gun.HasAnim(Gun.BeginningIdleAnim))
        {
            Gun.PlayAnim(Gun.BeginningIdleAnim);
        }
    }
}

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
    local DH_ROTankCannon P;

    P = DH_ROTankCannon(Gun);

    if (P != none && P.ResupplyAmmo())
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

        return Ceil(4.0 * ProportionOfReloadRemaining) / 4.0; // round to increments of 0.25
    }
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

defaultproperties
{
    bShowRangeText=true
    GunsightPositions=1
    GunsightOpticsName="ScopeNameHere"
    UnbuttonedPositionIndex=2
    ManualRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    ManualPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    ManualRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    ManualMinRotateThreshold=0.250000
    ManualMaxRotateThreshold=2.500000
    PoweredMinRotateThreshold=0.150000
    PoweredMaxRotateThreshold=1.750000
    RotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    PitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    MaxRotateThreshold=1.500000
    bDesiredBehindView=false
    PeriscopePositionIndex=-1
    AltAmmoReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
}
