//=============================================================================
// DH_GerBinocularsItem
//=============================================================================

class DH_GerBinocularsItem extends DH_GerArtyBinocularsItem;

// These binocs don't call arty
simulated function Fire(float F)
{
    return;
}

defaultproperties
{
     AttachmentClass=Class'DH_Equipment.DH_GerBinocularsAttachment'
}
