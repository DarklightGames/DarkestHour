//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SovietMolotovProjectile extends DHThrowableIncendiaryProjectile;



defaultproperties
{
    PickupClass=class'DH_Weapons.DH_SovietMolotovPickup'
    StaticMesh=StaticMesh'DH_Molotovs_stc.SovietMolotov_world' //TODO: Import bottle Static Mesh

    bBounce=false 

    // Sound
    ExplosionSoundRadius=300.0
    ExplosionSound(0)=Sound'DH_MolotovCocktail.explosion1'
    ExplosionSound(1)=Sound'DH_MolotovCocktail.explosion1'
    ExplosionSound(2)=Sound'DH_MolotovCocktail.explosion1'
    SurfaceHits(0)=Sound'DH_MolotovCocktail.explosion1' // EST_Default,
    SurfaceHits(1)=Sound'DH_MolotovCocktail.explosion1' // EST_Rock,
    SurfaceHits(2)=Sound'DH_MolotovCocktail.explosion1' // EST_Dirt,
    SurfaceHits(3)=Sound'DH_MolotovCocktail.explosion1' // EST_Metal,
    SurfaceHits(4)=Sound'DH_MolotovCocktail.explosion1' // EST_Wood,
    SurfaceHits(5)=Sound'DH_MolotovCocktail.explosion1' // EST_Plant,
    SurfaceHits(6)=Sound'DH_MolotovCocktail.explosion1' // EST_Flesh,
    SurfaceHits(7)=Sound'DH_MolotovCocktail.explosion1' // EST_Ice,
    SurfaceHits(8)=Sound'DH_MolotovCocktail.explosion1' // EST_Snow,
    SurfaceHits(9)=Sound'DH_MolotovCocktail.explosion1' // EST_Water,
    SurfaceHits(10)=Sound'DH_MolotovCocktail.explosion1' // EST_Glass,
    SurfaceHits(11)=Sound'DH_MolotovCocktail.explosion1' // EST_Gravel,
    SurfaceHits(12)=Sound'DH_MolotovCocktail.explosion1' // EST_Concrete,
    SurfaceHits(13)=Sound'DH_MolotovCocktail.explosion1' // EST_HollowWood,
    SurfaceHits(14)=Sound'DH_MolotovCocktail.explosion1' // EST_Mud,
    SurfaceHits(15)=Sound'DH_MolotovCocktail.explosion1' // EST_MetalArmor,
    SurfaceHits(16)=Sound'DH_MolotovCocktail.explosion1' // EST_Paper,
    SurfaceHits(17)=Sound'DH_MolotovCocktail.explosion1' // EST_Cloth,
    SurfaceHits(18)=Sound'DH_MolotovCocktail.explosion1' // EST_Rubber,
    SurfaceHits(19)=Sound'DH_MolotovCocktail.explosion1' // EST_Poop
}
