//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarVehicle extends ROVehicle
    abstract;

var     DHPawn      OwningPawn;
var     bool        bCanBeResupplied;
var     int         PlayerResupplyAmounts[2];
var     bool        bEnteredOnce;
var     ObjectMap   NotifyParameters;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bCanBeResupplied;
}

//GotoState called from DHPawn.Died to let us know the owner is dead and we should destroy ourselves.
simulated state PendingDestroy
{
Begin:
Sleep(5.0);
Destroy();
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        NotifyParameters = new class'ObjectMap';
        NotifyParameters.Insert("VehicleClass", Class);
    }
}

function PlayerResupply()
{
    WeaponPawns[0].Gun.MainAmmoCharge[0] = Clamp(WeaponPawns[0].Gun.MainAmmoCharge[0] + PlayerResupplyAmounts[0], 0, WeaponPawns[0].GunClass.default.InitialPrimaryAmmo);
    WeaponPawns[0].Gun.MainAmmoCharge[1] = Clamp(WeaponPawns[0].Gun.MainAmmoCharge[1] + PlayerResupplyAmounts[1], 0, WeaponPawns[0].GunClass.default.InitialSecondaryAmmo);

    //If we're full of ammo now, then we can't be resupplied.
    if (WeaponPawns[0].Gun.MainAmmoCharge[0] == WeaponPawns[0].GunClass.default.InitialPrimaryAmmo &&
        WeaponPawns[0].Gun.MainAmmoCharge[1] == WeaponPawns[0].GunClass.default.InitialSecondaryAmmo)
    {
        bCanBeResupplied = false;
    }
}

function bool TryToDrive(Pawn P)
{
    local DHPawn DHP;
    local DHPlayerReplicationInfo PRI;
    local DHRoleInfo RI;

    DHP = DHPawn(P);
    PRI = DHPlayerReplicationInfo(DHP.PlayerReplicationInfo);
    RI = DHRoleInfo(PRI.RoleInfo);

    if (DHP == none || PRI == none || RI == none || !RI.bCanUseMortars)
    {
        P.ReceiveLocalizedMessage(class'DHMortarMessage', 8);
        return false;
    }

    if (DHP.bIsCrawling)
    {
        return false;
    }

    if (WeaponPawns[0].Driver != none)
    {
        P.ReceiveLocalizedMessage(class'DHMortarMessage', 9);
        return false;
    }

    if (VehicleTeam != P.GetTeamNum())
    {
        P.ReceiveLocalizedMessage(class'DHMortarMessage', 10);
        return false;
    }

    if (bEnteredOnce && DHP.Weapon != none && DHP.Weapon.IsA('DHMortarWeapon'))
    {
        return false;
    }

    WeaponPawns[0].KDriverEnter(DHP);

    bEnteredOnce = true;

    SetMortarOwner(DHP);

    return true;
}

simulated function SetMortarOwner(DHPawn P)
{
    if (OwningPawn != none && OwningPawn != P)  //New owner
    {
        OwningPawn.OwnedMortar = none;  //Remove previous ownership
    }

    OwningPawn = P;
    P.OwnedMortar = self;

    if (IsInState('PendingDestroy'))
    {
        GotoState('');
    }
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    //Absolute invincibility.
    return;
}

// Let the player know they can get in this vehicle
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
