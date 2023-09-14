//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSniperWeapon extends DHProjectileWeapon
    abstract;

defaultproperties
{
    bHasScope=true
    bIsSniper=true
    bPlusOneLoading=true

    bUsesIronsightFOV=false
    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.85

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"

    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
}
