//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_EnfieldNo4ScopedWeapon extends DH_BoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_EnfieldNo4_1st.ukx
#exec OBJ LOAD FILE=..\textures\DH_Scopeshaders.utx

// Handles initializing and swithing between different scope modes
simulated function UpdateScopeMode()
{
    if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() &&
        Instigator.IsHumanControlled())
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
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
            }

            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(512,512);
            ScopeScriptedTexture.Client = self;

            if (ScriptedScopeCombiner == none)
            {
                // Construct the Combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = Texture'DH_ScopeShaders.Zoomblur.Enfield_Xhair';
                ScriptedScopeCombiner.FallbackMaterial = Shader'DH_ScopeShaders.Zoomblur.EnfieldLensShader';
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
                ScopeScriptedShader.FallbackMaterial = Shader'DH_ScopeShaders.Zoomblur.EnfieldLensShader';
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
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
            }
            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(1024,1024);
            ScopeScriptedTexture.Client = self;

            if (ScriptedScopeCombiner == none)
            {
                // Construct the Combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = Texture'DH_ScopeShaders.Zoomblur.Enfield_Xhair';
                ScriptedScopeCombiner.FallbackMaterial = Shader'DH_ScopeShaders.Zoomblur.EnfieldLensShader';
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
                ScopeScriptedShader.FallbackMaterial = Shader'DH_ScopeShaders.Zoomblur.EnfieldLensShader';
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

// Returns the number of bullets to be loaded
// Doing this again here to handle No4's unusual bullet capacity
function int GetRoundsToLoad()
{
    local int CurrentMagLoad;
    local int AmountToAdd, AmountNeeded;

    CurrentMagLoad = AmmoAmount(0);

    if (PrimaryAmmoArray.Length == 0)
    {
        return 0;
    }

    AmountNeeded = 10 - CurrentMagLoad;

    if (AmountNeeded > CurrentBulletCount)
        AmountToAdd = CurrentBulletCount;
    else
        AmountToAdd = AmountNeeded;

    return AmountToAdd;
}

// Overriden to handle special No.4 magazine functionality
function bool FillAmmo()
{
    local int InitialAmount, i;

    if (PrimaryAmmoArray.Length == MaxNumPrimaryMags)
    {
        return false;
    }

    InitialAmount = FireMode[0].AmmoClass.default.InitialAmount;

    PrimaryAmmoArray.Length = MaxNumPrimaryMags;
    for(i=0; i<PrimaryAmmoArray.Length; i++)
    {
        PrimaryAmmoArray[i] = InitialAmount;
    }
    CurrentMagIndex=0;
    CurrentMagCount = PrimaryAmmoArray.Length - 1;

    // HACK: Because the No4 uses two mags, the initial amount needs to be two mags
    PrimaryAmmoArray[CurrentMagIndex] = 10;
    AddAmmo(InitialAmount * 2,0);
    CalculateBulletCount();

    return true;
}

// Overriden to handle special No.4 magazine functionality
function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned)
{
    local bool bJustSpawnedAmmo;
    local int addAmount, InitialAmount, i;

    if (FireMode[m] != none && FireMode[m].AmmoClass != none)
    {
        Ammo[m] = Ammunition(Instigator.FindInventoryType(FireMode[m].AmmoClass));
        bJustSpawnedAmmo = false;

        if ((FireMode[m].AmmoClass == none) || ((m != 0) && (FireMode[m].AmmoClass == FireMode[0].AmmoClass)))
            return;

        InitialAmount = FireMode[m].AmmoClass.default.InitialAmount;

        if (bJustSpawned && WP == none)
        {
            PrimaryAmmoArray.Length = InitialNumPrimaryMags;
            for(i=0; i<PrimaryAmmoArray.Length; i++)
            {
                PrimaryAmmoArray[i] = InitialAmount;
            }
            CurrentMagIndex=0;
            CurrentMagCount = PrimaryAmmoArray.Length - 1;

            // HACK: Because the No4 uses two mags, the initial amount needs to be two mags
            PrimaryAmmoArray[CurrentMagIndex] = 10;
            InitialAmount = InitialAmount * 2;
        }

        if (WP != none)
        {
            InitialAmount = WP.AmmoAmount[m];
            PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
        }

        if (Ammo[m] != none)
        {
            addamount = InitialAmount + Ammo[m].AmmoAmount;
            Ammo[m].Destroy();
        }
        else
            addAmount = InitialAmount;

        AddAmmo(addAmount,m);
        CalculateBulletCount();
    }
}

defaultproperties
{
    PreReloadAnim="Single_Open"
    SingleReloadAnim="Single_Insert"
    PostReloadAnim="Single_Close"
    lenseMaterialID=5
    scopePortalFOVHigh=13.000000
    scopePortalFOV=7.000000
    scopeYaw=25
    scopePitchHigh=20
    scopeYawHigh=40
    TexturedScopeTexture=Texture'DH_Weapon_tex.AlliedSmallArms.EnfieldNo4_Scope_Overlay'
    IronIdleAnim="Scope_Idle"
    IronBringUp="Scope_In"
    IronPutDown="Scope_Out"
    BayonetBoneName="bayonet"
    BoltHipAnim="bolt_scope"
    BoltIronAnim="iron_boltrest"
    PostFireIronIdleAnim="Iron_idle"
    PostFireIdleAnim="Idle"
    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=40.000000
    IronSightDisplayFOVHigh=43.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.400000
    PlayerFOVZoom=27.000000
    XoffsetHighDetail=(X=-12.000000)
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4ScopedMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.400000
    CurrentRating=0.400000
    bSniping=true
    DisplayFOV=70.000000
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_EnfieldNo4ScopedPickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4ScopedAttachment'
    ItemName="Scoped Enfield No.4"
    Mesh=SkeletalMesh'DH_EnfieldNo4_1st.EnfieldNo4_Scoped'
}
