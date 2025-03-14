//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGetPassword extends UT2K4GetPassword;

var localized string LabelText;
var localized string EditBoxText;
var localized string OKButtonText;
var localized string CancelButtonText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);
    
    l_Text.Caption=LabelText;
    ed_Data.Caption=EditBoxText;
    b_OK.Caption=OKButtonText;
    b_Cancel.Caption=CancelButtonText;
}

function RetryPassword()
{
    local string            EntryString;
    local ExtendedConsole   MyConsole;

    EntryString = ed_Data.GetText();
    MyConsole = ExtendedConsole(PlayerOwner().Player.Console);

    if ( MyConsole != None && EntryString != "" )
        SavePassword(MyConsole, EntryString);

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
    LabelText="A password is required to play on this server."
    EditBoxText="Server Password"
    OKButtonText="Submit"
    CancelButtonText="Cancel"
}
