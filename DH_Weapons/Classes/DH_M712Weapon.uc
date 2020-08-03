//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_M712Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Mauser M712 'Schnellfeuer'"
    FireModeClass(0)=class'DH_Weapons.DH_M712Fire'
    FireModeClass(1)=class'DH_Weapons.DH_M712MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M712Attachment'
    PickupClass=class'DH_Weapons.DH_M712Pickup'

    Mesh=SkeletalMesh'DH_C96_1st.M712_mesh'

    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=0
    Skins(1)=Texture'Weapons1st_tex.Pistols.Mauser_c96'
    HighDetailOverlay=Shader'Weapons1st_tex.Pistols.c96_S'
    handnum=0
    sleevenum=2

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=75.0
    DisplayFOV=80.0

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5
    bHasSelectFire=true

    SelectEmptyAnim="Draw_empty"
    PutDownAnim="putaway"
    PutDownEmptyAnim="putaway_empty"
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"
    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    SprintStartEmptyAnim="Sprint_Start_Empty"
    SprintLoopEmptyAnim="Sprint_Middle_Empty"
    SprintEndEmptyAnim="Sprint_End_Empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
}
