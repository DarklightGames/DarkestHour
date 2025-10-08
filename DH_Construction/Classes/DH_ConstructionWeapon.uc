//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ConstructionWeapon extends DH_ProxyWeapon;

var class<DHConstruction>       ConstructionClass;

var Sound                       ClickSound;

struct TraceFromPlayerResult
{
    var Actor HitActor;
    var Vector HitLocation;
    var Vector HitNormal;
    var Range LocalRotationYawRange;
    var bool bLimitLocalRotation;
};

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerCreateConstruction;
}

simulated function Destroyed()
{
    super.Destroyed();

    if (Level.NetMode != NM_DedicatedServer)
    {
        HideAllSockets();
    }
}

// TODO: add a nice sound effect when the construction slots into a socket!
// TODO: have the color change to green when the slot is being occupied.
// BUG: when the construction dies, the socket remains, but anything that was put in it
// is destroyed as soon as the construction is. To fix this we have to tear off the ownership
// of socket occupants.

simulated function ShowAllSockets()
{
    local DHConstructionSocket Socket;

    // Show relevant construction sockets.
    foreach DynamicActors(Class'DHConstructionSocket', Socket)
    {
        if (Socket.IsForConstructionClass(ProxyCursor.GetContext(), ConstructionClass))
        {
            Socket.Show();
        }
    }
}

simulated function HideAllSockets()
{
    local DHConstructionSocket Socket;

    // TODO: HIDE all construction sockets.
    foreach DynamicActors(Class'DHConstructionSocket', Socket)
    {
        Socket.Hide();
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    // TODO: we need to show all *relevant* sockets.
    //   also have to handle the case where sockets are created after the weapon is brought up.
    //   the dumb thing to do would be to check this in TICK but that's not great.
    //   dynamicactor 
    if (Level.NetMode != NM_DedicatedServer)
    {
        ShowAllSockets();
    }
}

simulated function bool PutDown()
{
    // TODO: we need to show all *relevant* sockets.
    //   also have to handle the case where sockets are created after the weapon is brought up.
    //   the dumb thing to do would be to check this in TICK but that's not great.
    //   dynamicactor 
    if (Level.NetMode != NM_DedicatedServer)
    {
        HideAllSockets();
    }

    return super.PutDown();
}

simulated function ClientPlayClickSound()
{
    local PlayerController PC;

    PC = PlayerController(Instigator.Controller);

    if (PC != none)
    {
        PC.ClientPlaySound(ClickSound);
    }
}

// Overridden to cycle the variant of the construction proxy.
exec simulated function SwitchFireMode()
{
    local DHConstructionProxy CP;

    CP = DHConstructionProxy(ProxyCursor);

    if (CP != none && CP.GetRuntimeData().bHasVariants)
    {
        CP.CycleVariant();

        ClientPlayClickSound();
    }
}

// Overridden to cycle the skin of the construction proxy.
exec simulated function ROMGOperation()
{
    local DHConstructionProxy CP;

    CP = DHConstructionProxy(ProxyCursor);

    if (CP != none && CP.GetRuntimeData().bHasSkins)
    {
        CP.CycleSkin();

        ClientPlayClickSound();
    }
}

simulated function SetConstructionClass(class<DHConstruction> NewConstructionClass)
{
    local DHConstructionProxy CP;

    ConstructionClass = NewConstructionClass;
    
    // We already have the construction weapon in our inventory, so let's
    // simply update the construction class of the existing proxy cursor.
    CP = DHConstructionProxy(ProxyCursor);

    if (CP != none)
    {
        CP.SetConstructionClass(ConstructionClass);
    }
}

simulated function OnTick(float DeltaTime)
{
    local TraceFromPlayerResult R;
    local PlayerController PC;
    local DHConstructionProxy CP;

    CP = DHConstructionProxy(ProxyCursor);

    if (CP == none)
    {
        return;
    }

    PC = PlayerController(Instigator.Controller);

    if (CP == none)
    {
        return;
    }

    R = TraceFromPlayer();

    CP.UpdateParameters(R.HitLocation, PC.CalcViewRotation, R.HitActor, R.HitNormal, R.bLimitLocalRotation, R.LocalRotationYawRange);

    if (CP.ProxyError.Type != ERROR_None)
    {
        // Display the construction error message.
        Instigator.ReceiveLocalizedMessage(Class'DHConstructionErrorMessage', int(CP.ProxyError.Type),,, ProxyCursor);
    }
    else
    {
        // Display the construction controls message.
        Instigator.ReceiveLocalizedMessage(Class'DHConstructionControlsMessage', 0, Instigator.PlayerReplicationInfo,, CP);
    }
}

simulated function OnProxySocketEnter(DHConstructionSocket Socket)
{
    // TODO: play a neat sound.
    ClientPlayClickSound();
}

simulated function OnProxySocketExit(DHConstructionSocket Socket)
{
    // TODO: play a neat sound.
    ClientPlayClickSound();
}

simulated function DHActorProxy CreateProxyCursor()
{
    local DHConstructionProxy Cursor;

    Cursor = Spawn(Class'DHConstructionProxy', Instigator);
    Cursor.SetConstructionClass(default.ConstructionClass.static.GetConstructionClass(Cursor.GetContext()));
    Cursor.OnSocketEnter = OnProxySocketEnter;
    Cursor.OnSocketExit = OnProxySocketExit;

    return Cursor;
}

simulated function bool CanConfirmPlacement()
{
    local DHConstructionProxy CP;

    CP = DHConstructionProxy(ProxyCursor);

    return CP != none && CP.ProxyError.Type == ERROR_None;
}

simulated function OnConfirmPlacement()
{
    local DHConstructionProxy CP;

    CP = DHConstructionProxy(ProxyCursor);

    if (CP != none)
    {
        ServerCreateConstruction(CP.ConstructionClass, CP.GroundActor, ProxyCursor.Location, ProxyCursor.Rotation, CP.VariantIndex, CP.DefaultSkinIndex + CP.SkinIndex);
    }
}

simulated function bool ShouldSwitchToLastWeaponOnPlacement()
{
    return ConstructionClass.default.bShouldSwitchToLastWeaponOnPlacement;
}

simulated function bool ShouldSnapRotation()
{
    return ConstructionClass.default.bSnapRotation;
}

simulated function float GetRotationSnapAngle()
{
    return ConstructionClass.default.RotationSnapAngle;
}

simulated function float GetLocalRotationRate()
{
    return ConstructionClass.default.LocalRotationRate;
}

simulated function TraceFromPlayerResult TraceFromPlayer()
{
    local PlayerController PC;
    local Actor TempHitActor;
    local Vector TraceStart, TraceEnd, X, Y, Z;
    local DHConstructionSocket Socket;
    local TraceFromPlayerResult Result;

    Result.bLimitLocalRotation = false;

    if (Instigator == none)
    {
        return Result;
    }

    PC = PlayerController(Instigator.Controller);

    // Trace out into the world and try and hit something static.
    TraceStart = Instigator.Location + Instigator.EyePosition();
    TraceEnd = TraceStart + (Vector(PC.CalcViewRotation) * Class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProxyTraceDepthMeters));

    // Trace for construction sockets.
    foreach TraceActors(Class'DHConstructionSocket', Socket, Result.HitLocation, Result.HitNormal, TraceStart, TraceEnd)
    {
        if (Socket == none)
        {
            continue;
        }

        // This is assumed to be in ascending order of distance, so this should
        // return the nearest traced location hint.
        if (Socket.IsForConstructionClass(ProxyCursor.GetContext(), ConstructionClass))
        {
            Result.HitActor = Socket;
            Result.HitLocation = Result.HitActor.Location;
            GetAxes(Result.HitActor.Rotation, X, Y, Z);
            Result.HitNormal = Z;
            Result.bLimitLocalRotation = Socket.bLimitLocalRotation;
            Result.LocalRotationYawRange = Socket.LocalRotationYawRange;
            return Result;
        }
    }

    // Trace static actors and (world geometry etc.)
    foreach TraceActors(Class'Actor', TempHitActor, Result.HitLocation, Result.HitNormal, TraceEnd, TraceStart)
    {
        if (TempHitActor.bStatic && !TempHitActor.IsA('ROBulletWhipAttachment') && !TempHitActor.IsA('Volume'))
        {
            Result.HitActor = TempHitActor;
            break;
        }
    }

    if (Result.HitActor == none)
    {
        // We didn't hit anything, trace down to the ground in hopes of finding
        // something solid to rest on
        TraceStart = TraceEnd;
        TraceEnd = TraceStart + vect(0, 0, -1) * Class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProxyTraceHeightMeters);

        foreach TraceActors(Class'Actor', TempHitActor, Result.HitLocation, Result.HitNormal, TraceEnd, TraceStart)
        {
            if (TempHitActor.bStatic && !TempHitActor.IsA('ROBulletWhipAttachment') && !TempHitActor.IsA('Volume'))
            {
                Result.HitActor = TempHitActor;
                break;
            }
        }

        if (Result.HitActor == none)
        {
            Result.HitLocation = TraceStart;
        }
    }

    return Result;
}

function ServerCreateConstruction(class<DHConstruction> ConstructionClass, Actor Owner, Vector Location, Rotator Rotation, int VariantIndex, int SkinIndex)
{
    local DHConstruction C;
    local DHPawn P;
    local DHActorProxy.Context Context;
    local DHConstructionProxy TestProxy;
    local DHConstruction.ConstructionError Error;
    local array<DHConstructionSupplyAttachment.Withdrawal> Withdrawals;
    local DHConstructionSocket Socket;

    if (Instigator == none)
    {
        return;
    }

    Context.TeamIndex = Instigator.GetTeamNum();
    Context.LevelInfo = Class'DH_LevelInfo'.static.GetInstance(Level);
    Context.PlayerController = DHPlayer(Instigator.Controller);
    Context.VariantIndex = VariantIndex;
    Context.SkinIndex = SkinIndex;

    if (ConstructionClass.static.GetPlayerError(Context).Type != ERROR_None)
    {
        return;
    }

    // Create a proxy to test placement logic on the server-side.
    TestProxy = Spawn(Class'DHConstructionProxy', Instigator);

    if (TestProxy == none)
    {
        return;
    }

    TestProxy.GroundActor = Owner;
    TestProxy.SetConstructionClass(ConstructionClass);
    TestProxy.SetLocation(Location);
    TestProxy.SetRotation(Rotation);

    // HACK: We set this to true to signal to the error checker that we should
    // not raise errors when we are overlapping other proxies.
    TestProxy.bHidden = true;

    Error = TestProxy.GetPositionError();

    TestProxy.Destroy();

    if (Error.Type != ERROR_None)
    {
        return;
    }

    P = DHPawn(Instigator);

    if (P == none || !P.UseSupplies(ConstructionClass.static.GetSupplyCost(Context), Withdrawals))
    {
        return;
    }

    C = Spawn(ConstructionClass, Owner,, Location, Rotation);

    Socket = DHConstructionSocket(Owner);

    if (C != none)
    {
        C.InstigatorController = DHPlayer(Instigator.Controller);

        // If we are being placed into a socket, set the socket as occupied by the new construction.
        Socket = DHConstructionSocket(Owner);

        if (Socket != none)
        {
            Socket.Occupant = C;
        }

        C.VariantIndex = VariantIndex;
        C.SkinIndex = Context.SkinIndex;
        
        C.OnPlaced();

        if (!C.bIsNeutral)
        {
            C.SetTeamIndex(Instigator.GetTeamNum());
        }

        C.UpdateAppearance();
        C.OnSpawnedByPlayer(C.InstigatorController);
    }
}

simulated function ResetCursor()
{
    local DHConstructionProxy CP;

    CP = DHConstructionProxy(ProxyCursor);

    if (CP != none)
    {
        // This resets the proxy.
        CP.SetConstructionClass(CP.ConstructionClass);

        ClientPlayClickSound();
    }
}

defaultproperties
{
    ClickSound=Sound'ROMenuSounds.msfxMouseClick'
}
