//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHSniperWeapon extends DHProjectileWeapon
    abstract;

defaultproperties
{
    bHasScope=true
    bIsSniper=true
    bPlusOneLoading=true
    ScopeOverlaySize=0.7

    bUsesIronsightFOV=false
    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.85

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
}
