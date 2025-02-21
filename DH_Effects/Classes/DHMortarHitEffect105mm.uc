//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortarHitEffect105mm extends DHHitEffect;

defaultproperties
{
    HitEffects(0)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo01')    // Default (Dirt?)
    HitEffects(1)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo01')    // Rock
    HitEffects(2)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo01')    // Dirt
    HitEffects(3)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo01')    // Metal*
    HitEffects(4)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo02')    // Wood*
    HitEffects(5)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo02')    // Plant (Grass)
    HitEffects(6)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo02')    // Flesh (dead animals)
    HitEffects(7)=(HitDecal=class'ArtilleryMarkSnow',HitEffect=class'ROEffects.ROArtillerySnowEmitter',HitSound=Sound'Artillery.explosions.explo03')    // Ice
    HitEffects(8)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtillerySnowEmitter',HitSound=Sound'Artillery.explosions.explo03')     // Snow
    HitEffects(9)=(HitEffect=class'DHMortarExplosion81mmWater',HitSound=Sound'Artillery.explosions.explo04')                       // Water
    HitEffects(10)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // Glass
    HitEffects(11)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // Gravel
    HitEffects(12)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // Concrete
    HitEffects(13)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // HollowWood*
    HitEffects(14)=(HitDecal=class'ArtilleryMarkSnow',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // Mud
    HitEffects(15)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // MetalArmor*
    HitEffects(16)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // Paper
    HitEffects(17)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // Cloth
    HitEffects(18)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo03')   // Rubber
    HitEffects(19)=(HitDecal=class'ArtilleryMarkSnow',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo01')   // Poop

    //DH Custom impacts
    HitEffects(21)=(HitDecal=class'ArtilleryMarkSnow',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo04')   // Sand EST_Custom01
    HitEffects(22)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo01')   // Sand Bags EST_Custom02
    HitEffects(23)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo04')   // Brick EST_Custom03
    HitEffects(24)=(HitDecal=class'ArtilleryMarkDirt',HitEffect=class'ROEffects.ROArtilleryDirtEmitter',HitSound=Sound'Artillery.explosions.explo01')   // Hedgerow-Bush EST_Custom04

    TransientSoundVolume=6.0
    MinSoundRadius=5300.0
    MaxSoundRadius=5500.0
    bAlwaysRelevant=true
}
