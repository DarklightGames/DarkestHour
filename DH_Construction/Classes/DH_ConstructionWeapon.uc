//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ConstructionWeapon extends DHProxyWeapon;

var class<DHConstruction>       ConstructionClass;

var Sound                       ClickSound;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerCreateConstruction;
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
    local Actor HitActor;
    local Vector HitLocation, HitNormal;
    local PlayerController PC;
    local DHConstructionProxy CP;
    local int bLimitLocalRotation;
    local Range LocalRotationYawRange;

    if (ProxyCursor != none)
    {
        PC = PlayerController(Instigator.Controller);

        TraceFromPlayer(HitActor, HitLocation, HitNormal, bLimitLocalRotation, LocalRotationYawRange);

        CP = DHConstructionProxy(ProxyCursor);

        if (CP != none)
        {
            CP.UpdateParameters(HitLocation, PC.CalcViewRotation, HitActor, HitNormal, bool(bLimitLocalRotation), LocalRotationYawRange);

            if (CP.ProxyError.Type != ERROR_None)
            {
                Instigator.ReceiveLocalizedMessage(class'DHConstructionErrorMessage', int(CP.ProxyError.Type),,, ProxyCursor);
            }
            else
            {
                Instigator.ReceiveLocalizedMessage(class'DHConstructionControlsMessage', 0, Instigator.PlayerReplicationInfo,, CP);
            }
        }
    }
}

simulated function DHActorProxy CreateProxyCursor()
{
    local DHConstructionProxy Cursor;

    Cursor = Spawn(class'DHConstructionProxy', Instigator);
    Cursor.SetConstructionClass(default.ConstructionClass.static.GetConstructionClass(Cursor.GetContext()));

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

simulated function TraceFromPlayer(
    out Actor HitActor,
    out Vector HitLocation,
    out Vector HitNormal,
    optional out int bLimitLocalRotation,
    optional out Range LocalRotationYawRange
    )
{
    local PlayerController PC;
    local Actor TempHitActor;
    local Vector TraceStart, TraceEnd, X, Y, Z;
    local DHConstructionSocket Socket;

    bLimitLocalRotation = 0;

    if (Instigator == none)
    {
        return;
    }

    PC = PlayerController(Instigator.Controller);

    // Trace out into the world and try and hit something static.
    TraceStart = Instigator.Location + Instigator.EyePosition();
    TraceEnd = TraceStart + (Vector(PC.CalcViewRotation) * class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProxyTraceDepthMeters));

    // Trace for location hints.
    foreach TraceActors(class'DHConstructionSocket', Socket, HitLocation, HitNormal, TraceStart, TraceEnd)
    {
        if (Socket == none)
        {
            continue;
        }

        // This is assumed to be in ascending order of distance, so this should
        // return the nearest traced location hint.
        if (Socket.IsForConstructionClass(ConstructionClass))
        {
            HitActor = Socket;
            HitLocation = HitActor.Location;
            GetAxes(HitActor.Rotation, X, Y, Z);
            HitNormal = Z;
            bLimitLocalRotation = int(Socket.bLimitLocalRotation);
            LocalRotationYawRange = Socket.LocalRotationYawRange;
            return;
        }
    }

    // Trace static actors and (world geometry etc.)
    foreach TraceActors(class'Actor', TempHitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        if (TempHitActor.bStatic && !TempHitActor.IsA('ROBulletWhipAttachment') && !TempHitActor.IsA('Volume'))
        {
            HitActor = TempHitActor;
            break;
        }
    }

    if (HitActor == none)
    {
        // We didn't hit anything, trace down to the ground in hopes of finding
        // something solid to rest on
        TraceStart = TraceEnd;
        TraceEnd = TraceStart + vect(0, 0, -1) * class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProxyTraceHeightMeters);

        foreach TraceActors(class'Actor', TempHitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
        {
            if (TempHitActor.bStatic && !TempHitActor.IsA('ROBulletWhipAttachment') && !TempHitActor.IsA('Volume'))
            {
                HitActor = TempHitActor;
                break;
            }
        }

        if (HitActor == none)
        {
            HitLocation = TraceStart;
        }
    }
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
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(Level);
    Context.PlayerController = DHPlayer(Instigator.Controller);
    Context.VariantIndex = VariantIndex;
    Context.SkinIndex = SkinIndex;

    if (ConstructionClass.static.GetPlayerError(Context).Type != ERROR_None)
    {
        return;
    }

    // Create a proxy to test placement logic on the server-side.
    TestProxy = Spawn(class'DHConstructionProxy', Instigator);

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
