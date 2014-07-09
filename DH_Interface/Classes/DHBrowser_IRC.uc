//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHBrowser_IRC extends UT2k4Browser_IRC;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int              i;

	Super.Initcomponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);

	// Change the Style of the Tabs
	c_Channel.TabHeight=0.06;
	c_Channel.BackgroundStyle = None;
	c_Channel.BackgroundStyleName = "";
	for ( i = 0; i < c_Channel.TabStack.Length; i++ )
	{
		if ( c_Channel.TabStack[i] != None )
		{
	        		c_Channel.TabStack[i].Style=None;   // needed to reset style
			c_Channel.TabStack[i].FontScale=FNS_Medium;
			c_Channel.TabStack[i].bAutoSize=True;
			c_Channel.TabStack[i].bAutoShrink=False;
			c_Channel.TabStack[i].StyleName="DHTabTextButtonStyle";
			c_Channel.TabStack[i].Initcomponent(MyController, c_Channel);
        }
	}
}

defaultproperties
{
     Begin Object Class=DHGUITabControl Name=ChannelTabControl
         bDockPanels=True
         WinHeight=1.000000
         bAcceptsInput=True
         OnActivate=ChannelTabControl.InternalOnActivate
     End Object
     c_Channel=DHGUITabControl'DH_Interface.DHBrowser_IRC.ChannelTabControl'

     SystemPageClass="DH_Interface.DHIRC_System"
     PublicChannelClass="DH_Interface.DHIRC_Channel"
     PrivateChannelClass="DH_Interface.DHIRC_Private"
}
