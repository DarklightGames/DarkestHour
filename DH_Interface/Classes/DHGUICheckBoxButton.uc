//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHGUICheckBoxButton extends GUICheckBoxButton;

var bool bCanClickUncheck;

var string CenterText;

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
// delegate calling logic. We also don't want clicking a selected button to
// become unselected when clicked again.
function bool InternalOnClick(GUIComponent Sender)
{
    if (bCheckBox && (!bChecked || bCanClickUncheck))
    {
        SetChecked(!bChecked);
    }

    return true;
}

function InternalOnRendered(Canvas C)
{
    local float XL, YL;

    if (CenterText != "")
    {
        C.Font = class'ROHud'.static.LoadSmallFontStatic(7);
        C.SetDrawColor(0, 0, 0);
        C.TextSize(CenterText, XL, YL);
        C.SetPos(ActualLeft() + (ActualWidth() / 2) - (XL / 2), ActualTop() + (ActualHeight() / 2) - (YL / 2));
        C.DrawText(CenterText);
    }
}

defaultproperties
{
    bCanClickUncheck=true
    OnRendered=InternalOnRendered
}
