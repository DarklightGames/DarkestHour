//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PegasusGun extends DH_Flak88Gun;

defaultproperties
{
    bTeamLocked=false    // this gun is specifically for the Pegasus Bridge map, where the Brits can capture the gun
    MaxDesireability=0.0 // make bots ignore the gun, otherwise the Brit bots all go for the gun & ignore the bridge
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_PegasusGunPawn')
}
