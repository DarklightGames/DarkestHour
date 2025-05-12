//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleHitEffect extends ROVehicleHitEffect;

var class<ProjectedDecal>       HitDecal;

simulated function InitHitEffects(Vector HitLoc, Vector HitNormal)
{
    PlaySound(HitSound, SLOT_None, 3.0, false, 100.0);

    Spawn(class'DHBulletHitMetalEffect',,, HitLoc, Rotator(HitNormal));

    if (HitDecal != None)
    {
        Spawn(HitDecal, self,, Location, Rotator(-HitNormal));
    }
}

defaultproperties
{
    HitDecal=class'BulletHoleMetalArmor'
}
