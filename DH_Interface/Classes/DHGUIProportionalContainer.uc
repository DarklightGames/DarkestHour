
//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIProportionalContainer extends DHGUIPlainBackground;

var(Debug) bool    bChangingPosValues;

struct ComponentPosValues
{
        var GUIComponent    component;
        var float           WinLeft, WinTop, WinWidth, WinHeight;
};

var()      array<ComponentPosValues>    AlignOriginalValues;

function bool ManageComponent(GUIComponent Component)
{
        local bool bResult;
        bResult = super.ManageComponent(Component);
        InternalPreDraw(none);                  // This is used to position the controls before drawing them
                                                    // (else you see the controls full screen for a split second,
                                                    // which looks kinda odd)
        return bResult;
}

function bool InternalPreDraw(Canvas C)
{
    local int i;
    local float AL, AT, AW, AH, LPad, RPad, TPad, BPad;
    local ComponentPosValues values;

    if (AlignStack.Length == 0) {
        return false;
    }

    if (bChangingPosValues) {
        AlignOriginalValues.Length = 0;
        return false;
    }

    AL = ActualLeft();
    AT = ActualTop();
    AW = ActualWidth();
    AH = ActualHeight();

    LPad = (LeftPadding   * AW) + ImageOffset[0];
    TPad = (TopPadding    * AH) + ImageOffset[1];
    RPad = (RightPadding  * AW) + ImageOffset[2];
    BPad = (BottomPadding * AH) + ImageOffset[3];

    if (Style != none)
    {
        LPad += BorderOffsets[0];
        TPad += BorderOffsets[1];
        RPad += BorderOffsets[2];
        BPad += BorderOffsets[3];
    }

    AL += LPad;
    AT += TPad;
    AW -= LPad + RPad;
    AH -= TPad + BPad;

    for (i = 0; i < AlignStack.Length; ++i)
    {
        values = GetAlignOriginalValues(AlignStack[i]);
        AlignStack[i].WinLeft = RelativeLeft(values.WinLeft * AW + AL);
        AlignStack[i].WinTop = RelativeTop(values.WinTop * AH + AT);
        AlignStack[i].WinWidth = RelativeWidth(values.WinWidth * AW);
        AlignStack[i].WinHeight = RelativeHeight(values.WinHeight * AH);
    }
    
    return false;
}

function ComponentPosValues GetAlignOriginalValues(GUIComponent component)
{
        local ComponentPosValues values;
        local int i;

        for (i = 0; i < AlignOriginalValues.Length; ++i)
                if (AlignOriginalValues[i].component == component)
                    return AlignOriginalValues[i];

        values.component = component;
        values.WinLeft = component.WinLeft;
        values.WinTop = component.WinTop;
        values.WinWidth = component.WinWidth;
        values.WinHeight = component.WinHeight;
        AlignOriginalValues[AlignOriginalValues.Length] = values;
        return values;
}

defaultproperties
{
    TopPadding=0.05
    BottomPadding=0.05
}
