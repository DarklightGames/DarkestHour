//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPassengerPawn extends DHVehicleWeaponPawn
    abstract;

/**
Matt UK, November 2014 - added new system to avoid rider pawns needing to exist on net clients unless rider position is occupied
Each rider pawn that exists on a client is a net channel that has to be maintained & updated by the server.
The new system can substantially cut down the number of net channels & associated replication, especially in maps with lots of vehicles.
We toggle the bTearOff flag for each rider pawn when it is unoccupied/occupied, which causes the usual clientside simulated actors to spawn or be destroyed.
When bTearOff is set, the actor stops being net relevant & the server closes the channel, stops replicating the actor & destroys the clientside version.
The trick is to stop the actor from actually being torn off on the client, otherwise that causes us big problems & breaks the system.
There is a built-in delay of 5 seconds before the server decides the actor isn't net relevant, closes the channel & destroys the clientside actor.
If a player switches back to the old rider position within these 5 secs, we need them to re-occupy the existing rider pawn & abort closing the channel.
I've found a way to achieve this is to delay the next NetUpdateTime to be >5 seconds in the future, which delays bTearOff from replicating to clients.
That way the server closes the channel & destroys the clientside actor before bTearOff is sent to the client, so it never actually gets torn off.
And if a player re-enters the rider position during these 5 secs, we just change bTearOff back to false & it becomes net relevant again.
A further complication is when a player exits a rider pawn, we need to introduce a very short delay before setting bTearOff on server, so a 0.5 sec timer is used.
This is necessary to allow properties updated on exit (e.g. Owner, Driver & PRI all none) to replicate to clients before shutting down all net traffic.
Changes in other classes: slight modifications to functions NumPassengers in Vehicle classes & DrawVehicleIcon in DHHud, to work with new system & avoid errors.
*/

// An array of subclasses, one specifically assigned for each index position in the vehicle's WeaponPawns array, so this actor knows its own PositionInArray
// Facilitates using a generic passenger pawn class for all vehicles, with properties being specified in vehicle's PassengerPawns array
// Avoids need for lots of passenger pawn classes for every vehicle, but we need subclasses with PositionInArray as net client has to know its index position
// Note that if really needed we can still use specific passenger classes with a vehicle, instead of the PassengerPawns array
var     array<class<DHPassengerPawn> >  PassengerClasses;

var     bool    bNeedToInitializeDriver;     // clientside flag that we need to do some player set up, once we receive the Driver actor
var     bool    bNeedToStoreVehicleRotation; // clientside flag that we need to set StoredVehicleRotation, once we receive the VehicleBase actor
var     bool    bUseDriverHeadBoneCam;       // use the driver's head bone for the camera location
var     bool    bDebugExitPositions;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleDebugExits; // in debug mode only
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to set bTearOff to true on a server, which stops this rider pawn being replicated to clients (until entered, when we unset bTearOff)
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        bTearOff = true;
    }
}

// Modified to make sure net clients attach the player in the correct position when vehicle is replicated to client
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role < ROLE_Authority && bDriving)
    {
        bNeedToInitializeDriver = true;
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Sets bTearOff to true on a server when player exits, purely so server decides the actor is no longer net relevant, kills off the clientside actor & closes the net channel
// But we don't want the clientside actor to actually get torn off, as that would cause us big problems, so we have to stop bTearOff from reaching the client
// So we delay the next update to the client for longer than the server's 5 second delay before it kills a clientside actor after it becomes net irrelevant
function Timer()
{
    if (!bDriving && !bTearOff && (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer))
    {
        NetUpdateTime = Level.TimeSeconds + (6.0 * Level.Game.GameSpeed);
        bTearOff = true;
    }
}

// Modified to ensure player pawn is attached, as on replication, AttachDriver() only works if client has received VehicleBase actor, which it may not have yet
// Also to call SetPassengerProperties when net client receives VehicleBase, & to remove stuff not relevant to a passenger pawn as it has no VehicleWeapon
simulated function PostNetReceive()
{
    local bool bAddSelfToWeaponPawns;
    local int  i;

    // Initialize the vehicle base
    if (!bInitializedVehicleBase)
    {
        if (VehicleBase != none)
        {
            bInitializedVehicleBase = true;

            // Set up our properties from vehicle's PassengerPawns array
            SetPassengerProperties();

            // Set StoredVehicleRotation if it couldn't be set in ClientKDriverEnter() due to not then having the VehicleBase actor (replication timing issues)
            if (bNeedToStoreVehicleRotation)
            {
                StoredVehicleRotation = VehicleBase.Rotation;
            }

            // On client, this actor is destroyed if becomes net irrelevant - when it respawns, empty WeaponPawns array needs filling again or will cause lots of errors
            // First check if our WeaponPawns slot doesn't exist, is empty or has an invalid member
            if (PositionInArray >= VehicleBase.WeaponPawns.Length || VehicleBase.WeaponPawns[PositionInArray] == none || VehicleBase.WeaponPawns[PositionInArray].default.Class == none)
            {
                bAddSelfToWeaponPawns = true;

                // Then make sure that somehow another WeaponPawns slot isn't already occupied by this actor or an actor of the same class
                for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
                {
                    if (VehicleBase.WeaponPawns[i] != none && (VehicleBase.WeaponPawns[i] == self || VehicleBase.WeaponPawns[i].Class == class))
                    {
                        bAddSelfToWeaponPawns = false;
                        break;
                    }
                }
            }

            if (bAddSelfToWeaponPawns)
            {
                VehicleBase.WeaponPawns[PositionInArray] = self;
            }
        }
    }
    // Fail-safe so if we somehow lose our VehicleBase reference after initializing, we unset our flag & are then ready to re-initialize when we receive VehicleBase again
    else if (VehicleBase == none)
    {
        bInitializedVehicleBase = false;
    }

    // Make sure player pawn is attached, as on replication, AttachDriver() only works if client has received VehicleBase actor, which it may not have yet
    // Client then receives Driver attachment and RelativeLocation through replication, but this is unreliable & sometimes gives incorrect positioning
    // As a fix, if player pawn has flagged bNeedToAttachDriver (meaning attach failed), we call AttachDriver() here
    if (bNeedToInitializeDriver && Driver != none && VehicleBase != none)
    {
        bNeedToInitializeDriver = false;

        if (DHPawn(Driver) != none && DHPawn(Driver).bNeedToAttachDriver)
        {
            DetachDriver(Driver);
            AttachDriver(Driver);
            DHPawn(Driver).bNeedToAttachDriver = false;
        }
    }
}

// Modified to call SetPassengerProperties - this is where we do it for standalones or servers, because we need the VehicleBase
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    if (Role == ROLE_Authority)
    {
        VehicleBase = VehiclePawn; // this is all that's in the super
        SetPassengerProperties();
    }
}

// New function to set up our properties, using what has been specified in the vehicle's PassengerPawns array, allowing use of a generic passenger pawn class
// Note this will do nothing if specific passenger classes have been used with the vehicle, instead of the PassengerPawns array (because PassengerPawns.Length will be 0)
simulated function SetPassengerProperties()
{
    local DHVehicle V;
    local int       Index;

    V = DHVehicle(VehicleBase);

    if (V != none)
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
        CameraLocation = CameraLocation + (FPCamPos >> CameraRotation);
    }

    // Finalise the camera with any shake
    CameraLocation = CameraLocation + (PC.ShakeOffset >> PC.Rotation);
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

// From ROPassengerPawn
simulated function vector GetCameraLocationStart()
{
    if (VehicleBase != none)
    {
        return VehicleBase.GetBoneCoords(CameraBone).Origin;
    }

    return Location;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE ENTRY  ******************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to fix bug where you couldn't switch between rider positions if a tanker hadn't yet entered the tank, & to remove obsolete stuff & duplication from the Supers
function bool TryToDrive(Pawn P)
{
    // Deny entry if vehicle has driver or is dead, or if player is crouching or on fire or reloading a weapon (plus several very obscure other reasons)
    if (Driver != none || Health <= 0 || P == none || (DHPawn(P) != none && DHPawn(P).bOnFire) || (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none || !P.Controller.bIsPlayer || P.DrivenVehicle != none || P.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    if (VehicleBase != none)
    {
        // Trying to enter a vehicle that isn't on our team
        if (P.GetTeamNum() != VehicleBase.VehicleTeam) // VehicleTeam reliably gives the team, even if vehicle hasn't yet been entered
        {
            if (VehicleBase.Driver == none)
            {
                return VehicleBase.TryToDrive(P);
            }

            P.ReceiveLocalizedMessage(class'DHVehicleMessage', 1); // can't use enemy vehicle

            return false;
        }

        // Bot tries to enter the VehicleBase if it has no driver
        if (!P.IsHumanControlled() && VehicleBase.Driver == none)
        {
            return VehicleBase.TryToDrive(P);
        }
    }

    // Passed all checks, so allow player to enter the vehicle
    if (bEnterringUnlocks && bTeamLocked)
    {
        bTeamLocked = false;
    }

    KDriverEnter(P);

    return true;
}

// Modified (in deprecated ROPassengerPawn) to remove any 'Gun' references
// Further modified to unset bTearOff on a server, which makes this rider pawn potentially relevant to clients & always to the one entering the rider position
// Also to set rotation to match the way the rider is facing, so his view starts facing the same way, & to remove redundancy & optimise the ordering of the function
function KDriverEnter(Pawn P)
{
    local Controller C;
    local rotator NewRotation;

    // On a server, disable bTearOff so this actor replicates to relevant net clients
    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        SetTimer(0.0, false); // clear any timer, so we don't risk setting bTearOff to true again just after we enter
        bTearOff = false;     // don't need to do quick net update as normal entering sequence already does it
    }

    bDriving = true;
    StuckCount = 0;

    // Set player's current controller to control this vehicle pawn instead & make the player our 'Driver'
    C = P.Controller;
    Driver = P;
    Driver.StartDriving(self);

    // Make the player unpossess its DHPawn body & possess this vehicle pawn
    C.bVehicleTransition = true; // to keep Bots from doing Restart()
    C.Unpossess();
    Driver.SetOwner(self); // this keeps the driver relevant
    C.Possess(self);
    C.bVehicleTransition = false;
    DrivingStatusChanged();
    Level.Game.DriverEnteredVehicle(self, P);

    // Match player's rotation to match the way the rider is facing, so his view starts facing the same way
    NewRotation.Yaw = DriveRot.Yaw;
    SetRotation(NewRotation);
    Driver.bSetPCRotOnPossess = false; // so when player gets out, he'll be facing the same direction as he was in the vehicle

    if (PlayerController(C) != none)
    {
        VehicleLostTime = 0.0;
    }
}

// Matt: modified to work around common problems on net clients when deploying into a spawn vehicle, caused by replication timing issues (see notes in DHVehicleMGPawn.ClientKDriverEnter)
// Also to set rotation to match the way the rider is facing, so his view starts facing the same way
simulated function ClientKDriverEnter(PlayerController PC)
{
    local rotator NewRotation;

    // Fix possible replication timing problems on a net client
    if (Role < ROLE_Authority && PC != none)
    {
        // No known problems with these replicated variables in this class, but added to match other Vehicle classes
        Controller = PC;
        SetOwner(PC);
        Role = ROLE_AutonomousProxy;

        // Fix for problem where net client may be in state 'Spectating' when deploying into spawn vehicle
        if (PC.IsInState('Spectating'))
        {
            PC.GotoState('PlayerWalking');
        }
    }

    if (VehicleBase != none)
    {
        StoredVehicleRotation = VehicleBase.Rotation;
    }
    else
    {
        bNeedToStoreVehicleRotation = true; // fix for problem where net client may not yet have VehicleBase actor when deploying into spawn vehicle
    }

    super(Vehicle).ClientKDriverEnter(PC);

    PC.SetFOV(WeaponFOV);

    NewRotation.Yaw = DriveRot.Yaw;
    SetRotation(NewRotation);
}

// Modified just to avoid confusing attachment to CameraBone & instead use the usual WeaponBone specified in the vehicle's PassengerWeapons array
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

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE EXIT  ********************************* //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add clientside checks before sending the function call to the server
// Optimises network performance generally & specifically avoids a rider camera bug when unsuccessfully trying to switch to another vehicle position
simulated function SwitchWeapon(byte F)
{
    local VehicleWeaponPawn WeaponPawn;
    local bool              bMustBeTankerToSwitch;
    local byte              ChosenWeaponPawnIndex;

    if (Role < ROLE_Authority) // only do these clientside checks on a net client
    {
        if (VehicleBase == none)
        {
            return;
        }

        // Trying to switch to driver position
        if (F == 1)
        {
            // Stop call to server as there is already a human driver
            if (VehicleBase.Driver != none && VehicleBase.Driver.IsHumanControlled())
            {
                return;
            }

            if (VehicleBase.bMustBeTankCommander)
            {
                bMustBeTankerToSwitch = true;
            }
        }
        // Trying to switch to non-driver position
        else
        {
            ChosenWeaponPawnIndex = F - 2;

            // Stop call to server if player has selected an invalid weapon position or the current position
            // Note that if player presses 0, which is invalid choice, the byte index will end up as 254 & so will still fail this test (which is what we want)
            if (ChosenWeaponPawnIndex >= VehicleBase.PassengerWeapons.Length || ChosenWeaponPawnIndex == PositionInArray)
            {
                return;
            }

            // Stop call to server if weapon position already has a human player
            // Note we don't try to stop call to server if weapon pawn doesn't exist, as probably won't on net client, but will get replicated if player enters position on server
            if (ChosenWeaponPawnIndex < VehicleBase.WeaponPawns.Length)
            {
                WeaponPawn = VehicleBase.WeaponPawns[ChosenWeaponPawnIndex];

                if (WeaponPawn != none && WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
                {
                    return;
                }
            }

            if (class<ROVehicleWeaponPawn>(VehicleBase.PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass).default.bMustBeTankCrew)
            {
                bMustBeTankerToSwitch = true;
            }
        }

        // Stop call to server if player has selected a tank crew role but isn't a tanker
        if (bMustBeTankerToSwitch && !(Controller != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) != none
            && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
        {
            ReceiveLocalizedMessage(class'DHVehicleMessage', 0); // not qualified to operate vehicle

            return;
        }
    }

    ServerChangeDriverPosition(F);
}

// Modified to give player the same momentum as the vehicle when exiting
// Also to remove overlap with DriverDied(), moving common features into DriverLeft(), which gets called by both functions
function bool KDriverLeave(bool bForceLeave)
{
    local vector ExitVelocity;

    if (!bForceLeave)
    {
        ExitVelocity = Velocity;
        ExitVelocity.Z += 60.0; // add a little height kick to allow for hacked in damage system
    }

    if (super(VehicleWeaponPawn).KDriverLeave(bForceLeave))
    {
        if (!bForceLeave)
        {
            Instigator.Velocity = ExitVelocity;
        }

        return true;
    }

    return false;
}

// Modified to remove overlap with KDriverLeave(), moving common features into DriverLeft(), which gets called by both functions
function DriverDied()
{
    super(Vehicle).DriverDied();

    DriverLeft(); // fix Unreal bug (as done in ROVehicle), as DriverDied should call DriverLeft, the same as KDriverLeave does
}

// Modified to add common features from KDriverLeave() & DriverDied(), which both call this function
function DriverLeft()
{
    if (VehicleBase != none)
    {
        VehicleBase.MaybeDestroyVehicle(); // set spiked vehicle timer if it's an empty, disabled vehicle
    }

    DrivingStatusChanged(); // the Super from Vehicle
}

// Overridden to set passenger exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    if (VehicleBase != none)
    {
        NewRot = VehicleBase.Rotation;
        NewRot.Pitch = LimitPitch(NewRot.Pitch);
        SetRotation(NewRot);
    }

    super.ClientKDriverLeave(PC);
}

// Modified to set bTearOff to true (after a short timer) on a server when player exits, which kills off the clientside actor & closes the net channel
// Need to use timer to add short delay, to allow properties updated on exit (e.g. Owner, Driver & PRI all none) to replicate to client before shutting down all net traffic
simulated event DrivingStatusChanged()
{
    super.DrivingStatusChanged();

    if (!bDriving && (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer))
    {
        SetTimer(0.5, false);
    }
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
// Also to trace from player's actual world location, with a smaller trace extent so player is less likely to snag on objects that wouldn't really block his exit
function bool PlaceExitingDriver()
{
    local vector Extent, ZOffset, ExitPosition, HitLocation, HitNormal;
    local int    StartIndex, i;

    if (Driver == none || VehicleBase == none)
    {
        return false;
    }

    // Set extent & ZOffset, using a smaller extent than original
    Extent.X = Driver.default.DrivingRadius;
    Extent.Y = Driver.default.DrivingRadius ;
    Extent.Z = Driver.default.DrivingHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Debug exits - uses DHPassengerPawn class default, allowing bDebugExitPositions to be toggled for all passenger pawns
    if (class'DHPassengerPawn'.default.bDebugExitPositions)
    {
        for (i = 0; i < VehicleBase.ExitPositions.Length; ++i)
        {
            ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

            Spawn(class'DHDebugTracer',,, ExitPosition);
        }
    }

    i = Clamp(PositionInArray + 1, 0, VehicleBase.ExitPositions.Length - 1);
    StartIndex = i;

    // Check whether player can be moved to each exit position & use the 1st valid one we find
    while (i >= 0 && i < VehicleBase.ExitPositions.Length)
    {
        ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

        if (VehicleBase.Trace(HitLocation, HitNormal, ExitPosition, Driver.Location + ZOffset - Driver.default.PrePivot, false, Extent) == none
            && Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) == none
            && Driver.SetLocation(ExitPosition))
        {
            return true;
        }

        ++i;

        if (i == StartIndex)
        {
            break;
        }
        else if (i == VehicleBase.ExitPositions.Length)
        {
            i = 0;
        }
    }

    return false;
}

// Modified to remove need to have specified CameraBone, which is irrelevant (in conjunction with modified AttachDriver)
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

// Emptied out as we don't have a GunClass to cache (from ROPassengerPawn)
static function StaticPrecache(LevelInfo L)
{
}

// From ROPassengerPawn
simulated function bool PointOfView()
{
    return false;
}

// Emptied out to prevent unnecessary replicated function calls to server
function Fire(optional float F)
{
}

function AltFire(optional float F)
{
}

// From ROPassengerPawn
function float ModifyThreat(float Current, Pawn Threat)
{
    if (Vehicle(Threat) != none)
    {
        return Current - 1.5;
    }

    return Current + 1.0;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Allows debugging exit positions to be toggled for all rider pawns
exec function ToggleDebugExits()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DHPassengerPawn'.default.bDebugExitPositions = !class'DHPassengerPawn'.default.bDebugExitPositions;
        Log("DHPassengerPawn.bDebugExitPositions =" @ class'DHPassengerPawn'.default.bDebugExitPositions);
    }
}

defaultproperties
{
    bPassengerOnly=true
    bSinglePositionExposed=true
    bKeepDriverAuxCollision=true
    bUseDriverHeadBoneCam=true
    WeaponFOV=90.0
    bHasAltFire=false
    HudName="Rider"
    TPCamDistance=200.0 // TEST - others are 300?
    TPCamLookat=(X=-25.0,Y=0.0,Z=0.0)
    TPCamWorldOffset=(X=0.0,Y=0.0,Z=120.0)

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

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & may be hard coded into functionality:
    bPCRelativeFPRotation=true
    bZeroPCRotOnEntry=false
    bSetPCRotOnPossess=false
    bFPNoZFromCameraPitch=false
    bAllowViewChange=false
    bDesiredBehindView=false
    FPCamViewOffset=(X=0.0,Y=0.0,Z=0.0) // always use FPCamPos for any camera offset (but shouldn't need to, as we use player's head bone for camera location)
}
