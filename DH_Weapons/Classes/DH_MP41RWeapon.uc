//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MP41RWeapon extends DHFastAutoWeapon;

simulated function bool StartFire(int Mode)
{
    if (super(DHProjectileWeapon).StartFire(Mode))
    {
        if (FireMode[Mode].bMeleeMode)
        {
            return true;
        }

        AnimStopLooping();

        // single
        if (FireMode[0].bWaitForRelease)
        {
            return true;
        }
        else // auto
        {
            if (!FireMode[Mode].IsInState('FireLoop'))
            {
                FireMode[Mode].StartFiring();
                return true;
            }
        }
    }

    return false;
}

defaultproperties
{
    SwayModifyFactor=0.65 // -0.5
    ItemName="Maschinenpistole 41(r)"

    FireModeClass(0)=class'DH_Weapons.DH_MP41RFire'
    FireModeClass(1)=class'DH_Weapons.DH_MP41RMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MP41RAttachment'
    PickupClass=class'DH_Weapons.DH_MP41RPickup'

    Mesh=SkeletalMesh'DH_Ppsh_1st.MP41R'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.PPSH41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    Skins(0)=Texture'Weapons1st_tex.Arms.german_sleeves'
    Skins(1)=Texture'Weapons1st_tex.Arms.hands'
    Skins(2)=Shader'Weapons1st_tex.SMG.MP40_s'
    //Skins(3)=Shader'Weapons1st_tex.SMG.PPSH41_S'
    HandNum=1
    SleeveNum=0

    IronSightDisplayFOV=65
    DisplayFOV=82

    bHasSelectFire=true

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    SelectFireAnim="fireswitch"
    SelectFireIronAnim="Iron_fireswitch"
    SelectFireEmptyAnim="fireswitch_empty"
    SelectFireIronEmptyAnim="Iron_fireswitch_empty"

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

    MagEmptyReloadAnims(0)="reload_empty_mp41r"
    MagPartialReloadAnims(0)="reload_half_mp41r"
}
