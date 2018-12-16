//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_ATGunRotateWeapon extends DH_ProxyWeapon;

var DHATGun Gun;

simulated function PostBeginPlay()
{
    local DHPawn P;

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
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
    }
}

simulated function DHActorProxy CreateProxyCursor()
{
    local DHATGunProxy Proxy;

    Proxy = Spawn(class'DHATGunProxy', Instigator,, Gun.Location, Gun.Rotation);
    Proxy.SetGun(Gun);

    return Proxy;
}

simulated function float GetLocalRotationRate()
{
    return 8192;
}

simulated function OnConfirmPlacement()
{
    if (Gun == none || ProxyCursor == none)
    {
        return;
    }

    Gun.ServerRotate(ProxyCursor.Rotation);
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

