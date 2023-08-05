//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MAB38Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Moschetto Automatico Beretta M1938"
    FireModeClass(0)=class'DH_Weapons.DH_MAB38Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MAB38MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MAB38Attachment'
    PickupClass=class'DH_Weapons.DH_MAB38Pickup'

    Mesh=SkeletalMesh'DH_MAB_1st.MAB38-Mesh'

    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=0
    Skins(0)=Texture'DH_MAB38_tex.MAB38.MAB38'

    handnum=1
    sleevenum=2

    DisplayFOV=90
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=40.0
    ZoomOutTime=0.1
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle001"

    bHasSelectFire=true
    SelectFireAnim="none"
    SelectFireIronAnim="none"

    MuzzleBone="Muzzle001"

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
    PutDownEmptyAnim="put_away_empty"
}
