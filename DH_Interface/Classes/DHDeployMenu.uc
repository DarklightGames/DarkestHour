//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
var automated   DHGUIMapContainer               c_Map;
var automated   ROGUIProportionalContainer      c_Squads;
var automated   DHGUISquadsComponent                p_Squads;
var automated   ROGUIProportionalContainer  c_Footer;
var automated   GUILabel                    l_Status;
var automated   GUIImage                        i_PrimaryWeapon;
var automated   GUIImage                        i_SecondaryWeapon;
var automated   GUIImage                        i_Vehicle;
var automated   GUIGFXButton                    i_SpawnVehicle;
var automated   GUIGFXButton                    i_ArtilleryVehicle;
var automated   GUIGFXButton                    i_SupplyVehicle;
var automated   GUIGFXButton                    i_MaxVehicles;
var automated   GUILabel                        l_MaxVehicles;
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

var localized   string                      NoneText,
                                            SelectRoleText,
                                            SelectSpawnPointText,
                                            DeployInTimeText,
                                            DeployNowText,
                                            ReservedString,
                                            ChangeTeamConfirmText,
                                            FreeChangeTeamConfirmText,
                                            CantChangeTeamYetText,
                                            LockText,
                                            UnlockText,
                                            VehicleUnavailableString,
                                            LockedText,
                                            BotsText,
                                            SquadOnlyText,
                                            SquadLeadershipOnlyText,
                                            RecommendJoiningSquadText,
                                            UnassignedPlayersCaptionText,
                                            NonSquadLeaderOnlyText
                                            ;

// NOTE: The reason this variable is needed is because the PlayerController's
// GetTeamNum function is not reliable after receiving a successful team change
// signal from InternalOnMessage.
var             byte                        CurrentTeam;

var             ELoadoutMode                LoadoutMode;

var             int                         SpawnPointIndex;
var             byte                        SpawnVehicleIndex;

var             bool                        bButtonsEnabled;

var             Material                    VehicleNoneMaterial;

var             EMapMode                    MapMode;

var Texture LockIcon;
var Texture UnlockIcon;

var localized string        SurrenderConfirmBaseText;
var localized string        SurrenderConfirmNominationText;
var localized string        SurrenderConfirmEndRoundText;
var localized string        SurrenderButtonText[2];
var localized array<string> SurrenderResponseMessages;
var int                     SurrenderButtonUnlockTime;
var int                     SurrenderButtonCooldownSeconds;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local class<DHNation> AxisNationClass, AlliedNationClass;

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

    // Team flags
    if (PC != none && PC.ClientLevelInfo != none)
    {
        AxisNationClass = PC.ClientLevelInfo.GetTeamNationClass(AXIS_TEAM_INDEX);
        AlliedNationClass = PC.ClientLevelInfo.GetTeamNationClass(ALLIES_TEAM_INDEX);

        i_Axis.Image = AxisNationClass.default.DeployMenuFlagTexture;
        i_Allies.Image = AlliedNationClass.default.DeployMenuFlagTexture;
    }

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
    c_Vehicle.ManageComponent(i_SupplyVehicle);
    c_Vehicle.ManageComponent(lb_Vehicles);
    c_Vehicle.ManageComponent(i_MaxVehicles);
    c_Vehicle.ManageComponent(l_MaxVehicles);

    c_Roles.ManageComponent(lb_Roles);

    if (PC != none)
    {
        SetMapMode(EMapMode(PC.DeployMenuStartMode));
    }
    else
    {
        SetMapMode(MODE_Map);
    }
}

function SetLoadoutMode(ELoadoutMode Mode)
{
    local int i;

    LoadoutMode = Mode;

    // GUIComponent visibility is not properly hierarchical, so we
    // need to hide and show elements individually.
    i_Vehicle.SetVisibility(Mode == LM_Vehicle);
    lb_Vehicles.SetVisibility(Mode == LM_Vehicle);

    i_PrimaryWeapon.SetVisibility(Mode == LM_Equipment);
    i_SecondaryWeapon.SetVisibility(Mode == LM_Equipment);

    cb_PrimaryWeapon.SetVisibility(Mode == LM_Equipment && cb_PrimaryWeapon.ItemCount() > 1);
    cb_SecondaryWeapon.SetVisibility(Mode == LM_Equipment && cb_SecondaryWeapon.ItemCount() > 1);

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
            i_SupplyVehicle.SetVisibility(false);
            i_MaxVehicles.SetVisibility(false);
            l_MaxVehicles.SetVisibility(false);
            break;

        case LM_Vehicle:
            b_EquipmentButton.EnableMe();
            b_VehicleButton.DisableMe();
            i_VehiclesButton.Image = Material'DH_GUI_Tex.DeployMenu.vehicles';
            UpdateVehicleImage();
            break;
    }

    UpdateSpawnPoints();
    UpdateButtons();
}

function Timer()
{
    // The GRI might not be set when we first open the menu if the player
    // opens it very quickly. This timer will sit and wait until the GRI is
    // confirmed to be present before populating any lists or running any
    // regular timer logic.
    local int TeamIndex;

    if (GRI == none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

        if (GRI != none)
        {
            // This bullshit is used by RO code to circumvent the
            // fact we can't send initialization parameters to the menu.
            // SHOCKING: we actually can, but they never used it!
            if (PC.ForcedTeamSelectOnRoleSelectPage != -5)
            {
                TeamIndex = PC.ForcedTeamSelectOnRoleSelectPage;
                PC.ForcedTeamSelectOnRoleSelectPage = -5;
            }
            else
            {
                TeamIndex = PC.GetTeamNum();
            }

            OnTeamChanged(TeamIndex);

            // Automatically select the player's spawn point.
            c_Map.p_Map.SelectSpawnPoint(PC.SpawnPointIndex);
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

        if (GRI.bIsInSetupPhase)
        {
            l_Reinforcements.Caption = "???";
            l_Reinforcements.TextColor = class'UColor'.default.White;
            i_Reinforcements.ImageColor = class'UColor'.default.White;
        }
        else if (GRI.SpawnsRemaining[CurrentTeam] == -1)
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

        if (GRI.DHRoundDuration == 0 && GRI.bMatchHasBegun)
        {
            l_RoundTime.Caption = class'DHHud'.default.NoTimeLimitText;
        }
        else
        {
            l_RoundTime.Caption = class'TimeSpan'.static.ToString(GRI.GetRoundTimeRemaining());
        }
    }
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
    local int RoleIndex;
    local byte TeamIndex;

    if (GRI != none)
    {
        RoleIndex = GRI.GetRoleIndexAndTeam(DHRoleInfo(li_Roles.GetObject()), TeamIndex);
    }
    else
    {
        RoleIndex = -1;
    }

    c_Map.p_Map.UpdateSpawnPoints(TeamIndex, RoleIndex, GetSelectedVehiclePoolIndex(), SpawnPointIndex);
}

function UpdateStatus()
{
    local int TeamSizes[2];
    local bool bSurrenderButtonEnabled;

    if (GRI == none || PC == none)
    {
        return;
    }

    GRI.GetTeamSizes(TeamSizes);

    l_Axis.Caption = string(TeamSizes[AXIS_TEAM_INDEX]);
    l_Allies.Caption = string(TeamSizes[ALLIES_TEAM_INDEX]);

    l_Status.Caption = GetStatusText();

    // Suicide
    SetEnabled(b_MenuOptions[1], PC.Pawn != none);

    // Surrender
    bSurrenderButtonEnabled = GRI.bIsSurrenderVoteEnabled;

    if (bSurrenderButtonEnabled)
    {
        b_MenuOptions[2].Caption = SurrenderButtonText[int(PC.bSurrendered)];

        if (!PC.bSurrendered && GRI.ElapsedTime < SurrenderButtonUnlockTime)
        {
            bSurrenderButtonEnabled = false;
            b_MenuOptions[2].Caption @= "(" $ class'TimeSpan'.static.ToString(SurrenderButtonUnlockTime - GRI.ElapsedTime) $ ")";
        }

        bSurrenderButtonEnabled = bSurrenderButtonEnabled &&
                                  (class'DH_LevelInfo'.static.DHDebugMode() || !GRI.bIsInSetupPhase) &&
                                  !GRI.IsSurrenderVoteInProgress(PC.GetTeamNum()) &&
                                  GRI.RoundWinnerTeamIndex > 1;
    }

    SetEnabled(b_MenuOptions[2], bSurrenderButtonEnabled);
}

function string GetStatusText()
{
    local DHRoleInfo RI;
    local int        SpawnTime;

    RI = DHRoleInfo(li_Roles.GetObject());

    if (RI == none)
    {
        return default.SelectRoleText;
    }

    if (SpawnPointIndex == -1)
    {
        return default.SelectSpawnPointText;
    }

    SpawnTime = Max(0, PC.GetNextSpawnTime(SpawnPointIndex, RI, GetSelectedVehiclePoolIndex()) - GRI.ElapsedTime);

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
    local class<ROVehicle> VehicleClass;
    local DHRoleInfo       RI;
    local GUIQuestionPage  ConfirmWindow;
    local bool             bDisabled;
    local float            RespawnTime;
    local int              i, j;
    local string           S;
    local DHGameReplicationInfo.EVehicleReservationError VRE;

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
        VRE = GRI.GetVehicleReservationError(PC, RI, CurrentTeam, j);

        // NOTE: Allow our user to select the vehicle if there's a way for us to
        // display the reason for the error (e.g. team hit the max active limit)
        bDisabled = PC.VehiclePoolIndex != j && (VRE != ERROR_None && VRE != ERROR_TeamMaxActive);

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
                ConfirmWindow = Controller.ShowQuestionDialog(default.VehicleUnavailableString, QBTN_OK, QBTN_OK);
                ConfirmWindow.OnButtonClick = none;
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
    local DHRoleInfo RI;
    local int        Count, BotCount, Limit, i;
    local string     S;
    local DHPlayer.ERoleEnabledResult RoleEnabledResult;

    for (i = 0; i < li_Roles.ItemCount; ++i)
    {
        RI = DHRoleInfo(li_Roles.GetObjectAtIndex(i));

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

        RoleEnabledResult = PC.GetRoleEnabledResult(RI);

        GRI.GetRoleCounts(RI, Count, BotCount, Limit);

        if (Limit == 0)
        {
            S @= "[" $ LockedText $ "]";
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
            S @= "*" $ BotsText $ "*";
        }

        switch (RoleEnabledResult)
        {
            case RER_SquadOnly:
                S @= "*" $ SquadOnlyText $ "*";
                break;
            case RER_SquadLeaderOnly:
                S @= "*" $ SquadLeadershipOnlyText $ "*";
                break;
            CASE RER_NonSquadLeaderOnly:
                S @= "*" $ NonSquadLeaderOnlyText $ "*";
                break;
        }
        
        li_Roles.SetItemAtIndex(i, S);
        li_Roles.SetDisabledAtIndex(i, RoleEnabledResult != RER_Enabled);
    }

    // If we end up having a newly disabled element selected, deselect it.
    if (li_Roles.IsIndexDisabled(li_Roles.Index))
    {
        li_Roles.SetIndex(-1);
    }
}

function bool OnClick(GUIComponent Sender)
{
    local GUIQuestionPage ConfirmWindow;
    local string          ConfirmMessage;

    PC = DHPlayer(PlayerOwner());

    switch (Sender)
    {
        // Disconnect
        case b_MenuOptions[0]:
            PC.ConsoleCommand("DISCONNECT");
            CloseMenu();
            break;

        // Suicide
        case b_MenuOptions[1]:
            PlayerOwner().ConsoleCommand("SUICIDE");
            break;

        // Surrender
        case b_MenuOptions[2]:
            if (PC != none)
            {
                PC.ServerTeamSurrenderRequest(true);
            }
            break;

        // Map vote
        case b_MenuOptions[3]:
            Controller.OpenMenu(Controller.MapVotingMenu);
            break;

        // Server browser
        case b_MenuOptions[4]:
            Controller.OpenMenu("DH_Interface.DHServerBrowser");
            break;

        // Settings
        case b_MenuOptions[5]:
            Controller.OpenMenu("DH_Interface.DHSettingsPage");
            break;

        // Continue button
        case b_MenuOptions[6]:
            if (PC != none &&
                !PC.bHasReceivedSquadJoinRecommendationMessage &&
                PC.SquadReplicationInfo != none &&
                PC.SquadReplicationInfo.bAreRallyPointsEnabled &&
                !PC.IsInSquad() &&
                PC.SquadReplicationInfo.IsAnySquadJoinable(PC.GetTeamNum()))
            {
                PC.bHasReceivedSquadJoinRecommendationMessage = true;
                ConfirmWindow = Controller.ShowQuestionDialog(default.RecommendJoiningSquadText, QBTN_YesNo, QBTN_Yes);
                ConfirmWindow.OnButtonClick = OnRecommendJoiningSquadButtonClick;
            }
            else
            {
                Apply();
            }
            break;

        // Weapons/equipment
        case b_EquipmentButton:
            SetLoadoutMode(LM_Equipment);
            break;

        // Vehicle
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

        // Changing team (most of this functionality is common, with only minor changes depending on team selected)
        case b_Axis:
        case b_Allies:
        case b_Spectate:
            if (!(Sender == b_Axis && CurrentTeam == AXIS_TEAM_INDEX) && !(Sender == b_Allies && CurrentTeam == ALLIES_TEAM_INDEX)) // make sure player is actually changing team
            {
                // Player is prevented from changing team as he switched recently
                if (PC.NextChangeTeamTime >= GRI.ElapsedTime)
                {
                    ConfirmMessage = Repl(default.CantChangeTeamYetText, "{s}", class'TimeSpan'.static.ToString(PC.NextChangeTeamTime - GRI.ElapsedTime));
                    Controller.ShowQuestionDialog(ConfirmMessage, QBTN_OK, QBTN_OK);
                }
                // Player can change team, but give him a screen prompt & ask him to confirm the change
                else
                {
                    // Player can switch freely in single player mode, or within the first ChangeTeamInterval seconds of the round
                    // So this is just a simple confirmation prompt, without any warning
                    if (PlayerOwner().Level.NetMode == NM_Standalone || GRI.ElapsedTime <= class'DarkestHourGame'.default.ChangeTeamInterval)
                    {
                        ConfirmMessage = FreeChangeTeamConfirmText;
                    }
                    // Otherwise warn the player that if he changes team, he'll have to wait a certain time before being allowed to switch again
                    else
                    {
                        ConfirmMessage = Repl(default.ChangeTeamConfirmText, "{s}", class'DarkestHourGame'.default.ChangeTeamInterval);
                    }

                    ConfirmWindow = Controller.ShowQuestionDialog(ConfirmMessage, QBTN_YesNo);

                    // Set the function to call when the player presses 'yes' or 'no'
                    if (Sender == b_Axis)
                    {
                        ConfirmWindow.NewOnButtonClick = ChangeToAxisChoice;
                    }
                    else if (Sender == b_Allies)
                    {
                        ConfirmWindow.NewOnButtonClick = ChangeToAlliesChoice;
                    }
                    else if (Sender == b_Spectate)
                    {
                        ConfirmWindow.bAllowedAsLast = true; // when the confirmation window gets closed, this stops it from defaulting to opening the main menu
                        ConfirmWindow.NewOnButtonClick = ChangeToSpectateChoice;
                    }
                }
            }

            break;

        default:
            break;
    }

    return false;
}

function OnSurrenderConfirmButtonClick(byte Button)
{
    if (Button == QBTN_YES && PC != none && GRI != none)
    {
        PC.ServerTeamSurrenderRequest();
        SurrenderButtonUnlockTime = GRI.ElapsedTime + SurrenderButtonCooldownSeconds;
    }
}

function OnRecommendJoiningSquadButtonClick(byte Button)
{
    switch (Button)
    {
        case QBTN_YES:
            if (PC != none && PC.SquadReplicationInfo != none && PC.SquadReplicationInfo.IsAnySquadJoinable(PC.GetTeamnum()))
            {
                // Automatically join a squad, deselect the current spawn point.
                // Ideally, this will show the user their new spawning options
                // if the squad has it's act together.
                PC.ServerSquadJoinAuto();
                c_Map.p_Map.SelectSpawnPoint(-1);
                SetMapMode(MODE_Map);
            }
            else
            {
                // No squads are joinable, just take them to the squad menu (rare case)
                SetMapMode(MODE_Squads);
            }
            break;
        case QBTN_NO:
            Apply();
            break;
        default:
            break;
    }
}

function bool ChangeToAxisChoice(byte Button)
{
    if (Button == 16) // player has clicked 'yes' to confirm change
    {
        ChangeTeam(AXIS_TEAM_INDEX);
    }

    return true;
}

function bool ChangeToAlliesChoice(byte Button)
{
    if (Button == 16) // player has clicked 'yes' to confirm change
    {
        ChangeTeam(ALLIES_TEAM_INDEX);
    }

    return true;
}

function bool ChangeToSpectateChoice(byte Button)
{
    if (Button == 16) // player has clicked 'yes' to confirm change
    {
        ChangeTeam(254); // to spectator
    }

    return true;
}

function Apply()
{
    local RORoleInfo RI;
    local int        RoleIndex;

    if (b_MenuOptions[6].MenuState == MSAT_Disabled)
    {
        return;
    }

    RI = RORoleInfo(li_Roles.GetObject());

    if (RI == none)
    {
        return;
    }

    RoleIndex = GRI.GetRoleIndexAndTeam(RI);

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
                           int(cb_PrimaryWeapon.GetExtra()),
                           int(cb_SecondaryWeapon.GetExtra()),
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
    local int  SquadIndex;
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

        // Continue button should always be clickable if we're using the old
        // spawning system. If we're using the new spawning system, we have to
        // check that our pending parameters are valid.
        if (PC.ClientLevelInfo.SpawnMode == ESM_RedOrchestra ||
            (li_Vehicles.Index >= 0 && GRI.CanSpawnWithParameters(SpawnPointIndex,
                                                                 CurrentTeam,
                                                                 GRI.GetRoleIndexAndTeam(DHRoleInfo(li_Roles.GetObject()), Team),
                                                                 SquadIndex,
                                                                 GetSelectedVehiclePoolIndex(),
                                                                 true)))
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
        i_VehiclesButton.Image = Material'DH_GUI_Tex.DeployMenu.vehicles_asterisk';
    }
    else
    {
        i_VehiclesButton.Image = Material'DH_GUI_Tex.DeployMenu.vehicles';
    }

    if (bContinueEnabled)
    {
        b_MenuOptions[6].EnableMe();
        i_Arrows.Image = Material'DH_GUI_Tex.DeployMenu.arrow_blurry';
    }
    else
    {
        b_MenuOptions[6].DisableMe();
        i_Arrows.Image = Material'DH_GUI_Tex.DeployMenu.arrow_disabled';
    }
}

function PopulateRoles()
{
    local string RoleName;
    local int    i;

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

// Automatically selects a role from the roles list. If the player is
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
    local UInteger Integer;
    local int      i;

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
    local string MessageText;
    local GUIQuestionPage ConfirmWindow;
    local int TeamSizes[2];
    local byte TeamIndex;

    Result = int(MsgLife);

    if (Msg ~= "NOTIFY_GUI_ROLE_SELECTION_PAGE")
    {
        switch (Result)
        {
            // Spectator
            case 96:
                CloseMenu();
                break;

            // Axis
            case 97:
                OnTeamChanged(AXIS_TEAM_INDEX);
                c_Map.p_Map.SelectSpawnPoint(-1);
                break;

            // Allies
            case 98:
                OnTeamChanged(ALLIES_TEAM_INDEX);
                c_Map.p_Map.SelectSpawnPoint(-1);
                break;

            // Success
            case 0:
                CloseMenu();
                break;

            default:
                MessageText = class'ROGUIRoleSelection'.static.GetErrorMessageForID(Result);
                Controller.ShowQuestionDialog(MessageText, QBTN_OK, QBTN_OK);
                break;
        }
    }
    else if (Msg ~= "NOTIFY_GUI_SURRENDER_RESULT")
    {
        if (Result == -1)
        {
            // Player can surrender; show the confirmation prompt

            if (PC != none && GRI != none)
            {
                GRI.GetTeamSizes(TeamSizes);
                TeamIndex = PC.GetTeamNum();

                MessageText = default.SurrenderConfirmBaseText;

                if (TeamIndex < arraycount(TeamSizes) && TeamSizes[TeamIndex] == 1)
                {
                    // The round will end immediately
                    MessageText @= default.SurrenderConfirmEndRoundText;
                }
                else
                {
                    // The vote will be nominated
                    MessageText @= Repl(default.SurrenderConfirmNominationText, "{0}", int(class'DHVoteInfo_TeamSurrender'.static.GetNominationsThresholdPercent() * 100));
                }

                ConfirmWindow = Controller.ShowQuestionDialog(MessageText, QBTN_YesNo, QBTN_Yes);
                ConfirmWindow.OnButtonClick = OnSurrenderConfirmButtonClick;
            }
        }
        else if (Result >= 0 && Result < SurrenderResponseMessages.Length)
        {
            // The request was denied by the server
            MessageText = SurrenderResponseMessages[Result];
            Controller.ShowQuestionDialog(MessageText, QBTN_OK, QBTN_OK);
        }
        else
        {
            Warn("Received invalid result code");
        }
    }
    else if (Msg ~= "SQUAD_MERGE_REQUEST_RESULT")
    {
        MessageText = class'DHSquadReplicationInfo'.static.GetSquadMergeRequestResultString(Result);
        Controller.ShowQuestionDialog(MessageText, QBTN_OK, QBTN_OK);
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
    local class<Inventory> InventoryClass;
    local RORoleInfo       RI;
    local material         InventoryMaterial;
    local int              i, j;

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
                    if (RI.PrimaryWeapons[i].Item != none && cb_PrimaryWeapon.FindIndex(RI.PrimaryWeapons[i].Item.default.ItemName) == -1)
                    {
                        cb_PrimaryWeapon.AddItem(RI.PrimaryWeapons[i].Item.default.ItemName, RI.PrimaryWeapons[i].Item, string(i));
                    }
                }

                for (i = 0; i < arraycount(RI.SecondaryWeapons); ++i)
                {
                    if (RI.SecondaryWeapons[i].Item != none && cb_SecondaryWeapon.FindIndex(RI.SecondaryWeapons[i].Item.default.ItemName) == -1)
                    {
                        cb_SecondaryWeapon.AddItem(RI.SecondaryWeapons[i].Item.default.ItemName, RI.SecondaryWeapons[i].Item, string(i));
                    }
                }
            }

            cb_PrimaryWeapon.SetIndex(0);
            cb_SecondaryWeapon.SetIndex(0);

            if (PC.GetRoleInfo() == RI && RI != none)
            {
                if (PC.DHPrimaryWeapon >= 0)
                {
                    cb_PrimaryWeapon.SetIndex(class'xGUIList'.static.GetIndexOfObject(cb_PrimaryWeapon.MyComboBox.List, RI.PrimaryWeapons[PC.DHPrimaryWeapon].Item));
                }

                if (PC.DHSecondaryWeapon >= 0)
                {
                    cb_SecondaryWeapon.SetIndex(class'xGUIList'.static.GetIndexOfObject(cb_SecondaryWeapon.MyComboBox.List, RI.SecondaryWeapons[PC.DHSecondaryWeapon].Item));
                }
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
    local class<Vehicle>   VehicleClass;
    local class<DHVehicle> DHVC;
    local int              VehiclePoolIndex;

    VehiclePoolIndex = GetSelectedVehiclePoolIndex();

    if (LoadoutMode == LM_Vehicle && VehiclePoolIndex >= 0)
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

        if (DHVC != none && DHVC.default.SupplyAttachmentClass != none)
        {
            i_SupplyVehicle.Show();
        }
        else
        {
            i_SupplyVehicle.Hide();
        }

        if (GRI.IgnoresMaxTeamVehiclesFlags(VehiclePoolIndex))
        {
            i_MaxVehicles.Hide();
            l_MaxVehicles.Hide();
        }
        else
        {
            i_MaxVehicles.Show();
            l_MaxVehicles.Show();
            l_MaxVehicles.Caption = string(Max(0, GRI.GetReservableTankCount(CurrentTeam)));

            if (GRI.GetReservableTankCount(CurrentTeam) <= 0)
            {
                l_MaxVehicles.TextColor = class'UColor'.default.Red;
            }
            else
            {
                l_MaxVehicles.TextColor = class'UColor'.default.White;
            }
        }
    }
    else
    {
        i_Vehicle.Image = default.VehicleNoneMaterial;
        i_SpawnVehicle.Hide();
        i_ArtilleryVehicle.Hide();
        i_SupplyVehicle.Hide();
        i_MaxVehicles.Hide();
        l_MaxVehicles.Hide();
    }
}

function ChangeTeam(int TeamIndex)
{
    if (TeamIndex != CurrentTeam) // confirm that we are actually changing teams
    {
        SetButtonsEnabled(false);
        PC.ServerSetPlayerInfo(TeamIndex, 255, 0, 0, -1, -1);
    }
}

function OnTeamChanged(int TeamIndex)
{
    CurrentTeam = TeamIndex;

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

        if (!GRI.bIsInSetupPhase && AttritionRate > 0.0)
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
    local Interactions.EInputKey    K;
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
    local array<DHPlayerReplicationInfo> Members;
    local DHPlayerReplicationInfo        SavedPRI;
    local DHGUISquadComponent            C;
    local int TeamIndex, SquadLimit, i, j, k;
    local bool bIsInSquad, bIsInASquad, bIsSquadLeader, bIsSquadFull, bIsSquadLocked, bCanJoinSquad, bCanSquadBeLocked;

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
    SquadLimit = SRI.GetTeamSquadLimit(TeamIndex);

    // Go through the active squads
    for (i = 0; i < SquadLimit && j < p_Squads.SquadComponents.Length; ++i)
    {
        if (!SRI.IsSquadActive(TeamIndex, i))
        {
            continue;
        }

        C = p_Squads.SquadComponents[j];
        C.SquadIndex = i;

        SetVisible(C, true);

        bIsInSquad = SRI.IsInSquad(PRI, TeamIndex, i);
        bIsSquadFull = SRI.IsSquadFull(TeamIndex, i);
        bIsSquadLeader = SRI.IsSquadLeader(PRI, TeamIndex, i);
        bIsSquadLocked = SRI.IsSquadLocked(TeamIndex, i);
        bCanSquadBeLocked = SRI.CanSquadBeLocked(TeamIndex, i);

        SetVisible(C.lb_Members, true);
        SetVisible(C.li_Members, true);
        SetVisible(C.l_SquadName, !C.bIsEditingName);
        SetVisible(C.eb_SquadName, bIsSquadLeader);
        SetVisible(C.b_CreateSquad, false);
        SetVisible(C.b_JoinSquad, !bIsInSquad);
        SetVisible(C.b_LeaveSquad, bIsInSquad);
        SetVisible(C.b_LockSquad, bIsSquadLeader);
        SetVisible(C.i_LockSquad, bIsSquadLocked || bIsSquadLeader);

        if (bIsSquadLeader)
        {
            if (bIsSquadLocked)
            {
                C.i_LockSquad.Image = LockIcon;
                C.b_LockSquad.SetHint(default.UnlockText);
            }
            else
            {
                C.i_LockSquad.Image = UnlockIcon;

                if (bCanSquadBeLocked)
                {
                    C.i_LockSquad.ImageColor.A = 255;
                    C.b_LockSquad.SetHint(default.LockText);
                }
                else
                {
                    C.i_LockSquad.ImageColor.A = 64;
                    C.b_LockSquad.SetHint("Squad can be locked only if it has " $ SRI.SquadLockMemberCountMin $ " or more members");
                }
            }
        }
        else
        {
            if (bIsSquadLocked)
            {
                C.i_LockSquad.Image = LockIcon;
                C.i_LockSquad.ImageColor.A = 128;
            }
        }

        bCanJoinSquad = !bIsInASquad && SRI.IsSquadJoinable(TeamIndex, i);

        if (bCanJoinSquad)
        {
            C.b_JoinSquad.EnableMe();
        }
        else
        {
            C.b_JoinSquad.DisableMe();
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
            C.li_Members.SetItemAtIndex(k, Members[k].GetNamePrefix() $ "." @ Members[k].PlayerName);
            C.li_Members.SetObjectAtIndex(k, Members[k]);
        }

        // Re-select the previous selection.
        C.li_Members.SelectByObject(SavedPRI);

        ++j;
    }

    if (!bIsInASquad && j < SquadLimit && j < p_Squads.SquadComponents.Length)
    {
        C = p_Squads.SquadComponents[j++];

        SetVisible(C, true);
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

    while (j < p_Squads.SquadComponents.Length - 1)
    {
        SetVisible(p_Squads.SquadComponents[j], false);
        ++j;
    }

    // Show the unassigned category
    SRI.GetUnassignedPlayers(TeamIndex, Members);

    if (j >= p_Squads.SquadComponents.Length)
    {
        return;
    }

    if (Members.Length > 0)
    {
        C = p_Squads.SquadComponents[j];
        C.l_SquadName.Caption = default.UnassignedPlayersCaptionText;
        C.SquadIndex = -1;

        SetVisible(C, true);
        SetVisible(C.lb_Members, true);
        SetVisible(C.li_Members, true);
        SetVisible(C.l_SquadName, true);
        SetVisible(C.eb_SquadName, false);
        SetVisible(C.b_CreateSquad, false);
        SetVisible(C.b_JoinSquad, false);
        SetVisible(C.b_LeaveSquad, false);
        SetVisible(C.b_LockSquad, false);
        SetVisible(C.i_LockSquad, false);

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
            C.li_Members.SetItemAtIndex(k, Members[k].PlayerName);
            C.li_Members.SetObjectAtIndex(k, Members[k]);
        }

        // Re-select the previous selection.
        C.li_Members.SelectByObject(SavedPRI);
    }
    else
    {
        SetVisible(p_Squads.SquadComponents[j], false);
    }
}

static function SetEnabled(GUIComponent C, bool bEnabled)
{
    if (C != none)
    {
        if (bEnabled)
        {
            C.EnableMe();
        }
        else
        {
            C.DisableMe();
        }
    }
}

static function SetVisible(GUIComponent C, bool bVisible)
{
    if (C != none)
    {
        C.SetVisibility(bVisible);
        SetEnabled(C, bVisible);
    }
}

defaultproperties
{
    SelectRoleText="Select a role"
    SelectSpawnPointText="Select a spawn point"
    DeployInTimeText="Press Continue to deploy ({0})"
    DeployNowText="Press Continue to deploy now!"
    ChangeTeamConfirmText="Are you sure you want to change teams? (you will not be able to change back for {s} seconds)"
    FreeChangeTeamConfirmText="Are you sure you want to change teams?"
    CantChangeTeamYetText="You must wait {s} before you can change teams"
    ReservedString="Reserved"
    VehicleUnavailableString="The vehicle you had selected is no longer available."
    LockText="Lock"
    UnlockText="Unlock"
    NoneText="None"
    LockedText="Locked"
    BotsText="BOTS"
    SquadOnlyText="SQUADS ONLY"
    SquadLeadershipOnlyText="LEADERS ONLY"
    NonSquadLeaderOnlyText="NON-LEADERS ONLY"
    RecommendJoiningSquadText="It it HIGHLY RECOMMENDED that you JOIN A SQUAD before deploying! Joining a squad grants you additional deployment options and lets you get to the fight faster.||Do you want to automatically join a squad now?"
    UnassignedPlayersCaptionText="Unassigned"

    SurrenderButtonCooldownSeconds=30
    SurrenderConfirmBaseText="Are you sure you want to surrender?"
    SurrenderConfirmNominationText="This action will nominate the team wide vote. The vote will begin after {0}% of the team has opted to retreat."
    SurrenderConfirmEndRoundText="This will immediately end the round in favor of the opposite team."

    SurrenderButtonText[0]="Retreat"
    SurrenderButtonText[1]="Keep fighting"

    SurrenderResponseMessages[0]="Fatal error!"
    SurrenderResponseMessages[1]="You haven't picked a team."
    SurrenderResponseMessages[2]="Round hasn't started yet."
    SurrenderResponseMessages[3]="Retreat vote is disabled."
    SurrenderResponseMessages[4]="Vote is already in progress."
    SurrenderResponseMessages[5]="You've already retreated."
    SurrenderResponseMessages[6]="Your team already had a vote to retreat earlier. Try again later."
    SurrenderResponseMessages[7]="You cannot retreat after the round is over."
    // SurrenderResponseMessages[8]="Your team has too many reinforcements to surrender."
    SurrenderResponseMessages[9]="You cannot retreat this early."
    SurrenderResponseMessages[10]="You cannot retreat during the setup phase."

    MapMode=MODE_Map
    bButtonsEnabled=true
    SpawnPointIndex=-1
    VehicleNoneMaterial=Material'DH_GUI_tex.DeployMenu.vehicle_none'

    OnMessage=InternalOnMessage
    OnPreDraw=InternalOnPreDraw
    OnKeyEvent=InternalOnKeyEvent
    bRenderWorld=false
    bAllowedAsLast=true
    WinTop=0.0
    WinHeight=1.0

    Begin Object Class=FloatingImage Name=FloatingBackground
        Image=Texture'DH_GUI_Tex.DeployMenu.Background'
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
        Image=Material'DH_GUI_tex.DeployMenu.flag_germany'
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
        Image=Material'DH_GUI_tex.DeployMenu.flag_usa'
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
        Image=Material'DH_GUI_tex.DeployMenu.spectate'
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
        Image=Texture'DH_GUI_Tex.DeployMenu.reinforcements'
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
        Image=Texture'DH_GUI_Tex.DeployMenu.ForceScale'
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
        Image=Texture'DH_GUI_Tex.DeployMenu.StopWatch'
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
        Image=Texture'DH_GUI_Tex.DeployMenu.equipment'
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
        Image=Texture'DH_GUI_Tex.DeployMenu.vehicles'
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
        Image=Texture'DH_GUI_Tex.DeployMenu.compass'
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
        Image=Texture'DH_GUI_Tex.DeployMenu.squads'
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

    Begin Object Class=DHGUIButton Name=DisconnectButtonObject
        Caption="Disconnect"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(0)=DisconnectButtonObject

    Begin Object Class=DHGUIButton Name=SuicideButtonObject
        Caption="Suicide"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(1)=SuicideButtonObject

    Begin Object Class=DHGUIButton Name=RetreatButtonObject
        Caption="Retreat"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(2)=RetreatButtonObject

    Begin Object Class=DHGUIButton Name=MapVoteButtonObject
        Caption="Map Vote"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(3)=MapVoteButtonObject

    Begin Object Class=DHGUIButton Name=ServersButtonObject
        Caption="Servers"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(4)=ServersButtonObject

    Begin Object Class=DHGUIButton Name=SettingsButtonObject
        Caption="Settings"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(5)=SettingsButtonObject

    Begin Object Class=DHGUIButton Name=ContinueButtonObject
        Caption="Continue"
        CaptionAlign=TXTA_Center
        StyleName="DHDeployContinueButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(6)=ContinueButtonObject

    Begin Object Class=GUIImage Name=ArrowImageObject
        Image=Material'DH_GUI_tex.DeployMenu.arrow_blurry'
        WinHeight=1.0
        WinLeft=0.875
        WinWidth=0.125
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_BottomLeft
    End Object
    i_Arrows=ArrowImageObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapRootContainerObject
        WinWidth=0.68
        WinHeight=0.91
        WinLeft=0.3
        WinTop=0.02
        OnPreDraw=MapContainerPreDraw
    End Object
    c_MapRoot=MapRootContainerObject

    Begin Object Class=DHGUIMapContainer Name=MapContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        OnSpawnPointChanged=OnSpawnPointChanged
    End Object
    c_Map=MapContainerObject

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
        Graphic=Material'DH_GUI_Tex.DeployMenu.DeployEnabled'
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
        Graphic=Material'DH_GUI_Tex.DeployMenu.artillery'
        bVisible=false
        Hint="Artillery Vehicle"
        StyleName="TextLabel"
    End Object
    i_ArtilleryVehicle=ArtilleryVehicleImageObject

    Begin Object Class=GUIGFXButton Name=MaxVehiclesImageObject
        WinWidth=0.125
        WinHeight=0.125
        WinLeft=0.0
        WinTop=0.0
        Position=ICP_Center
        Graphic=Material'DH_InterfaceArt2_tex.Icons.tank'
        bVisible=false
        Hint="Tanks Available"
        StyleName="TextLabel"
    End Object
    i_MaxVehicles=MaxVehiclesImageObject

    Begin Object Class=GUILabel Name=MaxVehiclesLabelObject
        WinHeight=0.125
        WinWidth=0.125
        WinTop=0.0
        WinLeft=0.125
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_MaxVehicles=MaxVehiclesLabelObject

    Begin Object Class=GUIGFXButton Name=SupplyVehicleImageObject
        WinWidth=0.25
        WinHeight=0.125
        WinLeft=0.5
        WinTop=0.0
        Position=ICP_Center
        Graphic=Material'DH_InterfaceArt2_tex.Icons.supply_cache'
        bVisible=false
        Hint="Construction Supply Vehicle"
        StyleName="TextLabel"
    End Object
    i_SupplyVehicle=SupplyVehicleImageObject

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

    LockIcon=Texture'DH_InterfaceArt2_tex.Icons.lock'
    UnlockIcon=Texture'DH_InterfaceArt2_tex.Icons.unlock'
}
