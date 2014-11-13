//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHIRC_Channel extends UT2k4IRC_Channel;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.Initcomponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);
}

defaultproperties
{
     IRCNickColor=(B=150,R=255)
     IRCInfoColor=(B=130,R=160)
}
