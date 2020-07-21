//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_IncendiaryBottleNo1Projectile extends DHThrowableIncendiaryProjectile;

defaultproperties
{
    PickupClass=class'DH_Weapons.DH_IncendiaryBottleNo1Pickup'
    StaticMesh=StaticMesh'DH_IncendiaryBottles_stc.Weapons.BottleNo1'

    // Sound
    ExplosionSoundRadius=300.0
    ExplosionSound(0)=Sound'DH_MolotovCocktail.explosion1'
    ExplosionSound(1)=Sound'DH_MolotovCocktail.explosion2'
    ExplosionSound(2)=Sound'DH_MolotovCocktail.explosion3'
}
