//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BrenWeapon extends DHBipodAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Bren_1st.ukx

var     int     NumMagsToResupply;      // Number of ammo mags to add when this weapon has been resupplied

simulated function AnimEnd(int channel)
{
    local   name    anim;
    local   float   frame, rate;

    GetAnimParams(0, anim, frame, rate);

    if (ClientState == WS_ReadyToFire)
    {
        if (anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim) && (!FireMode[0].bIsFiring || !UsingAutoFire()))
        {
            PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, FastTweenTime);
        }
        else if (anim == DHProjectileFire(FireMode[0]).FireIronAnim && (!FireMode[0].bIsFiring || !UsingAutoFire()))
        {
            PlayIdle();
        }
        else if (anim== FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
        {
            PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
        }
        else if ((FireMode[0] == none || !FireMode[0].bIsFiring) && (FireMode[1] == none || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

//================================================
// Following 5 functions to allow resupply on Bren
//================================================
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Role == ROLE_Authority)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = true;

        if (CurrentMagCount != (MaxNumPrimaryMags - 1))
        {
            ROPawn(Instigator).bWeaponNeedsResupply = true;
        }
        else
        {
            ROPawn(Instigator).bWeaponNeedsResupply = false;
        }
    }
}

simulated function bool PutDown()
{
    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;

    return super.PutDown();
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
    super.GiveTo(Other,Pickup);

    ROPawn(Instigator).bWeaponCanBeResupplied = true;

    if (CurrentMagCount <= (MaxNumPrimaryMags - 1))
    {
        ROPawn(Instigator).bWeaponNeedsResupply = true;
    }
    else
    {
        ROPawn(Instigator).bWeaponNeedsResupply = false;
    }
}

function DropFrom(vector StartLocation)
{
    if (!bCanThrow)
    {
        return;
    }

    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;

    super.DropFrom(StartLocation);
}

simulated function Destroyed()
{
    if (Role == ROLE_Authority && Instigator!= none && ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = false;
        ROPawn(Instigator).bWeaponNeedsResupply = false;
    }

    super.Destroyed();
}

// This MG has been resupplied either by an ammo resupply area or another player
function bool ResupplyAmmo()
{
    local int InitialAmount, i;

    InitialAmount = FireMode[0].AmmoClass.default.InitialAmount;

    for (i = NumMagsToResupply; i > 0; i--)
    {
        if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
        {
            PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
        }
    }

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
    NetUpdateTime = Level.TimeSeconds - 1;

    return true;
}

defaultproperties
{
    NumMagsToResupply=2
    SightUpIronBringUp="Deploy"
    SightUpIronPutDown="undeploy"
    SightUpIronIdleAnim="deploy_idle"
    SightUpMagEmptyReloadAnim="deploy_reload_empty"
    SightUpMagPartialReloadAnim="deploy_reload_half"
    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6
    FireModeClass(0)=class'DH_Weapons.DH_BrenFire'
    FireModeClass(1)=class'DH_Weapons.DH_BrenMeleeFire'
    PickupClass=class'DH_Weapons.DH_BrenPickup'
    AttachmentClass=class'DH_Weapons.DH_BrenAttachment'
    ItemName="Bren Mk.IV"
    Mesh=SkeletalMesh'DH_Bren_1st.Bren'
}
