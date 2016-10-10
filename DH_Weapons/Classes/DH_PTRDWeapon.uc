//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDWeapon extends DHBipodWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Ptrd_1st.ukx

// Modified so can't reload unless empty
simulated function bool AllowReload()
{
    return AmmoAmount(0) < 1 && super.AllowReload();
}

// Modified to make ironsights key try to deploy/undeploy the bipod
simulated function ROIronSights()
{
    Deploy();
}

// Modified as every time the PTRD fires its out of ammo, so play the empty animation
simulated function AnimEnd(int channel)
{
    local name  Anim;
    local float Frame, Rate;

    if (ClientState == WS_ReadyToFire)
    {
        GetAnimParams(0, Anim, Frame, Rate);

        if (Anim == FireMode[0].FireAnim || Anim == FireMode[1].FireAnim)
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else
        {
            super.AnimEnd(channel);
        }
    }
}

// Modified so we don't play idle empty anims after a reload
simulated function PlayIdle()
{
    if (Instigator != none && Instigator.bBipodDeployed)
    {
        if (AmmoAmount(0) < 1 && !IsInState('Reloading') && HasAnim(IronIdleEmptyAnim))
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(IronIdleAnim))
        {
            LoopAnim(IronIdleAnim, IdleAnimRate, 0.2);
        }
    }
    else
    {
        if (AmmoAmount(0) < 1 && !IsInState('Reloading') && HasAnim(IdleEmptyAnim))
        {
            LoopAnim(IdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(IdleAnim))
        {
            LoopAnim(IdleAnim, IdleAnimRate, 0.2);
        }
    }
}

// Modified to start a reload if weapon is empty
simulated function Fire(float F)
{
    if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.bBipodDeployed && !HasAmmo())
    {
        ROManualReload();
    }
    else
    {
        super.Fire(F);
    }
}

defaultproperties
{
    IdleToBipodDeploy="Rest_2_Bipod"
    BipodDeployToIdle="Bipod_2_Rest"
    IdleToBipodDeployEmpty="Rest_2_Bipod_Empty"
    BipodDeployToIdleEmpty="Bipod_2_Rest_Empty"
    MagEmptyReloadAnim="Reload"
    IronIdleAnim="Bipod_Idle"
    IronBringUp="Rest_2_Bipod"
    IronPutDown="Bipod_2_Rest"
    IdleEmptyAnim="Rest_Idle_Empty"
    IronIdleEmptyAnim="Bipod_Idle_Empty"
    SprintStartEmptyAnim="Sprint_Start_Empty"
    SprintLoopEmptyAnim="Sprint_Middle_Empty"
    SprintEndEmptyAnim="Sprint_End_Empty"
    CrawlForwardEmptyAnim="crawlF"
    CrawlBackwardEmptyAnim="crawlB"
    CrawlStartEmptyAnim="crawl_in"
    CrawlEndEmptyAnim="crawl_out"
    SelectEmptyAnim="Draw_empty"
    PutDownEmptyAnim="put_away_empty"
    MaxNumPrimaryMags=20
    InitialNumPrimaryMags=15
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=35.0
    ZoomInTime=0.4
    ZoomOutTime=0.35
    FireModeClass(0)=class'DH_Weapons.DH_PTRDFire'
    FireModeClass(1)=class'ROInventory.ROEmptyFireclass'
    IdleAnim="Rest_Idle"
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
    DisplayFOV=70.0
    PickupClass=class'DH_Weapons.DH_PTRDPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_PTRDAttachment'
    ItemName="PTRD-41"
    Mesh=SkeletalMesh'Allies_Ptrd_1st.PTRD41_Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.PTRD_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
