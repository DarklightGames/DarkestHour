//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHBipodAutoWeapon extends DHAutoWeapon
    abstract;

defaultproperties
{
    bHasBipod=true

    bCanBeResupplied=true
    NumMagsToResupply=2

    bCanBipodDeploy=true
    ZoomOutTime=0.1

    PutDownAnim="putaway"
    // SightUpIronBringUp="SightUp_iron_in"
    // SightUpIronPutDown="SightUp_iron_out"
    // SightUpIronIdleAnim="SightUp_iron_idle"
    // SightUpMagEmptyReloadAnim="sightup_reload_empty"
    // SightUpMagPartialReloadAnim="sightup_reload_half"

    AIRating=0.7
    CurrentRating=0.7
    bSniping=true
}
