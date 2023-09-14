//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleHitEffect extends ROVehicleHitEffect;

var class<ProjectedDecal>       HitDecal;

simulated function InitHitEffects(vector HitLoc, vector HitNormal)
{
    PlaySound(HitSound, SLOT_None, 3.0, false, 100.0);

    Spawn(class'DHBulletHitMetalEffect',,, HitLoc, rotator(HitNormal));

    if (HitDecal != None)
    {
        Spawn(HitDecal,self,, Location, rotator(-HitNormal));
    }
}

defaultproperties
{
    HitDecal=class'BulletHoleMetalArmor'
}
