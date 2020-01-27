//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovProjectile extends DH_M34GrenadeProjectile;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    RotationRate.Pitch = -( 90000 + Rand(30000) );
    // RandSpin( 100000.0 );
}

defaultproperties
{
    MyDamageType = class'DHBurningDamageType'
    
    StaticMesh = StaticMesh'DH_WeaponPickups.Projectile.MolotovCocktail_throw'
    
    Damage = 80.0
    DamageRadius = 160.0
    Speed = 800.0
}
