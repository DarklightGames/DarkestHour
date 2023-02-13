//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMGAutomaticFire extends DHFastAutoFire
    abstract;

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
    // Recoil pct
    PctStandIronRecoil=1.0

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
