//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHDeployMenuPanel extends MidGamePanel;

//TODO Move background stuff into this class

var automated DHGUIButton                   b_MenuButton;
var DHDeployMenu                            MyDeployMenu; // Deploy Menu Access

//TODO: DH prefix is redundant
var DHGameReplicationInfo                   GRI;
var DHPlayer                                PC;
var DHPlayerReplicationInfo                 PRI;

var bool                                    bRendered;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    }

    if (PC == none || PRI == none)
    {
        return;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI == none)
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
