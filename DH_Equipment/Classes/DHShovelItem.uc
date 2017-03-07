//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHShovelItem extends DHWeapon;

defaultproperties
{
    ItemName="Shovel"
    AttachmentClass=class'DHWireCuttersAttachment'
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
    SprintStartAnim="sprintStart"
    SprintLoopAnim="sprintMiddle"
    SprintEndAnim="sprintEnd"

    AIRating=0.0
    CurrentRating=0.0
}
