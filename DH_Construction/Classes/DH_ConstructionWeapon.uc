//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ConstructionWeapon extends DHActorProxyWeapon;

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

function DHConstruction ServerCreateConstruction(class<DHConstruction> ConstructionClass, Actor Owner, Vector Location, Rotator Rotation, int VariantIndex, int SkinIndex)
{
    local DHConstruction C;
    local DHPawn P;
    local DHActorProxy.Context Context;
    local DHConstructionProxy TestProxy;
    local DHActorProxy.ActorProxyError Error;
    local array<DHConstructionSupplyAttachment.Withdrawal> Withdrawals;
    local DHConstructionSocket Socket;

    if (Instigator == none)
    {
        return none;
    }

    Context.TeamIndex = Instigator.GetTeamNum();
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(Level);
    Context.PlayerController = DHPlayer(Instigator.Controller);
    Context.VariantIndex = VariantIndex;
    Context.SkinIndex = SkinIndex;

    if (ConstructionClass.static.GetContextError(Context).Type != ERROR_None)
    {
        return none;
    }

    // Create a proxy to test placement logic on the server-side.
    TestProxy = Spawn(class'DHConstructionProxy', Instigator);

    if (TestProxy == none)
    {
        return none;
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
        return none;
    }

    P = DHPawn(Instigator);

    if (P == none || !P.UseSupplies(ConstructionClass.static.GetSupplyCost(Context), Withdrawals))
    {
        return none;
    }

    C = Spawn(ConstructionClass, Owner,, Location, Rotation);

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

    return C;
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

function bool IsSocketValid(DHActorProxySocket Socket)
{
    local DHConstructionSocket CS;

    CS = DHConstructionSocket(Socket);

    return CS != none && CS.IsForConstructionClass(ConstructionClass);
}

simulated function float GetTraceDepthMeters()
{
    return ConstructionClass.default.ProxyTraceDepthMeters;
}

simulated function bool GetTraceHeightMeters()
{
    return ConstructionClass.default.ProxyTraceHeightMeters;
}

defaultproperties
{
    ClickSound=Sound'ROMenuSounds.msfxMouseClick'
    ControlsMessageClass=class'DHConstructionControlsMessage'
    DrawScale=0.0
}
