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
var automated   GUIGFXButton                    b_Axis;
var automated   GUIGFXButton                    b_Allies;
var automated   GUIGFXButton                    b_Spectate;
var automated   GUIImage                    i_Reinforcements;
var automated   GUILabel                    l_Reinforcements;
var automated   GUIImage                    i_RoundTime;
var automated   GUILabel                    l_RoundTime;
var automated   ROGUIProportionalContainer  c_Roles;
var automated   DHGUIListBox                    lb_Roles;
var             DHGUIList                       li_Roles;
var automated   ROGUIProportionalContainer  LoadoutTabContainer;
var automated   GUIGFXButton                    b_EquipmentButton;
var automated   GUIGFXButton                    b_VehicleButton;
var automated   GUILabel                    l_Loadout;
var automated   ROGUIProportionalContainer  c_Loadout;
var automated   ROGUIProportionalContainer        c_Equipment;
var automated   ROGUIProportionalContainer        c_Vehicle;
var automated   ROGUIProportionalContainer  c_Map;
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

var automated   array<DHGUIButton>          b_MenuOptions;

var automated   DHDeploymentMapMenu         MapComponent;

var DHGameReplicationInfo                   GRI;
var DHPlayer                                PC;

// Colin: The reason this variable is needed is because the PlayerController's
// GetTeamNum function is not reliable after recieving a successful team change
// signal from InternalOnMessage.
var byte                                    CurrentTeam;

var ELoadoutMode                            LoadoutMode;
var localized string                        NoneString;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super.InitComponent(MyController, MyOwner);

    PC = DHPlayer(PlayerOwner());

    if (PC == none)
    {
        return;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

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
    c_Teams.ManageComponent(b_Axis);
    c_Teams.ManageComponent(b_Spectate);

    c_Loadout.ManageComponent(c_Equipment);
    c_Loadout.ManageComponent(c_Vehicle);

    LoadoutTabContainer.ManageComponent(b_EquipmentButton);
    LoadoutTabContainer.ManageComponent(b_VehicleButton);

    c_Map.ManageComponent(MapComponent);

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
    LoadoutMode = Mode;

    // Colin: GUIComponent visiblity is not properly hierarchical, so we
    // need to hide and show elements indidivually.
    i_Vehicle.SetVisibility(Mode == LM_Vehicle);
    lb_Vehicles.SetVisibility(Mode == LM_Vehicle);

    i_PrimaryWeapon.SetVisibility(Mode == LM_Equipment);
    i_SecondaryWeapon.SetVisibility(Mode == LM_Equipment);

    cb_PrimaryWeapon.SetVisibility(Mode == LM_Equipment && cb_PrimaryWeapon.ItemCount() > 0);
    cb_SecondaryWeapon.SetVisibility(Mode == LM_Equipment && cb_SecondaryWeapon.ItemCount() > 0);

    //TODO: hide other shit

    UpdateMap();
}

function Timer()
{
    UpdateRoles();
    UpdateVehicles();
    UpdateStatus();
}

function UpdateStatus()
{
    local int RoundTime;

    //TODO: update team numbers on tabs

    l_Reinforcements.Caption = string(GRI.DHSpawnCount[CurrentTeam]);

    if (!GRI.bMatchHasBegun)
    {
        RoundTime = GRI.RoundStartTime + GRI.PreStartTime - GRI.ElapsedTime;
    }
    else
    {
        RoundTime = GRI.RoundStartTime + GRI.RoundDuration - GRI.ElapsedTime;
    }

    l_RoundTime.Caption = class'DHLib'.static.GetDurationString(Max(0, RoundTime), "m:ss");
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

    li_Vehicles.Insert(0, default.NoneString, none,, true);

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

function UpdateMap()
{
    MapComponent.Update();
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

        // Apply
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

    PC.ServerSetPlayerInfo(255,
                           RoleIndex,
                           cb_PrimaryWeapon.GetIndex(),
                           cb_SecondaryWeapon.GetIndex(),
                           MapComponent.SpawnPoint,
                           GRI.GetVehiclePoolIndex(class<Vehicle>(li_Vehicles.GetObject())),
                           MapComponent.SpawnVehicle,
                           0);
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
                return;

            //Axis
            case 97:
                //Axis
                OnTeamChanged(AXIS_TEAM_INDEX);
                return;

            //Allies
            case 98:
                OnTeamChanged(ALLIES_TEAM_INDEX);
                return;

            //Success
            case 0:
                CloseMenu();
                return;

            default:
                ErrorMessage = class'ROGUIRoleSelection'.static.GetErrorMessageForID(Result);
                break;
        }

        if (Controller != none)
        {
            Controller.OpenMenu(Controller.QuestionMenuClass);
            GUIQuestionPage(Controller.TopPage()).SetupQuestion(ErrorMessage, QBTN_Ok, QBTN_Ok);
        }
    }
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

    OnTeamChanged(PC.GetTeamNum());

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
    //TODO: have the entire map be drawn identically to the DHHud map
    local float Offset;

    Offset = (c_Map.ActualWidth() - c_Map.ActualHeight()) / 2.0;
    Offset /= ActualWidth();

    MapComponent.SetPosition(c_Map.WinLeft + Offset,
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
                i_GivenItems[j].Image = none;
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

            for (i = 0; i < RI.default.GivenItems.Length; ++i)
            {
                WeaponClass = class<Weapon>(DynamicLoadObject(RI.default.GivenItems[i], class'class'));

                if (WeaponClass != none)
                {
                    //TODO: do proper placement logic
                    i_GivenItems[j++].Image = class<ROWeaponAttachment>(WeaponClass.default.AttachmentClass).default.menuImage;
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
            i_PrimaryWeapon.Image = class<ROWeaponAttachment>(class<Inventory>(cb_PrimaryWeapon.GetObject()).default.AttachmentClass).default.MenuImage;
            break;

        case cb_SecondaryWeapon:
            i_SecondaryWeapon.Image = class<ROWeaponAttachment>(class<Inventory>(cb_SecondaryWeapon.GetObject()).default.AttachmentClass).default.MenuImage;
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

            break;

        default:
            break;
    }
}

function ChangeTeam(byte Team)
{
    if (Team != CurrentTeam)
    {
        PC.ServerSetPlayerInfo(Team, 255, 0, 0, 255, 255, 255, 255);
    }
}

function OnTeamChanged(byte Team)
{
    CurrentTeam = Team;

    PopulateRoles();
    PopulateVehicles();

    UpdateMap();
}

defaultproperties
{
    // GUI Components
    OnMessage=InternalOnMessage
    bRenderWorld=true
    bAllowedAsLast=true
    WinTop=0.0
    WinHeight=1.0

    Begin Object Class=FloatingImage Name=FloatingBackground
        Image=texture'DH_GUI_Tex.Menu.MultiMenuBack'
        DropShadow=none
        ImageStyle=ISTY_Scaled
        WinTop=0.0
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=1.0
    End Object
    i_Background=FloatingBackground

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=FooterContainerObject
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.95
    End Object
    c_Footer=FooterContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=TeamsContainerObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.02
    End Object
    c_Teams=TeamsContainerObject

    Begin Object Class=GUIGFXButton Name=AxisButtonObject
        Caption="Axis"
        WinWidth=0.333
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.0
        OnClick=OnClick
    End Object
    b_Axis=AxisButtonObject

    Begin Object Class=GUIGFXButton Name=AlliesButtonObject
        Caption="Allies"
        WinWidth=0.333
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.333334
        OnClick=OnClick
    End Object
    b_Allies=AlliesButtonObject

    Begin Object Class=GUIGFXButton Name=SpectateButtonObject
        Caption="Spectate"
        WinWidth=0.333
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.666667
        OnClick=OnClick
    End Object
    b_Spectate=SpectateButtonObject

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

    Begin Object Class=GUIGFXButton Name=EquipmentButtonObject
        Caption="Equipment"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.0
        OnClick=OnClick
    End Object
    b_EquipmentButton=EquipmentButtonObject

    Begin Object Class=GUIGFXButton Name=VehicleButtonObject
        Caption="Vehicle"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.5
        OnClick=OnClick
    End Object
    b_VehicleButton=VehicleButtonObject

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
        OnPreDraw = MapContainerPreDraw;
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

    //Apply Button
    Begin Object Class=DHGUIButton Name=ApplyButtonObject
        Caption="Apply"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(7)=ApplyButtonObject

    Begin Object Class=DHDeploymentMapMenu Name=MapComponentObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    MapComponent=MapComponentObject

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

    NoneString="None"
}
