//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitEffect extends DHHitEffect;

defaultproperties
{
    HitEffects(0)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitDefaultEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')        // Default (Dirt?)
    HitEffects(1)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitRockEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt')     // Rock
    HitEffects(2)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitDirtEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')        // Dirt
    HitEffects(3)=(HitDecal=class'BulletHoleMetal',HitEffect=class'DHBulletHitMetalEffect',FlashEffect=class'DHFlashEffectSmall',HitSound=Sound'ProjectileSounds.Bullets.Impact_Metal')      // Metal
    HitEffects(4)=(HitDecal=class'BulletHoleWood',HitEffect=class'DHBulletHitWoodEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')        // Wood
    HitEffects(5)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitGrassEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Grass')      // Plant (Grass)
    HitEffects(6)=(HitDecal=class'BulletHoleFlesh',HitEffect=class'DHBulletHitFleshEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')        // Flesh (dead animals)
    HitEffects(7)=(HitDecal=class'BulletHoleIce',HitEffect=class'DHBulletHitIceEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')        // Ice
    HitEffects(8)=(HitDecal=class'BulletHoleSnow',HitEffect=class'DHBulletHitSnowEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')        // Snow
    HitEffects(9)=(HitEffect=class'DHBulletHitWaterEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Snow')                                    // Water
    HitEffects(10)=(HitDecal=class'BulletHoleIce',HitEffect=class'DHBreakingGlass',HitSound=Sound'DH_ProjectileSounds.BulletImpacts.Impact_Glass')            // Glass
    HitEffects(11)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitGravelEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel')     // Gravel
    HitEffects(12)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitConcreteEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt')    // Concrete
    HitEffects(13)=(HitDecal=class'BulletHoleWood',HitEffect=class'DHBulletHitWoodEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')       // HollowWood
    HitEffects(14)=(HitDecal=class'BulletHoleSnow',HitEffect=class'DHBulletHitMudEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')        // Mud
    HitEffects(15)=(HitDecal=class'BulletHoleMetalArmor',HitEffect=class'DHBulletHitMetalArmorEffect',FlashEffect=class'DHFlashEffectSmall',HitSound=Sound'ProjectileSounds.Bullets.Impact_Metal')  //MetalArmor
    HitEffects(16)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitPaperEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Wood')       // Paper
    HitEffects(17)=(HitDecal=class'BulletHoleCloth',HitEffect=class'DHBulletHitClothEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')       // Cloth
    HitEffects(18)=(HitDecal=class'BulletHoleMetal',HitEffect=class'ROBulletHitRubberEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt')       // Rubber
    HitEffects(19)=(HitDecal=class'BulletHoleDirt',HitEffect=class'ROBulletHitMudEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Mud')        // Poop

    //DH Custom impacts
    HitEffects(21)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitSandEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel') // Sand EST_Custom01
    HitEffects(22)=(HitDecal=class'BulletHoleCloth',HitEffect=class'DHBulletHitSandBagEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Gravel') //Sand Bags EST_Custom02
    HitEffects(23)=(HitDecal=class'BulletHoleConcrete',HitEffect=class'DHBulletHitBrickEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Asphalt') //Brick EST_Custom03
    HitEffects(24)=(HitDecal=class'BulletHoleDirt',HitEffect=class'DHBulletHitHedgeEffect',HitSound=Sound'ProjectileSounds.Bullets.Impact_Dirt') //Hedgerow-Bush EST_Custom04
}
