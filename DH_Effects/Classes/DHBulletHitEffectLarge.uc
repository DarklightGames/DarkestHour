//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBulletHitEffectLarge extends DHHitEffect;


defaultproperties
{
    HitEffects(0)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitDefaultEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')          // Default (Dirt?)
    HitEffects(1)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitRockEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt')      // Rock
    HitEffects(2)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitDirtEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')             // Dirt
    HitEffects(3)=(HitDecal=Class'BulletHoleMetal',HitEffect=Class'DHBulletHitMetalEffectLarge',FlashEffect=Class'DHFlashEffectSmall',HitSound=Sound'ProjectileSounds.PTRD_penetrate') // Metal
    HitEffects(4)=(HitDecal=Class'BulletHoleWood',HitEffect=Class'DHBulletHitWoodEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')             // Wood
    HitEffects(5)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitGrassEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Grass')           // Plant (Grass)
    HitEffects(6)=(HitDecal=Class'BulletHoleFlesh',HitEffect=Class'DHBulletHitFleshEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')            // Flesh (dead animals)
    HitEffects(7)=(HitDecal=Class'BulletHoleIce',HitEffect=Class'DHBulletHitIceEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')               // Ice
    HitEffects(8)=(HitDecal=Class'BulletHoleSnow',HitEffect=Class'DHBulletHitSnowEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')             // Snow
    HitEffects(9)=(HitEffect=Class'DHBulletHitWaterEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')                                           // Water
    HitEffects(10)=(HitDecal=Class'BulletHoleIce',HitEffect=Class'DHBreakingGlass',HitSound=Sound'DH_ProjectileSounds.BulletImpacts.Impact_Glass')              // Glass
    HitEffects(11)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitGravelEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel')    // Gravel
    HitEffects(12)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitConcreteEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt') // Concrete
    HitEffects(13)=(HitDecal=Class'BulletHoleWood',HitEffect=Class'DHBulletHitWoodEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')            // HollowWood
    HitEffects(14)=(HitDecal=Class'BulletHoleSnow',HitEffect=Class'DHBulletHitMudEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')              // Mud
    HitEffects(15)=(HitDecal=Class'BulletHoleMetalArmor',HitEffect=Class'DHBulletHitMetalArmorEffectLarge',FlashEffect=Class'DHFlashEffectSmall',HitSound=Sound'ProjectileSounds.PTRD_deflect') // MetalArmor
    HitEffects(16)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitPaperEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')            // Paper
    HitEffects(17)=(HitDecal=Class'BulletHoleCloth',HitEffect=Class'DHBulletHitClothEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')               // Cloth
    HitEffects(18)=(HitDecal=Class'BulletHoleMetal',HitEffect=Class'ROBulletHitRubberEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')              // Rubber
    HitEffects(19)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitMudEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')                   // Poop

    // DH Custom impacts
    HitEffects(21)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitSandEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel')               // Sand EST_Custom01
    HitEffects(22)=(HitDecal=Class'BulletHoleCloth',HitEffect=Class'DHBulletHitSandBagEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel')           // Sand Bags EST_Custom02
    HitEffects(23)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitBrickEffectLarge',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt')    // Brick EST_Custom03
    HitEffects(24)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitHedgeEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')                // Hedgerow-Bush EST_Custom04
}
