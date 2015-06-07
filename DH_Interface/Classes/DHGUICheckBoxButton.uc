//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHGUICheckBoxButton extends GUICheckBoxButton;

delegate OnCheckChanged(GUIComponent Sender, bool bChecked);

// Colin: Modified to not call OnChange if the checked status was not actually
// changed.
function SetChecked(bool bNewChecked)
{
    if (bCheckBox && bNewChecked != bChecked)
    {
        bChecked = bNewChecked;

        OnChange(self);

        OnCheckChanged(self, bNewChecked);
    }
}

// Colin: Modified to simply call SetChecked so we don't need to duplicate
// delegate calling logic.
function bool InternalOnClick(GUIComponent Sender)
{
    if (bCheckBox)
    {
        SetChecked(!bChecked);
    }

    return true;
}

defaultproperties
{
}
