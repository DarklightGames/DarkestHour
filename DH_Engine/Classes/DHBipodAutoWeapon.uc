//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHBipodAutoWeapon extends DHAutoWeapon
    abstract;

defaultproperties
{
    bCanBeResupplied=true
    NumMagsToResupply=2

    bCanBipodDeploy=true
    ZoomOutTime=0.1

    PutDownAnim="putaway"

    AIRating=0.7
    CurrentRating=0.7
    bSniping=true
}
