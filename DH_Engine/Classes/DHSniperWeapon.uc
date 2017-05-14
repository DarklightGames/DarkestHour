//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSniperWeapon extends DHProjectileWeapon
    abstract;

#exec OBJ LOAD FILE=Weapons1st_tex.utx
#exec OBJ LOAD FILE=..\Textures\ScopeShaders.utx
#exec OBJ LOAD FILE=InterfaceArt_tex.utx

var     float           ScopePortalFOV;          // the FOV to zoom the scope portal by
var     bool            bInitializedScope;       // set to true when the scope has been initialized
var     bool            bDebugSights;            // shows centering cross in scope overlay for testing purposes

// Texture scope overlay
var     texture         ScopeOverlay;            // texture overlay for scope
var     float           ScopeOverlaySize;        // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
var     float           OverlayCorrectionX;      // scope center correction in pixels, in case an overlay is off-center by pixel or two
var     float           OverlayCorrectionY;

// From ROSniperWeapon, but referencing the DHWeapon class
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    ScopeDetail = class'DH_Engine.DHWeapon'.default.ScopeDetail;
    UpdateScopeMode();
}

// In ROSniperWeapon this handled initializing & switching between different scope modes
// DH only uses RO_TextureScope mode, so it's stripped down to just that
simulated function UpdateScopeMode()
{
    if (Level.NetMode != NM_DedicatedServer && InstigatorIsLocalHuman())
    {
        IronSightDisplayFOV = default.IronSightDisplayFOV;
        PlayerViewOffset.X = default.PlayerViewOffset.X;
        bPlayerFOVZooms = true;

        bInitializedScope = true;
    }
}

// Modified to draw scope overlay
simulated event RenderOverlays(Canvas Canvas)
{
    local ROPlayer Playa;
    local ROPawn   RPawn;
    local rotator  RollMod;
    local float    TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight, PosX, PosY;
    local int      LeanAngle, i;

    if (Instigator == none)
    {
        return;
    }

    Playa = ROPlayer(Instigator.Controller);

    if (!bInitializedScope && Playa != none)
    {
        UpdateScopeMode();
    }

    // Draw muzzle flashes/smoke for all fire modes so idle state won't cause emitters to just disappear
    Canvas.DrawActor(none, false, true); // clear the z-buffer here

    for (i = 0; i < NUM_FIRE_MODES; ++i)
    {
        FireMode[i].DrawMuzzleFlash(Canvas);
    }

    // Adjust weapon position for lean
    RPawn = ROPawn(Instigator);

    if (RPawn != none && RPawn.LeanAmount != 0.0)
    {
        LeanAngle += RPawn.LeanAmount;
    }

    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    // Remove the roll component so the weapon doesn't tilt with the terrain
    RollMod = Instigator.GetViewRotation();
    RollMod.Roll += LeanAngle;

    if (IsCrawling())
    {
        RollMod.Pitch = CrawlWeaponPitch;
    }

    if (bUsesFreeAim && !bUsingSights && Playa != none)
    {
        if (!IsCrawling())
        {
            RollMod.Pitch += Playa.WeaponBufferRotation.Pitch;
        }

        RollMod.Yaw += Playa.WeaponBufferRotation.Yaw;
    }

    SetRotation(RollMod);

    // Draw scope overlay (method is different from RO & is same as DrawGunsightOverlay() in DHVehicleCannonPawn - see notes there)
    if (bPlayerViewIsZoomed && bUsingSights)
    {
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.SetPos(0.0, 0.0);

        TextureSize = float(ScopeOverlay.USize);
        TilePixelWidth = TextureSize / ScopeOverlaySize * 0.955; // width based on weapon's ScopeOverlaySize (0.955 factor widens visible FOV to full screen for 'standard' overlay if GS=1.0)
        TilePixelHeight = TilePixelWidth * float(Canvas.SizeY) / float(Canvas.SizeX); // height proportional to width, maintaining screen aspect ratio
        TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0) - OverlayCorrectionX;
        TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0) - OverlayCorrectionY;

        Canvas.DrawTile(ScopeOverlay, Canvas.SizeX, Canvas.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);

        // Debug - draw cross on center of screen to check scope overlay is properly centred
        if (bDebugSights)
        {
            PosX = Canvas.SizeX / 2.0;
            PosY = Canvas.SizeY / 2.0;
            Canvas.SetPos(0.0, 0.0);
            Canvas.DrawVertical(PosX - 1.0, PosY - 3.0);
            Canvas.DrawVertical(PosX, PosY - 3.0);
            Canvas.SetPos(0.0, PosY + 3.0);
            Canvas.DrawVertical(PosX - 1.0, PosY - 3.0);
            Canvas.DrawVertical(PosX, PosY - 3.0);
            Canvas.SetPos(0.0, 0.0);
            Canvas.DrawHorizontal(PosY - 1.0, PosX - 3.0);
            Canvas.DrawHorizontal(PosY, PosX - 3.0);
            Canvas.SetPos(PosX + 3.0, 0.0);
            Canvas.DrawHorizontal(PosY - 1.0, PosX - 3.0);
            Canvas.DrawHorizontal(PosY, PosX - 3.0);
        }
    }
    else
    {
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}

// From ROSniperWeapon
simulated event RenderTexture(ScriptedTexture Tex)
{
    local rotator RollMod;
    local ROPawn  RPawn;

    if (Owner != none && Instigator != none && Tex != none && Tex.Client != none)
    {
        RollMod = Instigator.GetViewRotation();
        RPawn = ROPawn(Instigator);

        // Subtract roll from view while leaning
        if (RPawn != none && RPawn.LeanAmount != 0.0)
        {
            RollMod.Roll += RPawn.LeanAmount;
        }

        Tex.DrawPortal(0, 0, Tex.USize, Tex.VSize, Owner, (Instigator.Location + Instigator.EyePosition()), RollMod, ScopePortalFOV);
    }
}

// From ROSniperWeapon, but removed check that literal animation 'scope_shoot_last' isn't playing
// No weapon in RO or DH has such an animation & it's clearly doing nothing
// Even when you fire your last shot you should stay scoped & only come off the scope when you begin to bolt or reload
simulated function bool ShouldDrawPortal()
{
    return bUsingSights && (IsInState('Idle') || IsInState('PostFiring'));
}

// Modified to prevent the exploit of freezing your animations after firing
simulated function AnimEnd(int Channel)
{
    local name  Anim;
    local float Frame, Rate;

    if (ClientState == WS_ReadyToFire)
    {
        GetAnimParams(0, Anim, Frame, Rate);

//      // Don't play the idle anim after a bayo strike or bash (this, from the ROWeapon Super, is omitted here)
//      if (FireMode[1].bMeleeMode && ROWeaponFire(FireMode[1]) != none &&
//          (Anim == ROWeaponFire(FireMode[1]).BashAnim || Anim == ROWeaponFire(FireMode[1]).BayoStabAnim || Anim == ROWeaponFire(FireMode[1]).BashEmptyAnim))
//      {
//          // do nothing;
//      }
//      else

        if (Anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim) && !FireMode[0].bIsFiring) // adds checks that isn't firing
        {
            PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, FastTweenTime); // uses FastTweenTime instead of 0.0
        }
        else if (DHProjectileFire(FireMode[0]) != none && Anim == DHProjectileFire(FireMode[0]).FireIronAnim && !FireMode[0].bIsFiring)
        {
            PlayIdle();
        }
        else if (Anim == FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
        {
            PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
        }
        else if (!FireMode[0].bIsFiring && !FireMode[1].bIsFiring)
        {
            PlayIdle();
        }
    }
}

// Modified to prevent the exploit of freezing your animations after firing
simulated event StopFire(int Mode)
{
    if (FireMode[Mode].bIsFiring)
    {
        FireMode[Mode].bInstantStop = true;
    }

    if (InstigatorIsLocallyControlled() && !FireMode[Mode].bFireOnRelease && !IsAnimating(0)) // adds check that isn't animating
    {
        PlayIdle();
    }

    FireMode[Mode].bIsFiring = false;
    FireMode[Mode].StopFiring();

    if (!FireMode[Mode].bFireOnRelease)
    {
        ZeroFlashCount(Mode);
    }
}

// Debug execs to enable sight debugging and calibration, to make sure textured sight overlay is exactly centred
exec function DebugSights()
{
    bDebugSights = !bDebugSights;
}

exec function CorrectX(float NewValue)
{
    Log(Name @ "OverlayCorrectionX =" @ NewValue @ "(was" @ OverlayCorrectionX $ ")");
    OverlayCorrectionX = NewValue;
}
exec function CorrectY(float NewValue)
{
    Log(Name @ "OverlayCorrectionY =" @ NewValue @ "(was" @ OverlayCorrectionY $ ")");
    OverlayCorrectionY = NewValue;
}

defaultproperties
{
    bIsSniper=true
    bPlusOneLoading=true
    ScopeOverlaySize=0.7

    PlayerIronsightFOV=90.0
    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.85

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
}
