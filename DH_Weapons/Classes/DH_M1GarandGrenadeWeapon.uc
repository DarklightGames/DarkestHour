//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1GarandGrenadeWeapon extends DHProjectileWeapon;

var     bool    bIsLastRound;
var   WeaponFire   FireModeGarand;
var   WeaponFire   FireModeBayonet;

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

     if (bBayonetMounted)
    {
        ChangeBayoStatus(true);
    }
}

function PerformReload(optional int Count)
{
    if (bBayonetMounted)
    {
        AmmoCharge[0] = 1;

        if (AmmoAmount(0) > 0 && ROWeaponAttachment(ThirdPersonActor) != none)
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
        return 1;
    }
    else
    {
		return FireModeGarand.AmmoClass.Default.MaxAmmo;
    }
}

// simulated function int AmmoAmount(int mode)
// {
//     if (bBayonetMounted)
//     {
//         return AmmoCharge[0];
//     }
//     else
//     {
//         return super.AmmoAmount(0);
//     }

// 	return 0;
// }

function bool AddAmmo(int AmmoToAdd, int Mode)
{
    if (bBayonetMounted)
    {
        if (AmmoCharge[0] < MaxAmmo(0))
        {
            AmmoCharge[0] = Min(MaxAmmo(0), AmmoCharge[0] + AmmoToAdd);
            return true;
        }
        return false;
    }
    else
    {
        return super.AddAmmo(AmmoToAdd, 0);
    }
}

// simulated function bool HasAmmo()
// {
//     if (bBayonetMounted)
//     {
//         return AmmoCharge[1] > 0;
//     }
//     else
//     {
//         return super.HasAmmo();
//     }
// }

function ChangeBayoStatus(bool bBayoStatus)
{
    Log("ChangeBayoStatus: " @ bBayoStatus);
    if (bBayoStatus)
    {
        FireMode[0] = FireModeBayonet;
        AmmoClass[0] = FireModeBayonet.AmmoClass;
        bMustFireWhileSighted = true;
    }
    else
    {
        FireMode[0] = FireModeGarand;
        AmmoClass[0] = FireModeGarand.AmmoClass;
        bMustFireWhileSighted = false;
    }
    AmmoCharge[0] = 0;
    // AmmoCharge[1] = 0;

    super.ChangeBayoStatus(bBayoStatus);
}

defaultproperties
{
    ItemName="M1 Garand Grenade Launcher"
    FireModeClass(0)=class'DH_Weapons.DH_M1GarandFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1GarandMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1GarandGrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_M1GarandGrenadePickup'

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
