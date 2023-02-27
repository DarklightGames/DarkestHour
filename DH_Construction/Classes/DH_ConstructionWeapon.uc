//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ConstructionWeapon extends DH_ProxyWeapon;

var class<DHConstruction>       ConstructionClass;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerCreateConstruction;
}

simulated function OnTick(float DeltaTime)
{
    local Actor HitActor;
    local vector HitLocation, HitNormal;
    local PlayerController PC;
    local DHConstructionProxy CP;

    if (ProxyCursor != none)
    {
        PC = PlayerController(Instigator.Controller);

        TraceFromPlayer(HitActor, HitLocation, HitNormal);

        CP = DHConstructionProxy(ProxyCursor);

        if (CP != none)
        {
            CP.UpdateParameters(HitLocation, PC.CalcViewRotation, HitActor, HitNormal);

            if (CP.ProxyError.Type != ERROR_None)
            {
                Instigator.ReceiveLocalizedMessage(class'DHConstructionErrorMessage', int(CP.ProxyError.Type),,, ProxyCursor);
            }
            else
            {
                Instigator.ReceiveLocalizedMessage(class'DHConstructionControlsMessage',,,, Instigator.Controller);
            }
        }
    }
}

simulated function DHActorProxy CreateProxyCursor()
{
    local DHConstructionProxy Cursor;

    Cursor = Spawn(class'DHConstructionProxy', Instigator);
    Cursor.SetConstructionClass(default.ConstructionClass);

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
        ServerCreateConstruction(ConstructionClass, CP.GroundActor, ProxyCursor.Location, ProxyCursor.Rotation);
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

simulated function TraceFromPlayer(out Actor HitActor, out vector HitLocation, out vector HitNormal)  // TODO: this needs to output a location and groundactor?
{
    local PlayerController PC;
    local Actor TempHitActor;
    local vector TraceStart, TraceEnd;

    if (Instigator == none)
    {
        return;
    }

    PC = PlayerController(Instigator.Controller);

    // Trace out into the world and try and hit something static.
    TraceStart = Instigator.Location + Instigator.EyePosition();
    TraceEnd = TraceStart + (vector(PC.CalcViewRotation) * class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProxyTraceDepthMeters));

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

// TODO: This hardly seems like the right place to put the construction supply extraction logic!
function ServerCreateConstruction(class<DHConstruction> ConstructionClass, Actor Owner, vector Location, rotator Rotation)
{
    local DHConstruction C;
    local DHPawn P;
    local DHActorProxy.Context Context;
    local DHConstructionProxy TestProxy;
    local DHConstruction.ConstructionError Error;
    local array<DHConstructionSupplyAttachment.Withdrawal> Withdrawals;

    if (Instigator == none)
    {
        return;
    }

    Context.TeamIndex = Instigator.GetTeamNum();
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(Level);
    Context.PlayerController = DHPlayer(Instigator.Controller);

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

    if (C != none)
    {
        C.InstigatorController = DHPlayer(Instigator.Controller);

        if (!C.bIsNeutral)
        {
            C.SetTeamIndex(Instigator.GetTeamNum());
        }

        C.UpdateAppearance();
        C.OnSpawnedByPlayer();
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
    }
}
