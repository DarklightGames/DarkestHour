//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PIATWeapon extends DH_ProjectileWeapon;

#exec OBJ LOAD FILE=..\DarkestHour\Animations\DH_PIAT_1st.ukx

var()   int         Ranges[3];              // The angle to launch the projectile at different ranges (30,60,80 meters)
var     int         RangeIndex;             // Current range setting
var     name        IronIdleAnimOne;        // Iron idle animation for range setting one
var     name        IronIdleAnimTwo;        // Iron idle animation for range setting two
var     name        IronIdleAnimThree;      // Iron idle animation for range setting three

var     ROFPAmmoRound            RocketAttachment;     // The first person ammo round attached to the rocket

var int     NumMagsToResupply;          // Number of ammo mags to add when this weapon has been resupplied

//=============================================================================
// replication
//=============================================================================
replication
{
    reliable if (Role<ROLE_Authority)
        ServerSetRange;
}

function bool IsATWeapon()
{
    return true;
}

simulated function bool AllowReload()
{
    //Cannot reload without being prone or rested.
    if (!Instigator.bIsCrawling && !Instigator.bRestingWeapon)
    {
        class'DH_PIATWarningMsg'.static.ClientReceive(PlayerController(Instigator.Controller), 2);
        return false;
    }

    // Don't allow a reload if bomb already loaded
    if (AmmoAmount(0) > 0)
        return false;

    return super.AllowReload();
}

// Overridden to support cycling the panzerfaust aiming ranges
simulated exec function Deploy()
{
    if (IsBusy() || !bUsingSights)
        return;

    CycleRange();
}

// switch the PIAT aiming ranges
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

// Switch the PIAT aiming ranges on the server
function ServerSetRange(int NewIndex)
{
    RangeIndex=NewIndex;

    if (bUsingSights)
    {
        DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];
    }
    else
    {
        DH_ProjectileFire(FireMode[0]).AddedPitch = 0;
    }
}


// Ovveriden to play the panzerfaust animations for different ranges
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

function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local int m;
    local weapon w;
    local bool bPossiblySwitch, bJustSpawned;

    Instigator = Other;
    W = Weapon(Instigator.FindInventoryType(class));
    if (W == none || W.Class != Class) // added class check because somebody made FindInventoryType() return subclasses for some reason
    {
        bJustSpawned = true;
        super(Inventory).GiveTo(Other);
        bPossiblySwitch = true;
        W = self;
    }
    else if (!W.HasAmmo())
        bPossiblySwitch = true;

    if (Pickup == none)
        bPossiblySwitch = true;

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != none)
        {
            FireMode[m].Instigator = Instigator;

            if (Ammo(Pickup) != none)
            {
                DH_PIATWeapon(W).GiveAmmoPickupAmmo(m,Ammo(Pickup),bJustSpawned);
            }
            else
            {
                W.GiveAmmo(m,WeaponPickup(Pickup),bJustSpawned);
            }
        }
    }

    if (Instigator.Weapon != W)
        W.ClientWeaponSet(bPossiblySwitch);

    if (!bJustSpawned)
    {
        for (m = 0; m < NUM_FIRE_MODES; m++)
            Ammo[m] = none;
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
        return;

    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;

    super.DropFrom(StartLocation);
}

simulated function Destroyed()
{
    if (Role == ROLE_Authority && Instigator!= none && ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = false;
        ROPawn(Instigator).bWeaponNeedsResupply = false;
    }

    if (RocketAttachment != none)
        RocketAttachment.Destroy();

    super.Destroyed();
}

function GiveAmmoPickupAmmo(int m, Ammo AP, bool bJustSpawned)
{
    local bool bJustSpawnedAmmo;
    local int addAmount, InitialAmount, i;

    if (FireMode[m] != none && FireMode[m].AmmoClass != none)
    {
        Ammo[m] = Ammunition(Instigator.FindInventoryType(FireMode[m].AmmoClass));
        bJustSpawnedAmmo = false;

        if ((FireMode[m].AmmoClass == none) || ((m != 0) && (FireMode[m].AmmoClass == FireMode[0].AmmoClass)))
            return;

        InitialAmount = FireMode[m].AmmoClass.Default.InitialAmount;

        if (bJustSpawned && AP == none)
        {
            PrimaryAmmoArray.Length = MaxNumPrimaryMags;
            for(i=0; i<PrimaryAmmoArray.Length; i++)
            {
                PrimaryAmmoArray[i] = InitialAmount;
            }
            CurrentMagIndex=0;
            CurrentMagCount = PrimaryAmmoArray.Length - 1;
        }

        if ((AP != none) )
        {
            InitialAmount = AP.AmmoAmount;
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
    }
}

// Get the coords for the muzzle bone. Used for free-aim projectile spawning
function coords GetMuzzleCoords()
{
    // have to update the location of the weapon before getting the coords
    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));
    return GetBoneCoords('Warhead');
}

//------------------------------------------------------------------------------
// SelfDestroy(RO) - This is run server-side, it will destroy a weapon in a
//  player's inventory without spawning a pickup.
//------------------------------------------------------------------------------
function SelfDestroy()
{
    local int m;

    for(m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m].bIsFiring)
            StopFire(m);
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
    local Bot B;
    local float ZDiff, dist, Result;

    B = Bot(Instigator.Controller);

    if ((B == none) || (B.Enemy == none))
        return AIRating;

    if (Vehicle(B.Enemy) == none)
        return 0;

    result = AIRating;
    ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
    if (ZDiff > -300)
        result += 0.2;
    dist = VSize(B.Enemy.Location - Instigator.Location);
    if (dist > 400 && dist < 6000)
        return (FMin(2.0,result + (6000 - dist) * 0.0001));

    return result;
}

simulated function Fire(float F)
{
    //Level.Game.Broadcast(self, "Fire");

    if (!bUsingSights)
    {
        class'DH_PIATWarningMsg'.static.ClientReceive(PlayerController(Instigator.Controller), 0);
        return;
    }

    if (bUsingSights)
    {

        if (!Instigator.bIsCrawling && !Instigator.bRestingWeapon)
        {
            class'DH_PIATWarningMsg'.static.ClientReceive(PlayerController(Instigator.Controller), 1);
            return;
        }

        DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];

        if (Role < ROLE_Authority)
            ServerSetRange(RangeIndex);
    }
    else
    {
    DH_ProjectileFire(FireMode[0]).AddedPitch = 0;

        if (Role < ROLE_Authority)
            ServerSetRange(RangeIndex);
    }

    super.Fire(F);

    //Level.Game.Broadcast(self, "Added pitch = "$DH_ProjectileFire(FireMode[0]).AddedPitch);
}

//************************************************************************
simulated function PostBeginPlay()
{
    local vector RocketLoc;

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {

       RocketLoc = GetBoneCoords('Warhead').Origin;

       RocketAttachment = Spawn(class 'DH_PIATAmmoRound',self,, RocketLoc);

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

    if ((PrevWeapon != none) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch)
        OldWeapon = PrevWeapon;
    else
        OldWeapon = none;

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (/*WP != none && WP.AmmoAmount[m] < 1 && */AmmoAmount(0) < 1)
        {
            //log("Destroyed the fp ammoround");
            if (RocketAttachment != none)
                RocketAttachment.Destroy();
        }
        else
        {

           //log("didnt Destroyed the fp ammoround");
           if (RocketAttachment == none)
           {

                    RocketLoc = GetBoneCoords('Warhead').Origin;

                    RocketAttachment = Spawn(class 'DH_PIATAmmoRound',self,, RocketLoc);

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
    local vector RocketLoc;

    if (Level.NetMode != NM_DedicatedServer)
    {

       RocketLoc = GetBoneCoords('Warhead').Origin;

       RocketAttachment = Spawn(class 'DH_PIATAmmoRound',self,, RocketLoc);

       AttachToBone(RocketAttachment, 'Warhead');
    }
}



/*simulated state Reloading
{
    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }
}*/

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
        for (i=0; i<2; i++)
        {
            if ((item.inventorytype == AmmoClass[i]) && (AmmoClass[i] != none))
            {
                if ((AmmoAmount(0) <= 0 && PrimaryAmmoArray.Length < MaxNumPrimaryMags) || PrimaryAmmoArray.Length < MaxNumPrimaryMags - 1)
                {
                    // Handle multi mag ammo type pickups
                    if (ROMultiMagAmmoPickup(Item) != none)
                    {
                        for(j=0; j<ROMultiMagAmmoPickup(Item).AmmoMags.Length; j++)
                        {
                            if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
                            {
                                PrimaryAmmoArray[PrimaryAmmoArray.Length] = ROMultiMagAmmoPickup(Item).AmmoMags[j];//DropAmmo(StartLocation, PrimaryAmmoArray[i]);
                                bAddedMags=true;
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
                        bAddedMags=true;
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
                return true;
            }
        }
    }

/*  if (class == Item.InventoryType)
    {
        wpu = WeaponPickup(Item);
        if (wpu != none)
            return !wpu.AllowRepeatPickup();
        else
            return false;
    }*/

    // Drop current weapon and pickup the one on the ground
    if (Instigator.Weapon != none && Instigator.Weapon.InventoryGroup == InventoryGroup &&
        Item.InventoryType.default.InventoryGroup == InventoryGroup && Instigator.CanThrowWeapon())
    {
        ROPlayer(Instigator.Controller).ThrowWeapon();
        return false;
    }

    // Avoid multiple weapons in the same slot
    if (Item.InventoryType.default.InventoryGroup == InventoryGroup)
        return true;

    if (Inventory == none)
        return false;

    return Inventory.HandlePickupQuery(Item);
}

// This PIAT has been resupplied by another player
function bool ResupplyAmmo()
{
    local int InitialAmount, i;
    local bool bIsLoaded;

    if (AmmoAmount(0) > 0)
        bIsLoaded = true;

    InitialAmount = FireMode[0].AmmoClass.Default.InitialAmount;

    for(i=NumMagsToResupply; i>0; i--)
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
     IronIdleAnimOne="Iron_idle"
     IronIdleAnimTwo="iron_idleMid"
     IronIdleAnimThree="iron_idleFar"
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
     IronSightDisplayFOV=25.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     FireModeClass(0)=class'DH_ATWeapons.DH_PIATFire'
     FireModeClass(1)=class'DH_ATWeapons.DH_PIATMeleeFire'
     SelectAnim="Draw"
     PutDownAnim="putaway"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.600000
     CurrentRating=0.600000
     DisplayFOV=70.000000
     bCanAttachOnBack=true
     bCanRestDeploy=true
     PickupClass=class'DH_ATWeapons.DH_PIATPickup'
     BobDamping=1.600000
     AttachmentClass=class'DH_ATWeapons.DH_PIATAttachment'
     ItemName="PIAT"
     Mesh=SkeletalMesh'DH_PIAT_1st.PIAT'
     FillAmmoMagCount=1
     Priority=8
     InventoryGroup=5
}
