//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHIRC_Private extends UT2k4IRC_Private;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);
}

defaultproperties
{
}
