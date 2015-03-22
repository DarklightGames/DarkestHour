//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHRoleSelectPanel extends DHDeployMenuPanel
    config;

const NUM_ROLES = 10;

var automated ROGUIProportionalContainer    RolesContainer,
                                            PrimaryWeaponContainer,
                                            SecondaryWeaponContainer,
                                            EquipContainer;

var automated GUILabel                      l_EstimatedRedeployTime;

var automated GUIImage                      i_WeaponImages[2], i_MagImages[2];
var automated DHGUIListBox                  lb_Roles, lb_AvailableWeapons[2];
var automated GUIGFXButton                  b_Equipment[4];
var automated DHGUINumericEdit              nu_PrimaryAmmoMags;

var ROGUIListPlus                           li_Roles, li_AvailableWeapons[2];

var localized string                        NoSelectedRoleText,
                                            RoleHasBotsText,
                                            CurrentRoleText,
                                            RoleFullText,
                                            SelectEquipmentText,
                                            RoleIsFullMessageText,
                                            ChangingRoleMessageText,
                                            UnknownErrorMessageText,
                                            ErrorChangingTeamsMessageText,
                                            RedeployTimeText,
                                            SecondsText;

var localized string                        UnknownErrorSpectatorMissingReplicationInfo,
                                            SpectatorErrorTooManySpectators,
                                            SpectatorErrorRoundHasEnded,
                                            UnknownErrorTeamMissingReplicationInfo,
                                            ErrorTeamMustJoinBeforeStart,
                                            TeamSwitchErrorTooManyPlayers,
                                            UnknownErrorTeamMaxLives,
                                            TeamSwitchErrorRoundHasEnded,
                                            TeamSwitchErrorGameHasStarted,
                                            TeamSwitchErrorPlayingAgainstBots,
                                            TeamSwitchErrorTeamIsFull;

var RORoleInfo                              currentRole, desiredRole;
var int                                     currentTeam, desiredTeam;
var string                                  currentName, desiredName;
var int                                     currentWeapons[2], desiredWeapons[2];
var float                                   SavedMainContainerPos, RoleSelectFooterButtonsWinTop, RoleSelectReclickTime;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    Log(self @ "InitComponent");

    // Roles container
    li_Roles = ROGUIListPlus(lb_Roles.List);
    RolesContainer.ManageComponent(lb_Roles);

    // Primary weapon container
    PrimaryWeaponContainer.ManageComponent(i_WeaponImages[0]);
    PrimaryWeaponContainer.ManageComponent(lb_AvailableWeapons[0]);
    PrimaryWeaponContainer.ManageComponent(i_MagImages[0]);
    PrimaryWeaponContainer.ManageComponent(nu_PrimaryAmmoMags);
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

    // Change background from default if team == Axis
    if (currentTeam == Axis_Team_Index)
    {
        Background=Texture'DH_GUI_Tex.Menu.AxisLoadout_BG';
    }

    // Fill roles list
    FillRoleList();
    if (currentRole == none || DHP.DesiredRole == -1)
    {
        AutoPickRole();
    }
    else
    {
        ChangeDesiredRole(currentRole);
    }

    // Set initial counts
    Timer();
    SetTimer(0.1, true);

    Log("Players team is: " $ DHP.GetTeamNum());
}

function ShowPanel(bool bShow)
{
    local DHSpawnPoint SP;

    super.ShowPanel(bShow);

    if (bShow && MyDeployMenu != none)
    {
        MyDeployMenu.Tab = TAB_Role;

        // Check if SpawnPointIndex is valid
        if (DHGRI.IsSpawnPointIndexValid(DHP.SpawnPointIndex, DHP.GetTeamNum()))
        {
            SP = DHGRI.GetSpawnPoint(DHP.SpawnPointIndex);
        }

        // If spawnpoint index is type vehicles, then nullify it
        if (SP != none && SP.Type == ESPT_Vehicles)
        {
            DHP.ServerChangeSpawn(-1, -1, DHP.SpawnVehicleIndex);
        }
        else // Just nullify vehicle pool
        {
            DHP.ServerChangeSpawn(DHP.SpawnPointIndex, -1, DHP.SpawnVehicleIndex);
        }
    }
}

// This function informs InternalOnChange not to run until we are done rendering
function bool OnPostDraw(Canvas C)
{
    super.OnPostDraw(C);

    return true;
}

function GetInitialValues()
{
    // Get player's current role and team (if any)
    if (PRI != none)
    {
        // Get player's current team
        if (DHP != none && DHP.ForcedTeamSelectOnRoleSelectPage != -5)
        {
            currentTeam = DHP.ForcedTeamSelectOnRoleSelectPage;
            desiredTeam = DHP.ForcedTeamSelectOnRoleSelectPage;
            // Force role reset, this stops an exploit allowing you to be on the opposite team with previous team's role
            currentRole = none;
            desiredRole = none;
            DHP.CurrentRole = -1;
            DHP.DesiredRole = -1;
            DHP.ForcedTeamSelectOnRoleSelectPage = -5;
        }
        else if (PRI.bOnlySpectator)
        {
            currentTeam = -1;
        }
        else if (PRI.Team != none)
        {
            currentTeam = DHP.GetTeamNum();
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
        desiredRole = none;
    }
    else if (DHP.CurrentRole != DHP.DesiredRole)
    {
        if (currentTeam == AXIS_TEAM_INDEX)
        {
            currentRole = DHGRI.DHAxisRoles[DHP.DesiredRole];
        }
        else if (currentTeam == ALLIES_TEAM_INDEX)
        {
            currentRole = DHGRI.DHAlliesRoles[DHP.DesiredRole];
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
    currentName = DHP.GetUrlOption("Name");

    // Get player's current weapons
    if (currentRole == none)
    {
        currentWeapons[0] = -1;
        currentWeapons[1] = -1;
    }
    else if (DHP.CurrentRole != DHP.DesiredRole)
    {
        currentWeapons[0] = DHP.DesiredPrimary;
        currentWeapons[1] = DHP.DesiredSecondary;
    }
    else
    {
        currentWeapons[0] = DHP.PrimaryWeapon;
        currentWeapons[1] = DHP.SecondaryWeapon;
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

    li_Roles.Clear();

    ChangeDesiredRole(none);

    if (desiredTeam != AXIS_TEAM_INDEX && desiredTeam != ALLIES_TEAM_INDEX)
    {
        return;
    }

    for (i = 0; i < arraycount(DHGRI.DHAxisRoles); ++i)
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

        if (DHP != none && DHP.bUseNativeRoleNames)
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
        {
            li_Roles.SetIndex(roleIndex);
            NotifyDesiredRoleUpdated();
        }
    }
}

function AutoPickRole()
{
    local int i, currentRoleCount;
    local RORoleInfo role;

    if (desiredTeam == AXIS_TEAM_INDEX || desiredTeam == ALLIES_TEAM_INDEX)
    {
        // Pick the first non-full role
        for (i = 0; i < arraycount(DHGRI.DHAxisRoles); ++i)
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

            if (role.GetLimit(DHGRI.MaxPlayers) == 0) //Pick role with no max
            {
                ChangeDesiredRole(role);
                AttemptRoleApplication();
                return;
            }
        }

        Warn("All roles are full!");
    }
    else
    {
        ChangeDesiredRole(none);
    }
}

function NotifyDesiredRoleUpdated()
{
    UpdateWeaponsInfo();

    MyDeployMenu.bRoleIsCrew = desiredRole.default.bCanBeTankCrew;
}

function int FindRoleIndexInList(RORoleInfo newRole)
{
    local int i;

    if (li_Roles.ItemCount == 0)
        return -1;

    for (i = 0; i < li_Roles.ItemCount; ++i)
        if (newRole == li_Roles.GetObjectAtIndex(i))
            return i;

    return -1;
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
    i_MagImages[0].Image = none;

    if (desiredRole != none)
    {
        // Update available primary weapons list
        for (i = 0; i < arraycount(desiredRole.PrimaryWeapons); ++i)
        {
            if (desiredRole.PrimaryWeapons[i].item != none)
            {
                li_AvailableWeapons[0].Add(desiredRole.PrimaryWeapons[i].Item.default.ItemName,, string(i));
            }
        }
        // Update available secondary weapons list
        for (i = 0; i < arraycount(desiredRole.SecondaryWeapons); ++i)
        {
            if (desiredRole.SecondaryWeapons[i].item != none)
            {
                li_AvailableWeapons[1].Add(desiredRole.SecondaryWeapons[i].Item.default.ItemName,, string(i));
            }
        }
        // Update equipment
        UpdateRoleEquipment();

        AutoPickWeapons();
    }
}

function ClearEquipment()
{
    local int i;

    for (i = 0; i < 4; ++i)
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
    for (i = 0; i < arraycount(desiredRole.Grenades); ++i)
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
    for (i = 0; i < desiredRole.GivenItems.Length; ++i)
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
        for (i = 0; i < 2; ++i)
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
        for (i = 0; i < 2; ++i)
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
    for (i = 0; i < list.ItemCount; ++i)
        if (int(list.GetExtraAtIndex(i)) == index)
            return i;

    return -1;
}

//Theel fix this function, strange if/else embedding
function UpdateSelectedWeapon(int weaponCategory)
{
    local int i;
    local class<Inventory> item;

    // Clear current weapon & mag display
    i_WeaponImages[weaponCategory].Image = none;
    if (weaponCategory == 0)
    {
        i_MagImages[weaponCategory].Image = none;
    }

    if (desiredRole != none)
    {
        i = int(li_AvailableWeapons[weaponCategory].GetExtra());

        if (weaponCategory == 0)
        {
            item = desiredRole.PrimaryWeapons[i].Item;

            // Set min/max/mid for ammo button on primary weapon
            if (item != none)
            {
                nu_PrimaryAmmoMags.MinValue = DH_RoleInfo(desiredRole).MinStartAmmo * class<DH_ProjectileWeapon>(item).default.MaxNumPrimaryMags / 100;
                if (nu_PrimaryAmmoMags.MinValue < 1)
                {
                    nu_PrimaryAmmoMags.MinValue = 1;
                }
                nu_PrimaryAmmoMags.MidValue = DH_RoleInfo(desiredRole).DefaultStartAmmo * class<DH_ProjectileWeapon>(item).default.MaxNumPrimaryMags / 100;
                nu_PrimaryAmmoMags.MaxValue = DH_RoleInfo(desiredRole).MaxStartAmmo * class<DH_ProjectileWeapon>(item).default.MaxNumPrimaryMags / 100;

                // Set value to desired, if desired is out of range, set desired to clamped value
                nu_PrimaryAmmoMags.Value = string(DHP.DesiredAmmoAmount);
                if (int(nu_PrimaryAmmoMags.Value) < nu_PrimaryAmmoMags.MinValue || int(nu_PrimaryAmmoMags.Value) > nu_PrimaryAmmoMags.MaxValue)
                {
                    nu_PrimaryAmmoMags.Value = string(nu_PrimaryAmmoMags.MidValue); // Will reset value to mid if out of range
                }
                nu_PrimaryAmmoMags.CheckValue(); // Hard clamps value to be in range (visually)
                DHP.DesiredAmmoAmount = int(nu_PrimaryAmmoMags.Value);
                nu_PrimaryAmmoMags.SetVisibility(true);
            }
            else
            {
                nu_PrimaryAmmoMags.SetVisibility(false);
            }
        }
        else
        {
            item = desiredRole.SecondaryWeapons[i].Item;
        }

        if (item != none)
        {
            if (class<ROWeaponAttachment>(item.default.AttachmentClass) != none)
            {
                i_WeaponImages[weaponCategory].Image = class<ROWeaponAttachment>(item.default.AttachmentClass).default.menuImage;
            }

            if (class<Weapon>(item) != none &&
                class<Weapon>(item).default.FireModeClass[0] != none &&
                class<Weapon>(item).default.FireModeClass[0].default.AmmoClass != none &&
                weaponCategory == 0)
            {
                i_MagImages[weaponCategory].Image = class<Weapon>(item).default.FireModeClass[0].default.AmmoClass.default.IconMaterial;
            }

            desiredWeapons[weaponCategory] = i;

            // Update deploy time
            l_EstimatedRedeployTime.Caption = RedeployTimeText @ DHP.CalculateDeployTime(-1,desiredRole,desiredWeapons[0]) @ SecondsText;
        }
    }
}

// Used to update team counts & role counts
function Timer()
{
    UpdateRoleCounts();
    if (RoleSelectReclickTime < default.RoleSelectReclickTime)
    {
        RoleSelectReclickTime += 0.1; //Theel this shouldn't be a floating number it is reused
    }
    else
    {
        RoleSelectReclickTime = default.RoleSelectReclickTime;
    }
}

function int getTeamCount(int index)
{
    return class'ROGUITeamSelection'.static.getTeamCountStatic(DHGRI, PlayerOwner(), index);
}

function UpdateRoleCounts()
{
    local int i, roleLimit, roleCurrentCount, roleBotCount;
    local RORoleInfo role;
    local bool bHasBots, bIsFull, bIsCurrent;

    if (desiredTeam != AXIS_TEAM_INDEX && desiredTeam != ALLIES_TEAM_INDEX)
        return;

    for (i = 0; i < li_Roles.ItemCount; ++i)
    {
        role = RORoleInfo(li_Roles.GetObjectAtIndex(i));
        if (role == none)
            continue;

        bIsFull = checkIfRoleIsFull(role, desiredTeam, roleLimit, roleCurrentCount, roleBotCount);
        bHasBots = (roleBotCount > 0);

        if (role == currentRole)
        {
            bIsCurrent = true;
        }
        else
        {
            bIsCurrent = false;
        }

        if (DHP != none && DHP.bUseNativeRoleNames)
        {
            li_Roles.SetItemAtIndex(i, FormatRoleString(role.AltName, roleLimit, roleCurrentCount, bHasBots, bIsCurrent));
        }
        else
        {
            li_Roles.SetItemAtIndex(i, FormatRoleString(role.MyName, roleLimit, roleCurrentCount, bHasBots, bIsCurrent));
        }
        li_Roles.SetDisabledAtIndex(i, bIsFull);
    }
}

function bool checkIfRoleIsFull(RORoleInfo role, int team, optional out int roleLimit, optional out int roleCount, optional out int roleBotCount)
{
    local int index;

    index = FindRoleIndexInGRI(role, team);

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

    roleLimit = role.GetLimit(DHGRI.MaxPlayers);

    return (roleCount == roleLimit) && (roleLimit != 0) && !(roleBotCount > 0) && (currentRole != role);
}

function int FindRoleIndexInGRI(RORoleInfo role, int team)
{
    local int i;

    if (team == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.DHAxisRoles); ++i)
        {
            if (DHGRI.DHAxisRoles[i] == role)
            {
                return i;
            }
        }
    }
    else if (team == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.DHAlliesRoles); ++i)
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

function string FormatRoleString(string roleName, int roleLimit, int roleCount, bool bHasBots, optional bool bIsCurrentRole)
{
    local string s;

    if (roleLimit == 0)
    {
        s = roleName $ " [" $ roleCount $ "]";
    }
    else
    {
        if (roleCount == roleLimit && !bHasBots)
            s = roleName $ " [" $ RoleFullText $ "]";
        else
            s = roleName $ " [" $ roleCount $ "/" $ roleLimit $ "]";
    }

    if (bIsCurrentRole)
    {
        s = s @ CurrentRoleText;
    }

    if (bHasBots)
    {
        s = s $ RoleHasBotsText;
    }

    return s;
}

//This function needs work
function AttemptRoleApplication(optional bool bDontShowErrors)
{
    local byte teamIndex, roleIndex, w1, w2;

    //Theel's fast check to see if we even need to attempt role change
    if (currentRole != desiredRole ||
        currentTeam != desiredTeam ||
        currentName != desiredName ||
        currentWeapons[0] != desiredWeapons[0] ||
        currentWeapons[1] != desiredWeapons[1] ||
        nu_PrimaryAmmoMags.Value != string(DHP.DesiredAmmoAmount))
    {
        //Do nothing for now
    }
    else
    {
        return;
    }

    if (DHP == none)
    {
        warn("Unable to cast PlayerOwner() to ROPlayer in ROGUIRoleSelection.AttemptRoleApplication() !");
        return;
    }

    // Change player name (no need for confirmation on this)
    if (desiredName != currentName)
    {
        DHP.ReplaceText(desiredName, "\"", "");
        DHP.ConsoleCommand("SetName"@desiredName);
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
        if (checkIfRoleIsFull(desiredRole, desiredTeam) && Controller != none && !bDontShowErrors)
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

    // Make sure DesiredAmmoAmount is set
    DHP.DesiredAmmoAmount = byte(nu_PrimaryAmmoMags.Value);

    // Attempt team, role and weapons change
    DHP.ServerChangePlayerInfo(teamIndex, roleIndex, w1, w2);

    // We possibly changed, so lets update the values  THis might be causing bugs on semi-failure
    currentRole = desiredRole;
    currentTeam = desiredTeam;
    currentName = desiredName;
    currentWeapons[0] = desiredWeapons[0];
    currentWeapons[1] = desiredWeapons[1];
    //GetInitialValues(); //gulp lets see if this works and doesn't bug the fuck out
}

function bool InternalOnClick(GUIComponent Sender)
{
    switch (sender)
    {
        case b_MenuButton:
            MyDeployMenu.HandleMenuButton();
            break;

        case lb_AvailableWeapons[0]:
            UpdateSelectedWeapon(0);
            break;

        case lb_AvailableWeapons[1]:
            UpdateSelectedWeapon(1);
            break;
    }

    return true;
}

function InternalOnChange(GUIComponent Sender)
{
    local RORoleInfo role;

    if (!bRendered)
    {
        return;
    }

    switch (Sender)
    {
        case lb_Roles:
            role = RORoleInfo(li_Roles.GetObject());
            if (role != none && RoleSelectReclickTime == default.RoleSelectReclickTime)
            {
                // Because we changed role, lets reset our desired ammo
                DHP.DesiredAmmoAmount = 0;

                RoleSelectReclickTime = 0.0;
                ChangeDesiredRole(role);
                AttemptRoleApplication();
            }
            else
            {
                // We clicked another role, but we tried changing too fast, lets force index back
                if (role != none && desiredRole != none && desiredRole != role)
                {
                    li_Roles.SetIndex(li_Roles.FindItemObject(desiredRole));
                }
            }
            break;

        case nu_PrimaryAmmoMags:
            DHP.DesiredAmmoAmount = byte(nu_PrimaryAmmoMags.Value);
            l_EstimatedRedeployTime.Caption = RedeployTimeText @ DHP.CalculateDeployTime(-1,desiredRole,desiredWeapons[0]) @ SecondsText;
            break;
    }
}

//WTF IS THIS DOING?
function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    if (key == 0x1B)
    {
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
        result = int(MsgLife);

        switch (result)
        {
            case 0: // All is well!
            case 97:
            case 98:
                if (DHP != none)
                {
                    DHP.PlayerReplicationInfo.bReadyToPlay = true;
                }
                return;

            default:
                error_msg = getErrorMessageForId(result);
                break;
        }

        if (Controller != none)
        {
            Controller.OpenMenu(Controller.QuestionMenuClass);
            GUIQuestionPage(Controller.TopPage()).SetupQuestion(error_msg, QBTN_Ok, QBTN_Ok);
        }
    }
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

event Closed(GUIComponent Sender, bool bCancelled)
{
    super.Closed(Sender, bCancelled);

    AttemptRoleApplication(true);
}

defaultproperties
{
    Background=Texture'DH_GUI_Tex.Menu.AlliesLoadout_BG'
    OnPostDraw=OnPostDraw
    OnKeyEvent=InternalOnKeyEvent
    OnMessage=InternalOnMessage
    bNeverFocus=true
    RoleSelectReclickTime=1.0
    NoSelectedRoleText="Select a role from the role list."
    RoleHasBotsText=" (has bots)"
    CurrentRoleText="Current Role"
    RoleFullText="Full"
    RedeployTimeText="Estimated redeploy time:"
    SecondsText="seconds"

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

    RoleSelectFooterButtonsWinTop=0.946667

    // Estimated deploy time label
    Begin Object Class=GUILabel Name=EstimatedRedeployTime
        Caption="Estimated Redeploy Time:"
        TextAlign=TXTA_Center
        StyleName="DHLargeText"
        WinWidth=1.0
        WinHeight=0.03
        WinLeft=0.0
        WinTop=0.43
    End Object
    l_EstimatedRedeployTime=EstimatedRedeployTime

    // Primary Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=PrimaryWeaponContainer_inst
        bNoCaption=false
        Caption="Primary Weapon"
        CaptionAlign=TXTA_Left
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHLoadout_Box'
        WinWidth=1.0
        WinHeight=0.175
        WinLeft=0.0
        WinTop=0.486
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    PrimaryWeaponContainer=PrimaryWeaponContainer_inst

    // Secondary Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=SecondaryWeaponContainer_inst
        bNoCaption=false
        Caption="Secondary Weapon"
        CaptionAlign=TXTA_Left
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHLoadout_Box'
        WinWidth=1.0
        WinHeight=0.1315
        WinLeft=0.0
        WinTop=0.68
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    SecondaryWeaponContainer=SecondaryWeaponContainer_inst

    // Equipment Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=EquipmentContainer_inst
        bNoCaption=false
        Caption="Equipment"
        CaptionAlign=TXTA_Left
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHLoadout_Box'
        WinWidth=1.0
        WinHeight=0.1695
        WinLeft=0.0
        WinTop=0.8305
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    EquipContainer=EquipmentContainer_inst

    // Role Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=RolesContainer_inst
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHLoadout_Box'
        WinWidth=1.0
        WinHeight=0.407
        WinLeft=0.0
        WinTop=0.0
        TopPadding=0.03
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    RolesContainer=RolesContainer_inst

    // Role list box
    Begin Object Class=DHGuiListBox Name=Roles
        OutlineStyleName="ItemOutline"              // When focused, the outline selection (text background)
        SectionStyleName="ListSection"              // Not sure
        SelectedStyleName="DHItemOutline"           // Style for items selected
        StyleName="DHSmallText"                     // Style for items not selected
        bVisibleWhenEmpty=true
        bSorted=true
        OnCreateComponent=Roles.InternalOnCreateComponent
        TabOrder=0
        OnChange=InternalOnChange
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_Roles=DHGuiListBox'DH_Interface.DHRoleSelectPanel.Roles'

    // Weapons images
    Begin Object Class=GUIImage Name=PWeaponImage
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Left
        WinWidth=0.5
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.1
    End Object
    i_WeaponImages(0)=PWeaponImage
    Begin Object Class=GUIImage Name=SWeaponImage
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Left
        WinWidth=0.5
        WinHeight=0.85
        WinLeft=0.0
        WinTop=0.1
    End Object
    i_WeaponImages(1)=SWeaponImage

    // Mag image
    Begin Object Class=GUIImage Name=MagImage
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Left
        WinWidth=0.3
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.5
    End Object
    i_MagImages(0)=MagImage

    // Weapon selection boxes
    Begin Object Class=DHGuiListBox Name=WeaponListBox
        SelectedStyleName="DHListSelectionStyle"
        OutlineStyleName="ItemOutline"
        bVisibleWhenEmpty=false
        OnCreateComponent=WeaponListBox.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinTop=0.05
        WinLeft=0.5
        WinWidth=0.5
        WinHeight=1.0
        TabOrder=0
        OnClick=InternalOnClick
    End Object
    lb_AvailableWeapons(0)=WeaponListBox
    lb_AvailableWeapons(1)=WeaponListBox

    // Primary grenade
    Begin Object Class=GUIGFXButton Name=EquipButton0
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.15
        WinHeight=0.35
        WinLeft=0.0
        WinTop=0.15
        OnClick=InternalOnClick
        OnKeyEvent=EquipButton0.InternalOnKeyEvent
    End Object
    b_Equipment(0)=EquipButton0

    // Secondary grenade/satchel
    Begin Object Class=GUIGFXButton Name=EquipButton1
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.15
        WinHeight=0.35
        WinLeft=0.25
        WinTop=0.15
        OnClick=InternalOnClick
        OnKeyEvent=EquipButton1.InternalOnKeyEvent
    End Object
    b_Equipment(1)=EquipButton1

    // Third equipment
    Begin Object Class=GUIGFXButton Name=EquipButton2
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.15
        WinHeight=0.35
        WinLeft=0.5
        WinTop=0.15
        OnClick=InternalOnClick
        OnKeyEvent=EquipButton2.InternalOnKeyEvent
    End Object
    b_Equipment(2)=EquipButton2

    // Bazooka, Piat, Shrek, Panzerfaust
    Begin Object Class=GUIGFXButton Name=EquipButton3
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.75
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.5
        OnClick=InternalOnClick
        OnKeyEvent=EquipButton3.InternalOnKeyEvent
    End Object
    b_Equipment(3)=EquipButton3

    // The primary ammo button
    Begin Object Class=DHGUINumericEdit Name=PrimaryAmmoButton
        WinWidth=0.175
        WinHeight=0.175
        WinLeft=0.155
        WinTop=0.6625
        MinValue=0
        MaxValue=12
        Step=1
        OnChange=InternalOnChange
    End Object
    nu_PrimaryAmmoMags=PrimaryAmmoButton

    // Menu button
    Begin Object Class=DHGUIButton Name=MenuButton
        Caption="Menu"
        CaptionAlign=TXTA_Center
        RenderWeight=6.0
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.15
        WinHeight=0.035
        WinLeft=0.85
        WinTop=-0.035
        OnClick=InternalOnClick
    End Object
    b_MenuButton=MenuButton
}
