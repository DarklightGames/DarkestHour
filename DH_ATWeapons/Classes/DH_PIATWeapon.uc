//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PIATWeapon extends DH_ProjectileWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_PIAT_1st.ukx

var()   int     Ranges[3];         // The angle to launch the projectile at different ranges
var     int     RangeIndex;        // Current range setting
var     name    IronIdleAnims[3];  // Iron idle animation for different range settings
var     int     NumMagsToResupply; // Number of ammo mags to add when this weapon has been resupplied

var     class<LocalMessage>     WarningMessageClass;
var     class<ROFPAmmoRound>    RocketAttachmentClass;
var     ROFPAmmoRound           RocketAttachment;      // the attached first person ammo round

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetRange;
}

function bool IsATWeapon()
{
    return true;
}

simulated function bool AllowReload()
{
    // Cannot reload without being prone or rested.
    if (!Instigator.bIsCrawling && !Instigator.bRestingWeapon)
    {
        WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 2);

        return false;
    }

    // Don't allow a reload if bomb already loaded
    if (AmmoAmount(0) > 0)
    {
        return false;
    }

    return super.AllowReload();
}

// Overridden to support cycling the aiming ranges
simulated exec function Deploy()
{
    if (IsBusy() || !bUsingSights)
    {
        return;
    }

    CycleRange();
}

// Switch the aiming ranges
simulated function CycleRange()
{
    if (RangeIndex < 2)
    {
        RangeIndex++;
    }
    else
    {
        RangeIndex = 0;
    }

    DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];

    if (Instigator.IsLocallyControlled())
    {
        PlayIdle();
    }

    if (Role < ROLE_Authority)
    {
        ServerSetRange(RangeIndex);
    }
}

// Switch the aiming ranges on the server
function ServerSetRange(int NewIndex)
{
    RangeIndex = NewIndex;

    if (bUsingSights)
    {
        DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];
    }
    else
    {
        DH_ProjectileFire(FireMode[0]).AddedPitch = 0;
    }
}

// Overridden to play the animations for different ranges // Matt: simplified to use IronIdleAnims array instead of IronIdleAnimOne, IronIdleAnimTwo & IronIdleAnimThree
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

function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local Weapon W;
    local bool   bPossiblySwitch, bJustSpawned;
    local int    m;

    Instigator = Other;

    W = Weapon(Instigator.FindInventoryType(Class));

    if (W == none || W.Class != Class) // added class check because somebody made FindInventoryType() return subclasses for some reason
    {
        bJustSpawned = true;

        super(Inventory).GiveTo(Other);

        bPossiblySwitch = true;
        W = self;
    }
    else if (!W.HasAmmo())
    {
        bPossiblySwitch = true;
    }

    if (Pickup == none)
    {
        bPossiblySwitch = true;
    }

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != none)
        {
            FireMode[m].Instigator = Instigator;

            if (Ammo(Pickup) != none)
            {
                DH_PIATWeapon(W).GiveAmmoPickupAmmo(m, Ammo(Pickup), bJustSpawned);
            }
            else
            {
                W.GiveAmmo(m,WeaponPickup(Pickup), bJustSpawned);
            }
        }
    }

    if (Instigator.Weapon != W)
    {
        W.ClientWeaponSet(bPossiblySwitch);
    }

    if (!bJustSpawned)
    {
        for (m = 0; m < NUM_FIRE_MODES; m++)
        {
            Ammo[m] = none;
        }

        Destroy();
    }

    ROPawn(Instigator).bWeaponCanBeResupplied = true;

    if ((CurrentMagCount <= (MaxNumPrimaryMags - 2) && AmmoAmount(0) <= 0) || CurrentMagCount <= (MaxNumPrimaryMags - 3))
    {
        ROPawn(Instigator).bWeaponNeedsResupply = true;
    }
    else
    {
        ROPawn(Instigator).bWeaponNeedsResupply = false;
    }
}

function DropFrom(vector StartLocation)
{
    if (!bCanThrow)
    {
        return;
    }

    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;

    super.DropFrom(StartLocation);
}

simulated function Destroyed()
{
    if (Role == ROLE_Authority && ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = false;
        ROPawn(Instigator).bWeaponNeedsResupply = false;
    }

    if (RocketAttachment != none)
    {
        RocketAttachment.Destroy();
    }

    super.Destroyed();
}

function GiveAmmoPickupAmmo(int m, Ammo AP, bool bJustSpawned)
{
    local bool bJustSpawnedAmmo;
    local int  AddAmount, InitialAmount, i;

    if (FireMode[m] != none && FireMode[m].AmmoClass != none)
    {
        Ammo[m] = Ammunition(Instigator.FindInventoryType(FireMode[m].AmmoClass));

        bJustSpawnedAmmo = false;

        if (FireMode[m].AmmoClass == none || (m != 0 && FireMode[m].AmmoClass == FireMode[0].AmmoClass))
        {
            return;
        }

        InitialAmount = FireMode[m].AmmoClass.default.InitialAmount;

        if (bJustSpawned && AP == none)
        {
            PrimaryAmmoArray.Length = MaxNumPrimaryMags;

            for (i = 0; i < PrimaryAmmoArray.Length; ++i)
            {
                PrimaryAmmoArray[i] = InitialAmount;
            }

            CurrentMagIndex = 0;
            CurrentMagCount = PrimaryAmmoArray.Length - 1;
        }

        if (AP != none)
        {
            InitialAmount = AP.AmmoAmount;
            PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
        }

        if (Ammo[m] != none)
        {
            Addamount = InitialAmount + Ammo[m].AmmoAmount;
            Ammo[m].Destroy();
        }
        else
        {
            AddAmount = InitialAmount;
        }

        AddAmmo(AddAmount, m);
    }
}

// Get the coords for the muzzle bone - used for free-aim projectile spawning
function coords GetMuzzleCoords()
{
    // have to update the location of the weapon before getting the coords
    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    return GetBoneCoords('Warhead');
}

// SelfDestroy(RO) - This is run server-side, it will destroy a weapon in a player's inventory without spawning a pickup
function SelfDestroy()
{
    local int m;

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m].bIsFiring)
        {
            StopFire(m);
        }
    }

    if (Instigator != none)
    {
        DetachFromPawn(Instigator);
    }

    ClientWeaponThrown();
    Destroy();
}

function float GetAIRating()
{
    local Bot   B;
    local float ZDiff, Dist, Result;

    B = Bot(Instigator.Controller);

    if (B == none || B.Enemy == none)
    {
        return AIRating;
    }

    if (Vehicle(B.Enemy) == none)
    {
        return 0.0;
    }

    Result = AIRating;
    ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;

    if (ZDiff > -300.0)
    {
        Result += 0.2;
    }

    Dist = VSize(B.Enemy.Location - Instigator.Location);

    if (Dist > 400.0 && Dist < 6000.0)
    {
        return FMin(2.0, Result + (6000.0 - Dist) * 0.0001);
    }

    return Result;
}

simulated function Fire(float F)
{
    if (!bUsingSights)
    {
        WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 0);

        return;
    }

    if (bUsingSights)
    {
        if (!Instigator.bIsCrawling && !Instigator.bRestingWeapon)
        {
            WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 1);

            return;
        }

        DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];

        if (Role < ROLE_Authority)
        {
            ServerSetRange(RangeIndex);
        }
    }
    else
    {
        DH_ProjectileFire(FireMode[0]).AddedPitch = 0;

        if (Role < ROLE_Authority)
        {
            ServerSetRange(RangeIndex);
        }
    }

    super.Fire(F);
}

simulated function PostBeginPlay()
{
    local vector RocketLoc;

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        RocketLoc = GetBoneCoords('Warhead').Origin;
        RocketAttachment = Spawn(RocketAttachmentClass, self, , RocketLoc);
        AttachToBone(RocketAttachment, 'Warhead');
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    local vector RocketLoc;

    HandleSleeveSwapping();

    if (ROPlayer(Instigator.Controller) != none)
    {
        ROPlayer(Instigator.Controller).FAAWeaponRotationFactor = FreeAimRotationSpeed;
    }

    GotoState('RaisingWeapon');

    if (PrevWeapon != none && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch)
    {
        OldWeapon = PrevWeapon;
    }
    else
    {
        OldWeapon = none;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (AmmoAmount(0) < 1)
        {
            if (RocketAttachment != none)
            {
                RocketAttachment.Destroy();
            }
        }
        else
        {
            if (RocketAttachment == none)
            {
                RocketLoc = GetBoneCoords('Warhead').Origin;
                RocketAttachment = Spawn(RocketAttachmentClass, self, , RocketLoc);
                AttachToBone(RocketAttachment, 'Warhead');
            }
        }
    }

    if (Role == ROLE_Authority)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = true;

        if ((CurrentMagCount <= (MaxNumPrimaryMags - 2) && AmmoAmount(0) <= 0) || CurrentMagCount <= (MaxNumPrimaryMags - 3))
        {
            ROPawn(Instigator).bWeaponNeedsResupply = true;
        }
        else
        {
            ROPawn(Instigator).bWeaponNeedsResupply = false;
        }
    }
}

simulated function bool PutDown()
{
    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;

    return super.PutDown();
}

simulated function SpawnBomb()
{
    local vector ProjectileLocation;

    if (Level.NetMode != NM_DedicatedServer)
    {
       ProjectileLocation = GetBoneCoords('Warhead').Origin;
       RocketAttachment = Spawn(RocketAttachmentClass, self, , ProjectileLocation);
       AttachToBone(RocketAttachment, 'Warhead');
    }
}

// Overridden to prevent picking up more than the intended max ammo count
// MaxNumMags is actually set 1 higher than intended max, to facilitate unusual resupply/fillammo
function bool HandlePickupQuery(Pickup Item)
{
    local int  i, j;
    local bool bAddedMags;

    if (bNoAmmoInstances)
    {
        // Handle ammo pickups
        for (i = 0; i < 2; ++i)
        {
            if (Item.Inventorytype == AmmoClass[i] && AmmoClass[i] != none)
            {
                if ((AmmoAmount(0) <= 0 && PrimaryAmmoArray.Length < MaxNumPrimaryMags) || PrimaryAmmoArray.Length < MaxNumPrimaryMags - 1)
                {
                    // Handle multi mag ammo type pickups
                    if (ROMultiMagAmmoPickup(Item) != none)
                    {
                        for (j = 0; j < ROMultiMagAmmoPickup(Item).AmmoMags.Length; ++j)
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

                return true;
            }
        }
    }

    // Drop current weapon and pickup the one on the ground
    if (Instigator.Weapon != none && Instigator.Weapon.InventoryGroup == InventoryGroup && Item.InventoryType.default.InventoryGroup == InventoryGroup && Instigator.CanThrowWeapon())
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

// This PIAT has been resupplied by another player
function bool ResupplyAmmo()
{
    local int  InitialAmount, i;
    local bool bIsLoaded;

    if (AmmoAmount(0) > 0)
    {
        bIsLoaded = true;
    }

    InitialAmount = FireMode[0].AmmoClass.default.InitialAmount;

    for (i = NumMagsToResupply; i > 0; i--)
    {
        if (!bIsLoaded && PrimaryAmmoArray.Length < MaxNumPrimaryMags)
        {
            PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
        }
        else if (PrimaryAmmoArray.Length < MaxNumPrimaryMags - 1)
        {
            PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
        }
    }

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
    NetUpdateTime = Level.TimeSeconds - 1;

    return true;
}

function bool bIsATWeapon()
{
    return true;
}

defaultproperties
{
    Ranges(0)=85
    Ranges(1)=325
    Ranges(2)=500
    IronIdleAnims(0)="Iron_idle"
    IronIdleAnims(1)="iron_idleMid"
    IronIdleAnims(2)="iron_idleFar"
    NumMagsToResupply=2
    MagEmptyReloadAnim="Reload"
    MagPartialReloadAnim="Reload"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    BayonetBoneName="bayonet"
    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=2
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=25.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FireModeClass(0)=class'DH_ATWeapons.DH_PIATFire'
    FireModeClass(1)=class'DH_ATWeapons.DH_PIATMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.6
    CurrentRating=0.6
    DisplayFOV=70.0
    bCanAttachOnBack=true
    bCanRestDeploy=true
    PickupClass=class'DH_ATWeapons.DH_PIATPickup'
    BobDamping=1.6
    WarningMessageClass=class'DH_PIATWarningMsg'
    AttachmentClass=class'DH_ATWeapons.DH_PIATAttachment'
    RocketAttachmentClass=class'DH_PIATAmmoRound'
    ItemName="PIAT"
    Mesh=SkeletalMesh'DH_PIAT_1st.PIAT'
    FillAmmoMagCount=1
    Priority=8
    InventoryGroup=5
}
