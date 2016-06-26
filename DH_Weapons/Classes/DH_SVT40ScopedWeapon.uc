//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40ScopedWeapon extends DHSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Svt40_1st.ukx

var bool bJammed;

replication
{
    reliable if (Role == ROLE_Authority)
        bJammed;
}

// Overriden to prevent the exploit of freezing your animations after firing
simulated function AnimEnd(int channel)
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);

    if (ClientState == WS_ReadyToFire)
    {
        if (anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim) && !FireMode[0].bIsFiring )
        {
            PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, FastTweenTime);
        }
        else if (anim == ROProjectileFire(FireMode[0]).FireIronAnim && !FireMode[0].bIsFiring )
        {
            PlayIdle();
        }
        else if (anim == FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
        {
            PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
        }
        else if ((FireMode[0] == None || !FireMode[0].bIsFiring) && (FireMode[1] == None || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

// Overriden to prevent the exploit of freezing your animations after firing
simulated event StopFire(int Mode)
{
    if (FireMode[Mode].bIsFiring)
    {
        FireMode[Mode].bInstantStop = true;
    }

    if (Instigator.IsLocallyControlled() && !FireMode[Mode].bFireOnRelease)
    {
        if( !IsAnimating(0) )
        {
            PlayIdle();
        }
    }

    FireMode[Mode].bIsFiring = false;
    FireMode[Mode].StopFiring();

    if (!FireMode[Mode].bFireOnRelease)
    {
        ZeroFlashCount(Mode);
    }
}

defaultproperties
{
    ItemName="SVT-40 Scoped"
    Mesh=mesh'Allies_Svt40_1st.svt40_scoped_mesh'
    DrawScale=1.0
    DisplayFOV=70
    IronSightDisplayFOV=60
    BobDamping=1.6
    BayonetBoneName=Bayonet
    HighDetailOverlay=Material'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    FireModeClass(0)=DH_SVT40ScopedFire
    FireModeClass(1)=DH_SVT40ScopedMeleeFire
    InitialNumPrimaryMags=5
    MaxNumPrimaryMags=5
    CurrentMagIndex=0
    bPlusOneLoading=true
    bHasBayonet=false
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_SVT40ScopedPickup'
    AttachmentClass=class'DH_Weapons.DH_SVT40ScopedAttachment'
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    SelectAnim=Draw
    PutDownAnim=Put_Away
    MagEmptyReloadAnim=reload_empty
    MagPartialReloadAnim=reload_half
    IronBringUp=Scope_in
    IronIdleAnim=Scope_Idle
    IronPutDown=Scope_out
    CrawlForwardAnim=crawlF
    CrawlBackwardAnim=crawlB
    CrawlStartAnim=crawl_in
    CrawlEndAnim=crawl_out
    ZoomInTime=0.4
    ZoomOutTime=0.2
    PlayerFOVZoom=24    // The will be the PlayerFOV when using the scope in iron sight mode - 3.5x
    scopePortalFOV = 8// 3.5x
    XoffsetScoped = (X=0.0,Y=0.0,Z=0.0)
    scopePitch= -10
    scopeYaw= 40
    scopePortalFOVHigh = 15 // 3.5x
    IronSightDisplayFOVHigh = 32
    XoffsetHighDetail = (X=0.0,Y=0.0,Z=0.0)
    scopePitchHigh= 0
    scopeYawHigh= 35
    AIRating=+0.4
    CurrentRating=0.4
    bSniping=true
    TexturedScopeTexture=Texture'Weapon_overlays.Scopes.Rus_sniperscope_overlay'
}
