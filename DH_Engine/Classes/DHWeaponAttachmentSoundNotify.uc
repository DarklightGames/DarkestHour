//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponAttachmentSoundNotify extends CustomSoundNotify;

event Notify(Actor Owner)
{
    local ROWeaponAttachment WeaponAttachment;
    local Pawn Instigator;

    WeaponAttachment = ROWeaponAttachment(Owner);

    if (WeaponAttachment == none)
    {
        return;
    }

    Instigator = WeaponAttachment.Instigator;

    if (Instigator == none || Instigator.IsFirstPerson())
    {
        // Don't play the sound if the instigator is in first person.
        return;
    }

    Instigator.PlaySound(Sound,, Volume, false, Radius,, bAttenuate);
}

defaultproperties
{
    Radius=32.0
    bAttenuate=true
}
