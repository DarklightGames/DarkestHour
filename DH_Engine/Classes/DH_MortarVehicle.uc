//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MortarVehicle extends ROVehicle
    abstract;

var DH_Pawn OwningPawn;
var bool    bCanBeResupplied;
var int     PlayerResupplyAmounts[2];

var bool    bEnteredOnce;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bCanBeResupplied;
}

//GotoState called from DH_Pawn.Died to let us know the owner is dead and we should destroy ourselves.
simulated state PendingDestroy
{
Begin:
Sleep(5.0);
Destroy();
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
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
    local DH_Pawn DHP;
    local DHPlayerReplicationInfo PRI;
    local DH_RoleInfo RI;

    DHP = DH_Pawn(P);
    PRI = DHPlayerReplicationInfo(DHP.PlayerReplicationInfo);
    RI = DH_RoleInfo(PRI.RoleInfo);

    if (DHP == none || PRI == none || RI == none || !RI.bCanUseMortars)
    {
        P.ReceiveLocalizedMessage(class'DH_MortarMessage', 8);
        return false;
    }

    if (DHP.bIsCrawling)
    {
        return false;
    }

    if (WeaponPawns[0].Driver != none)
    {
        P.ReceiveLocalizedMessage(class'DH_MortarMessage', 9);
        return false;
    }

    if (VehicleTeam != P.GetTeamNum())
    {
        P.ReceiveLocalizedMessage(class'DH_MortarMessage', 10);
        return false;
    }

    if (bEnteredOnce && DHP.Weapon.IsA('DH_MortarWeapon'))
    {
        return false;
    }

    WeaponPawns[0].KDriverEnter(DHP);

    bEnteredOnce = true;

    SetMortarOwner(DHP);

    return true;
}

simulated function SetMortarOwner(DH_Pawn P)
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

defaultproperties
{
    ExplosionSoundRadius=0.0
    ExplosionDamage=0.0
    ExplosionRadius=0.0
    ExplosionMomentum=0.0
    TouchMessage="Operate "
    MaxDesireability=0.0
    GroundSpeed=0.0
    bOwnerNoSee=false
    CollisionRadius=20.0
    CollisionHeight=10.0
}
