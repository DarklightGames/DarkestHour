//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_RocketWeapon extends DH_SemiAutoWeapon;

var()   int         Ranges[3];              // The angle to launch the projectile at different ranges
var     int         RangeIndex;                         // Current range setting
var     name        IronIdleAnimOne;                // Iron idle animation for range setting one
var     name        IronIdleAnimTwo;                    // Iron idle animation for range setting two
var     name        IronIdleAnimThree;                  // Iron idle animation for range setting three
var     name        AssistedMagEmptyReloadAnim;     // 1st person animation for assisted empty reload
var     name        AssistedMagPartialReloadAnim;      // 1st person animation for assisted partial reload
var     int         NumMagsToResupply;          // Number of ammo mags to add when this weapon has been resupplied
var     class<LocalMessage>     WarningMessageClass;

replication
{
    reliable if (Role<ROLE_Authority)
        ServerSetRange;

    reliable if (Role==ROLE_Authority)
        ClientDoAssistedReload;
}

// Overridden to counteract mappers giving out more ammo than the weapon code can handle
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (PrimaryAmmoArray.Length > MaxNumPrimaryMags)
        PrimaryAmmoArray.Remove(MaxNumPrimaryMags, (PrimaryAmmoArray.Length - MaxNumPrimaryMags));
}

// Overridden to support cycling the rocket aiming ranges
simulated exec function Deploy()
{
    if (IsBusy() || !bUsingSights)
        return;

    CycleRange();
}

// switch the rocket aiming ranges
simulated function CycleRange()
{
    if (RangeIndex < 2)
    {
        RangeIndex++;
    }
    else
    {
        RangeIndex=0;
    }

    DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];

    if (Instigator.IsLocallyControlled())
    {
        PlayIdle();
    }

    if (Role < ROLE_Authority)
        ServerSetRange(RangeIndex);
}

// Switch the rocket aiming ranges on the server
function ServerSetRange(int NewIndex)
{
    RangeIndex=NewIndex;

    DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];
}

// Ovveriden to play the rocket animations for different ranges
simulated function PlayIdle()
{
    local name Anim;

    if (bUsingSights)
    {
        switch(RangeIndex)
        {
            case 0:
                Anim = IronIdleAnimOne;
                break;
            case 1:
                Anim = IronIdleAnimTwo;
                break;
            case 2:
                Anim = IronIdleAnimThree;
                break;
        }

        LoopAnim(Anim, IdleAnimRate, 0.2);
    }
    else
    {
        LoopAnim(IdleAnim, IdleAnimRate, 0.2);
    }
}

// Overriden to support projectile weapon specific functionality
// Overriden so that when raised, the weapon has no rocket, thus requiring resupply - this prevents player from loading weapon before going into action
simulated state RaisingWeapon
{
    simulated function BeginState()
    {
        local int Mode;
        local name Anim;

        if (PrimaryAmmoArray.Length > 1) // This prevents rocket being lost on vehicle exit and when spawning with no other weapons
            AmmoCharge[0] = 0;

        // If we have quickly raised our sights right after putting the weapon away,
        // take us out of ironsight mode
        if (bUsingSights)
            ZoomOut(false);

        // Reset any zoom values
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
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
            Anim = SelectAnim;
        }

        if (ClientState == WS_Hidden)
        {
            PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
            ClientPlayForceFeedback(SelectForce);  // jdf

            if (Instigator.IsLocallyControlled())
            {
                // determines if bayonet capable weapon should come up with bayonet on or off
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

                if ((Mesh!=none) && HasAnim(Anim))
                    PlayAnim(Anim, SelectAnimRate, 0.0);
            }

            ClientState = WS_BringUp;
        }

        SetTimer(GetAnimDuration(Anim, SelectAnimRate),false);

        for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
        {
            FireMode[Mode].bIsFiring = false;
            FireMode[Mode].HoldTime = 0.0;
            FireMode[Mode].bServerDelayStartFire = false;
            FireMode[Mode].bServerDelayStopFire = false;
            FireMode[Mode].bInstantStop = false;
        }
    }
}

// Overriden to support empty put away anims
// Overridden to add a rocket back into a player's inventory instead of making
// it disappear
simulated state LoweringWeapon
{
    simulated function BeginState()
    {
        local int Mode, InitialAmount;
        local name Anim;

        super.BeginState();

        InitialAmount = FireMode[0].AmmoClass.Default.InitialAmount;

        if (AmmoAmount(0) > 0 && CurrentMagCount < InitialNumPrimaryMags - 1)
        {
            PrimaryAmmoArray.Insert(CurrentMagIndex, 1);
            PrimaryAmmoArray[CurrentMagIndex] = InitialAmount;
            CurrentMagCount++;

            if (Instigator.IsLocallyControlled())
                PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'DHATLoadMessage',2);
        }

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
            if (Instigator.IsLocallyControlled())
            {
                for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
                {
                    if (FireMode[Mode].bIsFiring)
                        ClientStopFire(Mode);
                }

                if (ClientState == WS_BringUp)
                    TweenAnim(SelectAnim,PutDownTime);
                else if (HasAnim(Anim))
                    PlayAnim(Anim, PutDownAnimRate, 0.0);
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(Anim, PutDownAnimRate),false);

        for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
        {
            FireMode[Mode].bServerDelayStartFire = false;
            FireMode[Mode].bServerDelayStopFire = false;
        }
    }
}

function UpdateResupplyStatus()
{
    if (CurrentMagCount > 0 && AmmoAmount(0) <= 0)
    {
        ROPawn(Instigator).bWeaponNeedsResupply = false;
        DH_Pawn(Instigator).bWeaponNeedsReload = true;
    }
    else if (CurrentMagCount < MaxNumPrimaryMags - 1)
    {
        ROPawn(Instigator).bWeaponNeedsResupply = true;
        DH_Pawn(Instigator).bWeaponNeedsReload = false;
    }
    else
    {
        ROPawn(Instigator).bWeaponNeedsResupply = false;
        DH_Pawn(Instigator).bWeaponNeedsReload = false;
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Role == ROLE_Authority)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = true;
        DH_Pawn(Instigator).bWeaponCanBeReloaded = true;

        UpdateResupplyStatus();
    }
}

simulated function bool PutDown()
{
    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;
    DH_Pawn(Instigator).bWeaponCanBeReloaded = false;
    DH_Pawn(Instigator).bWeaponNeedsReload = false;

    return super.PutDown();
}

simulated function Fire(float F)
{
    if (Instigator.bIsCrawling)
    {
        WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 0);

        return;
    }
    else if (bUsingSights)
    {
        DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];

        if (Role < ROLE_Authority)
        {
            ServerSetRange(RangeIndex);
        }
    }
    else
    {
        WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 2);

        return;
    }

    super.Fire(F);
}

simulated function PostFire()
{
    super.PostFire();

    if (Role == ROLE_Authority)
    {
        UpdateResupplyStatus();
    }
}

// Don't autoswitch when we run out of ammo
simulated function OutOfAmmo()
{
    if (!HasAmmo())
    {
        if (DHWeaponAttachment(ThirdPersonActor) != none)
        {
            DHWeaponAttachment(ThirdPersonActor).bOutOfAmmo = true;
        }
    }

    if (!Instigator.IsLocallyControlled() || HasAmmo())
    {
        return;
    }
}

// Overridden to prevent reloading unless weapon is empty and player is not proned
simulated function bool AllowReload()
{
    if (Instigator.bIsCrawling)
    {
        PlayerController(Instigator.Controller).ReceiveLocalizedMessage(WarningMessageClass, 4);

        return false;
    }

    if (AmmoAmount(0) > 0)
    {
        return false;
    }

    return super.AllowReload();
}

simulated state Reloading
{
    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }

    // Sometimes the client will get switched out of ironsight mode before getting to
    // the reload function. This should catch that.
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
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

    DH_Pawn(Instigator).bWeaponNeedsReload = false;
}

simulated function ClientDoAssistedReload(optional int NumRounds)
{
    GotoState('AssistedReloading');
}

simulated state AssistedReloading extends Reloading
{
    simulated function BeginState()
    {
        if (Role == ROLE_Authority)
        {
            DH_Pawn(Instigator).HandleAssistedReload();
        }

        PlayAssistedReload();
    }

// Overridden to avoid taking player out of sights
Begin:
    if (bUsingSights)
    {
    }
    DH_Pawn(Instigator).bWeaponNeedsReload = false;
}

// Function to play assisted reload animations instead of standard ones
simulated function PlayAssistedReload()
{
    local name Anim;
    local float AnimTimer;

    if (AmmoAmount(0) > 0)
    {
        Anim = AssistedMagPartialReloadAnim;
    }
    else
    {
        Anim = AssistedMagEmptyReloadAnim;
    }

    AnimTimer = GetAnimDuration(Anim, 1.0) + FastTweenTime;

    if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
    {
        SetTimer(AnimTimer - (AnimTimer * 0.1), false);
    }
    else
    {
        SetTimer(AnimTimer,false);
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.0, FastTweenTime);
    }
}

// Overwritten to play rocket reload message
function PerformReload()
{
    local int CurrentMagLoad;
    local bool bDidPlusOneReload;

    CurrentMagLoad = AmmoAmount(0);

    if (PrimaryAmmoArray.Length == 0)
    {
        return;
    }

    if (CurrentMagLoad <= 0)
    {
        PrimaryAmmoArray.Remove(CurrentMagIndex, 1);
    }
    else
    {
        if (bPlusOneLoading)
        {
            //If there's only one bullet left (the one in the chamber), discard the clip
            if (CurrentMagLoad == 1)
            {
                PrimaryAmmoArray.Remove(CurrentMagIndex, 1);
            }
            else
            {
                PrimaryAmmoArray[CurrentMagIndex] = CurrentMagLoad - 1;
            }

            AmmoCharge[0] = 1;
            bDidPlusOneReload = true;
        }
        else
        {
            PrimaryAmmoArray[CurrentMagIndex] = CurrentMagLoad;
            AmmoCharge[0] = 0;
        }
    }

    if (PrimaryAmmoArray.Length == 0)
    {
        return;
    }

    CurrentMagIndex++;

    if (CurrentMagIndex > PrimaryAmmoArray.Length - 1)
    {
        CurrentMagIndex = 0;
    }

    if (bDidPlusOneReload)
    {
        AddAmmo(PrimaryAmmoArray[CurrentMagIndex] + 1, 0);
    }
    else
    {
        AddAmmo(PrimaryAmmoArray[CurrentMagIndex], 0);
    }

    AddAmmo(PrimaryAmmoArray[CurrentMagIndex], 0);

    if (AmmoAmount(0) > 0)
    {
        if (DHWeaponAttachment(ThirdPersonActor) != none)
        {
            DHWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
        }
    }

    ClientForceAmmoUpdate(0, AmmoAmount(0));

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
}

simulated state PendingAction
{
Begin:
    if (bUsingSights)
    {
    }
}

// Overridden to set resupply variables and to stop already loaded rockets being lost on weapon pickup
function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local int InitialAmount;
    local bool bJustSpawned;

    InitialAmount = FireMode[0].AmmoClass.Default.InitialAmount;

    super.GiveTo(Other,Pickup);

    if (CurrentMagCount > 0)
    {
        bJustSpawned = true;
        AmmoCharge[0] = 0;
    }

    if (HasAmmo() && !bJustSpawned)
    {
        AmmoCharge[0] = 0;
        PrimaryAmmoArray.Insert(CurrentMagIndex, 1);
        PrimaryAmmoArray[CurrentMagIndex] = InitialAmount;
        CurrentMagCount = 1;
    }
}

function DropFrom(vector StartLocation)
{
    if (!bCanThrow)
        return;

    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;
    DH_Pawn(Instigator).bWeaponCanBeReloaded = false;
    DH_Pawn(Instigator).bWeaponNeedsReload = false;

    super.DropFrom(StartLocation);
}

simulated function Destroyed()
{
    if (Role == ROLE_Authority && Instigator!= none && ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = false;
        ROPawn(Instigator).bWeaponNeedsResupply = false;
        DH_Pawn(Instigator).bWeaponCanBeReloaded = false;
        DH_Pawn(Instigator).bWeaponNeedsReload = false;
    }

    super.Destroyed();
}

// Overridden to prevent picking up more than the intended max ammo count
// MaxNumMags is actually set 1 higher than intended max, to facilitate unusual resupply/fillammo
function bool HandlePickupQuery(pickup Item)
{
//    local WeaponPickup wpu;
    local int i, j;
    local bool bAddedMags;

    if (bNoAmmoInstances)
    {
        // handle ammo pickups
        for (i = 0; i < 2; i++)
        {
            if (item.inventorytype == AmmoClass[i] && AmmoClass[i] != none)
            {
                if ((AmmoAmount(0) <= 0 && PrimaryAmmoArray.Length < MaxNumPrimaryMags) || PrimaryAmmoArray.Length < MaxNumPrimaryMags - 1)
                {
                    // Handle multi mag ammo type pickups
                    if (ROMultiMagAmmoPickup(Item) != none)
                    {
                        for(j = 0; j < ROMultiMagAmmoPickup(Item).AmmoMags.Length; j++)
                        {
                            if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
                            {
                                PrimaryAmmoArray[PrimaryAmmoArray.Length] = ROMultiMagAmmoPickup(Item).AmmoMags[j];

                                bAddedMags = true;
                            }
                            else
                            {
                                break;
                            }
                        }
                    }
                    // Handle standard/old style ammo pickups
                    else
                    {
                        PrimaryAmmoArray[PrimaryAmmoArray.Length] = Min(MaxAmmo(i), Ammo(item).AmmoAmount);

                        bAddedMags = true;
                    }
                }
                else
                {
                    return true;
                }

                // if we added mags, update the mag count and force a net update
                if (bAddedMags)
                {
                    CurrentMagCount = PrimaryAmmoArray.Length - 1;
                    NetUpdateTime = Level.TimeSeconds - 1;
                }

                item.AnnouncePickup(Pawn(Owner));
                item.SetRespawn();

                UpdateResupplyStatus();

                return true;
            }
        }
    }

    // Drop current weapon and pickup the one on the ground
    if (Instigator.Weapon != none &&
        Instigator.Weapon.InventoryGroup == InventoryGroup &&
        Item.InventoryType.default.InventoryGroup == InventoryGroup &&
        Instigator.CanThrowWeapon())
    {
        ROPlayer(Instigator.Controller).ThrowWeapon();

        return false;
    }

    // Avoid multiple weapons in the same slot
    if (Item.InventoryType.default.InventoryGroup == InventoryGroup)
    {
        return true;
    }

    if (Inventory == none)
    {
        return false;
    }

    return Inventory.HandlePickupQuery(Item);
}

function bool AssistedReload()
{
    local bool bReloadAllowed;

    if (bUsingSights && AmmoAmount(0) == 0 && CurrentMagCount > 0) //&& (instigator.bIsCrouched || instigator.bRestingWeapon)
        bReloadAllowed = true;

    if (bReloadAllowed)
    {
        NetUpdateTime = Level.TimeSeconds - 1;

        GotoState('AssistedReloading');
        ClientDoAssistedReload();

        return true;
    }
    else
    {
        PlayerController(Instigator.Controller).ReceiveLocalizedMessage(WarningMessageClass, 3);

        return false;
    }
}


// This rocket has been resupplied by another player
function bool ResupplyAmmo()
{
    local int InitialAmount, i;

    InitialAmount = FireMode[0].AmmoClass.default.InitialAmount;

    if (CurrentMagCount < MaxNumPrimaryMags - 1 && AmmoAmount(0) == 0)
    {
        for(i = NumMagsToResupply; i > 0; i--)
        {
            if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
            {
                PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
            }
        }

        CurrentMagCount = PrimaryAmmoArray.Length - 1;
        NetUpdateTime = Level.TimeSeconds - 1;
        ROPawn(Instigator).bWeaponNeedsResupply = false;
        DH_Pawn(Instigator).bWeaponNeedsReload = true;

        AssistedReload();

        return true;
    }
    else
    {
        return false;
    }
}

function bool IsATWeapon()
{
    return true;
}

//**************************************************************************************************************************

defaultproperties
{
     IronIdleAnimOne="Iron_idle"
     IronIdleAnimTwo="iron_idleMid"
     IronIdleAnimThree="iron_idleFar"
     AssistedMagEmptyReloadAnim="reloadA"
     AssistedMagPartialReloadAnim="reloadA"
     NumMagsToResupply=1
     MagEmptyReloadAnim="Reloads"
     MagPartialReloadAnim="Reloads"
     IronBringUp="iron_in"
     IronPutDown="iron_out"
     MaxNumPrimaryMags=3
     InitialNumPrimaryMags=3
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=25.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     FreeAimRotationSpeed=7.500000
     SelectAnim="Draw"
     PutDownAnim="putaway"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.600000
     CurrentRating=0.600000
     bSniping=true
     DisplayFOV=70.000000
     Priority=8
     bCanRestDeploy=true
     InventoryGroup=5
     BobDamping=1.600000
     FillAmmoMagCount=1
}
