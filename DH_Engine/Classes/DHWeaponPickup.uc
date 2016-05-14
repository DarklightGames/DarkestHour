//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHWeaponPickup extends ROWeaponPickup
    abstract;

var     TreeMap_string_Object   NotifyParameters; // an object that can hold references to several other objects, which can be used by messages to build a tailored message

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
var     vector                  BarrelSteamEmitterOffset; // offset for the emitter to position correctly on the pickup static mesh

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetDirty && Role == ROLE_Authority)
        bBarrelSteamActive;
}

// Modified to set bNetNotify on a net client if weapon type has barrels, so we receive PostNetReceive triggering when bBarrelSteamActive toggles
// Also to set up new NotifyParameters object, including pickup's InventoryType, which gets passed to screen messages & allows them to display weapon's name
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        NotifyParameters = new class'TreeMap_string_Object';
        NotifyParameters.Put("InventoryClass", InventoryType);

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

// Modified to store ammo mags & any barrels from the weapon
function InitDroppedPickupFor(Inventory Inv)
{
    local DHProjectileWeapon W;
    local int i;

    super.InitDroppedPickupFor(Inv);

    W = DHProjectileWeapon(Inv);

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

        // Ensure that AmmoMags has at least 1 item (otherwise it bugs other things)
        AmmoMags.Length = Max(AmmoMags.Length, 1);

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

// Modified to work generically, using ItemName
static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    switch (Switch)
    {
        case 0:
            return Repl(default.PickupMessage, "{0}", default.InventoryType.default.ItemName);
        case 1:
            return Repl(default.TouchMessage, "{0}", default.InventoryType.default.ItemName);
    }
}

// Modified to add the Controller to NotifyParameters object & pass that to screen message, allowing it to display both the use/pick up key & weapon name
simulated event NotifySelected(Pawn User)
{
    if (Level.NetMode != NM_DedicatedServer && User != none && User.IsHumanControlled() && ((Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime))
    {
        NotifyParameters.Put("Controller", User.Controller);
        User.ReceiveLocalizedMessage(TouchMessageClass, 1,,, NotifyParameters);
        LastNotifyTime = Level.TimeSeconds;
    }
}

defaultproperties
{
    DrawType=DT_StaticMesh
    AmbientGlow=64
    PickupMessage="You got the {0}"
    TouchMessage="Press [%USE%] to pick up {0}"
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
    BarrelSteamEmitterClass=class'ROEffects.ROMGSteam'
    TouchMessageClass=class'DHWeaponPickupTouchMessage'
}
