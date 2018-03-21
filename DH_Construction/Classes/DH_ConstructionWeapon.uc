//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ConstructionWeapon extends DHWeapon;

var class<DHConstruction>   ConstructionClass;
var DHConstructionProxy     Proxy;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerCreateConstruction;
}

simulated event Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    // HACK: This inventory system doesn't like what we're trying to do with it.
    // This bit of garbage saves us if we get into a state where the proxy has
    // been destroyed but the weapon is still hanging around.
    if (Role < ROLE_Authority && InstigatorIsLocallyControlled())
    {
        if (Proxy == none && Instigator.Weapon == self && Instigator.Weapon.OldWeapon == none)
        {
            // We've no weapon to go back to so just put this down, subsequently destroying it
            PutDown();
            Instigator.Controller.SwitchToBestWeapon();
            Instigator.ChangedWeapon();
        }
    }
}

simulated function Destroyed()
{
    if (Proxy != none)
    {
        Proxy.Destroy();
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
        if (Proxy != none)
        {
            Proxy.Destroy();
        }

        Proxy = Spawn(class'DHConstructionProxy', Instigator);
        Proxy.SetConstructionClass(default.ConstructionClass);
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
    if (Proxy != none)
    {
        Proxy.Destroy();
    }

    return super.PutDown();
}

simulated function ROIronSights()
{
    local ROPawn P;

    P = ROPawn(Instigator);

    if (InstigatorIsLocallyControlled() && P != none && P.CanSwitchWeapon())
    {
        if (Proxy != none)
        {
            Proxy.Destroy();
        }

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

simulated function Fire(float F)
{
    if (InstigatorIsLocallyControlled())
    {
        if (Proxy != none && Proxy.ProxyError.Type == ERROR_None)
        {
            ServerCreateConstruction(Proxy.ConstructionClass, Proxy.GroundActor, Proxy.Location, Proxy.Rotation);
            Proxy.Destroy();

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
    }
}

simulated function AltFire(float F) { }

// Modified to simply reset the location rotation of the proxy.
simulated exec function ROManualReload()
{
    if (Proxy != none)
    {
        // This resets the proxy.
        // TODO: make this a bit more readable, use 'Reset'?
        Proxy.SetConstructionClass(Proxy.ConstructionClass);
    }
}

simulated function bool WeaponLeanLeft()
{
    if (Proxy != none)
    {
        if (Proxy.ConstructionClass.default.bSnapRotation)
        {
            Proxy.LocalRotation.Yaw -= Proxy.ConstructionClass.default.RotationSnapAngle;
        }
        else
        {
            Proxy.LocalRotationRate.Yaw = -Proxy.ConstructionClass.default.LocalRotationRate;
        }

        return true;
    }

    return false;
}

simulated function bool WeaponLeanRight()
{
    if (Proxy != none)
    {
        if (Proxy.ConstructionClass.default.bSnapRotation)
        {
            Proxy.LocalRotation.Yaw += Proxy.ConstructionClass.default.RotationSnapAngle;
        }
        else
        {
            Proxy.LocalRotationRate.Yaw = Proxy.ConstructionClass.default.LocalRotationRate;
        }

        return true;
    }

    return false;
}

simulated function WeaponLeanLeftReleased()
{
    if (Proxy != none)
    {
        Proxy.LocalRotationRate.Yaw = 0;
    }
}

simulated function WeaponLeanRightReleased()
{
    if (Proxy != none)
    {
        Proxy.LocalRotationRate.Yaw = 0;
    }
}

// TODO: This hardly seems like the right place to put the construction supply
// extraction logic!
function ServerCreateConstruction(class<DHConstruction> ConstructionClass, Actor Owner, vector L, rotator R)
{
    local DHConstruction C;
    local DHPawn P;
    local DHConstruction.Context Context;
    local DHConstructionProxy TestProxy;
    local DHConstruction.ConstructionError Error;

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
    TestProxy.SetLocation(L);
    TestProxy.SetRotation(R);

    Error = TestProxy.GetPositionError();

    TestProxy.Destroy();

    if (Error.Type != ERROR_None)
    {
        return;
    }

    P = DHPawn(Instigator);

    if (P == none || !P.UseSupplies(ConstructionClass.static.GetSupplyCost(Context)))
    {
        return;
    }

    C = Spawn(ConstructionClass, Owner,, L, R);

    if (C != none)
    {
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
