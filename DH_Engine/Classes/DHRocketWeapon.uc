//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHRocketWeapon extends DHSemiAutoWeapon
    abstract;

var     array<int>              Ranges;                         // The angle to launch the projectile at different ranges
var     int                     RangeIndex;                     // Current range setting
var     array<name>             IronIdleAnims;                  // Iron idle animation for different range settings
var     name                    AssistedMagEmptyReloadAnim;     // 1st person animation for assisted empty reload
var     name                    AssistedMagPartialReloadAnim;   // 1st person animation for assisted partial reload
var     int                     NumMagsToResupply;              // Number of ammo mags to add when this weapon has been resupplied
var     class<LocalMessage>     WarningMessageClass;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetRange;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientDoAssistedReload;
}

// Overridden to counteract mappers giving out more ammo than the weapon code can handle
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (PrimaryAmmoArray.Length > MaxNumPrimaryMags)
    {
        PrimaryAmmoArray.Remove(MaxNumPrimaryMags, (PrimaryAmmoArray.Length - MaxNumPrimaryMags));
    }
}

// Overridden to support cycling the rocket aiming ranges
simulated exec function Deploy()
{
    if (IsBusy() || !bUsingSights)
    {
        return;
    }

    CycleRange();
}

// switch the rocket aiming ranges
simulated function CycleRange()
{
    local DHProjectileFire F;

    RangeIndex = ++RangeIndex % Ranges.Length;

    F = DHProjectileFire(FireMode[0]);

    if (F != none)
    {
        F.AddedPitch = Ranges[RangeIndex];
    }

    if (Instigator != none && Instigator.IsLocallyControlled())
    {
        PlayIdle();
    }

    if (Role < ROLE_Authority)
    {
        ServerSetRange(RangeIndex);
    }
}

// Switch the rocket aiming ranges on the server
function ServerSetRange(int NewIndex)
{
    local DHProjectileFire F;

    RangeIndex = NewIndex;

    F = DHProjectileFire(FireMode[0]);

    if (F != none)
    {
        F.AddedPitch = Ranges[RangeIndex];
    }
}

//==============================================================================
// Overiden to play the rocket animations for different ranges
//==============================================================================
simulated function PlayIdle()
{
    if (bUsingSights)
    {
        LoopAnim(IronIdleAnims[RangeIndex], IdleAnimRate, 0.2);
    }
    else
    {
        LoopAnim(IdleAnim, IdleAnimRate, 0.2);
    }
}

//==============================================================================
// Overriden to support projectile weapon specific functionality
// Overriden so that when raised, the weapon has no rocket, thus requiring
// resupply - this prevents player from loading weapon before going into action
//==============================================================================
simulated state RaisingWeapon
{
    simulated function BeginState()
    {
        local int i;
        local name Anim;

        if (PrimaryAmmoArray.Length > 1)
        {
            // This prevents rocket being lost on vehicle exit and when spawning
            // with no other weapons
            AmmoCharge[0] = 0;
        }

        // If we have quickly raised our sights right after putting the weapon
        // away, take us out of ironsight mode
        if (bUsingSights)
        {
            ZoomOut(false);
        }

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


            if (Instigator.IsLocallyControlled())
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

                if (Mesh != none && HasAnim(Anim))
                {
                    PlayAnim(Anim, SelectAnimRate, 0.0);
                }
            }

            ClientState = WS_BringUp;
        }

        SetTimer(GetAnimDuration(Anim, SelectAnimRate), false);

        for (i = 0; i < arraycount(FireMode); ++i)
        {
            FireMode[i].bIsFiring = false;
            FireMode[i].HoldTime = 0.0;
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
            FireMode[i].bInstantStop = false;
        }
    }
}

//==============================================================================
// Overriden to support empty put away anims
// Overridden to add a rocket back into a player's inventory instead of making
// it disappear
//==============================================================================
simulated state LoweringWeapon
{
    simulated function BeginState()
    {
        local int i;
        local name Anim;

        super.BeginState();

        if (AmmoAmount(0) > 0 && CurrentMagCount < InitialNumPrimaryMags - 1)
        {
            PrimaryAmmoArray.Insert(CurrentMagIndex, 1);
            PrimaryAmmoArray[CurrentMagIndex] = FireMode[0].AmmoClass.default.InitialAmount;

            ++CurrentMagCount;

            if (Instigator.IsLocallyControlled())
            {
                PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'DHATLoadMessage', 2);
            }
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
                for (i = 0; i < arraycount(FireMode); ++i)
                {
                    if (FireMode[i].bIsFiring)
                    {
                        ClientStopFire(i);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    TweenAnim(SelectAnim, PutDownTime);
                }
                else if (HasAnim(Anim))
                {
                    PlayAnim(Anim, PutDownAnimRate, 0.0);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(Anim, PutDownAnimRate), false);

        for (i = 0; i < arraycount(FireMode); ++i)
        {
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
        }
    }
}

function UpdateResupplyStatus()
{
    local DHPawn P;
    local bool bIsLoaded;
    local bool bHasAmmo;
    local bool bHasFullAmmo;

    P = DHPawn(Instigator);

    if (P == none || P.Weapon != self)
    {
        return;
    }

    bIsLoaded = AmmoAmount(0) > 0;
    bHasAmmo = CurrentMagCount > 0;
    bHasFullAmmo = CurrentMagCount >= MaxNumPrimaryMags - 1;

    P.bWeaponNeedsReload = bHasAmmo && !bIsLoaded;
    P.bWeaponNeedsResupply = !bHasFullAmmo;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    local DHPawn P;

    super.BringUp(PrevWeapon);

    if (Role == ROLE_Authority)
    {
        P = DHPawn(Instigator);

        if (P != none)
        {
            P.bWeaponCanBeReloaded = true;
            P.bWeaponCanBeResupplied = true;
        }

        UpdateResupplyStatus();
    }
}

simulated function bool PutDown()
{
    local DHPawn P;

    P = DHPawn(Instigator);

    if (P != none)
    {
        P.bWeaponCanBeReloaded = false;
        P.bWeaponCanBeResupplied = false;

        P.bWeaponNeedsReload = false;
        P.bWeaponNeedsResupply = false;
    }

    return super.PutDown();
}

simulated function Fire(float F)
{
    local PlayerController PC;
    local DHProjectileFire PF;

    if (Instigator != none)
    {
        PC = PlayerController(Instigator.Controller);
    }

    if (Instigator != none && Instigator.bIsCrawling)
    {
        // Cannot be prone while firing
        if (PC != none)
        {
            WarningMessageClass.static.ClientReceive(PC, 0,,, self);
        }

        return;
    }

    if (!bUsingSights)
    {
        // Must be sighted to fire
        if (PC != none)
        {
            WarningMessageClass.static.ClientReceive(PC, 2,,, self);
        }

        return;
    }

    PF = DHProjectileFire(FireMode[0]);

    if (PF != none)
    {
        PF.AddedPitch = Ranges[RangeIndex];
    }

    if (Role < ROLE_Authority)
    {
        ServerSetRange(RangeIndex);
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

//==============================================================================
// Don't auto-switch when we run out of ammo
//==============================================================================
simulated function OutOfAmmo()
{
    local DHWeaponAttachment WA;

    WA = DHWeaponAttachment(ThirdPersonActor);

    if (WA != none && !HasAmmo())
    {
        WA.bOutOfAmmo = true;
    }
}

//==============================================================================
// Overridden to prevent reloading if out of ammo or player is prone
//==============================================================================
simulated function bool AllowReload()
{
    local PlayerController PC;

    if (Instigator != none)
    {
        PC = PlayerController(Instigator.Controller);
    }

    if (Instigator != none && Instigator.bIsCrawling)
    {
        if (PC != none)
        {
            PC.ReceiveLocalizedMessage(WarningMessageClass, 4,,, self);
        }

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

        if (Instigator != none && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }

    // Sometimes the client will get switched out of ironsight mode before
    // getting to the reload function. This should catch that.
    if (Instigator != none && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
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

    if (Instigator != none && Instigator.IsA('DHPawn'))
    {
        DHPawn(Instigator).bWeaponNeedsReload = false;
    }
}

simulated function ClientDoAssistedReload(optional int NumRounds)
{
    GotoState('AssistedReloading');
}

simulated state AssistedReloading extends Reloading
{
    simulated function BeginState()
    {
        local DHPawn P;

        if (Role == ROLE_Authority)
        {
            P = DHPawn(Instigator);

            if (P != none)
            {
                P.HandleAssistedReload();
            }
        }

        PlayAssistedReload();
    }

// Overridden to avoid taking player out of sights
Begin:
    DHPawn(Instigator).bWeaponNeedsReload = false;
}

//==============================================================================
// Function to play assisted reload animations instead of standard ones
//==============================================================================
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
        SetTimer(AnimTimer, false);
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.0, FastTweenTime);
    }
}

//==============================================================================
// Overwritten to play rocket reload message
//==============================================================================
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
            // If there's only one bullet left (the one in the chamber), discard the clip
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

    ++CurrentMagIndex;

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

    if (AmmoAmount(0) > 0 && DHWeaponAttachment(ThirdPersonActor) != none)
    {
        DHWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
    }

    ClientForceAmmoUpdate(0, AmmoAmount(0));

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
}

//==============================================================================
// Overridden to set resupply variables and to stop already loaded rockets being
// lost on weapon pickup
//==============================================================================
function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local int InitialAmount;
    local bool bJustSpawned;

    InitialAmount = FireMode[0].AmmoClass.default.InitialAmount;

    super.GiveTo(Other, Pickup);

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
    local DHPawn P;

    if (!bCanThrow)
    {
        return;
    }

    P = DHPawn(Instigator);

    if (P != none)
    {
        P.bWeaponCanBeResupplied = false;
        P.bWeaponNeedsResupply = false;
        P.bWeaponCanBeReloaded = false;
        P.bWeaponNeedsReload = false;
    }

    super.DropFrom(StartLocation);
}

simulated function Destroyed()
{
    local DHPawn P;

    if (Role == ROLE_Authority)
    {
        P = DHPawn(Instigator);

        if (P != none)
        {
            P.bWeaponCanBeResupplied = false;
            P.bWeaponNeedsResupply = false;
            P.bWeaponCanBeReloaded = false;
            P.bWeaponNeedsReload = false;
        }
    }

    super.Destroyed();
}

//==============================================================================
// Overridden to prevent picking up more than the intended max ammo count
// MaxNumMags is actually set 1 higher than intended max, to facilitate unusual
// resupply/fillammo
//==============================================================================
function bool HandlePickupQuery(Pickup Item)
{
    local int i, j;
    local bool bAddedMags;

    if (bNoAmmoInstances)
    {
        // Handle ammo pickups
        for (i = 0; i < arraycount(AmmoClass); ++i)
        {
            if (AmmoClass[i] == none || Item.InventoryType != AmmoClass[i])
            {
                continue;
            }

            if ((AmmoAmount(0) <= 0 && PrimaryAmmoArray.Length < MaxNumPrimaryMags) || PrimaryAmmoArray.Length < MaxNumPrimaryMags - 1)
            {
                // Handle multi mag ammo type pickups
                if (ROMultiMagAmmoPickup(Item) != none)
                {
                    for (j = 0; j < ROMultiMagAmmoPickup(Item).AmmoMags.Length; ++j)
                    {
                        if (PrimaryAmmoArray.Length >= MaxNumPrimaryMags)
                        {
                            break;
                        }

                        PrimaryAmmoArray[PrimaryAmmoArray.Length] = ROMultiMagAmmoPickup(Item).AmmoMags[j];

                        bAddedMags = true;
                    }
                }
                // Handle standard/old style ammo pickups
                else
                {
                    PrimaryAmmoArray[PrimaryAmmoArray.Length] = Min(MaxAmmo(i), Ammo(Item).AmmoAmount);

                    bAddedMags = true;
                }
            }
            else
            {
                return true;
            }

            // If we added mags, update the mag count and force a net update
            if (bAddedMags)
            {
                CurrentMagCount = PrimaryAmmoArray.Length - 1;
                NetUpdateTime = Level.TimeSeconds - 1;
            }

            Item.AnnouncePickup(Pawn(Owner));
            Item.SetRespawn();

            UpdateResupplyStatus();

            return true;
        }
    }

    // Drop current weapon and pickup the one on the ground
    if (Instigator != none &&
        Instigator.Weapon != none &&
        Instigator.Weapon.InventoryGroup == InventoryGroup &&
        Item.InventoryType.default.InventoryGroup == InventoryGroup &&
        Instigator.CanThrowWeapon())
    {
        ROPlayer(Instigator.Controller).ThrowWeapon();

        return false;
    }

    // Avoid multiple weapons in the same slot
    if (Item != none && Item.InventoryType.default.InventoryGroup == InventoryGroup)
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
    local PlayerController PC;

    if (!bUsingSights || AmmoAmount(0) != 0 || CurrentMagCount <= 0)
    {
        if (Instigator != none)
        {
            PC = PlayerController(Instigator.Controller);

            if (PC != none)
            {
                PC.ReceiveLocalizedMessage(WarningMessageClass, 3,,, self);
            }
        }

        return false;
    }

    NetUpdateTime = Level.TimeSeconds - 1;

    GotoState('AssistedReloading');

    ClientDoAssistedReload();

    return true;
}

//==============================================================================
// This rocket has been resupplied by another player
//==============================================================================
function bool ResupplyAmmo()
{
    local int i;
    local DHPawn P;

    if (CurrentMagCount >= MaxNumPrimaryMags - 1 || AmmoAmount(0) != 0)
    {
        return false;
    }

    for (i = 0; i < NumMagsToResupply; ++i)
    {
        if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
        {
            PrimaryAmmoArray[PrimaryAmmoArray.Length] = FireMode[0].AmmoClass.default.InitialAmount;
        }
    }

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
    NetUpdateTime = Level.TimeSeconds - 1;

    P = DHPawn(Instigator);

    if (P != none)
    {
        P.bWeaponNeedsResupply = false;
        P.bWeaponNeedsReload = true;
    }

    AssistedReload();

    return true;
}

function bool FillAmmo()
{
    local bool bDidFillAmmo;

    bDidFillAmmo = super.FillAmmo();

    UpdateResupplyStatus();

    return bDidFillAmmo;
}

defaultproperties
{
    IronIdleAnims(0)="Iron_idle"
    IronIdleAnims(1)="iron_idleMid"
    IronIdleAnims(2)="iron_idleFar"
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
    IronSightDisplayFOV=25.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FreeAimRotationSpeed=7.5
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.6
    CurrentRating=0.6
    bSniping=true
    DisplayFOV=70.0
    Priority=8
    bCanRestDeploy=true
    InventoryGroup=5
    BobDamping=1.6
    FillAmmoMagCount=1
    Ranges(0)=0
    WarningMessageClass=class'DH_Engine.DHRocketWarningMessage'
}
