//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_EnfieldNo4ScopedWeapon extends DH_BoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_EnfieldNo4_1st.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Scopeshaders.utx

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
    {
        AmountToAdd = CurrentBulletCount;
    }
    else
    {
        AmountToAdd = AmountNeeded;
    }

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

    for (i = 0; i < PrimaryAmmoArray.Length; i++)
    {
        PrimaryAmmoArray[i] = InitialAmount;
    }

    CurrentMagIndex = 0;
    CurrentMagCount = PrimaryAmmoArray.Length - 1;

    // HACK: Because the No4 uses two mags, the initial amount needs to be two mags
    PrimaryAmmoArray[CurrentMagIndex] = 10;
    AddAmmo(InitialAmount * 2,0);
    CalculateBulletCount();

    return true;
}

// Overriden to handle special No.4 magazine functionality
function GiveAmmo(int M, WeaponPickup WP, bool bJustSpawned)
{
    local bool bJustSpawnedAmmo;
    local int AddAmount, InitialAmount, i;
    local DHWeaponPickup DHWP;

    if (FireMode[M] != none && FireMode[M].AmmoClass != none)
    {
        Ammo[M] = Ammunition(Instigator.FindInventoryType(FireMode[M].AmmoClass));

        bJustSpawnedAmmo = false;

        if (FireMode[M].AmmoClass == none || (M != 0 && FireMode[M].AmmoClass == FireMode[0].AmmoClass))
        {
            return;
        }

        InitialAmount = FireMode[M].AmmoClass.default.InitialAmount;

        if (bJustSpawned && WP == none)
        {
            PrimaryAmmoArray.Length = InitialNumPrimaryMags;

            for (i = 0; i < PrimaryAmmoArray.Length; ++i)
            {
                PrimaryAmmoArray[i] = InitialAmount;
            }

            CurrentMagIndex = 0;
            PrimaryAmmoArray[CurrentMagIndex] = 10;
            InitialAmount = InitialAmount * 2;
        }

        if (WP != none)
        {
            InitialAmount = WP.AmmoAmount[M];

            DHWP = DHWeaponPickup(WP);

            if (DHWP != none)
            {
                for (i = 0; i < DHWP.AmmoMags.Length; ++i)
                {
                    PrimaryAmmoArray[i] = DHWP.AmmoMags[i];
                }

                CurrentMagIndex = DHWP.LoadedMagazineIndex;
            }
        }

        CurrentMagCount = PrimaryAmmoArray.Length - 1;

        if (Ammo[M] != none)
        {
            AddAmount = InitialAmount + Ammo[M].AmmoAmount;

            Ammo[M].Destroy();
        }
        else
        {
            AddAmount = InitialAmount;
        }

        AddAmmo(AddAmount, M);
    }

    CalculateBulletCount();
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
    TexturedScopeTexture=texture'DH_Weapon_tex.AlliedSmallArms.EnfieldNo4_Scope_Overlay'
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
