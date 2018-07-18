//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_ConstructionWeapon extends DHWeapon;

var class<DHConstruction>       ConstructionClass;

var array<DHConstructionProxy>  ControlPoints;
var array<DHConstructionProxy>  Proxies;
var array<DHConstructionProxy>  Pool;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerCreateConstruction;
}

simulated function DHConstructionProxy GetProxyCursor()
{
    if (ControlPoints.Length == 0)
    {
        return none;
    }

    return ControlPoints[ControlPoints.Length - 1];
}

simulated event Tick(float DeltaTime)
{
    local Actor HitActor;
    local vector HitLocation, HitNormal;
    local PlayerController PC;
    local DHConstructionProxy ProxyCursor;

    super.Tick(DeltaTime);

    if (InstigatorIsLocallyControlled())
    {
        ProxyCursor = GetProxyCursor();

        if (ProxyCursor != none)
        {
            PC = PlayerController(Instigator.Controller);

            TraceFromPlayer(HitActor, HitLocation, HitNormal);

            ProxyCursor.UpdateParameters(HitLocation, PC.CalcViewRotation, HitActor, HitNormal);

            if (ProxyCursor.ProxyError.Type != ERROR_None)
            {
                Instigator.ReceiveLocalizedMessage(class'DHConstructionErrorMessage', int(ProxyCursor.ProxyError.Type),,, ProxyCursor);
            }
            else
            {
                Instigator.ReceiveLocalizedMessage(class'DHConstructionControlsMessage',,,, Instigator.Controller);
            }
        }

        UpdateSamples();

        // HACK: This inventory system doesn't like what we're trying to do with it.
        // This bit of garbage saves us if we get into a state where the proxy has
        // been destroyed but the weapon is still hanging around.
        if (GetProxyCursor() == none && Instigator.Weapon == self && Instigator.Weapon.OldWeapon == none)
        {
            // We've no weapon to go back to so just put this down, subsequently destroying it
            PutDown();
            Instigator.Controller.SwitchToBestWeapon();
            Instigator.ChangedWeapon();
        }
    }
}

simulated function UpdateSamples()
{
    local int i, j;
    local vector Forward, Start, End, SampleLocation, TraceStart, TraceEnd, HitLocation, HitNormal;
    local float LineLength, Diameter, TraceZ;
    local int SampleCount, TotalProxies;
    local int ProxyIndex;
    local DHConstructionProxy Proxy;
    local Actor HitActor;
    local rotator R;

    if (ControlPoints.Length <= 1)
    {
        return;
    }

    Diameter = ConstructionClass.static.GetPlacementDiameter();
    TraceZ = ControlPoints[0].Location.Z;

    for (i = 0; i < ControlPoints.Length - 1; ++i)
    {
        Start = ControlPoints[i].Location;
        End = ControlPoints[i + 1].Location;

        // Calculate the length of this line.
        LineLength = VSize(End - Start);
        Forward = Normal(End - Start);

        // Calculate the amount of sampling points along this segment.
        SampleCount = (LineLength - Diameter) / Diameter;

        for (j = 0; j < SampleCount; ++j)
        {
            if (ProxyIndex >= Proxies.Length)
            {
                if (Pool.Length == 0)
                {
                    // TODO: make a new one if necessary
                }

                Proxies[Proxies.Length] = Pool[Pool.Length - 1];
                Pool.Remove(Pool.Length - 1, 1);
            }

            Proxy = Proxies[ProxyIndex++];
            Proxy.bHidden = false;

            SampleLocation = Start + ((Forward * Diameter) * (j + 1));
            SampleLocation.Z = TraceZ;
            TraceStart = SampleLocation;
            TraceStart.Z += 100.0;  // TODO: magic numbers
            TraceEnd = SampleLocation;
            TraceEnd.Z -= 100.0;

            R = rotator(Forward);

            foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
            {
                if (HitActor.bStatic && !HitActor.IsA('Volume'))
                {
                    TraceZ = HitLocation.Z;
                    Proxy.UpdateParameters(HitLocation, R, HitActor, HitNormal);
                    break;
                }
            }

            ++TotalProxies;
        }
    }

    // Move all unused proxies back to the pool.
    while (Proxies.Length > TotalProxies)
    {
        Proxies[Proxies.Length - 1].bHidden = true;
        Pool[Pool.Length] = Proxies[Proxies.Length - 1];
        Proxies.Remove(Proxies.Length - 1, 1);
    }
}

simulated function DestroyProxies()
{
    local int i;

    for (i = 0; i < Proxies.Length; ++i)
    {
        if (Proxies[i] != none)
        {
            Proxies[i].Destroy();
        }
    }

    for (i = 0; i < Pool.Length; ++i)
    {
        if (Pool[i] != none)
        {
            Pool[i].Destroy();
        }
    }

    for (i = 0; i < ControlPoints.Length; ++i)
    {
        if (ControlPoints[i] != none)
        {
            ControlPoints[i].Destroy();
        }
    }
}

simulated function Destroyed()
{
    DestroyProxies();

    super.Destroyed();
}

// Modified to create the construction proxy here and also to remove the HasAmmo
// check when setting the OldWeapon since we don't care if the last weapon has
// ammo or not, we still want to switch back it after we're done.
simulated function BringUp(optional Weapon PrevWeapon)
{
    local DHConstructionProxy Proxy;

    HandleSleeveSwapping();

    if (ROPlayer(Instigator.Controller) != none)
    {
        ROPlayer(Instigator.Controller).FAAWeaponRotationFactor = FreeAimRotationSpeed;
    }

    GotoState('RaisingWeapon');

    if (PrevWeapon != none && !PrevWeapon.bNoVoluntarySwitch)
    {
        OldWeapon = PrevWeapon;
    }
    else
    {
        OldWeapon = none;
    }

    ResetPlayerFOV();

    if (InstigatorIsLocallyControlled())
    {
        DestroyProxies();

        while (Pool.Length < 10)   // TODO: magic number
        {
            Proxy = Spawn(class'DHConstructionProxy', Instigator);
            Proxy.SetConstructionClass(ConstructionClass);
            Proxy.bIsInterpolated = true;
            Proxy.bHidden = true;
            Pool[Pool.Length] = Proxy;
        }

        ControlPoints[ControlPoints.Length] = Spawn(class'DHConstructionProxy', Instigator);

        GetProxyCursor().SetConstructionClass(default.ConstructionClass);
    }
}

simulated state LoweringWeapon
{
    simulated function BeginState()
    {
        // NOTE: The !bDeleteMe and GotoState('Idle') are integral to stop
        // stack overflows!
        if (Role == ROLE_Authority && !bDeleteMe)
        {
            GotoState('Idle');
            SelfDestroy();
        }

        super.BeginState();
    }

    simulated function EndState()
    {
        if (!bDeleteMe)
        {
            super.EndState();
        }
    }
}

simulated function bool PutDown()
{
    DestroyProxies();

    return super.PutDown();
}

simulated function ROIronSights()
{
    local ROPawn P;

    P = ROPawn(Instigator);

    if (InstigatorIsLocallyControlled())
    {
        GetProxyCursor().Destroy();

        ControlPoints.Length = ControlPoints.Length - 1;

        if (GetProxyCursor() == none && P != none && P.CanSwitchWeapon())
        {
            DestroyProxies();

            if (Instigator.Weapon.OldWeapon != none)
            {
                Instigator.SwitchToLastWeapon();
                Instigator.ChangedWeapon();
            }
            else
            {
                // We've no weapon to go back to so just put this down, subsequently
                // destroying it.
                PutDown();
                Instigator.Controller.SwitchToBestWeapon();
            }
        }
    }
}

simulated function Fire(float F)
{
    local DHConstructionProxy ProxyCursor;
    local int i;

    if (InstigatorIsLocallyControlled())
    {
        ProxyCursor = GetProxyCursor();

        for (i = 0; i < ControlPoints.Length; ++i)
        {
            if (ControlPoints[i].ProxyError.Type != ERROR_None)
            {
                // TODO: send a message to the user that one or more of their control points is no good
                return;
            }
        }

        for (i = 0; i < ControlPoints.Length; ++i)
        {
            ServerCreateConstruction(ConstructionClass, ControlPoints[i].GroundActor, ControlPoints[i].Location, ControlPoints[i].Rotation);
        }

        for (i = 0; i < Proxies.Length; ++i)
        {
            ServerCreateConstruction(ConstructionClass, Proxies[i].GroundActor, Proxies[i].Location, Proxies[i].Rotation);
        }

        if (ConstructionClass.default.bShouldSwitchToLastWeaponOnPlacement)
        {
            DestroyProxies();

            if (Instigator.Weapon.OldWeapon != none)
            {
                // HACK: This stops a standalone client from immediately firing
                // their previous weapon.
                if (Level.NetMode == NM_Standalone)
                {
                    Instigator.Weapon.OldWeapon.ClientState = WS_Hidden;
                }

                Instigator.SwitchToLastWeapon();
                Instigator.ChangedWeapon();
            }
            else
            {
                PutDown();
                Instigator.Controller.SwitchToBestWeapon();
            }
        }
        else
        {
            ControlPoints.Length = 1;
        }
    }
}

simulated function TraceFromPlayer(out Actor HitActor, out vector HitLocation, out vector HitNormal)  // TODO: this needs to output a location and groundactor?
{
    local PlayerController PC;
    local Actor TempHitActor;
    local vector TraceStart, TraceEnd, Delta;
    local float Size, Diameter;

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

    if (ConstructionClass.default.bCanBePlacedWithControlPoints && ControlPoints.Length > 1)
    {
        Delta = HitLocation - ControlPoints[ControlPoints.Length - 2].Location;
        Size = VSize(Delta);
        Diameter = ConstructionClass.static.GetPlacementDiameter();
        HitLocation = ControlPoints[ControlPoints.Length - 2].Location + (Normal(Delta) * (Diameter * int(Size / Diameter) + 1));
    }
}

simulated function AltFire(float F)
{
    local DHConstructionProxy ProxyCursor, ControlPoint;

    if (!ConstructionClass.default.bCanBePlacedWithControlPoints)
    {
        // TODO: message to user that this doesn't support control point placement
        return;
    }

    ProxyCursor = GetProxyCursor();

    if (ProxyCursor == none || ProxyCursor.ProxyError.Type != ERROR_None)
    {
        return;
    }

    ControlPoint = Spawn(class'DHConstructionProxy', Instigator);
    ControlPoint.SetConstructionClass(ConstructionClass);
    ControlPoint.SetLocation(ProxyCursor.Location);
    ControlPoint.SetRotation(ProxyCursor.Rotation);
    ControlPoints[ControlPoints.Length] = ControlPoint;
}

// Modified to simply reset the location rotation of the proxy.
simulated exec function ROManualReload()
{
    local DHConstructionProxy ProxyCursor;

    ProxyCursor = GetProxyCursor();

    if (ProxyCursor != none)
    {
        // This resets the proxy.
        // TODO: make this a bit more readable, use 'Reset'?
        ProxyCursor.SetConstructionClass(ProxyCursor.ConstructionClass);
    }
}

simulated function bool WeaponLeanLeft()
{
    local DHConstructionProxy ProxyCursor;

    ProxyCursor = GetProxyCursor();

    if (ProxyCursor != none)
    {
        if (ProxyCursor.ConstructionClass.default.bSnapRotation)
        {
            ProxyCursor.LocalRotation.Yaw -= ProxyCursor.ConstructionClass.default.RotationSnapAngle;
        }
        else
        {
            ProxyCursor.LocalRotationRate.Yaw = -ProxyCursor.ConstructionClass.default.LocalRotationRate;
        }

        return true;
    }

    return false;
}

simulated function bool WeaponLeanRight()
{
    local DHConstructionProxy ProxyCursor;

    ProxyCursor = GetProxyCursor();

    if (ProxyCursor != none)
    {
        if (ProxyCursor.ConstructionClass.default.bSnapRotation)
        {
            ProxyCursor.LocalRotation.Yaw += ProxyCursor.ConstructionClass.default.RotationSnapAngle;
        }
        else
        {
            ProxyCursor.LocalRotationRate.Yaw = ProxyCursor.ConstructionClass.default.LocalRotationRate;
        }

        return true;
    }

    return false;
}

simulated function WeaponLeanLeftReleased()
{
    local DHConstructionProxy ProxyCursor;

    ProxyCursor = GetProxyCursor();

    if (ProxyCursor != none)
    {
        ProxyCursor.LocalRotationRate.Yaw = 0;
    }
}

simulated function WeaponLeanRightReleased()
{
    local DHConstructionProxy ProxyCursor;

    ProxyCursor = GetProxyCursor();

    if (ProxyCursor != none)
    {
        ProxyCursor.LocalRotationRate.Yaw = 0;
    }
}

// TODO: This hardly seems like the right place to put the construction supply extraction logic!
function ServerCreateConstruction(class<DHConstruction> ConstructionClass, Actor Owner, vector Location, rotator Rotation)
{
    local DHConstruction C;
    local DHPawn P;
    local DHConstruction.Context Context;
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
    }
}

defaultproperties
{
    SprintStartAnim="crawl_in"
    SprintLoopAnim="crawl_in"
    SprintEndAnim="crawl_in"
    CrawlForwardAnim="crawl_in"
    CrawlBackwardAnim="crawl_in"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_in"
    FireModeClass(0)=Class'DH_Weapons.DH_EmptyFire'
    FireModeClass(1)=Class'DH_Weapons.DH_EmptyFire'
    RestAnim="crawl_in"
    AimAnim="crawl_in"
    RunAnim="crawl_in"
    SelectAnim="crawl_in"
    PutDownAnim="crawl_in"
    bCanThrow=false
    Priority=100
    bUsesFreeAim=false
    bCanSway=false
    InventoryGroup=1
    PlayerViewOffset=(X=-6.000000,Y=-6.000000,Z=100000.000000)
    PlayerViewPivot=(Roll=-2730)
    AttachmentClass=Class'DH_Weapons.DH_EmptyAttachment'
    ItemName=" "
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_US'
    bForceSwitch=false
    bNoVoluntarySwitch=true
}
