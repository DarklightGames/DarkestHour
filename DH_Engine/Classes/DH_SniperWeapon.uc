//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SniperWeapon extends DH_ProjectileWeapon
    abstract;

#exec OBJ LOAD FILE=Weapons1st_tex.utx
#exec OBJ LOAD FILE=..\textures\ScopeShaders.utx
#exec OBJ LOAD FILE=InterfaceArt_tex.utx

var()       int         lenseMaterialID;        // used since material id's seem to change alot

var()       float       scopePortalFOVHigh;     // The FOV to zoom the scope portal by.
var()       float       scopePortalFOV;         // The FOV to zoom the scope portal by.

// Not sure if these pitch vars are still needed now that we use Scripted Textures. We'll keep for now in case they are. - Ramm 08/14/04
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
var() float     OverlayCenterSize;    // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var() float     OverlayCorrectionX;
var() float     OverlayCorrectionY;
var   bool      bInitializedScope;      // Set to true when the scope has been initialized

// Helper function for the scope system. The scope system checks here to see when it should draw the portal.
// If you want to limit any times the portal should/shouldn't be drawn, add them here.
// Ramm 10/27/03
simulated function bool ShouldDrawPortal()
{
    local name thisAnim;
    local float animframe;
    local float animrate;

    GetAnimParams(0, thisAnim, animframe, animrate);

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

// Handles initializing and swithing between different scope modes
simulated function UpdateScopeMode()
{
    if (Level.NetMode != NM_DedicatedServer &&
        Instigator != none && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        if (ScopeDetail == RO_ModelScope)
        {
            scopePortalFOV = default.scopePortalFOV;
            IronSightDisplayFOV = default.IronSightDisplayFOV;
            bPlayerFOVZooms = false;

            if (bUsingSights)
            {
                PlayerViewOffset = XoffsetScoped;
            }

            if (ScopeScriptedTexture == none)
            {
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'Scriptedtexture'));
            }

            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(512,512);
            ScopeScriptedTexture.Client = self;

            if (ScriptedScopeCombiner == none)
            {
                // Construct the Combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = texture'ScopeShaders.Zoomblur.Xhair';
                ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
                ScriptedScopeCombiner.CombineOperation = CO_Multiply;
                ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
                ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
            }

            if (ScopeScriptedShader == none)
            {
                // Construct the scope shader
                ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
                ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
                ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
            }

            bInitializedScope = true;
        }
        else if (ScopeDetail == RO_ModelScopeHigh)
        {
            scopePortalFOV = scopePortalFOVHigh;
            IronSightDisplayFOV = default.IronSightDisplayFOVHigh;
            bPlayerFOVZooms = false;

            if (bUsingSights)
            {
                PlayerViewOffset = XoffsetHighDetail;
            }

            if (ScopeScriptedTexture == none)
            {
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'Scriptedtexture'));
            }

            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(1024, 1024);
            ScopeScriptedTexture.Client = self;

            if (ScriptedScopeCombiner == none)
            {
                // Construct the Combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = texture'ScopeShaders.Zoomblur.Xhair';
                ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
                ScriptedScopeCombiner.CombineOperation = CO_Multiply;
                ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
                ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
            }

            if (ScopeScriptedShader == none)
            {
                // Construct the scope shader
                ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
                ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
                ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
            }

            bInitializedScope = true;
        }
        else if (ScopeDetail == RO_TextureScope)
        {
            IronSightDisplayFOV = default.IronSightDisplayFOV;
            PlayerViewOffset.X = default.PlayerViewOffset.X;
            bPlayerFOVZooms = true;

            bInitializedScope = true;
        }
    }
}

simulated event RenderOverlays(Canvas Canvas)
{
    local int m;
    local rotator RollMod;
    local ROPlayer Playa;
    //For lean - Justin
    local ROPawn rpawn;
    local int leanangle;
    // Drawpos actor
    local rotator RotOffset;
    local float scale;
    local float ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    if (Instigator == none)
    {
        return;
    }

    Playa = ROPlayer(Instigator.Controller);

    if (!bInitializedScope && Playa != none)
    {
        UpdateScopeMode();
    }

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    Canvas.DrawActor(none, false, true); // amb: Clear the z-buffer here

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != none)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }

    // these seem to set the current position and rotation of the weapon
    // in relation to the player

    //Adjust weapon position for lean
    rpawn = ROPawn(Instigator);

    if (rpawn != none && rpawn.LeanAmount != 0)
    {
        leanangle += rpawn.LeanAmount;
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

        RollMod.Roll += leanangle;

        if (IsCrawling())
        {
            RollMod.Pitch = CrawlWeaponPitch;
            RotOffset.Pitch = CrawlWeaponPitch;
        }
    }
    else
    {
        RollMod = Instigator.GetViewRotation();
        RollMod.Roll += leanangle;

        if (IsCrawling())
        {
            RollMod.Pitch = CrawlWeaponPitch;
            RotOffset.Pitch = CrawlWeaponPitch;
        }
    }

    if (bUsingSights && Playa != none && (ScopeDetail == RO_ModelScope || ScopeDetail == RO_ModelScopeHigh))
    {
        if (ShouldDrawPortal() && ScopeScriptedTexture != none)
        {
            Skins[LenseMaterialID] = ScopeScriptedShader;
            ScopeScriptedTexture.Client = self;   // Need this because this can get corrupted - Ramm
            ScopeScriptedTexture.Revision = (ScopeScriptedTexture.Revision +1);
        }

        bDrawingFirstPerson = true;

        Canvas.DrawBoundActor(self, false, false, DisplayFOV, Playa.Rotation, Playa.WeaponBufferRotation, Instigator.CalcZoomedDrawOffset(self));

        bDrawingFirstPerson = false;
    }
    // Added "bInIronViewCheck here. Hopefully it prevents us getting the scope overlay when not zoomed.
    // Its a bit of a band-aid solution, but it will work til we get to the root of the problem - Ramm 08/12/04
    else if (ScopeDetail == RO_TextureScope && bPlayerViewIsZoomed && bUsingSights)
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;

        if (!bUsingSights)
        {
           Log("Warning, drawing overlay texture and we aren't zoomed!!!");
        }

        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        scale = Canvas.SizeY / 1200.0;

         // Draw the reticle
        ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1 - OverlayCenterScale) * float(TexturedScopeTexture.USize) / 2;
        OverlayCenterTexSize =  float(TexturedScopeTexture.USize) * OverlayCenterScale;
        Canvas.SetPos(0, 0);
        Canvas.DrawTile(TexturedScopeTexture , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

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
    local ROPawn Rpawn;

    RollMod = Instigator.GetViewRotation();
    Rpawn = ROPawn(Instigator);

    // Subtract roll from view while leaning - Ramm
    if (Rpawn != none && rpawn.LeanAmount != 0)
    {
        RollMod.Roll += rpawn.LeanAmount;
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
        local float TargetDisplayFOV;
        local vector TargetPVO;

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (ScopeDetail == RO_ModelScopeHigh)
            {
                TargetDisplayFOV = default.IronSightDisplayFOVHigh;
                TargetPVO = default.XoffsetHighDetail;
            }
            else if (ScopeDetail == RO_ModelScope)
            {
                TargetDisplayFOV = default.IronSightDisplayFOV;
                TargetPVO = default.XoffsetScoped;
            }
            else
            {
                TargetDisplayFOV = default.IronSightDisplayFOV;
                TargetPVO = default.PlayerViewOffset;
            }

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
        ScopeScriptedTexture=none;
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
        ScopeScriptedTexture=none;
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
    OverlayCenterSize=0.700000
    bIsSniper=true
    FreeAimRotationSpeed=6.000000
    bCanAttachOnBack=true
}

