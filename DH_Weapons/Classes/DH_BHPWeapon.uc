//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BHPWeapon extends DHPistolWeapon;

// This weapon has a special bit of logic that plays an alternate animation
// when it's first drawn.
var bool bHasBeenDrawn;
var name FirstSelectAnim;

simulated state RaisingWeapon
{
    simulated function EndState()
    {
        // Marks the weapon as being drawn already.
        super.EndState();

        bHasBeenDrawn = true;
    }
}

simulated function name GetSelectAnim()
{
    if (bHasBeenDrawn)
    {
        return SelectAnim;
    }
    else
    {
        return FirstSelectAnim;
    }
}

defaultproperties
{
    ItemName="Browning High-Power"
    FireModeClass(0)=class'DH_Weapons.DH_BHPFire'
    FireModeClass(1)=class'DH_Weapons.DH_BHPMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BHPAttachment'
    PickupClass=class'DH_Weapons.DH_BHPPickup'

    Mesh=SkeletalMesh'DH_BHP_1st.BHP-Mesh'
    HighDetailOverlay=Shader'DH_BHP_tex.BHP.BHP_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=0

    Skins(0)=Texture'DH_BHP_tex.BHP.BHP'

    HandNum=1
    SleeveNum=2

    IronSightDisplayFOV=70.0
    ZoomOutTime=0.4

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5

    SelectEmptyAnim="Draw_empty"
    PutDownEmptyAnim="put_away_empty"
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"
    SprintStartEmptyAnim="Sprint_Empty_Start"
    SprintLoopEmptyAnim="Sprint_Empty_Middle"
    SprintEndEmptyAnim="Sprint_Empty_End"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"

    FirstSelectAnim="Draw2"
}
