//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_C96Weapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Mauser C96"
    FireModeClass(0)=class'DH_Weapons.DH_C96Fire'
    FireModeClass(1)=class'DH_Weapons.DH_C96MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_C96Attachment'
    PickupClass=class'DH_Weapons.DH_C96Pickup'

    Mesh=SkeletalMesh'DH_C96_1st.c96_mesh'

    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=0
    Skins(0)=Texture'Weapons1st_tex.Pistols.Mauser_c96'
    HighDetailOverlay=Shader'Weapons1st_tex.Pistols.c96_S'
    handnum=2
    sleevenum=1

    SwayModifyFactor=1.4 //+0.3 as it was rather awkward to hold

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0

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
