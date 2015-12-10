//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHHud extends ROHud;

#exec OBJ LOAD FILE=..\Textures\DH_GUI_Tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_Weapon_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx

const MAX_OBJ_ON_SIT = 12; // the maximum objectives that can be listed down the side on the situational map (not on the map itself)

const VOICE_ICON_DIST_MAX = 2624.672119;    // maximum distance from a talking player at which we will show a voice icon

var Pawn                LastTalkingPawn;    // records last pawn for which we showed a voice icon, so we don't need to keep finding it

var DHGameReplicationInfo   DHGRI;

var int                 AlliedNationID;     // US = 0, Britain = 1, Canada = 2

var SpriteWidget        VehicleAltAmmoReloadIcon; // ammo reload icon for a coax MG, so reload progress can be shown on HUD like a tank cannon reload
var SpriteWidget        VehicleMGAmmoReloadIcon;  // ammo reload icon for a vehicle mounted MG position
var SpriteWidget        MapIconCarriedRadio;
var SpriteWidget        CanMantleIcon;
var SpriteWidget        CanCutWireIcon;
var SpriteWidget        VoiceIcon;
var SpriteWidget        MapIconMortarHETarget;
var SpriteWidget        MapIconMortarSmokeTarget;
var SpriteWidget        MapIconMortarArrow;
var SpriteWidget        MapIconMortarHit;
var SpriteWidget        MapLevelOverlay;
var TextWidget          MapScaleText;
var SpriteWidget        DeployOkayIcon;
var SpriteWidget        DeployEnemiesNearbyIcon;
var SpriteWidget        DeployInObjectiveIcon;

var SpriteWidget        MapAxisFlagIcon;
var SpriteWidget        MapAlliesFlagIcons[3];

var localized string    LegendCarriedArtilleryRadioText;

var localized string    NoTimeLimitText;
var localized string    NeedReloadText;
var localized string    CanReloadText;
var localized string    AndMoreText;

var localized string    JoinTeamText;
var localized string    SelectSpawnPointText;
var localized string    SpawnInfantryText;
var localized string    SpawnVehicleText;
var localized string    SpawnAtVehicleText;
var localized string    ReinforcementsDepletedText;
var localized string    SpawnNoRoleText;
var localized string    TimeElapsedText;
var localized string    MapNameText;

var float               ObituaryFadeInTime;   // for some added suspense:
var float               ObituaryDelayTime;
var array<Obituary>     DHObituaries;         // replaced RO's Obituaries static array, so we can have more than 4 death messages
var array<string>       ConsoleDeathMessages; // paired with DHObituaries array & holds accompanying console death messages

var globalconfig bool   bShowVoiceIcon;     // whether or not to show the voice icon above player's heads
var globalconfig bool   bShowDeathMessages; // whether or not to show the death messages
var globalconfig bool   bSimpleColours;     // for colourblind setting, i.e. red and blue only
var globalconfig int    PlayerNameFontSize; // the size of the name you see when you mouseover a player

var bool                bDebugVehicleHitPoints; // show all vehicle's special hit points (VehHitpoints & NewVehHitpoints), but not the driver's hit points
var bool                bDebugVehicleWheels;    // show all vehicle's physics wheels (the Wheels array of invisible wheels that drive & steer vehicle, even ones with treads)

// Disabled as the only functionality was in HudBase re the DamageTime array, but that became redundant in RO (no longer gets set in function DisplayHit)
simulated function Tick(float deltaTime)
{
    Disable('Tick');
}

// Emptied out as became redundant in RO, but still gets called every Tick from PostRender/DrawHud functions
// Would only do anything if one of the DamageTime array members was set to > 0, but that only happened in HudBase.DisplayHit() & it was removed in RO
function DrawDamageIndicators(Canvas C)
{
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.overheadmap_Icons');
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.AlliedStar');
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.GerCross');

    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_head');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_torso');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Pelvis');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Lupperleg');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Rupperleg');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Lupperarm');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Rupperarm');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Llowerleg');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Rlowerleg');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Llowerarm');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Rlowerarm');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Lhand');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Rhand');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Lfoot');
    Level.AddPrecacheMaterial(texture'DH_GUI_Tex.Player_hits.US_hit_Rfoot');

    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_head');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_torso');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Pelvis');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Lupperleg');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Rupperleg');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Lupperarm');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Rupperarm');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Llowerleg');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Rlowerleg');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Llowerarm');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Rlowerarm');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Lhand');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Rhand');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Lfoot');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Player_hits.ger_hit_Rfoot');

    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.HUD.DeployIcon');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.HUD.Compass2_main');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.HUD.TexRotator0');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.OverheadMap.overheadmap_background');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.HUD.VUMeter');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Cursors.Pointer');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.HUD.Needle_rot');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Menu.SectionHeader_captionbar');

    Level.AddPrecacheMaterial(FinalBlend'DH_GUI_Tex.GUI.PlayerIcon_final');
    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons');
    Level.AddPrecacheMaterial(Material'InterfaceArt2_tex.overheadmaps.overheadmap_IconsB');

    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.numbers');
    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.situation_map_icon');

    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.ger_player');
    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.ger_player_background');
    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.ger_player_Stamina');
    Level.AddPrecacheMaterial(FinalBlend'InterfaceArt_tex.HUD.ger_player_Stamina_critical');
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.US_player');
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.US_player_background');
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.US_player_Stamina');
    Level.AddPrecacheMaterial(FinalBlend'DH_GUI_Tex.GUI.US_player_Stamina_critical');

    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.stance_stand');
    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.stance_crouch');
    Level.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.stance_prone');

    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.throttle_background2');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.throttle_background2_bottom');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.throttle_background');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.throttle_main');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.throttle_lever');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.Ger_RPM');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.Rus_RPM');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.Ger_Speedometer');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.Tank_Hud.Rus_Speedometer');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.Tank_Hud.Ger_needle_rot');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.Tank_Hud.Rus_needle_rot');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.Tank_Hud.Ger_needle_rpm_rot');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.Tank_Hud.Rus_needle_rpm_rot');

    // Damage icons
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.artkill');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.satchel');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.Strike');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.Generic');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.b792mm');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.buttsmack');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.knife');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.b762mm');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.rusgrenade');
    Level.AddPrecacheMaterial(texture'InterfaceArt2_tex.deathicons.sniperkill');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.b9mm');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.germgrenade');
    Level.AddPrecacheMaterial(texture'InterfaceArt2_tex.deathicons.faustkill');
    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.deathicons.mine');
    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.deathicons.backblastkill');
    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.deathicons.piatkill');
    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.deathicons.schreckkill');
    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.deathicons.zookakill');
    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.deathicons.canisterkill');
    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.deathicons.ATGunKill');
    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.deathicons.VehicleFireKill');
    Level.AddPrecacheMaterial(texture'DH_InterfaceArt_tex.deathicons.PlayerFireKill');
}

function DrawCustomBeacon(Canvas C, Pawn P, float ScreenLocX, float ScreenLocY)
{
    local PlayerReplicationInfo PRI;
    local float PlayerDist, XL, YL;

    PRI = P.PlayerReplicationInfo;

    if (PRI == none || PRI.Team == none)
    {
        return;
    }

    if (PlayerOwner == none || PlayerOwner.PlayerReplicationInfo == none || PlayerOwner.PlayerReplicationInfo.Team == none || PlayerOwner.Pawn == none)
    {
        return;
    }

    if (PlayerOwner.PlayerReplicationInfo.Team.TeamIndex != PRI.Team.TeamIndex)
    {
        return;
    }

    PlayerDist = VSizeSquared(P.Location - PlayerOwner.Pawn.Location);

    if (PlayerDist > 2560000.0) // was 1600.0 but now using VSizeSquared for efficient processing (equals 26.5 metres)
    {
        return;
    }

    if (!FastTrace(P.Location, PlayerOwner.Pawn.Location))
    {
        return;
    }

    if (PRI.Team != none)
    {
        C.DrawColor = default.SideColors[PRI.Team.TeamIndex];
    }
    else
    {
        C.DrawColor = default.SideColors[0];
    }

    C.Font = GetPlayerNameFont(C);
    C.StrLen(PRI.PlayerName, XL, YL);
    C.SetPos(ScreenLocX - 0.5 * XL, ScreenLocY - YL);
    C.DrawText(PRI.PlayerName, true);
    C.SetPos(ScreenLocX, ScreenLocY);
}

simulated function Message(PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
    local Class<LocalMessage>   MessageClassType;
    local Class<DHLocalMessage> DHMessageClassType;

    switch (MsgType)
    {
        case 'Say':
            if (PRI != none && PRI.PlayerName != "")
            {
                Msg = PRI.PlayerName $ ":" @ Msg;
            }

            DHMessageClassType = class'DHSayMessage';
            break;
        case 'TeamSay':
            DHMessageClassType = class'DHTeamSayMessage';
            Msg = DHMessageClassType.static.AssembleString(self,, PRI, Msg);
            break;
        case 'SayDead':
            DHMessageClassType = class'DHSayDeadMessage';
            Msg = DHMessageClassType.static.AssembleString(self,, PRI, Msg);
            break;
        case 'TeamSayDead':
            DHMessageClassType = class'DHTeamSayDeadMessage';
            Msg = DHMessageClassType.static.AssembleString(self,, PRI, Msg);
            break;
        case 'VehicleSay':
            DHMessageClassType = class'DHVehicleSayMessage';
            Msg = DHMessageClassType.static.AssembleString(self,, PRI, Msg);
            break;
        case 'CriticalEvent':
            MessageClassType = class'CriticalEventPlus';
            LocalizedMessage(MessageClassType, 0, none, none, none, Msg);
            return;
        case 'DeathMessage':
            return;
        default:
            DHMessageClassType = class'DHLocalMessage';
            break;
    }

    AddDHTextMessage(Msg, DHMessageClassType, PRI);
}

function AddDHTextMessage(string M, class<DHLocalMessage> MessageClass, PlayerReplicationInfo PRI)
{
    local int i;

    if (bMessageBeep && MessageClass.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }

    for (i = 0; i < ConsoleMessageCount; ++i)
    {
        if (TextMessages[i].Text == "")
        {
            break;
        }
    }

    if (i == ConsoleMessageCount)
    {
        for (i = 0; i < ConsoleMessageCount-1; ++i)
        {
            TextMessages[i] = TextMessages[i+1];
        }
    }

    TextMessages[i].Text = M;
    TextMessages[i].MessageLife = Level.TimeSeconds + MessageClass.default.LifeTime;
    TextMessages[i].TextColor = MessageClass.static.GetDHConsoleColor(PRI, AlliedNationID, bSimpleColours);
    TextMessages[i].PRI = PRI;
}

// Modified to use new DHObituaries array instead of RO's Obituaries array
// Also to save a console death message in a paired ConsoleDeathMessages array, so it can be displayed later, only when the delayed screen death message is shown
function AddDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> DamageType)
{
    local Obituary O;
    local int      IndexPosition;

    if (Victim == none)
    {
        return;
    }

    if (Killer != none && Killer != Victim)
    {
        O.KillerName = Killer.PlayerName;
        O.KillerColor = SideColors[Killer.Team.TeamIndex];
    }

    O.VictimName = Victim.PlayerName;
    O.VictimColor = SideColors[Victim.Team.TeamIndex];
    O.DamageType = DamageType;
    O.EndOfLife = Level.TimeSeconds + ObituaryLifeSpan;

    // Making the player's name show up in white in the kill list
    if (PlayerOwner != none &&
        Killer != none &&
        PlayerOwner.PlayerReplicationInfo != none &&
        PlayerOwner.PlayerReplicationInfo.PlayerName == Killer.PlayerName)
    {
        O.KillerColor = WhiteColor;
    }

    IndexPosition = DHObituaries.Length;
    DHObituaries[IndexPosition] = O;

    // Save console death message in a paired ConsoleDeathMessages array
    if (!class'DHDeathMessage'.default.bNoConsoleDeathMessages)
    {
        ConsoleDeathMessages[IndexPosition] = class'DHDeathMessage'.static.GetString(0, Killer, Victim, DamageType);
    }
}

// Modified to correct bug that sometimes screwed up layout of critical message, resulting in very long text lines going outside of message background & sometimes off screen
simulated function ExtraLayoutMessage(out HudLocalizedMessage Message, out HudLocalizedMessageExtra MessageExtra, Canvas C)
{
    local  array<string>  Lines;
    local  float          TempXL, TempYL, InitialXL, XL, YL;
    local  int            InitialNumLines, i, j;

    // Hackish for ROCriticalMessages
    if (class'Object'.static.ClassIsChildOf(Message.Message, class'ROCriticalMessage'))
    {
        // Set a random background type
        MessageExtra.background_type = Rand(4);

        // Figure what width to use to break the string at
        InitialXL = Message.DX;

        // Modified line to use max width specified in ROCriticalMessage subclass
        TempXL = Min(InitialXL, C.SizeX * class<ROCriticalMessage>(Message.Message).default.maxMessageWidth);

        if (TempXL < Message.DY * 8.0) // only wrap if we have enough text
        {
            MessageExtra.Lines.Length = 1;
            MessageExtra.Lines[0] = Message.StringMessage;
        }
        else
        {
            Lines.Length = 0;
            C.WrapStringToArray(Message.StringMessage, Lines, TempXL);
            InitialNumLines = Lines.Length;
            Message.DX = TempXL; // added to fix bug, so Message.DX is always set, even for the 1st pass

            for (i = 0; i < 20; ++i)
            {
                TempXL *= 0.8;
                Lines.Length = 0;
                C.WrapStringToArray(Message.StringMessage, Lines, TempXL);

                if (Lines.Length > InitialNumLines)
                {
                    // If we're getting more than InitialNumLines Lines, it means we should use the previously calculated width
                    Lines.Length = 0;
                    C.WrapStringToArray(Message.StringMessage, Lines, Message.DX);

                    // Save strings to message array + calculate resulting XL/YL
                    MessageExtra.Lines.Length = Lines.Length;
                    C.Font = Message.StringFont;
                    XL = 0.0;
                    YL = 0.0;

                    for (j = 0; j < Lines.Length; ++j)
                    {
                        MessageExtra.Lines[j] = Lines[j];
                        C.TextSize(Lines[j], TempXL, TempYL);
                        XL = Max(TempXL, XL);
                        YL += TempYL;
                    }

                    Message.DX = XL;
                    Message.DY = YL;

                    break;
                }

                Message.DX = TempXL; // store temporarily
            }
        }
    }
}

static function font GetPlayerNameFont(Canvas C)
{
    local int FontSize;

    if (default.OverrideConsoleFontName != "")
    {
        if (default.OverrideConsoleFont != none)
        {
            return default.OverrideConsoleFont;
        }

        default.OverrideConsoleFont = Font(DynamicLoadObject(default.OverrideConsoleFontName, class'Font'));

        if (default.OverrideConsoleFont != none)
        {
            return default.OverrideConsoleFont;
        }

        Log("Warning: HUD couldn't dynamically load font" @ default.OverrideConsoleFontName);

        default.OverrideConsoleFontName = "";
    }

    FontSize = default.PlayerNameFontSize;

    if (C.ClipX < 640.0)
    {
        FontSize++;
    }

    if (C.ClipX < 800.0)
    {
        FontSize++;
    }

    if (C.ClipX < 1024.0)
    {
        FontSize++;
    }

    if (C.ClipX < 1280.0)
    {
        FontSize++;
    }

    if (C.ClipX < 1600.0)
    {
        FontSize++;
    }

    return LoadFontStatic(Min(8, FontSize));
}

// Modified to set a reference to the DHGRI, as soon as we can (can't do it in a BeginPlay event as net client won't yet have received GRI)
simulated event PostRender(canvas Canvas)
{
    if (DHGRI == none && PlayerOwner != none)
    {
        DHGRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);
    }

    super.PostRender(Canvas);
}

// DrawHudPassC - Draw all the widgets here
// Modified to add mantling icon - PsYcH0_Ch!cKeN
simulated function DrawHudPassC(Canvas C)
{
    local VoiceChatRoom      VCR;
    local float              Y, XL, YL, Alpha;
    local string             s;
    local color              MyColor;
    local AbsoluteCoordsInfo Coords;
    local ROWeapon           MyWeapon;
    local bool               bIsSpawnVehicle;
    local byte               BlockFlags;

    if (PawnOwner == none)
    {
        return;
    }

    // Set coordinates to use whole screen
    Coords.Width = C.ClipX;
    Coords.Height = C.ClipY;

    // Damage to body parts (but not when in a vehicle)
    if (bShowPersonalInfo && ROPawn(PawnOwner) != none)
    {
        DrawSpriteWidget(C, HealthFigureBackground);
        DrawSpriteWidget(C, HealthFigureStamina);
        DrawSpriteWidget(C, HealthFigure);
        DrawSpriteWidget(C, StanceIcon);
        DrawLocationHits(C, ROPawn(PawnOwner));
    }

    // MG deploy icon if the weapon can be deployed
    if (PawnOwner.bCanBipodDeploy)
    {
        DrawSpriteWidget(C, MGDeployIcon);
    }

    if (DHPawn(PawnOwner) != none)
    {
        // Mantling icon if an object can be climbed
        if (DHPawn(PawnOwner).bCanMantle)
        {
            DrawSpriteWidget(C, CanMantleIcon);
        }
        // Wire cutting icon if an object can be cut
        else if (DHPawn(PawnOwner).bCanCutWire)
        {
            DrawSpriteWidget(C, CanCutWireIcon);
        }
    }

    // Weapon rest icon
    if (PawnOwner.bRestingWeapon)
    {
        DrawSpriteWidget(C, WeaponRestingIcon);
    }
    else if (PawnOwner.bCanRestWeapon)
    {
        DrawSpriteWidget(C, WeaponCanRestIcon);
    }

    // Resupply icon
    if (PawnOwner.bTouchingResupply)
    {
        if (Vehicle(PawnOwner) != none)
        {
            if (Level.TimeSeconds - PawnOwner.LastResupplyTime <= 1.5)
            {
                DrawSpriteWidget(C, ResupplyZoneResupplyingVehicleIcon);
            }
            else
            {
                DrawSpriteWidget(C, ResupplyZoneNormalVehicleIcon);
            }
        }
        else
        {
            if (Level.TimeSeconds - PawnOwner.LastResupplyTime <= 1.5)
            {
                DrawSpriteWidget(C, ResupplyZoneResupplyingPlayerIcon);
            }
            else
            {
                DrawSpriteWidget(C, ResupplyZoneNormalPlayerIcon);
            }
        }
    }

    // Spawn vehicle deploy icon
    if (Vehicle(PawnOwner) != none)
    {
        if (PawnOwner.IsA('DHArmoredVehicle'))
        {
            bIsSpawnVehicle = DHArmoredVehicle(PawnOwner).bIsSpawnVehicle;
        }
        else if (PawnOwner.IsA('DHWheeledVehicle'))
        {
            bIsSpawnVehicle = DHWheeledVehicle(PawnOwner).bIsSpawnVehicle;
        }

        if (bIsSpawnVehicle)
        {
            BlockFlags = DHGRI.GetSpawnVehicleBlockFlags(Vehicle(PawnOwner));

            if (BlockFlags == class'DHSpawnManager'.default.BlockFlags_None)
            {
                DrawSpriteWidget(C, DeployOkayIcon);
            }
            else if ((BlockFlags & class'DHSpawnManager'.default.BlockFlags_InObjective) != 0)
            {
                DrawSpriteWidget(C, DeployInObjectiveIcon);
            }
            else if ((BlockFlags & class'DHSpawnManager'.default.BlockFlags_EnemiesNearby) != 0)
            {
                DrawSpriteWidget(C, DeployEnemiesNearbyIcon);
            }
        }
    }

    if (bShowWeaponInfo && PawnOwner.Weapon != none)
    // Weapon info
    {
        if (AmmoIcon.WidgetTexture != none)
        {
            MyWeapon = ROWeapon(PawnOwner.Weapon);

            if (MyWeapon != none)
            {
                if (MyWeapon.bWaitingToBolt || MyWeapon.AmmoAmount(0) <= 0)
                {
                    AmmoIcon.Tints[TeamIndex] = WeaponReloadingColor;
                    AmmoCount.Tints[TeamIndex] = WeaponReloadingColor;
                    AutoFireIcon.Tints[TeamIndex] = WeaponReloadingColor;
                    SemiFireIcon.Tints[TeamIndex] = WeaponReloadingColor;
                }
                else
                {
                    AmmoIcon.Tints[TeamIndex] = default.AmmoIcon.Tints[TeamIndex];
                    AmmoCount.Tints[TeamIndex] = default.AmmoCount.Tints[TeamIndex];
                    AutoFireIcon.Tints[TeamIndex] = default.AutoFireIcon.Tints[TeamIndex];
                    SemiFireIcon.Tints[TeamIndex] = default.SemiFireIcon.Tints[TeamIndex];
                }

                DrawSpriteWidget(C, AmmoIcon);
                DrawNumericWidget(C, AmmoCount, Digits);

                if (MyWeapon.bHasSelectFire)
                {
                    if (MyWeapon.UsingAutoFire())
                    {
                        DrawSpriteWidget(C, AutoFireIcon);
                    }
                    else
                    {
                        DrawSpriteWidget(C, SemiFireIcon);
                    }
                }

                MyWeapon.NewDrawWeaponInfo(C, 0.86 * C.ClipY);
            }
        }
    }

    // Objective capture bar
    DrawCaptureBar(C);

    // Compass
    if (bShowCompass)
    {
        DrawCompass(C);
    }

    // 'Map updated' icon
    if (bShowMapUpdatedIcon)
    {
        Alpha = (Level.TimeSeconds - MapUpdatedIconTime) % 2.0;

        if (Alpha < 0.5)
        {
            Alpha = 1.0 - Alpha / 0.5;
        }
        else if (Alpha < 1.0)
        {
            Alpha = (Alpha - 0.5) / 0.5;
        }
        else
        {
            Alpha = 1.0;
        }

        MyColor.R = 255;
        MyColor.G = 255;
        MyColor.B = 255;
        MyColor.A = Byte(Alpha * 255.0);

        if (MyColor.A != 0)
        {
            // Set different position if not showing compass
            if (!bShowCompass)
            {
                MapUpdatedText.PosX = 0.95;
                MapUpdatedIcon.PosX = 0.95;
            }
            else
            {
                MapUpdatedText.PosX = default.MapUpdatedText.PosX;
                MapUpdatedIcon.PosX = default.MapUpdatedIcon.PosX;
            }

            XL = 0.0;
            YL = 0.0;
            Y  = 0.0;

            if (bShowMapUpdatedText)
            {
                // Check width & height of text label
                s = class'ROTeamGame'.static.ParseLoadingHintNoColor(OpenMapText, PlayerController(Owner));
                C.Font = getSmallMenuFont(C);

                // Draw text
                MapUpdatedText.Text = s;
                MapUpdatedText.Tints[0] = MyColor; MapUpdatedText.Tints[1] = MyColor;
                MapUpdatedText.OffsetY = default.MapUpdatedText.OffsetY * MapUpdatedIcon.TextureScale;
                DrawTextWidgetClipped(C, MapUpdatedText, Coords, XL, YL, Y);

                // Offset icon by text height
                MapUpdatedIcon.OffsetY = MapUpdatedText.OffsetY - YL - Y / 2.0;
            }
            else
            {
                // Offset icon by text height
                MapUpdatedIcon.OffsetY = default.MapUpdatedText.OffsetY * MapUpdatedIcon.TextureScale;
            }

            // Draw icon
            MapUpdatedIcon.Tints[0] = MyColor; MapUpdatedIcon.Tints[1] = MyColor;
            DrawSpriteWidgetClipped(C, MapUpdatedIcon, Coords, true, XL, YL, true, true, true);

            // Check if we should stop showing the icon
            if (Level.TimeSeconds - MapUpdatedIconTime > MaxMapUpdatedIconDisplayTime)
            {
                bShowMapUpdatedIcon = false;
            }
        }
    }

    // Player names
    DrawPlayerNames(C);

    // Portrait
    if (bShowPortrait || (bShowPortraitVC && Level.TimeSeconds - LastPlayerIDTalkingTime < 2.0))
    {
        // Start by updating current portrait PRI
        if (Level.TimeSeconds - LastPlayerIDTalkingTime < 0.1 && PlayerOwner.GameReplicationInfo != none)
        {
            if (PortraitPRI == none || PortraitPRI.PlayerID != LastPlayerIDTalking)
            {
                if (PortraitPRI == none)
                {
                    PortraitX = 1.0;
                }

                PortraitPRI = PlayerOwner.GameReplicationInfo.FindPlayerByID(LastPlayerIDTalking);

                if (PortraitPRI != none)
                {
                    PortraitTime = Level.TimeSeconds + 3.0;
                }
            }
            else
            {
                PortraitTime = Level.TimeSeconds + 0.2;
            }
        }
        else
        {
            LastPlayerIDTalking = 0;
        }

        // Update portrait alpha value (fade in & fade out)
        if ((PortraitTime - Level.TimeSeconds) > 0.0)
        {
            PortraitX = FMax(0.0, PortraitX - 3.0 * (Level.TimeSeconds - HudLastRenderTime));
        }
        else if (PortraitPRI != none)
        {
            PortraitX = FMin(1.0, PortraitX + 3.0 * (Level.TimeSeconds - HudLastRenderTime));

            if (PortraitX == 1.0)
            {
                PortraitPRI = none;
            }
        }

        // Draw portrait if needed
        if (PortraitPRI != none)
        {
            if (PortraitPRI.Team != none)
            {
                if (PortraitPRI.Team.TeamIndex == 0)
                {
                    PortraitIcon.WidgetTexture = CaptureBarTeamIcons[0];
                    PortraitText[0].Tints[TeamIndex] = SideColors[0];
                }
                else if (PortraitPRI.Team.TeamIndex == 1)
                {
                    PortraitIcon.WidgetTexture = CaptureBarTeamIcons[1];
                    PortraitText[0].Tints[TeamIndex] = SideColors[1];
                }
                else
                {
                    PortraitIcon.WidgetTexture = CaptureBarTeamIcons[0];
                    PortraitText[0].Tints[TeamIndex] = default.PortraitText[0].Tints[TeamIndex];
                }
            }

            // PortraitX goes from 0 to 1 -- we'll use that as alpha
            PortraitIcon.Tints[TeamIndex].A = Byte(255 * (1.0 - PortraitX));
            PortraitText[0].Tints[TeamIndex].A = PortraitIcon.Tints[TeamIndex].A;

            XL = 0.0;
            DrawSpriteWidgetClipped(C, PortraitIcon, Coords, true, XL, YL, false, true);

            // Draw first line of text
            PortraitText[0].OffsetX = PortraitIcon.OffsetX * PortraitIcon.TextureScale + XL * 1.1;
            PortraitText[0].Text = PortraitPRI.PlayerName;
            C.Font = GetFontSizeIndex(C, -2);
            DrawTextWidgetClipped(C, PortraitText[0], Coords);

            // Draw second line of text
            VCR = PlayerOwner.VoiceReplicationInfo.GetChannelAt(PortraitPRI.ActiveChannel);

            if (VCR != none)
            {
                PortraitText[1].Text = "(" @ VCR.GetTitle() @ ")";
            }
            else
            {
                PortraitText[1].Text = "(?)";
            }

            PortraitText[1].OffsetX = PortraitText[0].OffsetX;
            PortraitText[1].Tints[TeamIndex] = PortraitText[0].Tints[TeamIndex];
            DrawTextWidgetClipped(C, PortraitText[1], Coords);

            // Draw the voice icon
            if (bShowVoiceIcon)
            {
                DrawVoiceIcon(C);
            }
        }
    }

    // Debug option - draw actors on the HUD to help debugging network relevancy
    if (bShowRelevancyDebugOverlay && (Level.NetMode == NM_Standalone || (DHGRI != none && DHGRI.bAllowNetDebug)))
    {
        DrawNetworkActors(C);
    }

    // Debug options - slow !
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        // Draw all vehicle occupant ('Driver') hit points
        if (bDebugDriverCollision)
        {
            DrawDriverPointSphere();
        }

        // Draw all vehicle's special hit points
        if (bDebugVehicleHitPoints)
        {
            DrawVehiclePointSphere();
        }

        // Draw all player's body part hit points & bullet whip attachment
        if (bDebugPlayerCollision)
        {
            DrawPointSphere();
        }

        // Draw all vehicle's physics wheels
        if (bDebugVehicleWheels)
        {
            DrawVehiclePhysiscsWheels();
        }
    }
}

// Draws all the vehicle HUD info, e.g. vehicle icon, passengers, ammo, speed, throttle
// Overridden to handle new system where rider pawns won't exist on clients unless occupied (& generally prevent spammed log errors)
function DrawVehicleIcon(Canvas Canvas, ROVehicle Vehicle, optional ROVehicleWeaponPawn Passenger)
{
    local ROTreadCraft          AV;
    local ROWheeledVehicle      WheeledVehicle;
    local DHWheeledVehicle      DHWV;
    local ROVehicleWeaponPawn   WeaponPawn;
    local ROVehicleWeapon       VehWeapon;
    local ROTankCannon          Cannon;
    local PlayerReplicationInfo PRI;
    local AbsoluteCoordsInfo    Coords, Coords2;
    local SpriteWidget          Widget;
    local TexRotator            VehicleHudTurret, VehicleHudTurretLook;
    local color                 VehicleColor;
    local rotator               MyRot;
    local int                   i, Current, Pending;
    local float                 f, XL, YL, Y_one, MyScale, ProportionOfReloadRemaining, ModifiedVehicleOccupantsTextYOffset; // offsets text vertically when drawing coaxial ammo info
    local array<string>         Lines;

    if (bHideHud)
    {
        return;
    }

    // Figure what the scale is
    MyScale = HudScale; // * ResScaleY;

    // Figure where to draw
    Coords.PosX = Canvas.ClipX * VehicleIconCoords.X;
    Coords.Height = Canvas.ClipY * VehicleIconCoords.YL * MyScale;
    Coords.PosY = Canvas.ClipY * VehicleIconCoords.Y - Coords.Height;
    Coords.Width = Coords.Height;

    // Compute whole-screen coords
    Coords2.PosX = 0.0;
    Coords2.PosY = 0.0;
    Coords2.Width = Canvas.ClipX;
    Coords2.Height = canvas.ClipY;

    // Set initial passenger PosX (shifted if we're drawing ammo info, else it's draw closer to the tank icon)
    VehicleOccupantsText.PosX = default.VehicleOccupantsText.PosX;

    // Large vehicles may use a larger icon texture
    if (Vehicle.bVehicleHudUsesLargeTexture)
    {
        Widget = VehicleIconAlt;
    }
    else
    {
        Widget = VehicleIcon;
    }

    // Figure what color to draw in
    f = Vehicle.Health / Vehicle.HealthMax;

    if (f > 0.75)
    {
        VehicleColor = VehicleNormalColor;
    }
    else if (f > 0.35)
    {
        VehicleColor = VehicleDamagedColor;
    }
    else
    {
        VehicleColor = VehicleCriticalColor;
    }

    Widget.Tints[0] = VehicleColor;
    Widget.Tints[1] = VehicleColor;

    // Draw clock face (without numbers)
    VehicleIcon.WidgetTexture = material'DH_InterfaceArt_tex.Tank_Hud.clock_face';
    DrawSpriteWidgetClipped(Canvas, VehicleIcon, Coords, true);

    // Draw vehicle icon
    Widget.WidgetTexture = Vehicle.VehicleHudImage;
    DrawSpriteWidgetClipped(Canvas, Widget, Coords, true);

    // Draw engine (if needed)
    f = Vehicle.EngineHealth / Vehicle.default.EngineHealth;

    if (f < 0.95)
    {
        if (f < 0.35)
        {
            VehicleEngine.WidgetTexture = VehicleEngineCriticalTexture;
        }
        else
        {
            VehicleEngine.WidgetTexture = VehicleEngineDamagedTexture;
        }

        VehicleEngine.PosX = Vehicle.VehicleHudEngineX;
        VehicleEngine.PosY = Vehicle.VehicleHudEngineY;
        DrawSpriteWidgetClipped(Canvas, VehicleEngine, Coords, true);
    }

    AV = ROTreadCraft(Vehicle);

    // Setup/draw armored fighting vehicle specific stuff
    if (AV != none)
    {
        // Update turret references, if necessary
        if (AV.CannonTurret == none)
        {
            AV.UpdateTurretReferences();
        }

        Cannon = AV.CannonTurret;
        VehicleHudTurret = AV.VehicleHudTurret;
        VehicleHudTurretLook = AV.VehicleHudTurretLook;

        // Draw any damaged treads
        if (AV.bLeftTrackDamaged)
        {
            VehicleThreads[0].TextureScale = AV.VehicleHudThreadsScale;
            VehicleThreads[0].PosX = AV.VehicleHudThreadsPosX[0];
            VehicleThreads[0].PosY = AV.VehicleHudThreadsPosY;
            DrawSpriteWidgetClipped(Canvas, VehicleThreads[0], Coords, true, XL, YL, false, true);
        }

        if (AV.bRightTrackDamaged)
        {
            VehicleThreads[1].TextureScale = AV.VehicleHudThreadsScale;
            VehicleThreads[1].PosX = AV.VehicleHudThreadsPosX[1];
            VehicleThreads[1].PosY = AV.VehicleHudThreadsPosY;
            DrawSpriteWidgetClipped(Canvas, VehicleThreads[1], Coords, true, XL, YL, false, true);
        }
    }
    // Added option for a non-armoured fighting vehicle to have a mounted cannon (e.g. Sd.Kfz.251/22 - German half-track with mounted pak 40 AT gun)
    else
    {
        DHWV = DHWheeledVehicle(Vehicle);

        if (DHWV != none && DHWV.Cannon != none)
        {
            Cannon = DHWV.Cannon;
            VehicleHudTurret = DHWV.VehicleHudTurret;
            VehicleHudTurretLook = DHWV.VehicleHudTurretLook;
        }
    }

    // Update & draw turret (if needed)
    if (ROTankCannonPawn(Passenger) != none)
    {
        // Update & draw look turret
        if (VehicleHudTurretLook != none)
        {
            VehicleHudTurretLook.Rotation.Yaw = Vehicle.Rotation.Yaw - Passenger.CustomAim.Yaw;
            Widget.WidgetTexture = VehicleHudTurretLook;
            Widget.Tints[0].A /= 2;
            Widget.Tints[1].A /= 2;
            DrawSpriteWidgetClipped(Canvas, Widget, Coords, true);
            Widget.Tints[0] = VehicleColor;
            Widget.Tints[1] = VehicleColor;
        }

        // Draw ammo count since we're a gunner
        if (bShowWeaponInfo)
        {
            // Shift passengers list farther to the right
            VehicleOccupantsText.PosX = VehicleOccupantsTextOffset;

            // Draw icon
            VehicleAmmoIcon.WidgetTexture = Passenger.AmmoShellTexture;
            DrawSpriteWidget(Canvas, VehicleAmmoIcon);

            // Draw reload state icon (if needed)
            VehicleAmmoReloadIcon.WidgetTexture = Passenger.AmmoShellReloadTexture;
            VehicleAmmoReloadIcon.Scale = Passenger.GetAmmoReloadState();
            DrawSpriteWidget(Canvas, VehicleAmmoReloadIcon);

            // Draw ammo count
            if (Passenger != none && Passenger.Gun != none)
            {
                VehicleAmmoAmount.Value = Passenger.Gun.PrimaryAmmoCount();
            }

            DrawNumericWidget(Canvas, VehicleAmmoAmount, Digits);

            // Draw ammo type
            if (Cannon != none)
            {
                if (Cannon.bMultipleRoundTypes)
                {
                    // Get ammo types
                    Current = Cannon.GetRoundsDescription(Lines);
                    Pending = Cannon.GetPendingRoundIndex();

                    VehicleAmmoTypeText.OffsetY = default.VehicleAmmoTypeText.OffsetY * MyScale;

                    if (MyScale < 0.85)
                    {
                        Canvas.Font = GetConsoleFont(Canvas);
                    }
                    else
                    {
                        Canvas.Font = GetSmallMenuFont(Canvas);
                    }

                    i = (Current + 1) % Lines.Length;

                    while (true)
                    {
                        if (i == Pending)
                        {
                            VehicleAmmoTypeText.Text = Lines[i] $ "<-";
                        }
                        else
                        {
                            VehicleAmmoTypeText.Text = Lines[i];
                        }

                        if (i == Current)
                        {
                            VehicleAmmoTypeText.Tints[TeamIndex].A = 255;
                        }
                        else
                        {
                            VehicleAmmoTypeText.Tints[TeamIndex].A = 128;
                        }

                        DrawTextWidgetClipped(Canvas, VehicleAmmoTypeText, Coords2, XL, YL, Y_one);
                        VehicleAmmoTypeText.OffsetY -= YL;

                        i = (i + 1) % Lines.Length;

                        if (i == (Current + 1) % Lines.Length)
                        {
                            break;
                        }
                    }
                }

                // Draw coaxial gun ammo info if needed
                if (Cannon.AltFireProjectileClass != none)
                {
                    // Draw coaxial gun ammo icon
                    VehicleAltAmmoIcon.WidgetTexture = Cannon.hudAltAmmoIcon;
                    DrawSpriteWidget(Canvas, VehicleAltAmmoIcon);

                    // Draw coaxial gun reload state icon (if needed) // added to show reload progress in red, like a tank cannon reload
                    if (DHVehicleCannonPawn(Passenger) != none)
                    {
                        ProportionOfReloadRemaining = DHVehicleCannonPawn(Passenger).GetAltAmmoReloadState();

                        if (ProportionOfReloadRemaining > 0.0)
                        {
                            VehicleAltAmmoReloadIcon.WidgetTexture = DHVehicleCannonPawn(Passenger).AltAmmoReloadTexture;
                            VehicleAltAmmoReloadIcon.Scale = ProportionOfReloadRemaining;
                            DrawSpriteWidget(Canvas, VehicleAltAmmoReloadIcon);
                        }
                    }

                    // Draw coaxial gun ammo amount
                    VehicleAltAmmoAmount.Value = Cannon.GetNumMags();
                    DrawNumericWidget(Canvas, VehicleAltAmmoAmount, Digits);

                    // Shift occupants list position to accommodate coaxial gun ammo info
                    ModifiedVehicleOccupantsTextYOffset = VehicleAltAmmoOccupantsTextOffset * MyScale;
                }
            }
        }
    }

    // Draw clock numbers
    VehicleIcon.WidgetTexture = material'DH_InterfaceArt_tex.Tank_Hud.clock_numbers';
    DrawSpriteWidgetClipped(Canvas, VehicleIcon, Coords, true);

    // Update & draw any turret
    if (Cannon != none && VehicleHudTurret != none)
    {
        MyRot = rotator(vector(Cannon.CurrentAim) >> Cannon.Rotation);
        VehicleHudTurret.Rotation.Yaw = Vehicle.Rotation.Yaw - MyRot.Yaw;
        Widget.WidgetTexture = VehicleHudTurret;
        DrawSpriteWidgetClipped(Canvas, Widget, Coords, true);
    }

    // Draw MG ammo info (if needed)
    if (bShowWeaponInfo && Passenger != none && Passenger.bIsMountedTankMG)
    {
        VehWeapon = ROVehicleWeapon(Passenger.Gun);

        if (VehWeapon != none)
        {
            // Offset vehicle passenger names
            VehicleOccupantsText.PosX = VehicleOccupantsTextOffset;

            // Draw ammo icon
            VehicleMGAmmoIcon.WidgetTexture = VehWeapon.hudAltAmmoIcon;
            DrawSpriteWidget(Canvas, VehicleMGAmmoIcon);

            // Draw reload state icon (if needed) // added to show reload progress in red, like a tank cannon reload
            if (DHVehicleMGPawn(Passenger) != none)
            {
                ProportionOfReloadRemaining = Passenger.GetAmmoReloadState();

                if (ProportionOfReloadRemaining > 0.0)
                {
                    VehicleMGAmmoReloadIcon.WidgetTexture = DHVehicleMGPawn(Passenger).VehicleMGReloadTexture;
                    VehicleMGAmmoReloadIcon.Scale = ProportionOfReloadRemaining;
                    DrawSpriteWidget(Canvas, VehicleMGAmmoReloadIcon);
                }
            }

            // Draw ammo count
            VehicleMGAmmoAmount.Value = VehWeapon.GetNumMags();
            DrawNumericWidget(Canvas, VehicleMGAmmoAmount, Digits);
        }
    }

    // Draw rpm/speed/throttle gauges if we're the driver
    if (Passenger == none)
    {
        WheeledVehicle = ROWheeledVehicle(Vehicle);

        if (WheeledVehicle != none)
        {
            // Get team index
            if (Vehicle.Controller != none && Vehicle.Controller.PlayerReplicationInfo != none && Vehicle.Controller.PlayerReplicationInfo.Team != none)
            {
                if (Vehicle.Controller.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                {
                    i = AXIS_TEAM_INDEX;
                }
                else
                {
                    i = ALLIES_TEAM_INDEX;
                }
            }
            else
            {
                i = AXIS_TEAM_INDEX;
            }

            // Update textures for backgrounds
            VehicleSpeedIndicator.WidgetTexture = VehicleSpeedTextures[i];
            VehicleRPMIndicator.WidgetTexture = VehicleRPMTextures[i];

            // Draw backgrounds
            DrawSpriteWidgetClipped(Canvas, VehicleSpeedIndicator, Coords, true, XL, YL, false, true);
            DrawSpriteWidgetClipped(Canvas, VehicleRPMIndicator, Coords, true, XL, YL, false, true);

            // Get speed value & update rotator
            f = VSize(WheeledVehicle.Velocity) * 0.05965; // convert from UU to kph // was " * 3600.0 / 60.352 / 1000.0" but optimised calculation as done many times per sec
            f *= VehicleSpeedScale[i];
            f += VehicleSpeedZeroPosition[i];

            // Check if we should reset needles rotation
            if (VehicleNeedlesLastRenderTime < Level.TimeSeconds - 0.5)
            {
                f = VehicleLastSpeedRotation;
            }

            // Calculate modified rotation (to limit rotation speed)
            if (f < VehicleLastSpeedRotation)
            {
                VehicleLastSpeedRotation = max(f, VehicleLastSpeedRotation - (Level.TimeSeconds - VehicleNeedlesLastRenderTime) * VehicleNeedlesRotationSpeed);
            }
            else
            {
                VehicleLastSpeedRotation = min(f, VehicleLastSpeedRotation + (Level.TimeSeconds - VehicleNeedlesLastRenderTime) * VehicleNeedlesRotationSpeed);
            }

            TexRotator(VehicleSpeedNeedlesTextures[i]).Rotation.Yaw = VehicleLastSpeedRotation;

            // Get RPM value & update rotator
            f = WheeledVehicle.EngineRPM / 100.0;
            f *= VehicleRPMScale[i];
            f += VehicleRPMZeroPosition[i];

            // Check if we should reset needles rotation
            if (VehicleNeedlesLastRenderTime < Level.TimeSeconds - 0.5)
            {
                f = VehicleLastSpeedRotation;
            }

            // Calculate modified rotation (to limit rotation speed)
            if (f < VehicleLastRPMRotation)
            {
                VehicleLastRPMRotation = max(f, VehicleLastRPMRotation - (Level.TimeSeconds - VehicleNeedlesLastRenderTime) * VehicleNeedlesRotationSpeed);
            }
            else
            {
                VehicleLastRPMRotation = min(f, VehicleLastRPMRotation + (Level.TimeSeconds - VehicleNeedlesLastRenderTime) * VehicleNeedlesRotationSpeed);
            }

            TexRotator(VehicleRPMNeedlesTextures[i]).Rotation.Yaw = VehicleLastRPMRotation;

            // Save last updated time
            VehicleNeedlesLastRenderTime = Level.TimeSeconds;

            // Update textures for needles
            VehicleSpeedIndicator.WidgetTexture = VehicleSpeedNeedlesTextures[i];
            VehicleRPMIndicator.WidgetTexture = VehicleRPMNeedlesTextures[i];

            // Draw needles
            DrawSpriteWidgetClipped(Canvas, VehicleSpeedIndicator, Coords, true, XL, YL, false, true);
            DrawSpriteWidgetClipped(Canvas, VehicleRPMIndicator, Coords, true, XL, YL, false, true);

            // Check if we should draw throttle
            if (ROPlayer(Vehicle.Controller) != none &&
                ((ROPlayer(Vehicle.Controller).bInterpolatedTankThrottle && AV != none) || (ROPlayer(Vehicle.Controller).bInterpolatedVehicleThrottle && AV == none)))
            {
                // Draw throttle background
                DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorBackground, Coords, true, XL, YL, false, true);

                // Save YL for use later
                Y_one = YL;

                // Check which throttle variable we should use
                if (PlayerOwner != Vehicle.Controller)
                {
                    // Is spectator
                    if (WheeledVehicle.ThrottleRep <= 100)
                    {
                        f = (WheeledVehicle.ThrottleRep * -1.0) / 100.0;
                    }
                    else
                    {
                        f = Float(WheeledVehicle.ThrottleRep - 101) / 100.0;
                    }
                }
                else
                {
                    f = WheeledVehicle.Throttle;
                }

                // Figure which part to draw (top or bottom) depending if throttle is positive or negative, update the scale value and draw the widget
                if (f ~= 0.0)
                {
                }
                else if (f > 0.0)
                {
                    VehicleThrottleIndicatorTop.Scale = VehicleThrottleTopZeroPosition + f * (VehicleThrottleTopMaxPosition - VehicleThrottleTopZeroPosition);
                    DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorTop, Coords, true, XL, YL, false, true);
                }
                else
                {
                    VehicleThrottleIndicatorBottom.Scale = VehicleThrottleBottomZeroPosition - f * (VehicleThrottleBottomMaxPosition - VehicleThrottleBottomZeroPosition);
                    DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorBottom, Coords, true, XL, YL, false, true);
                }

                // Draw throttle foreground
                DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorForeground, Coords, true, XL, YL, false, true);

                // Draw the lever thingy
                if (f ~= 0.0)
                {
                    VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - Y_one * VehicleThrottleTopZeroPosition;
                }
                else if (f > 0.0)
                {
                    VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - Y_one * VehicleThrottleIndicatorTop.Scale;
                }
                else
                {
                    VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - Y_one * (1.0 - VehicleThrottleIndicatorBottom.Scale);
                }

                DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorLever, Coords, true, XL, YL, true, true);

                // Shift passengers list farther to the right
                VehicleOccupantsText.PosX = VehicleGaugesOccupantsTextOffset;
            }
            else
            {
                // Shift passengers list farther to the right
                VehicleOccupantsText.PosX = VehicleGaugesNoThrottleOccupantsTextOffset;
            }

            // hax to get proper x offset on non-4:3 screens
            VehicleOccupantsText.PosX *= Canvas.ClipY / Canvas.ClipX * 4.0 / 3.0;
        }
    }

    // Draw vehicle occupant dots
    for (i = 0; i < Vehicle.VehicleHudOccupantsX.Length; ++i)
    {
        if (Vehicle.VehicleHudOccupantsX[i] ~= 0)
        {
            continue;
        }

        if (i == 0)
        {
            // Draw driver
            if (Passenger == none) // we're the driver
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsPlayerColor;
            }
            else if (Vehicle.Driver != none)
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsOccupiedColor;
            }
            else
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsVacantColor;
            }

            VehicleOccupants.PosX = Vehicle.VehicleHudOccupantsX[0];
            VehicleOccupants.PosY = Vehicle.VehicleHudOccupantsY[0];
            DrawSpriteWidgetClipped(Canvas, VehicleOccupants, Coords, true);
        }
        else
        {
            if (i - 1 >= Vehicle.WeaponPawns.Length) // if we're already beyond WeaponPawns.Length, there's no point continuing with the for loop
            {
                break;
            }
            else if (Vehicle.WeaponPawns[i - 1] == none) // added to show missing rider/passenger pawns, as now they won't exist on clients unless occupied
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsVacantColor;
            }
            else if (Vehicle.WeaponPawns[i - 1] == Passenger && Passenger != none)
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsPlayerColor;
            }
            else if (Vehicle.WeaponPawns[i - 1].PlayerReplicationInfo != none)
            {
                if (Passenger != none && Passenger.PlayerReplicationInfo != none && Vehicle.WeaponPawns[i - 1].PlayerReplicationInfo == Passenger.PlayerReplicationInfo)
                {
                    VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsPlayerColor;
                }
                else
                {
                    VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsOccupiedColor;
                }
            }
            else
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsVacantColor;
            }

            VehicleOccupants.PosX = Vehicle.VehicleHudOccupantsX[i];
            VehicleOccupants.PosY = Vehicle.VehicleHudOccupantsY[i];

            DrawSpriteWidgetClipped(Canvas, VehicleOccupants, Coords, true);
        }
    }

    //////////////////////////////////////
    // Draw passenger names
    //////////////////////////////////////

    // Get self's PRI
    if (Passenger != none)
    {
        PRI = Passenger.PlayerReplicationInfo;
    }
    else
    {
        PRI = Vehicle.PlayerReplicationInfo;
    }

    // Clear lines array
    Lines.Length = 0;

    // Shift text up some more if we're the driver and we're displaying capture bar
    if (bDrawingCaptureBar && Vehicle.PlayerReplicationInfo == PRI)
    {
        ModifiedVehicleOccupantsTextYOffset -= 0.12 * Canvas.SizeY * MyScale;
    }

    // Driver's name
    if (Vehicle.PlayerReplicationInfo != none && Vehicle.PlayerReplicationInfo != PRI) // don't draw our own name!
    {
        Lines[Lines.Length] = class'ROVehicleWeaponPawn'.default.DriverHudName $ ":" @ Vehicle.PlayerReplicationInfo.PlayerName;
    }

    // Passengers' names
    for (i = 0; i < Vehicle.WeaponPawns.Length; ++i)
    {
        WeaponPawn = ROVehicleWeaponPawn(Vehicle.WeaponPawns[i]);

        if (WeaponPawn != none && WeaponPawn.PlayerReplicationInfo != none && WeaponPawn.PlayerReplicationInfo != PRI) // don't draw our own name!
        {
            Lines[Lines.Length] = WeaponPawn.HudName $ ":" @ WeaponPawn.PlayerReplicationInfo.PlayerName;
        }
    }

    // Draw the lines
    if (Lines.Length > 0)
    {
        VehicleOccupantsText.OffsetY = default.VehicleOccupantsText.OffsetY * MyScale;
        VehicleOccupantsText.OffsetY += ModifiedVehicleOccupantsTextYOffset;
        Canvas.Font = GetSmallMenuFont(Canvas);

        for (i = Lines.Length - 1; i >= 0; --i)
        {
            VehicleOccupantsText.Text = Lines[i];
            DrawTextWidgetClipped(Canvas, VehicleOccupantsText, Coords2, XL, YL, Y_one);
            VehicleOccupantsText.OffsetY -= YL;
        }
    }
}

// Modified to handle resupply text for AT weapons & mortars & assisted reload text for AT weapons
function DrawPlayerNames(Canvas C)
{
    local vector          HitLocation, HitNormal, ScreenPos, NamedPlayerLoc, X, Y, Z, Dir;
    local int             PawnOwnerTeam;
    local float           StrX, StrY;
    local string          ResupplyMessage;
    local bool            bCouldMGResupply, bCouldMortarResupply, bCouldATResupply, bCouldATReload;
    local Pawn            HitPawn;
    local DHPawn          MyDHP, OtherDHP;
    local DHMortarVehicle Mortar;

    if (PawnOwner == none || PlayerOwner == none)
    {
        return;
    }

    HitPawn = Pawn(Trace(HitLocation, HitNormal, PlayerOwner.CalcViewLocation + (1600.0 * vector(PlayerOwner.CalcViewRotation)), PlayerOwner.CalcViewLocation, true));
    PawnOwnerTeam = PawnOwner.GetTeamNum();
    Mortar = DHMortarVehicle(HitPawn);

    // Record NamedPlayer & possibly NameTime, if we're looking at a player or a mortar on the same team
    if (HitPawn != none && HitPawn != PawnOwner && (HitPawn.GetTeamNum() == PawnOwnerTeam || (Mortar != none && Mortar.VehicleTeam == PawnOwnerTeam)))
    {
        if (NamedPlayer != HitPawn || Level.TimeSeconds - NameTime > 0.5)
        {
            NamedPlayer = HitPawn;
            NameTime = Level.TimeSeconds;
        }
    }
    else
    {
        NamedPlayer = none;
    }

    // Draw viewed player name & maybe resupply/reload text (the time check keeps name on screen for 1 second after we look away)
    if (NamedPlayer != none && Level.TimeSeconds - NameTime < 1.0)
    {
        Dir = Normal(NamedPlayer.Location - PawnOwner.Location);
        GetAxes(PlayerOwner.CalcViewRotation, X, Y, Z);

        if (Dir dot X > 0.0)
        {
            NamedPlayerLoc = NamedPlayer.Location;
            NamedPlayerLoc.Z += NamedPlayer.CollisionHeight + 8.0;

            MyDHP = DHPawn(PawnOwner);

            // Set resupply/reload flags
            if (MyDHP != none)
            {
                // Resupply a deployed mortar
                if (Mortar != none)
                {
                    if (Mortar.bCanBeResupplied && MyDHP.bHasMortarAmmo)
                    {
                        bCouldMortarResupply = true;
                    }
                }
                else
                {
                    OtherDHP = DHPawn(NamedPlayer);

                    if (OtherDHP != none)
                    {
                        // AT weapon assisted reload
                        if (OtherDHP.bWeaponNeedsReload)
                        {
                            bCouldATReload = true;
                        }
                        else if (OtherDHP.bWeaponNeedsResupply)
                        {
                            // AT weapon resupply
                            if (DHRocketWeaponAttachment(OtherDHP.WeaponAttachment) != none)
                            {
                                if (MyDHP.bHasATAmmo)
                                {
                                    bCouldATResupply = true;
                                }
                            }
                            // MG resupply
                            else if (MyDHP.bHasMGAmmo)
                            {
                                bCouldMGResupply = true;
                            }
                        }
                        // Mortar resupply (a player carrying an undeployed mortar)
                        else if (OtherDHP.bMortarCanBeResupplied && MyDHP.bHasMortarAmmo)
                        {
                            bCouldMortarResupply = true;
                        }
                    }
                }

                // If we could resupply/reload the player, set the appropriate message
                if (bCouldMGResupply || bCouldMortarResupply || bCouldATResupply || bCouldATReload)
                {
                    // If within 2 metres then we can actually resupply/reload the player
                    if (VSizeSquared(NamedPlayerLoc - MyDHP.Location) < 14400.0)
                    {
                        if (bCouldATReload)
                        {
                            ResupplyMessage = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanReloadText, PlayerController(Owner));
                        }
                        else
                        {
                            ResupplyMessage = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                        }
                    }
                    // Otherwise we'll display a message saying the player needs a resupply/reload
                    else
                    {
                        if (bCouldATReload)
                        {
                            ResupplyMessage = NeedReloadText;
                        }
                        else
                        {
                            ResupplyMessage = NeedAmmoText;
                        }

                        // Not close enough to actually resupply/reload, so reset these local variables
                        bCouldMGResupply = false;
                        bCouldMortarResupply = false;
                        bCouldATResupply = false;
                        bCouldATReload = false;
                    }
                }

                // Now set our pawn's resupply/reload variables (do this only once, as they are replicated)
                MyDHP.bCanMGResupply = bCouldMGResupply;
                MyDHP.bCanMortarResupply = bCouldMortarResupply;
                MyDHP.bCanATResupply = bCouldATResupply;
                MyDHP.bCanATReload = bCouldATReload;
            }

            C.Font = GetPlayerNameFont(C);
            ScreenPos = C.WorldToScreen(NamedPlayerLoc);

            // Draw player name & any resupply/reload message
            if (NamedPlayer.PlayerReplicationInfo != none)
            {
                C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, StrX, StrY);
                C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 0.5);

                if (ResupplyMessage != "")
                {
                    C.DrawColor = WhiteColor;
                    C.DrawTextClipped(ResupplyMessage);
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 1.5); // if resupply/reload message drawn, now raise drawing position so player's name is above message
                }

                C.DrawColor = SideColors[NamedPlayer.PlayerReplicationInfo.Team.TeamIndex];
                C.DrawTextClipped(NamedPlayer.PlayerReplicationInfo.PlayerName);
            }
            // Or if we don't have a player name but have resupply text, then just draw that (must be a deployed mortar that can be resupplied)
            else if (ResupplyMessage != "")
            {
                C.DrawColor = WhiteColor;
                C.TextSize(ResupplyMessage, StrX, StrY);
                C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 0.5);
                C.DrawTextClipped(ResupplyMessage);
            }
        }
    }
}

// Modified to only show the vehicle occupant ('Driver') hit points, not the vehicle's special hit points for engine & ammo stores
// (Badly named, but is an inherited function - best thought of as DrawVehicleOccupantHitPoint)
simulated function DrawDriverPointSphere()
{
    local ROVehicle       V;
    local ROVehicleWeapon VW;
    local Coords          CO;
    local vector          Loc;
    local int             i;

    foreach DynamicActors(class'ROVehicle', V)
    {
        if (V != none)
        {
            for (i = 0; i < V.VehHitpoints.Length; ++i)
            {
                if (V.VehHitpoints[i].HitPointType == HP_Driver && V.VehHitpoints[i].PointBone != '')
                {
                    CO = V.GetBoneCoords(V.VehHitpoints[i].PointBone);
                    Loc = CO.Origin + (V.VehHitpoints[i].PointHeight * V.VehHitpoints[i].PointScale * CO.XAxis);
                    Loc = Loc + (V.VehHitpoints[i].PointOffset >> V.Rotation);
                    V.DrawDebugSphere(Loc, V.VehHitpoints[i].PointRadius * V.VehHitpoints[i].PointScale, 10, 0, 255, 0);
                }
            }
        }
    }

    foreach DynamicActors(class'ROVehicleWeapon', VW)
    {
        if (VW != none)
        {
            for (i = 0; i < VW.VehHitpoints.Length; ++i)
            {
                if (VW.VehHitpoints[i].PointBone != '')
                {
                    CO = VW.GetBoneCoords(VW.VehHitpoints[i].PointBone);
                    Loc = CO.Origin + (VW.VehHitpoints[i].PointHeight * VW.VehHitpoints[i].PointScale * CO.XAxis);
                    Loc = Loc + (VW.VehHitpoints[i].PointOffset >> rotator(CO.Xaxis));
                    VW.DrawDebugSphere(Loc, VW.VehHitpoints[i].PointRadius * VW.VehHitpoints[i].PointScale, 10, 0, 255, 0);
                }
            }
        }
    }
}

// Modified to include DHArmoredVehicle's special hit points & to use different colours for different types of hit point
// Engine is blue, ammo stores are red, gun traverse & pivot are gold, periscopes are pink, others are white
// (Badly named, but is an inherited function - best thought of as DrawVehicleHitPoints)
simulated function DrawVehiclePointSphere()
{
    local ROVehicle        V;
    local DHArmoredVehicle AV;
    local Coords           CO;
    local vector           Loc;
    local color            C;
    local int              i;

    foreach DynamicActors(class'ROVehicle', V)
    {
        if (V != none)
        {
            for (i = 0; i < V.VehHitpoints.Length; ++i)
            {
                if (V.VehHitpoints[i].HitPointType != HP_Driver && V.VehHitpoints[i].PointBone != '')
                {
                    CO = V.GetBoneCoords(V.VehHitpoints[i].PointBone);
                    Loc = CO.Origin + (V.VehHitpoints[i].PointHeight * V.VehHitpoints[i].PointScale * CO.XAxis);
                    Loc = Loc + (V.VehHitpoints[i].PointOffset >> V.Rotation);

                    if (V.VehHitpoints[i].HitPointType == HP_Engine)
                    {
                        C = BlueColor;
                    }
                    else if (V.VehHitpoints[i].HitPointType == HP_AmmoStore)
                    {
                        C = RedColor;
                    }
                    else
                    {
                        C = GrayColor;
                    }

                    V.DrawDebugSphere(Loc, V.VehHitpoints[i].PointRadius * V.VehHitpoints[i].PointScale, 10, C.R, C.G, C.B);
                }
            }

            AV = DHArmoredVehicle(V);

            if (AV != none)
            {
                for (i = 0; i < AV.NewVehHitpoints.Length; ++i)
                {
                    if (AV.NewVehHitpoints[i].PointBone != '')
                    {
                        CO = AV.GetBoneCoords(AV.NewVehHitpoints[i].PointBone);
                        Loc = CO.Origin + (AV.NewVehHitpoints[i].PointHeight * AV.NewVehHitpoints[i].PointScale * CO.XAxis);
                        Loc = Loc + (AV.NewVehHitpoints[i].PointOffset >> AV.Rotation);

                        if (AV.NewVehHitpoints[i].NewHitPointType == NHP_Traverse || AV.NewVehHitpoints[i].NewHitPointType == NHP_GunPitch)
                        {
                            C = GoldColor;
                        }
                        else if (AV.NewVehHitpoints[i].NewHitPointType == NHP_GunOptics || AV.NewVehHitpoints[i].NewHitPointType == NHP_PeriscopeOptics)
                        {
                            C = PurpleColor;
                        }
                        else
                        {
                            C = WhiteColor;
                        }

                        AV.DrawDebugSphere(Loc, AV.NewVehHitpoints[i].PointRadius * AV.NewVehHitpoints[i].PointScale, 10, C.R, C.G, C.B);
                    }
                }
            }
        }
    }
}

// Modified to avoid drawing the player's own collision in 1st person, as it screws up the view too much and serves no purpose
// Also to draw pawn's AuxCollisionCylinder (DHBulletWhipAttachment), instead of unnecessary whole body cylinder (it's just an optimisation, not an actual hit point)
// (Badly named, but is an inherited function - best thought of as DrawPlayerHitPoints)
simulated function DrawPointSphere()
{
    local ROPawn P;
    local coords CO;
    local vector Loc;
    local int    i;

    foreach DynamicActors(class'ROPawn', P)
    {
        if (P != none && ((P != PawnOwner && P.Owner != PawnOwner) || PlayerOwner.bBehindView)) // only draw player's own collision if he's in behind view
        {
            if (P.AuxCollisionCylinder != none && P.AuxCollisionCylinder.bCollideActors) // don't draw AuxCollisionCylinder if it's collision is disabled
            {
                CO = P.GetBoneCoords(P.AuxCollisionCylinder.AttachmentBone);

                DrawDebugCylinder(CO.Origin, vect(1.0, 0.0, 0.0), vect(0.0, 1.0, 0.0), vect(0.0, 0.0, 1.0),
                    P.AuxCollisionCylinder.CollisionRadius, P.AuxCollisionCylinder.CollisionHeight, 10, 255, 255, 255); // white
            }

            for (i = 1; i < P.Hitpoints.Length; ++i) // skip Hitpoints[0], as that's just the big whole body cylinder (an optimisation) & not an actual hit point
            {
                if (P.Hitpoints[i].PointBone != '')
                {
                    CO = P.GetBoneCoords(P.Hitpoints[i].PointBone);
                    Loc = CO.Origin + (P.Hitpoints[i].PointOffset >> P.GetBoneRotation(P.Hitpoints[i].PointBone));

                    DrawDebugCylinder(Loc, CO.ZAxis, CO.YAxis, CO.XAxis, P.Hitpoints[i].PointRadius * P.Hitpoints[i].PointScale,
                        P.Hitpoints[i].PointHeight * P.Hitpoints[i].PointScale, 10, 0, 255, 0); // green
                }
            }
        }
    }
}

// New function showing all vehicle's physics wheels (the Wheels array of invisible wheels that drive & steer vehicle, even ones with treads)
simulated function DrawVehiclePhysiscsWheels()
{
    local ROVehicle V;
    local Coords    CO;
    local vector    Loc;
    local int       i;

    foreach DynamicActors(class'ROVehicle', V)
    {
        if (V != none)
        {
            for (i = 0; i < V.Wheels.Length; ++i)
            {
                if (V.Wheels[i].BoneName != '')
                {
                    CO = V.GetBoneCoords(V.Wheels[i].BoneName);
                    Loc = CO.Origin + (V.Wheels[i].BoneOffset >> V.Rotation);
                    V.DrawDebugSphere(Loc, V.Wheels[i].WheelRadius, 10, 255, 255, 255); // white
                }
            }
        }
    }
}

simulated function DrawMap(Canvas C, AbsoluteCoordsInfo SubCoords)
{
    local int                       i, Pos, OwnerTeam, Distance;
    local Actor                     A;
    local Controller                P;
    local float                     MyMapScale, PawnRotation, ArrowRotation;
    local vector                    Temp, MapCenter;
    local ROVehicleWeaponPawn       WeaponPawn;
    local Vehicle                   V;
    local Actor                     NetActor;
    local Pawn                      NetPawn;
    local DHPawn                    DHP;
    local SpriteWidget              Widget;
    local string                    S, DistanceString;
    local DHPlayer                  Player;
    local DHRoleInfo                RI;
    local DHPlayerReplicationInfo   PRI;

    if (DHGRI == none)
    {
        return;
    }

    // Get player team - if none, we won't draw team-specific information on the map
    if (PlayerOwner != none)
    {
        OwnerTeam = PlayerOwner.GetTeamNum();
    }
    else
    {
        OwnerTeam = 255;
    }

    // Get player
    Player = DHPlayer(PlayerOwner);

    // Draw level map
    MapLevelImage.WidgetTexture = DHGRI.MapImage;

    if (MapLevelImage.WidgetTexture != none)
    {
        // Set the texture coords to support the size of the image and not rely on defaultproperties
        MapLevelImage.TextureCoords.X2 = MapLevelImage.WidgetTexture.MaterialUSize() - 1;
        MapLevelImage.TextureCoords.Y2 = MapLevelImage.WidgetTexture.MaterialVSize() - 1;

        DrawSpriteWidgetClipped(C, MapLevelImage, SubCoords, true);
    }

    // Draw level map overlay
    MapLevelOverlay.WidgetTexture = Material'DH_GUI_Tex.GUI.GridOverlay';

    if (MapLevelOverlay.WidgetTexture != none)
    {
        DrawSpriteWidgetClipped(C, MapLevelOverlay, subCoords, true);
    }

    // Calculate level map constants
    Temp = DHGRI.SouthWestBounds - DHGRI.NorthEastBounds;
    MapCenter = Temp / 2.0  + DHGRI.NorthEastBounds;
    MyMapScale = Abs(Temp.X);

    if (MyMapScale ~= 0.0)
    {
        MyMapScale = 1.0; // just so we never get divisions by 0
    }

    // Set the font to be used to draw objective text
    C.Font = GetSmallMenuFont(C);

    // Draw resupply areas
    for (i = 0; i < arraycount(DHGRI.ResupplyAreas); ++i)
    {
        if (!DHGRI.ResupplyAreas[i].bActive || (DHGRI.ResupplyAreas[i].Team != OwnerTeam && DHGRI.ResupplyAreas[i].Team != NEUTRAL_TEAM_INDEX))
        {
            continue;
        }

        if (DHGRI.ResupplyAreas[i].ResupplyType == 1)
        {
            // Tank resupply icon
            DrawIconOnMap(C, SubCoords, MapIconVehicleResupply, MyMapScale, DHGRI.ResupplyAreas[i].ResupplyVolumeLocation, MapCenter);
        }
        else
        {
            // Player resupply icon
            DrawIconOnMap(C, SubCoords, MapIconResupply, MyMapScale, DHGRI.ResupplyAreas[i].ResupplyVolumeLocation, MapCenter);
        }
    }

    if (Level.NetMode == NM_Standalone && bShowDebugInfoOnMap)
    {
        // PSYONIX: DEBUG - Show all vehicles on map who have no driver
        foreach DynamicActors(class'Vehicle', V)
        {
            Widget = MapIconRally[V.GetTeamNum()];
            Widget.TextureScale = 0.04;

            if (V.Health <= 0)
            {
                Widget.RenderStyle = STY_Translucent;
            }
            else
            {
                Widget.RenderStyle = STY_Normal;
            }

            // Empty vehicle
            if (Bot(V.Controller) == none && ROWheeledVehicle(V) != none && V.NumPassengers() == 0)
            {
                DrawDebugIconOnMap(C, SubCoords, Widget, MyMapScale, V.Location, MapCenter, "");
            }
            // Vehicle
            else if (VehicleWeaponPawn(V) == none && V.Controller != none)
            {
                DrawDebugIconOnMap(C, SubCoords, Widget, MyMapScale, V.Location, MapCenter, Left(Bot(V.Controller).Squad.GetOrders(), 1) @ V.NumPassengers());
            }
        }

        // PSYONIX: DEBUG - Show all players on map and indicate orders
        for (P = Level.ControllerList; P != none; P = P.NextController)
        {
            if (Bot(P) != none && ROVehicle(P.Pawn) == none)
            {
                Widget = MapIconTeam[P.GetTeamNum()];
                Widget.TextureScale = 0.025;

                DrawDebugIconOnMap(C, SubCoords, Widget, MyMapScale, P.Pawn.Location, MapCenter, Left(Bot(P).Squad.GetOrders(), 1));
            }
        }
    }

    if ((Level.NetMode == NM_Standalone || DHGRI.bAllowNetDebug) && bShowRelevancyDebugOnMap)
    {
        if (NetDebugMode == ND_All)
        {
            foreach DynamicActors(class'Actor', NetActor)
            {
                if (!NetActor.bStatic && !NetActor.bNoDelete)
                {
                    Widget = MapIconNeutral;
                    Widget.TextureScale = 0.04;
                    Widget.RenderStyle = STY_Normal;
                    DrawDebugIconOnMap(C, SubCoords, Widget, MyMapScale, NetActor.Location, MapCenter, "");
                }
            }
        }
        else if (NetDebugMode == ND_VehiclesOnly)
        {
            // PSYONIX: DEBUG - Show all vehicles on map who have no driver
            foreach DynamicActors(class'Vehicle', V)
            {
                Widget = MapIconRally[V.GetTeamNum()];
                Widget.TextureScale = 0.04;
                Widget.RenderStyle = STY_Normal;

                if (ROWheeledVehicle(V) != none)
                {
                    DrawDebugIconOnMap(C, SubCoords, Widget, MyMapScale, V.Location, MapCenter, "");
                }
            }
        }
        else if (NetDebugMode == ND_PlayersOnly)
        {
            foreach DynamicActors(class'DHPawn', DHP)
            {
                Widget = MapIconTeam[DHP.GetTeamNum()];
                Widget.TextureScale = 0.04;
                Widget.RenderStyle = STY_Normal;

                DrawDebugIconOnMap(C, SubCoords, Widget, MyMapScale, DHP.Location, MapCenter, "");
            }
        }
        else if (NetDebugMode == ND_PawnsOnly)
        {
            foreach DynamicActors(class'Pawn', NetPawn)
            {
                if (Vehicle(NetPawn) != none)
                {
                    Widget = MapIconRally[V.GetTeamNum()];
                }
                else if (ROPawn(NetPawn) != none)
                {
                    Widget = MapIconTeam[NetPawn.GetTeamNum()];
                }
                else
                {
                    Widget = MapIconNeutral;
                }

                Widget.TextureScale = 0.04;
                Widget.RenderStyle = STY_Normal;

                DrawDebugIconOnMap(C, SubCoords, Widget, MyMapScale, NetPawn.Location, MapCenter, "");
            }
        }
        if (NetDebugMode == ND_AllWithText)
        {
            foreach DynamicActors(class'Actor', NetActor)
            {
                if (!NetActor.bStatic && !NetActor.bNoDelete)
                {
                    Widget = MapIconNeutral;
                    Widget.TextureScale = 0.04;
                    Widget.RenderStyle = STY_Normal;

                    S = "" $ NetActor;

                    // Remove the package name, if it exists
                    Pos = InStr(s, ".");

                    if (Pos != -1)
                    {
                        s = Mid(s, Pos + 1);
                    }

                    DrawDebugIconOnMap(C, SubCoords, Widget, MyMapScale, NetActor.Location, MapCenter, s);
                }
            }
        }
    }

    if (Player != none)
    {
        // Draw the marked arty strike
        Temp = Player.SavedArtilleryCoords;

        if (Temp != vect(0.0, 0.0, 0.0))
        {
            Widget = MapIconArtyStrike;
            Widget.Tints[0].A = 125;
            Widget.Tints[1].A = 125;
            DrawIconOnMap(C, SubCoords, Widget, MyMapScale, Temp, MapCenter);
        }

        // Draw the destroyable/destroyed targets
        if (Player.Destroyables.Length != 0)
        {
            for (i = 0; i < Player.Destroyables.Length; ++i)
            {
                if (Player.Destroyables[i].bHidden || Player.Destroyables[i].bDamaged)
                {
                    DrawIconOnMap(C, SubCoords, MapIconDestroyedItem, MyMapScale, Player.Destroyables[i].Location, MapCenter);
                }
                else
                {
                    DrawIconOnMap(C, SubCoords, MapIconDestroyableItem, MyMapScale, Player.Destroyables[i].Location, MapCenter);
                }
            }
        }
    }

    if (OwnerTeam != 255)
    {
        PRI = DHPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);

        // Get Role info
        if (PRI != none)
        {
            RI = DHRoleInfo(PRI.RoleInfo);
        }

        // Draw the in-progress arty strikes
        if ((OwnerTeam == AXIS_TEAM_INDEX || OwnerTeam == ALLIES_TEAM_INDEX) && DHGRI.ArtyStrikeLocation[OwnerTeam] != vect(0.0, 0.0, 0.0))
        {
            DrawIconOnMap(C, SubCoords, MapIconArtyStrike, MyMapScale, DHGRI.ArtyStrikeLocation[OwnerTeam], MapCenter);
        }

        // Draw the rally points
        for (i = 0; i < arraycount(DHGRI.AxisRallyPoints); ++i)
        {
            if (OwnerTeam == AXIS_TEAM_INDEX)
            {
                Temp = DHGRI.AxisRallyPoints[i].RallyPointLocation;
            }
            else if (OwnerTeam == ALLIES_TEAM_INDEX)
            {
                Temp = DHGRI.AlliedRallyPoints[i].RallyPointLocation;
            }

            // Draw the marked rally point
            if (Temp != vect(0.0, 0.0, 0.0))
            {
                DrawIconOnMap(C, SubCoords, MapIconRally[OwnerTeam], MyMapScale, Temp, MapCenter);
            }
        }

        // Draw Artillery Radio Icons
        if (OwnerTeam == AXIS_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.AxisRadios); ++i)
            {
                if (DHGRI.AxisRadios[i] == none || (DHGRI.AxisRadios[i].IsA('DHArtilleryTrigger') && !DHArtilleryTrigger(DHGRI.AxisRadios[i]).bShouldShowOnSituationMap))
                {
                    continue;
                }

                DrawIconOnMap(C, SubCoords, MapIconRadio, MyMapScale, DHGRI.AxisRadios[i].Location, MapCenter);
            }
        }
        else if (OwnerTeam == ALLIES_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.AlliedRadios); ++i)
            {
                if (DHGRI.AlliedRadios[i] == none || (DHGRI.AlliedRadios[i].IsA('DHArtilleryTrigger') && !DHArtilleryTrigger(DHGRI.AlliedRadios[i]).bShouldShowOnSituationMap))
                {
                    continue;
                }

                DrawIconOnMap(C, SubCoords, MapIconRadio, MyMapScale, DHGRI.AlliedRadios[i].Location, MapCenter);
            }
        }

        // Draw player-carried Artillery radio icons if player is an artillery officer
        if (RI != none && RI.bIsArtilleryOfficer)
        {
            if (OwnerTeam == AXIS_TEAM_INDEX)
            {
                for (i = 0; i < arraycount(DHGRI.CarriedAxisRadios); ++i)
                {
                    if (DHGRI.CarriedAxisRadios[i] == none)
                    {
                        continue;
                    }

                    DrawIconOnMap(C, SubCoords, MapIconCarriedRadio, MyMapScale, DHGRI.CarriedAxisRadios[i].Location, MapCenter);
                }
            }
            else if (OwnerTeam == ALLIES_TEAM_INDEX)
            {
                for (i = 0; i < arraycount(DHGRI.CarriedAlliedRadios); ++i)
                {
                    if (DHGRI.CarriedAlliedRadios[i] == none)
                    {
                        continue;
                    }

                    DrawIconOnMap(C, SubCoords, MapIconCarriedRadio, MyMapScale, DHGRI.CarriedAlliedRadios[i].Location, MapCenter);
                }
            }
        }

        // Draw help requests
        if (OwnerTeam == AXIS_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.AxisHelpRequests); ++i)
            {
                if (DHGRI.AxisHelpRequests[i].requestType == 255)
                {
                    continue;
                }

                switch (DHGRI.AxisHelpRequests[i].requestType)
                {
                    case 0: // help request at objective
                        Widget = MapIconHelpRequest;
                        Widget.Tints[0].A = 125;
                        Widget.Tints[1].A = 125;
                        DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[DHGRI.AxisHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 1: // attack request
                    case 2: // defend request
                        DrawIconOnMap(C, SubCoords, MapIconAttackDefendRequest, MyMapScale, DHGRI.DHObjectives[DHGRI.AxisHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 3: // mg resupply requests
                        DrawIconOnMap(C, SubCoords, MapIconMGResupplyRequest[AXIS_TEAM_INDEX], MyMapScale, DHGRI.AxisHelpRequestsLocs[i], MapCenter);
                        break;

                    case 4: // help request at coords
                        DrawIconOnMap(C, SubCoords, MapIconHelpRequest, MyMapScale, DHGRI.AxisHelpRequestsLocs[i], MapCenter);
                        break;

                    default:
                        Log("Unknown requestType found in AxisHelpRequests[" $ i $ "]:" @ DHGRI.AxisHelpRequests[i].requestType);
                }
            }

            // Draw all mortar targets on the map
            if (RI != none && (RI.bIsMortarObserver || RI.bCanUseMortars))
            {
                for (i = 0; i < arraycount(DHGRI.GermanMortarTargets); ++i)
                {
                    if (DHGRI.GermanMortarTargets[i].bIsActive)
                    {
                        if (DHGRI.GermanMortarTargets[i].HitLocation.X != 0.0 &&
                            DHGRI.GermanMortarTargets[i].HitLocation.Y != 0.0 &&
                            DHGRI.GermanMortarTargets[i].HitLocation.Z == 0.0)
                        {
                            // Colin: Mortar targets have an arrow that points in the
                            // direction of player's mortar hit.
                            Temp = Normal(DHGRI.GermanMortarTargets[i].Location - DHGRI.GermanMortarTargets[i].HitLocation);
                            ArrowRotation = class'DHLib'.static.RadiansToUnreal(Atan(Temp.X, Temp.Y));
                            ArrowRotation -= class'DHLib'.static.DegreesToUnreal(DHGRI.OverheadOffset);
                            TexRotator(FinalBlend(MapIconMortarArrow.WidgetTexture).Material).Rotation.Yaw = ArrowRotation;

                            DrawIconOnMap(C, SubCoords, MapIconMortarArrow, MyMapScale, DHGRI.GermanMortarTargets[i].Location, MapCenter);
                        }

                        if (RI.bCanUseMortars && PlayerOwner.Pawn != none)
                        {
                            Distance = int(class'DHLib'.static.UnrealToMeters(VSize(PlayerOwner.Pawn.Location - DHGRI.GermanMortarTargets[i].Location)));
                            Distance = (Distance / 5) * 5;  // round to the nearest 5 meters
                            DistanceString = string(Distance) @ "m";
                        }

                        if (DHGRI.GermanMortarTargets[i].bIsSmoke)
                        {
                            DrawIconOnMap(C, SubCoords, MapIconMortarSmokeTarget, MyMapScale, DHGRI.GermanMortarTargets[i].Location, MapCenter,, DistanceString);
                        }
                        else
                        {
                            DrawIconOnMap(C, SubCoords, MapIconMortarHETarget, MyMapScale, DHGRI.GermanMortarTargets[i].Location, MapCenter,, DistanceString);
                        }

                        // Draw hit location
                        if (DHGRI.GermanMortarTargets[i].HitLocation.Z != 0.0)
                        {
                            DrawIconOnMap(C, SubCoords, MapIconMortarHit, MyMapScale, DHGRI.GermanMortarTargets[i].HitLocation, MapCenter);
                        }
                    }
                }
            }
        }
        else if (OwnerTeam == ALLIES_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.AlliedHelpRequests); ++i)
            {
                if (DHGRI.AlliedHelpRequests[i].requestType == 255)
                {
                    continue;
                }

                switch (DHGRI.AlliedHelpRequests[i].requestType)
                {
                    case 0: // help request at objective
                        Widget = MapIconHelpRequest;
                        Widget.Tints[0].A = 125;
                        Widget.Tints[1].A = 125;
                        DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[DHGRI.AlliedHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 1: // attack request
                    case 2: // defend request
                        DrawIconOnMap(C, SubCoords, MapIconAttackDefendRequest, MyMapScale, DHGRI.DHObjectives[DHGRI.AlliedHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 3: // mg resupply requests
                        DrawIconOnMap(C, SubCoords, MapIconMGResupplyRequest[ALLIES_TEAM_INDEX], MyMapScale, DHGRI.AlliedHelpRequestsLocs[i], MapCenter);
                        break;

                    case 4: // help request at coords
                        DrawIconOnMap(C, SubCoords, MapIconHelpRequest, MyMapScale, DHGRI.AlliedHelpRequestsLocs[i], MapCenter);
                        break;

                    default:
                        Log("Unknown requestType found in AlliedHelpRequests[" $ i $ "]:" @ DHGRI.AlliedHelpRequests[i].requestType);
                }
            }

            // Draw all mortar targets on the map
            if (RI != none && (RI.bIsMortarObserver || RI.bCanUseMortars))
            {
                for (i = 0; i < arraycount(DHGRI.AlliedMortarTargets); ++i)
                {
                    if (DHGRI.AlliedMortarTargets[i].bIsActive)
                    {
                        if (DHGRI.AlliedMortarTargets[i].HitLocation.X != 0.0 &&
                            DHGRI.AlliedMortarTargets[i].HitLocation.Y != 0.0 &&
                            DHGRI.AlliedMortarTargets[i].HitLocation.Z == 0.0)
                        {
                            // Colin: Mortar targets have an arrow that points in the
                            // direction of player's mortar hit.
                            Temp = Normal(DHGRI.AlliedMortarTargets[i].Location - DHGRI.AlliedMortarTargets[i].HitLocation);
                            ArrowRotation = class'DHLib'.static.RadiansToUnreal(Atan(Temp.X, Temp.Y));
                            ArrowRotation -= class'DHLib'.static.DegreesToUnreal(DHGRI.OverheadOffset);
                            TexRotator(FinalBlend(MapIconMortarArrow.WidgetTexture).Material).Rotation.Yaw = ArrowRotation;

                            DrawIconOnMap(C, SubCoords, MapIconMortarArrow, MyMapScale, DHGRI.AlliedMortarTargets[i].Location, MapCenter);
                        }

                        if (RI.bCanUseMortars && PlayerOwner.Pawn != none)
                        {
                            Distance = int(class'DHLib'.static.UnrealToMeters(VSize(PlayerOwner.Pawn.Location - DHGRI.AlliedMortarTargets[i].Location)));
                            Distance = (Distance / 5) * 5;  // round to the nearest 5 meters
                            DistanceString = string(Distance) @ "m";
                        }

                        if (DHGRI.AlliedMortarTargets[i].bIsSmoke)
                        {
                            DrawIconOnMap(C, SubCoords, MapIconMortarSmokeTarget, MyMapScale, DHGRI.AlliedMortarTargets[i].Location, MapCenter,, DistanceString);
                        }
                        else
                        {
                            DrawIconOnMap(C, SubCoords, MapIconMortarHETarget, MyMapScale, DHGRI.AlliedMortarTargets[i].Location, MapCenter,, DistanceString);
                        }

                        // Draw hit location
                        if (DHGRI.AlliedMortarTargets[i].HitLocation.Z != 0.0)
                        {
                            DrawIconOnMap(C, SubCoords, MapIconMortarHit, MyMapScale, DHGRI.AlliedMortarTargets[i].HitLocation, MapCenter);
                        }
                    }
                }
            }
        }
    }

    // Draw objectives
    for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
    {
        if (DHGRI.DHObjectives[i] == none)
        {
            continue;
        }

        // Set up icon info
        if (DHGRI.DHObjectives[i].ObjState == OBJ_Axis)
        {
            Widget = MapAxisFlagIcon;
        }
        else if (DHGRI.DHObjectives[i].ObjState == OBJ_Allies)
        {
            Widget = MapAlliesFlagIcons[DHGRI.AlliedNationID];
        }
        else
        {
            Widget = MapIconNeutral;
        }

        if (!DHGRI.DHObjectives[i].bActive)
        {
            Widget.Tints[0] = GrayColor;
            Widget.Tints[1] = GrayColor;
            Widget.Tints[0].A = 50;
            Widget.Tints[1].A = 125;
        }
        else
        {
            Widget.Tints[0] = WhiteColor;
            Widget.Tints[1] = WhiteColor;
        }

        // Draw flashing icon if objective is disputed
        if (DHGRI.DHObjectives[i].CompressedCapProgress != 0 && DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
        {
            if (DHGRI.DHObjectives[i].CompressedCapProgress == 1 || DHGRI.DHObjectives[i].CompressedCapProgress == 2)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 2, DHGRI.DHObjectives[i].ObjName, DHGRI, i);
            }
            else if (DHGRI.DHObjectives[i].CompressedCapProgress == 3 || DHGRI.DHObjectives[i].CompressedCapProgress == 4)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 3, DHGRI.DHObjectives[i].ObjName, DHGRI, i);
            }
            else
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 1, DHGRI.DHObjectives[i].ObjName, DHGRI, i);
            }
        }
        else
        {
            DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 1, DHGRI.DHObjectives[i].ObjName, DHGRI, i);
        }

        // If the objective isn't completely captured, overlay a flashing icon from other team
        if (DHGRI.DHObjectives[i].CompressedCapProgress != 0 && DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
        {
            if (DHGRI.DHObjectives[i].CurrentCapTeam == ALLIES_TEAM_INDEX)
            {
                Widget = MapIconDispute[ALLIES_TEAM_INDEX];
            }
            else
            {
                Widget = MapIconDispute[AXIS_TEAM_INDEX];
            }

            if (DHGRI.DHObjectives[i].CompressedCapProgress == 1 || DHGRI.DHObjectives[i].CompressedCapProgress == 2)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 4);
            }
            else if (DHGRI.DHObjectives[i].CompressedCapProgress == 3 || DHGRI.DHObjectives[i].CompressedCapProgress == 4)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 5);
            }
        }
    }

    // Get player actor
    if (PawnOwner != none)
    {
        A = PawnOwner;
    }
    else if (PlayerOwner.IsInState('Spectating'))
    {
        A = PlayerOwner;
    }
    else if (PlayerOwner.Pawn != none)
    {
        A = PlayerOwner.Pawn;
    }

    // Fix for frelled rotation on weapon pawns
    WeaponPawn = ROVehicleWeaponPawn(A);

    if (WeaponPawn != none)
    {
        Player = DHPlayer(WeaponPawn.Controller);

        if (Player != none && WeaponPawn.VehicleBase != none)
        {
            PawnRotation = -Player.CalcViewRotation.Yaw;
        }
        else if (WeaponPawn.VehicleBase != none)
        {
            PawnRotation = -WeaponPawn.VehicleBase.Rotation.Yaw;
        }
        else
        {
            PawnRotation = -A.Rotation.Yaw;
        }
    }
    else if (A != none)
    {
        PawnRotation = -A.Rotation.Yaw;
    }

    // Draw the map scale indicator
    //MapScaleText.text = "Grid Square: ~" $ string(int(class'DHLib'.static.UnrealToMeters(Abs(DHGRI.NorthEastBounds.X - DHGRI.SouthWestBounds.X)) / 9.0)) $ "m";
    //DrawTextWidgetClipped(C, MapScaleText, subCoords);

    // Draw player icon
    if (A != none)
    {
        // Set proper icon rotation
        if (DHGRI.OverheadOffset == 90)
        {
            TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = PawnRotation - 32768;
        }
        else if (DHGRI.OverheadOffset == 180)
        {
            TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = PawnRotation - 49152;
        }
        else if (DHGRI.OverheadOffset == 270)
        {
            TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = PawnRotation;
        }
        else
        {
            TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = PawnRotation - 16384;
        }

        // Draw the player icon
        DrawIconOnMap(C, SubCoords, MapPlayerIcon, MyMapScale, A.Location, MapCenter);
    }

    // Overhead map debugging
    if (Level.NetMode == NM_Standalone && ROTeamGame(Level.Game).LevelInfo.bDebugOverhead)
    {
        DrawIconOnMap(C, SubCoords, MapIconTeam[ALLIES_TEAM_INDEX], MyMapScale, DHGRI.NorthEastBounds, MapCenter);
        DrawIconOnMap(C, SubCoords, MapIconTeam[AXIS_TEAM_INDEX], MyMapScale, DHGRI.SouthWestBounds, MapCenter);
    }
}

// Renders the objectives on the HUD similar to the scoreboard
simulated function DrawObjectives(Canvas C)
{
    local DHPlayerReplicationInfo PRI;
    local AbsoluteCoordsInfo      MapCoords, SubCoords;
    local SpriteWidget  Widget;
    local DHPlayer      Player;
    local int           i, j, OwnerTeam, ObjCount, SecondaryObjCount;
    local bool          bShowRally;
    local bool          bShowArtillery;
    local bool          bShowResupply;
    local bool          bShowArtyCoords;
    local bool          bShowNeutralObj;
    local bool          bShowMGResupplyRequest;
    local bool          bShowHelpRequest;
    local bool          bShowAttackDefendRequest;
    local bool          bShowArtyStrike;
    local bool          bShowDestroyableItems;
    local bool          bShowDestroyedItems;
    local bool          bShowVehicleResupply;
    local bool          bHasSecondaryObjectives;
    local float         XL, YL, YL_one, Time;
    // PSYONIX: DEBUG
    local float         X, Y, StrX, StrY;
    local string        s;
    // AT Gun
    local bool          bShowATGun;
    local DHRoleInfo    RI;

    // Avoid access none if DHGRI isn't set yet
    if (DHGRI == none)
    {
        return;
    }

    // Update time
    if (!DHGRI.bMatchHasBegun)
    {
        CurrentTime = Max(0, DHGRI.RoundStartTime + DHGRI.PreStartTime - DHGRI.ElapsedTime);
    }
    else
    {
        CurrentTime = Max(0, DHGRI.RoundEndTime - DHGRI.ElapsedTime);
    }

    // Get player
    Player = DHPlayer(PlayerOwner);

    // Get PRI
    PRI = DHPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);

    // Get Role info
    if (PRI != none && PRI.RoleInfo != none)
    {
        RI = DHRoleInfo(PRI.RoleInfo);
    }

    // Get player team - if none, we won't draw team-specific information on the map
    if (PlayerOwner != none)
    {
        OwnerTeam = PlayerOwner.GetTeamNum();
    }
    else
    {
        OwnerTeam = 255;
    }

    // Set map coords based on resolution - we want to keep a 4:3 aspect ratio for the map
    MapCoords.Height = C.ClipY * 0.9;
    MapCoords.PosY = C.ClipY * 0.05;
    MapCoords.Width = MapCoords.Height * 4.0 / 3.0;
    MapCoords.PosX = (C.ClipX - MapCoords.Width) / 2.0;

    // Calculate map offset (for animation)
    if (bAnimateMapIn)
    {
        AnimateMapCurrentPosition -= (Level.TimeSeconds - HudLastRenderTime) / AnimateMapSpeed;

        if (AnimateMapCurrentPosition <= 0.0)
        {
            AnimateMapCurrentPosition = 0.0;
            bAnimateMapIn = false;
        }
    }
    else if (bAnimateMapOut)
    {
        AnimateMapCurrentPosition += (Level.TimeSeconds - HudLastRenderTime) / AnimateMapSpeed;

        if (AnimateMapCurrentPosition >= default.AnimateMapCurrentPosition)
        {
            AnimateMapCurrentPosition = default.AnimateMapCurrentPosition;
            bAnimateMapOut = false;
        }
    }

    MapCoords.PosX += C.ClipX * AnimateMapCurrentPosition;

    // Draw map background
    DrawSpriteWidgetClipped(C, MapBackground, MapCoords, true);

    // Calculate absolute coordinates of level map
    GetAbsoluteCoordinatesAlt(MapCoords, MapLegendImageCoords, SubCoords);
    MapLevelImageCoordinates = SubCoords; // save coordinates for use in menu page

    // Draw coordinates text on sides of the map
    for (i = 0; i < 9; ++i)
    {
        MapCoordTextXWidget.PosX = (Float(i) + 0.5) / 9.0;
        MapCoordTextXWidget.Text = MapCoordTextX[i];
        DrawTextWidgetClipped(C, MapCoordTextXWidget, SubCoords);

        MapCoordTextYWidget.PosY = MapCoordTextXWidget.PosX;
        MapCoordTextYWidget.Text = MapCoordTextY[i];
        DrawTextWidgetClipped(C, MapCoordTextYWidget, SubCoords);
    }

    // Draw the overhead map
    DrawMap(C, SubCoords);

    // Draw the timer legend
    DrawTextWidgetClipped(C, MapTimerTitle, MapCoords, XL, YL, YL_one);

    // Calculate seconds & minutes
    Time = CurrentTime;
    MapTimerTexts[3].Text = string(Int(Time % 10.0));
    Time /= 10.0;
    MapTimerTexts[2].Text = string(Int(Time % 6.0));
    Time /= 6.0;
    MapTimerTexts[1].Text = string(Int(Time % 10.0));
    Time /= 10.0;
    MapTimerTexts[0].Text = string(Int(Time));

    C.Font = GetFontSizeIndex(C, -2);

    // Draw the time
    for (i = 0; i < 4; ++i)
    {
        DrawTextWidgetClipped(C, MapTimerTexts[i], MapCoords, XL, YL, YL_one);
    }

    C.Font = GetSmallMenuFont(C);

    // Calc legend coords
    GetAbsoluteCoordinatesAlt(MapCoords, MapLegendCoords, SubCoords);

    // Draw legend title
    DrawTextWidgetClipped(C, MapLegendTitle, SubCoords, XL, YL, YL_one);

    // Draw legend elements
    LegendItemsIndex = 2; // no item at position #0 and #1 (reserved for title)

    DrawLegendElement(C, SubCoords, MapAxisFlagIcon, LegendAxisObjectiveText);
    DrawLegendElement(C, SubCoords, MapAlliesFlagIcons[DHGRI.AlliedNationID], LegendAlliesObjectiveText);

    // Draw objectives
    for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
    {
        if (DHGRI.DHObjectives[i] != none &&
            DHGRI.DHObjectives[i].ObjState == OBJ_Neutral)
        {
            bShowNeutralObj = true;
            break;
        }
    }

    if (bShowNeutralObj || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconNeutral, LegendNeutralObjectiveText);
    }

    // Artillery
    if (OwnerTeam == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.AxisRadios); ++i)
        {
            if (DHGRI.AxisRadios[i] != none && (!DHGRI.AxisRadios[i].IsA('DHArtilleryTrigger') || DHArtilleryTrigger(DHGRI.AxisRadios[i]).bShouldShowOnSituationMap))
            {
                bShowArtillery = true;
                break;
            }
        }
    }
    else if (OwnerTeam == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.AlliedRadios); ++i)
        {
            if (DHGRI.AlliedRadios[i] != none && (!DHGRI.AlliedRadios[i].IsA('DHArtilleryTrigger') || DHArtilleryTrigger(DHGRI.AlliedRadios[i]).bShouldShowOnSituationMap))
            {
                bShowArtillery = true;
                break;
            }
        }
    }

    // Draw player-carried Artillery radio icons if player is an artillery officer
    if (RI != none && RI.bIsArtilleryOfficer)
    {
        if (OwnerTeam == AXIS_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.CarriedAxisRadios); ++i)
            {
                if (DHGRI.CarriedAxisRadios[i] != none)
                {
                    bShowArtillery = true;
                    break;
                }

            }
        }
        else if (OwnerTeam == ALLIES_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.CarriedAlliedRadios); ++i)
            {
                if (DHGRI.CarriedAlliedRadios[i] != none)
                {
                    bShowArtillery = true;
                    break;
                }
            }
        }
    }

    if (bShowArtillery || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconRadio, LegendArtilleryRadioText);
    }

    if ((bShowArtillery || bShowAllItemsInMapLegend) && RI.bIsArtilleryOfficer)
    {
        DrawLegendElement(C, SubCoords, MapIconCarriedRadio, LegendCarriedArtilleryRadioText);
    }

    if (bShowResupply || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconResupply, LegendResupplyAreaText);
    }

    // Resupply
    for (i = 0; i < arraycount(DHGRI.ResupplyAreas); ++i)
    {
        if (DHGRI.ResupplyAreas[i].bActive && (DHGRI.ResupplyAreas[i].Team == OwnerTeam || DHGRI.ResupplyAreas[i].Team == NEUTRAL_TEAM_INDEX))
        {
            if (DHGRI.ResupplyAreas[i].ResupplyType == 1)
            {
                // Tank resupply icon
                bShowVehicleResupply = true;
            }
            else
            {
                // Player resupply icon
                bShowResupply = true;
            }
        }
    }

    if (bShowVehicleResupply)
    {
        DrawLegendElement(C, SubCoords, MapIconVehicleResupply, LegendResupplyAreaText);
    }

    // Rally Points
    for (i = 0; i < arraycount(DHGRI.AxisRallyPoints); ++i)
    {
        if ((OwnerTeam == AXIS_TEAM_INDEX && DHGRI.AxisRallyPoints[i].RallyPointLocation != vect(0.0, 0.0, 0.0)) ||
            (OwnerTeam == ALLIES_TEAM_INDEX && DHGRI.AlliedRallyPoints[i].RallyPointLocation != vect(0.0, 0.0, 0.0)))
        {
            bShowRally = true;
            break;
        }
    }

    if ((bShowRally || bShowAllItemsInMapLegend) && OwnerTeam != 255)
    {
        DrawLegendElement(C, SubCoords, MapIconRally[OwnerTeam], LegendRallyPointText);
    }

    // Artillery coords & destroyable items [?]
    if (Player != none)
    {
        // Draw the marked arty strike
        if (Player.SavedArtilleryCoords != vect(0.0, 0.0, 0.0))
        {
            bShowArtyCoords = true;
        }

        // Draw the destroyable/destroyed targets
        if (Player.Destroyables.Length != 0)
        {
            for (i = 0; i < Player.Destroyables.Length; ++i)
            {
                if (Player.Destroyables[i].bHidden || Player.Destroyables[i].bDamaged)
                {
                    bShowDestroyedItems = true;
                }
                else
                {
                    bShowDestroyableItems = true;
                }
            }
        }
    }

    if (bShowArtyCoords || bShowAllItemsInMapLegend)
    {
        Widget = MapIconArtyStrike;
        Widget.Tints[TeamIndex].A = 64;
        DrawLegendElement(C, SubCoords, Widget, LegendSavedArtilleryText);
        Widget.Tints[TeamIndex].A = 255;
    }


    // Artillery strike
    if ((OwnerTeam == AXIS_TEAM_INDEX || OwnerTeam == ALLIES_TEAM_INDEX) && DHGRI.ArtyStrikeLocation[OwnerTeam] != vect(0.0, 0.0, 0.0))
    {
        bShowArtyStrike = true;
    }

    if (bShowArtyStrike || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconArtyStrike, LegendArtyStrikeText);
    }

    if ((bShowMGResupplyRequest || bShowAllItemsInMapLegend) && OwnerTeam != 255)
    {
        DrawLegendElement(C, SubCoords, MapIconMGResupplyRequest[OwnerTeam], LegendMGResupplyText);
    }

    //Requests
    if (OwnerTeam == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.AxisHelpRequests); ++i)
        {
            switch (DHGRI.AxisHelpRequests[i].RequestType)
            {
                case 0: // help request at objective
                    bShowHelpRequest = true;
                    break;

                case 1: // attack request
                case 2: // defend request
                    bShowAttackDefendRequest = true;
                    break;

                case 3: // mg resupply requests
                    bShowMGResupplyRequest = true;
                    break;

                case 4: // help request at coords
                    bShowHelpRequest = true;
                    break;

                default:
                    break;
            }
        }
    }
    else if (OwnerTeam == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHGRI.AlliedHelpRequests); ++i)
        {
            switch (DHGRI.AlliedHelpRequests[i].RequestType)
            {
                case 0: // help request at objective
                    bShowHelpRequest = true;
                    break;

                case 1: // attack request
                case 2: // defend request
                    bShowAttackDefendRequest = true;
                    break;

                case 3: // mg resupply requests
                    bShowMGResupplyRequest = true;
                    break;

                case 4: // help request at coords
                    bShowHelpRequest = true;
                    break;

                default:
                    break;
            }
        }
    }

    if (bShowHelpRequest || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconHelpRequest, LegendHelpRequestText);
    }

    if (bShowAttackDefendRequest || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconAttackDefendRequest, LegendOrderTargetText);
    }

    if (bShowDestroyableItems || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconDestroyableItem, LegendDestroyableItemText);
    }

    if (bShowDestroyedItems || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconDestroyedItem, LegendDestroyedItemText);
    }

    if (bShowATGun)
    {
        DrawLegendElement(C, SubCoords, MapIconATGun, LegendATGunText);
    }

    // Calc objective text box coords
    GetAbsoluteCoordinatesAlt(MapCoords, MapObjectivesCoords, SubCoords);

    // See if there are any secondary objectives
    for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
    {
        if (DHGRI.DHObjectives[i] == none || !DHGRI.DHObjectives[i].bActive)
        {
            continue;
        }

        if (!DHGRI.DHObjectives[i].bRequired)
        {
            bHasSecondaryObjectives = true;
            break;
        }
    }

    // Draw objective text box header
    if (bHasSecondaryObjectives)
    {
        DrawTextWidgetClipped(C, MapRequiredObjectivesTitle, SubCoords, XL, YL, YL_one);
    }
    else
    {
        DrawTextWidgetClipped(C, MapObjectivesTitle, SubCoords, XL, YL, YL_one);
    }

    MapObjectivesTexts.OffsetY = 0;

    // Draw objective texts
    ObjCount = 1;
    C.Font = GetSmallMenuFont(C);

    // Modified so objectives don't draw off the situational map, it will show "and more..." if there are too many active
    for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
    {
        if (DHGRI.DHObjectives[i] == none || !DHGRI.DHObjectives[i].bActive || !DHGRI.DHObjectives[i].bRequired)
        {
            continue;
        }

        if (DHGRI.DHObjectives[i].ObjState != OwnerTeam)
        {
            if (DHGRI.DHObjectives[i].AttackerDescription == "")
            {
                MapObjectivesTexts.Text = ObjCount $ "." @ "Attack" @ DHGRI.DHObjectives[i].ObjName;
            }
            else
            {
                MapObjectivesTexts.Text = ObjCount $ "." @ DHGRI.DHObjectives[i].AttackerDescription;
            }
        }
        else
        {
            if (DHGRI.DHObjectives[i].DefenderDescription == "")
            {
                MapObjectivesTexts.Text = ObjCount $ "." @ "Defend" @ DHGRI.DHObjectives[i].ObjName;
            }
            else
            {
                MapObjectivesTexts.Text = ObjCount $ "." @ DHGRI.DHObjectives[i].DefenderDescription;
            }
        }

        // Can only show so many objectives before they draw off map, so lets leave the last spot to indicate there are more...
        if (j == MAX_OBJ_ON_SIT - 1)
        {
            MapObjectivesTexts.Text = AndMoreText;
        }

        // Don't draw anymore objective text as it would be off the situational map
        if (j < MAX_OBJ_ON_SIT)
        {
            DrawTextWidgetClipped(C, MapObjectivesTexts, SubCoords, XL, YL, YL_one);
            MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
            ++j;
        }

        ObjCount++;
    }

    // Theel: should secondary objectives even be listed (they shouldn't be important enough!)
    if (bHasSecondaryObjectives)
    {
        MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
        MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
        MapSecondaryObjectivesTitle.OffsetY = MapObjectivesTexts.OffsetY;
        DrawTextWidgetClipped(C, MapSecondaryObjectivesTitle, SubCoords, XL, YL, YL_one);

        for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
        {
            if (DHGRI.DHObjectives[i] == none || !DHGRI.DHObjectives[i].bActive|| DHGRI.DHObjectives[i].bRequired)
            {
                continue;
            }

            if (DHGRI.DHObjectives[i].ObjState != OwnerTeam)
            {
                MapObjectivesTexts.Text = (SecondaryObjCount + 1) $ "." @ DHGRI.DHObjectives[i].AttackerDescription;
            }
            else
            {
                MapObjectivesTexts.Text = (SecondaryObjCount + 1) $ "." @ DHGRI.DHObjectives[i].DefenderDescription;
            }

            DrawTextWidgetClipped(C, MapObjectivesTexts, SubCoords, XL, YL, YL_one);
            MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
            SecondaryObjCount++;
        }
    }

    // Draw 'objectives missing' if no objectives found - for debug only
    if (ObjCount == 1)
    {
        MapObjectivesTexts.Text = "(OBJECTIVES MISSING)";
        DrawTextWidgetClipped(C, MapObjectivesTexts, SubCoords, XL, YL, YL_one);
    }

    // Draw the instruction header
    s = class'ROTeamGame'.static.ParseLoadingHintNoColor(SituationMapInstructionsText, PlayerController(Owner));
    C.DrawColor = WhiteColor;
    C.Font = GetLargeMenuFont(C);

    X = C.ClipX * 0.5;
    Y = C.ClipY * 0.01;

    C.TextSize(s, StrX, StrY);
    C.SetPos(X - StrX / 2.0, Y);
    C.DrawTextClipped(s);
}

simulated function DrawLocationHits(Canvas C, ROPawn P)
{
    local int          Team, i;
    local bool         bNewDrawHits;
    local SpriteWidget Widget;

    if (PawnOwner.PlayerReplicationInfo != none && PawnOwner.PlayerReplicationInfo.Team != none)
    {
        Team = PawnOwner.PlayerReplicationInfo.Team.TeamIndex;
    }
    else
    {
        Team = 0;
    }

    for (i = 0; i < arraycount(P.DamageList); ++i)
    {
        if (P.DamageList[i] > 0)
        {
            // Draw hit
            Widget = HealthFigure;

            if (Team == AXIS_TEAM_INDEX)
            {
                Widget.WidgetTexture = locationHitAxisImages[i];
            }
            else if (Team == ALLIES_TEAM_INDEX)
            {
                Widget.WidgetTexture = locationHitAlliesImages[i];
            }
            else
            {
                continue;
            }

            DrawSpriteWidget(C, Widget);

            if (locationHitAlphas[i] > 0.0)
            {
                bNewDrawHits = true;
            }
        }
    }

    bDrawHits = bNewDrawHits;
}

simulated function UpdateHud()
{
    local ROPawn P;
    local Weapon W;
    local byte   Nation;

    if (PawnOwnerPRI != none)
    {
        P = ROPawn(PawnOwner);

        if (P != none)
        {
            // Set stamina info
            HealthFigureStamina.Scale = 1.0 - P.Stamina / P.default.Stamina;
            HealthFigureStamina.Tints[0].G = 255 - HealthFigureStamina.Scale * 255;
            HealthFigureStamina.Tints[1].G = 255 - HealthFigureStamina.Scale * 255;
            HealthFigureStamina.Tints[0].B = 255 - HealthFigureStamina.Scale * 255;
            HealthFigureStamina.Tints[1].B = 255 - HealthFigureStamina.Scale * 255;

            // Set stance info
            if (P.bIsCrouched)
            {
                StanceIcon.WidgetTexture = StanceCrouch;
            }
            else if (P.bIsCrawling)
            {
                StanceIcon.WidgetTexture = StanceProne;
            }
            else
            {
                StanceIcon.WidgetTexture = StanceStanding;
            }
        }

        if (PawnOwnerPRI.Team != none && PlayerOwner.GameReplicationInfo != none)
        {
            Nation = PlayerOwner.GameReplicationInfo.NationIndex[PawnOwnerPRI.Team.TeamIndex];
            HealthFigure.WidgetTexture = NationHealthFigures[Nation];
            HealthFigureBackground.WidgetTexture = NationHealthFiguresBackground[Nation];

            if (HealthFigureStamina.Scale > 0.9)
            {
                HealthFigureStamina.WidgetTexture = NationHealthFiguresStaminaCritical[Nation];
                HealthFigureStamina.Tints[0].G = 255; HealthFigureStamina.Tints[1].G = 255;
                HealthFigureStamina.Tints[0].B = 255; HealthFigureStamina.Tints[1].B = 255;
            }
            else
            {
                HealthFigureStamina.WidgetTexture = NationHealthFiguresStamina[Nation];
            }
        }
    }

    if (PawnOwner != none)
    {
        W = PawnOwner.Weapon;

        if (W != none)
        {
            if (W.AmmoClass[0] != none)
            {
                AmmoIcon.WidgetTexture = W.AmmoClass[0].default.IconMaterial;
            }
            else
            {
                AmmoIcon.WidgetTexture = none;
            }

            AmmoCount.Value = W.GetHudAmmoCount();
        }
    }
}

simulated function DrawVoiceIcon(Canvas C)
{
    local Pawn   P;
    local float  Distance, Scale;
    local vector ScreenPosition, VoiceLocation, VoiceDirection;

    if (PortraitPRI == none || PawnOwner == none || PlayerOwner == none)
    {
        return;
    }

    // Find the talking pawn, if we don't have one previously recorded or it's now a different player
    if (LastTalkingPawn == none || LastTalkingPawn.PlayerReplicationInfo != PortraitPRI)
    {
        foreach RadiusActors(class'Pawn', P, VOICE_ICON_DIST_MAX, PawnOwner.Location)
        {
            if (P.PlayerReplicationInfo == PortraitPRI)
            {
                if (Vehicle(P) != none)
                {
                    LastTalkingPawn = Vehicle(P).Driver;
                }
                else
                {
                    LastTalkingPawn = P;
                }

                break;
            }
        }
    }

    if (LastTalkingPawn != none)
    {
        // Get location, direction & distance of the talking player
        VoiceLocation = LastTalkingPawn.GetBoneCoords(LastTalkingPawn.HeadBone).Origin + vect(0.0, 0.0, 32.0);
        VoiceDirection = VoiceLocation - PlayerOwner.CalcViewLocation;
        Distance = VSize(VoiceDirection);

        // Don't draw if player is too far away
        if (Distance > VOICE_ICON_DIST_MAX)
        {
            return;
        }

        // Don't draw if player is behind us
        if (Acos(Normal(VoiceDirection) dot vector(PlayerOwner.CalcViewRotation)) > 1.5705)
        {
            return;
        }

        // Scale down the voice icon's size & opacity, based on distance, so it is smaller & fainter the further away it is
        // (apply a minimum, otherwise icon becomes very hard to see)
        Scale = FMax(0.3, 1.0 - (Distance / VOICE_ICON_DIST_MAX));

        VoiceIcon.TextureScale = Scale * default.VoiceIcon.TextureScale; // set size

        // If the icon is behind world geometry, make it look faint (reduce scale to minimum before setting opacity)
        if (Scale > 0.3 && !FastTrace(VoiceLocation, PlayerOwner.CalcViewLocation))
        {
            Scale = 0.3;
        }

        VoiceIcon.Tints[0].A = byte(Scale * 255.0); // set opacity

        // Set icon screen position & draw the voice icon
        ScreenPosition = C.WorldToScreen(VoiceLocation);
        VoiceIcon.PosX = ScreenPosition.X / C.ClipX;
        VoiceIcon.PosY = ScreenPosition.Y / C.ClipY;

        DrawSpriteWidget(C, VoiceIcon);
    }
}

// Modified to handle delay before displaying death messages, with fade in & out - Basnett, 2011
function DisplayMessages(Canvas C)
{
    local int   i;
    local float X, Y, XL, YL, Scale, TimeOfDeath, FadeInBeginTime, FadeInEndTime, FadeOutBeginTime;
    local byte  Alpha;
    local Obituary O;

    super(HudBase).DisplayMessages(C);

    if (!bShowDeathMessages)
    {
        return;
    }

    // Removes expired obituaries (& paired console death message)
    for (i = DHObituaries.Length - 1; i >= 0; --i)
    {
        if (Level.TimeSeconds > DHObituaries[i].EndOfLife)
        {
            DHObituaries.Remove(i, 1);

            if (i < ConsoleDeathMessages.Length)
            {
                ConsoleDeathMessages.Remove(i, 1);
            }
        }
    }

    Scale = C.ClipX / 1600.0;
    C.Font = GetConsoleFont(C);
    Y = 8.0 * Scale;

    // Offset death messages if we're displaying a hint
    if (bDrawHint)
    {
        Y += 2.0 * Y + (HintCoords.Y + HintCoords.YL) * C.ClipY;
    }

    // Loop through Obituaries & display if due
    for (i = 0; i < DHObituaries.Length; ++i)
    {
        O = DHObituaries[i];

        TimeOfDeath = O.EndOfLife - default.ObituaryLifeSpan;
        FadeInBeginTime = TimeOfDeath + default.ObituaryDelayTime;

        // Ignore this one if not due for display yet
        if (Level.TimeSeconds < FadeInBeginTime)
        {
            continue;
        }

        FadeInEndTime = FadeInBeginTime + default.ObituaryFadeInTime;
        FadeOutBeginTime = O.EndOfLife - default.ObituaryFadeInTime;

        // Adjust alpha (transparency) if message is fading in
        if (Level.TimeSeconds > FadeInBeginTime && Level.TimeSeconds < FadeInEndTime)
        {
            Alpha = byte(((Level.TimeSeconds - FadeInBeginTime) / default.ObituaryFadeInTime) * 255.0);
        }
        // Or if message is fading out
        else if (Level.TimeSeconds > FadeOutBeginTime)
        {
            Alpha = byte(Abs(255.0 - (((Level.TimeSeconds - FadeOutBeginTime) / default.ObituaryFadeInTime) * 255.0)));
        }
        else
        {
            Alpha = 255;
        }

        // Draw the death message
        C.TextSize(O.VictimName, XL, YL);

        X = C.ClipX - 8.0 * Scale - XL;

        C.SetPos(X, Y + 20.0 * Scale - YL * 0.5);
        C.DrawColor = O.VictimColor;
        C.DrawColor.A = Alpha;
        C.DrawTextClipped(O.VictimName);

        X -= 48.0 * Scale;

        C.SetPos(X, Y);
        C.DrawColor = WhiteColor;
        C.DrawColor.A = Alpha;
        C.DrawTileScaled(GetDamageIcon(O.DamageType), Scale * 1.25, Scale * 1.25);

        if (O.KillerName != "")
        {
            C.TextSize(O.KillerName, XL, YL);
            X -= 8.0 * Scale + XL;

            C.SetPos(X, Y + 20.0 * Scale - YL * 0.5);
            C.DrawColor = O.KillerColor;
            C.DrawColor.A = Alpha;
            C.DrawTextClipped(O.KillerName);
        }

        Y += 44.0 * Scale;

        // If paired console death message hasn't been shown yet, do it now
        if (ConsoleDeathMessages[i] != "")
        {
            if (PlayerConsole != none)
            {
                PlayerConsole.Message(ConsoleDeathMessages[i], 0.0);
            }

            ConsoleDeathMessages[i] = ""; // clear the message string, so this isn't repeated
        }
    }
}

simulated function DrawCaptureBar(Canvas Canvas)
{
    local DHPawn              P;
    local ROVehicle           Veh;
    local ROVehicleWeaponPawn WpnPwn;
    local int    Team;
    local byte   CurrentCapArea, CurrentCapProgress, CurrentCapAxisCappers, CurrentCapAlliesCappers, CurrentCapRequiredCappers;
    local float  AxisProgress, AlliesProgress, AttackersProgress, AttackersRatio, DefendersProgress, DefendersRatio, XL, YL, YPos;
    local string s;

    bDrawingCaptureBar = false;

    // Don't draw if we have no associated pawn or DHGRI
    if (PawnOwner == none || DHGRI == none)
    {
        return;
    }

    // Get capture info from associated pawn
    P = DHPawn(PawnOwner);

    // Pawn is a player pawn
    if (P != none)
    {
        CurrentCapArea = P.CurrentCapArea;

        if (CurrentCapArea != 255)
        {
            CurrentCapProgress = P.CurrentCapProgress;
            CurrentCapAxisCappers = P.CurrentCapAxisCappers;
            CurrentCapAlliesCappers = P.CurrentCapAlliesCappers;
        }
    }
    else
    {
        Veh = ROVehicle(PawnOwner);

        // Pawn is a vehicle
        if (Veh != none)
        {
            CurrentCapArea = Veh.CurrentCapArea;

            if (CurrentCapArea != 255)
            {
                CurrentCapProgress = Veh.CurrentCapProgress;
                CurrentCapAxisCappers = Veh.CurrentCapAxisCappers;
                CurrentCapAlliesCappers = Veh.CurrentCapAlliesCappers;
            }
        }
        else
        {
            WpnPwn = ROVehicleWeaponPawn(PawnOwner);

            // Pawn is a vehicle weapon pawn
            if (WpnPwn != none)
            {
                CurrentCapArea = WpnPwn.CurrentCapArea;

                if (CurrentCapArea != 255)
                {
                    CurrentCapProgress = WpnPwn.CurrentCapProgress;
                    CurrentCapAxisCappers = WpnPwn.CurrentCapAxisCappers;
                    CurrentCapAlliesCappers = WpnPwn.CurrentCapAlliesCappers;
                }
            }
            // Unsupported pawn type - return
            else
            {
                return;
            }
        }
    }

    // Don't render if we're not in a valid capture zone
    if (CurrentCapArea >= arraycount(DHGRI.DHObjectives) || DHGRI.DHObjectives[CurrentCapArea] == none)
    {
        return;
    }

    // Get current team
    if (PawnOwner.PlayerReplicationInfo != none && PawnOwner.PlayerReplicationInfo.Team != none)
    {
        Team = PawnOwner.PlayerReplicationInfo.Team.TeamIndex;
    }
    else
    {
        Team = 0;
    }

    // Get cap progress on a 0-1 scale for each team
    if (CurrentCapProgress == 0)
    {
        if (DHGRI.DHObjectives[CurrentCapArea].ObjState == NEUTRAL_TEAM_INDEX)
        {
            AlliesProgress = 0.0;
            AxisProgress = 0.0;
        }
        else if (DHGRI.DHObjectives[CurrentCapArea].ObjState == AXIS_TEAM_INDEX)
        {
            AlliesProgress = 0.0;
            AxisProgress = 1.0;
        }
        else
        {
            AlliesProgress = 1.0;
            AxisProgress = 0.0;
        }
    }
    else if (CurrentCapProgress > 100)
    {
        AlliesProgress = float(CurrentCapProgress - 100) / 100.0;

        if (DHGRI.DHObjectives[CurrentCapArea].ObjState != NEUTRAL_TEAM_INDEX)
        {
            AxisProgress = 1.0 - AlliesProgress;
        }
    }
    else
    {
        AxisProgress = float(CurrentCapProgress) / 100.0;

        if (DHGRI.DHObjectives[CurrentCapArea].ObjState != NEUTRAL_TEAM_INDEX)
        {
            AlliesProgress = 1.0 - AxisProgress;
        }
    }

    // Assign those progress to defender or attacker, depending on current team
    if (Team == AXIS_TEAM_INDEX)
    {
        AttackersProgress = AxisProgress;
        DefendersProgress = AlliesProgress;
        CaptureBarAttacker.Tints[TeamIndex] = CaptureBarTeamColors[AXIS_TEAM_INDEX];
        CaptureBarAttackerRatio.Tints[TeamIndex] = CaptureBarTeamColors[AXIS_TEAM_INDEX];
        CaptureBarDefender.Tints[TeamIndex] = CaptureBarTeamColors[ALLIES_TEAM_INDEX];
        CaptureBarDefenderRatio.Tints[TeamIndex] = CaptureBarTeamColors[ALLIES_TEAM_INDEX];
        CaptureBarIcons[0].WidgetTexture = MapAxisFlagIcon.WidgetTexture;
        CaptureBarIcons[0].TextureCoords = MapAxisFlagIcon.TextureCoords;
        CaptureBarIcons[1].WidgetTexture = MapAlliesFlagIcons[DHGRI.AlliedNationID].WidgetTexture;
        CaptureBarIcons[1].TextureCoords = MapAlliesFlagIcons[DHGRI.AlliedNationID].TextureCoords;

        // Figure ratios
        if (CurrentCapAlliesCappers == 0)
        {
            AttackersRatio = 1.0;
        }
        else if (CurrentCapAxisCappers == 0)
        {
            AttackersRatio = 0.0;
        }
        else
        {
            AttackersRatio = Float(CurrentCapAxisCappers) / (CurrentCapAxisCappers + CurrentCapAlliesCappers);
        }

        DefendersRatio = 1.0 - AttackersRatio;
    }
    else
    {
        AttackersProgress = AlliesProgress;
        DefendersProgress = AxisProgress;
        CaptureBarAttacker.Tints[TeamIndex] = CaptureBarTeamColors[ALLIES_TEAM_INDEX];
        CaptureBarAttackerRatio.Tints[TeamIndex] = CaptureBarTeamColors[ALLIES_TEAM_INDEX];
        CaptureBarDefender.Tints[TeamIndex] = CaptureBarTeamColors[AXIS_TEAM_INDEX];
        CaptureBarDefenderRatio.Tints[TeamIndex] = CaptureBarTeamColors[AXIS_TEAM_INDEX];
        CaptureBarIcons[0].WidgetTexture = MapAlliesFlagIcons[DHGRI.AlliedNationID].WidgetTexture;
        CaptureBarIcons[0].TextureCoords = MapAlliesFlagIcons[DHGRI.AlliedNationID].TextureCoords;
        CaptureBarIcons[1].WidgetTexture = MapAxisFlagIcon.WidgetTexture;
        CaptureBarIcons[1].TextureCoords = MapAxisFlagIcon.TextureCoords;

        // Figure ratios
        if (CurrentCapAxisCappers == 0)
        {
            AttackersRatio = 1.0;
        }
        else if (CurrentCapAlliesCappers == 0)
        {
            AttackersRatio = 0.0;
        }
        else
        {
            AttackersRatio = Float(CurrentCapAlliesCappers) / (CurrentCapAxisCappers + CurrentCapAlliesCappers);
        }

        DefendersRatio = 1.0 - AttackersRatio;
    }

    // Draw capture bar at 50% faded if we're at a stalemate
    if (CurrentCapAxisCappers == CurrentCapAlliesCappers)
    {
        CaptureBarAttacker.Tints[TeamIndex].A /= 2;
        CaptureBarDefender.Tints[TeamIndex].A /= 2;
    }

    // Convert attacker/defender progress to widget scale (bar goes from 53 to 203, total width of texture is 256)
    CaptureBarAttacker.Scale = 150.0 / 256.0 * AttackersProgress + 53.0 / 256.0;
    CaptureBarDefender.Scale = 150.0 / 256.0 * DefendersProgress + 53.0 / 256.0;

    // Convert attacker/defender ratios to widget scale (bar goes from 63 to 193, total width of texture is 256)
    CaptureBarAttackerRatio.Scale = 130.0 / 256.0 * AttackersRatio + 63.0 / 256.0;
    CaptureBarDefenderRatio.Scale = 130.0 / 256.0 * DefendersRatio + 63.0 / 256.0;

    // Check which icon to show on right side
    if (AttackersProgress ~= 1.0)
    {
        CaptureBarIcons[1].WidgetTexture = CaptureBarIcons[0].WidgetTexture;
    }

    // Draw everything
    DrawSpriteWidget(Canvas, CaptureBarBackground);
    DrawSpriteWidget(Canvas, CaptureBarAttacker);
    DrawSpriteWidget(Canvas, CaptureBarDefender);
    DrawSpriteWidget(Canvas, CaptureBarAttackerRatio);
    DrawSpriteWidget(Canvas, CaptureBarDefenderRatio);
    DrawSpriteWidget(Canvas, CaptureBarOutline);

    // Draw the left icon
    DrawSpriteWidget(Canvas, CaptureBarIcons[0]);

    // Only draw right icon if objective is capped already
    if (!(DefendersProgress ~= 0.0) || (AttackersProgress ~= 1.0))
    {
        DrawSpriteWidget(Canvas, CaptureBarIcons[1]);
    }

    // Set up to draw the objective name
    s = DHGRI.DHObjectives[CurrentCapArea].ObjName;
    CurrentCapRequiredCappers = DHGRI.DHObjectives[CurrentCapArea].PlayersNeededToCapture;

    // Add a display for the number of cappers in vs the amount needed to capture
    if (CurrentCapRequiredCappers > 1)
    {
        // Displayed when the cap is neutral, the other team completely owns the cap, or there are enemy capturers
        if (Team == 0 && (DHGRI.DHObjectives[CurrentCapArea].ObjState == 2 || AxisProgress != 1.0 || CurrentCapAlliesCappers != 0))
        {
            if (CurrentCapAxisCappers < CurrentCapRequiredCappers)
            {
                CaptureBarAttacker.Tints[TeamIndex].A /= 2;
                CaptureBarDefender.Tints[TeamIndex].A /= 2;
            }

            s @= "(" $ CurrentCapAxisCappers @ "/" @ CurrentCapRequiredCappers $ ")";
        }
        else if (Team == 1 && (DHGRI.DHObjectives[CurrentCapArea].ObjState == 2 || AlliesProgress != 1.0 || CurrentCapAxisCappers != 0))
        {
            if (CurrentCapAlliesCappers < CurrentCapRequiredCappers)
            {
                CaptureBarAttacker.Tints[TeamIndex].A /= 2;
                CaptureBarDefender.Tints[TeamIndex].A /= 2;
            }

            s @= "(" $ CurrentCapAlliesCappers @ "/" @ CurrentCapRequiredCappers $ ")";
        }
    }

    // Draw the objective name
    Canvas.Font = GetConsoleFont(Canvas);
    Canvas.TextSize(s, XL, YL);
    Canvas.DrawColor = WhiteColor;
    YPos = Canvas.ClipY * CaptureBarBackground.PosY - (CaptureBarBackground.TextureCoords.Y2 + 1.0 + 4.0) * CaptureBarBackground.TextureScale * HudScale * ResScaleY;
    Canvas.SetPos(Canvas.ClipX * CaptureBarBackground.PosX - XL / 2.0, YPos - YL);

    Canvas.DrawText(s);

    // Add signal so that vehicle passenger list knows to shift text up
    bDrawingCaptureBar = true;
}

// Modified to fix a bug that spams thousands of "accessed none" errors to log, if there is a missing objective number in the array
simulated function UpdateMapIconLabelCoords(FloatBox LabelCoords, ROGameReplicationInfo GRI, int CurrentObj)
{
    local float NewY;
    local int   Count, i;

    if (DHGRI == none || CurrentObj >= arraycount(DHGRI.DHObjectives) || CurrentObj < 0)
    {
        return;
    }

    // Do not update label coords if it's disabled in the objective
    if (DHGRI.DHObjectives[CurrentObj] != none && DHGRI.DHObjectives[CurrentObj].bDoNotUseLabelShiftingOnSituationMap)
    {
        DHGRI.DHObjectives[CurrentObj].LabelCoords = LabelCoords;

        return;
    }

    if (CurrentObj == 0)
    {
        // Set label position to be same as tested position
        DHGRI.DHObjectives[0].LabelCoords = LabelCoords;

        return;
    }

    for (i = 0; i < CurrentObj; ++i)
    {
        if (DHGRI.DHObjectives[i] == none) // added to avoid spamming "accessed none" errors
        {
            continue;
        }

        // Check if there's overlap in the X axis
        if (!(LabelCoords.X2 <= DHGRI.DHObjectives[i].LabelCoords.X1 || LabelCoords.X1 >= DHGRI.DHObjectives[i].LabelCoords.X2))
        {
            // There's overlap - check if there's overlap in the Y axis
            if (!(LabelCoords.Y2 <= DHGRI.DHObjectives[i].LabelCoords.Y1 || LabelCoords.Y1 >= DHGRI.DHObjectives[i].LabelCoords.Y2))
            {
                // There's overlap on both axes; the label overlaps - update the position of the label
                NewY = DHGRI.DHObjectives[i].LabelCoords.Y2 - (LabelCoords.Y2 - LabelCoords.Y1) * 0.0;
                LabelCoords.Y2 = NewY + LabelCoords.Y2 - LabelCoords.Y1;
                LabelCoords.Y1 = NewY;

                i = -1; // this is to force re-checking of all possible overlaps to ensure that no other label overlaps with this

                Count++; // safety check to prevent runaway loop

                if (Count > (CurrentObj * 5))
                {
                    break;
                }
            }
        }

    }

    // Set new label position
    DHGRI.DHObjectives[CurrentObj].LabelCoords = LabelCoords;
}

// Modified so if player is in a vehicle, the keybinds to GrowHUD & ShrinkHUD will call same named functions in the vehicle classes
// When player is in a vehicle these functions do nothing to the HUD, but they can be used to add useful custom functionality to vehicles, especially as keys are -/+ by default
exec function GrowHUD()
{
    if (PawnOwner != none && PawnOwner.IsA('Vehicle'))
    {
        if (PawnOwner.IsA('DHArmoredVehicle'))
        {
            DHArmoredVehicle(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DHWheeledVehicle'))
        {
            DHWheeledVehicle(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DHVehicleCannonPawn'))
        {
            DHVehicleCannonPawn(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DHVehicleMGPawn'))
        {
            DHVehicleMGPawn(PawnOwner).GrowHUD();
        }
    }
    else
    {
        super.GrowHUD();
    }
}

exec function ShrinkHUD()
{
    if (PawnOwner != none && PawnOwner.IsA('Vehicle'))
    {
        if (PawnOwner.IsA('DHArmoredVehicle'))
        {
            DHArmoredVehicle(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DHWheeledVehicle'))
        {
            DHWheeledVehicle(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DHVehicleCannonPawn'))
        {
            DHVehicleCannonPawn(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DHVehicleMGPawn'))
        {
            DHVehicleMGPawn(PawnOwner).ShrinkHUD();
        }
    }
    else
    {
        super.ShrinkHUD();
    }
}

// Modified to show respawn time for deploy system
simulated function DrawSpectatingHud(Canvas C)
{
    local DHPlayerReplicationInfo PRI;
    local DHSpawnPoint            SP;
    local DHPlayer                PC;
    local class<Vehicle>          SVC;
    local float  Scale, X, Y, strX, strY, NameWidth, SmallH, XL;
    local int    Time;
    local string s;

    PC = DHPlayer(PlayerOwner);

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    }

    Scale = C.ClipX / 1600.0;

    // Draw fade effects
    C.Style = ERenderStyle.STY_Alpha;
    DrawFadeEffect(C);

    if (DHGRI != none && DHGRI.bMatchHasBegun)
    {
        // Update & draw round timer
        if (!DHGRI.bMatchHasBegun)
        {
            CurrentTime = DHGRI.RoundStartTime + DHGRI.PreStartTime - DHGRI.ElapsedTime;
        }
        else
        {
            CurrentTime = DHGRI.RoundEndTime - DHGRI.ElapsedTime;
        }

        if (DHGRI.RoundDuration == 0)
        {
            s = default.TimeRemainingText $ default.NoTimeLimitText;
        }
        else
        {
            s = default.TimeRemainingText $ GetTimeString(CurrentTime);
        }

        X = 8.0 * Scale;
        Y = 8.0 * Scale;

        C.DrawColor = WhiteColor;
        C.Font = GetConsoleFont(C);
        C.TextSize(s, strX, strY);
        C.SetPos(X, Y);
        C.DrawTextClipped(s);

        s = "";

        // Draw deploy text
        if (PRI == none || PRI.Team == none || PRI.bOnlySpectator)
        {
            s = default.JoinTeamText; // press ESC to join a team
        }
        else if (DHGRI.bReinforcementsComing[PRI.Team.TeamIndex] == 1)
        {
            if (DHGRI.SpawnsRemaining[PRI.Team.TeamIndex] > 0)
            {
                Time = Max(PC.NextSpawnTime - DHGRI.ElapsedTime, 0);

                switch (PC.ClientLevelInfo.SpawnMode)
                {
                    case ESM_DarkestHour:
                        if (PC.VehiclePoolIndex != 255 && PC.SpawnPointIndex != 255)
                        {
                            // You will deploy as a {0} driving a {3} at {2} | Press ESC to change
                            s = default.SpawnVehicleText;
                            s = Repl(s, "{3}", DHGRI.VehiclePoolVehicleClasses[PC.VehiclePoolIndex].default.VehicleNameString);
                        }
                        else if (PC.SpawnPointIndex != 255)
                        {
                            SP = DHGRI.SpawnPoints[PC.SpawnPointIndex];

                            if (SP == none)
                            {
                                // Press ESC to select a spawn point
                                s = default.SelectSpawnPointText;
                            }
                            else
                            {
                                // You will deploy as a {0} in {2} | Press ESC to change
                                s = default.SpawnInfantryText;
                            }
                        }
                        else if (PC.SpawnVehicleIndex != 255)
                        {
                            SVC = DHGRI.SpawnVehicles[PC.SpawnVehicleIndex].VehicleClass;

                            if (SVC != none)
                            {
                                // You will deploy as a {0} at a {1} in {2} | Press ESC to change
                                s = Repl(default.SpawnAtVehicleText, "{1}", SVC.default.VehicleNameString);
                            }
                            else
                            {
                                // Press ESC to select a spawn point
                                s = default.SelectSpawnPointText;
                            }
                        }
                        else
                        {
                            // Press ESC to select a spawn point
                            s = default.SelectSpawnPointText;
                        }

                        break;

                    case ESM_RedOrchestra:
                        s = default.ReinforcementText;
                        break;
                }

                if (PRI.RoleInfo != none)
                {
                    if (PC.bUseNativeRoleNames)
                    {
                        s = Repl(s, "{0}", PRI.RoleInfo.AltName);
                    }
                    else
                    {
                        s = Repl(s, "{0}", PRI.RoleInfo.MyName);
                    }
                }
                else
                {
                    s = default.SpawnNoRoleText;
                }

                s = Repl(s, "{2}", GetTimeString(Time));
            }
            else
            {
                s = default.ReinforcementsDepletedText;
            }
        }

        Y += 4.0 * Scale + strY;

        C.SetPos(X, Y);
        C.DrawTextClipped(s);
    }

    // Draw player's name
    if (PlayerOwner.ViewTarget != PlayerOwner.Pawn && PawnOwner != none && PawnOwner.PlayerReplicationInfo != none)
    {
        S = ViewingText $ PawnOwner.PlayerReplicationInfo.PlayerName;
        C.DrawColor = WhiteColor;
        C.Font = GetConsoleFont(C);
        C.TextSize(S, strX, strY);
        C.SetPos(C.ClipX / 2.0 - strX / 2.0, C.ClipY - 8.0 * Scale - strY);
        C.DrawTextClipped(S);
    }

    // Rough spectate hud stuff // TODO: refine this so its not so plain
    if (PC != none)
    {
        S = PC.GetSpecModeDescription();
        C.DrawColor = WhiteColor;
        C.Font = GetLargeMenuFont(C);

        X = C.ClipX * 0.5;
        Y = C.ClipY * 0.1;

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2.0, Y  - strY);
        C.DrawTextClipped(S);

        // Draw line 1
        S = SpectateInstructionText1;
        C.Font = GetConsoleFont(C);

        X = C.ClipX * 0.5;
        Y = C.ClipY * 0.9;

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2.0, Y  - strY);
        C.DrawTextClipped(S);

        // Draw line 2
        S = SpectateInstructionText2;
        X = C.ClipX * 0.5;
        Y += strY + (3.0 * Scale);

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2.0, Y  - strY);
        C.DrawTextClipped(S);

        // Draw line 3
        S = SpectateInstructionText3;
        X = C.ClipX * 0.5;
        Y += strY + (3.0 * Scale);

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2.0, Y  - strY);
        C.DrawTextClipped(S);

        // Draw line 4
        S = SpectateInstructionText4;
        X = C.ClipX * 0.5;
        Y += strY + (3.0 * Scale);

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2.0, Y  - strY);
        C.DrawTextClipped(S);
    }

    // Draw the players name large if they are viewing someone else in first person
    if (PawnOwner != none && PawnOwner != PlayerOwner.Pawn && PawnOwner.PlayerReplicationInfo != none && !PlayerOwner.bBehindView)
    {
        C.Font = GetMediumFontFor(C);
        C.SetDrawColor(255, 255, 0, 255);
        C.StrLen(PawnOwner.PlayerReplicationInfo.PlayerName, NameWidth, SmallH);
        NameWidth = FMax(NameWidth, 0.15 * C.ClipX);

        if (C.ClipX >= 640.0)
        {
            C.Font = GetConsoleFont(C);
            C.StrLen("W" ,XL, SmallH);
            C.SetPos(79.0 * C.ClipX / 80.0 - NameWidth, C.ClipY * 0.68);
            C.DrawText(NowViewing, false);
        }

        C.Font = GetMediumFontFor(C);
        C.SetPos(79.0 * C.ClipX / 80.0 - NameWidth, C.ClipY * 0.68 + SmallH);
        C.DrawText(PawnOwner.PlayerReplicationInfo.PlayerName, false);
    }

    // Draw hints
    if (bDrawHint)
    {
        DrawHint(C);
    }

    // Update & draw screen messages
    DisplayLocalMessages(C);
}

// Modified to make objective title's smaller on the overview
function DrawIconOnMap(Canvas C, AbsoluteCoordsInfo LevelCoords, SpriteWidget Icon, float MyMapScale, vector Location, vector MapCenter,
    optional int FlashMode, optional string Title, optional ROGameReplicationInfo GRI, optional int ObjectiveIndex)
{
    local FloatBox Label_coords;
    local vector   HUDLocation;
    local float    XL, YL, YL_one, OldFontXScale, OldFontYScale;

    // Calculate the screen position
    HUDLocation = Location - MapCenter;
    HUDLocation.Z = 0.0;
    HUDLocation = GetAdjustedHudLocation(HUDLocation);

    Icon.PosX = HUDLocation.X / MyMapScale + 0.5;
    Icon.PosY = HUDLocation.Y / MyMapScale + 0.5;

    Icon.PosX = FMax(0.0, FMin(1.0, Icon.PosX));
    Icon.PosY = FMax(0.0, FMin(1.0, Icon.PosY));

    // Set flashing texture if needed
    if (FlashMode > 1)
    {
        if (FlashMode == 2)
        {
            Icon.WidgetTexture = MapIconsFlash;
        }
        else if (FlashMode == 3)
        {
            Icon.WidgetTexture = MapIconsFastFlash;
        }
        else if (FlashMode == 4)
        {
            Icon.WidgetTexture = MapIconsAltFlash;
        }
        else if (FlashMode == 5)
        {
            Icon.WidgetTexture = MapIconsAltFastFlash;
        }
    }

    // Draw icon
    DrawSpriteWidgetClipped(C, Icon, LevelCoords, true, XL, YL, true);

    // Draw title
    if (Title != "" && DHGRI != none && ObjectiveIndex < arraycount(DHGRI.DHObjectives) && ObjectiveIndex >= 0
        && DHGRI.DHObjectives[ObjectiveIndex] != none && !DHGRI.DHObjectives[ObjectiveIndex].bDoNotDisplayTitleOnSituationMap)
    {
        // Setup text info
        MapTexts.text = Title;
        MapTexts.PosX = Icon.PosX;
        MapTexts.PosY = Icon.PosY;
        MapTexts.Tints[TeamIndex].A = Icon.Tints[TeamIndex].A;
        MapTexts.OffsetY = YL * 0.3;

        // Fake render to get desired label pos
        DrawTextWidgetClipped(C, MapTexts, LevelCoords, XL, YL, YL_one, true);

        // Update objective floatbox info with desired coords
        label_coords.X1 = LevelCoords.width * MapTexts.PosX - XL / 2.0;
        label_coords.Y1 = LevelCoords.height * MapTexts.PosY;
        label_coords.X2 = label_coords.X1 + XL;
        label_coords.Y2 = label_coords.Y1 + YL;

        // Iterate through objectives list & check if we should offset label
        UpdateMapIconLabelCoords(label_coords, GRI, ObjectiveIndex);

        // Update Y offset
        MapTexts.OffsetY += DHGRI.DHObjectives[ObjectiveIndex].LabelCoords.Y1 - label_coords.Y1;

        // Hack to make the text smaller on the overview for objectives
        OldFontXScale = C.FontScaleX;
        OldFontYScale = C.FontScaleY;
        C.FontScaleX = 0.66;
        C.FontScaleY = 0.66;

        // Draw text
        DrawTextWidgetClipped(C, MapTexts, LevelCoords);
        C.FontScaleX = OldFontXScale;
        C.FontScaleY = OldFontYScale;
    }
}

// Modified to make fade to black work with lower HUD opacity values
simulated function DrawFadeToBlack(Canvas Canvas)
{
    local float Alpha;

    if (FadeToBlackTime ~= 0.0)
    {
        Alpha = 0.0;
    }
    else
    {
        Alpha = FClamp((FadeToBlackTime - Level.TimeSeconds + FadeToBlackStartTime) / FadeToBlackTime, 0.0, 1.0);
    }

    if (!bFadeToBlackInvert)
    {
        Alpha = 1.0 - Alpha;
    }

    if (Alpha ~= 0.0)
    {
        bFadeToBlack = false;
    }
    else
    {
        Canvas.SetPos(0.0, 0.0);
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.DrawColor = BlackColor;
        Canvas.DrawColor.A = Alpha * 255;
        Canvas.ColorModulate.W = 1.0;
        Canvas.DrawTile(texture'Engine.WhiteTexture', Canvas.ClipX, Canvas.ClipY, 0.0, 0.0, 4.0, 4.0);
        Canvas.ColorModulate.W = HudOpacity / 255.0;
    }
}

// Draw objective information on the G15 LCD - updated in case this function is ever used
simulated function DrawLCDObjectives(Canvas C, GUIController GC)
{
    local int    ObjCount, Row, i;
    local string s;
    local bool   bHasSecondaryObjectives;

    if (DHGRI == none)
    {
        return;
    }

    // Draw objective texts
    ObjCount = 1;

    GC.LCDCls();

    // See if there are any secondary objectives
    for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
    {
        if (DHGRI.DHObjectives[i] != none && DHGRI.DHObjectives[i].bActive && !DHGRI.DHObjectives[i].bRequired)
        {
            bHasSecondaryObjectives = true;
            break;
        }
    }

    if (LCDPage == 0 || !bHasSecondaryObjectives)
    {
        GC.LCDDrawText(MapRequiredObjectivesTitle.text @ "Status:", 0, 0, GC.LCDTinyFont);
        Row++;

        for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
        {
            if (DHGRI.DHObjectives[i] == none || !DHGRI.DHObjectives[i].bActive || !DHGRI.DHObjectives[i].bRequired)
            {
                continue;
            }

            if (DHGRI.DHObjectives[i].ObjState == OBJ_Allies)
            {
                if (DHGRI.DHObjectives[i].CompressedCapProgress != 0 && DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
                {
                    s = ObjCount $ "." $ "Allies" $ "-" $ "under attack";
                }
                else
                {
                    s = ObjCount $ "." $ "Allies" $ "-" $ "captured";
                }
            }
            else if (DHGRI.DHObjectives[i].ObjState == OBJ_Axis)
            {
                if (DHGRI.DHObjectives[i].CompressedCapProgress != 0 && DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
                {
                    s = ObjCount $ "." $ "Axis" $ "-" $ "under attack";
                }
                else
                {
                    s = ObjCount $ "." $ "Axis" $ "-" $ "captured";
                }
            }
            else
            {
                if (DHGRI.DHObjectives[i].CompressedCapProgress != 0)
                {
                    if (DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
                    {
                        if (DHGRI.DHObjectives[i].CurrentCapTeam == ALLIES_TEAM_INDEX)
                        {
                            s = ObjCount $ "." $ "Neutral" $ "-" $ "allies attacking";
                        }
                        else
                        {
                            s = ObjCount $ "." $ "Neutral" $ "-" $ "axis attacking";
                        }
                    }
                    else
                    {
                        s = ObjCount $ "." $ "Neutral" $ "-" $ "under attack";
                    }
                }
                else
                {
                    s = ObjCount $ "." $ "Neutral";
                }
            }

            GC.LCDDrawText(s, 0, 8 * Row + 2, GC.LCDTinyFont);

            Row++;
            ObjCount++;
        }
    }

    if (LCDPage == 1 && bHasSecondaryObjectives)
    {
        GC.LCDDrawText(MapSecondaryObjectivesTitle.text @ "Status:", 0, 0, GC.LCDTinyFont);
        Row++;

        for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
        {
            if (DHGRI.DHObjectives[i] == none || !DHGRI.DHObjectives[i].bActive || DHGRI.DHObjectives[i].bRequired)
            {
                continue;
            }

            if (DHGRI.DHObjectives[i].ObjState == OBJ_Allies)
            {
                if (DHGRI.DHObjectives[i].CompressedCapProgress != 0 && DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
                {
                    s = ObjCount $ "." $ "Allies" $ "-" $ "under attack";
                }
                else
                {
                    s = ObjCount $ "." $ "Allies" $ "-" $ "captured";
                }
            }
            else if (DHGRI.DHObjectives[i].ObjState == OBJ_Axis)
            {
                if (DHGRI.DHObjectives[i].CompressedCapProgress != 0 && DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
                {
                    s = ObjCount $ "." $ "Axis" $ "-" $ "under attack";
                }
                else
                {
                    s = ObjCount $ "." $ "Axis" $ "-" $ "captured";
                }
            }
            else
            {
                if (DHGRI.DHObjectives[i].CompressedCapProgress != 0)
                {
                    if (DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
                    {
                        if (DHGRI.DHObjectives[i].CurrentCapTeam == ALLIES_TEAM_INDEX)
                        {
                            s = ObjCount $ "." $ "Neutral" $ "-" $ "allies attacking";
                        }
                        else
                        {
                            s = ObjCount $ "." $ "Neutral" $ "-" $ "axis attacking";
                        }
                    }
                    else
                    {
                        s = ObjCount $ "." $ "Neutral" $ "-" $ "under attack";
                    }
                }
                else
                {
                    s = ObjCount $ "." $ "Neutral";
                }
            }

            GC.LCDDrawText(s, 0, 8 * Row, GC.LCDTinyFont);

            Row++;
            ObjCount++;
        }
    }

    GC.LCDRepaint();
}

exec function ShowDebug()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bShowDebugInfo = !bShowDebugInfo;
    }
}

defaultproperties
{
    MapLevelOverlay=(RenderStyle=STY_Alpha,TextureCoords=(X2=511,Y2=511),TextureScale=1.0,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=125),Tints[1]=(B=255,G=255,R=255,A=255))
    MapScaleText=(RenderStyle=STY_Alpha,DrawPivot=DP_LowerRight,PosX=1.0,PosY=0.0375,WrapHeight=1.0,Tints[0]=(B=255,G=255,R=255,A=128),Tints[1]=(B=255,G=255,R=255,A=128))
    VehicleAltAmmoReloadIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.2,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Up,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=0,B=0,A=128),Tints[1]=(R=255,G=0,B=0,A=128))
    VehicleMGAmmoReloadIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.3,DrawPivot=DP_LowerLeft,PosX=0.15,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Up,Scale=0.75,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=0,B=0,A=128),Tints[1]=(R=255,G=0,B=0,A=128))
    MapIconCarriedRadio=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X1=64,Y1=192,X2=127,Y2=255),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    CanMantleIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.CanMantle',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=127),TextureScale=0.8,DrawPivot=DP_LowerMiddle,PosX=0.55,PosY=0.98,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    CanCutWireIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.CanCut',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=127),TextureScale=0.8,DrawPivot=DP_LowerMiddle,PosX=0.55,PosY=0.98,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    VoiceIcon=(WidgetTexture=texture'DH_InterfaceArt_tex.Communication.Voice',RenderStyle=STY_Alpha,TextureCoords=(X2=63,Y2=63),TextureScale=0.5,DrawPivot=DP_MiddleMiddle,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    MapIconMortarHETarget=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X1=127,Y1=0,X2=192,Y2=64),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapIconMortarSmokeTarget=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X1=191,Y1=0,X2=255,Y2=64),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapIconMortarArrow=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.mortar-arrow-final',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.1,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapIconMortarHit=(WidgetTexture=texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(Y1=64,X2=63,Y2=127),TextureScale=0.05,DrawPivot=DP_LowerMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    VehicleAmmoTypeText=(Text="",PosX=0.24,PosY=1.0,WrapWidth=0,WrapHeight=1,OffsetX=8,OffsetY=-4,DrawPivot=DP_LowerLeft,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255),bDrawShadow=false)
    VehicleAltAmmoIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.2,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    VehicleAltAmmoAmount=(TextureScale=0.2,MinDigitCount=1,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=135,OffsetY=-40,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))

    MapIconNeutral=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=0,X2=31,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAxisFlagIcon=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=32,X2=31,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAlliesFlagIcons(0)=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=96,Y1=0,X2=127,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAlliesFlagIcons(1)=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=64,Y1=0,X2=95,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAlliesFlagIcons(2)=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=32,Y1=0,X2=63,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))

    WeaponCanRestIcon=(WidgetTexture=Texture'DH_InterfaceArt_tex.HUD.DeployIcon',TextureCoords=(X1=0,Y1=0,X2=63,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-144,ScaleMode=SM_Left,scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=100,G=100,B=100,A=255),Tints[1]=(R=100,G=100,B=100,A=255))
    WeaponRestingIcon=(WidgetTexture=Texture'DH_InterfaceArt_tex.HUD.DeployIcon',TextureCoords=(X1=0,Y1=0,X2=63,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-144,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MGDeployIcon=(WidgetTexture=Texture'DH_InterfaceArt_tex.HUD.DeployIcon',TextureCoords=(X1=0,Y1=0,X2=63,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-144,ScaleMode=SM_Left,scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))

    CaptureBarIcons[0]=(TextureScale=0.50,DrawPivot=DP_MiddleMiddle,PosX=0.5,PosY=0.98,OffsetX=-100,OffsetY=-32,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    CaptureBarIcons[1]=(TextureScale=0.50,DrawPivot=DP_MiddleMiddle,PosX=0.5,PosY=0.98,OffsetX=100,OffsetY=-32,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))

    VehicleAltAmmoOccupantsTextOffset=-35
    VehicleOccupantsTextOffset=0.40
    LegendCarriedArtilleryRadioText="Artillery Radioman"
    NeedReloadText="Needs reloading"
    AndMoreText="and more..."
    CanReloadText="Press %THROWMGAMMO% to assist reload"
    PlayerNameFontSize=4
    bShowDeathMessages=true
    bShowVoiceIcon=true
    ObituaryFadeInTime=0.5
    ObituaryDelayTime=5.0
    LegendArtilleryRadioText="Artillery Radio"
    ResupplyZoneNormalPlayerIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    ResupplyZoneNormalVehicleIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    //ResupplyZoneResupplyingPlayerIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash')
    //ResupplyZoneResupplyingVehicleIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash')
    NationHealthFigures(1)=texture'DH_GUI_Tex.GUI.US_player'
    NationHealthFiguresBackground(1)=texture'DH_GUI_Tex.GUI.US_player_background'
    NationHealthFiguresStamina(1)=texture'DH_GUI_Tex.GUI.US_player_Stamina'
    NationHealthFiguresStaminaCritical(1)=FinalBlend'DH_GUI_Tex.GUI.US_player_Stamina_critical'
    PlayerArrowTexture=FinalBlend'DH_GUI_Tex.GUI.PlayerIcon_final'
    ObituaryLifeSpan=8.5
    MapIconsFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_flags_flashing'
    MapIconsFastFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_flags_fast_flash'
    MapIconsAltFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_flags_alt_flashing'
    MapIconsAltFastFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_flags_alt_fast_flash'
    MapBackground=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_background')
    MapPlayerIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.PlayerIcon_final',Tints[0]=(G=110))
    MapIconTeam(0)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconTeam(1)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconRally(0)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconRally(1)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconMGResupplyRequest(0)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconMGResupplyRequest(1)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    locationHitAlliesImages(0)=texture'DH_GUI_Tex.Player_hits.US_hit_Head'
    locationHitAlliesImages(1)=texture'DH_GUI_Tex.Player_hits.US_hit_torso'
    locationHitAlliesImages(2)=texture'DH_GUI_Tex.Player_hits.US_hit_pelvis'
    locationHitAlliesImages(3)=texture'DH_GUI_Tex.Player_hits.US_hit_LupperLeg'
    locationHitAlliesImages(4)=texture'DH_GUI_Tex.Player_hits.US_hit_RupperLeg'
    locationHitAlliesImages(5)=texture'DH_GUI_Tex.Player_hits.US_hit_LupperArm'
    locationHitAlliesImages(6)=texture'DH_GUI_Tex.Player_hits.US_hit_RupperArm'
    locationHitAlliesImages(7)=texture'DH_GUI_Tex.Player_hits.US_hit_LlowerLeg'
    locationHitAlliesImages(8)=texture'DH_GUI_Tex.Player_hits.US_hit_RlowerLeg'
    locationHitAlliesImages(9)=texture'DH_GUI_Tex.Player_hits.US_hit_LlowerArm'
    locationHitAlliesImages(10)=texture'DH_GUI_Tex.Player_hits.US_hit_RlowerArm'
    locationHitAlliesImages(11)=texture'DH_GUI_Tex.Player_hits.US_hit_LHand'
    locationHitAlliesImages(12)=texture'DH_GUI_Tex.Player_hits.US_hit_RHand'
    locationHitAlliesImages(13)=texture'DH_GUI_Tex.Player_hits.US_hit_Lfoot'
    locationHitAlliesImages(14)=texture'DH_GUI_Tex.Player_hits.US_hit_Rfoot'
    MouseInterfaceIcon=(WidgetTexture=texture'DH_GUI_Tex.Menu.DHPointer')
    CaptureBarTeamIcons(0)=texture'DH_GUI_Tex.GUI.GerCross'
    CaptureBarTeamIcons(1)=texture'DH_GUI_Tex.GUI.AlliedStar'
    CaptureBarTeamColors(0)=(R=221,G=0,B=0)
    CaptureBarTeamColors(1)=(R=49,G=57,B=223)
    TeamMessagePrefix="*TEAM* "

    SpawnNoRoleText="You will deploy in {2} | Press ESC to change"
    SpawnInfantryText="You will deploy as a {0} in {2} | Press ESC to change"
    SpawnVehicleText="You will deploy as a {0} driving a {3} in {2} | Press ESC to change"
    SelectSpawnPointText="Press ESC to select a spawn point"
    JoinTeamText="Press ESC to join a team"
    SpawnAtVehicleText="You will deploy as a {0} at a {1} in {2} | Press ESC to change"
    ReinforcementText="You will deploy as a {0} in {2} | Press ESC to change"
    ReinforcementsDepletedText="Reinforcements depleted!"
    NoTimeLimitText="Unlimited"

    TimeElapsedText="Time Elasped: "
    MapNameText="Map: "

    LegendAxisObjectiveText="Axis territory"
    LegendAlliesObjectiveText="Allied territory"

    SideColors(0)=(R=200,G=72,B=72,A=255)
    SideColors(1)=(R=151,G=154,B=223,A=255)

    DeployOkayIcon=(WidgetTexture=Material'DH_GUI_tex.GUI.deploy_status',TextureCoords=(X1=0,Y1=0,X2=63,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-200,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255))
    DeployEnemiesNearbyIcon=(WidgetTexture=Material'DH_GUI_tex.GUI.deploy_status_finalblend',TextureCoords=(X1=64,Y1=0,X2=127,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-200,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255))
    DeployInObjectiveIcon=(WidgetTexture=Material'DH_GUI_tex.GUI.deploy_status_finalblend',TextureCoords=(X1=0,Y1=64,X2=63,Y2=127),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-200,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255))
}
