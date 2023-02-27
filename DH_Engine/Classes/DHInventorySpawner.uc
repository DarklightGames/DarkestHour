//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHInventorySpawner extends Actor
    abstract
    placeable;

var DHWeaponPickupTouchMessageParameters    TouchMessageParameters;

var class<Weapon>       WeaponClass;

enum ETeamOwner
{
    TEAM_Axis,
    TEAM_Allies,
    TEAM_Neutral
};

var bool                bIsTeamLocked;
var() ETeamOwner        TeamOwner;
var private int         TeamIndex;

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
var     float           NextPickupGenerationTimeSeconds;


var array<Actor>        Proxies;
var class<Actor>        ProxyClass;
var StaticMesh          ProxyStaticMesh;

var localized string    ContainerNoun;

// Client-side variable for keeping track if the box is open or closed.
var bool                bIsOpen;

// Called when all pickups are exhausted and we are pending deletion.
var bool                bShouldDestroyOnExhaustion;
var float               ExhaustedLifespan;
delegate                OnExhausted(DHInventorySpawner Spawner);

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        TeamIndex;

    reliable if (bNetDirty && Role == ROLE_Authority)
        PickupCount;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        TeamIndex = int(TeamOwner);
        PickupCount = Min(PickupCount, PickupsMax);

        if (UsesMax != -1)
        {
            PickupCount = Min(PickupCount, UsesMax);
        }

        if (CanGeneratePickups())   // TODO: determine if we need to call this still or move it etc.
        {
            NextPickupGenerationTimeSeconds = Level.TimeSeconds + (60.0 / PickupGenerationRatePerMinute);
        }

        SetTimer(1.0, true);
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        TouchMessageParameters = new class'DHWeaponPickupTouchMessageParameters';
        TouchMessageParameters.InventoryClass = WeaponClass;

        UpdateProxies();
    }
}

simulated function Open()
{
    if (bIsOpen)
    {
        return;
    }

    PlayAnim(OpenAnimation);

    bIsOpen = true;
}

simulated function Close()
{
    if (!bIsOpen)
    {
        return;
    }

    PlayAnim(CloseAnimation);

    bIsOpen = false;
}

simulated function int GetTeamIndex()
{
    return TeamIndex;
}

function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;
}

simulated function bool ShouldBeOpen()
{
    local PlayerController PC;

    PC = Level.GetLocalPlayerController();

    return PickupCount > 0 && PC != none && CanBeUsedByTeam(PC.GetTeamNum());
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    bIsOpen = ShouldBeOpen();

    if (bIsOpen)
    {
        PlayAnim(OpenAnimation);
    }
    else
    {
        PlayAnim(ClosedAnimation);
    }

    SetTimer(1.0, true);
}

function bool CanGeneratePickups()
{
    return bShouldGeneratePickups && PickupGenerationRatePerMinute > 0 && PickupCount < PickupsMax;
}

simulated function UpdateAnimation()
{
    local bool bShouldBeOpen;

    bShouldBeOpen = ShouldBeOpen();

    if (bIsOpen && !bShouldBeOpen)
    {
        Close();
    }
    else if (!bIsOpen && bShouldBeOpen)
    {
        Open();
    }
}

simulated event Timer()
{
    if (Role == ROLE_Authority)
    {
        if (CanGeneratePickups() && Level.TimeSeconds > NextPickupGenerationTimeSeconds)
        {
            PickupCount = Min(PickupCount + 1, PickupsMax);

            if (UsesMax != -1)
            {
                PickupCount = Min(PickupCount, UsesMax - UseCount);
            }

            NextPickupGenerationTimeSeconds = Level.TimeSeconds + (60.0 / PickupGenerationRatePerMinute);
        }
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        UpdateAnimation();
        UpdateProxies();
    }
}

simulated function bool CanBeUsedByTeam(int TeamIndex)
{
    return !bIsTeamLocked || self.TeamIndex == NEUTRAL_TEAM_INDEX || self.TeamIndex == TeamIndex;
}

simulated function bool CanBeUsedByPawn(Pawn User)
{
    return User != none && User.IsHumanControlled() && CanBeUsedByTeam(User.GetTeamNum());
}

function UsedBy(Pawn User)
{
    local Weapon Weapon;
    local Pickup Pickup;

    if (!CanBeUsedByPawn(User) || PickupCount == 0)
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

        if (bShouldDestroyOnExhaustion)
        {
            LifeSpan = default.ExhaustedLifespan;
        }

        OnExhausted(self);
    }

    if (PickupCount <= 0 && !bShouldGeneratePickups)
    {
        if (bShouldDestroyOnExhaustion)
        {
            LifeSpan = default.ExhaustedLifespan;
        }

        OnExhausted(self);
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        UpdateProxies();
        UpdateAnimation();
    }
}

function Reset()
{
    PickupCount = default.PickupCount;
    SavedPickupCount = default.SavedPickupCount;
    UseCount = default.UseCount;
}

simulated event NotifySelected(Pawn User)
{
    local class<ROWeaponPickup> PickupClass;

    if (Level.NetMode == NM_DedicatedServer ||
        !CanBeUsedByPawn(User) ||
        PickupCount <= 0 ||
        WeaponClass == none ||
        TouchMessageParameters == none)
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
    local int i;
    local Actor Proxy;
    local bool bShouldHideProxies;

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

    bShouldHideProxies = !CanBeUsedByTeam(Level.GetLocalPlayerController().GetTeamNum());

    for (i = 0; i < Proxies.Length; ++i)
    {
        Proxies[i].bHidden = bShouldHideProxies;
    }
}

simulated event PostNetReceive()
{
    if (SavedPickupCount != PickupCount)
    {
        UpdateProxies();
        UpdateAnimation();

        SavedPickupCount = PickupCount;
    }
}

simulated event Destroyed()
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

    if (TouchMessageParameters != none)
    {
        TouchMessageParameters.PlayerController = none;
    }
}

static function string GetMenuName()
{
    return default.WeaponClass.default.ItemName @ default.ContainerNoun;
}

defaultproperties
{
    DrawType=DT_Mesh
    RemoteRole=ROLE_SimulatedProxy
    bCanAutoTraceSelect=true
    bAutoTraceNotify=true
    bNetNotify=true
    bCollideActors=true
    bBlockActors=true
    bBlockPlayers=true
    bUseCylinderCollision=true
    CollisionHeight=10.0
    CollisionRadius=30.0
    ExhaustedLifespan=15.0
    UsesMax=-1
    ProxyClass=class'DHWeaponPickupSpawnerProxy'
    ContainerNoun="crate"
    OpenAnimation="open"
    CloseAnimation="close"
    OpenedAnimation="opened"
    ClosedAnimation="closed"
    SavedPickupCount=-1
    bIsTeamLocked=false
    TeamOwner=TEAM_Neutral
}

