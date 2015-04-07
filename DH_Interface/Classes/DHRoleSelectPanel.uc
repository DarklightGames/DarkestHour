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

var automated GUILabel                      l_EstimatedSpawnTime;

var automated GUIImage                      i_WeaponImages[2], i_MagImages[2];
var automated DHGUIListBox                  lb_Roles, lb_AvailableWeapons[2];
var automated GUIGFXButton                  b_Equipment[4];
var automated DHGUINumericEdit              nu_PrimaryAmmoMags;

var ROGUIListPlus                           li_Roles, li_AvailableWeapons[2];

var localized string                        SpawnTimeText,
                                            SecondsText;

var RORoleInfo                              CurrentRole, DesiredRole;
var int                                     CurrentTeam, DesiredTeam;
var int                                     CurrentWeapons[2], DesiredWeapons[2];
var float                                   SavedMainContainerPos, RoleSelectFooterButtonsWinTop;

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
    if (CurrentTeam == Axis_Team_Index)
    {
        Background=Texture'DH_GUI_Tex.Menu.AxisLoadout_BG';
    }

    // Fill roles list
    FillRoleList();
    if (CurrentRole == none || DHP.DesiredRole == -1)
    {
        AutoPickRole();
    }
    else
    {
        ChangeDesiredRole(CurrentRole);
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
        if (DHGRI.IsSpawnPointIndexValid(MyDeployMenu.SpawnPointIndex, DHP.GetTeamNum()))
        {
            SP = DHGRI.GetSpawnPoint(MyDeployMenu.SpawnPointIndex);
        }

        // If spawnpoint index is type vehicles, then nullify it
        if (SP != none && SP.Type == ESPT_Vehicles)
        {
            MyDeployMenu.ChangeSpawnIndices(255, 255, MyDeployMenu.SpawnVehicleIndex);
        }
        else // Just nullify vehicle pool
        {
            MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, 255, MyDeployMenu.SpawnVehicleIndex);
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
            CurrentTeam = DHP.ForcedTeamSelectOnRoleSelectPage;
            DesiredTeam = DHP.ForcedTeamSelectOnRoleSelectPage;
            // Force role reset, this stops an exploit allowing you to be on the opposite team with previous team's role
            CurrentRole = none;
            DesiredRole = none;
            DHP.CurrentRole = -1;
            DHP.DesiredRole = -1;
            DHP.ForcedTeamSelectOnRoleSelectPage = -5;
        }
        else if (PRI.bOnlySpectator)
        {
            CurrentTeam = -1;
        }
        else if (PRI.Team != none)
        {
            CurrentTeam = DHP.GetTeamNum();
        }
        else
        {
            CurrentTeam = -1;
        }

        if (CurrentTeam != AXIS_TEAM_INDEX && CurrentTeam != ALLIES_TEAM_INDEX)
        {
            CurrentTeam = -1;
        }
    }
    else
    {
        CurrentTeam = -1;
    }

    // Get player's current/desired role
    if (CurrentTeam == -1)
    {
        CurrentRole = none;
        DesiredRole = none;
    }
    else if (DHP.CurrentRole != DHP.DesiredRole)
    {
        if (CurrentTeam == AXIS_TEAM_INDEX)
        {
            CurrentRole = DHGRI.DHAxisRoles[DHP.DesiredRole];
        }
        else if (CurrentTeam == ALLIES_TEAM_INDEX)
        {
            CurrentRole = DHGRI.DHAlliesRoles[DHP.DesiredRole];
        }
        else
        {
            CurrentRole = none;
        }
    }
    else if (PRI.RoleInfo != none)
    {
        CurrentRole = PRI.RoleInfo;
    }
    else
    {
        CurrentRole = none;
    }

    // Get player's current weapons
    if (CurrentRole == none)
    {
        CurrentWeapons[0] = -1;
        CurrentWeapons[1] = -1;
    }
    else if (DHP.CurrentRole != DHP.DesiredRole)
    {
        CurrentWeapons[0] = DHP.DesiredPrimary;
        CurrentWeapons[1] = DHP.DesiredSecondary;
    }
    else
    {
        CurrentWeapons[0] = DHP.PrimaryWeapon;
        CurrentWeapons[1] = DHP.SecondaryWeapon;
    }

    // Set desired stuff to be same as current stuff
    DesiredTeam = CurrentTeam;
    DesiredRole = CurrentRole;
    DesiredWeapons[0] = -5; // these values tell the AutoPickWeapon() function
    DesiredWeapons[1] = -5; // to use the currentWeapon[] value instead
}

function FillRoleList()
{
    local int i;
    local RORoleInfo Role;

    li_Roles.Clear();

    ChangeDesiredRole(none);

    if (DesiredTeam != AXIS_TEAM_INDEX && DesiredTeam != ALLIES_TEAM_INDEX)
    {
        return;
    }

    for (i = 0; i < arraycount(DHGRI.DHAxisRoles); ++i)
    {
        if (DesiredTeam == AXIS_TEAM_INDEX)
        {
            Role = DHGRI.DHAxisRoles[i];
        }
        else
        {
            Role = DHGRI.DHAlliesRoles[i];
        }

        if (Role == none)
        {
            continue;
        }

        if (DHP != none && DHP.bUseNativeRoleNames)
        {
            li_Roles.Add(Role.default.AltName, Role);
        }
        else
        {
            li_Roles.Add(Role.default.MyName, Role);
        }
    }

    li_Roles.SortList();
}

function ChangeDesiredRole(RORoleInfo newRole)
{
    local int RoleIndex;

    // Don't change role if we already have correct role selected
    if (newRole == DesiredRole && DesiredTeam != -1)
        return;

    DesiredRole = newRole;

    if (newRole == none)
    {
        li_Roles.SetIndex(-1);
    }
    else
    {
        RoleIndex = FindRoleIndexInList(newRole);
        if (RoleIndex != -1)
        {
            li_Roles.SetIndex(RoleIndex);
            NotifyDesiredRoleUpdated();
        }
    }
}

function AutoPickRole()
{
    local int i, CurrentRoleCount;
    local RORoleInfo Role;

    if (DesiredTeam == AXIS_TEAM_INDEX || DesiredTeam == ALLIES_TEAM_INDEX)
    {
        // Pick the first non-full Role
        for (i = 0; i < arraycount(DHGRI.DHAxisRoles); ++i)
        {
            if (DesiredTeam == AXIS_TEAM_INDEX)
            {
                Role = DHGRI.DHAxisRoles[i];
                CurrentRoleCount = DHGRI.DHAxisRoleCount[i];
            }
            else
            {
                Role = DHGRI.DHAlliesRoles[i];
                CurrentRoleCount = DHGRI.DHAlliesRoleCount[i];
            }

            if (Role == none)
            {
                continue;
            }

            if (Role.GetLimit(DHGRI.MaxPlayers) == 0) //Pick role with no max
            {
                ChangeDesiredRole(Role);
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

    MyDeployMenu.bRoleIsCrew = DesiredRole.default.bCanBeTankCrew;
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

    if (DesiredRole != none)
    {
        // Update available primary weapons list
        for (i = 0; i < arraycount(DesiredRole.PrimaryWeapons); ++i)
        {
            if (DesiredRole.PrimaryWeapons[i].item != none)
            {
                li_AvailableWeapons[0].Add(DesiredRole.PrimaryWeapons[i].Item.default.ItemName,, string(i));
            }
        }
        // Update available secondary weapons list
        for (i = 0; i < arraycount(DesiredRole.SecondaryWeapons); ++i)
        {
            if (DesiredRole.SecondaryWeapons[i].item != none)
            {
                li_AvailableWeapons[1].Add(DesiredRole.SecondaryWeapons[i].Item.default.ItemName,, string(i));
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
    for (i = 0; i < arraycount(DesiredRole.Grenades); ++i)
    {
        if (DesiredRole.Grenades[i].Item != none)
        {
            WeaponAttach = class<ROWeaponAttachment>(DesiredRole.Grenades[i].Item.default.AttachmentClass);

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
    for (i = 0; i < DesiredRole.GivenItems.Length; ++i)
    {
        if (DesiredRole.GivenItems[i] != "")
        {
            w = class<Weapon>(DynamicLoadObject(DesiredRole.GivenItems[i], class'class'));

            if (w != none)
            {
                WeaponAttach = class<ROWeaponAttachment>(w.default.AttachmentClass);
            }
            else
            {
                pu = class<Powerups>(DynamicLoadObject(DesiredRole.GivenItems[i], class'class'));
                WeaponAttach = class<ROWeaponAttachment>(pu.default.AttachmentClass);
            }

            if (WeaponAttach != none)
            {
                // Force AT weapon to go in slot #4
                if (DesiredRole.GivenItems[i] ~= "DH_ATWeapons.DH_PanzerFaustWeapon" || DesiredRole.GivenItems[i] ~= "DH_ATWeapons.DH_BazookaWeapon" ||
                    DesiredRole.GivenItems[i] ~= "DH_ATWeapons.DH_PanzerschreckWeapon" || DesiredRole.GivenItems[i] ~= "DH_ATWeapons.DH_PIATWeapon")
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
            if (DesiredRole.GivenItems[i] ~= "DH_Equipment.DH_ParachuteItem")
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
    if (CurrentTeam == DesiredTeam && CurrentRole == DesiredRole &&
        DesiredWeapons[0] == -5 && DesiredWeapons[1] == -5)
    {
        for (i = 0; i < 2; ++i)
        {
            DesiredWeapons[i] = CurrentWeapons[i];

            if (li_AvailableWeapons[i].ItemCount != 0)
                li_AvailableWeapons[i].SetIndex(FindIndexInWeaponsList(DesiredWeapons[i], li_AvailableWeapons[i]));

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

            DesiredWeapons[i] = int(li_AvailableWeapons[i].GetExtraAtIndex(0));

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

function UpdateSelectedWeapon(int weaponCategory)
{
    local int i;
    local class<Inventory> Item;

    // Clear current weapon & mag display
    i_WeaponImages[weaponCategory].Image = none;
    if (weaponCategory == 0)
    {
        i_MagImages[weaponCategory].Image = none;
    }

    if (DesiredRole != none)
    {
        i = int(li_AvailableWeapons[weaponCategory].GetExtra());

        if (weaponCategory == 0)
        {
            Item = DesiredRole.PrimaryWeapons[i].Item;

            // Set min/max/mid for ammo button on primary weapon
            if (Item != none)
            {
                nu_PrimaryAmmoMags.MinValue = DH_RoleInfo(DesiredRole).MinStartAmmo * class<DH_ProjectileWeapon>(Item).default.MaxNumPrimaryMags / 100;
                if (nu_PrimaryAmmoMags.MinValue < 1)
                {
                    nu_PrimaryAmmoMags.MinValue = 1;
                }
                nu_PrimaryAmmoMags.MidValue = DH_RoleInfo(DesiredRole).DefaultStartAmmo * class<DH_ProjectileWeapon>(Item).default.MaxNumPrimaryMags / 100;
                nu_PrimaryAmmoMags.MaxValue = DH_RoleInfo(DesiredRole).MaxStartAmmo * class<DH_ProjectileWeapon>(Item).default.MaxNumPrimaryMags / 100;

                // Set value to desired, if desired is out of range, set desired to clamped value
                nu_PrimaryAmmoMags.Value = string(DHP.SpawnAmmoAmount);
                if (int(nu_PrimaryAmmoMags.Value) < nu_PrimaryAmmoMags.MinValue || int(nu_PrimaryAmmoMags.Value) > nu_PrimaryAmmoMags.MaxValue)
                {
                    nu_PrimaryAmmoMags.Value = string(nu_PrimaryAmmoMags.MidValue); // Will reset value to mid if out of range
                }
                nu_PrimaryAmmoMags.CheckValue(); // Hard clamps value to be in range (visually)
                DHP.SpawnAmmoAmount = int(nu_PrimaryAmmoMags.Value);
                nu_PrimaryAmmoMags.SetVisibility(true);
            }
            else
            {
                nu_PrimaryAmmoMags.SetVisibility(false);
            }
        }
        else
        {
            Item = DesiredRole.SecondaryWeapons[i].Item;
        }

        if (Item != none)
        {
            if (class<ROWeaponAttachment>(Item.default.AttachmentClass) != none)
            {
                i_WeaponImages[weaponCategory].Image = class<ROWeaponAttachment>(Item.default.AttachmentClass).default.menuImage;
            }

            if (class<Weapon>(Item) != none &&
                class<Weapon>(Item).default.FireModeClass[0] != none &&
                class<Weapon>(Item).default.FireModeClass[0].default.AmmoClass != none &&
                weaponCategory == 0)
            {
                i_MagImages[weaponCategory].Image = class<Weapon>(Item).default.FireModeClass[0].default.AmmoClass.default.IconMaterial;
            }

            DesiredWeapons[weaponCategory] = i;

            // Update deploy time
            l_EstimatedSpawnTime.Caption = SpawnTimeText @ DHP.GetSpawnTime(-1, DesiredRole, DesiredWeapons[0]) @ SecondsText;
        }
    }
}

// Used to update team counts & role counts
function Timer()
{
    UpdateRoleCounts();
}

function int getTeamCount(int index)
{
    return class'ROGUITeamSelection'.static.getTeamCountStatic(DHGRI, PlayerOwner(), index);
}

function UpdateRoleCounts()
{
    local int i, RoleLimit, RoleCurrentCount, RoleBotCount;
    local RORoleInfo Role;
    local bool bHasBots, bIsFull, bIsCurrent;

    if (DesiredTeam != AXIS_TEAM_INDEX && DesiredTeam != ALLIES_TEAM_INDEX)
        return;

    for (i = 0; i < li_Roles.ItemCount; ++i)
    {
        Role = RORoleInfo(li_Roles.GetObjectAtIndex(i));
        if (Role == none)
            continue;

        bIsFull = CheckIfRoleIsFull(Role, DesiredTeam, RoleLimit, RoleCurrentCount, RoleBotCount);
        bHasBots = (RoleBotCount > 0);

        if (Role == CurrentRole)
        {
            bIsCurrent = true;
        }
        else
        {
            bIsCurrent = false;
        }

        if (DHP != none && DHP.bUseNativeRoleNames)
        {
            li_Roles.SetItemAtIndex(i, FormatRoleString(Role.AltName, RoleLimit, RoleCurrentCount, bHasBots, bIsCurrent));
        }
        else
        {
            li_Roles.SetItemAtIndex(i, FormatRoleString(Role.MyName, RoleLimit, RoleCurrentCount, bHasBots, bIsCurrent));
        }
        li_Roles.SetDisabledAtIndex(i, bIsFull);
    }
}

function bool CheckIfRoleIsFull(RORoleInfo Role, int Team, optional out int RoleLimit, optional out int RoleCount, optional out int RoleBotCount)
{
    local int index;

    index = FindRoleIndexInGRI(Role, Team);

    if (Team == AXIS_TEAM_INDEX)
    {
        RoleCount = DHGRI.DHAxisRoleCount[index];
        RoleBotCount = DHGRI.DHAxisRoleBotCount[index];
    }
    else if (Team == ALLIES_TEAM_INDEX)
    {
        RoleCount = DHGRI.DHAlliesRoleCount[index];
        RoleBotCount = DHGRI.DHAlliesRoleBotCount[index];
    }
    else
    {
        warn("Invalid Team used when calling CheckIfRoleIsFull():" @ Team);

        return false;
    }

    RoleLimit = Role.GetLimit(DHGRI.MaxPlayers);

    return (RoleCount == RoleLimit) && (RoleLimit != 0) && !(RoleBotCount > 0) && (CurrentRole != Role);
}

function int FindRoleIndexInGRI(RORoleInfo Role, int Team)
{
    local int i;

    if (Team == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.DHAxisRoles); ++i)
        {
            if (DHGRI.DHAxisRoles[i] == Role)
            {
                return i;
            }
        }
    }
    else if (Team == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.DHAlliesRoles); ++i)
        {
            if (DHGRI.DHAlliesRoles[i] == Role)
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

function string FormatRoleString(string RoleName, int RoleLimit, int RoleCount, bool bHasBots, optional bool bIsCurrentRole)
{
    local string s;

    if (RoleLimit == 0)
    {
        s = RoleName $ " [" $ RoleCount $ "]";
    }
    else
    {
        if (RoleCount == RoleLimit && !bHasBots)
            s = RoleName $ " [" $ MyDeployMenu.RoleFullText $ "]";
        else
            s = RoleName $ " [" $ RoleCount $ "/" $ RoleLimit $ "]";
    }

    if (bIsCurrentRole)
    {
        s = s @ MyDeployMenu.CurrentRoleText;
    }

    if (bHasBots)
    {
        s = s $ MyDeployMenu.RoleHasBotsText;
    }

    return s;
}

function bool IsApplicationChanged()
{
    // Check values for changes
    if (CurrentRole != DesiredRole ||
        CurrentTeam != DesiredTeam ||
        CurrentWeapons[0] != DesiredWeapons[0] ||
        CurrentWeapons[1] != DesiredWeapons[1] ||
        nu_PrimaryAmmoMags.Value != string(DHP.SpawnAmmoAmount) ||
        MyDeployMenu.SpawnPointIndex != DHP.SpawnPointIndex ||
        MyDeployMenu.VehiclePoolIndex != DHP.VehiclePoolIndex ||
        MyDeployMenu.SpawnVehicleIndex != DHP.SpawnVehicleIndex)
    {
        return true;
    }

    return false;
}

// TODO: clean up function && optimize if possible
function AttemptDeployApplication()
{
    local byte TeamIndex, RoleIndex, w1, w2;

    if (DHP == none)
    {
        return;
    }

    // Get desired team info
    if (DesiredTeam == CurrentTeam)
    {
        TeamIndex = 255;    // No change
    }
    else
    {
        if (DesiredTeam == -1)
            TeamIndex = 254; // spectator
        else
            TeamIndex = DesiredTeam;
    }

    // Get Role switch info
    if (TeamIndex == 254 || (TeamIndex == 255 && DesiredTeam == -1))
        RoleIndex = 255; // no role switch if we're spectating
    else if (DesiredRole == none)
    {
        warn("No role selected, using role #0");
        RoleIndex = 0; // force role of 0 if we havn't picked a role (should never happen)
    }
    else if (DesiredRole == CurrentRole && DesiredTeam == CurrentTeam)
    {
        RoleIndex = 255; // No change
    }
    else
    {
        if (CheckIfRoleIsFull(DesiredRole, DesiredTeam) && Controller != none)
        {
            Controller.OpenMenu(Controller.QuestionMenuClass);
            GUIQuestionPage(Controller.TopPage()).SetupQuestion(MyDeployMenu.RoleIsFullMessageText, QBTN_Ok, QBTN_Ok);
            return;
        }
        RoleIndex = FindRoleIndexInGRI(RORoleInfo(li_Roles.GetObject()), DesiredTeam);
    }

    // Get weapons info
    w1 = DesiredWeapons[0];
    w2 = DesiredWeapons[1];

    // Attempt team, role, weapons change, and spawn indices change
    DHP.ServerSetPlayerInfo(TeamIndex, RoleIndex, w1, w2, MyDeployMenu.SpawnPointIndex, MyDeployMenu.VehiclePoolIndex, MyDeployMenu.SpawnVehicleIndex, byte(nu_PrimaryAmmoMags.Value));
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
    local RORoleInfo Role;

    if (!bRendered)
    {
        return;
    }

    switch (Sender)
    {
        case lb_Roles:
            Role = RORoleInfo(li_Roles.GetObject());

            if (Role != none)
            {
                // Because we changed role, lets reset our desired ammo
                DHP.SpawnAmmoAmount = 0;

                ChangeDesiredRole(Role);
            }
            else
            {
                // We clicked another role, but we tried changing too fast, lets force index back
                if (Role != none && DesiredRole != none && DesiredRole != Role)
                {
                    li_Roles.SetIndex(li_Roles.FindItemObject(DesiredRole));
                }
            }
            break;

        case nu_PrimaryAmmoMags:
            DHP.SpawnAmmoAmount = byte(nu_PrimaryAmmoMags.Value);
            l_EstimatedSpawnTime.Caption = SpawnTimeText @ DHP.GetSpawnTime(-1, DesiredRole,DesiredWeapons[0]) @ SecondsText;
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

defaultproperties
{
    Background=Texture'DH_GUI_Tex.Menu.AlliesLoadout_BG'
    OnPostDraw=OnPostDraw
    OnKeyEvent=InternalOnKeyEvent
    bNeverFocus=true
    SpawnTimeText="Estimated redeploy time:"
    SecondsText="seconds"

    RoleSelectFooterButtonsWinTop=0.946667

    // Estimated deploy time label
    Begin Object Class=GUILabel Name=EstimatedSpawnTime
        Caption="Estimated Redeploy Time:"
        TextAlign=TXTA_Center
        StyleName="DHLargeText"
        WinWidth=1.0
        WinHeight=0.03
        WinLeft=0.0
        WinTop=0.43
    End Object
    l_EstimatedSpawnTime=EstimatedSpawnTime

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
