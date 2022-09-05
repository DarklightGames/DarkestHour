//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PPSh41Weapon extends DHFastAutoWeapon;

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    // removing wire shooting device from the normal version
    SetBoneScale(0, 0.0, 'WireCutter');
}

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
    SwayModifyFactor=0.83 // +0.13
    ItemName="PPSh-41"

    FireModeClass(0)=class'DH_Weapons.DH_PPSH41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPSH41MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPSH41Attachment'
    PickupClass=class'DH_Weapons.DH_PPSH41Pickup'

    Mesh=SkeletalMesh'DH_Ppsh_1st.PPSH-41-1st'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.PPSH41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=65.0
    DisplayFOV=85

    bHasSelectFire=true

    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3

    //alternative reloads
    MagEmptyReloadAnims(1)="reload_emptyB"
    MagEmptyReloadAnims(2)="reload_emptyC"
    MagEmptyReloadAnims(3)="reload_empty" //standart should be more common

    SelectFireAnim="selectfire"
    SelectFireIronAnim="Iron_selectfire"
    SelectFireEmptyAnim="selectfire_empty"
    SelectFireIronEmptyAnim="Iron_selectfire_empty"

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"

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
