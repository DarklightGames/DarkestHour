//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_EnfieldNo2Weapon extends DHPistolWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_EnfieldNo2_1st.ukx

defaultproperties
{
    ItemName="Enfield No.2"
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo2Fire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo2MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo2Attachment'
    PickupClass=class'DH_Weapons.DH_EnfieldNo2Pickup'

    Mesh=SkeletalMesh'DH_EnfieldNo2_1st.EnfieldNo2'
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.EnfieldNo2_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=40.0
    PlayerIronsightFOV=60.0

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5

    IdleEmptyAnim="Idle"
    IronIdleEmptyAnim="Iron_idle"
    IronBringUpEmpty="iron_in"
    IronPutDownEmpty="iron_out"
    SprintStartEmptyAnim="Sprint_Start"
    SprintLoopEmptyAnim="Sprint_Middle"
    SprintEndEmptyAnim="Sprint_end"
    CrawlForwardEmptyAnim="crawlF"
    CrawlBackwardEmptyAnim="crawlB"
    CrawlStartEmptyAnim="crawl_in"
    CrawlEndEmptyAnim="crawl_out"
    PutDownAnim="putaway"
    SelectEmptyAnim="Draw"
    PutDownEmptyAnim="putaway"
}
