//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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
    InventoryGroup=4
    GroupOffset=0
    Priority=4 // this should be higher than any other weapon on InventoryGroup=4, raising this higher than 8 will require to raise priority on other weapons
    bCanThrow=false

    DisplayFOV=80.0
    bCanSway=false

    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"

    AIRating=0.0
    CurrentRating=0.0
}
