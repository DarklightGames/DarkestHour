//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1GarandGrenadeWeapon extends DHProjectileWeapon;

var     bool    bIsLastRound;
var   WeaponFire   FireModeGarand;
var   WeaponFire   FireModeBayonet;
var class<Projectile> ProjectileGrenade[2];
var() class<Ammunition> GrenadeAmmoClass[2];
var int GrenadeAmmoCharge[2];
var int GrenadeAmmoMax[2];
var int GrenadeIndex;


// Modified to support garand last round clip eject for client only
simulated function Fire(float F)
{
    super.Fire(F);

    bIsLastRound = AmmoAmount(0) == 1;
}

// New function to support garand last round clip eject for server only
simulated function bool WasLastRound()
{
    return AmmoAmount(0) == 0;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    FireModeGarand = FireMode[0];
    GrenadeIndex = 0;
    FireModeBayonet = new(self) class'DH_Weapons.DH_M1GarandGrenadeFire';
    FireModeBayonet.ThisModeNum = 0;
    FireModeBayonet.Weapon = self;
    FireModeBayonet.Instigator = Instigator;
    FireModeBayonet.Level = Level;
    FireModeBayonet.Owner = self;
    FireModeBayonet.PreBeginPlay();
    FireModeBayonet.BeginPlay();
    FireModeBayonet.PostBeginPlay();
    FireModeBayonet.SetInitialState();
    FireModeBayonet.PostNetBeginPlay();

    // GrenadeAmmoClass[0] = FireModeGarand.AmmoClass;
    // GrenadeAmmoClass[1] = class'DH_Weapons.DH_M1GarandGrenadeAmmo';

     if (bBayonetMounted)
    {
        ChangeBayoStatus(true);
    }
}

function PerformReload(optional int Count)
{
    if (bBayonetMounted)
    {
        GrenadeAmmoCharge[GrenadeIndex] = 1;

        if (GrenadeAmmoCharge[GrenadeIndex] > 0 && ROWeaponAttachment(ThirdPersonActor) != none)
        {
            ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
        }
    }
    else
    {
        super.PerformReload(Count);
    }
}

simulated function int MaxAmmo(int mode)
{
    if (bBayonetMounted)
    {
        return GrenadeAmmoMax[GrenadeIndex];
    }
    else
    {
		return FireModeGarand.AmmoClass.Default.MaxAmmo;
    }
}

simulated function int AmmoAmount(int mode)
{
    if (bBayonetMounted)
    {
        return GrenadeAmmoCharge[GrenadeIndex];
    }
    else
    {
        return super.AmmoAmount(0);
    }

	return 0;
}

function bool AddAmmo(int AmmoToAdd, int Mode)
{
    if (bBayonetMounted)
    {
        if (GrenadeAmmoCharge[GrenadeIndex] < MaxAmmo(0))
        {
            GrenadeAmmoCharge[GrenadeIndex] = Min(MaxAmmo(0), GrenadeAmmoCharge[GrenadeIndex] + AmmoToAdd);
            return true;
        }
        return false;
    }
    else
    {
        return super.AddAmmo(AmmoToAdd, 0);
    }
}

simulated function bool HasAmmo()
{
    if (bBayonetMounted)
    {
        return GrenadeAmmoCharge[GrenadeIndex] > 0;
    }
    else
    {
        return super.HasAmmo();
    }
}

exec function SwitchFireMode()
{
    Log("SwitchFireMode on M1 Garand Grenade Launcher");
    if (bBayonetMounted)
    {  
        Log("SwitchFireMode: Bayonet is mounted");
        if (FireMode[0] != FireModeBayonet)
        {
            ChangeBayoStatus(true);
        }

        if (GrenadeIndex == 0)
        {
            GrenadeIndex = 1;
        }
        else
        {
            GrenadeIndex = 0;
        }
        FireMode[0].ProjectileClass = ProjectileGrenade[GrenadeIndex];
        AmmoClass[0] = GrenadeAmmoClass[GrenadeIndex];
        GrenadeAmmoCharge[GrenadeIndex] = 0;
    }
    else
    {
        Log("SwitchFireMode: Bayonet is NOT attached");
    }
}

simulated function bool UsingAutoFire()
{
    return bBayonetMounted && GrenadeIndex == 1;
}

function ChangeBayoStatus(bool bBayoStatus)
{
    Log("ChangeBayoStatus: " @ bBayoStatus);
    if (bBayoStatus)
    {
        GrenadeIndex = 0;
        FireMode[0] = FireModeBayonet;
        AmmoClass[0] = GrenadeAmmoClass[GrenadeIndex];
        bMustFireWhileSighted = false;
        bHasSelectFire = true;
        GrenadeAmmoCharge[GrenadeIndex] = 0;
    }
    else
    {
        FireMode[0] = FireModeGarand;
        AmmoClass[0] = FireModeGarand.AmmoClass;
        bMustFireWhileSighted = false;
        bHasSelectFire = false;
    }
    AmmoCharge[0] = 0;
    // AmmoCharge[1] = 0;

    super.ChangeBayoStatus(bBayoStatus);
}

defaultproperties
{
    ItemName="M7 Grenade Launcher"
    FireModeClass(0)=class'DH_Weapons.DH_M1GarandFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1GarandMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1GarandGrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_M1GarandGrenadePickup'

    ProjectileGrenade(0)=class'DH_Weapons.DH_M1GarandGrenadeRocket'
    ProjectileGrenade(1)=class'DH_Weapons.DH_M1GarandGrenadeSmokeRocket'
    GrenadeAmmoClass(0)=class'DH_Weapons.DH_M1GarandGrenadeAmmoFrag'
    GrenadeAmmoClass(1)=class'DH_Weapons.DH_M1GarandGrenadeAmmoSmoke'
    Mesh=SkeletalMesh'DH_Garand_1st.Garand_1st'
    bUseHighDetailOverlayIndex=false
    //HighDetailOverlayIndex=2

    Skins(1)=Texture'DH_Weapon_tex.AlliedSmallArms.M1Garand'
    Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.M1Garand_extra'
    HandNum=0
    SleeveNum=3

    IronSightDisplayFOV=55.0
    DisplayFOV=85.0
    FreeAimRotationSpeed=7.5

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11
    bPlusOneLoading=false
    bHasSelectFire=false

    MagEmptyReloadAnims(0)="reload"
    MagEmptyReloadAnims(1)="reload_sticky"
    MagEmptyReloadAnims(2)="reloadB"
    MagEmptyReloadAnims(3)="reload"
    MagEmptyReloadAnims(4)="reload"
    MagPartialReloadAnims(0)="reload_half_A"

    bHasBayonet=true
    // bMustFireWhileSighted=true
    BayonetBoneName="Muzzle_Slave"

    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    BayoAttachEmptyAnim="bayonet_on_empty"
    BayoDetachEmptyAnim="bayonet_off_empty"

    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="iron_in_empty"
    IronPutDownEmpty="iron_out_empty"
    SprintStartEmptyAnim="sprint_start_empty"
    SprintLoopEmptyAnim="sprint_middle_empty"
    SprintEndEmptyAnim="sprint_end_empty"

    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"

    SelectEmptyAnim="draw_empty"
    PutDownEmptyAnim="put_away_empty"

    UnloadedMunitionsPolicy=UMP_Consolidate
}
