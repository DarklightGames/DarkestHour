//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponPickup extends ROWeaponPickup
    abstract;

// General
var     int                     PlayerNearbyRadius;
var     int                     PlayerNearbyRetryTime;

// Ammo
var     array<int>              AmmoMags;
var     int                     LoadedMagazineIndex;

// Barrels
var     array<DHWeaponBarrel>   Barrels;                  // array of any carried barrels for this weapon
var     byte                    BarrelIndex;              // index number of current barrel
var     bool                    bBarrelSteamActive;       // barrel is steaming
var     bool                    bOldBarrelSteamActive;    // clientside record, so PostNetReceive can tell when bBarrelSteamActive changes
var     class<ROMGSteam>        BarrelSteamEmitterClass;
var     ROMGSteam               BarrelSteamEmitter;
var     Vector                  BarrelSteamEmitterOffset; // offset for the emitter to position correctly on the pickup static mesh

var     StaticMesh              EmptyStaticMesh;

var    bool                     bWaitingToBolt;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetDirty && Role == ROLE_Authority)
        bBarrelSteamActive;
}

// Modified to set bNetNotify on a net client if weapon type has barrels, so we receive PostNetReceive triggering when bBarrelSteamActive toggles.
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (Role < ROLE_Authority && class<DHProjectileWeapon>(InventoryType) != none)
        {
            bNetNotify = class<DHProjectileWeapon>(InventoryType).default.InitialBarrels > 0;
        }
    }
}

// Modified to destroy any BarrelSteamEmitter
simulated function Destroyed()
{
    super.Destroyed();

    if (BarrelSteamEmitter != none)
    {
        BarrelSteamEmitter.Destroy();
    }
}

// Non-owning net clients pick up changed value of bBarrelSteamActive here & it triggers toggling the steam emitter on/off
simulated function PostNetReceive()
{
    if (bBarrelSteamActive != bOldBarrelSteamActive)
    {
        bOldBarrelSteamActive = bBarrelSteamActive;
        SetBarrelSteamActive(bBarrelSteamActive);
    }
}

// Modified so a burning player can't pick up a weapon
auto state Pickup
{
    function bool ValidTouch(Actor Other)
    {
        return !(DHPawn(Other) != none &&
                 (DHPawn(Other).bOnFire ||
                 !DHPawn(Other).bCanPickupWeapons)) &&
               super.ValidTouch(Other);
    }

    function Timer()
    {
        // Only goto 'FadeOut' if no one is nearby, else try again shortly
        if (!ArePlayersNearby() && bDropped)
        {
            GotoState('FadeOut');
        }
        else if (bDropped)
        {
            SetTimer(PlayerNearbyRetryTime, false);
        }
    }
}

// New function that returns true if players are nearby
function bool ArePlayersNearby()
{
    local DHPawn    DHP;

    foreach RadiusActors(Class'DHPawn', DHP, PlayerNearbyRadius)
    {
        return true;
    }

    return false;
}

// Modified to store ammo mags & any barrels from the weapon and to not set a lifespan (we will let the fade out do that)
function InitDroppedPickupFor(Inventory Inv)
{
    local DHProjectileWeapon W;
    local int i;

    W = DHProjectileWeapon(Inv);

    if (W != none)
    {
        AmmoAmount[0] = W.AmmoAmount(0);
        AmmoAmount[1] = W.AmmoAmount(1);
        bHasBayonetMounted = W.bBayonetMounted;
        bWaitingToBolt = W.bWaitingToBolt;
    }

    SetPhysics(PHYS_Falling);
    GotoState('FallingPickup');
    Inventory = Inv;
    bAlwaysRelevant = false;
    bOnlyReplicateHidden = false;
    bUpdateSimulatedPosition = true;
    bDropped = true;
    bIgnoreEncroachers = false;
    NetUpdateFrequency = 8;

    if (W != none)
    {
        // Store the ammo mags from the weapon
        for (i = 0; i < W.PrimaryAmmoArray.Length; ++i)
        {
            if (i == W.CurrentMagIndex)
            {
                AmmoMags[AmmoMags.Length] = W.AmmoAmount(0);
            }
            else
            {
                AmmoMags[AmmoMags.Length] = W.PrimaryAmmoArray[i];
            }
        }

        // If weapon has barrels, transfer over any barrels
        if (W.Barrels.Length > 0)
        {
            Barrels = W.Barrels; // copy the weapon's reference to the Barrels array

            for (i = 0; i < Barrels.Length; ++i)
            {
                if (Barrels[i] != none)
                {
                    Barrels[i].SetOwner(self); // barrel's owner is now this pickup

                    if (Barrels[i].bIsCurrentBarrel)
                    {
                        BarrelIndex = i;
                        Barrels[BarrelIndex].UpdateBarrelStatus();
                    }
                }
            }
        }
        
        // If the weapon is empty and we have an empty static mesh variant, show that instead
        if (EmptyStaticMesh != none && W.AmmoAmount(0) == 0)
        {
            SetStaticMesh(EmptyStaticMesh);
        }
    }
}

// Called when we need to toggle barrel steam on or off, depending on the barrel temperature
simulated function SetBarrelSteamActive(bool bSteaming)
{
    bBarrelSteamActive = bSteaming;

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Spawn the steam emitter if we need it
        if (BarrelSteamEmitter == none && bBarrelSteamActive && BarrelSteamEmitterClass != none)
        {
            BarrelSteamEmitter = Spawn(BarrelSteamEmitterClass, self);

            if (BarrelSteamEmitter != none)
            {
                BarrelSteamEmitter.SetLocation(Location + (BarrelSteamEmitterOffset >> Rotation));
                BarrelSteamEmitter.SetBase(self);
            }
        }

        // Toggle the steam emitter on/off if we need to
        if (BarrelSteamEmitter != none && BarrelSteamEmitter.bActive != bBarrelSteamActive)
        {
            BarrelSteamEmitter.Trigger(self, Instigator);
        }
    }
}

// Disabled as it isn't used
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

simulated event NotifySelected(Pawn User)
{
    if (Level.NetMode != NM_DedicatedServer && User != none && User.IsHumanControlled() && ((Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime))
    {
        User.ReceiveLocalizedMessage(TouchMessageClass, 1, User.PlayerReplicationInfo,, InventoryType);
        LastNotifyTime = Level.TimeSeconds;
    }
}

defaultproperties
{
    DrawType=DT_StaticMesh
    AmbientGlow=64
    PickupMessage="You got the {0}"
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
    BarrelSteamEmitterClass=Class'DHMGSteam'
    TouchMessageClass=Class'DHWeaponPickupTouchMessage'
    bAcceptsProjectors=false
    PlayerNearbyRadius=256
    PlayerNearbyRetryTime=10
}
