//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHShovelItem extends DHWeapon;

function bool FillAmmo() { return false; }
function bool ResupplyAmmo() { return false; }
simulated exec function ROManualReload() { return; }

defaultproperties
{
    FireModeClass(0)=class'DH_Equipment.DHShovelBuildFireMode'
    FireModeClass(1)=class'DH_Equipment.DHShovelMeleeFire'

    ItemName="Shovel"
    AttachmentClass=class'DHShovelAttachment'
    InventoryGroup=8    // TODO: figure out best one!
    Priority=1
    bCanThrow=false

    Mesh=SkeletalMesh'DH_USA_shovel_1st.USA_shovel'

    DisplayFOV=70.0
    IronSightDisplayFOV=70.0
    PlayerFOVZoom=10.0
    bPlayerFOVZooms=true
    ZoomInTime=0.4
    ZoomOutTime=0.2
    bUsesFreeAim=false
    bCanSway=false

    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawlIn"
    CrawlEndAnim="crawlOut"
    SprintStartAnim="sprint_Start"
    SprintLoopAnim="sprint_Middle"
    SprintEndAnim="sprint_End"

    AIRating=0.0
    CurrentRating=0.0
}

