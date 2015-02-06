//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHRoleSelectPanel extends UT2K4TabPanel
    config;

// DELETE THIS:: well should I?
#exec OBJ LOAD FILE=..\Animations\Characters_anm.ukx
#exec OBJ LOAD FILE=..\Textures\Characters_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\WeaponPickupSM.usx

// Constants
const NUM_ROLES = 10;


// Containers
var automated ROGUIProportionalContainer    MainContainer;

var automated ROGUIProportionalContainer    RolesContainer,
                                            PrimaryWeaponContainer,
                                            SecondaryWeaponContainer,
                                            EquipContainer;

var automated GUILabel                      l_RolesTitle,
                                            l_PrimaryWeaponTitle,
                                            l_SecondaryWeaponTitle,
                                            l_EquipTitle;


var automated BackgroundImage               bg_Background;

// Button bar
var automated GUIButton                     b_Disconnect,
                                            b_Map,
                                            b_Score,
                                            b_Config,
                                            b_Continue;

// Current units controls


// Roles controls

var ROGUIListPlus                           li_Roles;
var automated GUIListBox                    lb_Roles;


// Weapons (both primary and secondary) controls
var automated GUIImage                      i_WeaponImages[2];
var ROGUIListPlus                           li_AvailableWeapons[2];
var automated GUIListBox                    lb_AvailableWeapons[2];

// Equipment
var automated GUIGFXButton                  b_Equipment[4];

// Localized text

var localized string                        NoSelectedRoleText;
var localized string                        RoleHasBotsText;
var localized string                        RoleFullText;
var localized string                        SelectEquipmentText;
var localized string                        RoleIsFullMessageText;
var localized string                        ChangingRoleMessageText;
var localized string                        UnknownErrorMessageText;
var localized string                        ErrorChangingTeamsMessageText;

var localized string                        UnknownErrorSpectatorMissingReplicationInfo;
var localized string                        SpectatorErrorTooManySpectators;
var localized string                        SpectatorErrorRoundHasEnded;
var localized string                        UnknownErrorTeamMissingReplicationInfo;
var localized string                        ErrorTeamMustJoinBeforeStart;
var localized string                        TeamSwitchErrorTooManyPlayers;
var localized string                        UnknownErrorTeamMaxLives;
var localized string                        TeamSwitchErrorRoundHasEnded;
var localized string                        TeamSwitchErrorGameHasStarted;
var localized string                        TeamSwitchErrorPlayingAgainstBots;
var localized string                        TeamSwitchErrorTeamIsFull;

var localized string                        ConfigurationButtonText1;
var localized string                        ConfigurationButtonHint1;
var localized string                        ConfigurationButtonText2;
var localized string                        ConfigurationButtonHint2;


// Variables
var ROGameReplicationInfo       GRI;
var RORoleInfo                  currentRole, desiredRole;
var int                         currentTeam, desiredTeam;
var string                      currentName, desiredName;
var int                         currentWeapons[2], desiredWeapons[2];

var float                       SavedMainContainerPos, SavedConfigButtonsContainerPos;

var float                       RoleSelectFooterButtonsWinTop,
                                OptionsFooterButtonsWinTop;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    //class'ROInterfaceUtil'.static.SetROStyle(MyController, Controls);

    GRI = ROGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    // Main containers
    /*
    MainContainer.ManageComponent(UnitsContainer);
    MainContainer.ManageComponent(l_RolesTitle);
    MainContainer.ManageComponent(RolesContainer);
    MainContainer.ManageComponent(PlayerContainer);
    MainContainer.ManageComponent(l_RoleDescTitle);


    MainContainer.ManageComponent(l_PrimaryWeaponTitle);
    MainContainer.ManageComponent(PrimaryWeaponContainer);
    MainContainer.ManageComponent(l_SecondaryWeaponTitle);
    MainContainer.ManageComponent(SecondaryWeaponContainer);
    MainContainer.ManageComponent(l_EquipTitle);
    */
    //MainContainer.ManageComponent(EquipContainer);


    // Current units container

    // Roles container
    //RolesContainer.ManageComponent(lb_Roles);
    li_Roles = ROGUIListPlus(lb_Roles.List);

    // Primary weapon container
    PrimaryWeaponContainer.ManageComponent(i_WeaponImages[0]);
    PrimaryWeaponContainer.ManageComponent(lb_AvailableWeapons[0]);
    li_AvailableWeapons[0] = ROGUIListPlus(lb_AvailableWeapons[0].List);

    // Secondary weapon container
    SecondaryWeaponContainer.ManageComponent(i_WeaponImages[1]);
    SecondaryWeaponContainer.ManageComponent(lb_AvailableWeapons[1]);
    li_AvailableWeapons[1] = ROGUIListPlus(lb_AvailableWeapons[1].List);

    // Equipment container
    EquipContainer.ManageComponent(b_Equipment[0]);
    EquipContainer.ManageComponent(b_Equipment[1]);
    EquipContainer.ManageComponent(b_Equipment[2]);
    EquipContainer.ManageComponent(b_Equipment[3]);

    // Get player's initial values (name, team, role, weapons)
    GetInitialValues();

    // Fill roles list
    FillRoleList();
    if (currentRole == none)
    {
        AutoPickRole();
        NotifyDesiredRoleUpdated();
    }
    else
        ChangeDesiredRole(currentRole);

    // Set controls visibility
    UpdateConfigButtonsVisibility();

    // Set initial counts
    Timer();
    SetTimer(0.1, true);
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

function ChangeDesiredRole(RORoleInfo newRole)
{
    local int roleIndex;

    // Don't change role if we already have correct role selected
    if (newRole == desiredRole && desiredTeam != -1)
        return;

    desiredRole = newRole;
    if (newRole == none)
    {
        li_Roles.SetIndex(-1);
    }
    else
    {
        roleIndex = FindRoleIndexInList(newRole);
        if (roleIndex != -1)
            li_Roles.SetIndex(roleIndex);
    }

    NotifyDesiredRoleUpdated();
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

function NotifyDesiredRoleUpdated()
{
    UpdateRoleDescription();
    UpdateWeaponsInfo();
    UpdatePlayerInfo();
}

function ChangeDesiredTeam(int team)
{
    desiredTeam = team;
    desiredRole = none;
    desiredWeapons[0] = -1;
    desiredWeapons[1] = -1;

    FillRoleList();
    AutoPickRole();
}

function int FindRoleIndexInList(RORoleInfo newRole)
{
    local int i;

    if (li_Roles.ItemCount == 0)
        return -1;

    for (i = 0; i < li_Roles.ItemCount; i++)
        if (newRole == li_Roles.GetObjectAtIndex(i))
            return i;

    return -1;
}

function UpdateRoleDescription()
{
/*no more role description remove this*/
}

function UpdatePlayerInfo()
{

}

function UpdateWeaponsInfo()
{
    local int i;

    // Clear boxes
    li_AvailableWeapons[0].Clear();
    li_AvailableWeapons[1].Clear();
    ClearEquipment();

    // Clear descriptions & images
    i_WeaponImages[0].Image = none;
    i_WeaponImages[1].Image = none;

    if (desiredRole != none)
    {
        // Update available primary weapons list
        for (i = 0; i < ArrayCount(desiredRole.PrimaryWeapons); i++)
            if (desiredRole.PrimaryWeapons[i].item != none)
                li_AvailableWeapons[0].Add(desiredRole.PrimaryWeapons[i].Item.default.ItemName,, string(i));
        //li_AvailableWeapons[0].SortList();

        // Update available secondary weapons list
        for (i = 0; i < ArrayCount(desiredRole.SecondaryWeapons); i++)
            if (desiredRole.SecondaryWeapons[i].item != none)
                li_AvailableWeapons[1].Add(desiredRole.SecondaryWeapons[i].Item.default.ItemName,, string(i));
        //li_AvailableWeapons[1].SortList();

        // Update equipment
        UpdateRoleEquipment();

        AutoPickWeapons();
    }
}

function ClearEquipment()
{
    local int i;

    for (i = 0; i < 4; i++)
    {
        b_Equipment[i].Graphic = none;
        b_Equipment[i].bVisible = false;
    }
}

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

function AutoPickWeapons()
{
    local int i;

    // If we already had selected a weapon, then re-select it.
    if (currentTeam == desiredTeam && currentRole == desiredRole &&
        desiredWeapons[0] == -5 && desiredWeapons[1] == -5)
    {
        for (i = 0; i < 2; i++)
        {
            desiredWeapons[i] = currentWeapons[i];

            if (li_AvailableWeapons[i].ItemCount != 0)
                li_AvailableWeapons[i].SetIndex(FindIndexInWeaponsList(desiredWeapons[i], li_AvailableWeapons[i]));

            UpdateSelectedWeapon(i);
        }
    }
    else
    {
        // Simple implementation, just select first weapon in list.
        for (i = 0; i < 2; i++)
        {
            if (li_AvailableWeapons[i].ItemCount != 0)
                li_AvailableWeapons[i].SetIndex(0);

            desiredWeapons[i] = int(li_AvailableWeapons[i].GetExtraAtIndex(0));

            UpdateSelectedWeapon(i);
        }
    }
}

function int FindIndexInWeaponsList(int index, GUIList list)
{
    local int i;
    for (i = 0; i < list.ItemCount; i++)
        if (int(list.GetExtraAtIndex(i)) == index)
            return i;

    return -1;
}

function UpdateSelectedWeapon(int weaponCategory)
{
    local class<InventoryAttachment> AttachClass;
    local class<ROWeaponAttachment> WeaponAttach;
    local int i;
    local class<Inventory> item;

    // Clear current weapon display
    i_WeaponImages[weaponCategory].Image = none;

    if (desiredRole != none)
    {
        i = int(li_AvailableWeapons[weaponCategory].GetExtra());
        if (weaponCategory == 0)
            item = desiredRole.PrimaryWeapons[i].Item;
        else
            item = desiredRole.SecondaryWeapons[i].Item;

        if (item != none)
        {
            AttachClass = item.default.AttachmentClass;
            WeaponAttach = class<ROWeaponAttachment>(AttachClass);
            if (WeaponAttach != none)
            {
                if (WeaponAttach.default.menuImage != None)
                    i_WeaponImages[weaponCategory].Image = WeaponAttach.default.menuImage;
            }

            desiredWeapons[weaponCategory] = i;

            // Update current weapon on player model
            UpdatePlayerInfo();
        }
    }
}

// Used to update team counts & role counts
function Timer()
{
    UpdateTeamCounts();
    UpdateRoleCounts();
}

function UpdateTeamCounts()
{
    //l_numAxis.Caption = "" $ getTeamCount(ALLIES_TEAM_INDEX);
    //l_numAllies.Caption = "" $ getTeamCount(AXIS_TEAM_INDEX);
}

function int getTeamCount(int index)
{
    return class'ROGUITeamSelection'.static.getTeamCountStatic(GRI, PlayerOwner(), index);
}

function UpdateRoleCounts()
{
    local int i, roleLimit, roleCurrentCount, roleBotCount;
    local RORoleInfo role;
    local bool bHasBots, bIsFull;

    if (desiredTeam != AXIS_TEAM_INDEX && desiredTeam != ALLIES_TEAM_INDEX)
        return;

    for (i = 0; i < li_Roles.ItemCount; i++)
    {
        role = RORoleInfo(li_Roles.GetObjectAtIndex(i));
        if (role == none)
            continue;

        bIsFull = checkIfRoleIsFull(role, desiredTeam, roleLimit, roleCurrentCount, roleBotCount);
        bHasBots = (roleBotCount > 0);

        if( ROPlayer(PlayerOwner()) != none &&  ROPlayer(PlayerOwner()).bUseNativeRoleNames )
        {
            li_Roles.SetItemAtIndex(i, FormatRoleString(role.AltName, roleLimit, roleCurrentCount, bHasBots));
        }
        else
        {
            li_Roles.SetItemAtIndex(i, FormatRoleString(role.MyName, roleLimit, roleCurrentCount, bHasBots));
        }
        li_Roles.SetDisabledAtIndex(i, bIsFull);
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

function string FormatRoleString(string roleName, int roleLimit, int roleCount, bool bHasBots)
{
    local string s;
    if (roleLimit == 0)
        s = roleName $ " [" $ roleCount $ "]";
    else
    {
        if (roleCount == roleLimit && !bHasBots)
            s = roleName $ " [" $ RoleFullText $ "]";
        else
            s = roleName $ " [" $ roleCount $ "/" $ roleLimit $ "]";
    }

    if (bHasBots)
        return s $ RoleHasBotsText;
    else
        return s;
}

function AttemptRoleApplication()
{
    local ROPlayer player;
    local byte teamIndex, roleIndex, w1, w2;

    player = ROPlayer(PlayerOwner());

    if (player == none)
    {
        warn("Unable to cast PlayerOwner() to ROPlayer in ROGUIRoleSelection.AttemptRoleApplication() !");
        return;
    }

    // Change player name (no need for confirmation on this)
    if (desiredName != currentName)
    {
        player.ReplaceText(desiredName, "\"", "");
        player.ConsoleCommand("SetName"@desiredName);
        currentName = desiredName;
    }

    // Get desired team info
    if (desiredTeam == currentTeam)
    {
        teamIndex = 255;    // No change
    }
    else
    {
        if (desiredTeam == -1)
            teamIndex = 254; // spectator
        else
            teamIndex = desiredTeam;
    }

    // Get role switch info
    if (teamIndex == 254 || (teamIndex == 255 && desiredTeam == -1))
        roleIndex = 255; // no role switch if we're spectating
    else if (desiredRole == none)
    {
        warn("No role selected, using role #0");
        roleIndex = 0; // force role of 0 if we havn't picked a role (should never happen)
    }
    else if (desiredRole == currentRole && desiredTeam == currentTeam)
    {
        roleIndex = 255; // No change
    }
    else
    {
        if (checkIfRoleIsFull(desiredRole, desiredTeam) && Controller != none)
        {
            Controller.OpenMenu(Controller.QuestionMenuClass);
            GUIQuestionPage(Controller.TopPage()).SetupQuestion(RoleIsFullMessageText, QBTN_Ok, QBTN_Ok);
            return;
        }

        roleIndex = FindRoleIndexInGRI(RORoleInfo(li_Roles.GetObject()), desiredTeam);
    }

    // Get weapons info
    w1 = desiredWeapons[0];
    w2 = desiredWeapons[1];
    //if (desiredWeapons[0] == currentWeapons[0] && desiredWeapons[1] == currentWeapons[1])
    //    w1 = 255;

    // Open 'changing role' dialog
    /*if (Controller != none)
    {
        Controller.OpenMenu(QuestionClass);
        GUIQuestionPage(Controller.TopPage()).SetupQuestion(ChangingRoleMessageText, QBTN_Abort, QBTN_Abort);
        GUIQuestionPage(Controller.TopPage()).OnButtonClick = InternalOnAbortButtonClick;
    }*/

    // Disable continue button
    SetContinueButtonState(true);

    // Attempt team, role and weapons change
    player.ServerChangePlayerInfo(teamIndex, roleIndex, w1, w2);
}

function CloseMenu()
{
    local ROPlayer player;

    player = ROPlayer(PlayerOwner());
    if (player != none)
    {
        if (player.bShowMapOnFirstSpawn && !player.bFirstObjectiveScreenDisplayed)
        {
            player.bFirstObjectiveScreenDisplayed = true;
            if( ROHud(player.MyHUD) != none )
                ROHud(player.MyHUD).ShowObjectives();
        }
    }
    // Check if we should start fade-from-black effect on player
    CheckNeedForFadeFromBlackEffect(PlayerOwner());
}

static function CheckNeedForFadeFromBlackEffect(PlayerController controller)
{

}

function SetContinueButtonState(bool bDisabled)
{
    if (bDisabled)
        b_Continue.MenuStateChange(MSAT_Disabled);
    else
        b_Continue.MenuStateChange(MSAT_Blurry);
}

function UpdateConfigButtonsVisibility()
{
    local float myWinTop;

    MainContainer.SetVisibility(true);
    bg_Background.SetVisibility(true);
    b_Config.Caption = ConfigurationButtonText1;
    b_Config.SetHint(ConfigurationButtonHint1);
    myWinTop = RoleSelectFooterButtonsWinTop;

    // To make sure items that should be hidden are hidden
    NotifyDesiredRoleUpdated();


    b_Disconnect.WinTop = myWinTop;
    b_Score.WinTop = myWinTop;
    b_Map.WinTop = myWinTop;
    b_Config.WinTop = myWinTop;
    b_Continue.WinTop = myWinTop;
}

function bool InternalOnClick(GUIComponent Sender)
{
    local ROPlayer player;

    player = ROPlayer(PlayerOwner());

    switch (sender)
    {
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

    return true;
}

function InternalOnChange( GUIComponent Sender )
{
    local string s;
    local RORoleInfo role;

    switch (Sender)
    {
        case lb_Roles:
            role = RORoleInfo(li_Roles.GetObject());
            if (role != none)
                ChangeDesiredRole(role);
            break;

        case lb_AvailableWeapons[0]:
            UpdateSelectedWeapon(0);
            break;

        case lb_AvailableWeapons[1]:
            UpdateSelectedWeapon(1);
            break;
    }
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    if (key == 0x1B)
    {
        CloseMenu();
        return true;
    }

    return super.OnKeyEvent(key, state, delta);
}

function InternalOnMessage(coerce string Msg, float MsgLife)
{
    local int result;
    local string error_msg;

    if (msg == "notify_gui_role_selection_page")
    {
        // Received success/failure message from server.

        result = int(MsgLife);

        switch (result)
        {
            case 0: // All is well!
            case 97:
            case 98:
                // Set flag saying that player is ready to play
                if (ROPlayer(PlayerOwner()) != none)
                    ROPlayer(PlayerOwner()).PlayerReplicationInfo.bReadyToPlay = true;

                CloseMenu();
                return;
                //break;

            default:
                error_msg = getErrorMessageForId(result);
                break;
        }

        SetContinueButtonState(false);

        if (Controller != none)
        {
            Controller.OpenMenu(Controller.QuestionMenuClass);
            GUIQuestionPage(Controller.TopPage()).SetupQuestion(error_msg, QBTN_Ok, QBTN_Ok);
        }
    }
}

function bool InternalOnDraw(Canvas canvas)
{
    return false;
}

function InternalOnClose(optional bool bCancelled)
{
    //Super.OnClose(bCancelled);
}

static function string getErrorMessageForId(int id)
{
    local string error_msg;
    switch (id)
    {
        // TEAM CHANGE ERROR

        case 01: // Couldn't switch to spectator: no player replication info
            error_msg = default.UnknownErrorMessageText $ default.UnknownErrorSpectatorMissingReplicationInfo;
            break;

        case 02: // Couldn't switch to spectator: out of spectator slots
            error_msg = default.SpectatorErrorTooManySpectators;
            break;

        case 03: // Couldn't switch to spectator: game has ended
        case 04: // Couldn't switch to spectator: round has ended
            error_msg = default.SpectatorErrorRoundHasEnded;
            break;


        case 10: // Couldn't switch teams: no player replication info
            error_msg = default.UnknownErrorMessageText $ default.UnknownErrorTeamMissingReplicationInfo;
            break;

        case 11: // Couldn't switch teams: must join team before game start
            error_msg = default.ErrorTeamMustJoinBeforeStart;
            break;

        case 12: // Couldn't switch teams: too many active players
            error_msg = default.TeamSwitchErrorTooManyPlayers;
            break;

        case 13: // Couldn't switch teams: MaxLives > 0 (wtf is this)
            error_msg = default.UnknownErrorMessageText $ default.UnknownErrorTeamMaxLives;
            break;

        case 14: // Couldn't switch teams: game has ended
        case 15: // Couldn't switch teams: round has ended
            error_msg = default.TeamSwitchErrorRoundHasEnded;
            break;

        case 16: // Couldn't switch teams: server rules disallow team changes after game has started
            error_msg = default.TeamSwitchErrorGameHasStarted;
            break;

        case 17: // Couldn't switch teams: playing game against bots
            error_msg = default.TeamSwitchErrorPlayingAgainstBots;
            break;

        case 18: // Couldn't switch teams: team is full
            error_msg = default.TeamSwitchErrorTeamIsFull;
            break;


        case 99: // Couldn't change teams: unknown reason
            error_msg = default.ErrorChangingTeamsMessageText;
            break;


        // ROLE CHANGE ERROR

        case 100: // Couldn't change roles (role is full)
            error_msg = default.RoleIsFullMessageText;
            break;


        case 199: // Couldn't change roles (unknown error)
            error_msg = default.UnknownErrorMessageText;
            break;


        default:
            error_msg = default.UnknownErrorMessageText $ " (id = " $ id $ ")";
    }

    return error_msg;
}

defaultproperties
{
    //bRenderWorld=True

    Background=Texture'DH_GUI_Tex.Menu.DHBox'

    OnKeyEvent=InternalOnKeyEvent
    OnMessage=InternalOnMessage
    //OnDraw=InternalOnDraw
    //OnClose=InternalOnClose

    //bAllowedAsLast=true

    NoSelectedRoleText="Select a role from the role list."
    RoleHasBotsText=" (has bots)"
    RoleFullText="Full"
    SelectEquipmentText="Select an item to view its description."
    RoleIsFullMessageText="The role you selected is full. Select another role from the list and hit continue."
    ChangingRoleMessageText="Please wait while your player information is being updated."
    UnknownErrorMessageText="An unknown error occured when updating player information. Please wait a bit and retry."
    ErrorChangingTeamsMessageText="An error occured when changing teams. Please retry in a few moments or select another team."

    UnknownErrorSpectatorMissingReplicationInfo=" (Spectator switch error: player has no replication info.)"
    SpectatorErrorTooManySpectators="Cannot switch to Spectating mode: too many spectators on server."
    SpectatorErrorRoundHasEnded="Cannot switch to Spectating mode: round has ended."
    UnknownErrorTeamMissingReplicationInfo=" (Team switch error: player has no replication info.)"
    ErrorTeamMustJoinBeforeStart="Cannot switch teams: must join team before game starts."
    TeamSwitchErrorTooManyPlayers="Cannot switch teams: too many active players in game."
    UnknownErrorTeamMaxLives=" (Team switch error: MaxLives > 0)"
    TeamSwitchErrorRoundHasEnded="Cannot switch teams: round has ended."
    TeamSwitchErrorGameHasStarted="Cannot switch teams: server rules disallow team changes after game has started."
    TeamSwitchErrorPlayingAgainstBots="Cannot switch teams: server rules ask for bots on one team and players on the other."
    TeamSwitchErrorTeamIsFull="Cannot switch teams: the selected team is full."

    ConfigurationButtonText1="Options"
    ConfigurationButtonHint1="Show game and configuration options"
    ConfigurationButtonText2="Role Selection"
    ConfigurationButtonHint2="Show the role selection controls"

    RoleSelectFooterButtonsWinTop=0.946667
    OptionsFooterButtonsWinTop=0.958750

    Begin Object Class=BackgroundImage Name=PageBackground
        //Image=texture'DH_GUI_Tex.Menu.DHSectionHeader'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1023
        Y2=1023
    End Object
    bg_Background=BackgroundImage'DH_Interface.DHRoleSelectPanel.PageBackground'

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MainContiner_inst
        WinLeft=0.0
        WinTop=0.0
        WinWidth=1.0
        WinHeight=1.0
        TopPadding=0.0
        LeftPadding=0.0
        RightPadding=0.0
        BottomPadding=0.0
    End Object
    MainContainer=MainContiner_inst

    Begin Object Class=DHGUIButton Name=DisconnectButton
        Caption="Disconnect"
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.012
        WinWidth=0.18
        TabOrder=1
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=DisconnectButton.InternalOnKeyEvent
    End Object
    b_Disconnect=DHGUIButton'DH_Interface.DHRoleSelectPanel.DisconnectButton'

    Begin Object Class=DHGUIButton Name=MapButton
        Caption="Situation Map"
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.22
        WinWidth=0.18
        TabOrder=2
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=MapButton.InternalOnKeyEvent
    End Object
    b_Map=DHGUIButton'DH_Interface.DHRoleSelectPanel.MapButton'

    Begin Object Class=DHGUIButton Name=ScoreButton
        Caption="Score"
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.41
        WinWidth=0.18
        TabOrder=3
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=ScoreButton.InternalOnKeyEvent
    End Object
    b_Score=DHGUIButton'DH_Interface.DHRoleSelectPanel.ScoreButton'

    Begin Object Class=DHGUIButton Name=ConfigButton
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.6
        WinWidth=0.18
        TabOrder=4
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=ConfigButton.InternalOnKeyEvent
    End Object
    b_Config=DHGUIButton'DH_Interface.DHRoleSelectPanel.ConfigButton'

    Begin Object Class=DHGUIButton Name=ContinueButton
        Caption="Continue"
        bAutoShrink=false
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.95875
        WinLeft=0.808000
        WinWidth=0.18
        TabOrder=5
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=ContinueButton.InternalOnKeyEvent
    End Object
    b_Continue=DHGUIButton'DH_Interface.DHRoleSelectPanel.ContinueButton'

    Begin Object Class=GUILabel Name=PrimaryWeaponTitle
        Caption="Primary Weapon"
        TextAlign=TXTA_Left
        StyleName="DHLargeText"
        WinWidth=0.450806
		WinHeight=0.042554
		WinLeft=0.009531
		WinTop=0.427909
    End Object
    l_PrimaryWeaponTitle=GUILabel'DH_Interface.DHRoleSelectPanel.PrimaryWeaponTitle'

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=PrimaryWeaponContainer_inst
        WinWidth=0.975537
		WinHeight=0.182460
		WinLeft=0.023428
		WinTop=0.517182

        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    PrimaryWeaponContainer=PrimaryWeaponContainer_inst

    Begin Object Class=GUILabel Name=SecondaryWeaponTitle
        Caption="Sidearm"
        TextAlign=TXTA_Left
        StyleName="DHLargeText"
        WinWidth=0.457124
		WinHeight=0.034503
		WinLeft=0.013212
		WinTop=0.637017
    End Object
    l_SecondaryWeaponTitle=GUILabel'DH_Interface.DHRoleSelectPanel.SecondaryWeaponTitle'

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=SecondaryWeaponContainer_inst
        WinWidth=0.978091
		WinHeight=0.131546
		WinLeft=0.010659
		WinTop=0.669514
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    SecondaryWeaponContainer=SecondaryWeaponContainer_inst

    Begin Object Class=GUILabel Name=EquipmentWeaponTitle
        Caption="Equipment"
        TextAlign=TXTA_Left
        StyleName="DHLargeText"
        WinWidth=0.343548
		WinHeight=0.042554
		WinLeft=0.042675
		WinTop=0.795098
    End Object
    l_EquipTitle=GUILabel'DH_Interface.DHRoleSelectPanel.EquipmentWeaponTitle'

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=EquipmentContainer_inst
        WinWidth=1.00
		WinHeight=0.112097
		WinLeft=0.0
		WinTop=0.833621
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    EquipContainer=EquipmentContainer_inst

    Begin Object Class=GUILabel Name=RolesTitle
        Caption="Role Selection"
        TextAlign=TXTA_Center
        StyleName="DHLargeText"
        WinWidth=0.392070
		WinHeight=0.045108
		WinLeft=0.280658
		WinTop=0.007675
    End Object
    l_RolesTitle=GUILabel'DH_Interface.DHRoleSelectPanel.RolesTitle'

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=RolesContainer_inst
        WinWidth=0.976899
		WinHeight=0.300269
		WinLeft=0.017662
		WinTop=0.050251
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    RolesContainer=RolesContainer_inst

    // Roles controls

    Begin Object Class=DHGuiListBox Name=Roles
        SelectedStyleName="DHListSelectionStyle"
        OutlineStyleName="ItemOutline"
        bVisibleWhenEmpty=true
        bSorted=true
        OnCreateComponent=Roles.InternalOnCreateComponent
        StyleName="DHSmallText"
        TabOrder=0
        OnChange=DHRoleSelectPanel.InternalOnChange
        WinWidth=0.979453
        WinHeight=1.0
		//WinHeight=0.342819
		WinLeft=0.012554
		WinTop=0.051728
    End Object
    lb_Roles=DHGuiListBox'DH_Interface.DHRoleSelectPanel.Roles'

    // Weapons controls

    Begin Object Class=GUIImage Name=WeaponImage
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        WinWidth=0.65
        WinHeight=0.5
    End Object
    i_WeaponImages(0)=GUIImage'DH_Interface.DHRoleSelectPanel.WeaponImage'
    i_WeaponImages(1)=GUIImage'DH_Interface.DHRoleSelectPanel.WeaponImage'

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
        OnChange=DHRoleSelectPanel.InternalOnChange
    End Object
    lb_AvailableWeapons(0)=DHGuiListBox'DH_Interface.DHRoleSelectPanel.WeaponListBox'
    lb_AvailableWeapons(1)=DHGuiListBox'DH_Interface.DHRoleSelectPanel.WeaponListBox'


    // Equipment controls
    Begin Object Class=GUIGFXButton Name=EquipButton0
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Scaled
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.200000
        WinHeight=0.495
        TabOrder=21
        bTabStop=true
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=EquipButton0.InternalOnKeyEvent
    End Object
    b_Equipment(0)=GUIGFXButton'DH_Interface.DHRoleSelectPanel.EquipButton0'

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
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=EquipButton1.InternalOnKeyEvent
    End Object
    b_Equipment(1)=GUIGFXButton'DH_Interface.DHRoleSelectPanel.EquipButton1'

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
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=EquipButton2.InternalOnKeyEvent
    End Object
    b_Equipment(2)=GUIGFXButton'DH_Interface.DHRoleSelectPanel.EquipButton2'

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
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=EquipButton3.InternalOnKeyEvent
    End Object
    b_Equipment(3)=GUIGFXButton'DH_Interface.DHRoleSelectPanel.EquipButton3'

}
