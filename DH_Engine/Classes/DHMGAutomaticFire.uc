//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHMGAutomaticFire extends DHFastAutoFire
    abstract;

var()       float           PctHipMGPenalty;    // The amount of recoil to add when the player firing an MG from the hip
var         DHMGWeapon      MGWeapon;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    MGWeapon = DHMGWeapon(Weapon);
}

// Modified to make rounds disappear from the visible ammo belt when nearly out of ammo
event ModeDoFire()
{
    super.ModeDoFire();

    if (Level.NetMode != NM_DedicatedServer)
    {
        MGWeapon.UpdateAmmoBelt();
    }
}

    {
    }
}

// Modified to apply PctHipMGPenalty if player is hip-firing the MG (bUsingSights signifies this)
// That replaces all recoil adjustments for bUsingSights in the Super
simulated function HandleRecoil()
{
    local ROPlayer ROP;
    local ROPawn   ROPwn;
    local rotator  NewRecoilRotation;

    if (Instigator != none)
    {
        ROP = ROPlayer(Instigator.Controller);
        ROPwn = ROPawn(Instigator);
    }

    if (ROP == none || ROPwn == none)
    {
        return;
    }

    if (!ROP.bFreeCamera)
    {
        NewRecoilRotation.Pitch = RandRange(MaxVerticalRecoilAngle * 0.75, MaxVerticalRecoilAngle);
        NewRecoilRotation.Yaw = RandRange(MaxHorizontalRecoilAngle * 0.75, MaxHorizontalRecoilAngle);

        if (Rand(2) == 1)
        {
            NewRecoilRotation.Yaw *= -1;
        }

        if (Instigator.Physics == PHYS_Falling)
        {
            NewRecoilRotation *= 3;
        }

        if (Instigator.bIsCrouched)
        {
            NewRecoilRotation *= PctCrouchRecoil;
        }
        else if (Instigator.bIsCrawling)
        {
            NewRecoilRotation *= PctProneRecoil;
        }

        // Player is crouched & in iron sights
        if (Weapon.bUsingSights)
        {
            NewRecoilRotation *= PctHipMGPenalty;
        }

        if (ROPwn.bRestingWeapon)
            NewRecoilRotation *= PctRestDeployRecoil;

        if (Instigator.bBipodDeployed)
        {
            NewRecoilRotation *= PctBipodDeployRecoil;
        }

        if (ROPwn.LeanAmount != 0)
        {
            NewRecoilRotation *= PctLeanPenalty;
        }

        ROP.SetRecoil(NewRecoilRotation, RecoilRate);
    }

    if (Level.NetMode != NM_DedicatedServer && Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        if (Weapon.bUsingSights)
        {
            ROPlayer(Instigator.Controller).AddBlur(BlurTimeIronsight, BlurScaleIronsight);
        }
        else
        {
            ROPlayer(Instigator.Controller).AddBlur(BlurTime, BlurScale);
        }
    }
}

// Modified to support ironsight mode (bUsingSights) being hipped-fire mode for MGs
function CalcSpreadModifiers()
{
    super.CalcSpreadModifiers();

    if (!Instigator.bBipodDeployed)
    {
        Spread *= HipSpreadModifier;
    }
}

// Modified because for MGs ironsight mode (bUsingSights) signifies the MG is being hip fired
simulated function bool IsPlayerHipFiring()
{
    return Weapon != none && Weapon.bUsingSights;
}

defaultproperties
{
    PackingThresholdTime=0.12
    bUsesTracers=true
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMG'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    BlurTime=0.04
    BlurTimeIronsight=0.04

    Spread=65.0
    CrouchSpreadModifier=1.0
    ProneSpreadModifier=1.0
    BipodDeployedSpreadModifier=1.0
    RestDeploySpreadModifier=1.0
    PctHipMGPenalty=2.0
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=250
    AimError=1800.0

    PreFireAnim=""
    FireIronAnim="Bipod_shoot_single"
    FireIronLoopAnim="Bipod_Shoot_Loop"
    FireIronEndAnim="Bipod_Shoot_End"
/*
    BipodDeployFireAnim="Bipod_shoot_single"
    BipodDeployFireLoopAnim="Bipod_Shoot_Loop"
    BipodDeployFireEndAnim="Bipod_Shoot_End" */
}
