//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHSemiAutoWeapon extends DHProjectileWeapon
    abstract;

defaultproperties
{
    bPlusOneLoading=true
    FreeAimRotationSpeed=6.0
    IronIdleAnim="Iron_idle"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    bSniping=true
    AIRating=0.4
    CurrentRating=0.4
}
