//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MAB42Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Moschetto Automatico Beretta M1938/42"
    FireModeClass(0)=class'DH_Weapons.DH_MAB42Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MAB42MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MAB42Attachment'
    PickupClass=class'DH_Weapons.DH_MAB42Pickup'

    Mesh=SkeletalMesh'DH_MAB_anm.MAB42-Mesh'

    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=2
    Skins(0)=Texture'DH_MAB38_tex.MAB42.MAB42'

    handnum=0
    sleevenum=1

    DisplayFOV=85.0
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=60.0
    ZoomOutTime=0.1
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="none"
    SelectFireIronAnim="none"

    FirstSelectAnim="draw_first"

    MuzzleBone="Muzzle"

    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="iron_in_empty"
    IronPutDownEmpty="iron_out_empty"
    SprintStartEmptyAnim="sprint_start_empty"
    SprintLoopEmptyAnim="sprint_middle_empty"
    SprintEndEmptyAnim="sprint_end_empty"

    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"

    SelectEmptyAnim="draw_empty"
    PutDownAnim="putaway"
    PutDownEmptyAnim="putaway_empty"
}
