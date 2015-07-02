//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarVehicle extends ROVehicle
    abstract;

var     DHPawn      OwningPawn;
var     bool        bEnteredOnce;
var     bool        bCanBeResupplied;
var     int         PlayerResupplyAmounts[2];
var     ObjectMap   NotifyParameters; // an object that can hold references to several other objects, which can be used by messages to build a tailored message

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
        NotifyParameters = new class'ObjectMap';
        NotifyParameters.Insert("VehicleClass", Class);
    }
}

// New function to handle resupply of mortar ammo by another player
function PlayerResupply()
{
    WeaponPawns[0].Gun.MainAmmoCharge[0] = Clamp(WeaponPawns[0].Gun.MainAmmoCharge[0] + PlayerResupplyAmounts[0], 0, WeaponPawns[0].GunClass.default.InitialPrimaryAmmo);
    WeaponPawns[0].Gun.MainAmmoCharge[1] = Clamp(WeaponPawns[0].Gun.MainAmmoCharge[1] + PlayerResupplyAmounts[1], 0, WeaponPawns[0].GunClass.default.InitialSecondaryAmmo);

    // If we're full of ammo now, then we can't be resupplied
    if (WeaponPawns[0].Gun.MainAmmoCharge[0] == WeaponPawns[0].GunClass.default.InitialPrimaryAmmo && 
        WeaponPawns[0].Gun.MainAmmoCharge[1] == WeaponPawns[0].GunClass.default.InitialSecondaryAmmo)
    {
        bCanBeResupplied = false;
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

// New function to record mortar ownership & to cancel any pending destruction
simulated function SetMortarOwner(DHPawn P)
{
    if (OwningPawn != none && OwningPawn != P)
    {
        OwningPawn.OwnedMortar = none;  // remove any previous ownership by another player
    }

    OwningPawn = P;
    P.OwnedMortar = self;

    if (IsInState('PendingDestroy'))
    {
        GotoState('');
    }
}

// No possibility of damage to mortar base
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
}

// Modified to pass new NotifyParameters to message, allowing it to display both the use/enter key & vehicle name
simulated event NotifySelected(Pawn User)
{
    if (Level.NetMode != NM_DedicatedServer && User != none && User.IsHumanControlled() && ((Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime))
    {
        NotifyParameters.Insert("Controller", User.Controller);

        PlayerController(User.Controller).ReceiveLocalizedMessage(TouchMessageClass, 0,,, NotifyParameters);

        LastNotifyTime = Level.TimeSeconds;
    }
}

defaultproperties
{
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
}
