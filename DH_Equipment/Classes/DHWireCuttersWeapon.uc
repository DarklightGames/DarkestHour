class DHWireCuttersItem extends ROProjectileWeapon;

function bool FillAmmo() { return false; }
function bool ResupplyAmmo() { return false; }
simulated function bool ShouldUseFreeAim() { return false; }
simulated exec function ROManualReload() { return; }
simulated function bool CanThrow() { return false; }

defaultproperties
{
    ItemName="Wire Cutters"
    Mesh=mesh'Common_Binoc_1st.binoculars'  //TODO: change
    DrawScale=1.0
    DisplayFOV=70
    IronSightDisplayFOV=70
    BobDamping=1.6
    MaxNumPrimaryMags=0
    CurrentMagIndex=0
    bPlusOneLoading=false
    bHasBayonet=false
    bCanRestDeploy=false
    bUsesFreeAim=false
    AttachmentClass=class'BinocularsAttachment'
    SelectAnimRate=1.0
    PutDownAnimRate=1.0

    // Draw/Put Away
    SelectAnim=Draw
    PutDownAnim=Put_Away
    // Ironsights
    IronBringUp=Zoom_in
    IronIdleAnim=Zoom_idle
    IronPutDown=Zoom_out
    // Crawling
    CrawlForwardAnim=crawlF
    CrawlBackwardAnim=crawlB
    CrawlStartAnim=crawl_in
    CrawlEndAnim=crawl_out

    //** Misc **//
    SelectForce="SwitchToAssaultRifle"
    bCanThrow=false
    bCanSway=false
    InventoryGroup=4
    Priority=1

    BinocsEnlargementFactor=0.2
}

