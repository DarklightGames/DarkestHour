//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHActorProxyWeapon extends DHWeapon;

var DHActorProxy                    ProxyCursor;

var class<DHActorProxyErrorMessage> ErrorMessageClass;
var class<DHControlsMessage>        ControlsMessageClass;

var() int                           LocalRotationRate;
var() protected float               TraceDepthMeters;
var() protected float               TraceHeightMeters;

simulated function DHActorProxy CreateProxyCursor();
simulated function OnConfirmPlacement();
simulated function bool ShouldSnapRotation();
simulated function float GetRotationSnapAngle();
simulated function float GetLocalRotationRate() { return LocalRotationRate; }
simulated function ResetCursor();

simulated function bool ShouldSwitchToLastWeaponOnPlacement()
{
    return true;
}

simulated event Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (InstigatorIsLocallyControlled())
    {
        OnTick(DeltaTime);

        // HACK: This inventory system doesn't like what we're trying to do with it.
        // This bit of garbage saves us if we get into a state where the proxy has
        // been destroyed but the weapon is still hanging around.
        if (ProxyCursor == none && Instigator.Weapon == self && Instigator.Weapon.OldWeapon == none)
        {
            // We've no weapon to go back to so just put this down, subsequently destroying it
            PutDown();
            Instigator.Controller.SwitchToBestWeapon();
            Instigator.ChangedWeapon();
        }
    }
}

simulated function OnTick(float DeltaTime)
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal;
    local PlayerController PC;
    local int bLimitLocalRotation;
    local Range LocalRotationYawRange;

    if (ProxyCursor == none)
    {
        return;
    }

    PC = PlayerController(Instigator.Controller);

    TraceFromPlayer(HitActor, HitLocation, HitNormal, bLimitLocalRotation, LocalRotationYawRange);

    if (ProxyCursor != none)
    {
        ProxyCursor.UpdateParameters(HitLocation, PC.CalcViewRotation, HitActor, HitNormal, bool(bLimitLocalRotation), LocalRotationYawRange);

        if (ProxyCursor.ProxyError.Type != ERROR_None)
        {
            if (ErrorMessageClass != none)
            {
                Instigator.ReceiveLocalizedMessage(ErrorMessageClass, int(ProxyCursor.ProxyError.Type),,, ProxyCursor);
            }
        }
        else
        {
            if (ControlsMessageClass != none)
            {
                Instigator.ReceiveLocalizedMessage(ControlsMessageClass, 0, Instigator.PlayerReplicationInfo,, ProxyCursor);
            }
        }
    }
}

simulated function Destroyed()
{
    if (ProxyCursor != none)
    {
        ProxyCursor.Destroy();
    }

    super.Destroyed();
}

// Modified to create the construction proxy here and also to remove the HasAmmo
// check when setting the OldWeapon since we don't care if the last weapon has
// ammo or not, we still want to switch back it after we're done.
simulated function BringUp(optional Weapon PrevWeapon)
{
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
        if (ProxyCursor != none)
        {
            ProxyCursor.Destroy();
        }

        ProxyCursor = CreateProxyCursor();
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
    if (ProxyCursor != none)
    {
        ProxyCursor.Destroy();
    }

    return super.PutDown();
}

simulated function ROIronSights()
{
    local ROPawn P;

    P = ROPawn(Instigator);

    if (InstigatorIsLocallyControlled())
    {
        if (P != none && P.CanSwitchWeapon())
        {
            ProxyCursor.Destroy();

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

simulated function bool CanConfirmPlacement()
{
    return true;
}

simulated function Fire(float F)
{
    if (InstigatorIsLocallyControlled())
    {
        if (!CanConfirmPlacement())
        {
            return;
        }

        OnConfirmPlacement();

        if (ShouldSwitchToLastWeaponOnPlacement())
        {
            ProxyCursor.Destroy();

            if (Instigator.Weapon != none && Instigator.Weapon.OldWeapon != none)
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
    }
}

// Modified to simply reset the location rotation of the proxy.
exec simulated function ROManualReload()
{
    ResetCursor();
}

simulated function bool WeaponLeanLeft()
{
    if (ProxyCursor != none)
    {
        if (ShouldSnapRotation())
        {
            ProxyCursor.LocalRotation.Yaw -= GetRotationSnapAngle();
        }
        else
        {
            ProxyCursor.LocalRotationRate.Yaw = -GetLocalRotationRate();
        }

        return true;
    }

    return false;
}

simulated function bool WeaponLeanRight()
{
    if (ProxyCursor != none)
    {
        if (ShouldSnapRotation())
        {
            ProxyCursor.LocalRotation.Yaw += GetRotationSnapAngle();
        }
        else
        {
            ProxyCursor.LocalRotationRate.Yaw = GetLocalRotationRate();
        }

        return true;
    }

    return false;
}

simulated function WeaponLeanLeftReleased()
{
    if (ProxyCursor != none)
    {
        ProxyCursor.LocalRotationRate.Yaw = 0;
    }
}

simulated function WeaponLeanRightReleased()
{
    if (ProxyCursor != none)
    {
        ProxyCursor.LocalRotationRate.Yaw = 0;
    }
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
    local DHActorProxySocket Socket;

    bLimitLocalRotation = 0;

    if (Instigator == none)
    {
        return;
    }

    PC = PlayerController(Instigator.Controller);

    // Trace out into the world and try and hit something static.
    TraceStart = Instigator.Location + Instigator.EyePosition();
    TraceEnd = TraceStart + (Vector(PC.CalcViewRotation) * class'DHUnits'.static.MetersToUnreal(GetTraceDepthMeters()));

    // TODO: make a function that evaluates whether sockets are valid.

    // Trace for location hints.
    foreach TraceActors(class'DHActorProxySocket', Socket, HitLocation, HitNormal, TraceStart, TraceEnd)
    {
        if (Socket == none)
        {
            continue;
        }

        // TODO: add a check if the socket is appropriate.
        // This is assumed to be in ascending order of distance, so this should
        // return the nearest traced location hint.
        if (IsSocketValid(Socket))
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
        TraceEnd = TraceStart + vect(0, 0, -1) * class'DHUnits'.static.MetersToUnreal(GetTraceHeightMeters());

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

function bool IsSocketValid(DHActorProxySocket Socket);

function float GetTraceDepthMeters()
{
    return TraceDepthMeters;
}

function float GetTraceHeightMeters()
{
    return TraceHeightMeters;
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
    FireModeClass(0)=class'DH_Engine.DH_EmptyFire'
    FireModeClass(1)=class'DH_Engine.DH_EmptyFire'
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
    AttachmentClass=class'DH_Engine.DH_EmptyAttachment'
    ItemName=" "
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_US'
    bForceSwitch=false
    bNoVoluntarySwitch=true
    ErrorMessageClass=class'DHActorProxyErrorMessage'
    TraceDepthMeters=5.0
    TraceHeightMeters=2.0
    LocalRotationRate=32768
}

