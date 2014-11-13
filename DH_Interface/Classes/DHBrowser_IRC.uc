//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHBrowser_IRC extends UT2k4Browser_IRC;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int              i;

    Super.Initcomponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);

    // Change the Style of the Tabs
    c_Channel.TabHeight=0.06;
    c_Channel.BackgroundStyle = none;
    c_Channel.BackgroundStyleName = "";
    for (i = 0; i < c_Channel.TabStack.Length; i++)
    {
        if (c_Channel.TabStack[i] != none)
        {
                    c_Channel.TabStack[i].Style=none;   // needed to reset style
            c_Channel.TabStack[i].FontScale=FNS_Medium;
            c_Channel.TabStack[i].bAutoSize=true;
            c_Channel.TabStack[i].bAutoShrink=false;
            c_Channel.TabStack[i].StyleName="DHTabTextButtonStyle";
            c_Channel.TabStack[i].Initcomponent(MyController, c_Channel);
        }
    }
}

defaultproperties
{
     Begin Object Class=DHGUITabControl Name=ChannelTabControl
         bDockPanels=true
         WinHeight=1.000000
         bAcceptsInput=true
         OnActivate=ChannelTabControl.InternalOnActivate
     End Object
     c_Channel=DHGUITabControl'DH_Interface.DHBrowser_IRC.ChannelTabControl'

     SystemPageClass="DH_Interface.DHIRC_System"
     PublicChannelClass="DH_Interface.DHIRC_Channel"
     PrivateChannelClass="DH_Interface.DHIRC_Private"
}
