//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBulletHitEffect extends DHHitEffect;

defaultproperties
{
    HitEffects(0)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitDefaultEffect',HitSound=Sound'ProjectileSounds.Impact_Dirt')        // Default (Dirt?)
    HitEffects(1)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitRockEffect',HitSound=Sound'ProjectileSounds.Impact_Asphalt')     // Rock
    HitEffects(2)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitDirtEffect',HitSound=Sound'ProjectileSounds.Impact_Dirt')        // Dirt
    HitEffects(3)=(HitDecal=Class'BulletHoleMetal',HitEffect=Class'DHBulletHitMetalEffect',FlashEffect=Class'DHFlashEffectSmall',HitSound=Sound'ProjectileSounds.Impact_Metal')      // Metal
    HitEffects(4)=(HitDecal=Class'BulletHoleWood',HitEffect=Class'DHBulletHitWoodEffect',HitSound=Sound'ProjectileSounds.Impact_Wood')        // Wood
    HitEffects(5)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitGrassEffect',HitSound=Sound'ProjectileSounds.Impact_Grass')      // Plant (Grass)
    HitEffects(6)=(HitDecal=Class'BulletHoleFlesh',HitEffect=Class'DHBulletHitFleshEffect',HitSound=Sound'ProjectileSounds.Impact_Mud')        // Flesh (dead animals)
    HitEffects(7)=(HitDecal=Class'BulletHoleIce',HitEffect=Class'DHBulletHitIceEffect',HitSound=Sound'ProjectileSounds.Impact_Snow')        // Ice
    HitEffects(8)=(HitDecal=Class'BulletHoleSnow',HitEffect=Class'DHBulletHitSnowEffect',HitSound=Sound'ProjectileSounds.Impact_Snow')        // Snow
    HitEffects(9)=(HitEffect=Class'DHBulletHitWaterEffect',HitSound=Sound'ProjectileSounds.Impact_Snow')                                    // Water
    HitEffects(10)=(HitDecal=Class'BulletHoleIce',HitEffect=Class'DHBreakingGlass',HitSound=Sound'DH_ProjectileSounds.Impact_Glass')            // Glass
    HitEffects(11)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitGravelEffect',HitSound=Sound'ProjectileSounds.Impact_Gravel')     // Gravel
    HitEffects(12)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitConcreteEffect',HitSound=Sound'ProjectileSounds.Impact_Asphalt')    // Concrete
    HitEffects(13)=(HitDecal=Class'BulletHoleWood',HitEffect=Class'DHBulletHitWoodEffect',HitSound=Sound'ProjectileSounds.Impact_Wood')       // HollowWood
    HitEffects(14)=(HitDecal=Class'BulletHoleSnow',HitEffect=Class'DHBulletHitMudEffect',HitSound=Sound'ProjectileSounds.Impact_Mud')        // Mud
    HitEffects(15)=(HitDecal=Class'BulletHoleMetalArmor',HitEffect=Class'DHBulletHitMetalArmorEffect',FlashEffect=Class'DHFlashEffectSmall',HitSound=Sound'ProjectileSounds.Impact_Metal')  //MetalArmor
    HitEffects(16)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitPaperEffect',HitSound=Sound'ProjectileSounds.Impact_Wood')       // Paper
    HitEffects(17)=(HitDecal=Class'BulletHoleCloth',HitEffect=Class'DHBulletHitClothEffect',HitSound=Sound'ProjectileSounds.Impact_Dirt')       // Cloth
    HitEffects(18)=(HitDecal=Class'BulletHoleMetal',HitEffect=Class'ROBulletHitRubberEffect',HitSound=Sound'ProjectileSounds.Impact_Dirt')       // Rubber
    HitEffects(19)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'ROBulletHitMudEffect',HitSound=Sound'ProjectileSounds.Impact_Mud')        // Poop

    //DH Custom impacts
    HitEffects(21)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitSandEffect',HitSound=Sound'ProjectileSounds.Impact_Gravel') // Sand EST_Custom01
    HitEffects(22)=(HitDecal=Class'BulletHoleCloth',HitEffect=Class'DHBulletHitSandBagEffect',HitSound=Sound'ProjectileSounds.Impact_Gravel') //Sand Bags EST_Custom02
    HitEffects(23)=(HitDecal=Class'BulletHoleConcrete',HitEffect=Class'DHBulletHitBrickEffect',HitSound=Sound'ProjectileSounds.Impact_Asphalt') //Brick EST_Custom03
    HitEffects(24)=(HitDecal=Class'BulletHoleDirt',HitEffect=Class'DHBulletHitHedgeEffect',HitSound=Sound'ProjectileSounds.Impact_Dirt') //Hedgerow-Bush EST_Custom04
    HitEffects(25)=(HitDecal=Class'DHBulletHoleDev',HitEffect=Class'DHBulletHitMetalArmorEffect',HitSound=Sound'ProjectileSounds.Impact_Metal') //Purple Hit-Visibility decal (Dev) EST_Custom05
}
