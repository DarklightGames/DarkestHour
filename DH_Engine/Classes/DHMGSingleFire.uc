//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMGSingleFire extends DHProjectileFire
    abstract;

// Modified to apply PctHipMGPenalty if player is hip-firing the MG (bUsingSights signifies this)
simulated function float CustomHandleRecoil()
{
    // Added to apply PctHipMGPenalty if player is hip-firing the MG (bUsingSights signifies this)
    if (Weapon != none && Weapon.bUsingSights)
    {
        return PctHipMGPenalty;
    }
    else
    {
        return 1.0;
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
