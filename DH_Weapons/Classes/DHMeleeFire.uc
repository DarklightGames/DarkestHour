//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHMeleeFire extends ROMeleeFire
    abstract;

const SoundRadius = 200.000000;

function ServerPlayFiring()
{
    Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,, SoundRadius,, false);
}

defaultproperties
{
}

