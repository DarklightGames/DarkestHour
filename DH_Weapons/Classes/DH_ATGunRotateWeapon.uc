//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ATGunRotateWeapon extends DHWeapon
    dependson(DHATGun);

var DHATGun Gun;

replication
{
    reliable if (Role < ROLE_Authority)
        ServerRotate, ServerExitRotation, ServerEnterRotation;
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
        if (Gun != none && DHPawn(Instigator).GunToRotate != none)
        {
            Instigator.ReceiveLocalizedMessage(class'DHATGunRotateControlsMessage',,,, Instigator.Controller);
        }
        else
        {
            OnExitRotation();
        }
    }
}

simulated function OnEnterRotation()
{
    local DHPawn P;

    P = DHPawn(Instigator);

    if (P == none)
    {
        Destroy();
        return;
    }

    Gun = P.GunToRotate;

    if (Gun == none)
    {
        Destroy();
        return;
    }
    else
    {
        if (InstigatorIsLocallyControlled())
        {
            Gun.ClientEnterRotation();
        }

        ServerEnterRotation(Gun, P);
    }
}

function ServerEnterRotation(DHATGun Gun, DHPawn Pawn)
{
    if (Gun != none)
    {
        Gun.ServerEnterRotation(Pawn);
    }
}

simulated function OnExitRotation()
{
    if (bDeleteMe || !InstigatorIsLocallyControlled() || Gun == none || !Gun.bIsBeingRotated)
    {
        return;
    }

    if (Gun != none)
    {
        ServerExitRotation(Gun);
        Gun = none;
    }
}

function ServerExitRotation(DHATGun Gun)
{
    if (Gun != none)
    {
        Gun.ServerExitRotation();
    }
}

simulated function OnRotate(byte InputRotationFactor)
{
    if (Gun != none)
    {
        ServerRotate(Gun, InputRotationFactor);
    }
}

function ServerRotate(DHATGun Gun, byte InputRotationFactor)
{
    if (Gun != none)
    {
        Gun.ServerRotate(InputRotationFactor);
    }
}

simulated function bool WeaponLeanLeft()
{
    OnRotate(255);
    return true;
}

simulated function bool WeaponLeanRight()
{
    OnRotate(1);
    return true;
}

simulated function WeaponLeanLeftReleased()
{
    OnRotate(0);
}

simulated function WeaponLeanRightReleased()
{
    OnRotate(0);
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
    OnExitRotation();
}

simulated function ROIronSights()
{
    OnExitRotation();
}

simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    OnExitRotation();

    return super.PrevWeapon(CurrentChoice, CurrentWeapon);
}

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    OnExitRotation();

    return super.NextWeapon(CurrentChoice, CurrentWeapon);
}

simulated function bool PutDown()
{
    return super.PutDown();
}

simulated function Destroyed()
{
    super.Destroyed();

    OnExitRotation();
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
    FireModeClass(0)=class'DH_Weapons.DH_EmptyFire'
    FireModeClass(1)=class'DH_Weapons.DH_EmptyFire'
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
    AttachmentClass=class'DH_Weapons.DH_EmptyAttachment'
    ItemName=" "
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_US'
    bForceSwitch=false
    bNoVoluntarySwitch=true
}
