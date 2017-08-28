//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHShovelItem extends DHWeapon
    abstract;

exec function SetOffset(int NewX, int NewY, int NewZ, optional bool bScaleOneTenth) // TEMPDEBUG to adjust positioning of 3rd person shovel attachment in player's hand
{
    local vector OldOffset, NewOffset;

    OldOffset = RelativeLocation;
    NewOffset.X = NewX;
    NewOffset.Y = NewY;
    NewOffset.Z = NewZ;

    if (bScaleOneTenth)
    {
        NewOffset /= 10.0;
    }

    ThirdPersonActor.SetRelativeLocation(NewOffset);
    Log(Name @ ": new RelativeLocation =" @ ThirdPersonActor.RelativeLocation @ "(was" @ OldOffset $ ")");
}

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

    CrawlStartAnim="crawlF" // TODO: get a proper "crawlIn" animation
    CrawlEndAnim="crawlF"   // TODO: get a proper "crawlOut" animation

    AIRating=0.0
    CurrentRating=0.0
}
