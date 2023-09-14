//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUITabControl extends GUITabControl;

function GUITabPanel AddTab(string InCaption, string PanelClass, optional GUITabPanel ExistingPanel, optional string InHint, optional bool bForceActive)
{
    local class<GUITabPanel> NewPanelClass;
    local DHGUITabButton     NewTabButton;
    local GUITabPanel        NewTabPanel;
    local int i;

    for (i = 0; i < TabStack.Length; ++i)
    {
        if (TabStack[i].Caption ~= InCaption)
        {
            return none;
        }
    }

    if (ExistingPanel == none)
    {
        NewPanelClass = class<GUITabPanel>(Controller.AddComponentClass(PanelClass));
    }

    if (ExistingPanel != none || NewPanelClass != none)
    {
        if (ExistingPanel != none)
        {
            NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel, true));
        }
        else if (NewPanelClass != none)
        {
            NewTabPanel = GUITabPanel(AddComponent(PanelClass, true));
        }

        if (NewTabPanel == none)
        {
                Log("Could not create panel for" @ NewPanelClass);

                return none;
        }

        if (NewTabPanel.MyButton != none)
        {
            NewTabButton = DHGUITabButton(NewTabPanel.MyButton);
        }
        else
        {
            NewTabButton = new class'DHGUITabButton';

            if (NewTabButton == none)
            {
                return none;
            }

            NewTabButton.InitComponent(Controller, self);
            NewTabButton.Opened(self);
            NewTabPanel.MyButton = NewTabButton;

            if (!bDrawTabAbove)
            {
                NewTabPanel.MyButton.bBoundToParent = false;
                NewTabPanel.MyButton.Style = Controller.GetStyle("FlippedTabButton",NewTabPanel.FontScale);
            }
        }

        NewTabPanel.MyButton.Hint         = Eval(InHint != "", InHint, NewTabPanel.Hint);
        NewTabPanel.MyButton.Caption      = Eval(InCaption != "", InCaption, NewTabPanel.PanelCaption);
        NewTabPanel.MyButton.OnClick      = InternalTabClick;
        NewTabPanel.MyButton.MyPanel      = NewTabPanel;
        NewTabPanel.MyButton.FocusInstead = self;
        NewTabPanel.MyButton.bNeverFocus  = true;
        NewTabPanel.InitPanel();
        TabStack[TabStack.Length] = NewTabPanel.MyButton;

        if ((TabStack.Length==1 && bVisible) || (bForceActive))
        {
            ActivateTab(NewTabPanel.MyButton, true);
        }
        else
        {
            NewTabPanel.Hide();
        }

        return NewTabPanel;
    }

    return none;
}

function GUITabPanel InsertTab(int Pos, string Caption, string PanelClass, optional GUITabPanel ExistingPanel, optional string InHint, optional bool bForceActive)
{
    local class<GUITabPanel> NewPanelClass;
    local GUITabPanel        NewTabPanel;
    local DHGUITabButton     NewTabButton;

    if (ExistingPanel == none)
    {
        NewPanelClass = class<GUITabPanel>(Controller.AddComponentClass(PanelClass));
    }

    if (ExistingPanel != none || NewPanelClass != none)
    {
        if (ExistingPanel != none)
        {
            NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel, true));
        }
        else if (NewPanelClass != none)
        {
            NewTabPanel = GUITabPanel(AddComponent(PanelClass, true));
        }

        if (NewTabPanel == none)
        {
            return none;
        }

        if (NewTabPanel.MyButton != none)
        {
            NewTabButton = DHGUITabButton(NewTabPanel.MyButton);
        }
        else
        {
            NewTabButton = new class'DHGUITabButton';

            if (NewTabButton == none)
            {
                return none;
            }

            NewTabButton.InitComponent(Controller, self);
            NewTabButton.Opened(self);
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
        {
            ActivateTab(NewTabPanel.MyButton, true);
        }
        else
        {
            NewTabPanel.Hide();
        }

        return NewTabPanel;
    }

    return none;
}

function bool InternalTabClick(GUIComponent Sender)
{
    local DHGUITabButton But;

    But = DHGUITabButton(Sender);

    if (But == none)
    {
        return false;
    }

    ActivateTab(But, true);

    return true;
}

defaultproperties
{
    bFillSpace=true
    StyleName="DHHeader"
    OnActivate=DHGUITabControl.InternalOnActivate
}
