//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMGSingleFire extends DHProjectileFire
    abstract;

var     float       PctHipMGPenalty; // the amount of recoil to add when the player firing an MG from the hip

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
    bWaitForRelease=true
    bUsesTracers=true
    FireRate=0.2
    FAProjSpawnOffset=(X=-20.0)
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    BlurTime=0.04
    BlurTimeIronsight=0.04

    PctHipMGPenalty=2.0
    CrouchSpreadModifier=1.0
    ProneSpreadModifier=1.0
    BipodDeployedSpreadModifier=1.0
    RestDeploySpreadModifier=1.0
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=250
    AimError=1800.0

    FireAnim="Shoot_single"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    FireIronAnim="Bipod_shoot_single"
    FireIronLoopAnim="Bipod_Shoot_Loop"
    FireIronEndAnim="Bipod_Shoot_End"
}
