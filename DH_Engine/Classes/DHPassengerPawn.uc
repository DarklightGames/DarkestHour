//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPassengerPawn extends DHVehicleWeaponPawn
    abstract;

/**
Matt UK, November 2014 - added new system to avoid rider pawns needing to exist on net clients unless rider position is occupied
Each rider pawn that exists on a client is a net channel that has to be maintained & updated by the server
The new system can substantially cut down the number of net channels & associated replication, especially in maps with lots of vehicles
What we need is a way of making the server stop replicating an empty rider pawn & cause any client versions of that actor to be destroyed
But that's actually hard to do; there isn't a simple instruction that makes a server do it
We can't just set RemoteRole to none, as that doesn't destroy any existing client actors, it just stops any further replicated info reaching them
As a workaround, on a server we toggle the bTearOff networking flag based on whether a rider pawn is unoccupied or occupied
Setting bTearOff on the server stops the actor being considered net relevant & stops further replication for it
Then, after a built-in engine delay of 5 seconds, the server closes the channel & destroys all existing replicated client versions of the actor
But the trick is to stop the actor from actually being torn off on clients, otherwise it leaves independent client actor copies, which must be avoided
Also, if a player switches into this rider position within these 5 seconds, we need to abort closing the net channel & destroying the client actors
I found a way to achieve all this is to delay next NetUpdateTime to be >5 seconds in the future, which delays bTearOff from replicating to clients
That way the server closes the channel & destroys the client actor before bTearOff is sent to the client, so it never actually gets torn off
And if a player re-enters the rider position during these 5 seconds, we simply change bTearOff back to false & it becomes net relevant again
A further complication is when player exits rider pawn we must introduce a short delay before setting bTearOff on server, so a 0.5 sec timer is used
That's necessary to allow properties updated on exit (e.g. Owner, Driver & PRI to none) to replicate to clients before shutting down all net traffic
Changes in other classes: when a DHVehicle spawns on net client, match WeaponPawns.Length to PassengerPawns.Length to account for 'missing' rider pawns
And always check a WeaponPawns array member exists before trying to do anything with it, as rider pawns may not exist on client (good practice anyway)
*/

// An array of subclasses, one specifically assigned for each index position in the vehicle's WeaponPawns array, so this actor knows its own PositionInArray
// Facilitates using a generic passenger pawn class for all vehicles, with properties being specified in vehicle's PassengerPawns array
// Avoids need for lots of passenger pawn classes for every vehicle, but we need subclasses with PositionInArray as net client has to know its index position
// Note that if really needed we can still use specific passenger classes with a vehicle, instead of the PassengerPawns array
var     array<class<DHPassengerPawn> >  PassengerClasses;

var     bool    bUseDriverHeadBoneCam; // use the driver's head bone for the camera location

///////////////////////////////////////////////////////////////////////////////////////
//  ************ ACTOR INITIALISATION, DESTRUCTION & KEY ENGINE EVENTS  ***********  //
///////////////////////////////////////////////////////////////////////////////////////

// Emptied out as the Super in ROVehicleWeaponPawn only tries to spawn a non-existent GunClass
function BeginPlay()
{
}

// Modified to set bTearOff to true on a server, which stops this rider pawn being replicated to clients (until entered, when we unset bTearOff)
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        bTearOff = true;
    }
}

// Sets bTearOff to true on server after player exits, so server decides actor is no longer net relevant, closes the net channel & destroys client actor
// But we don't want the client actor to actually get torn off, as that would cause us big problems, so we have to stop bTearOff from reaching the client
// So we delay next update to client for longer than server's 5 second built-in delay before it destroys client actor after it stops being net relevant
function Timer()
{
    if (!bDriving && !bTearOff && (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer))
    {
        NetUpdateTime = Level.TimeSeconds + (6.0 * Level.Game.GameSpeed);
        bTearOff = true;
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  VIEW/DISPLAY  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to avoid "accessed none" errors on VehicleBase & to generally optimise & match other DH vehicle classes
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat RelativeQuat, VehicleQuat, NonRelativeQuat;

    ViewActor = self;

    // CameraRotation is currently relative to vehicle, so now factor in the vehicle's rotation
    if (VehicleBase != none)
    {
        RelativeQuat = QuatFromRotator(Normalize(PC.Rotation));
        VehicleQuat = QuatFromRotator(VehicleBase.Rotation);
        NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
        CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));
    }
    else
    {
        CameraRotation = PC.Rotation;
    }

    // CameraLocation uses the player's 'head' bone if possible, otherwise there's a fall-back
    if (Driver != none && bUseDriverHeadBoneCam)
    {
        CameraLocation = Driver.GetBoneCoords('head').Origin;
    }
    else
    {
        CameraLocation = GetCameraLocationStart();
    }

    // Adjust camera location for any FPCamPos offset positioning
    if (FPCamPos != vect(0.0, 0.0, 0.0))
    {
        CameraLocation += FPCamPos >> CameraRotation;
    }

    // Finalise the camera with any shake
    CameraLocation += PC.ShakeOffset >> PC.Rotation;
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Modified to remove everything except drawing basic vehicle HUD info
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;

    PC = PlayerController(Controller);

    // Draw vehicle, turret, passenger list
    if (PC != none && !PC.bBehindView && ROHud(PC.myHUD) != none && VehicleBase != none)
    {
        ROHud(PC.myHUD).DrawVehicleIcon(C, VehicleBase, self);
    }
}

// Modified (from deprecated ROPassengerPawn) to use the vehicle's WeaponBone we now use to attach this passenger, instead of the confusing CameraBone
simulated function vector GetCameraLocationStart()
{
    if (VehicleBase != none)
    {
        return VehicleBase.GetBoneCoords(VehicleBase.PassengerWeapons[PositionInArray].WeaponBone).Origin;
    }

    return Location;
}

// Modified so the player's view starts facing the same way his attached pawn is facing, which feels natural
simulated function SetInitialViewRotation()
{
    local name    AttachBone;
    local vector  FacingDirection;
    local rotator NewRotation;

    if (VehicleBase != none)
    {
        AttachBone = VehicleBase.PassengerWeapons[PositionInArray].WeaponBone;
        FacingDirection = vector(VehicleBase.GetBoneRotation(AttachBone)) >> DriveRot; // apply DriveRot to attachment bone's rotation to get player's initial world facing direction
        NewRotation = rotator(FacingDirection << VehicleBase.Rotation);                // now make that relative to vehicle's rotation (standard in weapon pawns)
        NewRotation.Pitch = LimitPitch(NewRotation.Pitch);
        SetRotation(NewRotation);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** VEHICLE ENTRY & EXIT ***************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to unset bTearOff on a server, which makes this rider pawn potentially relevant to net clients & always to the one entering the rider position
function KDriverEnter(Pawn P)
{
    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        if (P == none || (P.Controller == none && !(P.IsA('DHPawn') && DHPawn(P).SwitchingController != none)))
        {
            return; // shouldn't happen, but the Super will fail if it can't get a pawn & controller, so this safeguard stops us tearing off if nothing is going to happen
        }

        SetTimer(0.0, false); // clear any timer, so we don't risk setting bTearOff to true again just after we enter
        bTearOff = false;     // note we don't need to force a quick net update of bTearOff, as normal possession functionality does it
    }

    super.KDriverEnter(P);
}

// Modified (from deprecated ROPassengerPawn) to avoid confusing attachment to CameraBone & instead use the usual WeaponBone specified in the vehicle's PassengerWeapons array
simulated function AttachDriver(Pawn P)
{
    local name AttachBone;

    if (VehicleBase != none && VehicleBase.PassengerWeapons[PositionInArray].WeaponBone != '')
    {
        AttachBone = VehicleBase.PassengerWeapons[PositionInArray].WeaponBone;
        P.bHardAttach = true;
        P.SetLocation(VehicleBase.GetBoneCoords(AttachBone).Origin);
        P.SetPhysics(PHYS_None);
        VehicleBase.AttachToBone(P, AttachBone);
        P.SetRelativeLocation(DrivePos + P.default.PrePivot);
        P.SetRelativeRotation(DriveRot);
        P.PrePivot = vect(0.0, 0.0, 0.0);
    }
}

// Modified to set bTearOff to true, after a short timer, on a server when player exits, which causes server to close the net channel & destroy client actor
// Need to use a short delay to allow properties updated on exit (e.g. Owner, Driver & PRI all to none) to replicate to client before shutting down net traffic
function DriverLeft()
{
    super.DriverLeft();

    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        SetTimer(0.5, false);
    }
}

// Modified (from deprecated ROPassengerPawn) to remove need to have specified CameraBone, which is irrelevant (in conjunction with modified AttachDriver)
simulated function DetachDriver(Pawn P)
{
    P.PrePivot = P.default.PrePivot;

    if (VehicleBase != none)
    {
        VehicleBase.DetachFromBone(P);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  MISCELLANEOUS ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to set up our properties, using what has been specified in the vehicle's PassengerPawns array, allowing use of a generic passenger pawn class
// Note this will do nothing if specific passenger classes have been used with the vehicle, instead of the PassengerPawns array (because PassengerPawns.Length will be 0)
simulated function InitializeVehicleBase()
{
    local DHVehicle V;
    local int       Index;

    V = DHVehicle(VehicleBase);

    if (V != none && V.PassengerPawns.Length > 0)
    {
        Index = PositionInArray - V.FirstRiderPositionIndex;

        if (Index >= 0 && Index < V.PassengerPawns.Length)
        {
            DrivePos = V.PassengerPawns[Index].DrivePos;
            DriveRot = V.PassengerPawns[Index].DriveRot;
            DriveAnim = V.PassengerPawns[Index].DriveAnim;
            FPCamPos = V.PassengerPawns[Index].FPCamPos;
        }
    }

    super.InitializeVehicleBase();
}

// From deprecated ROPassengerPawn
function float ModifyThreat(float Current, Pawn Threat)
{
    if (Vehicle(Threat) != none)
    {
        return Current - 1.5;
    }

    return Current + 1.0;
}

// Functions emptied out as a passenger pawn has no VehicleWeapon:
simulated function InitializeVehicleWeapon();
simulated function InitializeVehicleAndWeapon();
function bool CanFire() { return false; }
function bool ArePlayersWeaponsLocked(optional bool bNoScreenMessage) { return false; }
function Fire(optional float F); // prevents unnecessary replicated VehicleFire() function calls to server
function VehicleFire(bool bWasAltFire);
event FiredPendingPrimary();
event ApplyFireImpulse(bool bAlt);
function VehicleCeaseFire(bool bWasAltFire);
function ClientVehicleCeaseFire(bool bWasAltFire);
function ClientOnlyVehicleCeaseFire(bool bWasAltFire);
function bool StopWeaponFiring() { return false; }
simulated function IncrementRange();
simulated function DecrementRange();
simulated function bool CanReload() { return false; }
function CheckResumeReloadingOnEntry();
function float GetAmmoReloadState() { return 0.0; }
function bool ResupplyAmmo() { return false; }
simulated event SetRotatingStatus(byte NewRotationStatus);
simulated function ServerSetRotatingStatus(byte NewRotatingStatus);

defaultproperties
{
    bPassengerOnly=true
    bSinglePositionExposed=true
    bUseDriverHeadBoneCam=true
    HudName="Rider"

    PassengerClasses(0)=class'DH_Engine.DHPassengerPawnZero'
    PassengerClasses(1)=class'DH_Engine.DHPassengerPawnOne'
    PassengerClasses(2)=class'DH_Engine.DHPassengerPawnTwo'
    PassengerClasses(3)=class'DH_Engine.DHPassengerPawnThree'
    PassengerClasses(4)=class'DH_Engine.DHPassengerPawnFour'
    PassengerClasses(5)=class'DH_Engine.DHPassengerPawnFive'
    PassengerClasses(6)=class'DH_Engine.DHPassengerPawnSix'
    PassengerClasses(7)=class'DH_Engine.DHPassengerPawnSeven'
    PassengerClasses(8)=class'DH_Engine.DHPassengerPawnEight'
    PassengerClasses(9)=class'DH_Engine.DHPassengerPawnNine'
    PassengerClasses(10)=class'DH_Engine.DHPassengerPawnTen'
}
