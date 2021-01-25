//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_PPSh41_StickWeapon extends DHFastAutoWeapon;

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
    SwayModifyFactor=0.74 // -0.6
    ItemName="PPSh-41 /35rnd"

    FireModeClass(0)=class'DH_Weapons.DH_PPSH41_stickFire'
    FireModeClass(1)=class'DH_Weapons.DH_PPSH41_stickMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPSH41_stickAttachment'
    PickupClass=class'DH_Weapons.DH_PPSH41_stickPickup'

    Mesh=SkeletalMesh'DH_Ppsh_1st.PPSH-41-stick'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.PPSH41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    Skins(0)=Texture'DH_Weapon_tex.AlliedSmallArms.PPShBox'
    handnum=2

    IronSightDisplayFOV=62
    DisplayFOV=82

    bHasSelectFire=true
    SelectFireSound=Sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01'

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10

    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="iron_in_empty"
    IronPutDownEmpty="iron_out_empty"
    SprintStartEmptyAnim="sprint_start_empty"
    SprintLoopEmptyAnim="sprint_middle_empty"
    SprintEndEmptyAnim="sprint_end_empty"

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"

    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"

    SelectEmptyAnim="draw_empty"
    PutDownEmptyAnim="put_away_empty"
}
