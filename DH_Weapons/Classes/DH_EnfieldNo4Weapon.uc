//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_EnfieldNo4Weapon extends DH_BoltActionWeapon;

#exec OBJ LOAD FILE=..\DarkestHour\Animations\DH_EnfieldNo4_1st.ukx

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && Instigator.Controller != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(5, true);
    }
}

simulated function bool AllowReload()
{
    if (IsFiring() || IsBusy() || CurrentMagCount < 1 || AmmoAmount(0) > 5)
    {
        return false;
    }

    return true;
}

// Overridden to handle special No.4 magazine functionality
simulated function PlayReload()
{
    local name Anim;
    local float AnimTimer;

    if (AmmoAmount(0) > 0 || CurrentMagCount < 2)
    {
        Anim = MagPartialReloadAnim;
    }
    else
    {
        Anim = MagEmptyReloadAnim;
    }

    AnimTimer = GetAnimDuration(Anim, 1.0) + FastTweenTime;

    if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
    {
        SetTimer(AnimTimer - (AnimTimer * 0.1), false);
    }
    else
    {
        SetTimer(AnimTimer, false);
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.0, FastTweenTime);
    }
}

// Overridden to handle special No.4 magazine functionality
function PerformReload()
{
    local int CurrentMagLoad;

    CurrentMagLoad = AmmoAmount(0);

    if (PrimaryAmmoArray.Length == 0)
    {
        return;
    }

    if (CurrentMagLoad > 0)
    {
        PrimaryAmmoArray.Remove(CurrentMagIndex, 1);

        if (PrimaryAmmoArray.Length == 0)
        {
            return;
        }

        CurrentMagIndex++;

        if (CurrentMagIndex > PrimaryAmmoArray.Length - 1)
        {
            CurrentMagIndex = 0;
        }

        AddAmmo(PrimaryAmmoArray[CurrentMagIndex], 0);
    }
    else
    {
        PrimaryAmmoArray.Remove(CurrentMagIndex, 1);

        if (PrimaryAmmoArray.Length == 0)
        {
            return;
        }

        CurrentMagIndex++;

        if (CurrentMagIndex > PrimaryAmmoArray.Length - 1)
        {
            CurrentMagIndex = 0;
        }

        AddAmmo(PrimaryAmmoArray[CurrentMagIndex], 0);

        if (PrimaryAmmoArray.Length > 1)
        {
            PrimaryAmmoArray.Remove(CurrentMagIndex, 1);

            CurrentMagIndex++;

            if (CurrentMagIndex > PrimaryAmmoArray.Length - 1)
            {
                CurrentMagIndex = 0;
            }

            AddAmmo(PrimaryAmmoArray[CurrentMagIndex], 0);
        }
    }

    if (Instigator.IsHumanControlled())
    {
        if (AmmoStatus(0) > 0.5)
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 0);
        }
        else if (AmmoStatus(0) > 0.2)
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 1);
        }
        else
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 2);
        }
    }

    if (AmmoAmount(0) > 0)
    {
        if (DHWeaponAttachment(ThirdPersonActor) != none)
        {
            DHWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
        }
    }

    PrimaryAmmoArray[CurrentMagIndex] = AmmoAmount(0);

    ClientForceAmmoUpdate(0, AmmoAmount(0));

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
}

// Overridden to handle special No.4 magazine functionality
function bool FillAmmo()
{
    local int InitialAmount, i;

    if (PrimaryAmmoArray.Length == MaxNumPrimaryMags)
    {
        return false;
    }

    InitialAmount = FireMode[0].AmmoClass.default.InitialAmount;

    PrimaryAmmoArray.Length = MaxNumPrimaryMags;

    for (i = 0; i < PrimaryAmmoArray.Length; ++i)
    {
        PrimaryAmmoArray[i] = InitialAmount;
    }

    CurrentMagIndex = 0;
    CurrentMagCount = PrimaryAmmoArray.Length - 1;

    // HACK: Because the G41 uses two mags, the initial amount needs to be two mags
    PrimaryAmmoArray[CurrentMagIndex] = 10;
    AddAmmo(InitialAmount * 2, 0);

    return true;
}

// Overridden to handle special No.4 magazine functionality
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
}

defaultproperties
{
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    BayonetBoneName="bayonet"
    bHasBayonet=true
    BoltHipAnim="bolt"
    BoltIronAnim="iron_bolt"
    PostFireIronIdleAnim="Iron_idlerest"
    PostFireIdleAnim="Idle"
    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=20.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FreeAimRotationSpeed=7.5
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4Fire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_EnfieldNo4Pickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4Attachment'
    ItemName="Lee Enfield No.4 Rifle"
    Mesh=SkeletalMesh'DH_EnfieldNo4_1st.EnfieldNo4'
}
