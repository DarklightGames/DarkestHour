//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_ViSWeapon extends DHPistolWeapon;

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
    ItemName="ViS wz.35"
    FireModeClass(0)=class'DH_Weapons.DH_ViSFire'
    FireModeClass(1)=class'DH_Weapons.DH_ViSMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_ViSAttachment'
    PickupClass=class'DH_Weapons.DH_ViSPickup'

    Mesh=SkeletalMesh'DH_ViS_1st.ViS_Mesh'

    bUseHighDetailOverlayIndex=false
	
	Skins(1)=Texture'DH_ViS_tex.ViS.ViS_texture'
	Skins(2)=Texture'Weapons1st_tex.Pistols.p38'
	sleevenum=4
	handnum=0
	
	FirstSelectAnim=draw2


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
}
