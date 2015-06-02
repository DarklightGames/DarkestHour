//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHDeployTabControl extends GUITabControl;

function GUITabPanel AddTab(string InCaption, string PanelClass, optional GUITabPanel ExistingPanel, optional string InHint, optional bool bForceActive)
{
    local class<GUITabPanel> NewPanelClass;
    local DHDeployTabButton NewTabButton;
    local GUITabPanel  NewTabPanel;

    local int i;

    // Make sure this doesn't exist first
    for (i=0;i<TabStack.Length;i++)
    {
        if (TabStack[i].Caption ~= InCaption)
        {
            log("A tab with the caption"@InCaption@"already exists.");
            return none;
        }
    }

    if (ExistingPanel==None)
        NewPanelClass = class<GUITabPanel>(Controller.AddComponentClass(PanelClass));

    if ( (ExistingPanel!=None) || (NewPanelClass != None) )
    {
        if (ExistingPanel != None)
            NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel,true));
        else if (NewPanelClass != None)
            NewTabPanel = GUITabPanel(AddComponent(PanelClass,true));

        if (NewTabPanel == None)
        {
            log("Could not create panel for"@NewPanelClass);
            return None;
        }

        if (NewTabPanel.MyButton != None)
            NewTabButton = DHDeployTabButton(NewTabPanel.MyButton);
        else
        {
            NewTabButton = new class'DHDeployTabButton';
            if (NewTabButton==None)
            {
                log("Could not create tab for"@NewPanelClass);
                return None;
            }

            NewTabButton.InitComponent(Controller, Self);
            NewTabButton.Opened(Self);
            NewTabPanel.MyButton = NewTabButton;
            if (!bDrawTabAbove)
            {
                //NewTabPanel.MyButton.bBoundToParent = false;
                NewTabPanel.MyButton.Style = Controller.GetStyle("FlippedTabButton",NewTabPanel.FontScale);
            }
        }

        NewTabPanel.MyButton.Hint           = Eval(InHint != "", InHint, NewTabPanel.Hint);
        NewTabPanel.MyButton.Caption        = Eval(InCaption != "", InCaption, NewTabPanel.PanelCaption);
        NewTabPanel.MyButton.OnClick        = InternalTabClick;
        NewTabPanel.MyButton.MyPanel        = NewTabPanel;
        NewTabPanel.MyButton.FocusInstead   = self;
        NewTabPanel.MyButton.bNeverFocus    = true;

        NewTabPanel.InitPanel();

        // Add the tab to controls
        TabStack[TabStack.Length] = NewTabPanel.MyButton;
        if ( (TabStack.Length==1 && bVisible) || (bForceActive) )
            ActivateTab(NewTabPanel.MyButton,true);
        else NewTabPanel.Hide();

        return NewTabPanel;

    }

    return none;
}

function GUITabPanel InsertTab(int Pos, string Caption, string PanelClass, optional GUITabPanel ExistingPanel, optional string InHint, optional bool bForceActive)
{
    local class<GUITabPanel> NewPanelClass;
    local GUITabPanel NewTabPanel;
    local DHDeployTabButton NewTabButton;

    if (ExistingPanel == None)
        NewPanelClass = class<GUITabPanel>(Controller.AddComponentClass(PanelClass));

    if ( ExistingPanel != None || NewPanelClass != None)
    {
        if (ExistingPanel != None)
            NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel,true));
        else if (NewPanelClass != None)
            NewTabPanel = GUITabPanel(AddComponent(PanelClass,true));

        if (NewTabPanel == None)
        {
            log("Could not create panel for"@NewPanelClass);
            return None;
        }

        if (NewTabPanel.MyButton != None)
            NewTabButton = DHDeployTabButton(NewTabPanel.MyButton);

        else
        {
            NewTabButton = new class'DHDeployTabButton';
            if (NewTabButton==None)
            {
                log("Could not create tab for"@NewPanelClass);
                return None;
            }

            NewTabButton.InitComponent(Controller, Self);
            NewTabButton.Opened(Self);
            NewTabPanel.MyButton = NewTabButton;
        }


        NewTabPanel.MyButton.Caption = Caption;
        NewTabPanel.MyButton.Hint = InHint;
        NewTabPanel.MyButton.OnClick = InternalTabClick;
        NewTabPanel.MyButton.MyPanel = NewTabPanel;
        NewTabPanel.MyButton.FocusInstead = self;
        NewTabPanel.MyButton.bNeverFocus = true;
        NewTabPanel.InitPanel();

        TabStack.Insert(Pos, 1);
        TabStack[Pos] = NewTabPanel.MyButton;
        if (TabStack.Length==1 || bForceActive)
            ActivateTab(NewTabPanel.MyButton,true);
        else NewTabPanel.Hide();

        return NewTabPanel;
    }

    return None;
}

function bool InternalTabClick(GUIComponent Sender)
{
    local DHDeployTabButton But;

    But = DHDeployTabButton(Sender);
    if (But==None)
        return false;

    ActivateTab(But,true);
    return true;
}

defaultproperties
{

}
