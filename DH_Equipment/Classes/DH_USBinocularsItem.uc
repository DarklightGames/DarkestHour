//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USBinocularsItem extends DH_USArtyBinocularsItem;

// These binocs don't call arty
simulated function Fire(float F)
{
    return;
}

defaultproperties
{
    AttachmentClass=class'DH_Equipment.DH_USBinocularsAttachment'
}
