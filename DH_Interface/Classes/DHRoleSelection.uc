//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHRoleSelection extends ROGUIRoleSelection;

function bool InternalOnClick(GUIComponent Sender)
{
    local ROPlayer player;

    player = ROPlayer(PlayerOwner());

    switch (sender)
    {
        case b_JoinAxis:
            ChangeDesiredTeam(AXIS_TEAM_INDEX);
            break;

        case b_JoinAllies:
            ChangeDesiredTeam(ALLIES_TEAM_INDEX);
            break;

        case b_Spectate:
            ChangeDesiredTeam(-1);
            break;

        case b_Continue:
            AttemptRoleApplication();
            break;

        case b_Config:
            bShowingConfigButtons = !bShowingConfigButtons;
            UpdateConfigButtonsVisibility();
            break;

        case b_Disconnect:
            PlayerOwner().ConsoleCommand("DISCONNECT");
            CloseMenu();
            break;

        case b_Score:
            if (player != none && ROHud(player.myHUD) != none)
                player.myHUD.bShowScoreBoard = !player.myHUD.bShowScoreBoard;
            CloseMenu();
            break;

        case b_Map:
            if (player != none && ROHud(player.myHUD) != none)
                ROHud(player.myHUD).ShowObjectives();
            CloseMenu();
            break;
    }

    if (bShowingConfigButtons)
    {
        switch (Sender)
        {
            case b_StartNewGame:
                if (b_StartNewGame.bVisible)
                    Controller.OpenMenu(Controller.GetInstantActionPage());
                break;

            case b_ServerBrowser:
                Controller.OpenMenu("DH_Interface.DHServerBrowser");
                break;

            case b_AddFavorite:
                if (b_AddFavorite.bVisible && player != none)
                    player.ConsoleCommand("ADDCURRENTTOFAVORITES");
                break;

            case b_MapVoting:
                if (b_MapVoting.bVisible)
                    Controller.OpenMenu(Controller.MapVotingMenu);
                break;

            case b_KickVoting:
                if (b_MapVoting.bVisible)
                    Controller.OpenMenu(Controller.KickVotingMenu);
                break;

            case b_Communication:
                Controller.OpenMenu("ROInterface.ROCommunicationPage");
                break;

            case b_Configuration:
                Controller.OpenMenu("DH_Interface.DHSettingsPage_new");
                break;

            case b_ExitRO:
                Controller.OpenMenu(Controller.GetQuitPage());
                break;
        }
    }
    else
    {
        switch (Sender)
        {
            case b_Equipment[0]:
                l_EquipmentDescription.setContent(equipmentDescriptions[0]);
                break;

            case b_Equipment[1]:
                l_EquipmentDescription.setContent(equipmentDescriptions[1]);
                break;

            case b_Equipment[2]:
                l_EquipmentDescription.setContent(equipmentDescriptions[2]);
                break;

            case b_Equipment[3]:
                l_EquipmentDescription.setContent(equipmentDescriptions[3]);
                break;
        }
    }

    return true;
}

function UpdateTeamCounts()
{
    l_numAxis.Caption = "" $ getTeamCount(ALLIES_TEAM_INDEX);
    l_numAllies.Caption = "" $ getTeamCount(AXIS_TEAM_INDEX);
}

// Overridden to force Bazooka/Panzerschreck/PIAT to inventory slot 4 along with Panzerfaust
function UpdateRoleEquipment()
{
    local class<ROWeaponAttachment> WeaponAttach;
    local class<Weapon>   w;
    local class<Powerups> pu;
    local int  count, i, temp;
    local bool bHideItem;

    count = 0;
    temp = -1;

    // Add grenades if needed
    for (i = 0; i < arraycount(desiredRole.Grenades); i++)
    {
        if (desiredRole.Grenades[i].Item != none)
        {
            WeaponAttach = class<ROWeaponAttachment>(desiredRole.Grenades[i].Item.default.AttachmentClass);

            if (WeaponAttach != none)
            {
                if (WeaponAttach.default.menuImage != none)
                {
                    b_Equipment[count].Graphic = WeaponAttach.default.menuImage;
                    b_Equipment[count].bVisible = true;
                }

                equipmentDescriptions[count] = desiredRole.Grenades[i].Item.default.ItemName $ "||" $ WeaponAttach.default.menuDescription;
                l_EquipmentDescription.bVisible = true;
            }
 
            count++;
        }
    }

    // Parse GivenItems array
    for (i = 0; i < desiredRole.GivenItems.Length; i++)
    {
        if (desiredRole.GivenItems[i] != "")
        {
            w = class<Weapon>(DynamicLoadObject(desiredRole.GivenItems[i], class'class'));

            if (w != none)
            {
                WeaponAttach = class<ROWeaponAttachment>(w.default.AttachmentClass);
            }
            else
            {
                pu = class<Powerups>(DynamicLoadObject(desiredRole.GivenItems[i], class'class'));
                WeaponAttach = class<ROWeaponAttachment>(pu.default.AttachmentClass);
            }

            if (WeaponAttach != none)
            {
                // Force AT weapon to go in slot #4
                if (desiredRole.GivenItems[i] ~= "DH_ATWeapons.DH_PanzerFaustWeapon" || desiredRole.GivenItems[i] ~= "DH_ATWeapons.DH_BazookaWeapon" || 
                    desiredRole.GivenItems[i] ~= "DH_ATWeapons.DH_PanzerschreckWeapon" || desiredRole.GivenItems[i] ~= "DH_ATWeapons.DH_PIATWeapon")
                {
                    temp = count;
                    count = 3;
                }

                if (!bHideItem)
                {
                    if (WeaponAttach.default.menuImage != none)
                    {
                        b_Equipment[count].Graphic = WeaponAttach.default.menuImage;
                        b_Equipment[count].bVisible = true;
                    }

                    equipmentDescriptions[count] = w.default.ItemName $ "||" $ WeaponAttach.default.menuDescription;
                    l_EquipmentDescription.bVisible = true;
                }

                if (temp != -1)
                {
                    count = temp - 1;
                    temp = -1;
                }
            }

            // This check needs to be done here because DH_ParachuteItem has no attachment
            if (desiredRole.GivenItems[i] ~= "DH_Equipment.DH_ParachuteItem")
            {
                bHideItem = true;
            }

            if (!bHideItem)
            {
                count++;
            }
            else
            {
                bHideItem = false;
            }
        }

        if (count > arraycount(b_Equipment))
        {
            return;
        }
    }
}

function GetInitialValues()
{
    local ROPlayer player;
    local ROPlayerReplicationInfo PRI;

    player = ROPlayer(PlayerOwner());

    // Get player's current role and team (if any)
    PRI = ROPlayerReplicationInfo(player.PlayerReplicationInfo);
    if (PRI != none)
    {
        // Get player's current team
        if (ROPlayer(PlayerOwner()) != none && ROPlayer(PlayerOwner()).ForcedTeamSelectOnRoleSelectPage != -5)
        {
            currentTeam = ROPlayer(PlayerOwner()).ForcedTeamSelectOnRoleSelectPage;
            ROPlayer(PlayerOwner()).ForcedTeamSelectOnRoleSelectPage = -5;
        }
        else if (PRI.bOnlySpectator)
        {
            currentTeam = -1;
        }
        else if (PRI.Team != none)
        {
            currentTeam = PRI.Team.TeamIndex;
        }
        else
        {
            currentTeam = -1;
        }

        if (currentTeam != AXIS_TEAM_INDEX && currentTeam != ALLIES_TEAM_INDEX)
        {
            currentTeam = -1;
        }
    }
    else
    {
        currentTeam = -1;
    }

    // Get player's current/desired role
    if (currentTeam == -1)
    {
        currentRole = none;
    }
    else if (player.CurrentRole != player.DesiredRole)
    {
        if (currentTeam == AXIS_TEAM_INDEX)
        {
            currentRole = DHGameReplicationInfo(GRI).DHAxisRoles[player.DesiredRole];
        }
        else if (currentTeam == ALLIES_TEAM_INDEX)
        {
            currentRole = DHGameReplicationInfo(GRI).DHAlliesRoles[player.DesiredRole];
        }
        else
        {
            currentRole = none;
        }
    }
    else if (PRI.RoleInfo != none)
    {
        currentRole = PRI.RoleInfo;
    }
    else
    {
        currentRole = none;
    }

    // Get player's current name
    currentName = player.GetUrlOption("Name");

    // Get player's current weapons
    if (currentRole == none)
    {
        currentWeapons[0] = -1;
        currentWeapons[1] = -1;
    }
    else if (player.CurrentRole != player.DesiredRole)
    {
        currentWeapons[0] = player.DesiredPrimary;
        currentWeapons[1] = player.DesiredSecondary;
    }
    else
    {
        currentWeapons[0] = player.PrimaryWeapon;
        currentWeapons[1] = player.SecondaryWeapon;
    }

    // Set desired stuff to be same as current stuff
    desiredTeam = currentTeam;
    desiredRole = currentRole;
    desiredName = currentName;
    desiredWeapons[0] = -5; // these values tell the AutoPickWeapon() function
    desiredWeapons[1] = -5; // to use the currentWeapon[] value instead
}

function FillRoleList()
{
    local int i;
    local RORoleInfo role;
    local DHGameReplicationInfo DHGRI;

    li_Roles.Clear();

    ChangeDesiredRole(none);

    if (desiredTeam != AXIS_TEAM_INDEX && desiredTeam != ALLIES_TEAM_INDEX)
    {
        return;
    }

    DHGRI = DHGameReplicationInfo(GRI);

    for (i = 0; i < arraycount(DHGRI.DHAxisRoles); i++)
    {
        if (desiredTeam == AXIS_TEAM_INDEX)
        {
            role = DHGRI.DHAxisRoles[i];
        }
        else
        {
            role = DHGRI.DHAlliesRoles[i];
        }

        if (role == none)
        {
            continue;
        }

        if (ROPlayer(PlayerOwner()) != none && ROPlayer(PlayerOwner()).bUseNativeRoleNames)
        {
            li_Roles.Add(role.default.AltName, role);
        }
        else
        {
            li_Roles.Add(role.default.MyName, role);
        }
    }

    li_Roles.SortList();
}

function int FindRoleIndexInGRI(RORoleInfo role, int team)
{
    local int i;
    local DHGameReplicationInfo DHGRI;

    DHGRI = DHGameReplicationInfo(GRI);

    if (team == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.DHAxisRoles); i++)
        {
            if (DHGRI.DHAxisRoles[i] == role)
            {
                return i;
            }
        }
    }
    else if (team == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.DHAlliesRoles); i++)
        {
            if (DHGRI.DHAlliesRoles[i] == role)
            {
                return i;
            }
        }
    }
    else
    {
        return -1;
    }
}

function bool checkIfRoleIsFull(RORoleInfo role, int team, optional out int roleLimit, optional out int roleCount, optional out int roleBotCount)
{
    local int index;
    local DHGameReplicationInfo DHGRI;

    DHGRI = DHGameReplicationInfo(GRI);

    index = FindRoleIndexInGRI(role, team); // ugh, slow

    if (team == AXIS_TEAM_INDEX)
    {
        roleCount = DHGRI.DHAxisRoleCount[index];
        roleBotCount = DHGRI.DHAxisRoleBotCount[index];
    }
    else if (team == ALLIES_TEAM_INDEX)
    {
        roleCount = DHGRI.DHAlliesRoleCount[index];
        roleBotCount = DHGRI.DHAlliesRoleBotCount[index];
    }
    else
    {
        warn("Invalid team used when calling checkIfRoleIsFull():" @ team);

        return false;
    }

    roleLimit = role.GetLimit(GRI.MaxPlayers);

    return (roleCount == roleLimit) && (roleLimit != 0) && !(roleBotCount > 0) && (currentRole != role);
}

function AutoPickRole()
{
    local int i, currentRoleCount;
    local RORoleInfo role;
    local DHGameReplicationInfo DHGRI;

    DHGRI = DHGameReplicationInfo(GRI);

    if (desiredTeam == AXIS_TEAM_INDEX || desiredTeam == ALLIES_TEAM_INDEX)
    {
        // Pick the first non-full role
        for (i = 0; i < arraycount(DHGRI.DHAxisRoles); i++)
        {
            if (desiredTeam == AXIS_TEAM_INDEX)
            {
                role = DHGRI.DHAxisRoles[i];
                currentRoleCount = DHGRI.DHAxisRoleCount[i];
            }
            else
            {
                role = DHGRI.DHAlliesRoles[i];
                currentRoleCount = DHGRI.DHAlliesRoleCount[i];
            }

            if (role == none)
            {
                continue;
            }

            if (role.GetLimit(GRI.MaxPlayers) == 0 || currentRoleCount < role.GetLimit(GRI.MaxPlayers))
            {
                ChangeDesiredRole(role);

                return;
            }
        }

        // If they're all full.. well though noogies :)
        Warn("All roles are full!");
    }
    else
    {
        ChangeDesiredRole(none);
    }
}

defaultproperties
{
    Begin Object Class=GUILabel Name=RolesTitle
        Caption="Role Selection"
        TextAlign=TXTA_Right
        StyleName="DHLargeText"
        WinTop=0.223333
        WinLeft=0.07125
        WinWidth=0.175
        WinHeight=0.04
    End Object
    l_RolesTitle=GUILabel'DH_Interface.DHRoleSelection.RolesTitle'

    Begin Object Class=GUILabel Name=RoleDescTitle
        Caption="Role Description"
        TextAlign=TXTA_Right
        StyleName="DHLargeText"
        WinTop=0.561666
        WinLeft=0.31625
        WinWidth=0.175
        WinHeight=0.04
    End Object
    l_RoleDescTitle=GUILabel'DH_Interface.DHRoleSelection.RoleDescTitle'

    Begin Object Class=GUILabel Name=PrimaryWeaponTitle
        Caption="Primary Weapon"
        TextAlign=TXTA_Right
        StyleName="DHLargeText"
        WinTop=0.035
        WinLeft=0.803751
        WinWidth=0.175
        WinHeight=0.04
    End Object
    l_PrimaryWeaponTitle=GUILabel'DH_Interface.DHRoleSelection.PrimaryWeaponTitle'

    Begin Object Class=GUILabel Name=SecondaryWeaponTitle
        Caption="Sidearm"
        TextAlign=TXTA_Right
        StyleName="DHLargeText"
        WinTop=0.343334
        WinLeft=0.802501
        WinWidth=0.175
        WinHeight=0.04
    End Object
    l_SecondaryWeaponTitle=GUILabel'DH_Interface.DHRoleSelection.SecondaryWeaponTitle'

    Begin Object Class=GUILabel Name=EquipmentWeaponTitle
        Caption="Equipment"
        TextAlign=TXTA_Right
        StyleName="DHLargeText"
        WinTop=0.64
        WinLeft=0.80625
        WinWidth=0.175
        WinHeight=0.04
    End Object
    l_EquipTitle=GUILabel'DH_Interface.DHRoleSelection.EquipmentWeaponTitle'

    Begin Object Class=BackgroundImage Name=PageBackground
        Image=texture'DH_GUI_Tex.Menu.roleselect'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1023
        Y2=1023
    End Object
    bg_Background=BackgroundImage'DH_Interface.DHRoleSelection.PageBackground'

    Begin Object Class=BackgroundImage Name=PageBackground2
        Image=texture'DH_GUI_Tex.Menu.midgamemenu'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1023
        Y2=1023
    End Object
    bg_Background2=BackgroundImage'DH_Interface.DHRoleSelection.PageBackground2'

    Begin Object Class=DHGUIButton Name=DisconnectButton
        Caption="Disconnect"
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.012
        WinWidth=0.18
        TabOrder=1
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=DisconnectButton.InternalOnKeyEvent
    End Object
    b_Disconnect=DHGUIButton'DH_Interface.DHRoleSelection.DisconnectButton'

    Begin Object Class=DHGUIButton Name=MapButton
        Caption="Situation Map"
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.22
        WinWidth=0.18
        TabOrder=2
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=MapButton.InternalOnKeyEvent
    End Object
    b_Map=DHGUIButton'DH_Interface.DHRoleSelection.MapButton'

    Begin Object Class=DHGUIButton Name=ScoreButton
        Caption="Score"
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.41
        WinWidth=0.18
        TabOrder=3
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=ScoreButton.InternalOnKeyEvent
    End Object
    b_Score=DHGUIButton'DH_Interface.DHRoleSelection.ScoreButton'

    Begin Object Class=DHGUIButton Name=ConfigButton
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.6
        WinWidth=0.18
        TabOrder=4
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=ConfigButton.InternalOnKeyEvent
    End Object
    b_Config=DHGUIButton'DH_Interface.DHRoleSelection.ConfigButton'

    Begin Object Class=DHGUIButton Name=ContinueButton
        Caption="Continue"
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.808
        WinWidth=0.18
        TabOrder=5
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=ContinueButton.InternalOnKeyEvent
    End Object
    b_Continue=DHGUIButton'DH_Interface.DHRoleSelection.ContinueButton'

    Begin Object Class=DHGUIButton Name=JoinAxisButton
        Caption="Join Axis"
        StyleName="DHSmallTextButtonStyle"
        WinHeight=0.0375
        TabOrder=7
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=JoinAxisButton.InternalOnKeyEvent
    End Object
    b_JoinAxis=DHGUIButton'DH_Interface.DHRoleSelection.JoinAxisButton'

    Begin Object Class=DHGUIButton Name=JoinAlliesButton
        Caption="Join Allies"
        StyleName="DHSmallTextButtonStyle"
        WinHeight=0.0375
        TabOrder=6
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=JoinAlliesButton.InternalOnKeyEvent
    End Object
    b_JoinAllies=DHGUIButton'DH_Interface.DHRoleSelection.JoinAlliesButton'

    Begin Object Class=DHGUIButton Name=SpectateButton
        Caption="Spectate"
        StyleName="DHSmallTextButtonStyle"
        Hint="Observe the game as a non-playing spectator"
        WinHeight=0.0375
        TabOrder=8
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=SpectateButton.InternalOnKeyEvent
    End Object
    b_Spectate=DHGUIButton'DH_Interface.DHRoleSelection.SpectateButton'

    Begin Object Class=GUILabel Name=NumAxisLabel
        Caption="?"
        TextAlign=TXTA_Center
        StyleName="DHSmallText"
    End Object
    l_numAxis=GUILabel'DH_Interface.DHRoleSelection.NumAxisLabel'
    l_numAllies=GUILabel'DH_Interface.DHRoleSelection.NumAxisLabel'

    Begin Object Class=GUILabel Name=NumFakeLabel
        Caption=" "
        TextAlign=TXTA_Center
        StyleName="DHSmallText"
    End Object
    l_numFake=GUILabel'DH_Interface.DHRoleSelection.NumFakeLabel'

    Begin Object Class=DHGuiListBox Name=Roles
        SelectedStyleName="DHListSelectionStyle"
        OutlineStyleName="ItemOutline"
        bVisibleWhenEmpty=true
        bSorted=true
        OnCreateComponent=Roles.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinHeight=1.0
        TabOrder=0
        OnChange=DHRoleSelection.InternalOnChange
    End Object
    lb_Roles=DHGuiListBox'DH_Interface.DHRoleSelection.Roles'

    Begin Object Class=GUIImage Name=PlayerImage
        Image=texture'InterfaceArt_tex.Menu.empty'
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        WinTop=0.12
        WinHeight=0.88
        OnDraw=DHRoleSelection.InternalOnDraw
    End Object
    i_PlayerImage=GUIImage'DH_Interface.DHRoleSelection.PlayerImage'

    Begin Object Class=DHGUIScrollTextBox Name=RoleDescriptionTextBox
        bNoTeletype=true
        OnCreateComponent=RoleDescriptionTextBox.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinHeight=1.0
    End Object
    l_RoleDescription=DHGUIScrollTextBox'DH_Interface.DHRoleSelection.RoleDescriptionTextBox'

    Begin Object Class=GUILabel Name=PlayerNameLabel
        Caption="Name:"
        StyleName="DHLargeText"
        WinWidth=0.35
        WinHeight=0.1
    End Object
    l_PlayerName=GUILabel'DH_Interface.DHRoleSelection.PlayerNameLabel'

    Begin Object Class=DHGUIEditBox Name=PlayerNameEditbox
        TextStr="(Player name)"
        WinLeft=0.35
        WinWidth=0.65
        WinHeight=0.1
        OnActivate=PlayerNameEditbox.InternalActivate
        OnDeActivate=PlayerNameEditbox.InternalDeactivate
        OnChange=DHRoleSelection.InternalOnChange
        OnKeyType=PlayerNameEditbox.InternalOnKeyType
        OnKeyEvent=PlayerNameEditbox.InternalOnKeyEvent
    End Object
    e_PlayerName=DHGUIEditBox'DH_Interface.DHRoleSelection.PlayerNameEditbox'

    Begin Object Class=GUIImage Name=WeaponImage
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        WinWidth=0.65
        WinHeight=0.5
    End Object
    i_WeaponImages(0)=GUIImage'DH_Interface.DHRoleSelection.WeaponImage'
    i_WeaponImages(1)=GUIImage'DH_Interface.DHRoleSelection.WeaponImage'

    Begin Object Class=DHGUIScrollTextBox Name=WeaponDescription
        bNoTeletype=true
        OnCreateComponent=WeaponDescription.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinTop=0.55
        WinHeight=0.45
    End Object
    l_WeaponDescription(0)=DHGUIScrollTextBox'DH_Interface.DHRoleSelection.WeaponDescription'
    l_WeaponDescription(1)=DHGUIScrollTextBox'DH_Interface.DHRoleSelection.WeaponDescription'

    Begin Object Class=DHGuiListBox Name=WeaponListBox
        SelectedStyleName="DHListSelectionStyle"
        OutlineStyleName="ItemOutline"
        bVisibleWhenEmpty=true
        OnCreateComponent=WeaponListBox.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinLeft=0.7
        WinWidth=0.3
        WinHeight=0.5
        TabOrder=0
        OnChange=DHRoleSelection.InternalOnChange
    End Object
    lb_AvailableWeapons(0)=DHGuiListBox'DH_Interface.DHRoleSelection.WeaponListBox'
    lb_AvailableWeapons(1)=DHGuiListBox'DH_Interface.DHRoleSelection.WeaponListBox'

    Begin Object Class=GUIGFXButton Name=EquipButton0
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Scaled
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.2
        WinHeight=0.495
        TabOrder=21
        bTabStop=true
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=EquipButton0.InternalOnKeyEvent
    End Object
    b_Equipment(0)=GUIGFXButton'DH_Interface.DHRoleSelection.EquipButton0'

    Begin Object Class=GUIGFXButton Name=EquipButton1
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Scaled
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinLeft=0.21
        WinWidth=0.2
        WinHeight=0.495
        TabOrder=22
        bTabStop=true
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=EquipButton1.InternalOnKeyEvent
    End Object
    b_Equipment(1)=GUIGFXButton'DH_Interface.DHRoleSelection.EquipButton1'

    Begin Object Class=GUIGFXButton Name=EquipButton2
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Scaled
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinLeft=0.42
        WinWidth=0.2
        WinHeight=0.495
        TabOrder=23
        bTabStop=true
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=EquipButton2.InternalOnKeyEvent
    End Object
    b_Equipment(2)=GUIGFXButton'DH_Interface.DHRoleSelection.EquipButton2'

    Begin Object Class=GUIGFXButton Name=EquipButton3
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Scaled
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinTop=0.505
        WinWidth=0.41
        WinHeight=0.495
        TabOrder=24
        bTabStop=true
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=EquipButton3.InternalOnKeyEvent
    End Object
    b_Equipment(3)=GUIGFXButton'DH_Interface.DHRoleSelection.EquipButton3'

    Begin Object Class=DHGUIScrollTextBox Name=EquipDescTextBox
        bNoTeletype=true
        OnCreateComponent=EquipDescTextBox.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinLeft=0.44
        WinWidth=0.56
        WinHeight=1.0
    End Object
    l_EquipmentDescription=DHGUIScrollTextBox'DH_Interface.DHRoleSelection.EquipDescTextBox'

    Begin Object Class=ROGUIContainerNoSkinAlt Name=ConfigButtonsContainer_inst
        WinTop=0.108333
        WinLeft=0.06
        WinWidth=0.2
        WinHeight=0.6
        OnPreDraw=ConfigButtonsContainer_inst.InternalPreDraw
    End Object
    ConfigButtonsContainer=ROGUIContainerNoSkinAlt'DH_Interface.DHRoleSelection.ConfigButtonsContainer_inst'

    Begin Object Class=DHGUIButton Name=StartNewGameButton
        Caption="Start New Game"
        StyleName="DHSmallTextButtonStyle"
        TabOrder=11
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=StartNewGameButton.InternalOnKeyEvent
    End Object
    b_StartNewGame=DHGUIButton'DH_Interface.DHRoleSelection.StartNewGameButton'

    Begin Object Class=DHGUIButton Name=ServerBrowserButton
        Caption="Server Browser"
        StyleName="DHSmallTextButtonStyle"
        TabOrder=12
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=ServerBrowserButton.InternalOnKeyEvent
    End Object
    b_ServerBrowser=DHGUIButton'DH_Interface.DHRoleSelection.ServerBrowserButton'
    Begin Object Class=DHGUIButton Name=FavoritesButton
        Caption="Add Favorite"
        StyleName="DHSmallTextButtonStyle"
        TabOrder=13
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=FavoritesButton.InternalOnKeyEvent
    End Object
    b_AddFavorite=DHGUIButton'DH_Interface.DHRoleSelection.FavoritesButton'

    Begin Object Class=DHGUIButton Name=MapVotingButton
        Caption="Map Voting"
        StyleName="DHSmallTextButtonStyle"
        TabOrder=2
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=MapVotingButton.InternalOnKeyEvent
    End Object
    b_MapVoting=DHGUIButton'DH_Interface.DHRoleSelection.MapVotingButton'

    Begin Object Class=DHGUIButton Name=KickVotingButton
        Caption="Kick Voting"
        StyleName="DHSmallTextButtonStyle"
        TabOrder=14
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=KickVotingButton.InternalOnKeyEvent
    End Object
    b_KickVoting=DHGUIButton'DH_Interface.DHRoleSelection.KickVotingButton'

    Begin Object Class=DHGUIButton Name=CommunicationButton
        Caption="Communication"
        StyleName="DHSmallTextButtonStyle"
        TabOrder=15
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=CommunicationButton.InternalOnKeyEvent
    End Object
    b_Communication=DHGUIButton'DH_Interface.DHRoleSelection.CommunicationButton'
    Begin Object Class=DHGUIButton Name=ConfigurationButton
        Caption="Configuration"
        StyleName="DHSmallTextButtonStyle"
        TabOrder=16
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=ConfigurationButton.InternalOnKeyEvent
    End Object
    b_Configuration=DHGUIButton'DH_Interface.DHRoleSelection.ConfigurationButton'

    Begin Object Class=DHGUIButton Name=ExitROButton
        Caption="Exit Darkest Hour"
        StyleName="DHSmallTextButtonStyle"
        TabOrder=17
        OnClick=DHRoleSelection.InternalOnClick
        OnKeyEvent=ExitROButton.InternalOnKeyEvent
    End Object
    b_ExitRO=DHGUIButton'DH_Interface.DHRoleSelection.ExitROButton'

    ConfigurationButtonText1="Options"
    ConfigurationButtonHint1="Show game and configuration options"
    Background=texture'DH_GUI_Tex.Menu.midgamemenu'
}
