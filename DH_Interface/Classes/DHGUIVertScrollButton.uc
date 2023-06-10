//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIVertScrollButton extends GUIScrollButtonBase;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    if (bIncreaseButton)
    {
        StyleName = "DHGripButton";
        ImageIndex = 7;
    }

    super.Initcomponent(MyController, MyOwner);
}

defaultproperties
{
    ImageIndex=6
    StyleName="DHGripButton"
}
