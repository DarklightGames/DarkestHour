//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSniperWeapon extends DHProjectileWeapon
    abstract;

#exec OBJ LOAD FILE=Weapons1st_tex.utx
#exec OBJ LOAD FILE=..\Textures\ScopeShaders.utx
#exec OBJ LOAD FILE=InterfaceArt_tex.utx

var     int             LensMaterialID;          // used since material IDs seem to change a lot
var     float           ScopePortalFOVHigh;      // the FOV to zoom the scope portal by
var     float           ScopePortalFOV;          // the FOV to zoom the scope portal by

var     int             ScopePitch;              // tweaks the pitch of the scope firing angle
var     int             ScopeYaw;                // tweaks the yaw of the scope firing angle
var     int             ScopePitchHigh;          // tweaks the pitch of the scope firing angle high detail scope
var     int             ScopeYawHigh;            // tweaks the yaw of the scope firing angle high detail scope

// 3d Scope vars
var     ScriptedTexture ScopeScriptedTexture;    // scripted texture for 3d scopes
var     Shader          ScopeScriptedShader;     // the shader that combines the scripted texture with the sight overlay
var     Material        ScriptedTextureFallback; // the texture to render if the users system doesn't support shaders

// New scope vars
var     Combiner        ScriptedScopeCombiner;
var     texture         TexturedScopeTexture;
var     float           OverlayCenterScale;
var     float           OverlayCenterSize;       // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
var     float           OverlayCenterTexStart;
var     float           OverlayCenterTexSize;
var     float           OverlayCorrectionX;
var     float           OverlayCorrectionY;
var     bool            bInitializedScope;       // set to true when the scope has been initialized

// Modified to get new scope detail value from ROWeapon & to set scope overlay variables once instead of every DrawHUD
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    ScopeDetail = class'DH_Engine.DHWeapon'.default.ScopeDetail;
    UpdateScopeMode();

    if (Level.NetMode != NM_DedicatedServer && TexturedScopeTexture != none)
    {
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1.0 - OverlayCenterScale) * float(TexturedScopeTexture.USize) / 2.0;
        OverlayCenterTexSize = float(TexturedScopeTexture.USize) * OverlayCenterScale;
    }
}

// Modified to clear scope objects
simulated event Destroyed()
{
    super.Destroyed();

    ClearScopeObjects();
}

// Modified to clear scope objects
simulated function PreTravelCleanUp()
{
    ClearScopeObjects();
}

// Handles initializing & switching between different scope modes
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
    local int      LeanAngle, i;
    local float    ScreenRatio;

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
    Canvas.DrawActor(none, false, true);

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

    Skins[LensMaterialID] = ScriptedTextureFallback;

    // Draw scope overlay
    if (bPlayerViewIsZoomed && bUsingSights)
    {
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
        Canvas.SetPos(0.0, 0.0);

        Canvas.DrawTile(TexturedScopeTexture, Canvas.SizeX, Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX,
            OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0, OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);
    }
    else
    {
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}

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

// Helper function for the scope system - the scope system checks here to see when it should draw the portal
// If you want to limit any times the portal should/shouldn't be drawn, add them here
simulated function bool ShouldDrawPortal()
{
    local name  ThisAnim;
    local float AnimFrame, AnimRate;

    GetAnimParams(0, ThisAnim, AnimFrame, AnimRate);

    return bUsingSights && (IsInState('Idle') || IsInState('PostFiring')) && ThisAnim != 'scope_shoot_last';
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

// New function to clear up the scope objects
simulated function ClearScopeObjects()
{
    if (ScopeScriptedTexture != none)
    {
        ScopeScriptedTexture.Client = none;
        Level.ObjectPool.FreeObject(ScopeScriptedTexture);
        ScopeScriptedTexture = none;
    }

    if (ScriptedScopeCombiner != none)
    {
        ScriptedScopeCombiner.Material2 = none;
        Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
        ScriptedScopeCombiner = none;
    }

    if (ScopeScriptedShader != none)
    {
        ScopeScriptedShader.Diffuse = none;
        ScopeScriptedShader.SelfIllumination = none;
        Level.ObjectPool.FreeObject(ScopeScriptedShader);
        ScopeScriptedShader = none;
    }
}

defaultproperties
{
    ScriptedTextureFallback=Shader'Weapons1st_tex.Zoomscope.LensShader'
    OverlayCenterSize=0.7
    bIsSniper=true
    bSniping=true
    FreeAimRotationSpeed=6.0
    bCanAttachOnBack=true
    BobModifyFactor=0.15
    PlayerIronsightFOV=90.0
}
