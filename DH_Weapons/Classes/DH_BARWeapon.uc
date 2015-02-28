//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BARWeapon extends DH_BipodAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_BAR_1st.ukx

var     name    SelectFireAnim;
var     name    SelectFireIronAnim;
var     name    SightUpSelectFireIronAnim;
var     bool    bSlowFireRate;
var     int     NumMagsToResupply;      // Number of ammo mags to add when this weapon has been resupplied

replication
{
    reliable if (Role < ROLE_Authority)
        ServerChangeFireMode;
}

simulated exec function SwitchFireMode()
{
    if (IsBusy() || FireMode[0].bIsFiring || FireMode[1].bIsFiring)
    {
        return;
    }

    GotoState('SwitchingFireMode');
}

function ServerChangeFireMode()
{
    bSlowFireRate = !bSlowFireRate;

    if (bSlowFireRate)
    {
        FireMode[0].FireRate = 0.2; //slow rate 300rpm

    }
    else
    {
        FireMode[0].FireRate = 0.12; //fast rate 500rpm
    }

}

simulated state SwitchingFireMode extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        local name Anim;

        if (bUsingSights || Instigator.bBipodDeployed)
        {
            if (Instigator.bBipodDeployed && HasAnim(SightUpSelectFireIronAnim))
            {
                Anim = SightUpSelectFireIronAnim;
            }
            else
            {
                Anim = SelectFireIronAnim;
            }
        }
        else
        {
            Anim = SelectFireAnim;
        }

        if (Instigator.IsLocallyControlled())
        {
                PlayAnim(Anim, 1.0, FastTweenTime);
        }

        SetTimer(GetAnimDuration(SelectAnim, 1.0) + FastTweenTime, false);

        ServerChangeFireMode();

        if (Role < ROLE_Authority)
        {
            bSlowFireRate = !bSlowFireRate;

            if (bSlowFireRate)
            {
                FireMode[0].FireRate = 0.2;

            }
            else
            {
                FireMode[0].FireRate = 0.12;
            }
        }
    }
}

// used by the hud icons for select fire
simulated function bool UsingAutoFire()
{
    return !bSlowFireRate;
}

//================================================
// Following 5 functions to allow resupply on Bar
//================================================
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Role == ROLE_Authority)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = true;
        ROPawn(Instigator).bWeaponNeedsResupply = CurrentMagCount != (MaxNumPrimaryMags - 1);
    }
}

simulated function bool PutDown()
{
    return super.PutDown();

    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
    super.GiveTo(Other,Pickup);

    ROPawn(Instigator).bWeaponCanBeResupplied = true;
    ROPawn(Instigator).bWeaponNeedsResupply = CurrentMagCount <= (MaxNumPrimaryMags - 1);
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

    for (i = NumMagsToResupply; i > 0; --i)
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

function bool IsMGWeapon()
{
    return true;
}

defaultproperties
{
    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    SightUpSelectFireIronAnim="SightUp_iron_switch_fire"
    bSlowFireRate=true
    NumMagsToResupply=2
    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6
    IronSightDisplayFOV=25.0
    FreeAimRotationSpeed=2.0
    bHasSelectFire=true
    FireModeClass(0)=class'DH_Weapons.DH_BARFire'
    FireModeClass(1)=class'DH_Weapons.DH_BARMeleeFire'
    PickupClass=class'DH_Weapons.DH_BARPickup'
    AttachmentClass=class'DH_Weapons.DH_BARAttachment'
    ItemName="Browning Automatic Rifle"
    Mesh=SkeletalMesh'DH_BAR_1st.BAR'
}
