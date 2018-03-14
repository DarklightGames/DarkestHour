//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHShovelItem extends DHWeapon
    abstract;

function bool FillAmmo() { return false; }
function bool ResupplyAmmo() { return false; }
simulated exec function ROManualReload() { return; }

simulated function Fire(float F)
{
    if (Instigator != none && Instigator.bIsCrawling)
    {
        class'DHShovelWarningMessage'.static.ClientReceive(PlayerController(Instigator.Controller), 0);
    }
    else
    {
        super.Fire(F);
    }
}

simulated event DigDone()
{
    local DHShovelBuildFireMode FM;

    FM = DHShovelBuildFireMode(FireMode[0]);

    if (FM != none)
    {
        FM.DigDone();
    }
}

defaultproperties
{
    FireModeClass(0)=class'DH_Equipment.DHShovelBuildFireMode'
    FireModeClass(1)=class'DH_Equipment.DHShovelMeleeFire'

    ItemName="Shovel"
    InventoryGroup=9
    Priority=1
    bCanThrow=false

    DisplayFOV=80.0
    bCanSway=false

    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"

    AIRating=0.0
    CurrentRating=0.0
}
