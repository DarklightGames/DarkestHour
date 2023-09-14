//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarVehicle extends DHVehicle
    abstract;

var     DHPawn      OwningPawn;       // reference to the player pawn that owns this mortar (the current operator or the last player to man it)
var     bool        bCanBeResupplied; // flags that the mortar doesn't have full ammo & so can receive passed ammo

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
state PendingDestroy // TODO: perhaps use native ResetTime to do the same thing, deprecating this & related stuff?
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

simulated function Destroyed()
{
    super.Destroyed();

    if (NotifyParameters != none)
    {
        NotifyParameters.Clear();
    }
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

// Modified to handle special requirements to use mortar, with custom messages
function bool TryToDrive(Pawn P)
{
    local DHPawn     DHP;
    local DHRoleInfo RI;

    DHP = DHPawn(P);

    // Deny entry if player is on fire, or is crawling, or reloading a weapon (plus several very obscure other reasons)
    if (Health <= 0 || DHP == none || DHP.bOnFire || DHP.bIsCrawling || (DHP.Weapon != none && DHP.Weapon.IsInState('Reloading')) ||
        DHP.Controller == none || !DHP.Controller.bIsPlayer || DHP.DrivenVehicle != none || DHP.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, DHP) ||
        WeaponPawns.Length == 0 || WeaponPawns[0] == none)
    {
        return false;
    }

    // Deny entry to enemy mortar
    if (DHP.GetTeamNum() != VehicleTeam)
    {
        DHP.ReceiveLocalizedMessage(class'DHMortarMessage', 10); // can't use enemy mortar

        return false;
    }

    // Deny entry if not a mortar operator
    RI = DHP.GetRoleInfo();

    if (RI == none || !RI.bCanUseMortars)
    {
        DHP.ReceiveLocalizedMessage(class'DHMortarMessage', 8); // not qualified to operate mortar

        return false;
    }

    // Deny entry to mortar that's already manned
    if (WeaponPawns[0].Driver != none)
    {
        DHP.ReceiveLocalizedMessage(class'DHMortarMessage', 9); // mortar already being used

        return false;
    }

    // No entry if the player is holding an undeployed mortar
    if (DHMortarWeapon(DHP.Weapon) != none)
    {
        return false;
    }

    // Passed all checks, so allow player to man the mortar
    KDriverEnter(P);

    return true;
}

// Modified to put the player straight into the mortar weapon pawn position, & to cancel any pending destruction (if a previous owner has been killed)
// Also for the new owning player & the mortar to register each other
function KDriverEnter(Pawn P)
{
    local DHPawn DHP;

    DHP = DHPawn(P);

    if (DHP != none && WeaponPawns.Length >= 0 && WeaponPawns[0] != none)
    {
        if (IsInState('PendingDestroy'))
        {
            GotoState('');
        }

        WeaponPawns[0].KDriverEnter(DHP);

        if (OwningPawn != DHP && OwningPawn != none)
        {
            OwningPawn.OwnedMortar = none; // clear a previously recorded owner
        }

        OwningPawn = DHP;
        DHP.OwnedMortar = self;
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
        else if (bCanBeResupplied && !P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo && OwningPawn != P)
        {
            User.ReceiveLocalizedMessage(class'DHPawnTouchMessage', 0, PlayerReplicationInfo,, User.Controller);
            LastNotifyTime = Level.TimeSeconds;
        }
    }
}

// Functions emptied out as mortar bases cannot be occupied:
simulated function ClientKDriverEnter(PlayerController PC);
simulated event DrivingStatusChanged();
simulated function NextWeapon();
simulated function PrevWeapon();
function ServerChangeViewPoint(bool bForward);
simulated function SwitchWeapon(byte F);
function ServerChangeDriverPosition(byte F);
function bool KDriverLeave(bool bForceLeave) { return false; }
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

    // Exit positions
    ExitPositions(0)=(Y=48.0)
    ExitPositions(1)=(X=-48.0)
    ExitPositions(2)=(X=-48.0,Y=-48.0)
    ExitPositions(3)=(X=-48.0,Y=48.0)
    ExitPositions(4)=(Y=-48.0)
    ExitPositions(5)=()

    // Karma properties - minimal, just to stop "KInitActorDynamics: No Model" log error every time actor spawns (also had to add a small karma collision box to mesh)
    Begin Object Class=KarmaParamsRBFull Name=KParams0
    End Object
    KParams=KarmaParamsRBFull'KParams0'

    bShouldDrawPositionDots=false
    bShouldDrawOccupantList=false
}
