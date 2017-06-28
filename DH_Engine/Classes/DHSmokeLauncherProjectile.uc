//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSmokeLauncherProjectile extends DHMortarProjectileSmoke
    abstract;

// Modified so remove mortar shell's 'Whistle' state, with its descending sound & delayed impact effects
// Also to extend the list of ignored hits to include collision with the launcher's own vehicle
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local Vehicle OwnVehicle;

    if (Other == none || Other.IsA('ROBulletWhipAttachment') || Other.bDeleteMe || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    if (Instigator != none)
    {
        OwnVehicle = Instigator.GetVehicleBase();

        if ((Other == OwnVehicle || Other.Base == OwnVehicle) && OwnVehicle != none)
        {
            return;
        }
    }

    self.HitNormal = Normal(HitLocation - Other.Location);
    Explode(HitLocation, vect(0.0, 0.0, 1.0));
}

// Modified so remove mortar shell's 'Whistle' state, with its descending sound & delayed impact effects
simulated function HitWall(vector HitNormal, Actor Wall)
{
    self.HitNormal = HitNormal;
    Explode(Location, HitNormal);
}

defaultproperties
{
}
