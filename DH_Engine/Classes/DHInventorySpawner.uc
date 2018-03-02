//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHInventorySpawner extends Actor
    abstract
    placeable;

var DHWeaponPickupTouchMessageParameters    TouchMessageParameters;

var class<Weapon>       WeaponClass;

var array<name>         PickupBoneNames;

var     int             SavedPickupCount;
var     int             PickupsMax;
var()   int             PickupCount;
var     int             UseCount;
var()   int             UsesMax;    // -1 = infinite

var     name            CloseAnimation;
var     name            ClosedAnimation;
var     name            OpenAnimation;
var     name            OpenedAnimation;

var()   bool            bShouldGeneratePickups;
var()   int             PickupGenerationRatePerMinute;

var     float           ExhaustedLifespan;

var bool                bIsProxy;
var array<Actor>        Proxies;
var class<Actor>        ProxyClass;
var StaticMesh          ProxyStaticMesh;

var localized string    ContainerNoun;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        PickupCount;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        TouchMessageParameters = new class'DHWeaponPickupTouchMessageParameters';
        TouchMessageParameters.InventoryClass = WeaponClass;

        UpdateProxies();
    }

    if (Role == ROLE_Authority)
    {
        PickupCount = Min(PickupCount, PickupsMax);

        if (UsesMax != -1)
        {
            PickupCount = Min(PickupCount, UsesMax);
        }

        if (CanGeneratePickups())
        {
            SetTimer(60.0 / float(PickupGenerationRatePerMinute), false);
        }
    }
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (PickupCount == 0)
        {
            PlayAnim(ClosedAnimation);
        }
        else
        {
            PlayAnim(OpenAnimation);
        }
    }
}

function bool CanGeneratePickups()
{
    return bShouldGeneratePickups && PickupGenerationRatePerMinute > 0 && PickupCount < PickupsMax;
}

function Timer()
{
    PickupCount = Min(PickupCount + 1, PickupsMax);

    if (UsesMax != -1)
    {
        PickupCount = Min(PickupCount, UsesMax - UseCount);
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (PickupCount == 1)
        {
            PlayAnim(OpenAnimation);
        }

        UpdateProxies();
    }

    if (CanGeneratePickups())
    {
        SetTimer(60.0 / float(PickupGenerationRatePerMinute), false);
    }
}

function UsedBy(Pawn User)
{
    local Weapon Weapon;
    local Pickup Pickup;

    if (PickupCount == 0)
    {
        return;
    }

    Weapon = Spawn(WeaponClass);
    Pickup = Spawn(WeaponClass.default.PickupClass,,, User.Location);

    if (Pickup == none)
    {
        Warn("Failed to spawn pickup!");
        return;
    }

    Pickup.InitDroppedPickupFor(Weapon);
    Pickup.GotoState('Pickup', 'Begin');
    Pickup.UsedBy(User);

    if (Pickup != none)
    {
        Weapon.Destroy();
        Pickup.Destroy();
        return;
    }

    PickupCount -= 1;
    UseCount += 1;

    if (UsesMax != -1 && UseCount >= UsesMax)
    {
        PickupCount = 0;
        LifeSpan = default.ExhaustedLifespan;
    }

    if (PickupCount <= 0 && !bShouldGeneratePickups)
    {
        LifeSpan = default.ExhaustedLifespan;
    }

    if (Level.NetMode != NM_DedicatedServer)    // TODO: standalone?
    {
        UpdateProxies();

        if (PickupCount == 0)
        {
            PlayAnim(CloseAnimation);
        }
    }

    if (CanGeneratePickups())
    {
        SetTimer(60.0 / float(PickupGenerationRatePerMinute), false);
    }
}

simulated event NotifySelected(Pawn User)
{
    local class<ROWeaponPickup> PickupClass;

    if (PickupCount <= 0)
    {
        return;
    }

    PickupClass = class<ROWeaponPickup>(WeaponClass.default.PickupClass);

    if (PickupClass == none)
    {
        return;
    }

    TouchMessageParameters.PlayerController = PlayerController(User.Controller);

    User.ReceiveLocalizedMessage(PickupClass.default.TouchMessageClass, 1,,, TouchMessageParameters);
}

simulated function StaticMesh GetProxyStaticMesh()
{
    return WeaponClass.default.PickupClass.default.StaticMesh;
}

simulated function UpdateProxies()
{
    local Actor Proxy;

    while (Proxies.Length > PickupCount && Proxies.Length > 0)
    {
        Proxies[Proxies.Length - 1].Destroy();
        Proxies.Remove(Proxies.Length - 1, 1);
    }

    while (Proxies.Length < PickupCount && Proxies.Length < PickupBoneNames.Length)
    {
        Proxy = Spawn(ProxyClass, self);
        Proxy.SetStaticMesh(GetProxyStaticMesh());
        AttachToBone(Proxy, PickupBoneNames[Proxies.Length]);
        Proxy.SetRelativeLocation(vect(0, 0, 0));
        Proxy.SetRelativeRotation(rot(0, 0, 0));
        Proxies[Proxies.Length] = Proxy;
    }
}

simulated event PostNetReceive()
{
    if (SavedPickupCount != PickupCount)
    {
        if (PickupCount == 0)
        {
            PlayAnim(CloseAnimation);
        }
        else if (SavedPickupCount == 0)
        {
            PlayAnim(OpenedAnimation);
        }

        if (bIsProxy)
        {
            UpdateProxies();
        }

        SavedPickupCount = PickupCount;
    }
}

event Destroyed()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < Proxies.Length; ++i)
        {
            Proxies[i].Destroy();
        }

        Proxies.Length = 0;
    }
}

static function string GetMenuName()
{
    return default.WeaponClass.default.ItemName @ default.ContainerNoun;
}

defaultproperties
{
    DrawType=DT_Mesh
    RemoteRole=ROLE_DumbProxy
    bCanAutoTraceSelect=true
    bAutoTraceNotify=true
    bNetNotify=true
    bCollideActors=true
    bUseCylinderCollision=true
    CollisionHeight=30.0
    CollisionRadius=30.0
    ExhaustedLifespan=15.0
    UsesMax=-1
    ProxyClass=class'DHWeaponPickupSpawnerProxy'
    ContainerNoun="box"
    OpenAnimation="open"
    CloseAnimation="close"
    OpenedAnimation="opened"
    ClosedAnimation="closed"
}

