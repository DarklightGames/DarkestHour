//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUICheckBoxButton extends GUICheckBoxButton;

var bool bIsActive; // HACK: A hacky workaround to indicate that this button is
                    // active but temporarily hidden (e.g. outside of the viewport).

var bool bCanClickUncheck;

var string CenterText;

delegate OnCheckChanged(GUIComponent Sender, bool bChecked);
delegate Material GetOverlayMaterial(GUIComponent Sender);

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
    local Material OverlayMaterial;

    if (!bVisible)
    {
        return;
    }

    if (CenterText != "")
    {
        C.Font = class'ROHud'.static.LoadSmallFontStatic(7);
        C.SetDrawColor(0, 0, 0);
        C.TextSize(CenterText, XL, YL);
        C.SetPos(ActualLeft() + (ActualWidth() / 2) - (XL / 2), ActualTop() + (ActualHeight() / 2) - (YL / 2));
        C.DrawText(CenterText);
    }

    OverlayMaterial = GetOverlayMaterial(self);

    if (OverlayMaterial != none)
    {
        C.SetPos(ActualLeft(), ActualTop());
        C.SetDrawColor(255, 255, 255, 128);
        C.DrawTile(OverlayMaterial, ActualWidth(), ActualHeight(), 0, 0, 31, 31);
    }
}

defaultproperties
{
    bCanClickUncheck=true
    OnRendered=InternalOnRendered
}
