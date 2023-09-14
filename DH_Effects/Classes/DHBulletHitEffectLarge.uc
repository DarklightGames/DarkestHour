//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitEffectLarge extends DHHitEffect;


defaultproperties
{
    HitEffects(0)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitDefaultEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')          // Default (Dirt?)
    HitEffects(1)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitRockEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt')      // Rock
    HitEffects(2)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitDirtEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')             // Dirt
    HitEffects(3)=(HitDecal=class'BulletHoleMetal',HitEffect=class'DHBulletHitMetalEffectLarge',FlashEffect=class'DHFlashEffectSmall',HitSound=Sound'ProjectileSounds.PTRD_penetrate') // Metal
    HitEffects(4)=(HitDecal=class'BulletHoleWood',HitEffect=class'DHBulletHitWoodEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')             // Wood
    HitEffects(5)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitGrassEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Grass')           // Plant (Grass)
    HitEffects(6)=(HitDecal=class'BulletHoleFlesh',HitEffect=class'DHBulletHitFleshEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')            // Flesh (dead animals)
    HitEffects(7)=(HitDecal=class'BulletHoleIce',HitEffect=class'DHBulletHitIceEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')               // Ice
    HitEffects(8)=(HitDecal=class'BulletHoleSnow',HitEffect=class'DHBulletHitSnowEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')             // Snow
    HitEffects(9)=(HitEffect=class'DHBulletHitWaterEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')                                           // Water
    HitEffects(10)=(HitDecal=class'BulletHoleIce',HitEffect=class'DHBreakingGlass',HitSound=Sound'DH_ProjectileSounds.BulletImpacts.Impact_Glass')              // Glass
    HitEffects(11)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitGravelEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel')    // Gravel
    HitEffects(12)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitConcreteEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt') // Concrete
    HitEffects(13)=(HitDecal=class'BulletHoleWood',HitEffect=class'DHBulletHitWoodEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')            // HollowWood
    HitEffects(14)=(HitDecal=class'BulletHoleSnow',HitEffect=class'DHBulletHitMudEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')              // Mud
    HitEffects(15)=(HitDecal=class'BulletHoleMetalArmor',HitEffect=class'DHBulletHitMetalArmorEffectLarge',FlashEffect=class'DHFlashEffectSmall',HitSound=Sound'ProjectileSounds.PTRD_deflect') // MetalArmor
    HitEffects(16)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitPaperEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')            // Paper
    HitEffects(17)=(HitDecal=class'BulletHoleCloth',HitEffect=class'DHBulletHitClothEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')               // Cloth
    HitEffects(18)=(HitDecal=class'BulletHoleMetal',HitEffect=class'ROBulletHitRubberEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')              // Rubber
    HitEffects(19)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitMudEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')                   // Poop

    // DH Custom impacts
    HitEffects(21)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitSandEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel')               // Sand EST_Custom01
    HitEffects(22)=(HitDecal=class'BulletHoleCloth',HitEffect=class'DHBulletHitSandBagEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel')           // Sand Bags EST_Custom02
    HitEffects(23)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitBrickEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt')    // Brick EST_Custom03
    HitEffects(24)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitHedgeEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')                // Hedgerow-Bush EST_Custom04
}
