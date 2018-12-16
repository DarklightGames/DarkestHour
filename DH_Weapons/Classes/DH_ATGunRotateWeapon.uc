//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_ATGunRotateWeapon extends DH_ProxyWeapon;

var DHATGun Gun;

replication
{
    reliable if (Role < ROLE_Authority)
        ServerRotate;
}

simulated function DHActorProxy CreateProxyCursor()
{
    local DHATGunProxy Proxy;
    local DHPawn P;

    P = DHPawn(Instigator);

    if (P == none)
    {
        Destroy();
    }

    Gun = P.GunToRotate;

    if (Gun == none)
    {
        Destroy();
    }

    // Hide the gun locally on the client so the proxy takes center stage.
    Gun.bHidden = true;

    if (Gun == none)
    {
        Error("Attempted to create proxy cursor before Gun was assigned.");
    }

    Proxy = Spawn(class'DHATGunProxy', Instigator,, Gun.Location, Gun.Rotation);
    Proxy.SetGun(Gun);

    return Proxy;
}

simulated function float GetLocalRotationRate()
{
    return 2048;
}

simulated function OnConfirmPlacement()
{
    if (Gun == none || ProxyCursor == none)
    {
        return;
    }

    ServerRotate(Gun, ProxyCursor.Rotation);
}

function ServerRotate(DHATGun Gun, rotator TargetRotation)
{
    if (Gun != none)
    {
        Gun.RotateTo(TargetRotation);
    }
}

simulated function Destroyed()
{
    super.Destroyed();

    if (Gun != none)
    {
        Gun.bHidden = false;
    }
}

defaultproperties
{
}

