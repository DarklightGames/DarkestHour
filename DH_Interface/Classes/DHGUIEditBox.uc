//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIEditBox extends GUIEditBox;

delegate OnEnter();

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    if (Key == 0x0D && State == 3) // IK_Enter
    {
        OnEnter();

        return false;
    }

    return super.InternalOnKeyEvent(Key, State, Delta);
}

function InternalOnEnter()
{
    OnDeActivate();
}

defaultproperties
{
    OnEnter=InternalOnEnter
    StyleName="DHEditBox"
}
