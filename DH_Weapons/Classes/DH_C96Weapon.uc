//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_C96Weapon extends DHPistolWeapon;

//completely replaces old full auto c96
//will possibly make proper m712 in the future as a separate weapon


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
    ItemName="Mauser C96"
    FireModeClass(0)=class'DH_Weapons.DH_C96Fire'
    FireModeClass(1)=class'DH_Weapons.DH_C96MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_C96Attachment'
    PickupClass=class'DH_Weapons.DH_C96Pickup'

    Mesh=SkeletalMesh'DH_C96_1st.c96_mesh'

    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=0
    Skins(0)=Texture'DH_c96_tex.c96.c96'
    handnum=2
    sleevenum=1

    SwayModifyFactor=1.4 //+0.3 as it was rather awkward to hold

    DisplayFOV=75.0
    IronSightDisplayFOV=70

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12
    bHasSelectFire=false

    bTwoMagsCapacity=true
    bPlusOneLoading=false

    SelectEmptyAnim="Draw_empty"
    PutDownAnim="put_away"
    PutDownEmptyAnim="putaway_empty"
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"

    SprintStartEmptyAnim="Sprint_Start_Empty"
    SprintLoopEmptyAnim="Sprint_Middle_Empty"
    SprintEndEmptyAnim="Sprint_End_Empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"

    FirstSelectAnim="Draw2"
}
