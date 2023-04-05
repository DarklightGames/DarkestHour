//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHFastAutoWeapon extends DHAutoWeapon
    abstract;

simulated function bool StartFire(int Mode)
{
    if (super.StartFire(Mode))
    {
        if (FireMode[Mode].bMeleeMode)
        {
            return true;
        }

        AnimStopLooping();

        if (!FireMode[Mode].IsInState('FireLoop'))
        {
            FireMode[Mode].StartFiring();

            return true;
        }
    }

    return false;
}

// Modified to prevent MG from playing fire end anims while auto firing
simulated function AnimEnd(int Channel)
{
    if (!FireMode[0].IsInState('FireLoop'))
    {
        super.AnimEnd(channel);
    }
}
