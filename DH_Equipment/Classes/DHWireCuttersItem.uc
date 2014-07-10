//=============================================================================
// BinocularsItem
//=============================================================================
// Binoculars used for marking arty and waypoints
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DHWireCuttersItem extends ROProjectileWeapon;

var() float BinocsEnlargementFactor;

#exec OBJ LOAD FILE=Weapon_overlays.utx
#exec OBJ LOAD FILE=..\Animations\Common_Binoc_1st.ukx

//=============================================================================
// Rendering
//=============================================================================
simulated event RenderOverlays( Canvas Canvas )
{
    local rotator RollMod;
    local ROPlayer Playa;
    //For lean - Justin
    local ROPawn rpawn;
    local int leanangle;
    // Drawpos actor
    local rotator RotOffset;
    local float posx, overlap;

    if (Instigator == None)
        return;

    // Lets avoid having to do multiple casts every tick - Ramm
    Playa = ROPlayer(Instigator.Controller);

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    Canvas.DrawActor(None, false, true); // amb: Clear the z-buffer here

    // these seem to set the current position and rotation of the weapon
    // in relation to the player

    //Adjust weapon position for lean
    rpawn = ROPawn(Instigator);
    if (rpawn != none && rpawn.LeanAmount != 0)
    {
        leanangle += rpawn.LeanAmount;
    }

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );

    if( bUsesFreeAim && !bUsingSights )
    {
        // Remove the roll component so the weapon doesn't tilt with the terrain
        RollMod = Instigator.GetViewRotation();

        if( Playa != none )
        {
            RollMod.Pitch += Playa.WeaponBufferRotation.Pitch;
            RollMod.Yaw += Playa.WeaponBufferRotation.Yaw;

            RotOffset.Pitch -= Playa.WeaponBufferRotation.Pitch;
            RotOffset.Yaw -= Playa.WeaponBufferRotation.Yaw;
        }

        RollMod.Roll += leanangle;

        if( IsCrawling() )
        {
            RollMod.Pitch = CrawlWeaponPitch;
            RotOffset.Pitch = CrawlWeaponPitch;
        }


    }
    else
    {
        RollMod = Instigator.GetViewRotation();
        RollMod.Roll += leanangle;

        if( IsCrawling() )
        {
            RollMod.Pitch = CrawlWeaponPitch;
            RotOffset.Pitch = CrawlWeaponPitch;
        }
    }

    SetRotation( RollMod );

    if( bPlayerViewIsZoomed )
    {
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

//      Canvas.SetPos(0,0);          // sets the DrawTile origin position to (0,0), which I believe is in the upper left corner
//      Canvas.DrawTile( texture'Weapons1st_tex.binocular_overlay', Canvas.SizeX, Canvas.SizeY, 0.0, 0.0, texture'zoomblur10'.USize, texture'zoomblur10'.VSize );

        // Calculate reticle drawing position (and position to draw black bars at)
        posx = float(Canvas.SizeX - Canvas.SizeY) / 2.0 - Canvas.SizeY * BinocsEnlargementFactor;

        // Draw the reticle
        Canvas.SetPos(posx, -BinocsEnlargementFactor * Canvas.SizeY);
        Canvas.DrawTile(Texture'Weapon_overlays.Scopes.BINOC_overlay', Canvas.SizeY * (1 + 2 * BinocsEnlargementFactor), Canvas.SizeY * (1 + 2 * BinocsEnlargementFactor), 0.0, 0.0, Texture'Weapon_overlays.Scopes.BINOC_overlay'.USize, Texture'Weapon_overlays.Scopes.BINOC_overlay'.VSize );

        // Draw black bars on the sides
        overlap = 58.0 / float(Texture'Weapon_overlays.Scopes.BINOC_overlay'.VSize) * Canvas.SizeY * (1 + BinocsEnlargementFactor);
        canvas.SetPos(0, 0);
        Canvas.DrawTile(Texture'Engine.BlackTexture', posx + overlap, Canvas.SizeY, 0, 0, 8, 8);
        Canvas.SetPos(Canvas.SizeX - posx - overlap, 0);
        Canvas.DrawTile(Texture'Engine.BlackTexture', posx + overlap, Canvas.SizeY, 0, 0, 8, 8);

    }
    else
    {
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}

// No ammo for this weapon
function bool FillAmmo(){return false;}
function bool ResupplyAmmo(){return false;}
simulated function bool IsFiring(){return false;}

// No free-aim for binocs
simulated function bool ShouldUseFreeAim()
{
    return false;
}

// Not busy in the idle state because we never fire
simulated function bool IsBusy()
{
    return false;
}


simulated state IronSightZoomIn
{
    simulated function EndState()
    {
        local float TargetDisplayFOV;
        local vector TargetPVO;

        if( Instigator.IsLocallyControlled() && Instigator.IsHumanControlled() )
        {
            if( ScopeDetail == RO_ModelScopeHigh )
            {
                TargetDisplayFOV = Default.IronSightDisplayFOVHigh;
                TargetPVO = Default.XoffsetHighDetail;
            }
            else if( ScopeDetail == RO_ModelScope )
            {
                TargetDisplayFOV = Default.IronSightDisplayFOV;
                TargetPVO = Default.XoffsetScoped;
            }
            else
            {
                TargetDisplayFOV = Default.IronSightDisplayFOV;
                TargetPVO = Default.PlayerViewOffset;
            }

            DisplayFOV = TargetDisplayFOV;
            PlayerViewOffset = TargetPVO;
        }

        if( Instigator.IsLocallyControlled() )
        {
            PlayerViewZoom(true);
        }
    }
}

simulated state IronSightZoomOut
{
    simulated function BeginState()
    {
        if( Instigator.IsLocallyControlled() )
        {
            PlayAnim(IronPutDown, 1.0, 0.2 );
            PlayerViewZoom(false);
        }

        SetTimer(GetAnimDuration(IronPutDown, 1.0) + FastTweenTime,false);
    }
}

//=============================================================================
// Functions overriden because binoculars don't shoot
//=============================================================================
simulated function ClientWeaponSet(bool bPossiblySwitch)
{
    Instigator = Pawn(Owner);

    bPendingSwitch = bPossiblySwitch;

    if( Instigator == None )
    {
        GotoState('PendingClientWeaponSet');
        return;
    }

    ClientState = WS_Hidden;
    GotoState('Hidden');

    if( Level.NetMode == NM_DedicatedServer || !Instigator.IsHumanControlled() )
        return;

    if( Instigator.Weapon == self || Instigator.PendingWeapon == self ) // this weapon was switched to while waiting for replication, switch to it now
    {
        if (Instigator.PendingWeapon != None)
            Instigator.ChangedWeapon();
        else
            BringUp();
        return;
    }

    if( Instigator.PendingWeapon != None && Instigator.PendingWeapon.bForceSwitch )
        return;

    if( Instigator.Weapon == None )
    {
        Instigator.PendingWeapon = self;
        Instigator.ChangedWeapon();
    }
    else if ( bPossiblySwitch && !Instigator.Weapon.IsFiring() )
    {
        if ( PlayerController(Instigator.Controller) != None && PlayerController(Instigator.Controller).bNeverSwitchOnPickup )
            return;
        if ( Instigator.PendingWeapon != None )
        {
            if ( RateSelf() > Instigator.PendingWeapon.RateSelf() )
            {
                Instigator.PendingWeapon = self;
                Instigator.Weapon.PutDown();
            }
        }
        else if ( RateSelf() > Instigator.Weapon.RateSelf() )
        {
            Instigator.PendingWeapon = self;
            Instigator.Weapon.PutDown();
        }
    }
}

simulated state RaisingWeapon
{
    simulated function BeginState()
    {
        local ROPlayer player;

        if ( ClientState == WS_Hidden )
        {
            PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
            ClientPlayForceFeedback(SelectForce);  // jdf

            if ( Instigator.IsLocallyControlled() )
            {
                // determines if bayonet capable weapon should come up with bayonet on or off
                if( bHasBayonet )
                {
                    if( bBayonetMounted )
                    {
                        ShowBayonet();
                    }
                    else
                    {
                        HideBayonet();
                    }
                }

                if ( (Mesh!=None) && HasAnim(SelectAnim) )
                    PlayAnim(SelectAnim, SelectAnimRate, 0.0);
            }

            ClientState = WS_BringUp;
        }

        SetTimer(GetAnimDuration(SelectAnim, SelectAnimRate),false);

        // Hint check
        player = ROPlayer(Instigator.Controller);
        if (player != none)
            player.CheckForHint(8);
    }

    simulated function EndState(){}
}

simulated state LoweringWeapon
{
    simulated function BeginState()
    {
        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (Instigator.IsLocallyControlled())
            {
                if ( ClientState == WS_BringUp )
                    TweenAnim(SelectAnim,PutDownTime);
                else if ( HasAnim(PutDownAnim) )
                    PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(PutDownAnim, PutDownAnimRate),false);
    }

    simulated function EndState()
    {
        super.EndState();

        if (ClientState == WS_PutDown)
        {
            if ( Instigator.PendingWeapon == none )
            {
                PlayIdle();
                ClientState = WS_ReadyToFire;
            }
            else
            {
                ClientState = WS_Hidden;
                Instigator.ChangedWeapon();
                if ( Instigator.Weapon == self )
                {
                    PlayIdle();
                    ClientState = WS_ReadyToFire;
                }
            }
        }
    }
}

simulated function AnimEnd(int channel)
{
    if (ClientState == WS_ReadyToFire)
    {
        if ((FireMode[0] == None || !FireMode[0].bIsFiring) && (FireMode[1] == None || !FireMode[1].bIsFiring))
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
    if ( (Instigator == None) || (Instigator.Controller == None)
        || ( AIController(Instigator.Controller) != none ) || !bUsingSights )
       return;

        // server
    if (Instigator.IsLocallyControlled())
    {
       ROPlayer(Instigator.Controller).ServerSaveArtilleryPosition();
    }
}

// Attempt to save the rally point position
simulated function AltFire(float F)
{
    if ( (Instigator == None) || (Instigator.Controller == None)
        || ( AIController(Instigator.Controller) != none ))
       return;

    if (Instigator.IsLocallyControlled())
    {
       ROPlayer(Instigator.Controller).ServerSaveRallyPoint();
    }
}

//=============================================================================
// Sprinting
//=============================================================================
simulated function SetSprinting(bool bNewSprintStatus)
{
    if( bNewSprintStatus && !IsInState('WeaponSprinting') && !IsInState('RaisingWeapon')
        && !IsInState('LoweringWeapon') && ClientState != WS_PutDown && ClientState != WS_Hidden )
    {
        GotoState('StartSprinting');
    }
    else if ( !bNewSprintStatus && IsInState('WeaponSprinting') ||
        IsInState('StartSprinting') )
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
    MaxNumPrimaryMags=0
    CurrentMagIndex=0
    bPlusOneLoading=false
    bHasBayonet=false

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
    IronBringUp=Zoom_in
    IronIdleAnim=Zoom_idle
    IronPutDown=Zoom_out
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
