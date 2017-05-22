//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHDeployMenu extends UT2K4GUIPage;

enum ELoadoutMode
{
    LM_Equipment,
    LM_Vehicle
};

enum EMapMode
{
    MODE_Map,
    MODE_Squads
};

var automated   FloatingImage               i_Background;
var automated   ROGUIProportionalContainer  c_Teams;
var automated   GUIButton                       b_Axis;
var automated   GUIImage                        i_Axis;
var automated   GUILabel                        l_Axis;
var automated   GUIButton                       b_Allies;
var automated   GUIImage                        i_Allies;
var automated   GUILabel                        l_Allies;
var automated   GUIButton                       b_Spectate;
var automated   GUIImage                        i_Spectate;
var automated   GUIImage                    i_Reinforcements;
var automated   GUILabel                    l_Reinforcements;
var automated   GUIImage                    i_SizeAdvantage;
var automated   GUILabel                    l_SizeAdvantage;
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
var automated   ROGUIProportionalContainer  MapSquadsTabContainer;
var automated   GUIButton                   b_MapButton;
var automated   GUIImage                    i_MapButton;
var automated   GUIButton                   b_SquadsButton;
var automated   GUIImage                    i_SquadsButton;
var automated   GUILabel                    l_Loadout;
var automated   ROGUIProportionalContainer  c_Loadout;
var automated   ROGUIProportionalContainer      c_Equipment;
var automated   ROGUIProportionalContainer      c_Vehicle;
var automated   ROGUIProportionalContainer  c_MapRoot;
var automated   ROGUIProportionalContainer      c_Map;
var automated   GUIImage                            i_MapBorder;
var automated   DHGUIMapComponent                   p_Map;
var automated   ROGUIProportionalContainer      c_Squads;
var automated   DHGUISquadsComponent                p_Squads;
var automated   ROGUIProportionalContainer  c_Footer;
var automated   GUILabel                    l_Status;
var automated   GUIImage                        i_PrimaryWeapon;
var automated   GUIImage                        i_SecondaryWeapon;
var automated   GUIImage                        i_Vehicle;
var automated   GUIGFXButton                    i_SpawnVehicle;
var automated   GUIGFXButton                    i_ArtilleryVehicle;
var automated   DHmoComboBox                cb_PrimaryWeapon;
var automated   DHmoComboBox                cb_SecondaryWeapon;
var automated   GUIImage                    i_GivenItems[5];
var automated   DHGUIListBox                lb_Vehicles;
var             DHGUIList                   li_Vehicles;
var automated   DHGUIListBox                lb_PrimaryWeapons;
var             DHGUIList                   li_PrimaryWeapons;
var automated   GUIImage                    i_Arrows;

var automated   array<GUIButton>            b_MenuOptions;

var DHGameReplicationInfo                   GRI;
var DHSquadReplicationInfo                  SRI;
var DHPlayerReplicationInfo                 PRI;
var DHPlayer                                PC;

var localized   string                      NoneText;
var localized   string                      SelectRoleText;
var localized   string                      SelectSpawnPointText;
var localized   string                      DeployInTimeText;
var localized   string                      DeployNowText;
var localized   string                      ReservedString;
var localized   string                      ChangeTeamConfirmText;
var localized   string                      FreeChangeTeamConfirmText;
var localized   string                      CantChangeTeamYetText;

var localized   string                      LockText;
var localized   string                      UnlockText;

var localized   string                      VehicleUnavailableString;

// Colin: The reason this variable is needed is because the PlayerController's
// GetTeamNum function is not reliable after receiving a successful team change
// signal from InternalOnMessage.
var             byte                        CurrentTeam;

var             ELoadoutMode                LoadoutMode;

var             int                         SpawnPointIndex;
var             byte                        SpawnVehicleIndex;

var             bool                        bButtonsEnabled;

var             material                    VehicleNoneMaterial;

var             EMapMode                    MapMode;

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

    c_Footer.ManageComponent(i_Arrows);

    // Team buttons
    c_Teams.ManageComponent(b_Allies);
    c_Teams.ManageComponent(i_Allies);
    c_Teams.ManageComponent(l_Allies);
    c_Teams.ManageComponent(b_Axis);
    c_Teams.ManageComponent(i_Axis);
    c_Teams.ManageComponent(l_Axis);
    c_Teams.ManageComponent(b_Spectate);
    c_Teams.ManageComponent(i_Spectate);

    c_Loadout.ManageComponent(c_Equipment);
    c_Loadout.ManageComponent(c_Vehicle);

    LoadoutTabContainer.ManageComponent(b_EquipmentButton);
    LoadoutTabContainer.ManageComponent(b_VehicleButton);
    LoadoutTabContainer.ManageComponent(i_EquipmentButton);
    LoadoutTabContainer.ManageComponent(i_VehiclesButton);

    MapSquadsTabContainer.ManageComponent(b_MapButton);
    MapSquadsTabContainer.ManageComponent(b_SquadsButton);
    MapSquadsTabContainer.ManageComponent(i_MapButton);
    MapSquadsTabContainer.ManageComponent(i_SquadsButton);

    c_MapRoot.ManageComponent(c_Map);

    c_Map.ManageComponent(i_MapBorder);
    c_Map.ManageComponent(p_Map);

    c_Squads.ManageComponent(p_Squads);

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
    c_Vehicle.ManageComponent(i_SpawnVehicle);
    c_Vehicle.ManageComponent(i_ArtilleryVehicle);
    c_Vehicle.ManageComponent(lb_Vehicles);

    c_Roles.ManageComponent(lb_Roles);

    SetMapMode(MODE_Map);
}

function SetLoadoutMode(ELoadoutMode Mode)
{
    local int i;

    LoadoutMode = Mode;

    // Colin: GUIComponent visibility is not properly hierarchical, so we
    // need to hide and show elements individually.
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
            i_SpawnVehicle.SetVisibility(false);
            i_ArtilleryVehicle.SetVisibility(false);

            break;
        case LM_Vehicle:
            b_EquipmentButton.EnableMe();
            b_VehicleButton.DisableMe();
            i_VehiclesButton.Image = material'DH_GUI_Tex.DeployMenu.vehicles';
            UpdateVehicleImage();

            break;
    }

    UpdateSpawnPoints();
    UpdateButtons();
}

function Timer()
{
    // Colin: The GRI might not be set when we first open the menu if the player
    // opens it very quickly. This timer will sit and wait until the GRI is
    // confirmed to be present before populating any lists or running any
    // regular timer logic.
    local byte Team;

    if (GRI == none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

        if (GRI != none)
        {
            // Colin: Now that we have the GRI, we can set the Allied flag on
            // the team button.
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
                case 3: // USSR
                    i_Allies.Image = material'DH_GUI_tex.DeployMenu.flag_ussr';
                    break;
            }

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

            // Colin: Automatically select the player's spawn point.
            p_Map.SelectSpawnPoint(PC.SpawnPointIndex);
        }
    }

    if (SRI == none)
    {
        SRI = PC.SquadReplicationInfo;
    }

    if (PRI == none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    }

    if (GRI != none)
    {
        UpdateRoles();
        UpdateVehicles(true);
        UpdateRoundStatus();
        UpdateStatus();
        UpdateButtons();
        UpdateSpawnPoints();
    }

    if (SRI != none)
    {
        UpdateSquads();
    }
}

function UpdateRoundStatus()
{
    local int RoundTime;

    if (GRI != none)
    {
        if (GRI.AttritionRate[CurrentTeam] > 0.0)
        {
            l_Reinforcements.TextColor = class'UColor'.default.Red;
            i_Reinforcements.ImageColor = class'UColor'.default.Red;
        }
        else
        {
            l_Reinforcements.TextColor = class'UColor'.default.White;
            i_Reinforcements.ImageColor = class'UColor'.default.White;
        }

        if (GRI.SpawnsRemaining[CurrentTeam] == -1)
        {
            l_Reinforcements.Caption = GRI.ReinforcementsInfiniteText;
        }
        else
        {
            l_Reinforcements.Caption = string(GRI.SpawnsRemaining[CurrentTeam]);
        }

        if (GRI.CurrentAlliedToAxisRatio != 0.5)
        {
            l_SizeAdvantage.Caption = GRI.GetTeamScaleString(CurrentTeam);
            l_SizeAdvantage.Show();
            i_SizeAdvantage.Show();
        }
        else
        {
            l_SizeAdvantage.Hide();
            i_SizeAdvantage.Hide();
        }

        if (!GRI.bMatchHasBegun)
        {
            RoundTime = Max(0, GRI.RoundStartTime + GRI.PreStartTime - GRI.ElapsedTime);
        }
        else if (GRI.bRoundIsOver)
        {
            RoundTime = GRI.RoundEndTime;
        }
        else
        {
            RoundTime = Max(0, GRI.RoundEndTime - GRI.ElapsedTime);
        }

        if (GRI.RoundDuration == 0 && GRI.bMatchHasBegun)
        {
            l_RoundTime.Caption = class'DHHud'.default.NoTimeLimitText;
        }
        else
        {
            l_RoundTime.Caption = class'TimeSpan'.static.ToString(Max(0, RoundTime));
        }
    }
}

function GetMapCoords(vector Location, out float X, out float Y, optional float Width, optional float Height)
{
    local float MapScale;
    local vector MapCenter;

    MapScale = FMax(1.0, Abs((GRI.SouthWestBounds - GRI.NorthEastBounds).X));
    MapCenter = GRI.NorthEastBounds + ((GRI.SouthWestBounds - GRI.NorthEastBounds) * 0.5);
    Location = DHHud(PlayerOwner().MyHud).GetAdjustedHudLocation(Location - MapCenter, false);

    X = FClamp(0.5 + (Location.X / MapScale) - (Width / 2),
               0.0,
               1.0 - Width);

    Y = FClamp(0.5 + (Location.Y / MapScale) - (Height / 2),
               0.0,
               1.0 - Height);
}

function int GetSelectedVehiclePoolIndex()
{
    local UInteger Index;

    Index = UInteger(li_Vehicles.GetObject());

    if (Index != none)
    {
        return Index.Value;
    }

    return -1;
}

function UpdateSpawnPoints()
{
    local int i, RoleIndex, SquadIndex;
    local float X, Y;
    local byte Team;
    local GUI.eFontScale FS;

    if (GRI != none)
    {
        RoleIndex = GRI.GetRoleIndexAndTeam(DHRoleInfo(li_Roles.GetObject()), Team);
    }
    else
    {
        RoleIndex = -1;
    }

    if (PRI != none)
    {
        SquadIndex = PRI.SquadIndex;
    }
    else
    {
        SquadIndex = -1;
    }

    // Spawn points
    for (i = 0; i < arraycount(p_Map.b_SpawnPoints); ++i)
    {
        if (GRI != none &&
            GRI.SpawnPoints[i] != none &&
            GRI.SpawnPoints[i].IsVisibleTo(CurrentTeam, RoleIndex, SquadIndex, GetSelectedVehiclePoolIndex()))
        {
            GetMapCoords(GRI.SpawnPoints[i].Location, X, Y, p_Map.b_SpawnPoints[i].WinWidth, p_Map.b_SpawnPoints[i].WinHeight);

            p_Map.b_SpawnPoints[i].SetPosition(X, Y, p_Map.b_SpawnPoints[i].WinWidth, p_Map.b_SpawnPoints[i].WinHeight, true);
            p_Map.b_SpawnPoints[i].SetVisibility(true);
            p_Map.b_SpawnPoints[i].CenterText = GRI.SpawnPoints[i].GetMapText();

            if (GRI.SpawnPoints[i].CanSpawnWithParameters(GRI, CurrentTeam, RoleIndex, SquadIndex, GetSelectedVehiclePoolIndex()))
            {
                p_Map.b_SpawnPoints[i].MenuStateChange(MSAT_Blurry);
            }
            else
            {
                if (SpawnPointIndex != -1 && SpawnPointIndex == p_Map.b_SpawnPoints[i].Tag)
                {
                    p_Map.SelectSpawnPoint(-1);
                }

                p_Map.b_SpawnPoints[i].MenuStateChange(MSAT_Disabled);
            }

            p_Map.b_SpawnPoints[i].Style = Controller.GetStyle(GRI.SpawnPoints[i].GetMapStyleName(), FS);
        }
        else
        {
            // If spawn point that was previously selected is now hidden,
            // deselect it.
            p_Map.b_SpawnPoints[i].SetVisibility(false);
            p_Map.b_SpawnPoints[i].CenterText = "";

            if (SpawnPointIndex == p_Map.b_SpawnPoints[i].Tag)
            {
                p_Map.SelectSpawnPoint(-1);
            }
        }
    }
}

function UpdateStatus()
{
    if (GRI == none)
    {
        return;
    }

    l_Axis.Caption = string(class'ROGUITeamSelection'.static.getTeamCountStatic(GRI, PlayerOwner(), AXIS_TEAM_INDEX));
    l_Allies.Caption = string(class'ROGUITeamSelection'.static.getTeamCountStatic(GRI, PlayerOwner(), ALLIES_TEAM_INDEX));

    l_Status.Caption = GetStatusText();

    // Suicide button status
    if (PC.Pawn != none)
    {
        b_MenuOptions[1].MenuStateChange(MSAT_Blurry);
    }
    else
    {
        b_MenuOptions[1].MenuStateChange(MSAT_Disabled);
    }
}

function string GetStatusText()
{
    local DHRoleInfo RI;
    local int SpawnTime;

    RI = DHRoleInfo(li_Roles.GetObject());

    if (RI == none)
    {
        return default.SelectRoleText;
    }

    if (SpawnPointIndex == -1)
    {
        return default.SelectSpawnPointText;
    }

    SpawnTime = Max(0, PC.GetNextSpawnTime(RI, GetSelectedVehiclePoolIndex()) - GRI.ElapsedTime);

    if (SpawnTime > 0)
    {
        return Repl(default.DeployInTimeText, "{0}", class'DHLib'.static.GetDurationString(SpawnTime, "m:ss"));
    }
    else
    {
        return default.DeployNowText;
    }
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
            li_Vehicles.Add(GRI.VehiclePoolVehicleClasses[i].default.VehicleNameString, class'UInteger'.static.Create(i));
        }
    }

    li_Vehicles.SortList();
    li_Vehicles.Insert(0, default.NoneText, none,, true);

    UpdateVehicles();
    AutoSelectVehicle();
}

function UpdateVehicles(optional bool bShowAlert)
{
    local int i, j;
    local class<ROVehicle> VehicleClass;
    local DHRoleInfo RI;
    local bool bDisabled;
    local string S;
    local float RespawnTime;

    if (GRI == none)
    {
        return;
    }

    RI = DHRoleInfo(li_Roles.GetObject());

    for (i = 0; i < li_Vehicles.ItemCount; ++i)
    {
        if (UInteger(li_Vehicles.GetObjectAtIndex(i)) == none)
        {
            continue;
        }

        j = UInteger(li_Vehicles.GetObjectAtIndex(i)).Value;

        VehicleClass = GRI.VehiclePoolVehicleClasses[j];

        PC = DHPlayer(PlayerOwner());

        //TODO: have team max be indicated in another part of this control (ie. don't obfuscate meaning)
        bDisabled = VehicleClass != none &&
                    ((VehicleClass.default.bMustBeTankCommander && RI != none && !RI.default.bCanBeTankCrew) ||
                    (!GRI.IgnoresMaxTeamVehiclesFlags(j) && GRI.MaxTeamVehicles[CurrentTeam] <= 0) ||
                    GRI.GetVehiclePoolSpawnsRemaining(j) <= 0 ||
                    !GRI.IsVehiclePoolActive(j) ||
                    GRI.VehiclePoolActiveCounts[j] >= GRI.VehiclePoolMaxActives[j] ||
                    (PC.Pawn != none && PC.Pawn.Health > 0) ||
                    (PC.VehiclePoolIndex != j && !GRI.IsVehiclePoolReservable(PC, RI, j)));

        if (VehicleClass != none)
        {
            S = VehicleClass.default.VehicleNameString;

            if (GRI.GetVehiclePoolSpawnsRemaining(j) != 255)
            {
                S @= "[" $ GRI.GetVehiclePoolSpawnsRemaining(j) $ "]";
            }

            if (GRI.VehiclePoolMaxActives[j] != 255)
            {
                S @= "{" $ GRI.VehiclePoolActiveCounts[j] $ "/" $ GRI.VehiclePoolMaxActives[j] $ "}";
            }

            RespawnTime = GRI.VehiclePoolNextAvailableTimes[j] - GRI.ElapsedTime;
            RespawnTime = Max(RespawnTime, PC.NextVehicleSpawnTime - GRI.ElapsedTime);

            if (GRI.VehiclePoolReservationCount[j] > 0)
            {
                S @= "<" $ GRI.VehiclePoolReservationCount[j] @ default.ReservedString $ ">";
            }

            if (RespawnTime > 0)
            {
                S @= "(" $ class'DHLib'.static.GetDurationString(RespawnTime, "m:ss") $ ")";
            }

            li_Vehicles.SetItemAtIndex(i, S);
        }

        li_Vehicles.SetDisabledAtIndex(i, bDisabled);

        // If selected vehicle pool becomes disabled, select the "None" option
        // and display a warning to the user, if specified.
        if (bDisabled && li_Vehicles.Index == i)
        {
            if (bShowAlert)
            {
                Controller.OpenMenu("GUI2K4.GUI2K4QuestionPage");
                GUIQuestionPage(Controller.TopPage()).SetupQuestion(default.VehicleUnavailableString, QBTN_OK, QBTN_OK);
                GUIQuestionPage(Controller.TopPage()).OnButtonClick = OnOKButtonClick;
            }

            li_Vehicles.SetIndex(0);
        }
    }
}

function OnOKButtonClick(byte Button)
{
    Controller.CloseMenu(true);
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

        if (Limit == 0)
        {
            S @= "[Locked]";
        }
        else if (Limit == 255)
        {
            S @= "[" $ Count $ "]";
        }
        else
        {
            S @= "[" $ Count $ "/" $ Limit $ "]";
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
            if (CurrentTeam != 0 && PC.NextChangeTeamTime < GRI.ElapsedTime)
            {
                Controller.OpenMenu(Controller.QuestionMenuClass);

                // If solo then never warn
                if (PlayerOwner().Level.NetMode == NM_Standalone)
                {
                    GUIQuestionPage(Controller.TopPage()).SetupQuestion(FreeChangeTeamConfirmText, QBTN_YesNo);
                }
                else
                {
                    // If we are not with in the first ChangeTeamInterval seconds of the round, then warn
                    if (GRI.ElapsedTime > class'DarkestHourGame'.default.ChangeTeamInterval)
                    {
                        GUIQuestionPage(Controller.TopPage()).SetupQuestion(Repl(default.ChangeTeamConfirmText, "{s}", class'DarkestHourGame'.default.ChangeTeamInterval), QBTN_YesNo);
                    }
                    else
                    {
                        GUIQuestionPage(Controller.TopPage()).SetupQuestion(FreeChangeTeamConfirmText, QBTN_YesNo);
                    }
                }

                GUIQuestionPage(Controller.TopPage()).NewOnButtonClick = ChangeToAxisChoice;
            }
            else if (CurrentTeam != 0)
            {
                Controller.OpenMenu(Controller.QuestionMenuClass);
                GUIQuestionPage(Controller.TopPage()).SetupQuestion(Repl(default.CantChangeTeamYetText, "{s}", PC.NextChangeTeamTime - GRI.ElapsedTime), QBTN_Ok);
            }
            break;

        //Allies
        case b_Allies:
            if (CurrentTeam != 1 && PC.NextChangeTeamTime < GRI.ElapsedTime)
            {
                Controller.OpenMenu(Controller.QuestionMenuClass);

                // If solo then never warn
                if (PlayerOwner().Level.NetMode == NM_Standalone)
                {
                    GUIQuestionPage(Controller.TopPage()).SetupQuestion(FreeChangeTeamConfirmText, QBTN_YesNo);
                }
                else
                {
                    // If we are not with in the first ChangeTeamInterval seconds of the round, then warn
                    if (GRI.ElapsedTime > class'DarkestHourGame'.default.ChangeTeamInterval)
                    {
                        GUIQuestionPage(Controller.TopPage()).SetupQuestion(Repl(default.ChangeTeamConfirmText, "{s}", class'DarkestHourGame'.default.ChangeTeamInterval), QBTN_YesNo);
                    }
                    else
                    {
                        GUIQuestionPage(Controller.TopPage()).SetupQuestion(FreeChangeTeamConfirmText, QBTN_YesNo);
                    }
                }

                GUIQuestionPage(Controller.TopPage()).NewOnButtonClick = ChangeToAlliesChoice;
            }
            else if (CurrentTeam != 1)
            {
                Controller.OpenMenu(Controller.QuestionMenuClass);
                GUIQuestionPage(Controller.TopPage()).SetupQuestion(Repl(default.CantChangeTeamYetText, "{s}", PC.NextChangeTeamTime - GRI.ElapsedTime), QBTN_Ok);
            }
            break;

        //Spectate
        case b_Spectate:
            if (PC.NextChangeTeamTime < GRI.ElapsedTime)
            {
                Controller.OpenMenu(Controller.QuestionMenuClass);
                GUIQuestionPage(Controller.TopPage()).SetupQuestion(Repl(default.ChangeTeamConfirmText, "{s}", class'DarkestHourGame'.default.ChangeTeamInterval), QBTN_YesNo);
                GUIQuestionPage(Controller.TopPage()).NewOnButtonClick = ChangeToSpectateChoice;
            }
            else
            {
                Controller.OpenMenu(Controller.QuestionMenuClass);
                GUIQuestionPage(Controller.TopPage()).SetupQuestion(Repl(default.CantChangeTeamYetText, "{s}", PC.NextChangeTeamTime - GRI.ElapsedTime), QBTN_Ok);
            }
            break;

        //Equipment
        case b_EquipmentButton:
            SetLoadoutMode(LM_Equipment);
            break;

        //Vehicle
        case b_VehicleButton:
            SetLoadoutMode(LM_Vehicle);
            break;

        // Map
        case b_MapButton:
            SetMapMode(MODE_Map);
            break;

        // Squads
        case b_SquadsButton:
            SetMapMode(MODE_Squads);
            break;

        default:
            break;
    }

    return false;
}

function bool ChangeToAxisChoice(byte Button)
{
    switch (Button)
    {
        // Yes
        case 16:
            ChangeTeam(AXIS_TEAM_INDEX);
            return true;
            break;
        default:
            return true;
            break;
    }
}

function bool ChangeToAlliesChoice(byte Button)
{
    switch (Button)
    {
        // Yes
        case 16:
            ChangeTeam(ALLIES_TEAM_INDEX);
            return true;
            break;
        default:
            return true;
            break;
    }
}

function bool ChangeToSpectateChoice(byte Button)
{
    switch (Button)
    {
        // Yes
        case 16:
            ChangeTeam(254); // Spectate
            return true;
            break;
        default:
            return true;
            break;
    }
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

    if (li_Vehicles.Index == -1)
    {
        return;
    }

    SetButtonsEnabled(false);

    PC.ServerSetPlayerInfo(255,
                           RoleIndex,
                           cb_PrimaryWeapon.GetIndex(),
                           cb_SecondaryWeapon.GetIndex(),
                           SpawnPointIndex,
                           GetSelectedVehiclePoolIndex());
}

function SetButtonsEnabled(bool bEnable)
{
    bButtonsEnabled = bEnable;

    UpdateButtons();
}

function UpdateButtons()
{
    local bool bContinueEnabled;
    local int SquadIndex;
    local byte Team;

    if (PRI != none)
    {
        SquadIndex = PRI.SquadIndex;
    }
    else
    {
        SquadIndex = -1;
    }

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
        // that our pending parameters are valid.
        if (PC.ClientLevelInfo.SpawnMode == ESM_RedOrchestra ||
            (li_Vehicles.Index >= 0 && GRI.CanSpawnWithParameters(SpawnPointIndex,
                                                                 CurrentTeam,
                                                                 GRI.GetRoleIndexAndTeam(DHRoleInfo(li_Roles.GetObject()), Team),
                                                                 SquadIndex,
                                                                 GetSelectedVehiclePoolIndex())))
        {
            bContinueEnabled = true;
        }
    }
    else
    {
        b_Allies.DisableMe();
        b_Axis.DisableMe();
        b_Spectate.DisableMe();
    }

    if (LoadoutMode == LM_Equipment && li_Vehicles.GetObject() != none)
    {
        i_VehiclesButton.Image = material'DH_GUI_Tex.DeployMenu.vehicles_asterisk';
    }
    else
    {
        i_VehiclesButton.Image = material'DH_GUI_Tex.DeployMenu.vehicles';
    }

    if (bContinueEnabled)
    {
        b_MenuOptions[7].EnableMe();
        i_Arrows.Image = material'DH_GUI_Tex.DeployMenu.arrow_blurry';
    }
    else
    {
        b_MenuOptions[7].DisableMe();
        i_Arrows.Image = material'DH_GUI_Tex.DeployMenu.arrow_disabled';
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

    // Colin: PC.GetRoleInfo() can be invalid by the time it gets here. For
    // example, when switching teams, the client can (and likely will) get here
    // before PC.GetRoleInfo() is updated. Luckily, we can check the result of
    // SelectByObject and run the default behaviour (select an infinite role)
    // if it fails.
    if (PC.GetRoleInfo() != none &&
        li_Roles.SelectByObject(PC.GetRoleInfo()) != -1)
    {
        return;
    }

    if (CurrentTeam == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
        {
            if (GRI.DHAxisRoles[i] != none &&
                GRI.DHAxisRoleLimit[i] == 255)
            {
                li_Roles.SelectByObject(GRI.DHAxisRoles[i]);
            }
        }
    }
    else if (CurrentTeam == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.DHAlliesRoles); ++i)
        {
            if (GRI.DHAlliesRoles[i] != none &&
                GRI.DHAlliesRoleLimit[i] == 255)
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

// Automatically selects the players' currently selected vehicle to
// spawn. If no vehicle is selected to spawn, the "None" option will be
// selected, by default.
function AutoSelectVehicle()
{
    local int i;
    local UInteger Integer;

    if (PC.VehiclePoolIndex < 0)
    {
        return;
    }

    for (i = 0; i < li_Vehicles.Elements.Length; ++i)
    {
        Integer = UInteger(li_Vehicles.Elements[i].ExtraData);

        if (Integer != none && Integer.Value == PC.VehiclePoolIndex)
        {
            li_Vehicles.SetIndex(i);
        }
    }
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
                p_Map.SelectSpawnPoint(-1);
                break;

            //Allies
            case 98:
                OnTeamChanged(ALLIES_TEAM_INDEX);
                p_Map.SelectSpawnPoint(-1);
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

// Colin: This function centers the map inside of it's root container.
function bool MapContainerPreDraw(Canvas C)
{
    local float Offset;

    Offset = (c_MapRoot.ActualWidth() - c_MapRoot.ActualHeight()) / 2.0;
    Offset /= ActualWidth();

    c_Map.SetPosition(c_MapRoot.WinLeft + Offset,
                      c_MapRoot.WinTop,
                      c_MapRoot.ActualHeight(),
                      c_MapRoot.ActualHeight(),
                      true);

    c_Squads.SetPosition(c_MapRoot.WinLeft + Offset,
                      c_MapRoot.WinTop,
                      c_MapRoot.ActualHeight(),
                      c_MapRoot.ActualHeight(),
                      true);

    return true;
}

function InternalOnChange(GUIComponent Sender)
{
    local int i, j;
    local RORoleInfo RI;
    local class<Inventory> InventoryClass;
    local Material InventoryMaterial;

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
                cb_PrimaryWeapon.SetIndex(PC.DHPrimaryWeapon);
                cb_SecondaryWeapon.SetIndex(PC.DHSecondaryWeapon);
            }
            else
            {
                cb_PrimaryWeapon.SetIndex(0);
                cb_SecondaryWeapon.SetIndex(0);
            }

            j = 1;

            if (RI != none)
            {
                for (i = 0; i < arraycount(RI.Grenades); ++i)
                {
                    InventoryClass = RI.Grenades[i].Item;

                    if (InventoryClass != none && class<ROWeaponAttachment>(InventoryClass.default.AttachmentClass) != none)
                    {
                        InventoryMaterial = class<ROWeaponAttachment>(InventoryClass.default.AttachmentClass).default.MenuImage;

                        if (InventoryMaterial != none)
                        {
                            i_GivenItems[j++].Image = InventoryMaterial;
                        }
                    }
                }

                for (i = 0; i < RI.GivenItems.Length; ++i)
                {
                    if (RI.GivenItems[i] != "")
                    {
                        InventoryClass = class<Inventory>(DynamicLoadObject(RI.GivenItems[i], class'class'));

                        if (InventoryClass != none && class<ROWeaponAttachment>(InventoryClass.default.AttachmentClass) != none)
                        {
                            InventoryMaterial = class<ROWeaponAttachment>(InventoryClass.default.AttachmentClass).default.MenuImage;

                            if (InventoryMaterial != none)
                            {
                                if (InventoryMaterial.MaterialUSize() > InventoryMaterial.MaterialVSize())
                                {
                                    //Weapon material is wider than it is high.
                                    //This means it's probably a rocket or some
                                    //other long thing that needs to be put in our
                                    //"wide" slot (0).
                                    i_GivenItems[0].Image = InventoryMaterial;
                                }
                                else
                                {
                                    if (j < arraycount(i_GivenItems))
                                    {
                                        i_GivenItems[j++].Image = InventoryMaterial;
                                    }
                                }
                            }
                        }
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

            // Vehicle eligibility may have changed, update vehicles.
            UpdateVehicles();
            UpdateStatus();

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
            UpdateVehicleImage();
            UpdateSpawnPoints();
            UpdateStatus();

            break;

        default:
            break;
    }
}

function UpdateVehicleImage()
{
    local class<Vehicle> VehicleClass;
    local class<DHVehicle> DHVC;
    local int VehiclePoolIndex;

    VehiclePoolIndex = GetSelectedVehiclePoolIndex();

    if (VehiclePoolIndex >= 0)
    {
        VehicleClass = GRI.VehiclePoolVehicleClasses[VehiclePoolIndex];
        i_Vehicle.Image = VehicleClass.default.SpawnOverlay[0];

        if (GRI.VehiclePoolIsSpawnVehicles[VehiclePoolIndex] != 0)
        {
            i_SpawnVehicle.Show();
        }
        else
        {
            i_SpawnVehicle.Hide();
        }

        DHVC = class<DHVehicle>(VehicleClass);

        if (DHVC != none && DHVC.default.bIsArtilleryVehicle)
        {
            i_ArtilleryVehicle.Show();
        }
        else
        {
            i_ArtilleryVehicle.Hide();
        }
    }
    else
    {
        i_Vehicle.Image = default.VehicleNoneMaterial;
        i_SpawnVehicle.Hide();
        i_ArtilleryVehicle.Hide();
    }
}

function ChangeTeam(byte Team)
{
    // Confirm that we are actually changing teams
    if (Team != CurrentTeam)
    {
        SetButtonsEnabled(false);

        PC.ServerSetPlayerInfo(Team, 255, 0, 0, -1, -1);
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
    UpdateSquads();
}

function OnSpawnPointChanged(int SpawnPointIndex, optional bool bDoubleClick)
{
    self.SpawnPointIndex = SpawnPointIndex;

    UpdateStatus();
    UpdateButtons();

    if (bDoubleClick)
    {
        Apply();
    }
}

function bool InternalOnPreDraw(Canvas C)
{
    local float AttritionRate;

    if (GRI != none && PC != none)
    {
        AttritionRate = GRI.AttritionRate[CurrentTeam];

        if (AttritionRate > 0.0)
        {
            // TODO: convert to a material so we don't have to
            // make the alpha calculations ourself in script.
            i_Reinforcements.ImageColor.A = byte((Cos(2.0 * Pi * AttritionRate * PC.Level.TimeSeconds) * 128.0) + 128.0);
        }
        else
        {
            i_Reinforcements.ImageColor.A = 255;
        }
    }

    return super.OnPreDraw(C);
}

function ToggleMapMode()
{
    if (MapMode == MODE_Map)
    {
        SetMapMode(MODE_Squads);
    }
    else if (MapMode == MODE_Squads)
    {
        SetMapMode(MODE_Map);
    }
}

function SetMapMode(EMapMode Mode)
{
    MapMode = Mode;

    switch (MapMode)
    {
        case MODE_Map:
            b_MapButton.DisableMe();
            b_SquadsButton.EnableMe();
            c_Map.SetVisibility(true);
            c_Squads.SetVisibility(false);
            p_Squads.DisableMe();
            UpdateSpawnPoints();
            break;
        case MODE_Squads:
            b_MapButton.EnableMe();
            b_SquadsButton.DisableMe();
            c_Map.SetVisibility(false);
            c_Squads.SetVisibility(true);
            p_Squads.EnableMe();
            break;
        default:
            Warn("Unhandled map mode");
            break;
    }

    UpdateSquads();
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
    local Interactions.EInputKey K;
    local Interactions.EInputAction A;

    K = EInputKey(Key);
    A = EInputAction(State);

    if (K == IK_F1 && A == IST_Release)
    {
        ToggleMapMode();
        return true;
    }

    return super.OnKeyEvent(Key, State, Delta);
}

function UpdateSquads()
{
    local int i, j, k;
    local int TeamIndex;
    local bool bIsInSquad;
    local bool bIsInASquad;
    local bool bIsSquadLeader;
    local bool bIsSquadFull;
    local bool bIsSquadLocked;
    local bool bCanJoinSquad;
    local array<DHPlayerReplicationInfo> Members;
    local DHGUISquadComponent C;
    local DHPlayerReplicationInfo SavedPRI;

    super.Timer();

    // HACK: this GUI system is madness and requires me to do stupid things
    // like this in order for it to work.
    if (MapMode != MODE_Squads)
    {
        for (i = 0; i < p_Squads.SquadComponents.Length; ++i)
        {
            C = p_Squads.SquadComponents[i];
            SetVisible(C.lb_Members, false);
            SetVisible(C.li_Members, false);
            SetVisible(C.eb_SquadName, false);
            SetVisible(C.b_CreateSquad, false);
            SetVisible(C.b_JoinSquad, false);
            SetVisible(C.b_LeaveSquad, false);
            SetVisible(C.b_LockSquad, false);
            SetVisible(C.i_LockSquad, false);
        }

        return;
    }

    if (PC == none || PRI == none || SRI == none)
    {
        return;
    }

    TeamIndex = PC.GetTeamNum();

    if (TeamIndex != AXIS_TEAM_INDEX && TeamIndex != ALLIES_TEAM_INDEX)
    {
        return;
    }

    if (PRI == none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

        if (PRI == none)
        {
            return;
        }
    }

    bIsInASquad = PRI.IsInSquad();

    // Go through the active squads
    for (i = 0; i < SRI.GetTeamSquadLimit(TeamIndex); ++i)
    {
        if (!SRI.IsSquadActive(TeamIndex, i))
        {
            continue;
        }

        C = p_Squads.SquadComponents[j];

        SetVisible(C, true);

        bIsInSquad = SRI.IsInSquad(PRI, TeamIndex, i);
        bIsSquadFull = SRI.IsSquadFull(TeamIndex, i);
        bIsSquadLeader = SRI.IsSquadLeader(PRI, TeamIndex, i);
        bIsSquadLocked = SRI.IsSquadLocked(TeamIndex, i);

        SetVisible(C.lb_Members, true);
        SetVisible(C.li_Members, true);
        SetVisible(C.l_SquadName, !C.bIsEditingName);
        SetVisible(C.eb_SquadName, bIsSquadLeader);
        SetVisible(C.b_CreateSquad, false);
        SetVisible(C.b_JoinSquad, !bIsInSquad);
        SetVisible(C.b_LeaveSquad, bIsInSquad);
        SetVisible(C.b_LockSquad, bIsSquadLeader);
        SetVisible(C.i_LockSquad, bIsSquadLeader);

        if (bIsSquadLeader)
        {
            if (bIsSquadLocked)
            {
                C.i_LockSquad.Image = texture'DH_GUI_tex.DeployMenu.lock';
                C.b_LockSquad.SetHint(default.UnlockText);
            }
            else
            {
                C.i_LockSquad.Image = texture'DH_GUI_tex.DeployMenu.unlock';
                C.b_LockSquad.SetHint(default.LockText);
            }
        }

        if (!bIsInSquad)
        {
            bCanJoinSquad = !bIsInSquad && (!bIsSquadFull && !bIsSquadLocked);

            if (bCanJoinSquad)
            {
                C.b_JoinSquad.EnableMe();
            }
            else
            {
                C.b_JoinSquad.DisableMe();
            }
        }

        C.b_LockSquad.SetVisibility(bIsSquadLeader);

        C.l_SquadName.Caption = SRI.GetSquadName(TeamIndex, i);

        SRI.GetMembers(TeamIndex, i, Members);

        // Save the current PRI that is selected.
        SavedPRI = DHPlayerReplicationInfo(C.li_Members.GetObject());

        // Add or remove entries to match the member count.
        while (C.li_Members.ItemCount < Members.Length)
        {
            C.li_Members.Add("");
        }

        while (C.li_Members.ItemCount > Members.Length)
        {
            C.li_Members.Remove(0, 1);
        }

        // Update the text and associated object for each item.
        for (k = 0; k < Members.Length; ++k)
        {
            C.li_Members.SetItemAtIndex(k, Members[k].SquadMemberIndex + 1 $ "." @ Members[k].PlayerName);
            C.li_Members.SetObjectAtIndex(k, Members[k]);
        }

        // Re-select the previous selection.
        C.li_Members.SelectByObject(SavedPRI);

        ++j;
    }

    if (!bIsInASquad && j < p_Squads.SquadComponents.Length)
    {
        C = p_Squads.SquadComponents[j++];

        SetVisible(C.lb_Members, false);
        SetVisible(C.li_Members, false);
        SetVisible(C.l_SquadName, false);
        SetVisible(C.b_CreateSquad, true);
        SetVisible(C.b_JoinSquad, false);
        SetVisible(C.b_LeaveSquad, false);
        SetVisible(C.b_LockSquad, false);
        SetVisible(C.i_LockSquad, false);
        SetVisible(C.eb_SquadName, false);
    }

    while (j < p_Squads.SquadComponents.Length)
    {
        SetVisible(p_Squads.SquadComponents[j], false);

        ++j;
    }
}

function static SetVisible(GUIComponent C, bool bVisible)
{
    if (C != none)
    {
        C.SetVisibility(bVisible);

        if (bVisible)
        {
            C.EnableMe();
        }
        else
        {
            C.DisableMe();
        }
    }
}

defaultproperties
{
    SpawnPointIndex=-1

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

    Begin Object Class=GUILabel Name=AxisLabelObject
        WinHeight=1.0
        WinWidth=0.35
        WinTop=0.0
        WinLeft=0.05
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_Axis=AxisLabelObject

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

    Begin Object Class=GUILabel Name=AlliesLabelObject
        WinHeight=1.0
        WinWidth=0.35
        WinTop=0.0
        WinLeft=0.45
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_Allies=AlliesLabelObject

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
        WinLeft=0.85
        Image=material'DH_GUI_tex.DeployMenu.spectate'
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
    End Object
    i_Spectate=SpectateImageObject

    Begin Object Class=GUIImage Name=ReinforcementsImageObject
        WinWidth=0.035
        WinHeight=0.04
        WinLeft=0.02
        WinTop=0.075
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.reinforcements'
    End Object
    i_Reinforcements=ReinforcementsImageObject

    Begin Object class=GUILabel Name=ReinforcementsLabelObject
        TextAlign=TXTA_Left
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.08
        WinHeight=0.05
        WinLeft=0.0575
        WinTop=0.07
        TextFont="DHMenuFont"
    End Object
    l_Reinforcements=ReinforcementsLabelObject

    Begin Object Class=GUIImage Name=SizeAdvantageImageObject
        WinWidth=0.03
        WinHeight=0.035
        WinLeft=0.09
        WinTop=0.075
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.ForceScale'
    End Object
    i_SizeAdvantage=SizeAdvantageImageObject

    Begin Object class=GUILabel Name=SizeAdvantageLabelObject
        TextAlign=TXTA_Left
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.08
        WinHeight=0.05
        WinLeft=0.12
        WinTop=0.07
        TextFont="DHMenuFont"
    End Object
    l_SizeAdvantage=SizeAdvantageLabelObject

    Begin Object Class=GUIImage Name=RoundTimeImageObject
        WinWidth=0.035
        WinHeight=0.04
        WinLeft=0.17
        WinTop=0.075
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.StopWatch'
    End Object
    i_RoundTime=RoundTimeImageObject

    Begin Object class=GUILabel Name=RoundTimeLabelObject
        TextAlign=TXTA_Left
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.08
        WinHeight=0.05
        WinLeft=0.2
        WinTop=0.07
        Hint="Time Remaining"
        TextFont="DHMenuFont"
    End Object
    l_RoundTime=RoundTimeLabelObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=RolesContainerObject
        WinWidth=0.26
        WinHeight=0.22
        WinLeft=0.02
        WinTop=0.18
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

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapSquadsTabContainerObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.13
    End Object
    MapSquadsTabContainer=MapSquadsTabContainerObject

    Begin Object Class=GUIButton Name=EquipmentButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.0
        OnClick=OnClick
        Hint="Equipment"
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
        Hint="Vehicles"
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

    Begin Object Class=GUIButton Name=MapButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.0
        OnClick=OnClick
        Hint="Map [F1]"
    End Object
    b_MapButton=MapButtonObject

    Begin Object Class=GUIImage Name=MapButtonImageObject
        WinWidth=0.5
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.compass'
    End Object
    i_MapButton=MapButtonImageObject

    Begin Object Class=GUIButton Name=SquadsButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.5
        OnClick=OnClick
        Hint="Squads [F1]"
    End Object
    b_SquadsButton=SquadsButtonObject

    Begin Object Class=GUIImage Name=SquadsButtonImageObject
        WinWidth=0.5
        WinHeight=1.0
        WinLeft=0.5
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=texture'DH_GUI_Tex.DeployMenu.squads'
    End Object
    i_SquadsButton=SquadsButtonImageObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=LoadoutContainerObject
        WinWidth=0.26
        WinHeight=0.43
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

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapRootContainerObject
        WinWidth=0.68
        WinHeight=0.91
        WinLeft=0.3
        WinTop=0.02
        OnPreDraw=MapContainerPreDraw
    End Object
    c_MapRoot=MapRootContainerObject

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
    Begin Object Class=DHGUIButton Name=ContinueButtonObject
        Caption="Continue"
        CaptionAlign=TXTA_Center
        StyleName="DHDeployContinueButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(7)=ContinueButtonObject

    Begin Object Class=GUIImage Name=ArrowImageObject
        Image=material'DH_GUI_tex.DeployMenu.arrow_blurry'
        WinHeight=1.0
        WinLeft=0.875
        WinWidth=0.125
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_BottomLeft
    End Object
    i_Arrows=ArrowImageObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
    End Object
    c_Map=MapContainerObject

    Begin Object Class=GUIImage Name=MapBorderImageObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
        ImageStyle=ISTY_Scaled
        Image=material'DH_GUI_tex.DeployMenu.map_border'
    End Object
    i_MapBorder=MapBorderImageObject

    Begin Object Class=DHGUIMapComponent Name=MapComponentObject
        WinWidth=0.89
        WinHeight=0.89
        WinLeft=0.055
        WinTop=0.055
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
        WinWidth=0.333334
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
        WinWidth=0.666667
        WinHeight=0.333334
        WinLeft=0.333334
        WinTop=0.333334
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(0)=GivenItemImageObject0

    Begin Object Class=GUIImage Name=GivenItemImageObject1
        WinWidth=0.25
        WinHeight=0.333334
        WinLeft=0.0
        WinTop=0.666667
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(1)=GivenItemImageObject1

    Begin Object Class=GUIImage Name=GivenItemImageObject2
        WinWidth=0.25
        WinHeight=0.333334
        WinLeft=0.25
        WinTop=0.666667
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(2)=GivenItemImageObject2

    Begin Object Class=GUIImage Name=GivenItemImageObject3
        WinWidth=0.25
        WinHeight=0.333334
        WinLeft=0.5
        WinTop=0.666667
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(3)=GivenItemImageObject3

    Begin Object Class=GUIImage Name=GivenItemImageObject4
        WinWidth=0.25
        WinHeight=0.333334
        WinLeft=0.64
        WinTop=0.666667
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(4)=GivenItemImageObject4

    Begin Object Class=GUIImage Name=VehicleImageObject
        WinWidth=1.0
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_Vehicle=VehicleImageObject

    Begin Object Class=GUIGFXButton Name=SpawnVehicleImageObject
        WinWidth=0.25
        WinHeight=0.125
        WinLeft=0.75
        WinTop=0.0
        Position=ICP_Center
        Graphic=material'DH_GUI_Tex.DeployMenu.DeployEnabled'
        Hint="Spawn Vehicle"
        bVisible=false
        StyleName="TextLabel"
    End Object
    i_SpawnVehicle=SpawnVehicleImageObject

    Begin Object Class=GUIGFXButton Name=ArtilleryVehicleImageObject
        WinWidth=0.25
        WinHeight=0.125
        WinLeft=0.75
        WinTop=0.0
        Position=ICP_Center
        Graphic=material'DH_GUI_Tex.DeployMenu.artillery'
        bVisible=false
        Hint="Artillery Vehicle"
        StyleName="TextLabel"
    End Object
    i_ArtilleryVehicle=ArtilleryVehicleImageObject

    Begin Object Class=GUILabel Name=StatusLabelObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.88
        TextAlign=TXTA_Center
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_Status=StatusLabelObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=SquadsContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
    End Object
    c_Squads=SquadsContainerObject

    Begin Object Class=DHGUISquadsComponent Name=SquadsComponentObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
    End Object
    p_Squads=SquadsComponentObject

    NoneText="None"
    SelectRoleText="Select a role"
    SelectSpawnPointText="Select a spawn point"
    DeployInTimeText="Press Continue to deploy ({0})"
    DeployNowText="Press Continue to deploy now!"
    ChangeTeamConfirmText="Are you sure you want to change teams? (you will not be able to change back for {s} seconds)"
    FreeChangeTeamConfirmText="Are you sure you want to change teams?"
    CantChangeTeamYetText="You have {s} seconds before you can change teams"
    bButtonsEnabled=true
    VehicleNoneMaterial=material'DH_GUI_tex.DeployMenu.vehicle_none'
    OnPreDraw=InternalOnPreDraw
    ReservedString="Reserved"
    OnKeyEvent=InternalOnKeyEvent
    MapMode=MODE_Map
    LockText="Lock"
    UnlockText="Unlock"
    VehicleUnavailableString="The vehicle you had selected is no longer available."
}

