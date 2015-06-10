//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHDeployMenu extends UT2K4GUIPage;

enum ELoadoutMode
{
    LM_Equipment,
    LM_Vehicle
};

var automated   FloatingImage               i_Background;
var automated   ROGUIProportionalContainer  c_Teams;
var automated   GUIButton                       b_Axis;
var automated   GUIImage                        i_Axis;
var automated   GUIButton                       b_Allies;
var automated   GUIImage                        i_Allies;
var automated   GUIButton                       b_Spectate;
var automated   GUIImage                        i_Spectate;
var automated   GUIImage                    i_Reinforcements;
var automated   GUILabel                    l_Reinforcements;
var automated   GUIImage                    i_RoundTime;
var automated   GUILabel                    l_RoundTime;
var automated   ROGUIProportionalContainer  c_Roles;
var automated   DHGUIListBox                    lb_Roles;
var             DHGUIList                       li_Roles;
var automated   ROGUIProportionalContainer  LoadoutTabContainer;
var automated   GUIButton                       b_EquipmentButton;
var automated   GUIImage                        i_EquipmentButton;
var automated   GUIButton                       b_VehicleButton;
var automated   GUIImage                        i_VehiclesButton;
var automated   GUILabel                    l_Loadout;
var automated   ROGUIProportionalContainer  c_Loadout;
var automated   ROGUIProportionalContainer      c_Equipment;
var automated   ROGUIProportionalContainer      c_Vehicle;
var automated   ROGUIProportionalContainer  c_Map;
var automated   DHGUIMapComponent               p_Map;
var automated   ROGUIProportionalContainer  c_Footer;
var automated   GUILabel                    l_Status;
var automated   GUIImage                        i_PrimaryWeapon;
var automated   GUIImage                        i_SecondaryWeapon;
var automated   GUIImage                        i_Vehicle;
var automated   DHmoComboBox                cb_PrimaryWeapon;
var automated   DHmoComboBox                cb_SecondaryWeapon;
var automated   GUIImage                    i_GivenItems[6];
var automated   DHGUIListBox                lb_Vehicles;
var             DHGUIList                   li_Vehicles;
var automated   DHGUIListBox                lb_PrimaryWeapons;
var             DHGUIList                   li_PrimaryWeapons;
var automated   GUIImage                    i_Arrows;

var automated   array<GUIButton>            b_MenuOptions;

var DHGameReplicationInfo                   GRI;
var DHPlayer                                PC;

var localized string                        NoneText;
var localized   string                      SelectRoleText;
var localized   string                      SelectSpawnPointText;
var localized   string                      SelectVehicleText;

// Colin: The reason this variable is needed is because the PlayerController's
// GetTeamNum function is not reliable after receiving a successful team change
// signal from InternalOnMessage.
var             byte                        CurrentTeam;

var             ELoadoutMode                LoadoutMode;

var             byte                        SpawnPointIndex;
var             byte                        SpawnVehicleIndex;

var             bool                        bButtonsEnabled;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super.InitComponent(MyController, MyOwner);

    PC = DHPlayer(PlayerOwner());

    li_Roles = DHGUIList(lb_Roles.List);
    li_Vehicles = DHGUIList(lb_Vehicles.List);

    // Footer buttons
    for (i = 0; i < b_MenuOptions.Length; ++i)
    {
        b_MenuOptions[i].WinLeft = i * (1.0 / b_MenuOptions.Length);
        b_MenuOptions[i].WinWidth = 1.0 / b_MenuOptions.Length;

        c_Footer.ManageComponent(b_MenuOptions[i]);
    }

    // Team buttons
    c_Teams.ManageComponent(b_Allies);
    c_Teams.ManageComponent(i_Allies);
    c_Teams.ManageComponent(b_Axis);
    c_Teams.ManageComponent(i_Axis);
    c_Teams.ManageComponent(b_Spectate);
    c_Teams.ManageComponent(i_Spectate);

    c_Loadout.ManageComponent(c_Equipment);
    c_Loadout.ManageComponent(c_Vehicle);

    LoadoutTabContainer.ManageComponent(b_EquipmentButton);
    LoadoutTabContainer.ManageComponent(b_VehicleButton);
    LoadoutTabContainer.ManageComponent(i_EquipmentButton);
    LoadoutTabContainer.ManageComponent(i_VehiclesButton);

    c_Map.ManageComponent(p_Map);

    c_Equipment.ManageComponent(i_PrimaryWeapon);
    c_Equipment.ManageComponent(i_SecondaryWeapon);

    for (i = 0; i < arraycount(i_GivenItems); ++i)
    {
        if (i_GivenItems[i] != none)
        {
            c_Equipment.ManageComponent(i_GivenItems[i]);
        }
    }

    c_Equipment.ManageComponent(cb_PrimaryWeapon);
    c_Equipment.ManageComponent(cb_SecondaryWeapon);

    c_Vehicle.ManageComponent(i_Vehicle);
    c_Vehicle.ManageComponent(lb_Vehicles);

    c_Roles.ManageComponent(lb_Roles);
}

function SetLoadoutMode(ELoadoutMode Mode)
{
    local int i;

    LoadoutMode = Mode;

    // Colin: GUIComponent visiblity is not properly hierarchical, so we
    // need to hide and show elements indidivually.
    i_Vehicle.SetVisibility(Mode == LM_Vehicle);
    lb_Vehicles.SetVisibility(Mode == LM_Vehicle);

    i_PrimaryWeapon.SetVisibility(Mode == LM_Equipment);
    i_SecondaryWeapon.SetVisibility(Mode == LM_Equipment);

    cb_PrimaryWeapon.SetVisibility(Mode == LM_Equipment && cb_PrimaryWeapon.ItemCount() > 0);
    cb_SecondaryWeapon.SetVisibility(Mode == LM_Equipment && cb_SecondaryWeapon.ItemCount() > 0);

    for (i = 0; i < arraycount(i_GivenItems); ++i)
    {
        if (i_GivenItems[i] != none)
        {
            i_GivenItems[i].SetVisibility(Mode == LM_Equipment);
        }
    }

    switch (Mode)
    {
        case LM_Equipment:
            b_EquipmentButton.DisableMe();
            b_VehicleButton.EnableMe();
            break;
        case LM_Vehicle:
            b_EquipmentButton.EnableMe();
            b_VehicleButton.DisableMe();
            break;
    }

    UpdateSpawnPoints();
}

function Timer()
{
    // Colin: The GRI might not be set when we first open the menu if the player
    // opens it very quickly. This state will sit and wait until the GRI is confirmed
    // to be present.
    // TODO: bonus marks, have it show a 'loading' screen
    local byte Team;

    if (GRI == none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

        if (GRI != none)
        {
            // Colin: This bullshit is used by RO code to circumvent the
            // fact we can't send initialization parameters to the menu.
            if (PC.ForcedTeamSelectOnRoleSelectPage != -5)
            {
                Team = PC.ForcedTeamSelectOnRoleSelectPage;
                PC.ForcedTeamSelectOnRoleSelectPage = -5;
            }
            else
            {
                Team = PC.GetTeamNum();
            }

            OnTeamChanged(Team);

            p_Map.SelectSpawnPoint(PC.SpawnPointIndex, PC.SpawnVehicleIndex);
        }
    }

    if (GRI != none)
    {
        UpdateRoles();
        UpdateVehicles();
        UpdateRoundStatus();
        UpdateStatus();
        UpdateButtons();
        UpdateSpawnPoints();
    }
}

function UpdateRoundStatus()
{
    local int RoundTime;

    //TODO: update team numbers on tabs

    if (GRI != none)
    {
        l_Reinforcements.Caption = string(GRI.DHSpawnCount[CurrentTeam]);

        if (!GRI.bMatchHasBegun)
        {
            RoundTime = GRI.RoundStartTime + GRI.PreStartTime - GRI.ElapsedTime;
        }
        else
        {
            RoundTime = GRI.RoundStartTime + GRI.RoundDuration - GRI.ElapsedTime;
        }
    }

    l_RoundTime.Caption = class'DHLib'.static.GetDurationString(Max(0, RoundTime), "m:ss");
}

function GetMapCoords(vector Location, out float X, out float Y, optional float Width, optional float Height)
{
    local float MapScale;
    local vector MapCenter;

    MapScale = FMax(1.0, Abs((GRI.SouthWestBounds - GRI.NorthEastBounds).X));
    MapCenter = GRI.NorthEastBounds + ((GRI.SouthWestBounds - GRI.NorthEastBounds) * 0.5);
    Location = DHHud(PlayerOwner().MyHud).GetAdjustedHudLocation(Location - MapCenter, false);

    X = FClamp(0.5 + (Location.X / MapScale) - (Width / 2),
               0.0 + (Width / 2),
               1.0 - (Width / 2));

    Y = FClamp(0.5 + (Location.Y / MapScale) - (Height / 2),
               0.0 + (Height / 2),
               1.0 - (Height / 2));
}

function UpdateSpawnPoints()
{
    local int i, j;
    local float X, Y;
    local TexRotator TR;
    local DHRoleInfo RI;

    RI = DHRoleInfo(li_Roles.GetObject());

    // Spawn points
    for (i = 0; i < arraycount(p_Map.b_SpawnPoints); ++i)
    {
        if (GRI != none &&
            GRI.AreSpawnSettingsValid(CurrentTeam, RI, i, GRI.GetVehiclePoolIndex(class<Vehicle>(li_Vehicles.GetObject())), SpawnVehicleIndex))
        {
            GetMapCoords(GRI.SpawnPoints[i].Location, X, Y, p_Map.b_SpawnPoints[i].WinWidth, p_Map.b_SpawnPoints[i].WinHeight);

            p_Map.b_SpawnPoints[i].Tag = i;
            p_Map.b_SpawnPoints[i].SetVisibility(true);
            p_Map.b_SpawnPoints[i].SetPosition(X, Y, p_Map.b_SpawnPoints[i].WinWidth, p_Map.b_SpawnPoints[i].WinHeight, true);
        }
        else
        {
            // If spawn point that was previously selected is now hidden,
            // deselect it.
            if (SpawnPointIndex == p_Map.b_SpawnPoints[i].Tag)
            {
                p_Map.SelectSpawnPoint(255, 255);
            }

            p_Map.b_SpawnPoints[i].SetVisibility(false);
        }
    }

    // Spawn vehicles
    for (i = 0; i < arraycount(p_Map.b_SpawnVehicles); ++i)
    {
        if (li_Vehicles.GetObject() == none &&
            GRI != none &&
            GRI.SpawnVehicles[i].VehicleClass != none &&
            GRI.SpawnVehicles[i].TeamIndex == CurrentTeam)
        {
            GetMapCoords(GRI.SpawnVehicles[i].Location, X, Y, p_Map.b_SpawnVehicles[i].WinWidth, p_Map.b_SpawnVehicles[i].WinHeight);

            p_Map.b_SpawnVehicles[i].Tag = i;
            p_Map.b_SpawnVehicles[i].SetPosition(X, Y, p_Map.b_SpawnVehicles[i].WinWidth, p_Map.b_SpawnVehicles[i].WinHeight, true);
            p_Map.b_SpawnVehicles[i].SetVisibility(true);

            for (j = 0; j < arraycount(p_Map.b_SpawnVehicles[i].Style.Images); ++j)
            {
                TR = TexRotator(p_Map.b_SpawnVehicles[i].Style.Images[j]);

                if (TR != none)
                {
                    //TODO: verify correctness and take map rotation into consideration
                    TR.Rotation.Roll = GRI.SpawnVehicles[i].Location.Z;
                }
            }
        }
        else
        {
            // If spawn point that was previously selected is now hidden,
            // deselect it.
            if (SpawnVehicleIndex == p_Map.b_SpawnVehicles[i].Tag)
            {
                p_Map.SelectSpawnPoint(255, 255);
            }

            p_Map.b_SpawnVehicles[i].SetVisibility(false);
        }
    }
}

function UpdateStatus()
{
    if (GRI == none)
    {
        return;
    }

    switch (GRI.AlliedNationID)
    {
        case 0: // USA
            i_Allies.Image = material'DH_GUI_tex.DeployMenu.flag_usa';
            break;
        case 1: // UK
            i_Allies.Image = material'DH_GUI_tex.DeployMenu.flag_uk';
            break;
        case 2: // Canada
            i_Allies.Image = material'DH_GUI_tex.DeployMenu.flag_canada';
            break;
    }

    b_Axis.Caption = string(class'ROGUITeamSelection'.static.getTeamCountStatic(GRI, PlayerOwner(), AXIS_TEAM_INDEX));
    b_Allies.Caption = string(class'ROGUITeamSelection'.static.getTeamCountStatic(GRI, PlayerOwner(), ALLIES_TEAM_INDEX));
    l_Status.Caption = GetStatusText();
}

function string GetStatusText()
{
    local DHRoleInfo RI;

    RI = DHRoleInfo(li_Roles.GetObject());

    if (RI == none)
    {
        return default.SelectRoleText;
    }

    if (SpawnPointIndex == 255 && SpawnVehicleIndex == 255)
    {
        return default.SelectSpawnPointText;
    }

    return class'DHLib'.static.GetDurationString(Max(0, PC.GetSpawnTime(RI, cb_PrimaryWeapon.GetIndex(), 0, GRI.GetVehiclePoolIndex(class<Vehicle>(li_Vehicles.GetObject())))), "m:ss");
}

function PopulateVehicles()
{
    local int i;

    li_Vehicles.Clear();

    for (i = 0; i < arraycount(GRI.VehiclePoolVehicleClasses); ++i)
    {
        if (GRI.VehiclePoolVehicleClasses[i] != none &&
            GRI.VehiclePoolVehicleClasses[i].default.VehicleTeam == CurrentTeam)
        {
            li_Vehicles.Add(GRI.VehiclePoolVehicleClasses[i].default.VehicleNameString, GRI.VehiclePoolVehicleClasses[i]);
        }
    }

    li_Vehicles.SortList();

    li_Vehicles.Insert(0, default.NoneText, none,, true);

    UpdateVehicles();
    AutoSelectVehicle();
}

function UpdateVehicles()
{
    local int i, j;
    local class<ROVehicle> VehicleClass;
    local RORoleInfo RI;
    local bool bDisabled;
    local string S;
    local float RespawnTime;

    if (GRI == none)
    {
        return;
    }

    RI = RORoleInfo(li_Roles.GetObject());

    for (i = 0; i < li_Vehicles.ItemCount; ++i)
    {
        VehicleClass = class<ROVehicle>(li_Vehicles.GetObjectAtIndex(i));
        j = GRI.GetVehiclePoolIndex(VehicleClass);

        if (j == -1)
        {
            continue;
        }

        //TODO: have team max be indicated in another part of this control (ie. don't obfuscate meaning)
        bDisabled = VehicleClass != none &&
                    ((VehicleClass.default.bMustBeTankCommander && RI != none && !RI.default.bCanBeTankCrew) ||
                    GRI.MaxTeamVehicles[CurrentTeam] <= 0 ||
                    GRI.GetVehiclePoolSpawnsRemaining(j) <= 0 ||
                    !GRI.IsVehiclePoolActive(j) ||
                    GRI.VehiclePoolActiveCounts[j] >= GRI.VehiclePoolMaxActives[j]);

        if (VehicleClass != none)
        {
            S = VehicleClass.default.VehicleNameString;

            if (GRI.GetVehiclePoolSpawnsRemaining(j) != 255)
            {
                S @= "[" $ GRI.GetVehiclePoolSpawnsRemaining(j) $ "]";
            }

            RespawnTime = Max(0.0, GRI.VehiclePoolNextAvailableTimes[j] - GRI.ElapsedTime);

            if (RespawnTime > 0)
            {
                S @= "(" $ class'DHLib'.static.GetDurationString(RespawnTime, "m:ss") $ ")";
            }

            if (GRI.VehiclePoolActiveCounts[j] >= GRI.VehiclePoolMaxActives[j])
            {
                S @= "*MAX*";
            }

            li_Vehicles.SetItemAtIndex(i, S);
        }

        li_Vehicles.SetDisabledAtIndex(i, bDisabled);

        // Colin: If selected vehicle pool becomes disabled, select the "None"
        // option.
        if (bDisabled && li_Vehicles.Index == i)
        {
            li_Vehicles.SetIndex(0);
        }
    }
}

function UpdateRoles()
{
    local int i;
    local RORoleInfo RI;
    local int Count;
    local int BotCount;
    local int Limit;
    local string S;

    for (i = 0; i < li_Roles.ItemCount; ++i)
    {
        RI = RORoleInfo(li_Roles.GetObjectAtIndex(i));

        if (RI == none)
        {
            continue;
        }

        if (PC != none && PC.bUseNativeRoleNames)
        {
            S = RI.AltName;
        }
        else
        {
            S = RI.MyName;
        }

        GRI.GetRoleCounts(RI, Count, BotCount, Limit);

        if (Limit > 0)
        {
            S @= "[" $ Count $ "/" $ Limit $ "]";
        }
        else
        {
            S @= "[" $ Count $ "]";
        }

        if (BotCount > 0)
        {
            S @= "*BOTS*";
        }

        li_Roles.SetItemAtIndex(i, S);
        li_Roles.SetDisabledAtIndex(i, (PC.GetRoleInfo() != RI) && (Limit > 0) && (Count >= Limit) && (BotCount == 0));
    }
}

function bool OnClick(GUIComponent Sender)
{
    switch (Sender)
    {
        // Disconnect
        case b_MenuOptions[0]:
            PlayerOwner().ConsoleCommand("DISCONNECT");
            CloseMenu();
            break;

        // Suicide
        case b_MenuOptions[1]:
            PlayerOwner().ConsoleCommand("SUICIDE");
            CloseMenu();
            break;

        // Kick Vote
        case b_MenuOptions[2]:
            Controller.OpenMenu(Controller.KickVotingMenu);
            break;

        // Map Vote
        case b_MenuOptions[3]:
            Controller.OpenMenu(Controller.MapVotingMenu);
            break;

        // Communication
        case b_MenuOptions[4]:
            Controller.OpenMenu("ROInterface.ROCommunicationPage");
            break;

        // Server Browser
        case b_MenuOptions[5]:
            Controller.OpenMenu("DH_Interface.DHServerBrowser");
            break;

        // Options
        case b_MenuOptions[6]:
            Controller.OpenMenu("DH_Interface.DHSettingsPage_new");
            break;

        // Continue
        case b_MenuOptions[7]:
            Apply();
            break;

        //Axis
        case b_Axis:
            ChangeTeam(AXIS_TEAM_INDEX);
            break;

        //Allies
        case b_Allies:
            ChangeTeam(ALLIES_TEAM_INDEX);
            break;

        //Spectate
        case b_Spectate:
            ChangeTeam(254);
            break;

        //Equipment
        case b_EquipmentButton:
            SetLoadoutMode(LM_Equipment);
            break;

        //Vehicle
        case b_VehicleButton:
            SetLoadoutMode(LM_Vehicle);
            break;

        default:
            break;
    }

    return false;
}

function Apply()
{
    local RORoleInfo RI;
    local int RoleIndex;
    local byte Team;

    if (b_MenuOptions[7].MenuState == MSAT_Disabled)
    {
        return;
    }

    RI = RORoleInfo(li_Roles.GetObject());

    if (RI == none)
    {
        return;
    }

    RoleIndex = GRI.GetRoleIndexAndTeam(RI, Team);

    if (RoleIndex == -1)
    {
        return;
    }

    //TODO: ammunition?

    SetButtonsEnabled(false);

    PC.ServerSetPlayerInfo(255,
                           RoleIndex,
                           cb_PrimaryWeapon.GetIndex(),
                           cb_SecondaryWeapon.GetIndex(),
                           SpawnPointIndex,
                           GRI.GetVehiclePoolIndex(class<Vehicle>(li_Vehicles.GetObject())),
                           SpawnVehicleIndex,
                           0);
}

function SetButtonsEnabled(bool bEnable)
{
    bButtonsEnabled = bEnable;

    UpdateButtons();
}

function UpdateButtons()
{
    if (bButtonsEnabled)
    {
        if (CurrentTeam != ALLIES_TEAM_INDEX)
        {
            b_Allies.EnableMe();
        }
        else
        {
            b_Allies.DisableMe();
        }

        if (CurrentTeam != AXIS_TEAM_INDEX)
        {
            b_Axis.EnableMe();
        }
        else
        {
            b_Axis.DisableMe();
        }

        b_Spectate.EnableMe();

        // Colin: Continue button should always be clickable if we're using the old
        // spawning system. If we're using the new spawning system, we have to check
        // that our pending parameters are
        if (PC.ClientLevelInfo.SpawnMode == ESM_RedOrchestra ||
            GRI.AreSpawnSettingsValid(CurrentTeam,
                                  DHRoleInfo(li_Roles.GetObject()),
                                  SpawnPointIndex,
                                  GRI.GetVehiclePoolIndex(class<Vehicle>(li_Vehicles.GetObject())),
                                  SpawnVehicleIndex))
        {
            b_MenuOptions[7].EnableMe();
        }
        else
        {
            b_MenuOptions[7].DisableMe();
        }
    }
    else
    {
        b_Allies.DisableMe();
        b_Axis.DisableMe();
        b_Spectate.DisableMe();

        b_MenuOptions[7].DisableMe();
    }
}

function PopulateRoles()
{
    local int i;
    local string RoleName;

    li_Roles.Clear();
    li_Roles.SetIndex(-1);

    if (CurrentTeam == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
        {
            if (GRI.DHAxisRoles[i] != none)
            {
                if (PC != none && PC.bUseNativeRoleNames)
                {
                    RoleName = GRI.DHAxisRoles[i].default.AltName;
                }
                else
                {
                    RoleName = GRI.DHAxisRoles[i].default.MyName;
                }

                li_Roles.Add(RoleName, GRI.DHAxisRoles[i]);
            }
        }
    }
    else if (CurrentTeam == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.DHAlliesRoles); ++i)
        {
            if (GRI.DHAlliesRoles[i] != none)
            {
                if (PC != none && PC.bUseNativeRoleNames)
                {
                    RoleName = GRI.DHAlliesRoles[i].default.AltName;
                }
                else
                {
                    RoleName = GRI.DHAlliesRoles[i].default.MyName;
                }

                li_Roles.Add(RoleName, GRI.DHAlliesRoles[i]);
            }
        }
    }

    li_Roles.SortList();

    UpdateRoles();

    AutoSelectRole();
}

// Colin: Automatically selects a role from the roles list. If the player is
// currently assigned to a role, that role will be selected. Otherwise, a role
// that has no limit will be selected. In the rare case that no role is
// limitless, no role will be selected.
function AutoSelectRole()
{
    local int i;

    if (PC.GetRoleInfo() != none)
    {
        li_Roles.SelectByObject(PC.GetRoleInfo());
    }
    else
    {
        if (CurrentTeam == AXIS_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
            {
                if (GRI.DHAxisRoles[i] != none &&
                    GRI.DHAxisRoles[i].GetLimit(GRI.MaxPlayers) == 0)
                {
                    li_Roles.SelectByObject(GRI.DHAxisRoles[i]);
                }
            }
        }
        else if(CurrentTeam == ALLIES_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(GRI.DHAlliesRoles); ++i)
            {
                if (GRI.DHAlliesRoles[i] != none &&
                    GRI.DHAlliesRoles[i].GetLimit(GRI.MaxPlayers) == 0)
                {
                    li_Roles.SelectByObject(GRI.DHAlliesRoles[i]);
                }
            }
        }
        else
        {
            li_Roles.SelectByObject(none);
        }
    }
}

// Colin: Automatically selects the players' currently selected vehicle to
// spawn. If no vehicle is selected to spawn, the "None" option will be
// selected.
function AutoSelectVehicle()
{
    local class<Vehicle> VehicleClass;

    if (PC.VehiclePoolIndex >= 0 && PC.VehiclePoolIndex < arraycount(GRI.VehiclePoolVehicleClasses))
    {
        VehicleClass = GRI.VehiclePoolVehicleClasses[PC.VehiclePoolIndex];
    }

    li_Vehicles.SelectByObject(VehicleClass);
}

function InternalOnMessage(coerce string Msg, float MsgLife)
{
    local int Result;
    local string ErrorMessage;

    if (Msg ~= "NOTIFY_GUI_ROLE_SELECTION_PAGE")
    {
        Result = int(MsgLife);

        switch (Result)
        {
            //Spectator
            case 96:
                CloseMenu();
                break;

            //Axis
            case 97:
                //Axis
                OnTeamChanged(AXIS_TEAM_INDEX);
                p_Map.SelectSpawnPoint(255, 255);
                break;

            //Allies
            case 98:
                OnTeamChanged(ALLIES_TEAM_INDEX);
                p_Map.SelectSpawnPoint(255, 255);
                break;

            //Success
            case 0:
                CloseMenu();
                break;

            default:
                ErrorMessage = class'ROGUIRoleSelection'.static.GetErrorMessageForID(Result);

                if (Controller != none)
                {
                    Controller.OpenMenu(Controller.QuestionMenuClass);
                    GUIQuestionPage(Controller.TopPage()).SetupQuestion(ErrorMessage, QBTN_Ok, QBTN_Ok);
                }

                break;
        }
    }

    Log("got return value");
    SetButtonsEnabled(true);
}

// Colin: When the menu is closed, the client tells the server that it is no
// longer in this menu and is therefore ready to be spawned.
function OnClose(optional bool bCancelled)
{
    super.OnClose(bCancelled);

    PC.ServerSetIsInSpawnMenu(false);
}

// Colin: When the menu is closed, the client tells the server that they are in
// the spawn menu and therefore not ready to be spawned.
function OnOpen()
{
    super.OnOpen();

    PC.ServerSetIsInSpawnMenu(true);

    Timer();

    SetTimer(1.0, true);
}

function CloseMenu()
{
    if (Controller != none)
    {
        Controller.RemoveMenu(self);
    }
}

// Colin: This function centers the map component inside of it's container.
function bool MapContainerPreDraw(Canvas C)
{
    local float Offset;

    Offset = (c_Map.ActualWidth() - c_Map.ActualHeight()) / 2.0;
    Offset /= ActualWidth();

    p_Map.SetPosition(c_Map.WinLeft + Offset,
                      c_Map.WinTop,
                      c_Map.ActualHeight(),
                      c_Map.ActualHeight(),
                      true);

    return true;
}

function InternalOnChange(GUIComponent Sender)
{
    local int i, j;
    local RORoleInfo RI;
    local class<Vehicle> VehicleClass;
    local class<Weapon> WeaponClass;

    switch (Sender)
    {
        case li_Roles:
        case lb_Roles:
            i_PrimaryWeapon.Image = none;
            i_SecondaryWeapon.Image = none;

            for (i = 0; i < arraycount(i_GivenItems); ++i)
            {
                if (i_GivenItems[i] != none)
                {
                    i_GivenItems[i].Image = none;
                }
            }

            cb_PrimaryWeapon.Clear();
            cb_SecondaryWeapon.Clear();

            RI = RORoleInfo(li_Roles.GetObject());

            if (RI != none)
            {
                for (i = 0; i < arraycount(RI.PrimaryWeapons); ++i)
                {
                    if (RI.PrimaryWeapons[i].Item != none)
                    {
                        cb_PrimaryWeapon.AddItem(RI.PrimaryWeapons[i].Item.default.ItemName, RI.PrimaryWeapons[i].Item);
                    }
                }

                for (i = 0; i < arraycount(RI.SecondaryWeapons); ++i)
                {
                    if (RI.SecondaryWeapons[i].Item != none)
                    {
                        cb_SecondaryWeapon.AddItem(RI.SecondaryWeapons[i].Item.default.ItemName, RI.SecondaryWeapons[i].Item);
                    }
                }
            }

            if (PC.GetRoleInfo() == RI)
            {
                cb_PrimaryWeapon.SetIndex(PC.PrimaryWeapon);
                cb_SecondaryWeapon.SetIndex(PC.SecondaryWeapon);
            }
            else
            {
                cb_PrimaryWeapon.SetIndex(0);
                cb_SecondaryWeapon.SetIndex(0);
            }

            if (RI != none)
            {
                for (i = 0; i < RI.default.GivenItems.Length; ++i)
                {
                    WeaponClass = class<Weapon>(DynamicLoadObject(RI.default.GivenItems[i], class'class'));

                    if (WeaponClass != none && i_GivenItems[i] != none && class<ROWeaponAttachment>(WeaponClass.default.AttachmentClass) != none)
                    {
                        //TODO: do proper placement logic
                        i_GivenItems[j++].Image = class<ROWeaponAttachment>(WeaponClass.default.AttachmentClass).default.menuImage;
                    }
                }
            }

            if (RI != none && RI.bCanBeTankCrew)
            {
                SetLoadoutMode(LM_Vehicle);
            }
            else
            {
                SetLoadoutMode(LM_Equipment);
            }

            // Colin: Vehicle eligibility may have changed, update vehicles.
            UpdateVehicles();

            break;

        case cb_PrimaryWeapon:
            if (class<Inventory>(cb_PrimaryWeapon.GetObject()) != none && class<ROWeaponAttachment>(class<Inventory>(cb_PrimaryWeapon.GetObject()).default.AttachmentClass) != none)
            {
                i_PrimaryWeapon.Image = class<ROWeaponAttachment>(class<Inventory>(cb_PrimaryWeapon.GetObject()).default.AttachmentClass).default.MenuImage;
            }

            break;

        case cb_SecondaryWeapon:
            if (class<Inventory>(cb_SecondaryWeapon.GetObject()) != none && class<ROWeaponAttachment>(class<Inventory>(cb_SecondaryWeapon.GetObject()).default.AttachmentClass) != none)
            {
                i_SecondaryWeapon.Image = class<ROWeaponAttachment>(class<Inventory>(cb_SecondaryWeapon.GetObject()).default.AttachmentClass).default.MenuImage;
            }

            break;

        case li_Vehicles:
        case lb_Vehicles:
            VehicleClass = class<Vehicle>(li_Vehicles.GetObject());

            if (VehicleClass != none)
            {
                i_Vehicle.Image = VehicleClass.default.SpawnOverlay[0];
            }
            else
            {
                i_Vehicle.Image = none;
            }

            UpdateSpawnPoints();

            break;

        default:
            break;
    }
}

function ChangeTeam(byte Team)
{
    if (Team != CurrentTeam)
    {
        SetButtonsEnabled(false);

        PC.ServerSetPlayerInfo(Team, 255, 0, 0, 255, 255, 255, 255);
    }
}

function OnTeamChanged(byte Team)
{
    CurrentTeam = Team;

    PopulateRoles();
    PopulateVehicles();

    UpdateSpawnPoints();
    UpdateStatus();
    UpdateButtons();
    UpdateRoundStatus();
}

function OnSpawnPointChanged(byte SpawnPointIndex, byte SpawnVehicleIndex)
{
    self.SpawnPointIndex = SpawnPointIndex;
    self.SpawnVehicleIndex = SpawnVehicleIndex;

    UpdateStatus();
    UpdateButtons();
}

defaultproperties
{
    SpawnPointIndex=255
    SpawnVehicleIndex=255

    // GUI Components
    OnMessage=InternalOnMessage
    bRenderWorld=true
    bAllowedAsLast=true
    WinTop=0.0
    WinHeight=1.0

    Begin Object Class=FloatingImage Name=FloatingBackground
        Image=texture'DH_GUI_Tex.DeployMenu.Background'
        DropShadow=none
        ImageStyle=ISTY_Scaled
        WinTop=0.0
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=1.0
    End Object
    i_Background=FloatingBackground

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=FooterContainerObject
        WinHeight=0.05
        WinWidth=1.0
        WinLeft=0.0
        WinTop=0.95
    End Object
    c_Footer=FooterContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=TeamsContainerObject
        WinHeight=0.05
        WinWidth=0.26
        WinLeft=0.02
        WinTop=0.02
    End Object
    c_Teams=TeamsContainerObject

    Begin Object Class=GUIButton Name=AxisButtonObject
        StyleName="DHDeployTabButton"
        WinHeight=1.0
        WinWidth=0.4
        WinTop=0.0
        WinLeft=0.0
        OnClick=OnClick
        Hint="Join Axis"
    End Object
    b_Axis=AxisButtonObject

    Begin Object Class=GUIImage Name=AxisImageObject
        WinHeight=1.0
        WinWidth=0.2
        WinTop=0.0
        WinLeft=0.025
        Image=material'DH_GUI_tex.DeployMenu.flag_germany'
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
    End Object
    i_Axis=AxisImageObject

    Begin Object Class=GUIButton Name=AlliesButtonObject
        StyleName="DHDeployTabButton"
        WinHeight=1.0
        WinWidth=0.4
        WinTop=0.0
        WinLeft=0.4
        OnClick=OnClick
        Hint="Join Allies"
    End Object
    b_Allies=AlliesButtonObject

    Begin Object Class=GUIImage Name=AlliesImageObject
        WinHeight=1.0
        WinWidth=0.2
        WinTop=0.00
        WinLeft=0.425
        Image=material'DH_GUI_tex.DeployMenu.flag_usa'
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
    End Object
    i_Allies=AlliesImageObject

    Begin Object Class=GUIButton Name=SpectateButtonObject
        StyleName="DHDeployTabButton"
        WinHeight=1.0
        WinWidth=0.2
        WinTop=0.0
        WinLeft=0.8
        OnClick=OnClick
        Hint="Spectate"
    End Object
    b_Spectate=SpectateButtonObject

    Begin Object Class=GUIImage Name=SpectateImageObject
        WinHeight=1.0
        WinWidth=0.2
        WinTop=0.0
        WinLeft=0.8
        Image=material'DH_GUI_tex.DeployMenu.spectate'
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
    End Object
    i_Spectate=SpectateImageObject

    Begin Object Class=GUIImage Name=ReinforcementsImageObject
        WinWidth=0.04
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.07
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.reinforcements'
    End Object
    i_Reinforcements=ReinforcementsImageObject

    Begin Object class=GUILabel Name=ReinforcementsLabelObject
        TextAlign=TXTA_Left
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.09
        WinHeight=0.05
        WinLeft=0.06
        WinTop=0.07
    End Object
    l_Reinforcements=ReinforcementsLabelObject

    Begin Object Class=GUIImage Name=RoundTimeImageObject
        WinWidth=0.04
        WinHeight=0.05
        WinLeft=0.15
        WinTop=0.07
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.StopWatch'
    End Object
    i_RoundTime=RoundTimeImageObject

    Begin Object class=GUILabel Name=RoundTimeLabelObject
        TextAlign=TXTA_Left
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.09
        WinHeight=0.05
        WinLeft=0.19
        WinTop=0.07
        Hint="Time Remaining"
    End Object
    l_RoundTime=RoundTimeLabelObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=RolesContainerObject
        WinWidth=0.26
        WinHeight=0.28
        WinLeft=0.02
        WinTop=0.12
        LeftPadding=0.05
        RightPadding=0.05
        TopPadding=0.05
        BottomPadding=0.05
    End Object
    c_Roles=RolesContainerObject

    Begin Object Class=DHGUIListBox Name=RolesListBoxObject
        OutlineStyleName="ItemOutline"
        SectionStyleName="ListSection"
        SelectedStyleName="DHItemOutline"
        StyleName="DHSmallText"
        bVisibleWhenEmpty=true
        bSorted=true
        OnChange=InternalOnChange
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_Roles=RolesListBoxObject

    Begin Object Class=DHGUIListBox Name=VehiclesListBoxObject
        OutlineStyleName="ItemOutline"
        SectionStyleName="ListSection"
        SelectedStyleName="DHItemOutline"
        StyleName="DHSmallText"
        bVisibleWhenEmpty=true
        bSorted=true
        OnChange=InternalOnChange
        WinWidth=1.0
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.5
    End Object
    lb_Vehicles=VehiclesListBoxObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=LoadoutTabContainerObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.40
    End Object
    LoadoutTabContainer=LoadoutTabContainerObject

    Begin Object Class=GUIButton Name=EquipmentButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.0
        OnClick=OnClick
    End Object
    b_EquipmentButton=EquipmentButtonObject

    Begin Object Class=GUIImage Name=EquipmentButtonImageObject
        WinWidth=0.5
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.equipment'
    End Object
    i_EquipmentButton=EquipmentButtonImageObject

    Begin Object Class=GUIButton Name=VehicleButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.5
        OnClick=OnClick
    End Object
    b_VehicleButton=VehicleButtonObject

    Begin Object Class=GUIImage Name=VehiclesButtonImageObject
        WinWidth=0.5
        WinHeight=1.0
        WinLeft=0.5
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.vehicles'
    End Object
    i_VehiclesButton=VehiclesButtonImageObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=LoadoutContainerObject
        WinWidth=0.26
        WinHeight=0.48
        WinLeft=0.02
        WinTop=0.45
        LeftPadding=0.05
        RightPadding=0.05
        TopPadding=0.05
        BottomPadding=0.05
        OnClick=OnClick
    End Object
    c_Loadout=LoadoutContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=EquipmentContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    c_Equipment=EquipmentContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=VehicleContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bVisible=false
    End Object
    c_Vehicle=VehicleContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapContainerObject
        WinWidth=0.68
        WinHeight=0.91
        WinLeft=0.3
        WinTop=0.02
        OnPreDraw=MapContainerPreDraw
    End Object
    c_Map=MapContainerObject

    Begin Object Class=DHGUIButton Name=DisconnectButtonObject
        Caption="Disconnect"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(0)=DisconnectButtonObject

    //Suicide Button
    Begin Object Class=DHGUIButton Name=SuicideButtonObject
        Caption="Suicide"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(1)=SuicideButtonObject

    //Kick Vote Button
    Begin Object Class=DHGUIButton Name=KickVoteButtonObject
        Caption="Kick Vote"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(2)=KickVoteButtonObject

    //Map Vote Button
    Begin Object Class=DHGUIButton Name=MapVoteButtonObject
        Caption="Map Vote"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(3)=MapVoteButtonObject

    //CommunicationButton
    Begin Object Class=DHGUIButton Name=CommunicationButtonObject
        Caption="Communication"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(4)=CommunicationButtonObject

    //Servers Button
    Begin Object Class=DHGUIButton Name=ServersButtonObject
        Caption="Servers"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(5)=ServersButtonObject

    //Settings Button
    Begin Object Class=DHGUIButton Name=SettingsButtonObject
        Caption="Settings"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(6)=SettingsButtonObject

    //Continue Button
    Begin Object Class=GUIGFXButton Name=ContinueButtonObject
        Caption="Continue"
        CaptionAlign=TXTA_Right
        StyleName="DHDeployContinueButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
        Graphic=material'DH_GUI_tex.DeployMenu.arrow_sequence'
    End Object
    b_MenuOptions(7)=ContinueButtonObject

    Begin Object Class=DHGUIMapComponent Name=MapComponentObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
        OnSpawnPointChanged=OnSpawnPointChanged
    End Object
    p_Map=MapComponentObject

    Begin Object Class=GUIImage Name=PrimaryWeaponImageObject
        WinWidth=1.0
        WinHeight=0.333334
        WinLeft=0.0
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_PrimaryWeapon=PrimaryWeaponImageObject

    Begin Object Class=DHmoComboBox Name=PrimaryWeaponComboBoxObject
        bReadOnly=true
        CaptionWidth=0
        ComponentWidth=-1
        WinWidth=0.75
        WinLeft=0.0
        WinTop=0.0
        OnChange=InternalOnChange
    End Object
    cb_PrimaryWeapon=PrimaryWeaponComboBoxObject

    Begin Object Class=GUIImage Name=SecondaryWeaponImageObject
        WinWidth=0.5
        WinHeight=0.333334
        WinLeft=0.0
        WinTop=0.333334
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_SecondaryWeapon=SecondaryWeaponImageObject

    Begin Object Class=DHmoComboBox Name=SecondaryWeaponComboBoxObject
        bReadOnly=true
        CaptionWidth=0
        ComponentWidth=-1
        WinWidth=0.5
        WinLeft=0.0
        WinTop=0.333334
        OnChange=InternalOnChange
    End Object
    cb_SecondaryWeapon=SecondaryWeaponComboBoxObject

    Begin Object Class=GUIImage Name=GivenItemImageObject0
        WinWidth=0.5
        WinHeight=0.333334
        WinLeft=0.5
        WinTop=0.333334
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(0)=GivenItemImageObject0

    Begin Object Class=GUIImage Name=VehicleImageObject
        WinWidth=1.0
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_Vehicle=VehicleImageObject

    Begin Object Class=GUILabel Name=StatusLabelObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.88
        TextAlign=TXTA_Center
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
    End Object
    l_Status=StatusLabelObject

    NoneText="None"
    SelectRoleText="Select a role"
    SelectSpawnPointText="Select a spawn point"
    SelectVehicleText="Select a vehicle"
    bButtonsEnabled=true
}
