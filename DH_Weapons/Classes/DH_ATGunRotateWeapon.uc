//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_ATGunRotateWeapon extends DH_ProxyWeapon;

function DHActorProxy CreateProxyCursor()
{
    local DHATGunProxy Proxy;
    local DHATGun Gun;

    Gun = DHPawn(Instigator).GunToRotate;

    Proxy = Spawn(class'DHATGunProxy', Instigator,, Gun.Location, Gun.Rotation);
    Proxy.SetGun(Gun);

    return Proxy;
}

simulated function float GetLocalRotationRate()
{
    return 512;
}

defaultproperties
{
}

