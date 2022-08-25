//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHBackAttachment extends BackAttachment;

// Modified to support playing the idle animation and setting skin overrides.
function InitFor(Inventory I)
{
    local int j;

    local class<ROWeaponAttachment> WA;

    super.InitFor(I);

	if (I != none && I.AttachmentClass != none)
	{
        WA = class<ROWeaponAttachment>(I.AttachmentClass);

        if (WA != none)
        {
            PlayAnim(WA.default.WA_Idle);

            for (j = 0; j < WA.default.Skins.Length; ++j)
            {
                if (WA.default.Skins[j] != none)
                {
                    Skins[j] = WA.default.Skins[j];
                }
            }
        }
	}
}


