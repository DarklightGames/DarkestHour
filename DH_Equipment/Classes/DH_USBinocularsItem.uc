//=============================================================================
// DH_USBinocularsItem
//=============================================================================

class DH_USBinocularsItem extends DH_USArtyBinocularsItem;

// These binocs don't call arty
simulated function Fire(float F)
{
    return;
}

defaultproperties
{
     AttachmentClass=Class'DH_Equipment.DH_USBinocularsAttachment'
}
