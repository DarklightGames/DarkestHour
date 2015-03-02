//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_SniperWeapon extends DH_ProjectileWeapon
    abstract;

#exec OBJ LOAD FILE=Weapons1st_tex.utx
#exec OBJ LOAD FILE=..\Textures\ScopeShaders.utx
#exec OBJ LOAD FILE=InterfaceArt_tex.utx

var()       int         lenseMaterialID;        // Used since material id's seem to change alot

var()       float       scopePortalFOVHigh;     // The FOV to zoom the scope portal by.
var()       float       scopePortalFOV;         // The FOV to zoom the scope portal by.

// Not sure if these pitch vars are still needed now that we use Scripted Textures. We'll keep for now in case they are - Ramm 08/14/04
var()       int         scopePitch;             // Tweaks the pitch of the scope firing angle
var()       int         scopeYaw;               // Tweaks the yaw of the scope firing angle
var()       int         scopePitchHigh;         // Tweaks the pitch of the scope firing angle high detail scope
var()       int         scopeYawHigh;           // Tweaks the yaw of the scope firing angle high detail scope

// 3d Scope vars
var   ScriptedTexture   ScopeScriptedTexture;   // Scripted texture for 3d scopes
var   Shader            ScopeScriptedShader;    // The shader that combines the scripted texture with the sight overlay
var   Material          ScriptedTextureFallback;// The texture to render if the users system doesn't support shaders

// new scope vars
var   Combiner  ScriptedScopeCombiner;

var   texture   TexturedScopeTexture;
var() float     OverlayCenterScale;
var() float     OverlayCenterSize;      // Size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var() float     OverlayCorrectionX;
var() float     OverlayCorrectionY;
var   bool      bInitializedScope;      // Set to true when the scope has been initialized


// Helper function for the scope system. The scope system checks here to see when it should draw the portal.
// If you want to limit any times the portal should/shouldn't be drawn, add them here. Ramm 10/27/03
simulated function bool ShouldDrawPortal()
{
    local name  ThisAnim;
    local float AnimFrame;
    local float AnimRate;

    GetAnimParams(0, ThisAnim, AnimFrame, AnimRate);

    if (bUsingSights && (IsInState('Idle') || IsInState('PostFiring')) && thisAnim != 'scope_shoot_last')
    {
        return true;
    }
    else
    {
        return false;
    }
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Get new scope detail value from ROWeapon
    ScopeDetail = class'ROEngine.ROWeapon'.default.ScopeDetail;

    UpdateScopeMode();
}

// Handles initializing and switching between different scope modes
simulated function UpdateScopeMode()
{
    if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        IronSightDisplayFOV = default.IronSightDisplayFOV;
        PlayerViewOffset.X = default.PlayerViewOffset.X;
        bPlayerFOVZooms = true;

        bInitializedScope = true;
    }
}

simulated event RenderOverlays(Canvas Canvas)
{
    local int      m;
    local rotator  RollMod;
    local ROPlayer Playa;
    local ROPawn   RPawn;
    local int      LeanAngle;
    local rotator  RotOffset;
//  local float    Scale; // Matt: removed as unused
    local float    ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    if (Instigator == none)
    {
        return;
    }

    Playa = ROPlayer(Instigator.Controller);

    if (!bInitializedScope && Playa != none)
    {
        UpdateScopeMode();
    }

    // Draw muzzleflashes/smoke for all fire modes so idle state won't cause emitters to just disappear
    Canvas.DrawActor(none, false, true);

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != none)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }

    // Adjust weapon position for lean
    RPawn = ROPawn(Instigator);

    if (RPawn != none && RPawn.LeanAmount != 0.0)
    {
        LeanAngle += RPawn.LeanAmount;
    }

    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    if (bUsesFreeAim && !bUsingSights)
    {
        // Remove the roll component so the weapon doesn't tilt with the terrain
        RollMod = Instigator.GetViewRotation();

        if (Playa != none)
        {
            RollMod.Pitch += Playa.WeaponBufferRotation.Pitch;
            RollMod.Yaw += Playa.WeaponBufferRotation.Yaw;

            RotOffset.Pitch -= Playa.WeaponBufferRotation.Pitch;
            RotOffset.Yaw -= Playa.WeaponBufferRotation.Yaw;
        }

        RollMod.Roll += LeanAngle;

        if (IsCrawling())
        {
            RollMod.Pitch = CrawlWeaponPitch;
            RotOffset.Pitch = CrawlWeaponPitch;
        }
    }
    else
    {
        RollMod = Instigator.GetViewRotation();
        RollMod.Roll += LeanAngle;

        if (IsCrawling())
        {
            RollMod.Pitch = CrawlWeaponPitch;
            RotOffset.Pitch = CrawlWeaponPitch;
        }
    }

    if (bPlayerViewIsZoomed && bUsingSights)
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;

        if (!bUsingSights)
        {
           Log("Warning, drawing overlay texture and we aren't zoomed!!!");
        }

        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
//      Scale = Canvas.SizeY / 1200.0; // Matt: removed as unused

         // Draw the reticle
        ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1.0 - OverlayCenterScale) * float(TexturedScopeTexture.USize) / 2.0;
        OverlayCenterTexSize =  float(TexturedScopeTexture.USize) * OverlayCenterScale;
        Canvas.SetPos(0.0, 0.0);
        Canvas.DrawTile(TexturedScopeTexture , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

    }
    else
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;
        SetRotation(RollMod);
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}

simulated event RenderTexture(ScriptedTexture Tex)
{
    local rotator RollMod;
    local ROPawn  Rpawn;

    RollMod = Instigator.GetViewRotation();
    Rpawn = ROPawn(Instigator);

    // Subtract roll from view while leaning - Ramm
    if (Rpawn != none && RPawn.LeanAmount != 0.0)
    {
        RollMod.Roll += RPawn.LeanAmount;
    }

    if (Owner != none && Instigator != none && Tex != none && Tex.Client != none)
    {
        Tex.DrawPortal(0, 0, Tex.USize, Tex.VSize, Owner, (Instigator.Location + Instigator.EyePosition()), RollMod, scopePortalFOV);
    }
}

simulated state IronSightZoomIn
{
    simulated function EndState()
    {
        local float  TargetDisplayFOV;
        local vector TargetPVO;

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            TargetDisplayFOV = default.IronSightDisplayFOV;
            TargetPVO = default.PlayerViewOffset;

            DisplayFOV = TargetDisplayFOV;
            PlayerViewOffset = TargetPVO;
        }

        if (Instigator.IsLocallyControlled() && bPlayerFOVZooms)
        {
            PlayerViewZoom(true);
        }
    }
}

simulated state IronSightZoomOut
{
    simulated function BeginState()
    {
        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(IronPutDown, 1.0, 0.2);

            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }
        }

        SetTimer(GetAnimDuration(IronPutDown, 1.0) + FastTweenTime, false);
    }
}

simulated event Destroyed()
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

    super.Destroyed();
}

simulated function PreTravelCleanUp()
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
    FreeAimRotationSpeed=6.0
    bCanAttachOnBack=true
}

