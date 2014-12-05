//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHBrowser_MOTD extends ROUT2k4Browser_MOTD;

function NewsParse(out string page)
{
    local string junk;
    local int i;

    junk = page;
    Caps(junk);
    i = InStr(junk, "<BODY>");

    if (i > -1)
    {
         // remove all header from string
         page = Right(page, len(page) - i - 6);
    }

    junk = page;
    Caps(junk);
    i = InStr(junk, "</BODY>");

    if (i > -1)
    {
         // remove all footers from string
         page = Left(page,i);
    }

    page = Repl(page, "<br>", "|", false);
}

defaultproperties
{
    getRequest="GET /ingamenews.php HTTP/1.1"
    newsIPAddr="darkesthourgame.com"
    Begin Object Class=DHGUIScrollTextBox Name=MyMOTDText
        bNoTeletype=true
        CharDelay=0.050000
        EOLDelay=0.100000
        bVisibleWhenEmpty=true
        OnCreateComponent=MyMOTDText.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinTop=0.002679
        WinLeft=0.031250
        WinWidth=0.968750
        WinHeight=1.000000
        RenderWeight=0.600000
        TabOrder=1
        bNeverFocus=true
    End Object
    lb_MOTD=DHGUIScrollTextBox'DH_Interface.DHBrowser_MOTD.MyMOTDText'
    Begin Object Class=GUILabel Name=VersionNum
        TextAlign=TXTA_Right
        StyleName="DHSmallText"
        WinTop=-0.030000
        WinLeft=0.793500
        WinWidth=0.202128
        WinHeight=0.040000
        RenderWeight=20.700001
    End Object
    l_Version=GUILabel'DH_Interface.DHBrowser_MOTD.VersionNum'
    PanelCaption="Darkest Hour News"
}
