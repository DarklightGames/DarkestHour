//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHDeployMenu extends UT2K4PlayerLoginMenu;

function InitComponent(GUIController MyController, GUIComponent MyComponent)
{
    local PlayerController PC;

    Super(FloatingWindow).InitComponent(MyController, MyComponent);

    // rjp -- when playing SinglePlayer or InstantAction game, remove tabs which only apply to multiplayer
    //PC = PlayerOwner();
    //if ( PC != None && PC.Level.NetMode == NM_StandAlone )
    //    RemoveMultiplayerTabs(PC.Level.Game);
    // -- rjp

    if ( Panels.Length > 0 )
        AddPanels();

    SetTitle();
    T_WindowTitle.DockedTabs = c_Main;
}


function AddPanels()
{
    //Panels[0].ClassName = "DH_Interface.DHDeploymentMapMenu";
    Super.AddPanels();
}

DefaultProperties
{
    Panels(0)=(ClassName="GUI2K4.UT2K4Tab_PlayerLoginControls",Caption="Select Team",Hint="Select a team")
    Panels(1)=(ClassName="GUI2K4.UT2K4Tab_ServerMOTD",Caption="Select Role",Hint="Select a role")
    Panels(2)=(ClassName="GUI2K4.UT2K4Tab_MidGameRulesCombo",Caption="Select Equipment?",Hint="Select additional equipment")
    Panels(3)=(ClassName="GUI2K4.UT2K4Tab_MidGameVoiceChat",Caption="Select Vehicle",Hint="Select a vehicle to deploy with")
    Panels(4)=(ClassName="DH_Interface.DHDeploymentMapMenu",Caption="Deployment",Hint="Deploy to the battlefield")
}