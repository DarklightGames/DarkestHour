//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGetPassword extends UT2K4GetPassword;

const BUTTON_WIDTH=0.1475;
const BUTTON_HEIGHT=0.042773;
const BUTTON_SPACING=0.15;
const BUTTON_POS_TOP=0.7;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float ButtonRowLeft;

    super.InitComponent(MyController, MyOwner);
    
    // Set button positions
	ButtonRowLeft = 0.5 - BUTTON_SPACING * 0.5 - BUTTON_WIDTH;

	b_Cancel.SetPosition(ButtonRowLeft, 
                         BUTTON_POS_TOP, 
                         BUTTON_WIDTH, 
                         BUTTON_HEIGHT);

	b_Ok.SetPosition(ButtonRowLeft + BUTTON_SPACING + BUTTON_WIDTH, 
                     BUTTON_POS_TOP, 
                     BUTTON_WIDTH, 
                     BUTTON_HEIGHT);
}

function bool InternalOnPreDraw(Canvas C)
{
    // Bypass button positioning code in UT2K4GetDataMenu. 
    // Button positions don't rely on ActualHeight() anymore, so we don't need 
    // to adjust them on every draw call.
	return super(UT2K4GenericMessageBox).InternalOnPreDraw(C);
}

function RetryPassword()
{
    local string EntryString;
    local ExtendedConsole MyConsole;

    EntryString = ed_Data.GetText();
    MyConsole = ExtendedConsole(PlayerOwner().Player.Console);

    if (MyConsole != None && EntryString != "")
    {
        SavePassword(MyConsole, EntryString);
    }

    if (EntryString != "")
    {
        PlayerOwner().ClientTravel(RetryURL $ "?password=" $ EntryString, TRAVEL_Absolute, false);
    }
    else
    {
        PlayerOwner().ClientTravel(RetryURL, TRAVEL_Absolute, false);
    }

    Controller.CloseAll(false, true);
}

defaultproperties
{
	Begin Object Class=GUIButton Name=GetPassFail
        Caption="Cancel"
        StyleName="SquareButton"
		OnClick=InternalOnClick
		bBoundToParent=true
		TabOrder=2
	End Object
	b_Cancel=GetPassFail

	Begin Object Class=GUIButton Name=GetPassRetry
        Caption="Submit"
        StyleName="SquareButton"
		OnClick=InternalOnClick
		bBoundToParent=true
		TabOrder=1
	End Object
	b_OK=GetPassRetry
}
