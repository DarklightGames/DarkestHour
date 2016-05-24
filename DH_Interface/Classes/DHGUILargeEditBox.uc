//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGUILargeEditBox extends GUIEditBox;

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

    MenuStateChange(MSAT_Blurry);
}

defaultproperties
{
    OnEnter=InternalOnEnter
    StyleName="DHLargeEditBox"
}

