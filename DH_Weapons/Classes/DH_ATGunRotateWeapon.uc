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
    local vector HitLocation, HitNormal, CrossProduct, Forward, TraceStart, TraceEnd;

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

    // Get the orientation of the gun (aligned to the ground that it's on)
    TraceStart = Gun.Location;
    TraceEnd = TraceStart - vect(0, 0, 64);

    Trace(HitLocation, HitNormal, TraceEnd, TraceStart);

    CrossProduct = HitNormal cross vector(Gun.Rotation);
    Forward = HitNormal cross CrossProduct;

    Proxy = Spawn(class'DHATGunProxy', Instigator,, Gun.Location, rotator(Forward));
    Proxy.SetGun(Gun);

    return Proxy;
}

simulated function float GetLocalRotationRate()
{
    return 4096;
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

