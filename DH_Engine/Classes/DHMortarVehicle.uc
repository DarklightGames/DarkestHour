//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHMortarVehicle extends ROVehicle
    abstract;

var     DHPawn      OwningPawn;
var     bool        bEnteredOnce;
var     bool        bCanBeResupplied;
var     TreeMap_string_Object   NotifyParameters; // an object that can hold references to several other objects, which can be used by messages to build a tailored message

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bCanBeResupplied;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerDestroyMortar;
}

// New state called from DHPawn.Died() to let us know the mortar owner is dead & we should destroy the mortar actors
simulated state PendingDestroy
{
Begin:
    Sleep(5.0);
    Destroy();
}

// Called by net client after un-deploying mortar & putting it back into carried inventory, so mortar 'vehicle' actors are now destroyed
// Only called after client has completed the exiting process & it is safe for the server to destroy the vehicle actors (otherwise everything gets screwed up !)
function ServerDestroyMortar()
{
    Destroy();
}

// Modified to set up new NotifyParameters object, including this vehicle class, which gets passed to screen messages & allows them to display vehicle name
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        NotifyParameters = new class'TreeMap_string_Object';
        NotifyParameters.Put("VehicleClass", Class);
    }
}

// Modified to handle special requirements to use mortar, with custom messages, & to put player into mortar's VehicleWeaponPawn
function bool TryToDrive(Pawn P)
{
    local DHPawn                  DHP;
    local DHPlayerReplicationInfo PRI;
    local DHRoleInfo              RI;

    DHP = DHPawn(P);
    PRI = DHPlayerReplicationInfo(DHP.PlayerReplicationInfo);
    RI = DHRoleInfo(PRI.RoleInfo);

    if (DHP == none || PRI == none || RI == none || !RI.bCanUseMortars)
    {
        P.ReceiveLocalizedMessage(class'DHMortarMessage', 8); // not qualified to operate mortar

        return false;
    }

    if (DHP.bIsCrawling)
    {
        return false;
    }

    if (WeaponPawns[0].Driver != none)
    {
        P.ReceiveLocalizedMessage(class'DHMortarMessage', 9); // mortar already being used

        return false;
    }

    if (VehicleTeam != P.GetTeamNum())
    {
        P.ReceiveLocalizedMessage(class'DHMortarMessage', 10); // can't use enemy mortar

        return false;
    }

    if (bEnteredOnce)
    {
        if (DHMortarWeapon(DHP.Weapon) != none)
        {
            return false; // no entry if player is holding an undeployed mortar
        }
    }
    else
    {
        bEnteredOnce = true;
    }

    WeaponPawns[0].KDriverEnter(DHP);
    SetMortarOwner(DHP);

    return true;
}

// Record the player manning the mortar, including to clear any previous owner & cancel any pending mortar destruction (if previous owner has been killed)
simulated function SetMortarOwner(DHPawn P)
{
    if (P != none)
    {
        // A new player is manning the mortar, so remove any previously recorded ownership
        if (OwningPawn != none && OwningPawn != P)
        {
            OwningPawn.OwnedMortar = none;
        }

        OwningPawn = P;
        P.OwnedMortar = self;

        // Cancel any pending destruction
        if (IsInState('PendingDestroy'))
        {
            GotoState('');
        }
    }
}

// No possibility of damage to mortar base
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
}

// From ROWheeledVehicle, to use VehicleTeam, same as all other vehicles
simulated function int GetTeamNum()
{
    if (Role == Role_Authority && (Team == 255 || Team == 2) && Controller != none)
    {
        SetTeamNum(Controller.GetTeamNum());
    }

    return VehicleTeam;
}

// Modified to pass new NotifyParameters to message, allowing it to display both the use/enter key & vehicle name
simulated event NotifySelected(Pawn User)
{
    local DHPawn P;

    P = DHPawn(User);

    if (Level.NetMode != NM_DedicatedServer &&
        P != none &&
        P.IsHumanControlled() &&
        P.GetTeamNum() == VehicleTeam &&
        ((Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime))
    {
        if (P.GetRoleInfo() != none &&
            P.GetRoleInfo().bCanUseMortars)
        {
            NotifyParameters.Put("Controller", User.Controller);
            User.ReceiveLocalizedMessage(TouchMessageClass, 0,,, NotifyParameters);
            LastNotifyTime = Level.TimeSeconds;
        }
        else if (bCanBeResupplied && !P.bUsedCarriedMGAmmo && OwningPawn != P)
        {
            User.ReceiveLocalizedMessage(class'DHPawnTouchMessage', 0, PlayerReplicationInfo,, User.Controller);
            LastNotifyTime = Level.TimeSeconds;
        }
    }
}

// Functions emptied out as mortar bases cannot be occupied:
function KDriverEnter(Pawn P);
simulated function ClientKDriverEnter(PlayerController PC);
simulated event DrivingStatusChanged();
simulated function NextWeapon();
simulated function PrevWeapon();
function ServerChangeViewPoint(bool bForward);
simulated function SwitchWeapon(byte F);
function ServerChangeDriverPosition(byte F);
function bool KDriverLeave(bool bForceLeave);
function DriverDied();
function DriverLeft();
function bool PlaceExitingDriver() { return false; }
simulated function SetPlayerPosition();
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation);
simulated function DrawHUD(Canvas C);
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged);
simulated function int LimitYaw(int yaw) { return yaw; }
function int LimitPawnPitch(int pitch) { return pitch; }
function Fire(optional float F);
event CheckReset();

defaultproperties
{
    bNeverReset=true
    ExplosionSoundRadius=0.0
    ExplosionDamage=0.0
    ExplosionRadius=0.0
    ExplosionMomentum=0.0
    TouchMessageClass=class'DHVehicleTouchMessage'
    MaxDesireability=0.0
    GroundSpeed=0.0
    bOwnerNoSee=false
    CollisionRadius=20.0
    CollisionHeight=10.0
    Mesh=SkeletalMesh'DH_Mortars_3rd.MortarBase_generic' // not visible, just a 1 bone mesh to attach VehicleWeapon to, so don't need separate models for different mortars
    Physics=PHYS_None // stops karma log error as mortar base has no karma collision (i.e. pink collision boxes for mesh) or KarmaParams

    // Exit positions
    ExitPositions(0)=(Y=48.0)
    ExitPositions(1)=(X=-48.0)
    ExitPositions(2)=(X=-48.0,Y=-48.0)
    ExitPositions(3)=(X=-48.0,Y=48.0)
    ExitPositions(4)=(Y=-48.0)
}
