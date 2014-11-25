//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHWireCuttersItem extends ROWeapon;

#exec OBJ LOAD FILE=Weapon_overlays.utx
#exec OBJ LOAD FILE=..\Animations\Common_Binoc_1st.ukx

var() float BinocsEnlargementFactor;

function bool FillAmmo()
{
    return false;
}

function bool ResupplyAmmo()
{
    return false;
}

simulated function bool IsFiring()
{
    return false;
}

simulated function bool ShouldUseFreeAim()
{
    return false;
}

// Not busy in the idle state because we never fire
simulated function bool IsBusy()
{
    return false;
}

//==============================================================================
// Functions overriden because binoculars don't shoot
//==============================================================================
simulated function ClientWeaponSet(bool bPossiblySwitch)
{
    Instigator = Pawn(Owner);

    bPendingSwitch = bPossiblySwitch;

    if (Instigator == none)
    {
        GotoState('PendingClientWeaponSet');
        return;
    }

    ClientState = WS_Hidden;
    GotoState('Hidden');

    if (Level.NetMode == NM_DedicatedServer || !Instigator.IsHumanControlled())
        return;

    if (Instigator.Weapon == self || Instigator.PendingWeapon == self) // this weapon was switched to while waiting for replication, switch to it now
    {
        if (Instigator.PendingWeapon != none)
            Instigator.ChangedWeapon();
        else
            BringUp();
        return;
    }

    if (Instigator.PendingWeapon != none && Instigator.PendingWeapon.bForceSwitch)
        return;

    if (Instigator.Weapon == none)
    {
        Instigator.PendingWeapon = self;
        Instigator.ChangedWeapon();
    }
    else if (bPossiblySwitch && !Instigator.Weapon.IsFiring())
    {
        if (PlayerController(Instigator.Controller) != none && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
            return;
        if (Instigator.PendingWeapon != none)
        {
            if (RateSelf() > Instigator.PendingWeapon.RateSelf())
            {
                Instigator.PendingWeapon = self;
                Instigator.Weapon.PutDown();
            }
        }
        else if (RateSelf() > Instigator.Weapon.RateSelf())
        {
            Instigator.PendingWeapon = self;
            Instigator.Weapon.PutDown();
        }
    }
}

simulated function AnimEnd(int channel)
{
    if (ClientState == WS_ReadyToFire)
    {
        if ((FireMode[0] == none || !FireMode[0].bIsFiring) && (FireMode[1] == none || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

simulated event ClientStartFire(int Mode)
{
    return;
}

simulated event StopFire(int Mode)
{
    // Don're fire binocs
    return;
}

simulated exec function ROManualReload()
{
    // Can't reload binocs
    return;
}

// Attempt to save the artillery strike positions
simulated function Fire(float F)
{
    // added check for player to be in iron view to save arty coords - Antarian
    if (Instigator == none || Instigator.Controller == none || AIController(Instigator.Controller) != none || !bUsingSights)
    {
       return;
    }

    // server
    if (Instigator.IsLocallyControlled())
    {
       ROPlayer(Instigator.Controller).ServerSaveArtilleryPosition();
    }
}

//=============================================================================
// Sprinting
//=============================================================================
simulated function SetSprinting(bool bNewSprintStatus)
{
    if (bNewSprintStatus && !IsInState('WeaponSprinting') && !IsInState('RaisingWeapon')
        && !IsInState('LoweringWeapon') && ClientState != WS_PutDown && ClientState != WS_Hidden)
    {
        GotoState('StartSprinting');
    }
    else if (!bNewSprintStatus && IsInState('WeaponSprinting') ||
        IsInState('StartSprinting'))
    {
        GotoState('EndSprinting');
    }
}

simulated function bool CanThrow()
{
    return false;
}

defaultproperties
{
    //** Info **//
    ItemName="Wire Cutters"

    //** Display **//
    Mesh=mesh'Common_Binoc_1st.binoculars'
    DrawScale=1.0
    DisplayFOV=70
    IronSightDisplayFOV=70
    BobDamping=1.6
    HighDetailOverlay=Material'Weapons1st_tex.SniperScopes.Binoc_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    //** Weapon Firing **//
    //FireModeClass(0)=SVT40Fire
    //FireModeClass(1)=SVT40MeleeFire

    //** Weapon Functionality **//
    bCanRestDeploy=true
    bUsesFreeAim=false

    //** Inventory/Ammo **//
    //PickupClass=class'SVT40Pickup'
    AttachmentClass=class'BinocularsAttachment'

    //** Animation **//
    // Rates
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    // Draw/Put Away
    SelectAnim=Draw
    PutDownAnim=Put_Away
    // Ironsites
    // Crawling
    CrawlForwardAnim=crawlF
    CrawlBackwardAnim=crawlB
    CrawlStartAnim=crawl_in
    CrawlEndAnim=crawl_out

     //** Zooming **//
    ZoomInTime=0.4
    ZoomOutTime=0.2
    PlayerFOVZoom=10
    bPlayerFOVZooms=true

    //** Bot/AI **//
    AIRating=+0.0
    CurrentRating=0.0
    bSniping=false // So bots will use this weapon to take long range shots

    //** Misc **//
    SelectForce="SwitchToAssaultRifle"
    bCanThrow=false
    bCanSway=false
    InventoryGroup=4
    Priority=1

    BinocsEnlargementFactor=0.2
}
