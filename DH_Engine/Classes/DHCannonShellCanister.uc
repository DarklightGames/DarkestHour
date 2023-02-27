//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCannonShellCanister extends DHBullet;

var int NumberOfProjectilesPerShot; // the number of separate small projectiles launched by each canister shot

defaultproperties
{
    NumberOfProjectilesPerShot=20
    WhizType=2
    BallisticCoefficient=4.0
    Speed=45988.0
    Damage=120.0
    MyDamageType=class'DH_Engine.DHCanisterShotDamageType'
}
