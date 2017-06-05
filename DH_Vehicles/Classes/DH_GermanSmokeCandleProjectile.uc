//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_GermanSmokeCandleProjectile extends DHMortarProjectileSmoke; // German 90mm 'Schnellnebelkerze 39' smoke candle launched from vehicle smoke launcher

// Modified to add a little hack to prevent smoke projectile fired from early StuG from exploding on its roof-mounted MG gunshield if fired backwards
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    if (DH_Stug3GMountedMG(Other) != none && VehicleWeaponPawn(Instigator) != none && Other.Base == VehicleWeaponPawn(Instigator).VehicleBase && Other.Base != none)
    {
        return;
    }

    super.ProcessTouch(Other, HitLocation);
}

defaultproperties
{
    MaxSpeed=1500.0 // lands 60 to 65m away
    Speed=1500.0
}
