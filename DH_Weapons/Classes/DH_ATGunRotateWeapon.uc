//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_ATGunRotateWeapon extends DHWeapon;

var DHATGun Gun;

replication
{
    reliable if (Role < ROLE_Authority)
        ServerUpdateRotationDirection, ServerExitRotation, ServerEnterRotation;
}

simulated function bool ShouldSwitchToLastWeaponOnPlacement()
{
    return true;
}

simulated event Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (InstigatorIsLocallyControlled())
    {
        if (Instigator == none)
        {
             Log("-- instigator probably died");
             OnExitRotation();
        }

        // HACK: This inventory system doesn't like what we're trying to do with it.
        // This bit of garbage saves us if we get into a state where the proxy has
        // been destroyed but the weapon is still hanging around.
        if (Gun == none && Instigator.Weapon == self && Instigator.Weapon.OldWeapon == none)
        {
            // We've no weapon to go back to so just put this down, subsequently destroying it
            PutDown();
            Instigator.Controller.SwitchToBestWeapon();
            Instigator.ChangedWeapon();
        }
    }
}

simulated function OnEnterRotation()
{
    local DHPawn P;

    P = DHPawn(Instigator);

    Log(":: OnEnterRotation");

    if (P == none)
    {
        Log(":: > no instigator");

        Destroy();
        return;
    }

    Gun = P.GunToRotate;

    if (Gun == none)
    {
        Log(":: > no gun");

        Destroy();
        return;
    }
    else
    {
        ServerEnterRotation(Gun, P);
    }

}

function ServerEnterRotation(DHATGun Gun, DHPawn Instigator)
{
    Gun.ServerEnterRotation(Instigator);
}

simulated function OnExitRotation()
{
    Log(":: OnExitRotation");

    if (Gun != none)
    {
        ServerExitRotation(Gun);
    }
}

function ServerExitRotation(DHATGun Gun)
{
    Gun.ServerExitRotation();
}

// RotationDirection: 0 - none; 1 - cw; 255 - ccw
simulated function OnUpdateRotationDirection(byte RotationDirection)
{
    Log(":: OnUpdateRotationDirection" @ string(RotationDirection));

    if (Gun != none)
    {
        ServerUpdateRotationDirection(Gun, RotationDirection);
    }
}

function ServerUpdateRotationDirection(DHATGun Gun, byte RotationDirection)
{
    Gun.ServerUpdateRotationDirection(RotationDirection);
}

simulated function bool WeaponLeanLeft()
{
    if (Gun != none)
    {
        OnUpdateRotationDirection(255);
        return true;
    }

    return false;
}

simulated function bool WeaponLeanRight()
{
    if (Gun != none)
    {
        OnUpdateRotationDirection(1);
        return true;
    }

    return false;
}

simulated function WeaponLeanLeftReleased()
{
    if (Gun != none)
    {
        OnUpdateRotationDirection(0);
    }
}

simulated function WeaponLeanRightReleased()
{
    if (Gun != none)
    {
        OnUpdateRotationDirection(0);
    }
}

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
        OnEnterRotation();
    }
}

simulated function ROIronSights()
{
    local ROPawn P;

    P = ROPawn(Instigator);

    if (InstigatorIsLocallyControlled())
    {
        if (P != none && P.CanSwitchWeapon())
        {
            OnEnterRotation();

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

simulated function Fire(float F)
{
    if (InstigatorIsLocallyControlled())
    {
        OnExitRotation();

        if (ShouldSwitchToLastWeaponOnPlacement())
        {
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

simulated function bool PutDown()
{
    if (InstigatorIsLocallyControlled())
    {
        OnExitRotation();
    }

    return super.PutDown();
}

simulated function Destroyed()
{
    super.Destroyed();

    if (InstigatorIsLocallyControlled())
    {
        OnExitRotation();
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
