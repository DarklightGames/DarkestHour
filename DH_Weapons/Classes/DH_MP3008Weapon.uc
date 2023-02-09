//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MP3008Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Maschinenpistole 3008"
    FireModeClass(0)=class'DH_Weapons.DH_MP3008Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MP3008MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MP3008Attachment'
    PickupClass=class'DH_Weapons.DH_MP3008Pickup'

    Mesh=SkeletalMesh'DH_Sten_1st.MP3008_mesh'
    //HighDetailOverlay=Shader'DH_Weapon_tex.Spec_Maps.SMG.Sten_s'
    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=2

    Skins(2)=Texture'DH_Sten_tex.Sten.mp3008_tex'
    HandNum=1
    SleeveNum=0

    SwayModifyFactor=0.62 // -0.08

    DisplayFOV=80.0
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=66.0

    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="Iron_idle_empty"
    IronBringUpEmpty="Iron_in_empty"
    IronPutDownEmpty="Iron_out_empty"
    SprintStartEmptyAnim="Sprint_Start_Empty"
    SprintLoopEmptyAnim="Sprint_Middle_Empty"
    SprintEndEmptyAnim="Sprint_End_Empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
    SelectEmptyAnim="Draw_empty"
    PutDownEmptyAnim="put_away_empty"

    SelectFireAnim="fireswitch"
    SelectFireIronAnim="Iron_fireswitch"
    SelectFireEmptyAnim="fireswitch_empty"
    SelectFireIronEmptyAnim="Iron_fireswitch_empty"
}
