//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_SdKfz251_22Cannon extends DH_Pak40Cannon_CamoOne;

defaultproperties
{
    InitialPrimaryAmmo=12
    InitialSecondaryAmmo=10
    MaxPositiveYaw=2400
    MaxNegativeYaw=-5100
    YawStartConstraint=-5300
    YawEndConstraint=2600
    CustomPitchUpLimit=3400
    CustomPitchDownLimit=65275

    // Don't have a bone for the Pak40 attachment, so this offsets from the hull's 'body' bone to fit correctly onto the pedestal mount
    // Would be easy to add a weapon attachment bone to the hull mesh, but would then need a modified interior mesh to match
    CannonAttachmentOffset=(X=-42.76,Y=0.3,Z=37.95)
}
