//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHDeployMenuPanel extends MidGamePanel;

//TODO Move background stuff into this class

var automated DHGUIButton                   b_MenuButton;
var DHDeployMenu                            MyDeployMenu; // Deploy Menu Access

var DHGameReplicationInfo                   DHGRI;
var DHPlayer                                DHP;
var DHPlayerReplicationInfo                 PRI;

var bool                                    bRendered;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    DHP = DHPlayer(PlayerOwner());
    if (DHP != none)
    {
        PRI = DHPlayerReplicationInfo(DHP.PlayerReplicationInfo);
    }

    if (DHP == none || PRI == none)
    {
        return;
    }

    DHGRI = DHGameReplicationInfo(DHP.GameReplicationInfo);
    if (DHGRI == none)
    {
        return;
    }

    // Assign MyDeployMenu
    MyDeployMenu = DHDeployMenu(PageOwner);
}

function ShowPanel(bool bShow)
{
    super.ShowPanel(bShow);

    if (MyDeployMenu.bRoomForOptions)
    {
        b_MenuButton.SetVisibility(false);
    }
    else
    {
        b_MenuButton.SetVisibility(true);
    }
}

function bool OnPostDraw(Canvas C)
{
    super.OnPostDraw(C);

    bRendered = true;
    return true;
}

defaultproperties
{

}
