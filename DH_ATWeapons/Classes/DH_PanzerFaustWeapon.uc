//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerFaustWeapon extends RORocketWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Panzerfaust_1st.ukx

var()   int     Ranges[3];         // The angle to launch the projectile at different ranges (30,60,80 meters)
var     int     RangeIndex;        // Current range setting
var     name    IronIdleAnims[3];  // Iron idle animation for different range settings

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetRange;
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

    DH_ProjectileFire(FireMode[0]).AddedPitch = Ranges[RangeIndex];
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
                DH_PanzerFaustWeapon(W).GiveAmmoPickupAmmo(m, Ammo(Pickup), bJustSpawned);
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

            for (i = 0; i < PrimaryAmmoArray.Length; i++)
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

function DropFrom(vector StartLocation)
{
    local int m, i;
    local Pickup Pickup;
    local rotator R;

    if (!bCanThrow)
    {
        return;
    }

    if (Instigator != none && bUsingSights)
    {
        bUsingSights = false;
        ROPawn(Instigator).SetIronSightAnims(false);
    }

    ClientWeaponThrown();

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

    // Destroy empty weapons without pickups if needed (panzerfaust, etc)
    if (AmmoAmount(0) < 1)
    {
        Destroy();
    }
    else
    {
        for (i = 0; i < AmmoAmount(0); i++)
        {
            R.Yaw = Rand(65536);
            Pickup = Spawn(PickupClass,,, StartLocation,R);

            if (Pickup != none)
            {
                Pickup.InitDroppedPickupFor(self);
                Pickup.Velocity = Velocity >> R;

                if (Instigator.Health > 0)
                {
                    WeaponPickup(Pickup).bThrown = true;
                }

                Pickup = none;
            }
        }

        Destroy();
    }
}

function bool HandlePickupQuery(Pickup Item)
{
    local WeaponPickup WPU;
    local int i;

    if (bNoAmmoInstances)
    {
        // handle ammo pickups
        for (i = 0; i < 2; i++)
        {
            if (Item.inventorytype == AmmoClass[i] && AmmoClass[i] != none)
            {
                if (AmmoCharge[i] >= MaxAmmo(i))
                {
                    return true;
                }

                Item.AnnouncePickup(Pawn(Owner));
                AddAmmo(Ammo(Item).AmmoAmount, i);
                Item.SetRespawn();

                return true;
            }
            else if (WeaponPickup(Item) != none && Item.inventorytype == class && (AmmoClass[i] != none))
            {
                if (AmmoCharge[i] >= MaxAmmo(i) || WeaponPickup(Item).AmmoAmount[i] < 1)
                {
                    return true;
                }

                Item.AnnouncePickup(Pawn(Owner));
                AddAmmo(WeaponPickup(Item).AmmoAmount[i], i);
                Item.SetRespawn();

                return true;
            }
        }
    }

    if (Class == Item.InventoryType)
    {
        WPU = WeaponPickup(Item);

        if (WPU != none)
        {
            return !WPU.AllowRepeatPickup();
        }
        else
        {
            return false;
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

simulated function PostBeginPlay()
{
    local vector RocketLoc;

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        RocketLoc = GetBoneCoords('Warhead').Origin;
        RocketAttachment = Spawn(class'ROFPAmmoRound',self,, RocketLoc);
        AttachToBone(RocketAttachment, 'Warhead');
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    local vector RocketLoc;

    super.BringUp(PrevWeapon);

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
                RocketAttachment = Spawn(class'ROFPAmmoRound',self, , RocketLoc);
                AttachToBone(RocketAttachment, 'Warhead');
            }
        }
    }
}

simulated function int GetHudAmmoCount()
{
    return AmmoAmount(0);
}

// Get the coords for the muzzle bone - used for free-aim projectile spawning
function coords GetMuzzleCoords()
{
    // have to update the location of the weapon before getting the coords
    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    return GetBoneCoords('Warhead');
}

simulated state PostFiring
{
    simulated function bool IsBusy()
    {
        return true;
    }

    simulated function Timer()
    {
        GotoState('AutoLoweringWeapon');
    }

    simulated function BeginState()
    {
        SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0), false);
    }

    simulated function EndState()
    {
        if (ROWeaponAttachment(ThirdPersonActor) != none)
        {
            ROWeaponAttachment(ThirdPersonActor).AmbientSound = none;
        }

        OldWeapon = none;
    }
}

simulated function PostFire()
{
    GotoState('PostFiring');
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

simulated state AutoLoweringWeapon
{
    simulated function bool WeaponCanSwitch()
    {
        if (ClientState == WS_PutDown)
        {
            return true;
        }

        if (IsBusy() || Instigator.bBipodDeployed)
        {
            return false;
        }

        return super.WeaponCanSwitch();
    }

    simulated function bool IsBusy()
    {
        return true;
    }

    simulated function Timer()
    {
        local inventory Inv;
        local int i;
        local bool bFoundOtherWeapon;

        if (AmmoAmount(0) > 0)
        {
            Instigator.PendingWeapon = self;

            BringUp(self);

            if (Role == ROLE_Authority && ThirdPersonActor != none)
            {
                ThirdPersonActor.LinkMesh(ThirdPersonActor.default.Mesh);
            }
        }
        else
        {
            for (Inv = Instigator.Inventory; Inv != none; Inv = Inv.Inventory)
            {
                if (Inv != self && Weapon(Inv) != none)
                {
                    bFoundOtherWeapon = true;
                    break;
                }

                i++;

                if (i > 500)
                {
                    break;
                }
            }

            if (bFoundOtherWeapon && Instigator.IsLocallyControlled())
            {
                Instigator.Controller.SwitchToBestWeapon();
            }
            else
            {
                GotoState('Idle');
            }
        }
    }

    simulated function BeginState()
    {
        local int Mode;

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (Instigator.IsLocallyControlled())
            {
                for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
                {
                    if (FireMode[Mode].bIsFiring)
                    {
                        ClientStopFire(Mode);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    TweenAnim(SelectAnim,PutDownTime);
                }
                else if (HasAnim(PutDownAnim))
                {
                    PlayAnim(PutDownAnim, PutDownAnimRate, FastTweenTime);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(PutDownAnim, PutDownAnimRate), false);

        for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
        {
            FireMode[Mode].bServerDelayStartFire = false;
            FireMode[Mode].bServerDelayStopFire = false;
        }
    }

    simulated function EndState()
    {
        local int Mode;

        if (ClientState == WS_PutDown)
        {
            if (Instigator.PendingWeapon == none)
            {
                PlayIdle();
                ClientState = WS_ReadyToFire;
            }
            else
            {
                ClientState = WS_Hidden;
                Instigator.ChangedWeapon();

                for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
                {
                    FireMode[Mode].DestroyEffects();
                }
            }
        }

        if (Role == ROLE_Authority && AmmoAmount(0) < 1 && !bDeleteMe)
        {
            Gotostate('Idle');
            SelfDestroy();
        }
    }
// Take the player out of iron sights if they are in ironsights
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
            SmoothZoom(false);
        }
    }
}

simulated state RaisingWeapon
{
    simulated function BeginState()
    {
        local ROPlayer player;

        super.BeginState();

        // Hint check
        player = ROPlayer(Instigator.Controller);

        if (player != none)
        {
            player.CheckForHint(12);
        }
    }
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

    if (Dist > 400.0 && dist < 6000.0)
    {
        return FMin(2.0, Result + (6000.0 - Dist) * 0.0001);
    }

    return Result;
}

function bool IsATWeapon()
{
    return true;
}

defaultproperties
{
    Ranges(0)=500
    Ranges(1)=1150
    Ranges(2)=2000
    IronIdleAnims(0)="Iron_idle30"
    IronIdleAnims(1)="Iron_idle"
    IronIdleAnims(2)="Iron_idle90"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    BayonetBoneName="bayonet"
    MaxNumPrimaryMags=1
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=25.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.200000
    FireModeClass(0)=class'DH_ATWeapons.DH_PanzerFaustFire'
    FireModeClass(1)=class'ROInventory.PanzerFaustMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    AIRating=0.600000
    CurrentRating=0.600000
    DisplayFOV=70.000000
    bCanAttachOnBack=true
    PickupClass=class'DH_ATWeapons.DH_PanzerFaustPickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_ATWeapons.DH_PanzerFaustAttachment'
    ItemName="Panzerfaust 60"
    Mesh=SkeletalMesh'Axis_Panzerfaust_1st.Panzerfaust_Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.Panzerfaust_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
