//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHRoleSelectPanel extends MidGamePanel
    config;

const NUM_ROLES = 10;

var automated ROGUIProportionalContainer    MainContainer,
                                            RolesContainer,
                                            AmmoSliderContainer,
                                            PrimaryWeaponContainer,
                                            SecondaryWeaponContainer,
                                            EquipContainer;

var automated GUILabel                      l_RolesTitle,
                                            l_PrimaryWeaponTitle,
                                            l_SecondaryWeaponTitle,
                                            l_EquipTitle,
                                            l_EstimatedRedeployTime,
                                            l_StatusLabel;

var automated BackgroundImage               bg_Background;
var automated GUIImage                      i_WeaponImages[2], i_MagImages[2];
var automated GUIListBox                    lb_Roles, lb_AvailableWeapons[2];
var automated GUIGFXButton                  b_Equipment[4];
var automated DHGUINumericEdit              nu_PrimaryAmmoMags;

var ROGUIListPlus                           li_Roles, li_AvailableWeapons[2];

var localized string                        NoSelectedRoleText,
                                            RoleHasBotsText,
                                            RoleFullText,
                                            SelectEquipmentText,
                                            RoleIsFullMessageText,
                                            ChangingRoleMessageText,
                                            UnknownErrorMessageText,
                                            ErrorChangingTeamsMessageText;

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

var ROGameReplicationInfo                   GRI;
var RORoleInfo                              currentRole, desiredRole;
var int                                     currentTeam, desiredTeam;
var string                                  currentName, desiredName;
var int                                     currentWeapons[2], desiredWeapons[2];
var float                                   SavedMainContainerPos, RoleSelectFooterButtonsWinTop, RoleSelectReclickTime;
var bool                                    bRendered;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    GRI = ROGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    // Roles container
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
    //EquipContainer.ManageComponent(b_Equipment[0]);
    //EquipContainer.ManageComponent(b_Equipment[1]);
    //EquipContainer.ManageComponent(b_Equipment[2]);
    //EquipContainer.ManageComponent(b_Equipment[3]);

    // Get player's initial values (name, team, role, weapons)
    GetInitialValues();

    // Fill roles list
    FillRoleList();
    if (currentRole == none)
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
}

// This function informs InternalOnChange not to run until we are done rendering
function bool OnPostDraw(Canvas C)
{
    super.OnPostDraw(C);

    bRendered = true;

    return true;
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

            if (role.GetLimit(GRI.MaxPlayers) == 0) //Pick role with no max
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

    // Inform player that they are changing roles
    if (currentRole == desiredRole)
    {
        SetStatusString("You are currently a" @ currentRole.MyName);
    }
    else if (currentRole != desiredRole)
    {
        SetStatusString("You will attempt to change role to" @ desiredRole.MyName);
    }
}

function ToggleTeam()
{
    if (currentTeam == AXIS_TEAM_INDEX)
    {
        ChangeDesiredTeam(1);
    }
    else if (currentTeam == ALLIES_TEAM_INDEX)
    {
        ChangeDesiredTeam(0);
    }
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
    i_MagImages[1].Image = none;

    if (desiredRole != none)
    {
        // Update available primary weapons list
        for (i = 0; i < arraycount(desiredRole.PrimaryWeapons); i++)
        {
            if (desiredRole.PrimaryWeapons[i].item != none)
            {
                li_AvailableWeapons[0].Add(desiredRole.PrimaryWeapons[i].Item.default.ItemName,, string(i));
            }
        }
        // Update available secondary weapons list
        for (i = 0; i < arraycount(desiredRole.SecondaryWeapons); i++)
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

    Log("AutoPickWeapons() called");

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

//Theel fix this function, strange if/else embedding
function UpdateSelectedWeapon(int weaponCategory)
{
    local int i;
    local class<Inventory> item;
    local DHPlayer player;

    player = DHPlayer(PlayerOwner());

    // Clear current weapon & mag display
    i_WeaponImages[weaponCategory].Image = none;
    i_MagImages[weaponCategory].Image = none;

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
                nu_PrimaryAmmoMags.MidValue = DH_RoleInfo(desiredRole).DefaultStartAmmo * class<DH_ProjectileWeapon>(item).default.MaxNumPrimaryMags / 100;
                nu_PrimaryAmmoMags.MaxValue = DH_RoleInfo(desiredRole).MaxStartAmmo * class<DH_ProjectileWeapon>(item).default.MaxNumPrimaryMags / 100;

                // Set value to desired, if desired is out of range, set desired to clamped value
                Log("Desired Ammo Amount before:" @ player.DesiredAmmoAmount);
                nu_PrimaryAmmoMags.Value = string(player.DesiredAmmoAmount);
                if (int(nu_PrimaryAmmoMags.Value) < 1 || int(nu_PrimaryAmmoMags.Value) > nu_PrimaryAmmoMags.MaxValue)
                {
                    nu_PrimaryAmmoMags.Value = string(nu_PrimaryAmmoMags.MidValue);
                }
                nu_PrimaryAmmoMags.CheckValue(); //clamps value to be in range
                player.DesiredAmmoAmount = int(nu_PrimaryAmmoMags.Value);
                Log("Desired Ammo Amount after:" @ player.DesiredAmmoAmount);
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
            l_EstimatedRedeployTime.Caption = "Estimated redeploy time:" @ DHPlayer(PlayerOwner()).CalculateDeployTime(-1,desiredRole,desiredWeapons[0]) @ "Seconds";
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

    //Temp hack to make sure we have a role list
    if (li_Roles.Elements.Length <= 0)
    {
        //we aren't showing any roles!
        Log("Role list has" @ li_Roles.Elements.Length @ "elements");
        Log("       ");
        Log("       ");
        Warn("We are retrying to fill role list as we detected we didn't have one!!!!");
        Log("       ");
        Log("       ");

        //Refill the list then
        FillRoleList();
        AutoPickRole();
    }
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

        if (ROPlayer(PlayerOwner()) != none &&  ROPlayer(PlayerOwner()).bUseNativeRoleNames)
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
    {
        s = s $ RoleHasBotsText;
    }

    return s;
}

//This function needs work
function AttemptRoleApplication(optional bool bDontShowErrors)
{
    local DHPlayer player;
    local byte teamIndex, roleIndex, w1, w2;

    player = DHPlayer(PlayerOwner());

    //Theel's fast check to see if we even need to attempt role change
    if (currentRole != desiredRole ||
        currentTeam != desiredTeam ||
        currentName != desiredName ||
        currentWeapons[0] != desiredWeapons[0] ||
        currentWeapons[1] != desiredWeapons[1] ||
        nu_PrimaryAmmoMags.Value != string(DHPlayer(PlayerOwner()).DesiredAmmoAmount))
    {
        //Do nothing for now
    }
    else
    {
        return;
    }

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

    Log("AttemptRoleApplication() Calling ServerChangePlayerInfo!!!                                     Attempt Semi-Success");

    // Attempt team, role and weapons change
    player.ServerChangePlayerInfo(teamIndex, roleIndex, w1, w2);

    // We possibly changed, so lets update the values  THis might be causing bugs on semi-failure
    currentRole = desiredRole;
    currentTeam = desiredTeam;
    currentName = desiredName;
    currentWeapons[0] = desiredWeapons[0];
    currentWeapons[1] = desiredWeapons[1];
    //GetInitialValues(); //gulp lets see if this works and doesn't bug the fuck out
}

//Does this really need to be a function?
function SetStatusString(optional string S)
{
    local string StatusStr;

    if (S != "")
    {
        StatusStr = S;
    }
    else
    {
        StatusStr = "";
    }
    l_StatusLabel.Caption = StatusStr;
}

static function CheckNeedForFadeFromBlackEffect(PlayerController controller)
{

}

function bool InternalOnClick(GUIComponent Sender)
{
    switch (sender)
    {
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
                RoleSelectReclickTime = 0.0;
                ChangeDesiredRole(role);
                AttemptRoleApplication();
            }
            break;

        case nu_PrimaryAmmoMags:
            DHPlayer(PlayerOwner()).DesiredAmmoAmount = byte(nu_PrimaryAmmoMags.Value);
            Log("Desired Ammo Amount after:" @ DHPlayer(PlayerOwner()).DesiredAmmoAmount);
            l_EstimatedRedeployTime.Caption = "Estimated redeploy time:" @ DHPlayer(PlayerOwner()).CalculateDeployTime(-1,desiredRole,desiredWeapons[0]) @ "Seconds";
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
                if (ROPlayer(PlayerOwner()) != none)
                {
                    ROPlayer(PlayerOwner()).PlayerReplicationInfo.bReadyToPlay = true;
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
    Background=Texture'InterfaceArt_tex.Menu.GreyDark'
    OnPostDraw=OnPostDraw
    OnKeyEvent=InternalOnKeyEvent
    OnMessage=InternalOnMessage
    bNeverFocus=true
    RoleSelectReclickTime=1.0
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

    RoleSelectFooterButtonsWinTop=0.946667

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

    Begin Object Class=GUILabel Name=EstimatedRedeployTime
        Caption="Estimated Redeploy Time:"
        TextAlign=TXTA_Right
        StyleName="DHSmallText"
        WinWidth=0.651253
        WinHeight=0.0305
        WinLeft=0.162253
        WinTop=0.415428
    End Object
    l_EstimatedRedeployTime=EstimatedRedeployTime

    //Recent changes status label
    Begin Object Class=GUILabel Name=RecentChangesStatus
        Caption=""
        TextAlign=TXTA_Left
        StyleName="DHLargeText"
        WinWidth=0.982575
        WinHeight=0.033589
        WinLeft=0.010993
        WinTop=0.359297
    End Object
    l_StatusLabel=RecentChangesStatus

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
        WinHeight=0.18246
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
        WinWidth=1.0
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
        WinWidth=0.39207
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
        WinHeight=0.300269
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

    Begin Object Class=GUIImage Name=MagImage
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        WinWidth=0.146491
        WinHeight=0.063004
        WinLeft=0.352801
        WinTop=0.570795
    End Object
    i_MagImages(0)=MagImage
    i_MagImages(1)=MagImage

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
        OnClick=DHRoleSelectPanel.InternalOnClick
    End Object
    lb_AvailableWeapons(0)=DHGuiListBox'DH_Interface.DHRoleSelectPanel.WeaponListBox'
    lb_AvailableWeapons(1)=DHGuiListBox'DH_Interface.DHRoleSelectPanel.WeaponListBox'

    // Equipment controls
    Begin Object Class=GUIGFXButton Name=EquipButton0
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.171937
        WinHeight=0.072377
        WinLeft=0.018709
        WinTop=0.837604
        TabOrder=21
        bTabStop=true
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=EquipButton0.InternalOnKeyEvent
    End Object
    b_Equipment(0)=GUIGFXButton'DH_Interface.DHRoleSelectPanel.EquipButton0'

    Begin Object Class=GUIGFXButton Name=EquipButton1
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.175055
        WinHeight=0.069259
        WinLeft=0.193764
        WinTop=0.839028
        TabOrder=22
        bTabStop=true
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=EquipButton1.InternalOnKeyEvent
    End Object
    b_Equipment(1)=GUIGFXButton'DH_Interface.DHRoleSelectPanel.EquipButton1'

    Begin Object Class=GUIGFXButton Name=EquipButton2
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.277953
        WinHeight=0.125385
        WinLeft=0.365701
        WinTop=0.834756
        TabOrder=23
        bTabStop=true
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=EquipButton2.InternalOnKeyEvent
    End Object
    b_Equipment(2)=GUIGFXButton'DH_Interface.DHRoleSelectPanel.EquipButton2'

    Begin Object Class=GUIGFXButton Name=EquipButton3
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.680630
        WinHeight=0.069478
        WinLeft=0.018709
        WinTop=0.908829
        TabOrder=24
        bTabStop=true
        OnClick=DHRoleSelectPanel.InternalOnClick
        OnKeyEvent=EquipButton3.InternalOnKeyEvent
    End Object
    b_Equipment(3)=GUIGFXButton'DH_Interface.DHRoleSelectPanel.EquipButton3'

    //The primary ammo button
    Begin Object Class=DHGUINumericEdit Name=PrimaryAmmoButton
        WinWidth=0.20457
        WinHeight=0.037307
        WinLeft=0.469822
        WinTop=0.585544
        MinValue=0
        MaxValue=12
        Step=1
        OnChange=InternalOnChange
    End Object
    nu_PrimaryAmmoMags=PrimaryAmmoButton
}
