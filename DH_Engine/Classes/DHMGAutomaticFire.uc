//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMGAutomaticFire extends DHFastAutoFire
    abstract;

var     float       PctHipMGPenalty; // the amount of recoil to add when the player firing an MG from the hip

// Modified to make rounds disappear from the visible ammo belt when nearly out of ammo
event ModeDoFire()
{
    super.ModeDoFire();

    if (Level.NetMode != NM_DedicatedServer && DHMGWeapon(Weapon) != none)
    {
        DHMGWeapon(Weapon).UpdateAmmoBelt();
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

        if (ROPwn.Physics == PHYS_Falling)
        {
            NewRecoilRotation *= 3;
        }

        if (ROPwn.bIsCrouched)
        {
            NewRecoilRotation *= PctCrouchRecoil;
        }
        else if (ROPwn.bIsCrawling)
        {
            NewRecoilRotation *= PctProneRecoil;
        }

        // Added to apply PctHipMGPenalty if player is hip-firing the MG (bUsingSights signifies this)
        // This replaces all recoil adjustments for bUsingSights in the Super
        if (Weapon != none && Weapon.bUsingSights)
        {
            NewRecoilRotation *= PctHipMGPenalty;
        }

        if (ROPwn.bRestingWeapon)
        {
            NewRecoilRotation *= PctRestDeployRecoil;
        }

        if (ROPwn.bBipodDeployed)
        {
            NewRecoilRotation *= PctBipodDeployRecoil;
        }

        if (ROPwn.LeanAmount != 0)
        {
            NewRecoilRotation *= PctLeanPenalty;
        }

        ROP.SetRecoil(NewRecoilRotation, RecoilRate);
    }

    if (Level.NetMode != NM_DedicatedServer && default.bShouldBlurOnFire)
    {
        if (Weapon != none && Weapon.bUsingSights)
        {
            ROP.AddBlur(BlurTimeIronsight, BlurScaleIronsight);
        }
        else
        {
            ROP.AddBlur(BlurTime, BlurScale);
        }
    }
}

// Modified to support ironsight mode (bUsingSights) being hipped-fire mode for MGs
function CalcSpreadModifiers()
{
    super.CalcSpreadModifiers();

    if (Instigator != none && !Instigator.bBipodDeployed)
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
    // Recoil pct
    PctBipodDeployRecoil=0.04

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
    BipodDeployFireAnim="Bipod_shoot_single"
    BipodDeployFireLoopAnim="Bipod_Shoot_Loop"
    BipodDeployFireEndAnim="Bipod_Shoot_End"
}
