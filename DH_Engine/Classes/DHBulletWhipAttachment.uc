//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBulletWhipAttachment extends ROBulletWhipAttachment;

defaultproperties
{
    RemoteRole=ROLE_None // to stop this actor replicating to net clients, as it's spawned independently on clients & server

    // These are same as inherited from ROBulletWhipAttachment - only re-stated here as prompt that if changed, it's necessary to adjust check distance literals used after HitPointTraces
    // Currently 180k (square of max distance across whip 'diagonally') in DHProjectileFire.PreLaunchTrace, DHBullet.ProcessTouch & DHAntiVehicleProjectile.ProcessTouch (& any subclasses)
    CollisionRadius=150.0
    CollisionHeight=150.0
}
