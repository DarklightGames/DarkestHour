//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHProjectileWeapon extends DHWeapon
    abstract;

enum EUnloadedMunitionsPolicy
{
    UMP_Preserve,       // preserve unloaded "magazines" as-is (default)
    UMP_Discard,        // any unloaded munitions are immediately discarded
    UMP_Consolidate,    // unloaded munitions will be consolidated into full magazines
};

// Ammo/magazines
var         array<int>  PrimaryAmmoArray;           // the array of magazines and their ammo amounts this weapon has
var         byte        CurrentMagCount;            // current number of magazines, this should be replicated to the client (changed from int to byte for more efficient replication)
var         int         MaxNumPrimaryMags;          // the maximum number of mags a solder can carry for this weapon, should move to the role info
var         int         InitialNumPrimaryMags;      // the number of mags the soldier starts with, should move to the role info
var         int         CurrentMagIndex;            // the index of the magazine currently in use
var         int         NextMagAmmoCount;           // the amount of ammo being loaded into the next magazine
var         bool        bUsesMagazines;             // this weapon uses magazines, not single bullets, etc
var         bool        bTwoMagsCapacity;           // this weapon can be loaded with two magazines
var         bool        bPlusOneLoading;            // can have an extra round in the chamber when you reload before empty
var         EUnloadedMunitionsPolicy UnloadedMunitionsPolicy;
var         int         SavedRoundCount;            // number of rounds that have been saved from discarded magazines
var         bool        bDoesNotRetainLoadedMag;    // this weapon does not retain its loaded 'mag' when put away or dropped & it doesn't start loaded (e.g. bazooka or panzerschreck)
var         int         FillAmmoMagCount;           // the number of mags that a resupply point will try to add each time
var         bool        bCanBeResupplied;           // the weapon can be resupplied by another player
var         int         NumMagsToResupply;          // number of ammo mags to add when this weapon has been resupplied

// Animations
var         array<name> MagEmptyReloadAnims;        // anim for reloads when a weapon has an empty magazine/box, this anim will be used by bolt actions when inserting a full stripper clip
var         array<name> MagPartialReloadAnims;      // anim for reloads when a weapon still has ammo in magazine/box

var         name        BipodIdleAnim;
var         name        BipodIdleEmptyAnim;
var         name        BipodMagEmptyReloadAnim;
var         name        BipodMagPartialReloadAnim;

var         name        IronIdleAnim;               // anim for weapon idling while in iron sight view
var         name        IronBringUp;                // anim for weapon being brought up to iron sight view
var         name        IronBringUpRest;            // anim for weapon being brought up to iron sight view when needing to bolt
var         name        IronPutDown;                // anim for weapon being lowered out of iron sight view

var         name        BayoAttachAnim;             // anim for attaching the bayonet
var         name        BayoDetachAnim;             // anim for detaching the bayonet
var         name        BayoAttachEmptyAnim;        // anim for attaching the bayonet when empty
var         name        BayoDetachEmptyAnim;        // anim for detaching the bayonet when empty
var         name        BayonetBoneName;            // name for the bayonet bone, used in scaling the bayonet bone based on its attachment status
var         bool        bHasBayonet;                // whether or not this weapon has a bayonet

var         name        MuzzleBone;                 // muzzle bone, used to get coordinates
var         float       IronSwitchAnimRate;         // the rate to play the ironsight animation at

// Empty animations used for weapons that have visible empty states (pistols, PTRD, etc)
var         name        IdleEmptyAnim;              // anim for weapon idling empty
var         name        IronIdleEmptyAnim;          // anim for weapon idling while in iron sight view empty

var         name        IronBringUpEmpty;           // anim for weapon being brought up to iron sight view
var         name        IronPutDownEmpty;           // anim for weapon being lowered out of iron sight view

var         name        SprintStartEmptyAnim;       // anim that shows the beginning of the sprint with empty weapon
var         name        SprintLoopEmptyAnim;        // anim that is looped for when player is sprinting with empty weapon
var         name        SprintEndEmptyAnim;         // anim that shows the weapon returning to normal after sprinting with empty weapon

var()       name        CrawlForwardEmptyAnim;      // animation for crawling forward empty
var()       name        CrawlBackwardEmptyAnim;     // animation for crawling backward empty
var()       name        CrawlStartEmptyAnim;        // animation for starting to crawl empty
var()       name        CrawlEndEmptyAnim;          // animation for ending crawling empty

var()       name        SelectEmptyAnim;            // animation for drawing an empty weapon
var()       name        PutDownEmptyAnim;           // animation for putting away an empty weapon

// Manual bolting anims
var()       name        BoltHipAnim;                // animation for bolting after hip firing
var()       name        BoltIronAnim;               // animation for bolting while in ironsight view
var()       name        PostFireIdleAnim;           // animation after hip firing
var()       name        PostFireIronIdleAnim;       // animation after firing while in ironsight view

// Barrels
var     class<DHWeaponBarrel>   BarrelClass;        // barrel type we use now
var     array<DHWeaponBarrel>   Barrels;            // array of any carried barrels for this weapon
var     byte                InitialBarrels;         // barrels initially given
var     bool                bHasSpareBarrel;        // we have at least one spare barrel we can switch to (minimal replication so net client knows whether can change barrel)
var     byte                BarrelIndex;            // index number of current barrel
var     name                BarrelChangeAnim;       // anim for bipod barrel changing while deployed
var     bool                bCallBarrelChangeTimer; // we're in middle of a barrel change, so Timer() should call PerformBarrelChange() instead of exiting state ChangingBarrels
var     float               BarrelChangeDuration;   // saves duration of barrel change, so Timer() can be called at mid point & then again at end of barrel change animation
var     float               BarrelTemperature;
var     class<ROMGSteam>    BarrelSteamEmitterClass;
var     ROMGSteam           BarrelSteamEmitter;
var     name                BarrelSteamBone;        // bone we attach the barrel steam emitter to
var     bool                bBarrelSteamActive;     // barrel is steaming
var     bool                bBarrelDamaged;         // barrel is close to failure, accuracy is VERY BAD
var     bool                bBarrelFailed;          // barrel overheated and can't be used

// Bipod
var     bool    bCanFireFromHip;                // if true this weapon has a hip firing mode
var     bool    bMustFireWhileSighted;          // if true, this weapon can only be fired while using sights or bipod
var     bool    bMustReloadWithBipodDeployed;   // when true, reloads can only occur while bipodded

var     float   PlayerDeployFOV;            // the FOV that the player's view will be when the bipod is deployed

var     name    IdleToBipodDeploy;          // anim for bipod rest state to deployed state
var     name    IdleToBipodDeployEmpty;     // anim for bipod rest state to deployed empty state
var     name    IronToBipodDeploy;
var     name    IronToBipodDeployEmpty;
var     name    BipodDeployToIdle;          // anim for bipod deployed state to rest state
var     name    BipodIdleToHip;             // anim for bipod rest state to hip state
var     name    BipodHipToIdle;             // anim for bipod hip state to rest state
var     name    BipodHipIdle;               // anim for idle bipod hip state
var     name    BipodHipToDeploy;           // anim for bipod hip state to deployed state
var     name    BipodDeployToHip;           // anim for bipod deployed state to hip state
var     name    BipodDeployToIdleEmpty;     // anim for bipod deployed state to rest empty state

var     bool                        bDoBipodPhysicsSimulation;
var     DHBipodPhysicsSettings      BipodPhysicsSettings;
var     DHBipodPhysicsSimulation    BipodPhysicsSimulation;

// Scopes
var     bool            bHasScope;
var     bool            bHasModelScope;
var     bool            bForceModelScope;        // force the use of the 3D scope
var     float           ScopePortalFOV;          // the FOV to zoom the scope portal by
var     float           ScopePortalFOVHigh;
var     bool            bInitializedScope;       // set to true when the scope has been initialized
var     bool            bDebugSights;            // shows centering cross in scope overlay for testing purposes
var     texture         ScopeOverlay;            // texture overlay for scope
var     float           ScopeOverlaySize;        // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
var     float           OverlayCorrectionX;      // scope center correction in pixels, in case an overlay is off-center by pixel or two
var     float           OverlayCorrectionY;
var()       int         LensMaterialID;        // used since material id's seem to change alot

// Not sure if these pitch vars are still needed now that we use Scripted Textures. We'll keep for now in case they are. - Ramm 08/14/04
var()       int         ScopePitch;             // Tweaks the pitch of the scope firing angle
var()       int         ScopeYaw;               // Tweaks the yaw of the scope firing angle
var()       int         ScopePitchHigh;         // Tweaks the pitch of the scope firing angle high detail scope
var()       int         ScopeYawHigh;           // Tweaks the yaw of the scope firing angle high detail scope

// 3d Scope vars
var   ScriptedTexture   ScopeScriptedTexture;       // Scripted texture for 3d scopes
var   Shader            ScopeScriptedShader;        // The shader that combines the scripted texture with the sight overlay
var   Material          ScriptedTextureFallback;    // The texture to render if the users system doesn't support shaders
var   Material          ScriptedScopeTexture;       // The reticle texture to use for 3d scopes.
var   Combiner          ScriptedScopeCombiner;
var   bool              bForceRenderScope;          // When true, the 3D scope will be rendered despite the user's settings
var   int               ScopeScriptedTextureSize;   // Size, in pixels, for each dimension of the scripted scope texture (use powers of two!)

var     bool            bCanUseIronsights;      // allows firing from a shouldered/hipfire position (while not deployed)

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        CurrentMagCount, bHasSpareBarrel, bBarrelDamaged, bBarrelFailed, BarrelTemperature, NextMagAmmoCount;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerRequestReload, ServerZoomIn, ServerZoomOut, ServerChangeBayoStatus, ServerWorkBolt, ServerSwitchBarrels, ServerBipodDeploy;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientDoReload, ClientCancelReload, ClientSetBarrelSteam;
}

// Play an idle animation on a server so that weapon will be in the right position for hip hire calculations (requires muzzle bone to be in correct location & rotation)
// Server won't be in sync with net client's weapon position when ironsighted or bipod deployed, but doesn't matter as sighted calculations don't use weapon's position
simulated function PostBeginPlay()
{
    local DHPlayer PC;

    // Pre-apply bayonet based on user setting (the user setting gets updated when client connects or changes the setting)
    // If this is a bayonet weapon & is the server and client wants a bayonet attached at spawn, then set the bayonet mounted and update status
    if (bHasBayonet && Role == ROLE_Authority && Instigator != none && Instigator.Controller != none)
    {
        PC = DHPlayer(Instigator.Controller);

        if (PC != none && PC.bSpawnWithBayonet)
        {
            bBayonetMounted = true;
            UpdateBayonet();
        }
    }

    // Now call the super (after the server handles the bayonet)
    super.PostBeginPlay();

    if (Role == ROLE_Authority && !InstigatorIsLocallyControlled())
    {
        // Play the right idle animation on the server so that the weapon will be in the right
        // position for hip hire calculations
        if (bCanBipodDeploy && HasAnim(BipodHipIdle))
        {
            PlayAnim(BipodHipIdle, IdleAnimRate, 0.0);
        }
        else if (HasAnim(IdleAnim))
        {
            PlayAnim(IdleAnim, IdleAnimRate, 0.0);
        }
    }

    if (InstigatorIsLocallyControlled())
    {
        CreateBipodPhysicsSimulation();
    }

    if (bHasScope)
    {
        ScopeDetail = class'DH_Engine.DHWeapon'.default.ScopeDetail;
        UpdateScopeMode();
    }
}

simulated function CreateBipodPhysicsSimulation()
{
    if (bDoBipodPhysicsSimulation && BipodPhysicsSettings != none)
    {
        BipodPhysicsSimulation = new class'DHBipodPhysicsSimulation';
        BipodPhysicsSimulation.Initialize(BipodPhysicsSettings);
    }
}

event WeaponTick(float DeltaTime)
{
    super.WeaponTick(DeltaTime);

    if (BipodPhysicsSimulation != none)
    {
        BipodPhysicsSimulation.PhysicsTick(self, DeltaTime);
    }
}

// Modified so works in DHDebugMode, & to log barrels & their current temperature & state
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    local DHWeaponBarrel Barrel;
    local int            i;

    if (Level.NetMode != NM_Standalone && !class'DH_LevelInfo'.static.DHDebugMode())
    {
        return;
    }

    super(Weapon).DisplayDebug(Canvas, YL, YPos); // skip over Super in ROWeapon, as it requires RODebugMode

    // The super from ROWeapon, logging the FOV settings
    Canvas.SetDrawColor(0, 255, 0);
    Canvas.DrawText("DisplayFOV is" @ DisplayFOV $ ", default is" @ default.DisplayFOV $ ", zoomed default is" @ IronSightDisplayFOV);
    YPos += YL;
    Canvas.SetPos(4.0, YPos);

    // Show the barrel info - only works in multi-player as barrel actors don't exist on net clients
    if (Role == ROLE_Authority)
    {
        for (i = 0; i < Barrels.Length; ++i)
        {
            Barrel = Barrels[i];

            if (Barrel != none)
            {
                if (i == BarrelIndex)
                {
                    Canvas.DrawText("Active barrel temp:" @ Barrel.Temperature @ "State:" @ Barrel.GetStateName());
                }
                else
                {
                    Canvas.DrawText("Hidden barrel temp:" @ Barrel.Temperature @ "State:" @ Barrel.GetStateName());
                }

                YPos += YL;
                Canvas.SetPos(4.0, YPos);
            }
        }
    }
}

// Modified to update player's resupply status, destroy any barrel steam emitters,
// and destroy scope textures.
simulated function Destroyed()
{
    super.Destroyed();

    if (Role == ROLE_Authority)
    {
        UpdateResupplyStatus(false);
    }

    if (BarrelSteamEmitter != none)
    {
        BarrelSteamEmitter.Destroy();
    }

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

// New state containing common function overrides from states that extend state Busy, so instead they extend WeaponBusy to reduce code repetition
simulated state WeaponBusy extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }
}

// Implemented in subclasses
function ServerWorkBolt()
{
}

// Debug logging to show how much ammo we have in our mags
exec simulated function LogAmmo()
{
    local int i, TotalAmmoCount;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Role == ROLE_Authority)
    {
        Log("Weapon has" @ AmmoAmount(0) @ "rounds loaded and a total of" @ PrimaryAmmoArray.Length @ "mags");

        TotalAmmoCount += AmmoAmount(0);

        for (i = 0; i < PrimaryAmmoArray.Length; ++i)
        {
            if (i == CurrentMagIndex)
            {
                Log("Current mag has" @ PrimaryAmmoArray[i] @ "ammo");
            }
            else
            {
                TotalAmmoCount += PrimaryAmmoArray[i];
                Log("Stowed mag" @ i @ "has " @ PrimaryAmmoArray[i] @ "ammo");
            }
        }

        Log("Total rounds:" @ TotalAmmoCount);
    }
}

// Called by animations to force the scope rendering.
simulated event DHForceRenderScope()
{
    bForceRenderScope = true;
}

simulated event RenderOverlays(Canvas Canvas)
{
    local ROPlayer Playa;
    local ROPawn   RPawn;
    local rotator  RollMod;
    local int      LeanAngle, i;
    local float    TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight, PosX, PosY;

    if (Instigator == none)
    {
        return;
    }

    Playa = ROPlayer(Instigator.Controller);

    // Don't draw the weapon if we're not viewing our own pawn
    if (Playa != none && Playa.ViewTarget != Instigator)
    {
        return;
    }

    if (bHasScope && !bInitializedScope)
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

    if (bUsesFreeAim && !bUsingSights && Playa != none && RPawn != none && !RPawn.bBipodDeployed)
    {
        if (!IsCrawling()) // note DH has added this restriction to prevent pitch adjustment if player is crawling
        {
            RollMod.Pitch += Playa.WeaponBufferRotation.Pitch;
        }

        RollMod.Yaw += Playa.WeaponBufferRotation.Yaw;
    }

    SetRotation(RollMod); // note DH always calls this, where in RO it was only called if player was not ironsighted (which made setting RollMod pointless when sighted)

    if (bHasScope && LensMaterialID != -1 && LensMaterialID < Skins.Length)
    {
        Skins[LensMaterialID] = ScriptedTextureFallback;
    }

    if (bHasScope && (bUsingSights || bForceRenderScope))  // TODO: also we shouldn't be in the idlerest animation!
    {
        if (bForceModelScope || ScopeDetail == RO_ModelScope || ScopeDetail == RO_ModelScopeHigh)
        {
            if (ShouldDrawPortal() && ScopeScriptedTexture != none)
            {
                Skins[LensMaterialID] = ScopeScriptedShader;
                ScopeScriptedTexture.Client = self;   // Need this because this can get corrupted - Ramm
                ScopeScriptedTexture.Revision = ScopeScriptedTexture.Revision + 1;
            }

            bDrawingFirstPerson = true;

            if (Playa != none)
            {
                Canvas.DrawBoundActor(self, false, false, DisplayFOV, Playa.Rotation, Playa.WeaponBufferRotation, Instigator.CalcZoomedDrawOffset(self));
            }

            bDrawingFirstPerson = false;
        }
        else if (ScopeDetail == RO_TextureScope && bPlayerViewIsZoomed)
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
    else if (bUsingSights)
    {
        // Use the special actor drawing when in ironsights to avoid the ironsight "jitter"
        // TODO: This messes up the lighting & texture environment map shader when using ironsights
        // Maybe use a texrotator to simulate the texture environment map, or just find a way to fix the problems
        bDrawingFirstPerson = true;

        if (Playa != none)
        {
            Canvas.DrawBoundActor(self, false, false, DisplayFOV, Playa.Rotation, Playa.WeaponBufferRotation, Instigator.CalcZoomedDrawOffset(self));
        }

        bDrawingFirstPerson = false;
    }
    else
    {
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }

    bDrawingFirstPerson = false;
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

simulated function bool ShouldDrawPortal()
{
    return bHasScope && (bForceRenderScope || (bUsingSights && (IsInState('Idle') || IsInState('PostFiring') || IsInState('SwitchingFireMode'))));
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

simulated function bool IsDebugModeAllowed()
{
    return Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode();
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

exec function EmptyMags()
{
    if (IsDebugModeAllowed())
    {
        PrimaryAmmoArray.Remove(0, PrimaryAmmoArray.Length);
    }
}

function SetServerOrientation(rotator NewRotation)
{
    local rotator WeaponRotation;

    if (bUsesFreeAim && !bUsingSights && Instigator != none)
    {
        // Remove the roll component so the weapon doesn't tilt with the terrain
        WeaponRotation = Instigator.GetViewRotation();
        WeaponRotation.Pitch += NewRotation.Pitch;
        WeaponRotation.Yaw += NewRotation.Yaw;

        if (ROPawn(Instigator) != none)
        {
            WeaponRotation.Roll += ROPawn(Instigator).LeanAmount;
        }

        SetRotation(WeaponRotation);
        SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));
    }
}

// Get the coords for the muzzle bone - used for free-aim projectile spawning
function coords GetMuzzleCoords()
{
    // Have to update the location of the weapon before getting the coords
    if (Instigator != none)
    {
        SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));
    }

    return GetBoneCoords(MuzzleBone);
}

simulated function bool IsInstigatorBipodDeployed()
{
    return Instigator != none && Instigator.bBipodDeployed;
}

// Modified so no free aim if using ironsights, bipod, or melee attacking
simulated function bool ShouldUseFreeAim()
{
    return bUsesFreeAim 
        && !bUsingSights 
        && !(FireMode[1].IsFiring() && FireMode[1].bMeleeMode)
        && !(bCanBipodDeploy && IsInstigatorBipodDeployed());
}

// Modified so bots may use a melee attack if really close to their enemy
function byte BestMode()
{
    local AIController C;

    if (Instigator != none)
    {
        C = AIController(Instigator.Controller);
    }

    if (C == none || C.Enemy == none)
    {
        return 0;
    }

    // If have alt fire melee attack mode, maybe use alt fire if really close to Enemy
    if (FireMode[1].bMeleeMode)
    {
        if (VSize(C.Enemy.Location - Instigator.Location) < 125.0 && FRand() < 0.3) // 30% chance if within approx 2m
        {
            return 1;
        }

        return 0;
    }

    return super.BestMode();
}

// Modified to update player's resupply status & to maybe set the barrel steaming (as the weapon is selected & brought up)
simulated function BringUp(optional Weapon PrevWeapon)
{
    if (Role == ROLE_Authority)
    {
        UpdateResupplyStatus(true);
    }

    super.BringUp(PrevWeapon);

    if (InstigatorIsLocalHuman())
    {
        if (bBarrelSteamActive)
        {
            SetBarrelSteamActive(true);
        }

        UpdateBayonet();
    }
}

// Modified to update player's resupply status
simulated function bool PutDown()
{
    if (Role == ROLE_Authority)
    {
        UpdateResupplyStatus(false);
    }

    return super.PutDown();
}

// Modified to prevent a reload if we're putting the weapon away
state Hidden
{
    simulated function bool AllowReload()
    {
        return false;
    }
}

simulated function UpdateBayonet()
{
    // Determines if bayonet capable weapon should come up with bayonet on or off
    if (bHasBayonet)
    {
        if (bBayonetMounted)
        {
            ShowBayonet();
        }
        else
        {
            HideBayonet();
        }
    }
}

// Modified to handle ironsights, empty anim & bayonet
simulated state RaisingWeapon
{
    simulated function BeginState()
    {
        local name Anim;
        local int  i;

        // If we have quickly raised our sights right after putting the weapon away, take us out of ironsight mode
        if (bUsingSights)
        {
            ZoomOut();
        }

        // Reset any zoom values
        if (InstigatorIsLocalHuman())
        {
            if (DisplayFOV != default.DisplayFOV)
            {
                DisplayFOV = default.DisplayFOV;
            }

            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }
        }

        if (AmmoAmount(0) < 1 && HasAnim(SelectEmptyAnim))
        {
            Anim = SelectEmptyAnim;
        }
        else
        {
            Anim = GetSelectAnim();
        }

        if (ClientState == WS_Hidden)
        {
            PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
            ClientPlayForceFeedback(SelectForce);

            if (InstigatorIsLocallyControlled())
            {
                UpdateBayonet();

                if (Mesh != none && HasAnim(Anim))
                {
                    PlayAnim(Anim, SelectAnimRate, 0.0);
                }
            }

            ClientState = WS_BringUp;
        }

        SetTimer(GetAnimDuration(Anim, SelectAnimRate), false);

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            FireMode[i].bIsFiring = false;
            FireMode[i].HoldTime = 0.0;
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
            FireMode[i].bInstantStop = false;
        }
    }
}

simulated state Idle
{
    simulated function BeginState()
    {
        super.BeginState();

        bForceRenderScope = false;
    }
}

// Modified to support ironsight zoom & empty put away anims
simulated state LoweringWeapon
{
    // Don't zoom in when we're lowering the weapon
    simulated function PerformZoom(bool bZoomIn)
    {
    }

    // Don't allow a reload if we're putting the weapon away
    simulated function bool AllowReload()
    {
        return false;
    }

    // Don't allow the bayo to be attached while lowering the weapon
    exec simulated function Deploy()
    {
    }

    simulated function BeginState()
    {
        local name Anim;
        local int  i;

        if (bUsingSights)
        {
            ZoomOut();
        }

        bForceRenderScope = false;

        if (AmmoAmount(0) < 1 && HasAnim(PutDownEmptyAnim))
        {
            Anim = PutDownEmptyAnim;
        }
        else
        {
            Anim = PutDownAnim;
        }

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (InstigatorIsLocallyControlled())
            {
                for (i = 0; i < NUM_FIRE_MODES; ++i)
                {
                    if (FireMode[i].bIsFiring)
                    {
                        ClientStopFire(i);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    if (HasAnim(GetSelectAnim()))
                    {
                        TweenAnim(GetSelectAnim(), PutDownTime);
                    }
                }
                else if (HasAnim(Anim))
                {
                    PlayAnim(Anim, PutDownAnimRate, 0.0);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(Anim, PutDownAnimRate), false);

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
        }
    }

    simulated function EndState()
    {
        super.EndState();

        // Important if player switchs weapon while IS
        if (bUsingSights && Role == ROLE_Authority)
        {
            ServerZoomOut();
        }

        // Destroy any barrel steam emitter
        if (BarrelSteamEmitter != none)
        {
            BarrelSteamEmitter.Destroy();
        }
    }

// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ZoomOut();
        }

        if (InstigatorIsLocalHuman())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
}

// Modified to prevent firing if out of ammo or barrel has failed, & to take player out of ironsights if trying to do melee attack in ironsights
simulated function bool StartFire(int Mode)
{
    if (!FireMode[Mode].bMeleeMode && (AmmoAmount(Mode) <= 0 || bBarrelFailed))
    {
        return false;
    }

    if (super.StartFire(Mode))
    {
        // Take the weapon out of ironsights if we're trying to do a melee attack in ironsights
        if (FireMode[Mode].bMeleeMode)
        {
            GotoState('UnZoomImmediately');
        }

        return true;
    }

    return false;
}

//=============================================================================
// Crawling
//=============================================================================

// Modified to handle crawl empty animations & to take the player out of ironsights
simulated state StartCrawling
{
    simulated function PlayIdle()
    {
        local int Direction;

        if (InstigatorIsLocallyControlled())
        {
            if (ROPawn(Instigator) != none)
            {
                Direction = ROPawn(Instigator).Get8WayDirection();
            }

            if (Direction == 0 || Direction == 2 || Direction == 3 || Direction == 4 || Direction == 5)
            {
                if (AmmoAmount(0) < 1 && HasAnim(CrawlForwardEmptyAnim))
                {
                    LoopAnim(CrawlForwardEmptyAnim, 1.0, 0.2);
                }
                else if (HasAnim(CrawlForwardAnim))
                {
                    LoopAnim(CrawlForwardAnim, 1.0, 0.2);
                }
            }
            else
            {
                if (AmmoAmount(0) < 1 && HasAnim(CrawlBackwardEmptyAnim))
                {
                    LoopAnim(CrawlBackwardEmptyAnim, 1.0, 0.2);
                }
                else if (HasAnim(CrawlBackwardAnim))
                {
                    LoopAnim(CrawlBackwardAnim, 1.0, 0.2);
                }
            }
        }
    }

// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        ZoomOut();

        if (InstigatorIsLocalHuman())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }

    // Finish unzooming the player if they are zoomed
    if (DisplayFOV != default.DisplayFOV && InstigatorIsLocalHuman())
    {
        SmoothZoom(false);
    }
}

// Modified to handle crawl empty animation
simulated function PlayStartCrawl()
{
    if (AmmoAmount(0) < 1 && HasAnim(CrawlStartEmptyAnim))
    {
        PlayAnimAndSetTimer(CrawlStartEmptyAnim, 1.0, 0.1);
    }
    else
    {
        PlayAnimAndSetTimer(CrawlStartAnim, 1.0, 0.1);
    }
}

// Modified to handle crawl empty animations
simulated state Crawling
{
    simulated function PlayIdle()
    {
        local int Direction;

        if (InstigatorIsLocallyControlled())
        {
            if (ROPawn(Instigator) != none)
            {
                Direction = ROPawn(Instigator).Get8WayDirection();
            }

            if (Direction == 0 || Direction == 2 || Direction == 3 || Direction == 4 || Direction == 5)
            {
                if (AmmoAmount(0) < 1 && HasAnim(CrawlForwardEmptyAnim))
                {
                    LoopAnim(CrawlForwardEmptyAnim, 1.0, 0.2);
                }
                else if (HasAnim(CrawlForwardAnim))
                {
                    LoopAnim(CrawlForwardAnim, 1.0, 0.2);
                }
            }
            else
            {
                if (AmmoAmount(0) < 1 && HasAnim(CrawlBackwardEmptyAnim))
                {
                    LoopAnim(CrawlBackwardEmptyAnim, 1.0, 0.2);
                }
                else if (HasAnim(CrawlBackwardAnim))
                {
                    LoopAnim(CrawlBackwardAnim, 1.0, 0.2);
                }
            }
        }
    }

// Finish unzooming the player if they are zoomed
Begin:
    if (DisplayFOV != default.DisplayFOV && InstigatorIsLocalHuman())
    {
        SmoothZoom(false);
    }
}

// Modified to handle crawl empty animation
simulated function PlayEndCrawl()
{
    if (AmmoAmount(0) < 1 && HasAnim(CrawlEndEmptyAnim))
    {
        PlayAnimAndSetTimer(CrawlEndEmptyAnim, 1.0);
    }
    else
    {
        PlayAnimAndSetTimer(CrawlEndAnim, 1.0);
    }
}

//==============================================================================
// Bayonet attach/detach functionality
//==============================================================================

// Hide the bayonet (also called by anim notifies to hide bayonet during the attach/detach transition)
simulated function HideBayonet()
{
    SetBoneScale(0, 0.001, BayonetBoneName); // scale down bayonet bone
}

// Hide the bayonet (also called by anim notifies to hide bayonet during the attach/detach transition)
simulated function ShowBayonet()
{
    SetBoneScale(0, 1.0, BayonetBoneName);
}

// Triggered by deploy keybind & attempts to deploy the bipod or attach/detach any bayonet
exec simulated function Deploy()
{
    local DHPlayer PC;
    local bool bNewDeployedStatus;

    if (bCanBipodDeploy)
    {
        // Bipod is either deployed or player can deploy the bipod
        if (!IsBusy() && Instigator != none && (Instigator.bBipodDeployed || Instigator.bCanBipodDeploy) && VSize(Instigator.Velocity) == 0.0)
        {
            if (Instigator.IsLocallyControlled())
            {
                PC = DHPlayer(Instigator.Controller);

                if (PC == none || Level.TimeSeconds < PC.NextToggleDuckTimeSeconds)
                {
                    return;
                }
            }

            bNewDeployedStatus = !Instigator.bBipodDeployed;

            BipodDeploy(bNewDeployedStatus); // toggle whether bipod is deployed

            if (Role < ROLE_Authority)
            {
                ServerBipodDeploy(bNewDeployedStatus);
            }
        }
    }
    else if (bHasBayonet)
    {
        if (!IsBusy() && !(FireMode[1].bMeleeMode && (FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking'))))
        {
            ChangeBayoStatus(!bBayonetMounted);
        }
    }
}

// Attach or detach the bayonet
simulated function ChangeBayoStatus(bool bBayoStatus)
{
    if (bBayoStatus)
    {
        GotoState('AttachingBayonet');
    }
    else
    {
        GotoState('DetachingBayonet');
    }

    if (Role < ROLE_Authority)
    {
        ServerChangeBayoStatus(bBayoStatus);
    }
}

function ServerChangeBayoStatus(bool bBayoStatus)
{
    if (bBayoStatus)
    {
        GotoState('AttachingBayonet');
    }
    else
    {
        GotoState('DetachingBayonet');
    }
}

simulated state AttachingBayonet extends WeaponBusy
{
    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function BeginState()
    {
        if (AmmoAmount(0) == 0 && HasAnim(BayoAttachEmptyAnim))
        {
            PlayAnimAndSetTimer(BayoAttachEmptyAnim, 1.0, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(BayoAttachAnim, 1.0, 0.1);
        }

        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).HandleBayoAttach();
        }
    }

    simulated function EndState()
    {
        bBayonetMounted = true;

        if (ROWeaponAttachment(ThirdPersonActor) != none)
        {
            ROWeaponAttachment(ThirdPersonActor).bBayonetAttached = true;
        }
    }

// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        ZoomOut();

        if (InstigatorIsLocalHuman())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
}

simulated state DetachingBayonet extends WeaponBusy
{
    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function BeginState()
    {
        if (AmmoAmount(0) == 0 && HasAnim(BayoDetachEmptyAnim))
        {
            PlayAnimAndSetTimer(BayoDetachEmptyAnim, 1.0, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(BayoDetachAnim, 1.0, 0.1);
        }

        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).HandleBayoDetach();
        }
    }

    simulated function EndState()
    {
        bBayonetMounted = false;

        if (ROWeaponAttachment(ThirdPersonActor) != none)
        {
            ROWeaponAttachment(ThirdPersonActor).bBayonetAttached = false;
        }
    }

// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        ZoomOut();

        if (InstigatorIsLocalHuman())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
}

//==============================================================================
// Bipod deploy/undeploy functionality
//==============================================================================

// Forces the bipod to undeploy when needed
simulated function ForceUndeploy()
{
    if (!IsBusy() && IsInstigatorBipodDeployed())
    {
        BipodDeploy(false);

        if (Role < ROLE_Authority)
        {
            ServerBipodDeploy(false);
        }
    }
}

// Sets the deployed or undeployed state
simulated function BipodDeploy(bool bNewDeployedStatus)
{
    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetBipodDeployed(bNewDeployedStatus);
    }

    if (bNewDeployedStatus)
    {
        GotoState('DeployingBipod');
    }
    else
    {
        GotoState('UndeployingBipod');
    }
}

// Client-to-server function to set the deployed or undeployed state
function ServerBipodDeploy(bool bNewDeployedStatus)
{
    if (Instigator != none && Instigator.bCanBipodDeploy)
    {
        BipodDeploy(bNewDeployedStatus);
    }
}

// Stop players from using crouch while deployed, as that allows exploit where player can see & shoot over obstacles whilst being invisible to their targets
// Players can still use crouch to undeploy instantly while proned however
simulated function bool WeaponAllowCrouchChange()
{
    if (bCanBipodDeploy && IsInstigatorBipodDeployed() && !Instigator.bIsCrawling)
    {
        return false;
    }

    return super.WeaponAllowCrouchChange();
}

simulated state DeployingBipod extends WeaponBusy
{
    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function BeginState()
    {
        local name Anim;

        if (bUsingSights && HasAnim(IronToBipodDeploy))
        {
            Anim = IronToBipodDeploy;
        }
        else if (AmmoAmount(0) < 1 && HasAnim(IdleToBipodDeployEmpty))
        {
            Anim = IdleToBipodDeployEmpty;
        }
        else
        {
            Anim = IdleToBipodDeploy;
        }

        if (BipodPhysicsSimulation != none)
        {
           BipodPhysicsSimulation.LockBipod(self, 0, 0.5);
        }

        PlayAnimAndSetTimer(Anim, IronSwitchAnimRate, 0.1);
    }

    simulated function EndState()
    {
        SetIronSightFOV();
    }
Begin:
    if (bUsingSights)
    {
        ZoomOut();
    }
    
    SetPlayerFOV(PlayerDeployFOV);

    if (InstigatorIsLocalHuman())
    {
        SmoothZoom(true);
    }
}

simulated state UndeployingBipod extends WeaponBusy
{
    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function BeginState()
    {
        if (AmmoAmount(0) < 1 && HasAnim(BipodDeployToIdleEmpty))
        {
            PlayAnimAndSetTimer(BipodDeployToIdleEmpty, IronSwitchAnimRate, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(BipodDeployToIdle, IronSwitchAnimRate, 0.1);
        }

        if (BipodPhysicsSimulation != none)
        {
            BipodPhysicsSimulation.UnlockBipod();
        }

        ResetPlayerFOV();
    }

    simulated function EndState()
    {
        if (Instigator != none && Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            NotifyCrawlMoving();
        }

        if (InstigatorIsLocalHuman())
        {
            DisplayFOV = default.DisplayFOV;
            PlayerViewOffset = default.PlayerViewOffset;
        }
    }

Begin:
    if (InstigatorIsLocalHuman())
    {
        SmoothZoom(false);
    }
}

//=============================================================================
// Ironsight transition functionality
//=============================================================================

// Triggered by ironsights keybind & toggles ironsights/bipod undeployment
simulated function ROIronSights()
{
    if (bCanBipodDeploy && Instigator != none && Instigator.bBipodDeployed)
    {
        // Bipod is deployed, let's undeploy it.
        ForceUndeploy();
    }
    else if (bCanUseIronsights || bCanFireFromHip)
    {
        PerformZoom(!bUsingSights);
    }
}

// Zoom in or out of ironsights view
simulated function PerformZoom(bool bZoomIn)
{
    if (IsBusy() && !IsCrawling())
    {
        return;
    }

    if (bZoomIn)
    {
        if (Instigator != none && Instigator.Physics == PHYS_Falling)
        {
            return;
        }

        // Don't allow them to go to ironsights during a melee attack
        if (FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking'))
        {
            return;
        }

        ZoomIn(true);

        if (Role < ROLE_Authority)
        {
            ServerZoomIn();
        }
    }
    else
    {
        ZoomOut(true);

        if (Role < ROLE_Authority)
        {
            ServerZoomOut();
        }
    }
}

// Zoom into ironsights view
simulated function ZoomIn(optional bool bAnimateTransition)
{
    // Don't allow player to go to ironsights while in melee mode
    if (FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking'))
    {
        return;
    }

    bUsingSights = true;

    // Make the player stop firing when they go to ironsights
    if (FireMode[0].bIsFiring)
    {
        FireMode[0].StopFiring();
    }

    if (InstigatorIsLocalHuman())
    {
        SetPlayerFOV(GetPlayerIronsightFOV());
    }

    if (bAnimateTransition)
    {
        GotoState('IronSightZoomIn');
    }

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetIronSightAnims(true);
    }
}

function ServerZoomIn()
{
    ZoomIn(true);
}

// Zoom out of ironsights view
simulated function ZoomOut(optional bool bAnimateTransition)
{
    ResetPlayerFOV();

    if (bAnimateTransition)
    {
        GotoState('IronSightZoomOut');
    }

    bUsingSights = false;

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetIronSightAnims(false);
    }
}

function ServerZoomOut()
{
    ZoomOut(true);
}

simulated state IronSightZoomIn extends WeaponBusy
{
    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function BeginState()
    {
        local name Anim;

        if (AmmoAmount(0) < 1 && HasAnim(IronBringUpEmpty))
        {
            Anim = IronBringUpEmpty;
        }
        else if (bWaitingToBolt && HasAnim(IronBringUpRest))
        {
            Anim = IronBringUpRest;
        }
        else
        {
            Anim = IronBringUp;
        }

        PlayAnimAndSetTimer(Anim, IronSwitchAnimRate, 0.15);
    }

    simulated function EndState()
    {
        SetIronSightFOV();

        if (bPlayerFOVZooms && InstigatorIsLocallyControlled())
        {
            PlayerViewZoom(true);
        }
    }

Begin:
    if (InstigatorIsLocalHuman())
    {
        SmoothZoom(true);
    }
}

// New function just to avoid code repetition in different functions
simulated function SetIronSightFOV()
{
    local vector TargetPVO;

    if (InstigatorIsLocalHuman())
    {
        if (bHasScope)
        {
            if (ScopeDetail == RO_ModelScopeHigh)
            {
                TargetPVO = default.XoffsetHighDetail;
            }
            else if (ScopeDetail == RO_ModelScope)
            {
                TargetPVO = default.XOffsetScoped;
            }
            else
            {
                TargetPVO = default.PlayerViewOffset;
            }
        }
        else
        {
            TargetPVO = default.PlayerViewOffset;
        }

        DisplayFOV = default.IronSightDisplayFOV;
        PlayerViewOffset = TargetPVO;
    }
}

simulated state IronSightZoomOut extends WeaponBusy
{
    simulated function BeginState()
    {
        if (AmmoAmount(0) < 1 && HasAnim(IronPutDownEmpty))
        {
            PlayAnimAndSetTimer(IronPutDownEmpty, IronSwitchAnimRate, 0.15);
        }
        else
        {
            PlayAnimAndSetTimer(IronPutDown, IronSwitchAnimRate, 0.15);
        }
    }

    simulated function EndState()
    {
        if (Instigator != none && Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            NotifyCrawlMoving();
        }

        if (InstigatorIsLocalHuman())
        {
            DisplayFOV = default.DisplayFOV;
            PlayerViewOffset = default.PlayerViewOffset;
        }
    }

Begin:
    if (InstigatorIsLocalHuman())
    {
        if (bPlayerFOVZooms)
        {
            PlayerViewZoom(false);
        }

        SmoothZoom(false);
    }
}

// Takes the weapon out of ironsights or bipod if you jump
simulated function NotifyOwnerJumped()
{
    if (IsInstigatorBipodDeployed())
    {
        if (!IsBusy() || IsInState('DeployingBipod'))
        {
            BipodDeploy(false);

            if (Role < ROLE_Authority)
            {
                ServerBipodDeploy(false);
            }
        }
    }
    else if (!IsBusy() || IsInState('IronSightZoomIn'))
    {
        GotoState('TweenDown');
    }
}

// Just go back to the idle animation & take us out of zoom if we are zoomed
simulated state TweenDown extends WeaponBusy
{
    simulated function PlayIdle()
    {
        if (bUsingSights)
        {
            if (bWaitingToBolt && HasAnim(PostFireIronIdleAnim))
            {
                TweenAnim(PostFireIronIdleAnim, 0.5);
            }
            else if (AmmoAmount(0) < 1 && HasAnim(IronIdleEmptyAnim))
            {
                TweenAnim(IronIdleEmptyAnim, FastTweenTime);
            }
            else if (HasAnim(IronIdleAnim))
            {
                TweenAnim(IronIdleAnim, FastTweenTime);
            }
        }
        else
        {
            if (bWaitingToBolt && HasAnim(PostFireIdleAnim))
            {
                TweenAnim(PostFireIdleAnim, FastTweenTime);
            }
            else if (AmmoAmount(0) < 1 && HasAnim(IdleEmptyAnim))
            {
                TweenAnim(IdleEmptyAnim, FastTweenTime);
            }
            else if (HasAnim(IdleAnim))
            {
                TweenAnim(IdleAnim, FastTweenTime);
            }
        }
    }

    // Reset any zoom values
    simulated function EndState()
    {
        if (InstigatorIsLocalHuman())
        {
            global.PlayIdle();
        }
    }

Begin:
    if (bUsingSights)
    {
        SetTimer(default.ZoomOutTime + 0.1, false);

        ZoomOut();

        if (InstigatorIsLocallyControlled())
        {
            PlayIdle();

            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
    else
    {
        GotoState('Idle');
    }
}

// Modified to handle bipod, ironsight & empty anims
simulated function PlayIdle()
{
    if (bCanBipodDeploy && IsInstigatorBipodDeployed())
    {
        if (AmmoAmount(0) == 0 && HasAnim(BipodIdleEmptyAnim))
        {
            LoopAnim(BipodIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(BipodIdleAnim))
        {
            LoopAnim(BipodIdleAnim, IdleAnimRate, 0.2);
        }
    }
    else
    {
        if (bUsingSights)
        {
            if (bWaitingToBolt && HasAnim(PostFireIronIdleAnim))
            {
                LoopAnim(PostFireIronIdleAnim, IdleAnimRate, 0.5);
            }
            else if (AmmoAmount(0) < 1 && HasAnim(IronIdleEmptyAnim))
            {
                LoopAnim(IronIdleEmptyAnim, IdleAnimRate, FastTweenTime);
            }
            else if (HasAnim(BipodHipIdle))
            {
                LoopAnim(BipodHipIdle, IdleAnimRate, 0.2);
            }
            else if (HasAnim(IronIdleAnim))
            {
                LoopAnim(IronIdleAnim, IdleAnimRate, FastTweenTime);
            }
        }
        else
        {
            if (bWaitingToBolt && HasAnim(PostFireIdleAnim))
            {
                LoopAnim(PostFireIdleAnim, IdleAnimRate, FastTweenTime);
            }
            else if (AmmoAmount(0) < 1 && HasAnim(IdleEmptyAnim))
            {
                LoopAnim(IdleEmptyAnim, IdleAnimRate, FastTweenTime);
            }
            else if (HasAnim(IdleAnim))
            {
                LoopAnim(IdleAnim, IdleAnimRate, FastTweenTime);
            }
        }
    }
}

// Takes us out of zoom immediately - this is a non blocking state, and will not prevent firing, reloading, etc
// Use this when some non state changing action needs to bring us out of ironsights immediately, without playing the idle animation
simulated state UnZoomImmediately extends Idle
{
Begin:
    if (bUsingSights)
    {
        ZoomOut();

        if (InstigatorIsLocalHuman())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }

    GotoState('Idle');
}

//=============================================================================
// Sprinting
//=============================================================================

// Modified to handle empty anim & to take player out of ironsights
simulated state StartSprinting
{
    simulated function PlayIdle()
    {
        local float LoopSpeed, Speed2d;

        if (InstigatorIsLocallyControlled())
        {
            // Make the sprinting animation match the sprinting speed
            LoopSpeed = 1.5;
            Speed2d = VSize(Instigator.Velocity);
            LoopSpeed = (Speed2d / (Instigator.default.GroundSpeed * Instigator.SprintPct)) * 1.5;

            if ((AmmoAmount(0) <= 0) && HasAnim(SprintLoopEmptyAnim))
            {
                LoopAnim(SprintLoopEmptyAnim, LoopSpeed, 0.2);
            }
            else if (HasAnim(SprintLoopAnim))
            {
                LoopAnim(SprintLoopAnim, LoopSpeed, 0.2);
            }
        }
    }

// Take the player out of ironsights
Begin:
    ZoomOut();  // There are some cases where bUsingIronSights can be false, but the player is still zoomed in,
                // so lets not check it and just call ZoomOut() regardless

    if (InstigatorIsLocalHuman())
    {
        if (bPlayerFOVZooms)
        {
            PlayerViewZoom(false);
        }

        SmoothZoom(false);
    }
}

// Modified to handle empty anim
simulated function PlayStartSprint()
{
    if (AmmoAmount(0) <= 0 && HasAnim(SprintStartEmptyAnim))
    {
        PlayAnimAndSetTimer(SprintStartEmptyAnim, 1.5);
    }
    else if (HasAnim(SprintStartAnim))
    {
        PlayAnimAndSetTimer(SprintStartAnim, 1.5);
    }
}

// Modified to handle empty anim
simulated state WeaponSprinting
{
ignores PutDown, BringUp;

    simulated function PlayIdle()
    {
        local float LoopSpeed, Speed2d;

        if (InstigatorIsLocallyControlled())
        {
            // Make the sprinting animation match the sprinting speed
            LoopSpeed = 1.5;
            Speed2d = VSize(Instigator.Velocity);
            LoopSpeed = (Speed2d / (Instigator.default.GroundSpeed * Instigator.SprintPct)) * 1.5;

            if (AmmoAmount(0) <= 0 && HasAnim(SprintLoopEmptyAnim))
            {
                LoopAnim(SprintLoopEmptyAnim, LoopSpeed, FastTweenTime);
            }
            else if (HasAnim(SprintLoopAnim))
            {
                LoopAnim(SprintLoopAnim, LoopSpeed, FastTweenTime);
            }
        }
    }

// Finish unzooming the player if they are zoomed
Begin:
    if (DisplayFOV != default.DisplayFOV && InstigatorIsLocalHuman())
    {
        SmoothZoom(false);
    }
}

// Modified to handle empty anim
simulated function PlayEndSprint()
{
    if (AmmoAmount(0) <= 0 && HasAnim(SprintEndEmptyAnim))
    {
        PlayAnimAndSetTimer(SprintEndEmptyAnim, 1.5);
    }
    else
    {
        PlayAnimAndSetTimer(SprintEndAnim, 1.5);
    }
}

// New function to determine whether a reload is allowed
simulated function bool AllowReload()
{
    // Prevent reload (with message) if bipod not deployed
    if (bCanBipodDeploy && bMustReloadWithBipodDeployed && (Instigator == none || !Instigator.bBipodDeployed))
    {
        if (Instigator.Controller != none && PlayerController(Instigator.Controller) != none)
        {
            class'ROBipodWarningMsg'.static.ClientReceive(PlayerController(Instigator.Controller), 1);
        }

        return false;
    }

    // Weapons that can load 2 mags will not allow a mag to be loaded unless the 1st mag load has been used up
    if (bTwoMagsCapacity && AmmoAmount(0) > FireMode[0].AmmoClass.default.InitialAmount)
    {
        return false;
    }

    // To reload, the weapon must not be firing or busy & player must have at least 1 spare mag
    return !IsFiring() && !IsBusy() && CurrentMagCount > 0;
}

// Triggered by reload keybind & attempts to reload the weapon
exec simulated function ROManualReload()
{
    if (AllowReload())
    {
        if (Level.NetMode == NM_Client)
        {
            GotoState('PendingAction');
        }

        ServerRequestReload();
    }
}

function ServerRequestReload()
{
    if (AllowReload())
    {
        if (bCanBipodDeploy && IsInstigatorBipodDeployed())
        {
            GotoState('ReloadingBipod');
        }
        else
        {
            GotoState('Reloading');
        }

        if (!InstigatorIsLocallyControlled()) // a server makes an owning net client also go to state 'Reloading' (won't happen in SP or owning listen server)
        {
            ClientDoReload();
        }
    }
    else
    {
        ClientCancelReload();
    }
}

simulated function ClientDoReload(optional byte NumRounds)
{
    if (bCanBipodDeploy && IsInstigatorBipodDeployed())
    {
        GotoState('ReloadingBipod');
    }
    else
    {
        GotoState('Reloading');
    }
}

simulated function ClientCancelReload()
{
    GotoState('Idle');
}

simulated function bool IsSighted()
{
    return bUsingSights || IsInstigatorBipodDeployed();
}

// Modified to prevent firing if the weapon must be fired while sighted
simulated function bool ReadyToFire(int Mode)
{
    if (bMustFireWhileSighted && !IsSighted())
    {
        // This weapon must be fired while sighted.
        return false;
    }

    return super.ReadyToFire(Mode);
}

simulated state Reloading extends WeaponBusy
{
    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function BeginState()
    {
        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).HandleStandardReload();
        }

        if (Role == ROLE_Authority)
        {
            // Update the ammo count for the next magazine so that the client knows.
            // This is needed for magazines that appear differently depending on
            // how much ammo is in the magazine (e.g., DP-27).
            NextMagAmmoCount = PrimaryAmmoArray[GetNextMagIndex()];

            if (AmmoAmount(0) > 0 && bPlusOneLoading)
            {
                NextMagAmmoCount += 1;
            }
        }

        PlayReload();

        super.BeginState();
    }

    simulated function EndState()
    {
        if (Role == ROLE_Authority)
        {
            PerformReload();
        }

        bWaitingToBolt = false;

        super.EndState();
    }

    // This is overridden because the normal PlayIdle function will play the
    // "empty" animations after a reload because the client hasn't gotten
    // the message about the updated ammo count yet.
    simulated function PlayIdle()
    {
        local name Anim;

        if (Instigator.bBipodDeployed)
        {
            if (AmmoAmount(0) == 0 && HasAnim(BipodIdleEmptyAnim))
            {
                Anim = BipodIdleEmptyAnim;
            }
            else if (HasAnim(BipodIdleAnim))
            {
                Anim = BipodIdleAnim;
            }
        }
        else if (HasAnim(IdleAnim))
        {
            Anim = IdleAnim;
        }

        LoopAnim(Anim, IdleAnimRate, 0.2);
    }

// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        ZoomOut();

        if (InstigatorIsLocalHuman())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }

    // Sometimes the client will get switched out of ironsight mode before getting to the reload function - this should catch that
    if (InstigatorIsLocalHuman())
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        if (bPlayerFOVZooms)
        {
            PlayerViewZoom(false);
        }
    }
}

// State for reloading with bipod deployed
simulated state ReloadingBipod extends Reloading
{
    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function BeginState()
    {
        super.BeginState();

        ResetPlayerFOV();
    }
    
    simulated function EndState()
    {
        super.EndState();

        // TODO: if we're in a "reloading bipod" state, isn't the check of bBipodDeployed redundant?
        if (InstigatorIsLocalHuman() && Instigator.bBipodDeployed)
        {
            DisplayFOV = IronSightDisplayFOV;
        }
    }

    simulated function PlayIdle()
    {
        if (IsInstigatorBipodDeployed() && HasAnim(BipodIdleAnim))
        {
            LoopAnim(BipodIdleAnim, IdleAnimRate, 0.2);
        }
        else
        {
            super.PlayIdle();
        }
    }

// Take the player out of zoom & then zoom them back in
Begin:
    if (InstigatorIsLocalHuman() && Instigator.bBipodDeployed)
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        if (AmmoAmount(0) < 1 && HasAnim(BipodMagEmptyReloadAnim))
        {
            Sleep(GetAnimDuration(BipodMagEmptyReloadAnim, 1.0) - default.ZoomInTime - default.ZoomOutTime);
        }
        else
        {
            Sleep(GetAnimDuration(BipodMagPartialReloadAnim, 1.0) - default.ZoomInTime - default.ZoomOutTime);
        }

        SetPlayerFOV(PlayerDeployFOV);
        SmoothZoom(true);
    }
}

// Client gets sent to this state when the client has requested an action that needs verified by the server
// Once the server verifies they can start the action, the server will take the client out of this state
simulated state PendingAction extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        ZoomOut();

        if (InstigatorIsLocalHuman())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
}

// Returns the reload animation to play given the current state
simulated function name GetReloadAnim()
{
    if (bCanBipodDeploy && IsInstigatorBipodDeployed())
    {
        if (AmmoAmount(0) > 0 && HasAnim(BipodMagPartialReloadAnim))
        {
            return BipodMagPartialReloadAnim;
        }
        else if (HasAnim(BipodMagEmptyReloadAnim))
        {
            return BipodMagEmptyReloadAnim;
        }
    }
    
    if (AmmoAmount(0) > 0 || (bTwoMagsCapacity && CurrentMagCount < 2))
    {
        return MagPartialReloadAnims[Rand(MagPartialReloadAnims.Length)];
    }
    else
    {
        return MagEmptyReloadAnims[Rand(MagEmptyReloadAnims.Length)];
    }
}

// Play the reload animation & set a reload timer
simulated function PlayReload()
{
    PlayAnimAndSetTimer(GetReloadAnim(), 1.0, 0.1);
}

// Gets the index of the fullest magazine that is not our current magazine.
// This magazine index will be the next one loaded into the weapon if a
// a reload were to happen.
function int GetNextMagIndex()
{
    local int i, MaxCount, MagIndex;

    MaxCount = -1;
    MagIndex = -1;

    for (i = 0; i < PrimaryAmmoArray.Length; ++i)
    {
        if (i != CurrentMagIndex && PrimaryAmmoArray[i] > MaxCount)
        {
            MagIndex = i;
            MaxCount = PrimaryAmmoArray[i];
        }
    }

    return MagIndex;
}

// Gets the index of the fullest "magazine", including the current magazine
function int GetFullestMagIndex()
{
    local int i, MaxCount, MagIndex;

    MaxCount = -1;
    MagIndex = -1;

    for (i = 0; i < PrimaryAmmoArray.Length; ++i)
    {
        if (PrimaryAmmoArray[i] > MaxCount)
        {
            MagIndex = i;
            MaxCount = PrimaryAmmoArray[i];
        }
    }

    return MagIndex;
}

// New function to do the actual ammo swapping
function PerformReload(optional int Count)
{
    local int  CurrentMagLoad;
    local bool bDidPlusOneReload;

    if (CurrentMagCount < 1)
    {
        return;
    }

    // Record remaining no. of rounds in current mag
    CurrentMagLoad = AmmoAmount(0);

    if (bPlusOneLoading && CurrentMagLoad > 0) // deduct a round in the chamber for 'plus one' loading weapons
    {
        --CurrentMagLoad;
        bDidPlusOneReload = true;
    }

    // Discard current mag (remove it from ammo array) if it's empty, or if
    // weapon is set to discard current mag on reloading or if we're going to
    // load a 2nd clip into a weapon that can load 2 clips/mags (new clip
    // becomes the current 'mag')
    if (CurrentMagLoad <= 0 || UnloadedMunitionsPolicy == UMP_Discard || bTwoMagsCapacity)
    {
        // Remove current mag, meaning the next one in the array now becomes the new current mag
        PrimaryAmmoArray.Remove(CurrentMagIndex, 1);
    }
    // Check if we are unloading a partial clip and we are consolidating clips
    else if (CurrentMagLoad < FireMode[0].AmmoClass.default.InitialAmount && UnloadedMunitionsPolicy == UMP_Consolidate)
    {
        // Remove the current magazine.
        PrimaryAmmoArray.Remove(CurrentMagIndex, 1);

        SavedRoundCount += CurrentMagLoad;
    }
    // Otherwise put the current mag back into player's spare mags
    else
    {
        PrimaryAmmoArray[CurrentMagIndex] = CurrentMagLoad; // update CurrentMagIndex with current no. of loaded rounds, as it won't have been updated when shots fire
    }

    if (UnloadedMunitionsPolicy == UMP_Consolidate)
    {
        // Consolidate saved rounds into a new magazine.
        while (SavedRoundCount >= FireMode[0].AmmoClass.default.InitialAmount)
        {
            PrimaryAmmoArray[PrimaryAmmoArray.Length] = FireMode[0].AmmoClass.default.InitialAmount;
            SavedRoundCount -= FireMode[0].AmmoClass.default.InitialAmount;
        }
    }

    // Set the current magazine to the fullest magazine that we have
    CurrentMagIndex = GetFullestMagIndex();

    // Now build up the new ammo 'charge' from the newly loaded mag
    if (!bTwoMagsCapacity)
    {
        CurrentMagLoad = 0; // start by resetting to empty, unless it's a weapon that can load 2 clips/mags (in which case we add ammo to existing)
    }

    if (bDidPlusOneReload) // for 'plus one' loading weapons, add the round that was already in the chamber
    {
        ++CurrentMagLoad;
    }

    CurrentMagLoad += PrimaryAmmoArray[CurrentMagIndex]; // add ammo from the new mag

    // For weapons that can load 2 clips/mags, check if we can load a 2nd clip (possible if weapon was completely empty at start of reload)
    if (bTwoMagsCapacity && CurrentMagLoad <= FireMode[0].AmmoClass.default.InitialAmount && CurrentMagCount > 1)
    {
        PrimaryAmmoArray.Remove(CurrentMagIndex, 1);

        if (CurrentMagIndex >= PrimaryAmmoArray.Length)
        {
            CurrentMagIndex = 0;
        }

        CurrentMagLoad += PrimaryAmmoArray[CurrentMagIndex]; // bit of a hack, shoving rounds from 2nd clip into current 'mag'
    }

    // Now update the weapon's ammo 'charge' with the newly calculated rounds (only assign this once as it's a replicated variable)
    CurrentMagLoad = Min(CurrentMagLoad, FireMode[0].AmmoClass.default.MaxAmmo); // fail-safe to make sure ammo can never exceed maximum allowed
    AmmoCharge[0] = CurrentMagLoad;

    // Show a screen message indicating how full the new mag feels
    if (InstigatorIsHumanControlled())
    {
        if (AmmoStatus(0) > 0.5)
        {
            Instigator.ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 0);
        }
        else if (AmmoStatus(0) > 0.2)
        {
            Instigator.ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 1);
        }
        else
        {
            Instigator.ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 2);
        }
    }

    // Update the weapon attachment ammo status
    if (AmmoAmount(0) > 0 && ROWeaponAttachment(ThirdPersonActor) != none)
    {
        ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
    }

    UpdateResupplyStatus(true);
}

// Modified to start reload for a bot
simulated function OutOfAmmo()
{
    if (!HasAmmo())
    {
        if (ROWeaponAttachment(ThirdPersonActor) != none)
        {
            ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = true;
        }

        if (Instigator != none && AIController(Instigator.Controller) != none)
        {
            GotoState('Reloading');
        }
    }
}

// Modified so HUD ammo display shows number of magazines carried by the player
simulated function int GetHudAmmoCount()
{
    return CurrentMagCount;
}

// Modified to allow a friendly player to resupply the weapon (for weapons that allow this)
function bool ResupplyAmmo()
{
    local int i;

    if (Level.TimeSeconds > LastResupplyTimestamp + ResupplyInterval)
    {
        if (bCanBeResupplied && PrimaryAmmoArray.Length < MaxNumPrimaryMags)
        {
            for (i = 0; i < NumMagsToResupply; ++i)
            {
                PrimaryAmmoArray[PrimaryAmmoArray.Length] = FireMode[0].AmmoClass.default.InitialAmount;

                if (PrimaryAmmoArray.Length >= MaxNumPrimaryMags)
                {
                    break;
                }
            }

            UpdateResupplyStatus(true);
            LastResupplyTimestamp = Level.TimeSeconds;
            return true;
        }
    }

    return false;
}

// Modified so resupply point gradually replenishes ammo (no full resupply in one go)
function bool FillAmmo()
{
    local int  InitialAmount, i;
    local bool bDidFillAmmo;

    if (Level.TimeSeconds > LastResupplyTimestamp + ResupplyInterval)
    {
        InitialAmount = FireMode[0].AmmoClass.default.InitialAmount;

        // If we can carry more mags, add one or more (no. added is FillAmmoMagCount)
        if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
        {
            for (i = 0; i < default.FillAmmoMagCount; ++i)
            {
                PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
                bDidFillAmmo = true;

                if (PrimaryAmmoArray.Length >= MaxNumPrimaryMags)
                {
                    break;
                }
            }
        }
        // Otherwise, if we already have max mags, try to find a mag that isn't full & swap it for a new full mag
        else if (FillAmmoMagCount > 0)
        {
            for (i = 0; i < PrimaryAmmoArray.Length; ++i)
            {
                if (PrimaryAmmoArray[i] < InitialAmount && i != CurrentMagIndex) // skip over the current mag, as we have to do a manual reload to physically swap that mag out
                {
                    PrimaryAmmoArray[i] = InitialAmount;
                    bDidFillAmmo = true;
                    break;
                }
            }
        }

        if (bDidFillAmmo && IsCurrentWeapon())
        {
            UpdateResupplyStatus(true);
        }
    }
    if (bDidFillAmmo)
    {
        LastResupplyTimestamp = Level.TimeSeconds;
    }

    return bDidFillAmmo;
}

// Modified to call UpdateResupplyStatus()
function DropFrom(vector StartLocation)
{
    if (bCanThrow)
    {
        UpdateResupplyStatus(false);
    }

    super.DropFrom(StartLocation);
}

// New function to update the player's resupply status & number of spare mags
function UpdateResupplyStatus(bool bCurrentWeapon)
{
    local DHPawn P;

    P = DHPawn(Instigator);

    if (bCurrentWeapon)
    {
        CurrentMagCount = Max(0, PrimaryAmmoArray.Length - 1); // update number of spare mags (replicated)
    }

    if (P != none)
    {
        P.bWeaponNeedsResupply = bCanBeResupplied && bCurrentWeapon && CurrentMagCount < (MaxNumPrimaryMags - 1) && (TeamIndex == 2 || TeamIndex == P.GetTeamNum());
        P.bWeaponNeedsReload = false;
    }
}

function SetNumMags(int M)
{
    PrimaryAmmoArray.Length = M;

    if (IsCurrentWeapon())
    {
        UpdateResupplyStatus(true);
    }
}

function GiveAmmo(int M, WeaponPickup WP, bool bJustSpawned)
{
    local DHWeaponPickup DHWP;
    local int            InitialAmount, i;

    if (FireMode[M].AmmoClass != none)
    {
        if (M != 0 && FireMode[M].AmmoClass == FireMode[0].AmmoClass)
        {
            return;
        }

        // If from a WeaponPickup, swap to the ammo from the picked up weapon
        if (WP != none)
        {
            InitialAmount = WP.AmmoAmount[M];
            DHWP = DHWeaponPickup(WP);

            if (DHWP != none)
            {
                PrimaryAmmoArray = DHWP.AmmoMags;
                CurrentMagIndex = DHWP.LoadedMagazineIndex;
            }

            if (IsCurrentWeapon())
            {
                UpdateResupplyStatus(true);
            }
        }
        // If just spawned, give the default ammo for the weapon
        else if (bJustSpawned)
        {
            InitialAmount = FireMode[M].AmmoClass.default.InitialAmount;
            CurrentMagIndex = 0;

            PrimaryAmmoArray.Length = Ceil(InitialNumPrimaryMags * GetInitialNumMagsPercentage());

            for (i = 0; i < PrimaryAmmoArray.Length; ++i)
            {
                PrimaryAmmoArray[i] = InitialAmount;
            }

            // If the weapon loads two mags, the initial loaded rounds needs to be two mags
            if (bTwoMagsCapacity)
            {
                PrimaryAmmoArray[CurrentMagIndex] *= 2; // bit of a hack, shoving rounds from 2nd clip into current 'mag'
                InitialAmount *= 2;
            }
        }

        // Give the weapon its loaded ammo (AmmoCharge)
        if (!bDoesNotRetainLoadedMag)
        {
            AmmoCharge[M] = InitialAmount;
        }
    }
}

// Modified to remove alternative handling if weapon's bNoAmmoInstances is set to false
function bool AddAmmo(int AmmoToAdd, int Mode)
{
    if (AmmoClass[0] == AmmoClass[Mode])
    {
        Mode = 0;
    }

    if (Level.GRI.WeaponBerserk > 1.0)
    {
        AmmoCharge[Mode] = MaxAmmo(Mode);
    }
    else if (AmmoCharge[mode] < MaxAmmo(Mode))
    {
        AmmoCharge[Mode] = Min(MaxAmmo(Mode), AmmoCharge[Mode] + AmmoToAdd);
    }

    NetUpdateTime = Level.TimeSeconds - 1.0;

    return true;
}

function float GetInitialNumMagsPercentage()
{
    local float InitialAmmoPercent;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        Warn("Could not find GRI in GetInitialNumMagsPercentage() in:" @ self);
        return 1.0;
    }

    // If we are a DHPawn and the weapon can have changed initial num mags, then get munition percentage
    if (DHPawn(Instigator) != none && bCanHaveInitialNumMagsChanged)
    {
        InitialAmmoPercent = GRI.TeamMunitionPercentages[Instigator.GetTeamNum()] / 100.0; // we are using a 0.0 to 1.0 percentage, not 100.0% so divide by 100.0
    }
    else
    {
        InitialAmmoPercent = 1.0; // Set max otherwise
    }

    return InitialAmmoPercent;
}

// Modified to handle picking up spare ammo magazines from a WeaponPickup, which is a new system in DH
function bool HandlePickupQuery(Pickup Item)
{
    local int i, Count, MagCount, RoundsRemaining;
    local DHWeaponPickup WP;

    // If no passed item, prevent pick up & stop checking rest of Inventory chain
    if (Item == none)
    {
        return true;
    }

    // Pickup weapon is same as this weapon, so see if we can pick up any spare
    // mags from it
    if (Class == Item.InventoryType && WeaponPickup(Item) != none)
    {
        WP = DHWeaponPickup(Item);

        // If we already have max mags, prevent pick up & stop checking rest of
        // Inventory chain (same if pickup isn't a DHWeaponPickup & won't have
        // stored mags)
        if (WP != none)
        {
            // Colin: Going to keep it simple here. This function is just going to
            // pool all the ammunition together and give as many magazines as it can
            // rather than some complicated thing where we have to sort out which
            // magazines are more full and what to take.

            // Count up all the rounds of ammunition in the pickup
            for (i = 0; i < WP.AmmoMags.Length; ++i)
            {
                Count += WP.AmmoMags[i];
            }

            // Calculate the amount of full magazines
            MagCount = Count / MaxAmmo(0);

            // Calculate the amount of remaining ammunition after filling up as many
            // magazines as we could
            RoundsRemaining = Count % MaxAmmo(0);

            // Add full magazines
            for (i = 0; PrimaryAmmoArray.Length < MaxNumPrimaryMags && i < MagCount; ++i)
            {
                PrimaryAmmoArray[PrimaryAmmoArray.Length] = MaxAmmo(0);
            }

            // Add magazine
            if (PrimaryAmmoArray.Length < MaxNumPrimaryMags && RoundsRemaining > 0)
            {
                PrimaryAmmoArray[PrimaryAmmoArray.Length] = RoundsRemaining;
            }
        }

        if (IsCurrentWeapon())
        {
            UpdateResupplyStatus(true);
        }

        // Need to do this here as we're going to prevent a new weapon pick up, so the pickup won't give a screen message or destroy/respawn itself
        Item.AnnouncePickup(Pawn(Owner));
        Item.SetRespawn();

        return true; // prevents pick up, as already have weapon, & stops checking rest of Inventory chain
    }

    // Pickup weapon's inventory slot is same as this weapon (& we can't carry more then one item in the same slot)
    if (Item.InventoryType.default.InventoryGroup == InventoryGroup)
    {
        // If this is the currently held weapon & it can be dropped by human player, throw it away & pick up the weapon on the ground
        if (InstigatorIsHumanControlled() && Instigator.Weapon != none && Instigator.Weapon.InventoryGroup == InventoryGroup && Instigator.CanThrowWeapon())
        {
            PlayerController(Instigator.Controller).ThrowWeapon();

            return false; // allows pick up of new weapon & stops checking rest of Inventory chain
        }

        return true; // prevents pick up (as can't carry more than 1 item in same slot) & stops checking rest of Inventory chain
    }

    // Didn't do any pick up for this weapon, so pass this query on to the next item in the Inventory chain
    // If we've reached the last Inventory item, returning false will allow pick up of the weapon
    return Inventory != none && Inventory.HandlePickupQuery(Item);
}

// Modified to prevent melee attacks while deployed
simulated event ClientStartFire(int Mode)
{
    if (!FireMode[Mode].bMeleeMode || !IsInstigatorBipodDeployed())
    {
        super.ClientStartFire(Mode);
    }
}

// Modified to prevent firing (with message) if neither ironsighted or bipod deployed
// Modified to play the dry-fire sound if you're out of ammo
// Note that firing cannot be stopped in this function; it can only be used to do extra things, like effects
// If the pawn calls Fire() on its Weapon, it appears that ClientStartFire() gets triggered by native code, which is where weapon actually commences firing process
simulated function Fire(float F)
{
    // TODO: only do this if you MUST be deployed to fire (new bool!)
    if (InstigatorIsHumanControlled() && bMustFireWhileSighted && !IsSighted())
    {
        // "You must be deployed to fire your weapon!";
        class'ROBipodWarningMsg'.static.ClientReceive(PlayerController(Instigator.Controller), 0);
    }
    else if (AmmoAmount(0) < 1 && !IsBusy() && FireMode[0].NoAmmoSound != none)
    {
        PlayOwnedSound(FireMode[0].NoAmmoSound, SLOT_None, 1.0,,,, false);
    }
}

//=============================================================================
// Barrels - overheating & changing
//=============================================================================

// Triggered by change barrel keybind & attempts to swap over the barrels
exec simulated function ROMGOperation()
{
    if (AllowBarrelChange())
    {
        GotoState('ChangingBarrels');

        if (Role < ROLE_Authority)
        {
            ServerSwitchBarrels();
        }
    }
}

function ServerSwitchBarrels()
{
    if (AllowBarrelChange())
    {
        GotoState('ChangingBarrels');
    }
}

simulated function bool AllowBarrelChange()
{
    return bHasSpareBarrel && IsInstigatorBipodDeployed() && !IsInState('ChangingBarrels') && !IsFiring() && !IsBusy();
}

// State where we are changing the barrel
simulated state ChangingBarrels extends WeaponBusy
{
    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function Timer()
    {
        // Means we're half-way through the barrel change animation, so now we call PerformBarrelChange() & set another Timer, which will later exit this state
        if (bCallBarrelChangeTimer)
        {
            bCallBarrelChangeTimer = false;
            PerformBarrelChange();
            SetTimer(FMax(0.5 * BarrelChangeDuration, 0.1), false); // minimum of 0.1 secs just in case something has gone wrong - guarantees we set another Timer & exit state
        }
        // Otherwise we just exit the state as normal, as we've completed the barrel change process
        else
        {
            super.Timer();
        }
    }

    simulated function BeginState()
    {
        local float AnimTimer;

        ResetPlayerFOV();

        // This replaces what would be PlayAnimAndSetTimer(), so on an authority role we set up to call a Timer to swap barrels halfway through the barrel change animation
        // This is so any current steam effect stops when the old barrel has been removed & put away, then we determine whether the new barrel should be steaming
        // This is rather hacky & should really be controlled by a notify event in the barrel change animation, but I can't justify re-making RO's MG34 & MG42 anim files just for that
        // TODO: looks like RO's MG34 & MG42 anim files were later re-made as DH versions so if they are retained the anim notifies can be added instead of this hacky functionality
        if (HasAnim(BarrelChangeAnim))
        {
            if (InstigatorIsLocallyControlled())
            {
                PlayAnim(BarrelChangeAnim, 1.0, 0.1);
            }

            AnimTimer = GetAnimDuration(BarrelChangeAnim) + FastTweenTime;

            if (Role == ROLE_Authority)
            {
                if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !InstigatorIsLocallyControlled()))
                {
                    BarrelChangeDuration = 0.9 * AnimTimer; // 10% ServerTimerReduction
                }
                else
                {
                    BarrelChangeDuration = AnimTimer;
                }

                bCallBarrelChangeTimer = true; // flag for state Timer to call PerformBarrelChange at mid-point of anim
                SetTimer(0.5 * BarrelChangeDuration, false);
            }
            else
            {
                SetTimer(AnimTimer, false); // normal timer on a net client as it doesn't control barrel changes, it just receives updates from the server
            }
        }
    }

// Take the player out of zoom & then zoom them back in
Begin:
    if (InstigatorIsLocalHuman())
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        Sleep(GetAnimDuration(BarrelChangeAnim, 1.0) - default.ZoomInTime - default.ZoomOutTime);

        SetPlayerFOV(PlayerDeployFOV);
        SmoothZoom(true);
    }
}

function PerformBarrelChange()
{
    // We only have the 1 barrel in our weapon, don't do anything
    if (bHasSpareBarrel)
    {
        if (BarrelIndex >= 0 && BarrelIndex < Barrels.Length && Barrels[BarrelIndex] != none)
        {
            // If the barrel has failed, we're going to toss it, so remove it from the barrel array
            if (Barrels[BarrelIndex].bBarrelFailed)
            {
                Barrels[BarrelIndex].Destroy();
                Barrels.Remove(BarrelIndex, 1);

                if (Barrels.Length < 2)
                {
                    bHasSpareBarrel = false;
                }

                // If just removed the last barrel in array, cycle back to 0 (otherwise BarrelIndex stays the same, as next barrel has dropped back into current index position)
                if (BarrelIndex >- Barrels.Length)
                {
                    BarrelIndex = 0;
                }
            }
            else
            {
                Barrels[BarrelIndex].SetCurrentBarrel(false); // old barrel is no longer current
                BarrelIndex = ++BarrelIndex % Barrels.Length; // cycle BarrelIndex (loops back to 0 when goes past the last barrel in array)
            }
        }

        if (Barrels[BarrelIndex] != none)
        {
            Barrels[BarrelIndex].SetCurrentBarrel(true);
        }
    }
}

// Called when we need to toggle barrel steam on or off, depending on the barrel temperature
simulated function SetBarrelSteamActive(bool bSteaming)
{
    bBarrelSteamActive = bSteaming;

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Spawn the steam emitter if we need it
        if (BarrelSteamEmitter == none && bBarrelSteamActive && BarrelSteamEmitterClass != none)
        {
            BarrelSteamEmitter = Spawn(BarrelSteamEmitterClass, self);

            if (BarrelSteamEmitter != none)
            {
                AttachToBone(BarrelSteamEmitter, BarrelSteamBone);
            }
        }

        // Toggle the steam emitter on/off if we need to
        if (BarrelSteamEmitter != none && BarrelSteamEmitter.bActive != bBarrelSteamActive)
        {
            BarrelSteamEmitter.Trigger(self, Instigator);
        }
    }

    // Server calls a replicated server-to-client function to do the same on the owning net client
    if ((Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer) && !InstigatorIsLocallyControlled())
    {
        ClientSetBarrelSteam(bBarrelSteamActive);
    }

    // Do the same on the 3rd person WeaponAttachment
    if (DHWeaponAttachment(ThirdPersonActor) != none)
    {
        DHWeaponAttachment(ThirdPersonActor).SetBarrelSteamActive(bBarrelSteamActive);
    }
}

// Modified so if the barrel is already steaming when the pawn gets this weapon, we set the same affect on the WeaponAttachment
// Necessary as attachment may not yet exist when SetBarrelSteamActive() is called in this class (e.g. when picking up a pickup)
function AttachToPawnHidden(Pawn P)
{
    super.AttachToPawnHidden(P);

    if (bBarrelSteamActive && DHWeaponAttachment(ThirdPersonActor) != none)
    {
        DHWeaponAttachment(ThirdPersonActor).SetBarrelSteamActive(true);
    }
}

function AttachToPawn(Pawn P)
{
    super.AttachToPawn(P);

    if (bBarrelSteamActive && DHWeaponAttachment(ThirdPersonActor) != none)
    {
        DHWeaponAttachment(ThirdPersonActor).SetBarrelSteamActive(true);
    }
}

simulated function ClientSetBarrelSteam(bool bSteaming)
{
    if (Role < ROLE_Authority)
    {
        SetBarrelSteamActive(bSteaming);
    }
}

function SetBarrelDamaged(bool bDamaged)
{
    bBarrelDamaged = bDamaged;
}

function SetBarrelFailed(bool bFailed)
{
    bBarrelFailed = bFailed;
}

function SetBarrelTemperature(float NewTemp)
{
    BarrelTemperature = NewTemp;
}

// Modified to give barrel actors to player, if relevant
function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local int i;

    super.GiveTo(Other, Pickup);

    if (BarrelClass != none && Role == ROLE_Authority)
    {
        // This weapon is spawning for this player, so spawn any barrels
        if (Pickup == none)
        {
            if (InitialBarrels > 0)
            {
                for (i = 0; i < InitialBarrels; ++i)
                {
                    Barrels[i] = Spawn(BarrelClass, self);
                }

                BarrelIndex = 0;
                Barrels[BarrelIndex].SetCurrentBarrel(true);
            }
        }
        // Player has picked up this weapon from the ground, so transfer any barrels from the pickup
        else if (DHWeaponPickup(Pickup) != none && DHWeaponPickup(Pickup).Barrels.Length > 0)
        {
            Barrels = DHWeaponPickup(Pickup).Barrels; // copy the pickup's reference to the Barrels array

            for (i = 0; i < Barrels.Length; ++i)
            {
                if (Barrels[i] != none)
                {
                    Barrels[i].SetOwner(self); // barrel's owner is now this weapon

                    if (Barrels[i].bIsCurrentBarrel)
                    {
                        BarrelIndex = i;
                        Barrels[BarrelIndex].UpdateBarrelStatus();
                    }
                }
            }
        }

        bHasSpareBarrel = Barrels.Length >= 2;
    }
}

// Modified to notify an active barrel that we have fired (so it can increase its temperature) & change the WeaponAttachment's sound if the barrel is damaged
simulated function bool ConsumeAmmo(int Mode, float Load, optional bool bAmountNeededIsMax)
{
    local DHWeaponBarrel B;
    local float          SoundModifier;

    if (BarrelIndex >= 0 && BarrelIndex < Barrels.Length)
    {
        B = Barrels[BarrelIndex];

        if (Role == ROLE_Authority && B != none)
        {
            B.WeaponFired();
        }

        if (ThirdPersonActor != none)
        {
            if (bBarrelDamaged && B != none)
            {
                SoundModifier = FMax(52.0, 64.0 - ((B.Temperature - B.CriticalTemperature) / (B.FailureTemperature - B.CriticalTemperature) * 52.0));
                ThirdPersonActor.SoundPitch = SoundModifier;
            }
            else if (ThirdPersonActor.SoundPitch != 64)
            {
                ThirdPersonActor.SoundPitch = 64;
            }
        }
    }

    return super.ConsumeAmmo(Mode, Load, bAmountNeededIsMax);
}

// New debug exec to show spread limits as red lines
exec function DebugSpread()
{
    local DHProjectileFire FM;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        FM = DHProjectileFire(FireMode[0]);

        if (FM != none)
        {
            FM.bDebugSpread = !FM.bDebugSpread;

            if (!FM.bDebugSpread)
            {
                ClearStayingDebugLines();
            }
        }
    }
}

// SCOPE STUFF
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

simulated function float GetScopePortalFOV()
{
    switch (ScopeDetail)
    {
        case RO_ModelScope:
            return ScopePortalFOV;
        case RO_ModelScopeHigh:
            return ScopePortalFOVHigh;
    }
}

simulated function vector GetScopePlayerViewOffset()
{
    switch (ScopeDetail)
    {
        case RO_ModelScope:
            return XoffsetScoped;
        case RO_ModelScopeHigh:
            return XoffsetHighDetail;
    }
}

simulated function GetScopeScriptedTextureSize(out int Width, out int Height)
{
    switch (ScopeDetail)
    {
        case RO_TextureScope:
        case RO_ModelScope:
            Width = default.ScopeScriptedTextureSize / 2;
            Height = default.ScopeScriptedTextureSize / 2;
            break;
        case RO_ModelScopeHigh:
            Width = default.ScopeScriptedTextureSize;
            Height = default.ScopeScriptedTextureSize;
            break;
    }
}

// Handles initializing and switching between different scope modes
simulated function UpdateScopeMode()
{
    local int Width, Height;

    if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        if (bForceModelScope || ScopeDetail == RO_ModelScope || ScopeDetail == RO_ModelScopeHigh)
        {
            ScopePortalFOV = GetScopePortalFOV();
            IronSightDisplayFOV = default.IronSightDisplayFOV;
            bPlayerFOVZooms = false;
            bHasModelScope = true;

            if (bUsingSights)
            {
                PlayerViewOffset = GetScopePlayerViewOffset();
            }

            if (ScopeScriptedTexture == none)
            {
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
            }

            GetScopeScriptedTextureSize(Width, Height);

            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(Width, Height);
            ScopeScriptedTexture.Client = self;

            if (ScriptedScopeCombiner == none)
            {
                // Construct the combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = ScriptedScopeTexture;
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

//============================================================================
// DEBUG FUNCTIONS FOR BIPOD PHYSICS SIMULATION
//============================================================================

simulated function EAxis AxisFromString(string S)
{
    if (S ~= "X") return AXIS_X;
    else if (S ~= "Y") return AXIS_Y;
    else if (S ~= "Z") return AXIS_Z;
    else return AXIS_X;
}

exec simulated function BarrelRollAxis(string AxisString)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSettings != none)
    {
        BipodPhysicsSettings.BarrelRollAxis = AxisFromString(AxisString);
    }
}

exec simulated function BarrelPitchAxis(string AxisString)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSettings != none)
    {
        BipodPhysicsSettings.BarrelPitchAxis = AxisFromString(AxisString);
    }
}

exec simulated function BarrelRotationOffset(int Pitch, int Yaw, int Roll)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSettings != none)
    {
        BipodPhysicsSettings.BarrelBoneRotationOffset.Pitch = Pitch;
        BipodPhysicsSettings.BarrelBoneRotationOffset.Yaw = Yaw;
        BipodPhysicsSettings.BarrelBoneRotationOffset.Roll = Roll;
    }
}

exec simulated function BipodArmLength(float V)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSimulation != none)
    {
        BipodPhysicsSimulation.Settings.ArmLength = V;
    }
}

exec simulated function BipodAngularDamping(float V)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSimulation != none)
    {
        BipodPhysicsSimulation.Settings.AngularDamping = V;
    }
}

exec simulated function BipodGravityScale(float V)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSimulation != none)
    {
        BipodPhysicsSimulation.Settings.GravityScale = V;
    }
}

exec simulated function BipodYawDeltaFactor(float V)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSimulation != none)
    {
        BipodPhysicsSimulation.Settings.YawDeltaFactor = V;
    }
}

exec simulated function BipodAngularVelocityThreshold(float V)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSimulation != none)
    {
        BipodPhysicsSimulation.Settings.AngularVelocityThreshold = V;
    }
}

exec simulated function BipodCoefficientOfRestitution(float V)
{
    if (Level.NetMode == NM_Standalone && BipodPhysicsSimulation != none)
    {
        BipodPhysicsSimulation.Settings.CoefficientOfRestitution = V;
    }
}

exec simulated function DebugAddedPitch(int AddedPitch)
{
    // Added to debug the distance zeroing.
    if (Level.NetMode == NM_Standalone)
    {
        if (DHProjectileFire(FireMode[0]) != none)
        {
            DHProjectileFire(FireMode[0]).AddedPitch = AddedPitch;
        }
    }
}

defaultproperties
{
    Priority=9
    bUsesFreeAim=true
    bCanRestDeploy=true
    bCanAttachOnBack=true
    bCanUseIronsights=true
    DisplayFOV=70.0
    PlayerDeployFOV=60.0
    IronSwitchAnimRate=1.0
    FastTweenTime=0.2
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FillAmmoMagCount=1
    MuzzleBone="Muzzle"
    BarrelSteamEmitterClass=class'DH_Effects.DHMGSteam'

    LightType=LT_Steady
    LightEffect=LE_NonIncidence
    LightHue=30
    LightSaturation=150
    LightBrightness=255.0
    LightRadius=4.0
    LightPeriod=3

    SelectAnim="Draw"
    PutDownAnim="Put_away"
    IronBringUp="iron_in"
    IronPutDown="iron_out"

    ScriptedTextureFallback=Material'Weapons1st_tex.Zoomscope.LensShader'
    LensMaterialID=-1
    ScriptedScopeTexture=Texture'ScopeShaders.Zoomblur.Xhair'
    ScopeOverlaySize=0.7
    ScopeScriptedTextureSize=1024

    IronIdleAnim="Iron_idle"
    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"
}
