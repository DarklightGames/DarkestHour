//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHHud extends ROHud;

#exec OBJ LOAD FILE=..\Textures\DH_GUI_Tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_Weapon_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx

const   MAX_OBJ_ON_SIT = 12; // the maximum objectives that can be listed down the side on the situational map (not on the map itself)

const   VOICE_ICON_DIST_MAX = 2624.672119; // maximum distance from a talking player at which we will show a voice icon

var DHGameReplicationInfo   DHGRI;

var     int                 AlliedNationID; // US = 0, Britain = 1, Canada = 2

// Map or screen icons/legends
var     SpriteWidget        MapLevelOverlay;
var     TextWidget          MapScaleText;
var     SpriteWidget        MapIconCarriedRadio;
var     SpriteWidget        MapAxisFlagIcon;
var     SpriteWidget        MapAlliesFlagIcons[4];
var     SpriteWidget        MapIconMortarHETarget;
var     SpriteWidget        MapIconMortarSmokeTarget;
var     SpriteWidget        MapIconMortarArrow;
var     SpriteWidget        MapIconMortarHit;
var     SpriteWidget        MapPlayerNumberIcon;
var     array<texture>      PlayerNumberIconTextures;
var     SpriteWidget        SquadNameIcon;
var     SpriteWidget        CanMantleIcon;
var     SpriteWidget        CanCutWireIcon;
var     SpriteWidget        DeployOkayIcon;
var     SpriteWidget        DeployEnemiesNearbyIcon;
var     SpriteWidget        DeployInObjectiveIcon;
var     SpriteWidget        VehicleAltAmmoReloadIcon; // ammo reload icon for a coax MG, so reload progress can be shown on HUD like a tank cannon reload
var     SpriteWidget        VehicleMGAmmoReloadIcon;  // ammo reload icon for a vehicle mounted MG position
var     SpriteWidget        ExtraAmmoIcon; // extra ammo icon appears if the player has extra ammo to give out

// Map or screen text that can be localized for different languages
var     localized string    MapNameText;
var     localized string    MapGameTypeText;
var     localized string    NoTimeLimitText;
var     localized string    AndMoreText;
var     localized string    LegendCarriedArtilleryRadioText;
var     localized string    TimeElapsedText;
var     localized string    JoinTeamText;
var     localized string    SelectSpawnPointText;
var     localized string    SpawnInfantryText;
var     localized string    SpawnVehicleText;
var     localized string    SpawnAtVehicleText;
var     localized string    SpawnNoRoleText;
var     localized string    ReinforcementsDepletedText;
var     localized string    NeedReloadText;
var     localized string    CanReloadText;
var     localized string    DeathPenaltyText;

// Death messages
var     array<string>       ConsoleDeathMessages;   // paired with DHObituaries array & holds accompanying console death messages
var     array<Obituary>     DHObituaries;           // replaced RO's Obituaries static array, so we can have more than 4 death messages
var     float               ObituaryFadeInTime;     // for some added suspense:
var     float               ObituaryDelayTime;

// Displayed player & voice icon
var     array<Pawn>         NamedPawns;             // a list of all pawns whose names are currently being rendered
var     float               HUDLastNameDrawTime;    // the last time we called DrawPlayerNames() function, used so we can tell if a player has just become valid for name drawing
var     material            PlayerNameIconMaterial;
var     material            SpeakerIconMaterial;
var     material            NeedAssistIconMaterial;
var     material            NeedAmmoIconMaterial;

// User-configurable HUD settings
var     globalconfig bool   bSimpleColours;         // for colourblind setting, i.e. red and blue only
var     globalconfig bool   bShowDeathMessages;     // whether or not to show the death messages
var     globalconfig int    PlayerNameFontSize;     // the size of the name you see when you mouseover a player

// Debug
var     bool                bDebugVehicleHitPoints; // show all vehicle's special hit points (VehHitpoints & NewVehHitpoints), but not the driver's hit points
var     bool                bDebugVehicleWheels;    // show all vehicle's physics wheels (the Wheels array of invisible wheels that drive & steer vehicle, even ones with treads)
var     bool                bDebugCamera;           // in behind view, draws a red dot & white sphere to show current camera location, with a red line showing camera rotation
var     SkyZoneInfo         SavedSkyZone;           // saves original SkyZone for player's current ZoneInfo if sky is turned off for debugging, so can be restored when sky is turned back on

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

function DrawDebugInformation(Canvas C)
{
    local DHPlayer PC;
    local string S;
    local float X, Y, StrX, StrY;

    PC = DHPlayer(PlayerOwner);

    S = class'DHLib'.static.GetMapName(Level);

    if (PC != none && PC.Pawn != none)
    {
        S @= "[" $ int(PC.Pawn.Location.X) $ "," @ int(PC.Pawn.Location.Y) $ "," $ int(PC.Pawn.Location.Z) $ "]";
    }

    S @= class'DarkestHourGame'.default.Version.ToString();

    C.Style = ERenderStyle.STY_Alpha;
    C.Font = C.TinyFont;

    C.TextSize(S, StrX, StrY);
    Y = C.ClipY - StrY;
    X = C.ClipX - StrX;

    C.DrawColor = BlackColor;

    C.SetPos(X + 1, Y + 1);
    C.DrawTextClipped(S);

    C.DrawColor = WhiteColor;

    C.SetPos(X, Y);
    C.DrawTextClipped(S);
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(material'DH_GUI_Tex.GUI.overheadmap_Icons');
    Level.AddPrecacheMaterial(material'DH_GUI_Tex.GUI.AlliedStar');
    Level.AddPrecacheMaterial(material'DH_GUI_Tex.GUI.GerCross');

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
    Level.AddPrecacheMaterial(material'InterfaceArt_tex.OverheadMap.overheadmap_Icons');
    Level.AddPrecacheMaterial(material'InterfaceArt2_tex.overheadmaps.overheadmap_IconsB');

    Level.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.numbers');
    Level.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.situation_map_icon');

    Level.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.ger_player');
    Level.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.ger_player_background');
    Level.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.ger_player_Stamina');
    Level.AddPrecacheMaterial(FinalBlend'InterfaceArt_tex.HUD.ger_player_Stamina_critical');
    Level.AddPrecacheMaterial(material'DH_GUI_Tex.GUI.US_player');
    Level.AddPrecacheMaterial(material'DH_GUI_Tex.GUI.US_player_background');
    Level.AddPrecacheMaterial(material'DH_GUI_Tex.GUI.US_player_Stamina');
    Level.AddPrecacheMaterial(FinalBlend'DH_GUI_Tex.GUI.US_player_Stamina_critical');

    Level.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.stance_stand');
    Level.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.stance_crouch');
    Level.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.stance_prone');

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

simulated function Message(PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
    local DHPlayer PC;
    local class<LocalMessage>   MessageClassType;
    local class<DHLocalMessage> DHMessageClassType;

    PC = DHPlayer(PlayerOwner);

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
// Also to save a console death message in a paired ConsoleDeathMessages array,
// so it can be displayed later, only when the delayed screen death message is
// shown.
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
        O.KillerColor = class'DHColor'.default.TeamColors[Killer.Team.TeamIndex];
    }

    O.VictimName = Victim.PlayerName;
    O.VictimColor = class'DHColor'.default.TeamColors[Victim.Team.TeamIndex];
    O.DamageType = DamageType;

    // If a suicide, team kill, or spawn kill then have the kill message display ASAP
    if ((Killer != none && Killer.Team.TeamIndex == Victim.Team.TeamIndex) || DamageType == class'DHSpawnKillDamageType')
    {
        O.EndOfLife = Level.TimeSeconds + (ObituaryLifeSpan - ObituaryDelayTime);
    }
    else // Otherwise have it wait the delay time (the entire life span)
    {
        O.EndOfLife = Level.TimeSeconds + ObituaryLifeSpan;
    }

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

// Modified to correct bug that sometimes screwed up layout of critical message,
// resulting in very long text lines going outside of message background
// and  sometimes off screen
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

static function Font GetPlayerNameFont(Canvas C)
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
simulated event PostRender(Canvas Canvas)
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
    local DHVoiceChatRoom    VCR;
    local float              Y, XL, YL, Alpha;
    local string             s;
    local color              MyColor;
    local AbsoluteCoordsInfo Coords;
    local ROWeapon           MyWeapon;
    local byte               BlockFlags;
    local vector             CameraLocation;
    local rotator            CameraRotation;
    local Actor              ViewActor;

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

        // Extra ammo icon
        if (!DHPawn(PawnOwner).bUsedCarriedMGAmmo)
        {
            DrawSpriteWidget(C, ExtraAmmoIcon);
        }
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
    if (DHVehicle(PawnOwner) != none && DHVehicle(PawnOwner).bIsSpawnVehicle)
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

    // Weapon info
    if (bShowWeaponInfo && PawnOwner.Weapon != none)
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
        MyColor.A = byte(Alpha * 255.0);

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
            VCR = DHVoiceChatRoom(PlayerOwner.VoiceReplicationInfo.GetChannelAt(PortraitPRI.ActiveChannel));

            if (PortraitPRI.Team != none)
            {
                if (PortraitPRI.Team.TeamIndex == 0)
                {
                    PortraitIcon.WidgetTexture = CaptureBarTeamIcons[0];
                    PortraitText[0].Tints[TeamIndex] = class'DHColor'.default.TeamColors[0];
                }
                else if (PortraitPRI.Team.TeamIndex == 1)
                {
                    PortraitIcon.WidgetTexture = CaptureBarTeamIcons[1];
                    PortraitText[0].Tints[TeamIndex] = class'DHColor'.default.TeamColors[1];
                }
                else
                {
                    PortraitIcon.WidgetTexture = CaptureBarTeamIcons[0];
                    PortraitText[0].Tints[TeamIndex] = default.PortraitText[0].Tints[TeamIndex];
                }
            }

            // PortraitX goes from 0 to 1 -- we'll use that as alpha
            PortraitIcon.Tints[TeamIndex].A = byte(255 * (1.0 - PortraitX));
            PortraitText[0].Tints[TeamIndex].A = PortraitIcon.Tints[TeamIndex].A;

            XL = 0.0;
            DrawSpriteWidgetClipped(C, PortraitIcon, Coords, true, XL, YL, false, true);

            // Draw first line of text
            PortraitText[0].OffsetX = PortraitIcon.OffsetX * PortraitIcon.TextureScale + XL * 1.1;
            PortraitText[0].Text = PortraitPRI.PlayerName;
            C.Font = GetFontSizeIndex(C, -2);
            DrawTextWidgetClipped(C, PortraitText[0], Coords);

            // Draw second line of text
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
        // Draw all player's body part hit points & bullet whip attachment
        if (bDebugPlayerCollision)
        {
            DrawPointSphere();
        }

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

        // Draw all vehicle's physics wheels
        if (bDebugVehicleWheels)
        {
            DrawVehiclePhysiscsWheels();
        }

        // Show camera location & rotation in behind view (needs "show sky" in console)
        if (bDebugCamera && PlayerOwner != none && PlayerOwner.bBehindView && Vehicle(PawnOwner) != none)
        {
            Vehicle(PawnOwner).SpecialCalcFirstPersonView(PlayerOwner, ViewActor, CameraLocation, CameraRotation);
            DrawDebugSphere(CameraLocation, 1.0, 4, 255, 0, 0);       // camera location shown as very small red sphere, like a large dot
            DrawDebugSphere(CameraLocation, 10.0, 10, 255, 255, 255); // larger white sphere to make actual camera location more visible, especially if it's inside the mesh
            DrawDebugLine(CameraLocation, CameraLocation + (60.0 * vector(CameraRotation)), 255, 0, 0); // red line to show camera rotation
        }

        DrawDebugInformation(C);
    }
}

// Draws all the vehicle HUD info, e.g. vehicle icon, passengers, ammo, speed, throttle
// Overridden to handle new system where rider pawns won't exist on clients unless occupied (& generally prevent spammed log errors)
function DrawVehicleIcon(Canvas Canvas, ROVehicle Vehicle, optional ROVehicleWeaponPawn Passenger)
{
    local DHVehicle          V;
    local DHVehicleCannon    Cannon;
    local VehicleWeaponPawn  WP;
    local AbsoluteCoordsInfo Coords, Coords2;
    local SpriteWidget       Widget;
    local rotator            MyRot;
    local float              XL, YL, Y_one, StrX, StrY, Team, MaxChange, ProportionOfReloadRemaining, f;
    local int                Current, Pending, i;
    local color              VehicleColor;
    local array<color>       Colors;
    local array<string>      Lines;

    if (bHideHud)
    {
        return;
    }

    // Figure where to draw
    Coords.PosX = Canvas.ClipX * VehicleIconCoords.X;
    Coords.Height = Canvas.ClipY * VehicleIconCoords.YL * HudScale;
    Coords.PosY = Canvas.ClipY * VehicleIconCoords.Y - Coords.Height;
    Coords.Width = Coords.Height;

    // Compute whole-screen coords
    Coords2.PosX = 0.0;
    Coords2.PosY = 0.0;
    Coords2.Width = Canvas.ClipX;
    Coords2.Height = Canvas.ClipY;

    /////////////////////////////////////////////////////////////////
    // Draw vehicle icon, with passenger dots & any damage indicators
    /////////////////////////////////////////////////////////////////

    Widget = VehicleIcon;

    // Set vehicle color based on any damage
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

    // Draw vehicle icon, with clockface around it
    if (Vehicle.VehicleHudImage != none)
    {
        Widget.WidgetTexture = Vehicle.VehicleHudImage;
        Widget.TextureCoords.X2 = Vehicle.VehicleHudImage.MaterialUSize() - 1;
        Widget.TextureCoords.Y2 = Vehicle.VehicleHudImage.MaterialVSize() - 1;
        Widget.TextureScale = Vehicle.VehicleHudImage.MaterialUSize() / 256;
        DrawSpriteWidgetClipped(Canvas, Widget, Coords, true);
    }

    VehicleIcon.WidgetTexture = material'DH_InterfaceArt_tex.Tank_Hud.clock_face';
    DrawSpriteWidgetClipped(Canvas, VehicleIcon, Coords, true);

    VehicleIcon.WidgetTexture = material'DH_InterfaceArt_tex.Tank_Hud.clock_numbers';
    DrawSpriteWidgetClipped(Canvas, VehicleIcon, Coords, true);

    V = DHVehicle(Vehicle);

    if (V != none)
    {
        // Draw engine damage icon (if needed) - modified to show red if engine badly damaged enough to slow vehicle, & to flash red if engine is dead
        if (V.EngineHealth <= (V.default.EngineHealth * V.HeavyEngineDamageThreshold))
        {
            if (V.EngineHealth <= 0)
            {
                VehicleEngine.WidgetTexture = VehicleEngineCriticalTexture; // flashing red icon
            }
            else
            {
                VehicleEngine.WidgetTexture = VehicleEngineDamagedTexture; // red icon (not flashing)
            }

            VehicleEngine.PosX = V.VehicleHudEngineX;
            VehicleEngine.PosY = V.VehicleHudEngineY;
            DrawSpriteWidgetClipped(Canvas, VehicleEngine, Coords, true);
        }

        // Draw any damaged treads
        if (V.bLeftTrackDamaged)
        {
            VehicleThreads[0].TextureScale = V.VehicleHudTreadsScale;
            VehicleThreads[0].PosX = V.VehicleHudTreadsPosX[0];
            VehicleThreads[0].PosY = V.VehicleHudTreadsPosY;
            DrawSpriteWidgetClipped(Canvas, VehicleThreads[0], Coords, true, XL, YL, false, true);
        }

        if (V.bRightTrackDamaged)
        {
            VehicleThreads[1].TextureScale = V.VehicleHudTreadsScale;
            VehicleThreads[1].PosX = V.VehicleHudTreadsPosX[1];
            VehicleThreads[1].PosY = V.VehicleHudTreadsPosY;
            DrawSpriteWidgetClipped(Canvas, VehicleThreads[1], Coords, true, XL, YL, false, true);
        }

        // Draw any turret icon, with current turret rotation
        if (V.Cannon != none && V.VehicleHudTurret != none)
        {
            MyRot = rotator(vector(V.Cannon.CurrentAim) >> V.Cannon.Rotation);
            V.VehicleHudTurret.Rotation.Yaw = V.Rotation.Yaw - MyRot.Yaw;
            Widget.WidgetTexture = V.VehicleHudTurret;
            Widget.TextureCoords.X2 = V.VehicleHudTurret.MaterialUSize() - 1;
            Widget.TextureCoords.Y2 = V.VehicleHudTurret.MaterialVSize() - 1;
            Widget.TextureScale = V.VehicleHudTurret.MaterialUSize() / 256;
            DrawSpriteWidgetClipped(Canvas, Widget, Coords, true);
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
            else if (Vehicle.Driver != none || Vehicle.bDriving) // added bDriving as net client doesn't have Driver pawn if he's hidden because bDrawDriverInTP=false
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

            MapPlayerNumberIcon.TextureScale = 0.15;
            MapPlayerNumberIcon.PosX = Vehicle.VehicleHudOccupantsX[0];
            MapPlayerNumberIcon.PosY = Vehicle.VehicleHudOccupantsY[0];
            MapPlayerNumberIcon.WidgetTexture = PlayerNumberIconTextures[i];

            DrawSpriteWidgetClipped(Canvas, MapPlayerNumberIcon, Coords, true);
        }
        else
        {
            if (i - 1 >= Vehicle.WeaponPawns.Length)
            {
                break;
            }

            WP = Vehicle.WeaponPawns[i - 1];

            if (WP == none) // added to show missing rider/passenger pawns, as now they won't exist on clients unless occupied
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsVacantColor;
            }
            else if (WP == Passenger)
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsPlayerColor;
            }
            else if (WP.PlayerReplicationInfo != none)
            {
                if (Passenger != none && Passenger.PlayerReplicationInfo != none && WP.PlayerReplicationInfo == Passenger.PlayerReplicationInfo)
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

            MapPlayerNumberIcon.TextureScale = 0.15;
            MapPlayerNumberIcon.PosX = Vehicle.VehicleHudOccupantsX[i];
            MapPlayerNumberIcon.PosY = Vehicle.VehicleHudOccupantsY[i];
            MapPlayerNumberIcon.WidgetTexture = PlayerNumberIconTextures[Min(i, PlayerNumberIconTextures.Length - 1)];
            DrawSpriteWidgetClipped(Canvas, MapPlayerNumberIcon, Coords, true);
        }
    }

    //////////////////////////////////////////////////////////////////
    // If player is vehicle driver - draw speed, rpm & throttle gauges
    //////////////////////////////////////////////////////////////////

    if (Passenger == none)
    {
        // Get team index
        if (Vehicle.Controller != none && Vehicle.Controller.PlayerReplicationInfo != none && Vehicle.Controller.PlayerReplicationInfo.Team != none)
        {
            if (Vehicle.Controller.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
            {
                Team = AXIS_TEAM_INDEX;
            }
            else
            {
                Team = ALLIES_TEAM_INDEX;
            }
        }
        else
        {
            Team = AXIS_TEAM_INDEX;
        }

        // If more than half a second since we drew the gauges, reset the saved values as they are obsolete
        if (Level.TimeSeconds - VehicleNeedlesLastRenderTime >= 0.5)
        {
            VehicleLastSpeedRotation = 0.0;
            VehicleLastRPMRotation = 0.0;
        }

        // Set a maximum needle rotation change, to smooth movement, & record last render time
        MaxChange = (Level.TimeSeconds - VehicleNeedlesLastRenderTime) * VehicleNeedlesRotationSpeed;
        VehicleNeedlesLastRenderTime = Level.TimeSeconds;

        // Update speed needle value
        f = VSize(Vehicle.Velocity) * 0.05965; // convert from UU to kph // was " * 3600.0 / 60.352 / 1000.0" but optimised calculation as done many times per sec
        f *= VehicleSpeedScale[Team];
        f += VehicleSpeedZeroPosition[Team];

        if (f < VehicleLastSpeedRotation)
        {
            VehicleLastSpeedRotation = Max(f, VehicleLastSpeedRotation - MaxChange);
        }
        else
        {
            VehicleLastSpeedRotation = Min(f, VehicleLastSpeedRotation + MaxChange);
        }

        // Draw the speed guage
        VehicleSpeedIndicator.WidgetTexture = VehicleSpeedTextures[Team];
        DrawSpriteWidgetClipped(Canvas, VehicleSpeedIndicator, Coords, true, XL, YL, false, true); // background

        TexRotator(VehicleSpeedNeedlesTextures[Team]).Rotation.Yaw = VehicleLastSpeedRotation; // update needle rotation
        VehicleSpeedIndicator.WidgetTexture = VehicleSpeedNeedlesTextures[Team];
        DrawSpriteWidgetClipped(Canvas, VehicleSpeedIndicator, Coords, true, XL, YL, false, true); // needle

        // Update RPM needle value
        if (ROWheeledVehicle(Vehicle) != none)
        {
            f = ROWheeledVehicle(Vehicle).EngineRPM / 100.0;
            f *= VehicleRPMScale[Team];
            f += VehicleRPMZeroPosition[Team];

            if (f < VehicleLastRPMRotation)
            {
                VehicleLastRPMRotation = Max(f, VehicleLastRPMRotation - MaxChange);
            }
            else
            {
                VehicleLastRPMRotation = Min(f, VehicleLastRPMRotation + MaxChange);
            }
        }

        // Draw the RPM guage
        VehicleRPMIndicator.WidgetTexture = VehicleRPMTextures[Team];
        DrawSpriteWidgetClipped(Canvas, VehicleRPMIndicator, Coords, true, XL, YL, false, true);

        TexRotator(VehicleRPMNeedlesTextures[Team]).Rotation.Yaw = VehicleLastRPMRotation;
        VehicleRPMIndicator.WidgetTexture = VehicleRPMNeedlesTextures[Team];
        DrawSpriteWidgetClipped(Canvas, VehicleRPMIndicator, Coords, true, XL, YL, false, true);

        // Check if we should draw a throttle gauge
        if (ROPlayer(Vehicle.Controller) != none && ((ROPlayer(Vehicle.Controller).bInterpolatedTankThrottle && Vehicle.IsA('DHArmoredVehicle'))
            || (ROPlayer(Vehicle.Controller).bInterpolatedVehicleThrottle && !Vehicle.IsA('DHArmoredVehicle'))))
        {
            Y_one = YL; // save YL for use later

            // Check which throttle variable we should use
            if (PlayerOwner != Vehicle.Controller && ROWheeledVehicle(Vehicle) != none)
            {
                // Unpack replicated ThrottleRep
                f = ROWheeledVehicle(Vehicle).ThrottleRep;

                if (f <= 100.0) // negative throttle
                {
                    f = -f / 100.0;
                }
                else
                {
                    f = (f - 101.0) / 100.0;
                }
            }
            else
            {
                f = Vehicle.Throttle;
            }

            // Draw throttle shaded bar in top or bottom (depending if throttle is positive or negative) & set the throttle lever position
            if (f ~= 0.0) // throttle zeroed - no shaded bar
            {
                VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - (Y_one * VehicleThrottleTopZeroPosition);
            }
            else if (f > 0.0) // throttle is forwards
            {
                VehicleThrottleIndicatorTop.Scale = VehicleThrottleTopZeroPosition + (f * (VehicleThrottleTopMaxPosition - VehicleThrottleTopZeroPosition));
                DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorTop, Coords, true, XL, YL, false, true);

                VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - (Y_one * VehicleThrottleIndicatorTop.Scale);
            }
            else // throttle is pulled back
            {
                VehicleThrottleIndicatorBottom.Scale = VehicleThrottleBottomZeroPosition - (f * (VehicleThrottleBottomMaxPosition - VehicleThrottleBottomZeroPosition));
                DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorBottom, Coords, true, XL, YL, false, true);

                VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - (Y_one * (1.0 - VehicleThrottleIndicatorBottom.Scale));
            }

            // Draw the throttle gauge
            DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorBackground, Coords, true, XL, YL, false, true);
            DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorForeground, Coords, true, XL, YL, false, true);
            DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorLever, Coords, true, XL, YL, true, true);
        }
    }

    ////////////////////////////////////////////////////////////////
    // Draw turret & ammo if player is in a turret/cannon
    ////////////////////////////////////////////////////////////////

    else if (DHVehicleCannonPawn(Passenger) != none)
    {
        // Update & draw look turret, with current turret rotation
        if (V != none && V.VehicleHudTurretLook != none)
        {
            V.VehicleHudTurretLook.Rotation.Yaw = V.Rotation.Yaw - Passenger.CustomAim.Yaw;
            Widget.WidgetTexture = V.VehicleHudTurretLook;
            Widget.Tints[0].A /= 2;
            Widget.Tints[1].A /= 2;
            DrawSpriteWidgetClipped(Canvas, Widget, Coords, true);
        }

        if (bShowWeaponInfo)
        {
            // Draw cannon ammo icon
            VehicleAmmoIcon.WidgetTexture = Passenger.AmmoShellTexture;
            DrawSpriteWidget(Canvas, VehicleAmmoIcon);

            // Draw reload progress (if needed)
            ProportionOfReloadRemaining = Passenger.GetAmmoReloadState();

            if (ProportionOfReloadRemaining > 0.0)
            {
                VehicleAmmoReloadIcon.WidgetTexture = Passenger.AmmoShellReloadTexture;
                VehicleAmmoReloadIcon.Scale = ProportionOfReloadRemaining;
                DrawSpriteWidget(Canvas, VehicleAmmoReloadIcon);
            }

            Cannon = DHVehicleCannon(Passenger.Gun);

            if (Cannon != none)
            {
                // Draw cannon ammo count
                VehicleAmmoAmount.Value = Cannon.PrimaryAmmoCount();
                DrawNumericWidget(Canvas, VehicleAmmoAmount, Digits);

                // Draw different cannon ammo types
                if (Cannon.bMultipleRoundTypes)
                {
                    // Get ammo types text, font & position
                    // GetAmmoIndex() & LocalPendingAmmoIndex replace deprecated GetRoundsDescription(Lines) & GetPendingRoundIndex(), with Lines array constructed directly by for loop below
                    Current = Cannon.GetAmmoIndex();
                    Pending = Cannon.LocalPendingAmmoIndex;

                    for (i = 0; i < Cannon.ProjectileDescriptions.Length; ++i)
                    {
                        Lines[i] = Cannon.ProjectileDescriptions[i];
                    }

                    VehicleAmmoTypeText.OffsetY = default.VehicleAmmoTypeText.OffsetY * HudScale;

                    if (HudScale < 0.85)
                    {
                        Canvas.Font = GetConsoleFont(Canvas);
                    }
                    else
                    {
                        Canvas.Font = GetSmallMenuFont(Canvas);
                    }

                    // Draw ammo types (from last, upwards on the screen)
                    for (i = Lines.Length - 1; i >= 0; --i)
                    {
                        if (Lines[i] == "")
                        {
                            continue;
                        }

                        if (i == Current)
                        {
                            Lines[i] = ">" $ Lines[i]; // add indicator prefix for currently ammo type (adjust drawing position to suit)
                            Canvas.TextSize(">", StrX, StrY);
                            VehicleAmmoTypeText.OffsetX -= StrX;
                            VehicleAmmoTypeText.Tints[TeamIndex].A = 255; // bold text for current ammo type
                        }
                        else
                        {
                            VehicleAmmoTypeText.Tints[TeamIndex].A = 128; // pale text for other available ammo types
                        }

                        if (i == Pending)
                        {
                            Lines[i] = Lines[i] $ "<-"; // add indicator suffix to pending ammo type
                        }

                        // Draw this ammo type & adjust drawing position for next type
                        VehicleAmmoTypeText.Text = Lines[i];
                        DrawTextWidgetClipped(Canvas, VehicleAmmoTypeText, Coords2, XL, YL, Y_one);
                        VehicleAmmoTypeText.OffsetY -= YL;

                        if (i == Current)
                        {
                            VehicleAmmoTypeText.OffsetX += StrX; // reset after adjusting for current ammo indicator
                        }
                    }
                }

                // Draw coaxial MG ammo info (if present)
                if (Passenger.bHasAltFire && Cannon.AltFireProjectileClass != none)
                {
                    // Draw coaxial MG ammo icon
                    VehicleAltAmmoIcon.WidgetTexture = Cannon.HudAltAmmoIcon;
                    DrawSpriteWidget(Canvas, VehicleAltAmmoIcon);

                    // Draw coaxial MG reload progress (if needed) // added to show reload progress in red, like a tank cannon reload
                    ProportionOfReloadRemaining = DHVehicleCannonPawn(Passenger).GetAltAmmoReloadState();

                    if (ProportionOfReloadRemaining > 0.0)
                    {
                        VehicleAltAmmoReloadIcon.WidgetTexture = DHVehicleCannonPawn(Passenger).AltAmmoReloadTexture;
                        VehicleAltAmmoReloadIcon.Scale = ProportionOfReloadRemaining;
                        DrawSpriteWidget(Canvas, VehicleAltAmmoReloadIcon);
                    }

                    // Draw coaxial MG ammo amount
                    VehicleAltAmmoAmount.Value = Cannon.GetNumMags();
                    DrawNumericWidget(Canvas, VehicleAltAmmoAmount, Digits);
                }
            }
        }
    }

    ///////////////////////////////////////////////
    // If player is in a hull-mounted MG, draw ammo
    ///////////////////////////////////////////////

    else if (DHVehicleMGPawn(Passenger) != none && bShowWeaponInfo && ROVehicleWeapon(Passenger.Gun) != none)
    {
        // Draw MG ammo icon
        VehicleMGAmmoIcon.WidgetTexture = ROVehicleWeapon(Passenger.Gun).HudAltAmmoIcon;
        DrawSpriteWidget(Canvas, VehicleMGAmmoIcon);

        // Draw MG reload progress (if needed) // added to show reload progress in red, like a tank cannon reload
        ProportionOfReloadRemaining = Passenger.GetAmmoReloadState();

        if (ProportionOfReloadRemaining > 0.0)
        {
            VehicleMGAmmoReloadIcon.WidgetTexture = DHVehicleMGPawn(Passenger).VehicleMGReloadTexture;
            VehicleMGAmmoReloadIcon.Scale = ProportionOfReloadRemaining;
            DrawSpriteWidget(Canvas, VehicleMGAmmoReloadIcon);
        }

        // Draw ammo count
        VehicleMGAmmoAmount.Value = ROVehicleWeapon(Passenger.Gun).GetNumMags();
        DrawNumericWidget(Canvas, VehicleMGAmmoAmount, Digits);
    }

    ///////////////////////////////////////////////////////////
    // Draw vehicle occupant names (now including our own name)
    ///////////////////////////////////////////////////////////

    Lines.Length = 0; // clear array

    // Get driver name & color
    if (Vehicle.PlayerReplicationInfo != none)
    {
        Lines[0] = "1." @ Vehicle.PlayerReplicationInfo.PlayerName;
        Colors[0] = GetPlayerColor(DHPlayerReplicationInfo(Vehicle.PlayerReplicationInfo));
    }

    // Get passenger names & colors
    for (i = 0; i < Vehicle.WeaponPawns.Length; ++i)
    {
        WP = Vehicle.WeaponPawns[i];

        if (WP != none && WP.PlayerReplicationInfo != none)
        {
            //Lines[Lines.Length] = "" $ (i + 2) $ "." @ WP.PlayerReplicationInfo.PlayerName;
            Lines[Lines.Length] = (i + 2) $ "." @ WP.PlayerReplicationInfo.PlayerName;
            Colors[Colors.Length] = GetPlayerColor(DHPlayerReplicationInfo(WP.PlayerReplicationInfo));
        }
    }

    // Draw the names
    if (Lines.Length > 0)
    {
        Canvas.Font = GetPlayerNameFont(Canvas);
        VehicleOccupantsText.OffsetY = default.VehicleOccupantsText.OffsetY * HudScale;

        for (i = Lines.Length - 1; i >= 0; --i)
        {
            VehicleOccupantsText.Text = Lines[i];
            VehicleOccupantsText.Tints[0] = Colors[i];
            VehicleOccupantsText.Tints[1] = Colors[i];
            DrawTextWidgetClipped(Canvas, VehicleOccupantsText, Coords2, XL, YL, Y_one);
            VehicleOccupantsText.OffsetY -= YL;
        }
    }
}

function color GetPlayerColor(DHPlayerReplicationInfo PRI)
{
    local DHPlayerReplicationInfo MyPRI;

    if (PlayerOwner != none)
    {
        MyPRI = DHPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);
    }

    if (PRI != none && PRI.Team != none)
    {
        return class'DHColor'.default.TeamColors[PRI.Team.TeamIndex];
    }

    return class'UColor'.default.White;
}

// Modified to show the names of friendly players within 25m if they are talking, or if we can resupply them or assist them with loading a rocket
// This is as well as any player we are looking directly at (within a longer distance of 50m)
// We also show a relevant icon above a drawn name if the player is talking or if we can resupply or assist reload them
function DrawPlayerNames(Canvas C)
{
    local DHPlayerReplicationInfo OtherPRI;
    local ROVehicle               VehicleBase;
    local VehicleWeaponPawn       WepPawn;
    local DHMortarVehicle         Mortar;
    local Actor                   A;
    local Pawn                    LookedAtPawn, PawnForLocation, P;
    local array<Pawn>             Pawns;
    local material                IconMaterial;
    local color                   TeamColor;
    local vector                  ViewLocation, DrawLocation, HitLocation, HitNormal, TextSize, PlayerDirection;
    local string                  PlayerName;
    local float                   Now, NameFadeTime, HighestFadeInReached;
    local int                     NumOtherOccupants, i, j;
    local byte                    Alpha;
    local bool                    bMayBeValid, bCurrentlyValid, bFoundMatch;

    if (PawnOwner == none || PlayerOwner == none)
    {
        return;
    }

    ViewLocation = PlayerOwner.CalcViewLocation;

    // STAGE 1: check if we are looking directly at player (or a vehicle with a player) within 50m, who is not behind something
    foreach TraceActors(class'Actor', A, HitLocation, HitNormal, ViewLocation + (3018.0 * vector(PlayerOwner.CalcViewRotation)), ViewLocation)
    {
        if (A.bBlockActors)
        {
            // If traced a collision mesh actor, we switch traced actor to col mesh's owner & proceed as if we'd hit that actor
            if (A.IsA('DHCollisionMeshActor') && A.Owner != none)
            {
                A = A.Owner;
            }

            // We may be looking at a vehicle weapon (usually turret, could be some MGs with collision) & its owner will be a weapon pawn
            // If it's occupied, we'll use the weapon pawn as our LookedAtPawn, otherwise we'll check the vehicle for other occupants
            WepPawn = VehicleWeaponPawn(A.Owner);

            if (WepPawn != none)
            {
                if (WepPawn.bDriving)
                {
                    A = WepPawn;
                }

                VehicleBase = WepPawn.VehicleBase;
            }
            else
            {
                VehicleBase = ROVehicle(A);
            }

            // We're looking towards a vehicle, so if it has a driver we use the Vehicle as LookedAtPawn, otherwise we use any other occupied position (1st we find)
            // But we skip this if we've already found an occupied weapon pawn
            if (VehicleBase != none && A != WepPawn)
            {
                if (VehicleBase.bDriving)
                {
                    A = VehicleBase;
                }
                else
                {
                    for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
                    {
                        WepPawn = VehicleBase.WeaponPawns[i];

                        if (WepPawn != none && WepPawn.bDriving)
                        {
                            A = WepPawn;
                            break;
                        }
                    }
                }
            }

            // Make sure we aren't looking at our own pawn (happens in a vehicle or if moving forward)
            // Otherwise if we're looking at a pawn, record it & put it in the start of our Pawns array, then exit the foreach iteration
            if (A != PawnOwner && A != none)
            {
                LookedAtPawn = Pawn(A);

                if (LookedAtPawn != none)
                {
                    Pawns[0] = LookedAtPawn;
                }

                break;
            }
        }
    }

    // STAGE 2: find all other pawns within 25 meters & build our Pawns array (excluding our own pawn & any LookedAtPawn we've already added)
    foreach RadiusActors(class'Pawn', P, 1509.0, ViewLocation)
    {
        if (P != PawnOwner && P != LookedAtPawn)
        {
            Pawns[Pawns.Length] = P;
        }
    }

    // STAGE 3: now loop through all those pawns we gathered & check whether they are currently valid, removing any that are not
    // Then check whether any currently valid pawn is in the saved array of NamedPawns - if not then we add it to NamedPawns as a new player name to start drawing
    for (i = Pawns.Length - 1; i >= 0; --i)
    {
        P = Pawns[i];

        // Remove enemy players, pawns that are not being controlled (e.g. empty vehicle pawns) & spectators
        if (P == none || P.PlayerReplicationInfo == none || P.GetTeamNum() != PlayerOwner.GetTeamNum())
        {
            Pawns.Remove(i, 1);
            continue;
        }

        bCurrentlyValid = false; // reset for each pawn to be checked

        // The LookedAtPawn is always valid, as we're looking directly at them & know they are within range
        if (P == LookedAtPawn)
        {
            bCurrentlyValid = true;
        }
        // Player is talking, so will be valid if he's not hidden behind an obstruction (we'll do a line of sight check next)
        else if (P.PlayerReplicationInfo == PortraitPRI)
        {
            bMayBeValid = true;
        }
        // Player is manning a mortar, so we do a specific check whether we can resupply the mortar
        else if (P.IsA('DHMortarVehicleWeaponPawn'))
        {
            Mortar = DHMortarVehicle(VehicleWeaponPawn(P).VehicleBase);
            bMayBeValid = Mortar != none && Mortar.bCanBeResupplied && ROPawn(PlayerOwner.Pawn) != none && !ROPawn(PlayerOwner.Pawn).bUsedCarriedMGAmmo;
        }
        // Check whether we can resupply the player or assist them with loading a rocket
        else if (DHPawn(P) != none)
        {
            bMayBeValid = (DHPawn(P).bWeaponNeedsResupply && ROPawn(PlayerOwner.Pawn) != none && !ROPawn(PlayerOwner.Pawn).bUsedCarriedMGAmmo) // we can resupply ammo
                        || DHPawn(P).bWeaponNeedsReload;                                                                                       // we can assist rocket reload
        }
        // Player isn't currently valid as we aren't looking at them, they aren't talking, & we can't resupply them or assist them with loading a rocket
        else
        {
            bMayBeValid = false;
        }

        // Player may be valid as he is talking or needs resupply/reload, but we need to check he's not hidden behind an obstruction
        if (bMayBeValid && !bCurrentlyValid)
        {
            // If player is in a vehicle, use the vehicle/weapon pawn's DHPawn location for a more accurate line of sight check
            if (P.IsA('Vehicle') && Vehicle(P).Driver != none && Vehicle(P).bDrawDriverInTP)
            {
                bCurrentlyValid = FastTrace(Vehicle(P).Driver.Location, ViewLocation);
            }
            else
            {
                bCurrentlyValid = FastTrace(P.Location, ViewLocation);
            }
        }

        // Remove pawn from array if not currently valid
        if (!bCurrentlyValid)
        {
            Pawns.Remove(i, 1);
            continue;
        }

        // Check whether this currently valid pawn is already in the saved NamedPawns array - if not then we add it
        bFoundMatch = false;

        for (j = 0; j < NamedPawns.Length; ++j)
        {
            if (P == NamedPawns[j])
            {
                bFoundMatch = true;
                break;
            }
        }

        if (!bFoundMatch)
        {
            NamedPawns[NamedPawns.Length] = P;
        }
    }

    // STAGE 4: loop through saved NamedPawns array of players that are being drawn & check whether they still need to be shown, removing them if they don't
    // Then we draw the all remaining names, calculating any required fade in or out, & any relevant icons to be displayed above the name

    Now = Level.TimeSeconds; // ensures consistent current time is applied throughout the loop

    if (NamedPawns.Length > 0)
    {
        C.Font = GetPlayerNameFont(C);
        TeamColor = GetPlayerColor(DHPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo));
    }

    for (i = NamedPawns.Length - 1; i >= 0; --i)
    {
        P = NamedPawns[i];

        if (P != none)
        {
            OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
        }

        // Remove any pawns that are no longer being controlled or no longer exist
        if (OtherPRI == none || P == none)
        {
            NamedPawns.Remove(i, 1);
            continue;
        }

        bCurrentlyValid = false; // need to reset each iteration

        // Check if this NamedPawn is in our Pawns array of currently valid pawns
        for (j = 0; j < Pawns.Length; ++j)
        {
            if (P == Pawns[j])
            {
                bCurrentlyValid = true;
                break;
            }
        }

        if (bCurrentlyValid)
        {
            // Player has just become valid, as his name wasn't drawn last frame (his LastNameDrawTime was prior to the recorded HUDLastNameDrawTime)
            if (OtherPRI.LastNameDrawTime < HUDLastNameDrawTime)
            {
                // Check if player's name was previously in the process of being faded out
                HighestFadeInReached = FClamp(OtherPRI.LastNameDrawTime - OtherPRI.NameDrawStartTime, 0.0, 1.0); // maximum fade in value reached while player was valid
                NameFadeTime = OtherPRI.LastNameDrawTime + HighestFadeInReached - Now;

                // Now set his new NameDrawStartTime, so fade in can be calculated in future frames
                // And if player was being faded out, we'll fudge the NameDrawStartTime so we begin drawing his name at the same alpha level, but now fading back in
                OtherPRI.NameDrawStartTime = Now;

                if (NameFadeTime > 0.0)
                {
                    OtherPRI.NameDrawStartTime -= FMin(NameFadeTime, 1.0);
                }
            }

            // Update player's LastNameDrawTime & NameFadeTime
            // Note even if player is off screen & won't actually be drawn, we still update LastNameDrawTime as we don't want his name to fade in if we turn towards him
            OtherPRI.LastNameDrawTime = Now;
            NameFadeTime = Now - OtherPRI.NameDrawStartTime;

            // A slight fade threshold before starting to draw looked at player's name, just to stop it flickering up briefly if you only very quickly track over him
            if (NameFadeTime < 0.05 && P == LookedAtPawn)
            {
                continue;
            }
        }
        // Player isn't currently valid, but recently was & his name may still need to be shown fading out
        else
        {
            // Note the name may fade out in less than 1 second if the player wasn't drawn long enough to fully fade in
            // So we 1st calculate the maximum fade in value reached while the player was valid
            HighestFadeInReached = FClamp(OtherPRI.LastNameDrawTime - OtherPRI.NameDrawStartTime, 0.0, 1.0);
            NameFadeTime = OtherPRI.LastNameDrawTime + HighestFadeInReached - Now;

            // If player has fully faded out now, ignore him & remove from NamedPawns array
            if (NameFadeTime <= 0.0)
            {
                NamedPawns.Remove(i, 1);
                continue;
            }
        }

        // If player is in a vehicle, use the vehicle/weapon pawn's DHPawn so we can get a more accurate location for position checks & drawing
        if (P.IsA('Vehicle') && Vehicle(P).Driver != none && Vehicle(P).bDrawDriverInTP)
        {
            PawnForLocation = Vehicle(P).Driver;
        }
        else
        {
            PawnForLocation = P;
        }

        // For players other than the one we're looking directly at, check that they are broadly in front of us & so will be on our screen
        if (P != LookedAtPawn)
        {
            PlayerDirection = Normal(PawnForLocation.Location - PawnOwner.Location);

            if (PlayerDirection dot vector(PlayerOwner.CalcViewRotation) < 0.0)
            {
                continue;
            }
        }

        // We're going to draw this player's name, so get it
        // And if we are looking at a player in a vehicle, count any other vehicle occupants & append the count to his name, in the format "HisPlayerName (+2)"
        PlayerName = OtherPRI.PlayerName;

        if (P == LookedAtPawn && VehicleBase != none)
        {
            NumOtherOccupants = VehicleBase.NumPassengers() - 1;

            if (NumOtherOccupants > 0)
            {
                PlayerName @= "(+" $ NumOtherOccupants $ ")";
            }
        }

        // Set to draw the name & name icon in our team's color
        // And if player's name is fading in or out, lower the drawing alpha value accordingly
        C.DrawColor = TeamColor;

        if (NameFadeTime < 1.0 && NameFadeTime >= 0.0)
        {
            Alpha = byte(NameFadeTime * 255.0);
            C.DrawColor.A = Alpha;
        }
        else
        {
            Alpha = 255;
        }

        // Get the screen location for drawing player name
        if (PawnForLocation.HeadBone != '')
        {
            DrawLocation = PawnForLocation.GetBoneCoords(PawnForLocation.HeadBone).Origin;
            DrawLocation.Z += 16.0;
        }
        else
        {
            DrawLocation = PawnForLocation.Location;
        }

        DrawLocation = C.WorldToScreen(DrawLocation);

        // Now draw the player name, with a generic name icon below it
        C.TextSize(PlayerName, TextSize.X, TextSize.Y);
        C.SetPos(DrawLocation.X - 8.0, DrawLocation.Y - (TextSize.Y * 0.5));
        C.DrawTile(PlayerNameIconMaterial, 16.0, 16.0, 0.0, 0.0, PlayerNameIconMaterial.MaterialUSize(), PlayerNameIconMaterial.MaterialVSize());

        C.SetPos(DrawLocation.X - TextSize.X * 0.5, DrawLocation.Y - 32.0);
        DrawShadowedTextClipped(C, PlayerName);

        // Check whether we need to draw an icon above the player's name, if he's talking or needs resupply or assisted reload
        IconMaterial = none;

        if (OtherPRI == PortraitPRI)
        {
            IconMaterial = SpeakerIconMaterial;
        }
        else if (P.IsA('DHMortarVehicleWeaponPawn')) // a mortar is a special case to check for resupply
        {
            Mortar = DHMortarVehicle(VehicleWeaponPawn(P).VehicleBase);

            if (Mortar != none && Mortar.bCanBeResupplied && ROPawn(PlayerOwner.Pawn) != none && !ROPawn(PlayerOwner.Pawn).bUsedCarriedMGAmmo)
            {
                IconMaterial = NeedAmmoIconMaterial;
            }
        }
        else if (DHPawn(P) != none)
        {
            if (DHPawn(P).bWeaponNeedsResupply && ROPawn(PlayerOwner.Pawn) != none && !ROPawn(PlayerOwner.Pawn).bUsedCarriedMGAmmo)
            {
                IconMaterial = NeedAmmoIconMaterial;
            }
            else if (DHPawn(P).bWeaponNeedsReload)
            {
                IconMaterial = NeedAssistIconMaterial;
            }
        }

        // Now draw any relevant icon above the player's name, in white to make it more noticeable (instead of the team color)
        if (IconMaterial != none)
        {
            C.DrawColor = class'UColor'.default.White;
            C.DrawColor.A = Alpha;
            C.SetPos(DrawLocation.X - 12.0, DrawLocation.Y - 56.0);
            C.DrawTile(IconMaterial, 24.0, 24.0, 0.0, 0.0, IconMaterial.MaterialUSize(), IconMaterial.MaterialVSize());
        }
    }

    // Finally record the time this frame was drawn, so in future we can easily tell if a player has just become valid (his LastNameDrawTime would be prior to this time)
    HUDLastNameDrawTime = Now;
}

simulated function DrawShadowedTextClipped(Canvas C, string Text)
{
    local color SavedDrawColor;

    if (C != none)
    {
        SavedDrawColor = C.DrawColor;

        C.DrawColor = class'UColor'.default.Black;
        C.DrawColor.A = SavedDrawColor.A;
        C.CurX += 1;
        C.CurY += 1;

        C.DrawTextClipped(Text);

        C.DrawColor = SavedDrawColor;
        C.CurX -= 1;
        C.CurY -= 1;

        C.DrawTextClipped(Text);
    }
}

// Modified to fix problem where compass failed to follow view rotation of player driving a vehicle
simulated function DrawCompass(Canvas C)
{
    local Actor              A;
    local AbsoluteCoordsInfo GlobalCoors;
    local float              PawnRotation, PlayerRotation, Compensation, XL, YL;
    local int                OverheadOffset;

    // Get player actor
    if (PawnOwner != none)
    {
        A = PawnOwner;
    }
    else if (PlayerOwner != none)
    {
        if (PlayerOwner.IsInState('Spectating'))
        {
            A = PlayerOwner;
        }
        else if (PlayerOwner.Pawn != none)
        {
            A = PlayerOwner.Pawn;
        }
    }

    if (A != none)
    {
        // Figure which direction we're facing
        if (PlayerOwner != none)
        {
            PawnRotation = PlayerOwner.CalcViewRotation.Yaw; // fix is to always use CalcViewRotation (it's always the last calculated camera rotation)
        }
        else
        {
            PawnRotation = A.Rotation.Yaw;
        }

        // Compensate for map rotation
        if (PlayerOwner != none && PlayerOwner.GameReplicationInfo != none)
        {
            OverheadOffset = PlayerOwner.GameReplicationInfo.OverheadOffset;
        }

        Compensation = (float(OverheadOffset) / 90.0 * 16384.0) + 16384.0;
        PlayerRotation = PawnRotation + Compensation;

        // Pre-bind compass rotation to a -32000 to 32000 range relative to PlayerRotation
        while ((CompassCurrentRotation - PlayerRotation) > 32768)
        {
            CompassCurrentRotation -= 65536;
        }

        while ((CompassCurrentRotation - PlayerRotation) < -32768)
        {
            CompassCurrentRotation += 65536;
        }

        // Update compass & needle rotation
        CompassCurrentRotation = CompassCurrentRotation + (CompassStabilizationConstant * (PlayerRotation - CompassCurrentRotation) * (Level.TimeSeconds - HudLastRenderTime));
        TexRotator(CompassNeedle.WidgetTexture).Rotation.Yaw = CompassCurrentRotation;
    }
    else // shouldn't ever happen but better safe than log-spammy
    {
        PlayerRotation = CompassCurrentRotation;
    }

    // Draw compass base (fake, only to get sizes)
    GlobalCoors.width = C.ClipX;
    GlobalCoors.height = C.ClipY;
    DrawSpriteWidgetClipped(C, CompassBase, GlobalCoors, true, XL, YL, true, true, true);

    // Calculate needle screen offset
    CompassNeedle.OffsetX = (GlobalCoors.width * -0.005) + default.CompassNeedle.OffsetX + (CompassBase.OffsetX - XL / HudScale / 2.0);
    CompassNeedle.OffsetY = default.CompassNeedle.OffsetY + CompassBase.OffsetY - (YL / HudScale / 2.0);

    // Draw the compass needle & base
    DrawSpriteWidgetClipped(C, CompassNeedle, GlobalCoors, true, XL, YL, true, true, true);
    DrawSpriteWidgetClipped(C, CompassBase, GlobalCoors, true, XL, YL, true, true, true);

    // Draw icons
    if (CompassIconsOpacity > 0.0 || bShowObjectives)
    {
        DrawCompassIcons(C, CompassNeedle.OffsetX, CompassNeedle.OffsetY, XL / HudScale / 2.0 * CompassIconsPositionRadius, -(A.Rotation.Yaw + 16384), A, GlobalCoors);
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
                    Loc = Loc + (VW.VehHitpoints[i].PointOffset >> rotator(CO.XAxis));
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

// New function to split out lengthy map drawing functionality from the DrawObjectives() function
// As this is now called from the DHGUIMapComponent class as well as DrawObjectives (& also it helps
// shorten a very length DrawObjectives function)
simulated function DrawMap(Canvas C, AbsoluteCoordsInfo SubCoords, DHPlayer Player)
{
    local int                       i, Pos, OwnerTeam, Distance;
    local Controller                P;
    local float                     MyMapScale, ArrowRotation;
    local vector                    Temp, MapCenter;
    local Vehicle                   V;
    local Actor                     NetActor;
    local Pawn                      NetPawn;
    local DHPawn                    DHP;
    local SpriteWidget              Widget;
    local string                    S, DistanceString, ObjLabel;
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
    MapLevelOverlay.WidgetTexture = material'DH_GUI_Tex.GUI.GridOverlay';

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
/*
        // Draw the rally points // removed as rally points not used in 6.0, so no point checking - uncomment if rally functionality added back later
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
*/
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
                if (DHGRI.AxisHelpRequests[i].RequestType == 255)
                {
                    continue;
                }

                switch (DHGRI.AxisHelpRequests[i].RequestType)
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
                        Log("Unknown requestType found in AxisHelpRequests[" $ i $ "]:" @ DHGRI.AxisHelpRequests[i].RequestType);
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
                            ArrowRotation = class'UUnits'.static.RadiansToUnreal(Atan(Temp.X, Temp.Y));
                            ArrowRotation -= class'UUnits'.static.DegreesToUnreal(DHGRI.OverheadOffset);
                            TexRotator(FinalBlend(MapIconMortarArrow.WidgetTexture).Material).Rotation.Yaw = ArrowRotation;

                            DrawIconOnMap(C, SubCoords, MapIconMortarArrow, MyMapScale, DHGRI.GermanMortarTargets[i].Location, MapCenter);
                        }

                        if (RI.bCanUseMortars && PlayerOwner.Pawn != none)
                        {
                            Distance = int(class'DHUnits'.static.UnrealToMeters(VSize(PlayerOwner.Pawn.Location - DHGRI.GermanMortarTargets[i].Location)));
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
                if (DHGRI.AlliedHelpRequests[i].RequestType == 255)
                {
                    continue;
                }

                switch (DHGRI.AlliedHelpRequests[i].RequestType)
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
                        Log("Unknown requestType found in AlliedHelpRequests[" $ i $ "]:" @ DHGRI.AlliedHelpRequests[i].RequestType);
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
                            ArrowRotation = class'UUnits'.static.RadiansToUnreal(Atan(Temp.X, Temp.Y));
                            ArrowRotation -= class'UUnits'.static.DegreesToUnreal(DHGRI.OverheadOffset);
                            TexRotator(FinalBlend(MapIconMortarArrow.WidgetTexture).Material).Rotation.Yaw = ArrowRotation;

                            DrawIconOnMap(C, SubCoords, MapIconMortarArrow, MyMapScale, DHGRI.AlliedMortarTargets[i].Location, MapCenter);
                        }

                        if (RI.bCanUseMortars && PlayerOwner.Pawn != none)
                        {
                            Distance = int(class'DHUnits'.static.UnrealToMeters(VSize(PlayerOwner.Pawn.Location - DHGRI.AlliedMortarTargets[i].Location)));
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

        // Do not show the objective if it is supposed to be hidden on the map
        if (DHGRI.DHObjectives[i].bHideOnMap || (!DHGRI.DHObjectives[i].bActive && DHGRI.DHObjectives[i].bHideOnMapWhenInactive))
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

        if (!DHGRI.DHObjectives[i].bActive && DHGRI.DHObjectives[i].bHideLabelWhenInactive)
        {
            ObjLabel = "";
        }
        else
        {
            ObjLabel = DHGRI.DHObjectives[i].ObjName;
        }

        // Draw flashing icon if objective is disputed
        if (DHGRI.DHObjectives[i].CompressedCapProgress != 0 && DHGRI.DHObjectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
        {
            if (DHGRI.DHObjectives[i].CompressedCapProgress == 1 || DHGRI.DHObjectives[i].CompressedCapProgress == 2)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 2, ObjLabel, DHGRI, i);
            }
            else if (DHGRI.DHObjectives[i].CompressedCapProgress == 3 || DHGRI.DHObjectives[i].CompressedCapProgress == 4)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 3, ObjLabel, DHGRI, i);
            }
            else
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 1, ObjLabel, DHGRI, i);
            }
        }
        else
        {
            DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.DHObjectives[i].Location, MapCenter, 1, ObjLabel, DHGRI, i);
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

    DrawPlayerIconsOnMap(C, SubCoords, MyMapScale, MapCenter);

    // Overhead map debugging
    if (Level.NetMode == NM_Standalone && ROTeamGame(Level.Game).LevelInfo.bDebugOverhead)
    {
        DrawIconOnMap(C, SubCoords, MapIconTeam[ALLIES_TEAM_INDEX], MyMapScale, DHGRI.NorthEastBounds, MapCenter);
        DrawIconOnMap(C, SubCoords, MapIconTeam[AXIS_TEAM_INDEX], MyMapScale, DHGRI.SouthWestBounds, MapCenter);
    }
}

simulated function DrawPlayerIconsOnMap(Canvas C, AbsoluteCoordsInfo SubCoords, float MyMapScale, vector MapCenter)
{
    local Actor A;
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local int PlayerYaw;
    local color SelfColor;

    PC = DHPlayer(PlayerOwner);

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    }

    // Draw the local player on the map
    // Get player actor, for drawing player icon
    if (PawnOwner != none)
    {
        A = PawnOwner;
    }
    else if (PlayerOwner != none)
    {
        if (PlayerOwner.IsInState('Spectating'))
        {
            A = PlayerOwner;
        }
        else if (PlayerOwner.Pawn != none)
        {
            A = PlayerOwner.Pawn;
        }
    }

    if (A != none)
    {
        // Set icon rotation
        if (PlayerOwner != none)
        {
            PlayerYaw = PlayerOwner.CalcViewRotation.Yaw;
        }
        else
        {
            PlayerYaw = A.Rotation.Yaw;
        }

        if (PRI != none)
        {
            SelfColor = class'UColor'.default.OrangeRed;
            SelfColor.A = 160;
            DrawPlayerIconOnMap(C, SubCoords, MyMapScale, A.Location, MapCenter, PlayerYaw, SelfColor, 0.05);
        }
    }
}

simulated function DrawPlayerIconOnMap(Canvas C, AbsoluteCoordsInfo SubCoords, float MyMapScale, vector Location, vector MapCenter, float PlayerYaw, color Color, float TextureScale)
{
    MapPlayerIcon.TextureScale = TextureScale;

    TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = GetMapIconYaw(PlayerYaw);

    MapPlayerIcon.Tints[0] = Color;
    MapPlayerIcon.Tints[0].A = 192;

    // Draw the player icon
    DrawIconOnMap(C, SubCoords, MapPlayerIcon, MyMapScale, Location, MapCenter);
}

simulated function float GetMapIconYaw(float WorldYaw)
{
    local float MapIconYaw;

    MapIconYaw = -WorldYaw;

    if (DHGRI != none)
    {
        switch (DHGRI.OverheadOffset)
        {
            case 90:
                MapIconYaw -= 32768;
                break;

            case 180:
                MapIconYaw -= 49152;
                break;

            case 270:
                break;

            default:
                MapIconYaw -= 16384;
        }
    }

    return MapIconYaw;
}

// Renders the objectives on the HUD similar to the scoreboard
simulated function DrawObjectives(Canvas C)
{
    local DHPlayerReplicationInfo PRI;
    local AbsoluteCoordsInfo      MapCoords, SubCoords;
    local SpriteWidget  Widget;
    local DHPlayer      Player;
    local int           i, j, OwnerTeam, ObjCount, SecondaryObjCount;
//  local bool          bShowRally; // removed as rally points not used in 6.0, so no point checking - uncomment if rally functionality added back later
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
        MapCoordTextXWidget.PosX = (float(i) + 0.5) / 9.0;
        MapCoordTextXWidget.Text = MapCoordTextX[i];
        DrawTextWidgetClipped(C, MapCoordTextXWidget, SubCoords);

        MapCoordTextYWidget.PosY = MapCoordTextXWidget.PosX;
        MapCoordTextYWidget.Text = MapCoordTextY[i];
        DrawTextWidgetClipped(C, MapCoordTextYWidget, SubCoords);
    }

    // Draw the overhead map
    DrawMap(C, SubCoords, Player);

    // Draw the timer legend
    DrawTextWidgetClipped(C, MapTimerTitle, MapCoords, XL, YL, YL_one);

    // Calculate seconds & minutes
    Time = CurrentTime;
    MapTimerTexts[3].Text = string(int(Time % 10.0));
    Time /= 10.0;
    MapTimerTexts[2].Text = string(int(Time % 6.0));
    Time /= 6.0;
    MapTimerTexts[1].Text = string(int(Time % 10.0));
    Time /= 10.0;
    MapTimerTexts[0].Text = string(int(Time));

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
/*
    // Rally Points // removed as rally points not used in 6.0, so no point checking - uncomment if rally functionality added back later
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
*/
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

    // Requests
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

                case 3: // MG resupply requests
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

                case 3: // MG resupply requests
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
            if (DHGRI.DHObjectives[i] == none || !DHGRI.DHObjectives[i].bActive || DHGRI.DHObjectives[i].bRequired)
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
                switch(DHGRI.AlliedNationID)
                {
                    case 3: // USSR
                        Widget.WidgetTexture = class'ROHud'.default.LocationHitAlliesImages[i];
                        break;
                    default:
                        Widget.WidgetTexture = LocationHitAlliesImages[i];
                        break;
                }
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
    local bool bIsRussian;

    if (PawnOwnerPRI != none)
    {
        bIsRussian = PawnOwnerPRI.Team != none && PawnOwnerPRI.Team.TeamIndex == ALLIES_TEAM_INDEX && DHGRI != none && DHGRI.AlliedNationID == 3;

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

            if (bIsRussian)
            {
                HealthFigure.WidgetTexture = class'ROHud'.default.NationHealthFigures[Nation];
            }
            else
            {
                HealthFigure.WidgetTexture = NationHealthFigures[Nation];
            }

            if (bIsRussian)
            {
                HealthFigureBackground.WidgetTexture = class'ROHud'.default.NationHealthFiguresBackground[Nation];
            }
            else
            {
                HealthFigureBackground.WidgetTexture = NationHealthFiguresBackground[Nation];
            }

            if (HealthFigureStamina.Scale > 0.9)
            {
                if (bIsRussian)
                {
                    HealthFigureStamina.WidgetTexture = class'ROHud'.default.NationHealthFiguresStaminaCritical[Nation];
                }
                else
                {
                    HealthFigureStamina.WidgetTexture = NationHealthFiguresStaminaCritical[Nation];
                }

                HealthFigureStamina.Tints[0].G = 255; HealthFigureStamina.Tints[1].G = 255;
                HealthFigureStamina.Tints[0].B = 255; HealthFigureStamina.Tints[1].B = 255;
            }
            else
            {
                if (bIsRussian)
                {
                    HealthFigureStamina.WidgetTexture = class'ROHud'.default.NationHealthFiguresStamina[Nation];
                }
                else
                {
                    HealthFigureStamina.WidgetTexture = NationHealthFiguresStamina[Nation];
                }
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
            AttackersRatio = float(CurrentCapAxisCappers) / (CurrentCapAxisCappers + CurrentCapAlliesCappers);
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
            AttackersRatio = float(CurrentCapAlliesCappers) / (CurrentCapAxisCappers + CurrentCapAlliesCappers);
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
        if (PawnOwner.IsA('DHVehicle'))
        {
            DHVehicle(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DHVehicleWeaponPawn'))
        {
            DHVehicleWeaponPawn(PawnOwner).GrowHUD();
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
        if (PawnOwner.IsA('DHVehicle'))
        {
            DHVehicle(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DHVehicleWeaponPawn'))
        {
            DHVehicleWeaponPawn(PawnOwner).ShrinkHUD();
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
    local bool bShouldFlashText;

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
            s = default.TimeRemainingText $ class'TimeSpan'.static.ToString(Max(0, CurrentTime));
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
            s = default.JoinTeamText; // Press ESC to join a team
        }
        else if (DHGRI.bReinforcementsComing[PRI.Team.TeamIndex] == 1)
        {
            if (DHGRI.SpawnsRemaining[PRI.Team.TeamIndex] > 0 || DHGRI.SpawnsRemaining[PRI.Team.TeamIndex] == -1)
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
                                bShouldFlashText = true;
                            }
                            else
                            {
                                // You will deploy as a {0} in {2} | Press ESC to change
                                s = default.SpawnInfantryText;
                            }
                        }
                        else if (PC.SpawnVehicleIndex != 255)
                        {
                            SVC = DHGRI.VehiclePoolVehicleClasses[DHGRI.SpawnVehicles[PC.SpawnVehicleIndex].VehiclePoolIndex];

                            if (SVC != none)
                            {
                                // You will deploy as a {0} at a {1} in {2} | Press ESC to change
                                s = Repl(default.SpawnAtVehicleText, "{1}", SVC.default.VehicleNameString);
                            }
                            else
                            {
                                // Press ESC to select a spawn point
                                s = default.SelectSpawnPointText;
                                bShouldFlashText= true;
                            }
                        }
                        else
                        {
                            // Press ESC to select a spawn point
                            s = default.SelectSpawnPointText;
                            bShouldFlashText = true;
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

                s = Repl(s, "{2}", class'TimeSpan'.static.ToString(Max(0, Time)));
            }
            else
            {
                s = default.ReinforcementsDepletedText;
            }
        }

        Y += 4.0 * Scale + strY;

        // Flash the "Press ESC to select a spawn point" message to make it more noticeable.
        if (bShouldFlashText)
        {
            C.DrawColor = class'UColor'.static.Interp(class'UInterp'.static.Cosine(Level.TimeSeconds, 0.0, 1.0), WhiteColor, RedColor);
        }

        C.SetPos(X, Y);
        C.DrawTextClipped(s);

        // Draw death penalty count if > 0
        if (PC.DeathPenaltyCount > 0)
        {
            Y += 4.0 * Scale + strY;

            s = DeathPenaltyText;
            s = Repl(s, "{0}", PC.DeathPenaltyCount);
            s = Repl(s, "{1}", string((PC.DeathPenaltyCount - 1) * PC.DEATH_PENALTY_FACTOR));

            C.DrawColor = WhiteColor;
            C.SetPos(X, Y);
            C.DrawTextClipped(s);
        }
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
            C.StrLen("W", XL, SmallH);
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

// Modified to fix an accessed none error in ROHud.
simulated function LocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString)
{
    local int i, Count;
    local PlayerReplicationInfo PRI;

    if (Message == none || (bIsCinematic && !ClassIsChildOf(Message,class'ActionMessage')))
    {
        return;
    }

    if (CriticalString == "")
    {
        if (PawnOwner != none && PawnOwner.PlayerReplicationInfo != none)
        {
            PRI = PawnOwner.PlayerReplicationInfo;
        }
        else
        {
            PRI = PlayerOwner.PlayerReplicationInfo;
        }

        if (PRI == RelatedPRI_1)
        {
            CriticalString = Message.static.GetRelatedString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
        else
        {
            CriticalString = Message.static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
    }

    if (bMessageBeep && Message.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }

    if (!Message.default.bIsSpecial)
    {
        if (PlayerOwner.bDemoOwner)
        {
            for (i = 0; i < ConsoleMessageCount; ++i)
            {
                if (i >= arraycount(TextMessages) || TextMessages[i].Text == "")
                {
                    break;
                }
            }

            if (i > 0 && TextMessages[i - 1].Text == CriticalString)
            {
                return;
            }
        }

        AddTextMessage(CriticalString, Message,RelatedPRI_1);

        return;
    }

    if (class'Object'.static.ClassIsChildOf(Message, class'ROCriticalMessage') &&
        class'ROCriticalMessage'.default.MaxMessagesOnScreen > 0)
    {
        // Check if we have too many critical messages in stack
        Count = 0;

        for (i = 0; i < arraycount(LocalMessages); ++i)
        {
            if (class'Object'.static.ClassIsChildOf(LocalMessages[i].Message, class'ROCriticalMessage'))
            {
                Count++;
            }
        }

        if (Count >= class'ROCriticalMessage'.default.MaxMessagesOnScreen)
        {
            // We have too many critical messages -- delete oldest one
            for (i = 0; i < arraycount(LocalMessages); ++i)
            {
                if (class'Object'.static.ClassIsChildOf(LocalMessages[i].Message, class'ROCriticalMessage'))
                {
                    break;
                }
            }

            for (i = i; i < arraycount(LocalMessages) - 1; ++i)
            {
                LocalMessages[i] = LocalMessages[i + 1];
                LocalMessagesExtra[i] = LocalMessagesExtra[i + 1];
            }

            // BUGFIX: The previous implementation was indexing the array
            // as LocalMessages[i + 1], which, aside from being wrong,
            // could overrun the bounds of the array.
            ClearMessage(LocalMessages[i]);
        }
    }

    i = arraycount(LocalMessages);

    if (Message.default.bIsUnique)
    {
        for (i = 0; i < arraycount(LocalMessages); ++i)
        {
            if(LocalMessages[i].Message != none && LocalMessages[i].Message == Message)
            {
                break;
            }
        }
    }
    else if (Message.default.bIsPartiallyUnique || PlayerOwner.bDemoOwner)
    {
        for (i = 0; i < arraycount(LocalMessages); ++i)
        {
            if (LocalMessages[i].Message == none)
            {
                continue;
            }

            if (LocalMessages[i].Message == Message && LocalMessages[i].Switch == Switch)
            {
                break;
            }
        }
    }

    if (i == arraycount(LocalMessages))
    {
        // Find index of first empty message
        for (i = 0; i < arraycount(LocalMessages); ++i)
        {
            if (LocalMessages[i].Message == none)
            {
                break;
            }
        }
    }

    if (i == arraycount(LocalMessages))
    {
        // No empty messages, so move all messages to the "left" except the last one
        for (i = 0; i < arraycount(LocalMessages) - 1; ++i)
        {
            LocalMessages[i] = LocalMessages[i + 1];
            LocalMessagesExtra[i] = LocalMessagesExtra[i + 1];
        }
    }

    ClearMessage(LocalMessages[i]);

    LocalMessages[i].Message = Message;
    LocalMessages[i].Switch = Switch;
    LocalMessages[i].RelatedPRI = RelatedPRI_1;
    LocalMessages[i].RelatedPRI2 = RelatedPRI_2;
    LocalMessages[i].OptionalObject = OptionalObject;

    // Hackish for ROCriticalMessages
    if (class'Object'.static.ClassIsChildOf(Message, class'ROCriticalMessage') &&
        class<ROCriticalMessage>(Message).default.bQuickFade)
    {
         LocalMessages[i].LifeTime = Message.static.GetLifetime(Switch) + class<ROCriticalMessage>(Message).default.QuickFadeTime;
         LocalMessages[i].EndOfLife = LocalMessages[i].LifeTime + Level.TimeSeconds;

         // Mild hax: used to show hints when an obj is captured
         // This was simpliest way of doing it without having server call another
         // server-to-client function
         if (class'Object'.static.ClassIsChildOf(Message, class'ROObjectiveMsg') &&
            (Switch == 0 || Switch == 1) &&
            ROPlayer(PlayerOwner) != none)
         {
            ROPlayer(PlayerOwner).CheckForHint(17);
         }
    }
    else
    {
         LocalMessages[i].EndOfLife = Message.static.GetLifetime(Switch) + Level.TimeSeconds;
         LocalMessages[i].LifeTime = Message.static.GetLifetime(Switch);
    }

    LocalMessages[i].StringMessage = CriticalString;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to use DHDebugMode
exec function ShowDebug()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bShowDebugInfo = !bShowDebugInfo;
    }
}

// A debug exec transferred from ROHud class & modified to include hiding the sky, which is necessary to allow the crucial debug spheres to get drawn
simulated function PlayerCollisionDebug()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bDebugPlayerCollision = !bDebugPlayerCollision;
        SetSkyOff(bDebugPlayerCollision);
    }
}

// A debug exec transferred from ROHud class & modified to include hiding the sky, which is necessary to allow the crucial debug spheres to get drawn
// Note this is effectively redundant now as from DH 6.0 the system of using coded hit points for vehicle occupants has been abandoned
simulated function DriverCollisionDebug()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bDebugDriverCollision = !bDebugDriverCollision;
        SetSkyOff(bDebugDriverCollision);
    }
}

// New debug exec showing all vehicles' special hit points for engine (blue), ammo stores (red), & DHArmoredVehicle's extra hit points (gold for gun traverse/pivot, pink for periscopes)
exec function VehicleHitPointDebug()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bDebugVehicleHitPoints = !bDebugVehicleHitPoints;
        SetSkyOff(bDebugVehicleHitPoints);
    }
}

// New debug exec showing all vehicle's physics wheels (the Wheels array of invisible wheels that drive & steer vehicle, even ones with treads)
exec function VehicleWheelDebug()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bDebugVehicleWheels = !bDebugVehicleWheels;
        SetSkyOff(bDebugVehicleWheels);
    }
}

// New debug exec to toggle camera debug (location & rotation) for any vehicle position
exec function CameraDebug()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bDebugCamera = !bDebugCamera;
        SetSkyOff(bDebugCamera);
    }
}

// New function to hide or restore the sky, used by debug functions that use DrawDebugX native functions, that won't draw unless the sky is off
// Console command "show sky" toggles the sky on/off, but it only works in single player, so this allows these debug options to work in multiplayer
simulated function SetSkyOff(bool bHideSky)
{
    if (PlayerOwner != none && PlayerOwner.PlayerReplicationInfo != none && PlayerOwner.PlayerReplicationInfo.PlayerZone != none)
    {
        // Hide the sky
        if (bHideSky)
        {
            if (PlayerOwner.PlayerReplicationInfo.PlayerZone.SkyZone != none)
            {
                SavedSkyZone = PlayerOwner.PlayerReplicationInfo.PlayerZone.SkyZone;
                PlayerOwner.PlayerReplicationInfo.PlayerZone.SkyZone = none;
            }
        }
        // Restore the sky, but only if we have no other similar debug functionality enabled
        else if (PlayerOwner.PlayerReplicationInfo.PlayerZone.SkyZone == none && SavedSkyZone != none
            && !bDebugDriverCollision && !bDebugPlayerCollision && !bDebugVehicleHitPoints && !bDebugVehicleWheels && !bDebugCamera)
        {
            PlayerOwner.PlayerReplicationInfo.PlayerZone.SkyZone = SavedSkyZone;
        }
    }
}

defaultproperties
{
    // General
    MouseInterfaceIcon=(WidgetTexture=texture'DH_GUI_Tex.Menu.DHPointer')
    PlayerNameFontSize=1
    OverrideConsoleFontName="DHFonts.DHFont14"
    SpacingText="        "

    // Death messages
    bShowDeathMessages=true
    ObituaryLifeSpan=8.5
    ObituaryFadeInTime=0.5
    ObituaryDelayTime=5.0

    // Map text
    MapNameText="Map: "
    MapGameTypeText="Gametype: "
    AndMoreText="and more..."
    LegendAxisObjectiveText="Axis territory"
    LegendAlliesObjectiveText="Allied territory"
    LegendArtilleryRadioText="Artillery Radio"
    LegendCarriedArtilleryRadioText="Artillery Radioman"

    // Screen/message text
    TimeElapsedText="Time Elapsed: "
    NoTimeLimitText="Unlimited"
    NeedReloadText="Needs reloading"
    CanReloadText="Press %THROWMGAMMO% to assist reload"
    TeamMessagePrefix="*TEAM* "

    // Deploying text
    JoinTeamText="Press [ESC] to join a team"
    SelectSpawnPointText="Press [ESC] to select a spawn point"
    ReinforcementText="You will deploy as a {0} in {2} | Press [ESC] to change"
    SpawnInfantryText="You will deploy as a {0} in {2} | Press [ESC] to change"
    SpawnVehicleText="You will deploy as a {0} driving a {3} in {2} | Press [ESC] to change"
    SpawnAtVehicleText="You will deploy as a {0} at a {1} in {2} | Press [ESC] to change"
    SpawnNoRoleText="You will deploy in {2} | Press [ESC] to change"
    ReinforcementsDepletedText="Reinforcements depleted!"
    DeathPenaltyText="Death Penalty Count: {0} (+{1} second respawn time)"

    // Screen indicator icons
    PlayerNameIconMaterial=material'DH_InterfaceArt_tex.HUD.player_icon_world';
    SpeakerIconMaterial=texture'DH_InterfaceArt_tex.Communication.speaker_icon'
    NeedAssistIconMaterial=texture'DH_InterfaceArt_tex.Communication.need_assist_icon'
    NeedAmmoIconMaterial=texture'DH_InterfaceArt_tex.Communication.need_ammo_icon'
    CanMantleIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.CanMantle',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=127),TextureScale=0.8,DrawPivot=DP_LowerMiddle,PosX=0.55,PosY=0.98,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    CanCutWireIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.CanCut',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=127),TextureScale=0.8,DrawPivot=DP_LowerMiddle,PosX=0.55,PosY=0.98,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    DeployOkayIcon=(WidgetTexture=material'DH_GUI_tex.GUI.deploy_status',TextureCoords=(X1=0,Y1=0,X2=63,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-200,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255))
    DeployEnemiesNearbyIcon=(WidgetTexture=material'DH_GUI_tex.GUI.deploy_status_finalblend',TextureCoords=(X1=64,Y1=0,X2=127,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-200,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255))
    DeployInObjectiveIcon=(WidgetTexture=material'DH_GUI_tex.GUI.deploy_status_finalblend',TextureCoords=(X1=0,Y1=64,X2=63,Y2=127),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-200,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255))

    // Screen weapon & ammo resupply icons
    WeaponCanRestIcon=(WidgetTexture=texture'DH_InterfaceArt_tex.HUD.DeployIcon',TextureCoords=(X1=0,Y1=0,X2=63,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-144,ScaleMode=SM_Left,scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=100,G=100,B=100,A=255),Tints[1]=(R=100,G=100,B=100,A=255))
    WeaponRestingIcon=(WidgetTexture=texture'DH_InterfaceArt_tex.HUD.DeployIcon',TextureCoords=(X1=0,Y1=0,X2=63,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-144,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MGDeployIcon=(WidgetTexture=texture'DH_InterfaceArt_tex.HUD.DeployIcon',TextureCoords=(X1=0,Y1=0,X2=63,Y2=63),TextureScale=0.45,DrawPivot=DP_LowerRight,PosX=1.0,PosY=1.0,OffsetX=-8,OffsetY=-144,ScaleMode=SM_Left,scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    ResupplyZoneNormalPlayerIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    ResupplyZoneNormalVehicleIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    //  ResupplyZoneResupplyingPlayerIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash')
    //  ResupplyZoneResupplyingVehicleIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash')

    // Capture bar icons
    CaptureBarIcons[0]=(TextureScale=0.50,DrawPivot=DP_MiddleMiddle,PosX=0.5,PosY=0.98,OffsetX=-100,OffsetY=-32,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    CaptureBarIcons[1]=(TextureScale=0.50,DrawPivot=DP_MiddleMiddle,PosX=0.5,PosY=0.98,OffsetX=100,OffsetY=-32,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    CaptureBarTeamIcons(0)=texture'DH_GUI_Tex.GUI.GerCross'
    CaptureBarTeamIcons(1)=texture'DH_GUI_Tex.GUI.AlliedStar'
    CaptureBarTeamColors(0)=(R=221,G=0,B=0)
    CaptureBarTeamColors(1)=(R=49,G=57,B=223)

    // Player figure/health icon
    NationHealthFigures(1)=texture'DH_GUI_Tex.GUI.US_player'
    NationHealthFiguresBackground(1)=texture'DH_GUI_Tex.GUI.US_player_background'
    NationHealthFiguresStamina(1)=texture'DH_GUI_Tex.GUI.US_player_Stamina'
    NationHealthFiguresStaminaCritical(1)=FinalBlend'DH_GUI_Tex.GUI.US_player_Stamina_critical'
    LocationHitAlliesImages(0)=texture'DH_GUI_Tex.Player_hits.US_hit_Head'
    LocationHitAlliesImages(1)=texture'DH_GUI_Tex.Player_hits.US_hit_torso'
    LocationHitAlliesImages(2)=texture'DH_GUI_Tex.Player_hits.US_hit_pelvis'
    LocationHitAlliesImages(3)=texture'DH_GUI_Tex.Player_hits.US_hit_LupperLeg'
    LocationHitAlliesImages(4)=texture'DH_GUI_Tex.Player_hits.US_hit_RupperLeg'
    LocationHitAlliesImages(5)=texture'DH_GUI_Tex.Player_hits.US_hit_LupperArm'
    LocationHitAlliesImages(6)=texture'DH_GUI_Tex.Player_hits.US_hit_RupperArm'
    LocationHitAlliesImages(7)=texture'DH_GUI_Tex.Player_hits.US_hit_LlowerLeg'
    LocationHitAlliesImages(8)=texture'DH_GUI_Tex.Player_hits.US_hit_RlowerLeg'
    LocationHitAlliesImages(9)=texture'DH_GUI_Tex.Player_hits.US_hit_LlowerArm'
    LocationHitAlliesImages(10)=texture'DH_GUI_Tex.Player_hits.US_hit_RlowerArm'
    LocationHitAlliesImages(11)=texture'DH_GUI_Tex.Player_hits.US_hit_LHand'
    LocationHitAlliesImages(12)=texture'DH_GUI_Tex.Player_hits.US_hit_RHand'
    LocationHitAlliesImages(13)=texture'DH_GUI_Tex.Player_hits.US_hit_Lfoot'
    LocationHitAlliesImages(14)=texture'DH_GUI_Tex.Player_hits.US_hit_Rfoot'

    // Extra ammo indicator icon
    ExtraAmmoIcon=(WidgetTexture=texture'DH_InterfaceArt_tex.Communication.need_ammo_icon',TextureCoords=(X1=0,Y1=0,X2=31,Y2=31),TextureScale=0.33,DrawPivot=DP_LowerRight,PosX=0.0,PosY=1.0,OffsetX=130,OffsetY=-35,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))

    // Map general icons
    MapBackground=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_background')
    MapLevelOverlay=(RenderStyle=STY_Alpha,TextureCoords=(X2=511,Y2=511),TextureScale=1.0,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=125),Tints[1]=(B=255,G=255,R=255,A=255))
    MapScaleText=(RenderStyle=STY_Alpha,DrawPivot=DP_LowerRight,PosX=1.0,PosY=0.0375,WrapHeight=1.0,Tints[0]=(B=255,G=255,R=255,A=128),Tints[1]=(B=255,G=255,R=255,A=128))
    MapPlayerIcon=(WidgetTexture=FinalBlend'DH_InterfaceArt_tex.HUD.player_icon_map_final',TextureCoords=(X1=0,Y1=0,X2=31,Y2=31))
    PlayerArrowTexture=FinalBlend'DH_GUI_Tex.GUI.PlayerIcon_final'

    // Map icons for team requests & markers
    MapIconMGResupplyRequest(0)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconMGResupplyRequest(1)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconCarriedRadio=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X1=64,Y1=192,X2=127,Y2=255),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    MapIconRally(0)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconRally(1)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconMortarHETarget=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X1=127,Y1=0,X2=192,Y2=64),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapIconMortarSmokeTarget=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X1=191,Y1=0,X2=255,Y2=64),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapIconMortarArrow=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.mortar-arrow-final',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.1,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapIconMortarHit=(WidgetTexture=texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(Y1=64,X2=63,Y2=127),TextureScale=0.05,DrawPivot=DP_LowerMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))

    // Map flag icons
    MapIconNeutral=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=0,X2=31,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAxisFlagIcon=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=32,X2=31,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAlliesFlagIcons(0)=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=96,Y1=0,X2=127,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAlliesFlagIcons(1)=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=64,Y1=0,X2=95,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAlliesFlagIcons(2)=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=32,Y1=0,X2=63,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapAlliesFlagIcons(3)=(WidgetTexture=texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=32,Y1=32,X2=63,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    MapIconsFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_flags_flashing'
    MapIconsFastFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_flags_fast_flash'
    MapIconsAltFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_flags_alt_flashing'
    MapIconsAltFastFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_flags_alt_fast_flash'
    MapIconTeam(0)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    MapIconTeam(1)=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')

    // Map player number icons
    MapPlayerNumberIcon=(TextureCoords=(X1=0,Y1=0,X2=31,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,PosX=0,PosY=0,OffsetX=0,OffsetY=0,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=0,G=0,B=0,A=255),Tints[1]=(R=0,G=0,B=0,A=255))
    PlayerNumberIconTextures(0)=texture'DH_InterfaceArt_tex.HUD.player_number_1'
    PlayerNumberIconTextures(1)=texture'DH_InterfaceArt_tex.HUD.player_number_2'
    PlayerNumberIconTextures(2)=texture'DH_InterfaceArt_tex.HUD.player_number_3'
    PlayerNumberIconTextures(3)=texture'DH_InterfaceArt_tex.HUD.player_number_4'
    PlayerNumberIconTextures(4)=texture'DH_InterfaceArt_tex.HUD.player_number_5'
    PlayerNumberIconTextures(5)=texture'DH_InterfaceArt_tex.HUD.player_number_6'
    PlayerNumberIconTextures(6)=texture'DH_InterfaceArt_tex.HUD.player_number_7'
    PlayerNumberIconTextures(7)=texture'DH_InterfaceArt_tex.HUD.player_number_8'
    PlayerNumberIconTextures(8)=texture'DH_InterfaceArt_tex.HUD.player_number_9'
    PlayerNumberIconTextures(9)=texture'DH_InterfaceArt_tex.HUD.player_number_10'
    PlayerNumberIconTextures(10)=texture'DH_InterfaceArt_tex.HUD.player_number_11'
    PlayerNumberIconTextures(11)=texture'DH_InterfaceArt_tex.HUD.player_number_12'
    SquadNameIcon=(WidgetTexture=FinalBlend'DH_InterfaceArt_tex.HUD.SquadNameIcon',TextureCoords=(X1=0,Y1=0,X2=31,Y2=31),TextureScale=0.45,DrawPivot=DP_LowerMiddle,ScaleMode=SM_Up,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255))

    // Vehicle HUD
    VehicleOccupantsText=(PosX=0.78,OffsetX=0)
    VehicleAmmoTypeText=(Text="",PosX=0.24,PosY=1.0,WrapWidth=0.0,WrapHeight=1,OffsetX=8,OffsetY=-4,DrawPivot=DP_LowerLeft,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255),bDrawShadow=false)
    VehicleAltAmmoIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.2,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    VehicleAltAmmoAmount=(TextureScale=0.2,MinDigitCount=1,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=135,OffsetY=-40,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    VehicleAltAmmoReloadIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.2,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Up,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=0,B=0,A=128),Tints[1]=(R=255,G=0,B=0,A=128))
    VehicleMGAmmoReloadIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.3,DrawPivot=DP_LowerLeft,PosX=0.15,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Up,Scale=0.75,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=0,B=0,A=128),Tints[1]=(R=255,G=0,B=0,A=128))
}
