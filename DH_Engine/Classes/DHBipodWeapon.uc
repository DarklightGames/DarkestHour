//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHBipodWeapon extends DHProjectileWeapon
    abstract;

// Modified to handle animations for bipod deployed & firing from the hip
simulated function PlayIdle()
{
    if (Instigator != none && Instigator.bBipodDeployed)
    {
        if (AmmoAmount(0) < 1 && HasAnim(IronIdleEmptyAnim))
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(IronIdleAnim))
        {
            LoopAnim(IronIdleAnim, IdleAnimRate, 0.2);
        }
    }
    else if (bUsingSights && HasAnim(BipodHipIdle))
    {
        LoopAnim(BipodHipIdle, IdleAnimRate, 0.2);
    }
    else
    {
        if (AmmoAmount(0) < 1 && HasAnim(IdleEmptyAnim))
        {
            LoopAnim(IdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(IdleAnim))
        {
            LoopAnim(IdleAnim, IdleAnimRate, 0.2);
        }
    }
}

defaultproperties
{
    Priority=10
    bHasBipod=true
    bCanBipodDeploy=true
    bCanRestDeploy=false
    bMustReloadWithBipodDeployed=true
    PlayerDeployFOV=60.0

    IronBringUp="Rest_2_Bipod"
    IronPutDown="Bipod_2_Rest"
    IdleAnim="Rest_Idle"
    IronIdleAnim="Bipod_Idle"
    IdleToBipodDeploy="Rest_2_Bipod"
    BipodDeployToIdle="Bipod_2_Rest"
    MagEmptyReloadAnims(0)="Reload"

    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
}
