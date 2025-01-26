//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHMortarHitEffect81mm extends DHHitEffect;

defaultproperties
{
    HitEffects(0)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmConcrete',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')    // Default (Dirt?)
    HitEffects(1)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmConcrete',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')    // Rock
    HitEffects(2)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')            // Dirt
    HitEffects(3)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmMetal',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')       // Metal*
    HitEffects(4)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmWood',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02')        // Wood*
    HitEffects(5)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02')        // Plant (Grass)
    HitEffects(6)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02')        // Flesh (dead animals)
    HitEffects(7)=(HitDecal=class'ArtilleryMarkSnow',HitEffect=class'DHMortarExplosion81mmSnow',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02')    // Ice
    HitEffects(8)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmSnow',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')    // Snow
    HitEffects(9)=(HitEffect=class'DHMortarExplosion81mmWater',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04')                       // Water
    HitEffects(10)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmConcrete',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')   // Glass
    HitEffects(11)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmConcrete',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')   // Gravel
    HitEffects(12)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmConcrete',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')   // Concrete
    HitEffects(13)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmWood',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')       // HollowWood*
    HitEffects(14)=(HitDecal=class'ArtilleryMarkSnow',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')       // Mud
    HitEffects(15)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmMetal',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')  // MetalArmor*
    HitEffects(16)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')       // Paper
    HitEffects(17)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')       // Cloth
    HitEffects(18)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03')       // Rubber
    HitEffects(19)=(HitDecal=class'ArtilleryMarkSnow',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')       // Poop

    //DH Custom impacts
    HitEffects(21)=(HitDecal=class'ArtilleryMarkSnow',HitEffect=class'DHMortarExplosion81mmSand',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')   // Sand EST_Custom01
    HitEffects(22)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmSand',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')   // Sand Bags EST_Custom02
    HitEffects(23)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mmBrick',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')      // Brick EST_Custom03
    HitEffects(24)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'DHMortarExplosion81mm',HitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01')       // Hedgerow-Bush EST_Custom04

    TransientSoundVolume=6.0
    MinSoundRadius=5300.0
    MaxSoundRadius=5500.0
    bAlwaysRelevant=true
}
