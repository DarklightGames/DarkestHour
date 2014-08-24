//=============================================================================
// DH_SpringfieldScopedWeapon
//=============================================================================

class DH_SpringfieldScopedWeapon extends DH_BoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Springfield_1st.ukx
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
            ScopeScriptedTexture.Client = Self;

            if (ScriptedScopeCombiner == none)
            {
                // Construct the Combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = Texture'DH_ScopeShaders.Zoomblur.Xhair';
                ScriptedScopeCombiner.FallbackMaterial = Shader'DH_ScopeShaders.Zoomblur.LensShader';
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
                ScopeScriptedShader.FallbackMaterial = Shader'DH_ScopeShaders.Zoomblur.LensShader';
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
            ScopeScriptedTexture.Client = Self;

            if (ScriptedScopeCombiner == none)
            {
                // Construct the Combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = Texture'DH_ScopeShaders.Zoomblur.Xhair';
                ScriptedScopeCombiner.FallbackMaterial = Shader'DH_ScopeShaders.Zoomblur.LensShader';
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
                ScopeScriptedShader.FallbackMaterial = Shader'DH_ScopeShaders.Zoomblur.LensShader';
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
     TexturedScopeTexture=Texture'DH_Weapon_tex.AlliedSmallArms.Springfield_Scope_Overlay'
     IronIdleAnim="Scope_Idle"
     IronBringUp="Scope_In"
     IronPutDown="Scope_Out"
     BayonetBoneName="bayonet"
     BoltHipAnim="bolt_scope"
     BoltIronAnim="iron_boltrest"
     PostFireIronIdleAnim="Iron_idlerest"
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
     PlayerFOVZoom=32.000000
     XoffsetHighDetail=(X=-2.000000)
     FireModeClass(0)=Class'DH_Weapons.DH_SpringfieldScopedFire'
     FireModeClass(1)=Class'DH_Weapons.DH_SpringfieldScopedMeleeFire'
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
     PickupClass=Class'DH_Weapons.DH_SpringfieldScopedPickup'
     BobDamping=1.600000
     AttachmentClass=Class'DH_Weapons.DH_SpringfieldScopedAttachment'
     ItemName="M1903 Springfield Scoped"
     Mesh=SkeletalMesh'DH_Springfield_1st.Springfield_Scoped'
}
