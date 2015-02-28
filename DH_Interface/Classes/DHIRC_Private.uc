//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHIRC_Private extends UT2k4IRC_Private;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.Initcomponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);
}

defaultproperties
{
}
