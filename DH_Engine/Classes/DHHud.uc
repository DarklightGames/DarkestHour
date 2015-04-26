//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHHud extends ROHud;

#exec OBJ LOAD FILE=..\Textures\DH_GUI_Tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_Weapon_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx

var(ROHud) SpriteWidget VehicleAltAmmoReloadIcon; // ammo reload icon for a coax MG, so reload progress can be shown on HUD like a tank cannon reload
var(ROHud) SpriteWidget VehicleMGAmmoReloadIcon;  // ammo reload icon for a vehicle mounted MG position
var(DHHud) SpriteWidget MapIconCarriedRadio;
var(DHHud) SpriteWidget CanMantleIcon;
var(DHHud) SpriteWidget CanCutWireIcon;
var(DHHud) SpriteWidget VoiceIcon;
var(DHHud) SpriteWidget MapIconMortarTarget;
var(DHHud) SpriteWidget MapIconMortarHit;
var(DHHud) SpriteWidget MapLevelOverlay;
var(DHHud) TextWidget   MapScaleText;

var  localized string   LegendCarriedArtilleryRadioText;

var  localized string   NeedReloadText;
var  localized string   CanReloadText;
var  localized string   RedeployText[6];    //TODO: arrays are unwieldly

var  globalconfig int   PlayerNameFontSize; // the size of the name you see when you mouseover a player
var  globalconfig bool  bSimpleColours;     // for colourblind setting, i.e. red and blue only
var  globalconfig bool  bShowDeathMessages; // whether or not to show the death messages
var  globalconfig bool  bShowVoiceIcon;     // whether or not to show the voice icon above player's heads

var  int                AlliedNationID;     // US = 0, Britain = 1, Canada = 2

var  bool               bSetColour;         // whether we've set the Allied colour yet

// For some added suspense:
var  float              ObituaryFadeInTime;
var  float              ObituaryDelayTime;

var  array<Obituary>    DHObituaries;

var  const float        VOICE_ICON_DIST_MAX;

var  bool               bDebugVehicleHitPoints; // show vehicle's special hit points (VehHitpoints & NewVehHitpoints), but not the driver's hit points

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

    Level.AddPrecacheMaterial(texture'InterfaceArt_tex.HUD.MGDeploy');
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

// This is potentially called from 5 different functions, as GameReplicationInfo isn't replicating until after PostNetBeginPlay
simulated function SetAlliedColour()
{
    local DHGameReplicationInfo DHGRI;

    DHGRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (DHGRI != none)
    {
        if (bSimpleColours || DHGRI.AlliedNationID == 1)
        {
            CaptureBarTeamColors[1].R = 64;
            CaptureBarTeamColors[1].G = 80;
            CaptureBarTeamColors[1].B = 230;
            SideColors[1].R = 64;
            SideColors[1].G = 140;
            SideColors[1].B = 190;
            AlliedNationID = 1;
        }
        else if (DHGRI.AlliedNationID == 2)
        {
            CaptureBarTeamColors[1].R = 210;
            CaptureBarTeamColors[1].G = 190;
            CaptureBarTeamColors[1].B = 0;
            SideColors[1].R = 160;
            SideColors[1].G = 155;
            SideColors[1].B = 20;
            AlliedNationID = 2;
        }
        else
        {
            CaptureBarTeamColors[1] = default.CaptureBarTeamColors[1];
            SideColors[1] = default.SideColors[1];
            AlliedNationID = default.AlliedNationID;
        }

        if (bSimpleColours) // black!
        {
           CaptureBarTeamColors[0].R = 0;
           CaptureBarTeamColors[0].G = 0;
           CaptureBarTeamColors[0].B = 0;
        }

        Scoreboard.bActorShadows = bSimpleColours; // filthy hack to cheat our way around messed up class hierarchy
        bSetColour = true;
    }
}

function DrawCustomBeacon(Canvas C, Pawn P, float ScreenLocX, float ScreenLocY)
{
    local PlayerReplicationInfo PRI;
    local float PlayerDist, XL, YL;

    Log("Are we even getting here?");

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

    PlayerDist = VSize(P.Location - PlayerOwner.Pawn.Location);

    if (PlayerDist > 1600.0)
    {
        return;
    }

    if (!FastTrace(P.Location, PlayerOwner.Pawn.Location))
    {
        Log("FastTrace from" @ P.Tag @ "to" @ PlayerOwner.Pawn.Tag @ "Failed");

        return;
    }

    if (PRI.Team != none)
    {
        C.DrawColor = GetTeamColour(PRI.Team.TeamIndex);
    }
    else
    {
        C.DrawColor = GetTeamColour(0);
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
            Msg = PRI.PlayerName $ ":" @ Msg;
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

    AddDHTextMessage(Msg,DHMessageClassType,PRI);
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

    if (!bSetColour)
    {
        SetAlliedColour();
    }

    TextMessages[i].Text = M;
    TextMessages[i].MessageLife = Level.TimeSeconds + MessageClass.default.LifeTime;
    TextMessages[i].TextColor = MessageClass.static.GetDHConsoleColor(PRI, AlliedNationID, bSimpleColours);
    TextMessages[i].PRI = PRI;
}

// Adds a death message to the HUD
function AddDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> DamageType)
{
    local Obituary O;

    if (Victim == none)
    {
        return;
    }

    if (!bSetColour)
    {
        SetAlliedColour();
    }

    if (Killer != none && Killer != Victim)
    {
        O.KillerName = Killer.PlayerName;
        O.KillerColor = GetTeamColour(Killer.Team.TeamIndex);
    }

    O.VictimName = Victim.PlayerName;
    O.VictimColor = GetTeamColour(Victim.Team.TeamIndex);
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

    DHObituaries[DHObituaries.Length] = O;
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

        // Matt: replaced by line below to use max width specified in ROCriticalMessage subclass
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
            Message.DX = TempXL; // Matt: added to fix problem, so Message.DX is always set, even for the 1st pass

            for (i = 0; i < 20; ++i)
            {
                TempXL *= 0.8;
                Lines.Length = 0;
                C.WrapStringToArray(Message.StringMessage, Lines, TempXL);

                if (Lines.Length > InitialNumLines)
                {
                    // If we're getting more than InitialNumLines Lines, it means we should use the previously calculated width
                    Lines.Length = 0;
                    C.WrapStringToArray(Message.StringMessage, Lines, Message.DX); // Matt: was sometimes going wrong here, as Message.DX hadn't been set before the 1st pass

                    // Save strings to message array + calculate resulting XL/YL
                    MessageExtra.Lines.Length = Lines.Length;
                    C.Font = Message.StringFont;
                    XL = 0;
                    YL = 0;

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

function color GetTeamColour(byte Team)
{
    if (!bSetColour)
    {
        SetAlliedColour();
    }

    return SideColors[Team];
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

simulated event PostRender(canvas Canvas)
{
    if (!bSetColour)
    {
        SetAlliedColour();
    }

    super.PostRender(Canvas);
}

// DrawHudPassC - Draw all the widgets here
// Modified to add mantling icon - PsYcH0_Ch!cKeN
simulated function DrawHudPassC(Canvas C)
{
    local VoiceChatRoom         VCR;
    local ROPawn                ROP;
    local DHGameReplicationInfo GRI;
    local float                 Y, XL, YL, Alpha;
    local string                s;
    local color                 MyColor;
    local AbsoluteCoordsInfo    Coords;
    local ROWeapon              MyWeapon;

    // Set coordinates to use whole screen
    Coords.Width = C.ClipX; Coords.Height = C.ClipY;

    if (PawnOwner != none)
    {
        ROP = ROPawn(PawnOwner);
        GRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);
    }
    else
    {
        return;
    }

    // Don't draw the healthfigure when in a vehicle
    if (bShowPersonalInfo && ROP != none)
    {
        DrawSpriteWidget(C, HealthFigureBackground);
        DrawSpriteWidget(C, HealthFigureStamina);
        DrawSpriteWidget(C, HealthFigure);
        DrawSpriteWidget(C, StanceIcon);
        DrawLocationHits(C, ROP);
    }

    // Show MG deploy icon if the weapon can be deployed
    if (PawnOwner != none && PawnOwner.bCanBipodDeploy)
    {
        DrawSpriteWidget(C, MGDeployIcon);
    }

    if (PawnOwner != none && DHPawn(PawnOwner) != none)
    {
        if (DHPawn(PawnOwner).bCanMantle)
        {
            // Show Mantling icon if an object can be climbed
            DrawSpriteWidget(C, CanMantleIcon);
        }
        else if (DHPawn(PawnOwner).bCanCutWire)
        {
            DrawSpriteWidget(C, CanCutWireIcon);
        }
    }

    // Draw the icon for weapon resting
    if (PawnOwner != none)
    {
        if (PawnOwner.bRestingWeapon)
        {
            DrawSpriteWidget(C, WeaponRestingIcon);
        }
        else if (PawnOwner.bCanRestWeapon)
        {
            DrawSpriteWidget(C, WeaponCanRestIcon);
        }
    }

    // Resupply icon
    if (PawnOwner != none && PawnOwner.bTouchingResupply)
    {
        if (Vehicle(PawnOwner) != none)
        {
            if (Level.TimeSeconds - PawnOwner.LastResupplyTime <=  1.5)
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
            if (Level.TimeSeconds - PawnOwner.LastResupplyTime <=  1.5)
            {
                DrawSpriteWidget(C, ResupplyZoneResupplyingPlayerIcon);
            }
            else
            {
                DrawSpriteWidget(C, ResupplyZoneNormalPlayerIcon);
            }
        }
    }

    // Show weapon info
    if (bShowWeaponInfo && PawnOwner != none && PawnOwner.Weapon != none && AmmoIcon.WidgetTexture != none)
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
        }
    }

    DrawCaptureBar(C);

    // Draw Compass
    if (bShowCompass)
    {
        DrawCompass(C);
    }

    // Draw the 'map updated' icon
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

    DrawPlayerNames(C);

    if ((Level.NetMode == NM_Standalone || GRI.bAllowNetDebug) && bShowRelevancyDebugOverlay)
    {
        DrawNetworkActors(C);
    }

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
        if (PortraitTime - Level.TimeSeconds > 0.0)
        {
            PortraitX = FMax(0.0, PortraitX - 3.0 * (Level.TimeSeconds - hudLastRenderTime));
        }
        else if (PortraitPRI != none)
        {
            PortraitX = FMin(1.0, PortraitX + 3.0 * (Level.TimeSeconds - hudLastRenderTime));

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

            //Draw the voice icon
            DrawVoiceIcon(C, PortraitPRI);
        }
    }

    if (bShowWeaponInfo && PawnOwner != none && PawnOwner.Weapon != none)
    {
        PawnOwner.Weapon.NewDrawWeaponInfo(C, 0.86 * C.ClipY);
    }

    // Slow, for debugging only
    if (bDebugDriverCollision && class'DH_LevelInfo'.static.DHDebugMode())
    {
        DrawDriverPointSphere();
    }

    // Slow, for debugging only
    if (bDebugVehicleHitPoints && class'DH_LevelInfo'.static.DHDebugMode())
    {
        DrawVehiclePointSphere();
    }

    // Slow, for debugging only
    if (bDebugPlayerCollision && class'DH_LevelInfo'.static.DHDebugMode())
    {
        DrawPointSphere();
    }
}

// Draws all the vehicle HUD info, e.g. vehicle icon, passengers, ammo, speed, throttle
// Overridden to handle new system where rider pawns won't exist on clients unless occupied (& generally prevent spammed log errors)
function DrawVehicleIcon(Canvas Canvas, ROVehicle Vehicle, optional ROVehicleWeaponPawn Passenger)
{
    local  ROTreadCraft           TreadCraft;
    local  ROWheeledVehicle       WheeledVehicle;
    local  ROVehicleWeaponPawn    WeaponPawn;
    local  ROVehicleWeapon        VehWeapon;
    local  ROTankCannon           Cannon;
    local  PlayerReplicationInfo  PRI;
    local  AbsoluteCoordsInfo     Coords, Coords2;
    local  SpriteWidget           Widget;
    local  color                  VehicleColor;
    local  rotator                MyRot;
    local  int                    i, Current, Pending;
    local  float                  f, XL, YL, Y_one, MyScale, ProportionOfReloadRemaining;
    local  float                  ModifiedVehicleOccupantsTextYOffset; // used to offset text vertically when drawing coaxial ammo info
    local  array<string>          Lines;

    if (bHideHud)
    {
        return;
    }

    //////////////////////////////////////
    // Draw vehicle icon
    //////////////////////////////////////

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

    // The IS2 is so frelling huge that it needs to use larger textures
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

    // Draw treaded vehicle specific stuff
    TreadCraft = ROTreadCraft(Vehicle);

    if (TreadCraft != none)
    {
        // Update turret references
        if (TreadCraft.CannonTurret == none)
        {
            TreadCraft.UpdateTurretReferences();
        }

        // Draw threads (if needed)
        if (TreadCraft.bLeftTrackDamaged)
        {
            VehicleThreads[0].TextureScale = TreadCraft.VehicleHudThreadsScale;
            VehicleThreads[0].PosX = TreadCraft.VehicleHudThreadsPosX[0];
            VehicleThreads[0].PosY = TreadCraft.VehicleHudThreadsPosY;
            DrawSpriteWidgetClipped(Canvas, VehicleThreads[0], Coords, true, XL, YL, false, true);
        }

        if (TreadCraft.bRightTrackDamaged)
        {
            VehicleThreads[1].TextureScale = TreadCraft.VehicleHudThreadsScale;
            VehicleThreads[1].PosX = TreadCraft.VehicleHudThreadsPosX[1];
            VehicleThreads[1].PosY = TreadCraft.VehicleHudThreadsPosY;
            DrawSpriteWidgetClipped(Canvas, VehicleThreads[1], Coords, true, XL, YL, false, true);
        }

        // Update & draw look turret (if needed)
        if (Passenger != none && Passenger.IsA('ROTankCannonPawn'))
        {
            TreadCraft.VehicleHudTurretLook.Rotation.Yaw = Vehicle.Rotation.Yaw - Passenger.CustomAim.Yaw;
            Widget.WidgetTexture = TreadCraft.VehicleHudTurretLook;
            Widget.Tints[0].A /= 2;
            Widget.Tints[1].A /= 2;
            DrawSpriteWidgetClipped(Canvas, Widget, Coords, true);
            Widget.Tints[0] = VehicleColor;
            Widget.Tints[1] = VehicleColor;

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
                Cannon = ROTankCannon(Passenger.Gun);

                if (Cannon != none && Cannon.bMultipleRoundTypes)
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

                if (Cannon != none)
                {
                    // Draw coaxial gun ammo info if needed
                    if (Cannon.AltFireProjectileClass != none)
                    {
                        // Draw coaxial gun ammo icon
                        VehicleAltAmmoIcon.WidgetTexture = Cannon.hudAltAmmoIcon;
                        DrawSpriteWidget(Canvas, VehicleAltAmmoIcon);

                        // Draw coaxial gun reload state icon (if needed) // Matt: to show reload progress in red, like a tank cannon reload
                        if (DHTankCannonPawn(Passenger) != none)
                        {
                            ProportionOfReloadRemaining = DHTankCannonPawn(Passenger).GetAltAmmoReloadState();

                            if (ProportionOfReloadRemaining > 0.0)
                            {
                                VehicleAltAmmoReloadIcon.WidgetTexture = DHTankCannonPawn(Passenger).AltAmmoReloadTexture;
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

        // Update & draw turret
        if (TreadCraft.CannonTurret != none)
        {
            MyRot = rotator(vector(TreadCraft.CannonTurret.CurrentAim) >> TreadCraft.CannonTurret.Rotation);
            TreadCraft.VehicleHudTurret.Rotation.Yaw = Vehicle.Rotation.Yaw - MyRot.Yaw;
            Widget.WidgetTexture = TreadCraft.VehicleHudTurret;
            DrawSpriteWidgetClipped(Canvas, Widget, Coords, true);
        }
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

            // Draw reload state icon (if needed) // Matt: to show reload progress in red, like a tank cannon reload
            if (DHMountedTankMGPawn(Passenger) != none)
            {
                ProportionOfReloadRemaining = Passenger.GetAmmoReloadState();

                if (ProportionOfReloadRemaining > 0.0)
                {
                    VehicleMGAmmoReloadIcon.WidgetTexture = DHMountedTankMGPawn(Passenger).VehicleMGReloadTexture;
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
                ((ROPlayer(Vehicle.Controller).bInterpolatedTankThrottle && TreadCraft != none) || (ROPlayer(Vehicle.Controller).bInterpolatedVehicleThrottle && TreadCraft == none)))
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

    // Draw occupant dots
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
            if (i - 1 >= Vehicle.WeaponPawns.Length)
            {
                // Matt: added to replace lines above - if we're already beyond WeaponPawns.Length, there's no point continuing with the for loop
                break;
            }
            // Matt: added to show missing rider/passenger pawns, as now they won't exist on clients unless occupied
            else if (Vehicle.WeaponPawns[i - 1] == none)
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

        for (i = Lines.Length - 1; i >= 0 ; --i)
        {
            VehicleOccupantsText.Text = Lines[i];
            DrawTextWidgetClipped(Canvas, VehicleOccupantsText, Coords2, XL, YL, Y_one);
            VehicleOccupantsText.OffsetY -= YL;
        }
    }
}

// Draws identify info for friendlies
// Overridden to handle AT reload messages
function DrawPlayerNames(Canvas C)
{
    local Actor            HitActor;
    local vector           HitLocation, HitNormal, ViewPos, ScreenPos, Loc, X, Y, Z, Dir;
    local float            StrX, StrY, Distance;
    local string           Display;
    local bool             bIsAVehicle;
    local DHPawn           MyDHP, OtherDHP;
    local DHMortarVehicle  Mortar;

    if (PawnOwner == none || PawnOwner.Controller == none)
    {
        return;
    }

    if (!bSetColour)
    {
        SetAlliedColour();
    }

    ViewPos = PawnOwner.Location + PawnOwner.BaseEyeHeight * vect(0.0, 0.0, 1.0);
    HitActor = Trace(HitLocation, HitNormal, ViewPos + 1600.0 * vector(PawnOwner.Controller.Rotation), ViewPos, true);

    // CHECK FOR MORTAR - Basnett 2011
    if (HitActor != none && DHPawn(PawnOwner) != none && DHMortarVehicle(HitActor) != none)
    {
        MyDHP = DHPawn(PawnOwner);

        Mortar = DHMortarVehicle(HitActor);

        if (Mortar != none && Mortar.VehicleTeam == MyDHP.GetTeamNum())
        {
            NamedPlayer = Mortar;

            // Draw player name
            C.Font = GetPlayerNameFont(C);
            Loc = NamedPlayer.Location;
            Loc.Z += NamedPlayer.CollisionHeight + 8.0;
            ScreenPos = C.WorldToScreen(Loc);

            if (Mortar.PlayerReplicationInfo != none)
            {
                C.DrawColor = GetTeamColour(Mortar.PlayerReplicationInfo.Team.TeamIndex);
                C.TextSize(Mortar.PlayerReplicationInfo.PlayerName, StrX, StrY);
                C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 2.0);
                Display = Mortar.PlayerReplicationInfo.PlayerName;
                C.DrawTextClipped(Display);
            }

            // Someone's on it - let's check their ammunition
            // Also, are we capable of reloading?
            if (MyDHP != none && MyDHP.bHasMortarAmmo && Mortar.bCanBeResupplied)
            {
                Distance = VSizeSquared(Loc - PawnOwner.Location);

                if (MyDHP != none)
                {
                    MyDHP.bCanMGResupply = false;
                    MyDHP.bCanATReload = false;
                    MyDHP.bCanMortarResupply = false;

                    if (Distance < 14400.0) // 2 meters
                    {
                        MyDHP.bCanMortarResupply = true;
                        Display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                    }
                    else
                    {
                        MyDHP.bCanMortarResupply = false;
                        Display = NeedAmmoText;
                    }
                }

                // Draw text under player's name (need ammo or press x to resupply)
                C.DrawColor = WhiteColor;
                C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 1.0);
                C.DrawTextClipped(Display);
            }
        }

        return;
    }

    if (Pawn(HitActor) != none && Pawn(HitActor).PlayerReplicationInfo != none &&
        (PawnOwner.PlayerReplicationInfo.Team == none || PawnOwner.PlayerReplicationInfo.Team == Pawn(HitActor).PlayerReplicationInfo.Team))
    {
        if (NamedPlayer != HitActor || Level.TimeSeconds - NameTime > 0.5)
        {
            NameTime = Level.TimeSeconds;
        }

        NamedPlayer = Pawn(HitActor);
    }
    else
    {
        NamedPlayer = none;
    }

    if (NamedPlayer != none && NamedPlayer.PlayerReplicationInfo != none && Level.TimeSeconds - NameTime < 1.0)
    {
        MyDHP = DHPawn(PawnOwner);
        OtherDHP = DHPawn(NamedPlayer);

        // Quick check simply to stop error log spam
        bIsAVehicle = (OtherDHP == none);

        GetAxes(PlayerOwner.Rotation, X, Y, Z);
        Dir = Normal(NamedPlayer.Location - PawnOwner.Location);

        if (Dir dot X > 0.0)
        {
            C.DrawColor = GetTeamColour(NamedPlayer.PlayerReplicationInfo.Team.TeamIndex);
            C.Font = GetPlayerNameFont(C);

            // Mortar resupply
            if (MyDHP != none && OtherDHP != none && MyDHP.bHasMortarAmmo && OtherDHP.bMortarCanBeResupplied)
            {
                // Draw player name
                Loc = NamedPlayer.Location;
                Loc.Z += NamedPlayer.CollisionHeight + 8.0;
                ScreenPos = C.WorldToScreen(Loc);
                C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, StrX, StrY);
                C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 2.0);
                Display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                C.DrawTextClipped(Display);
                Distance = VSizeSquared(Loc - PawnOwner.Location);

                if (MyDHP != none)
                {
                    MyDHP.bCanMGResupply = false;
                    MyDHP.bCanATReload = false;
                    MyDHP.bCanMortarResupply = false;

                    if (Distance < 14400.0) // 2 meters
                    {
                        MyDHP.bCanMortarResupply = true;
                        Display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                    }
                    else
                    {
                        MyDHP.bCanMortarResupply = false;
                        Display = NeedAmmoText;
                    }
                }

                // Draw text under player's name (need ammo or press x to resupply)
                C.DrawColor = WhiteColor;
                C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 1.0);
                C.DrawTextClipped(Display);
            }
            else if (bIsAVehicle || !OtherDHP.bWeaponCanBeReloaded)
            {
                // MG resupply
                if (MyDHP != none && !NamedPlayer.IsA('Vehicle') && MyDHP.bHasMGAmmo && OtherDHP.bWeaponCanBeResupplied && OtherDHP.bWeaponNeedsResupply)
                {
                    // Draw player name
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8.0;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, StrX, StrY);
                    C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 2.0);
                    Display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(Display);

                    Distance = VSizeSquared(Loc - PawnOwner.Location);

                    if (MyDHP != none)
                    {
                        MyDHP.bCanATResupply = false;
                        MyDHP.bCanATReload = false;

                        if (Distance < 14400.0) // 2 meters
                        {
                            MyDHP.bCanMGResupply = true;
                            Display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                        }
                        else
                        {
                            MyDHP.bCanMGResupply = false;
                            Display = NeedAmmoText;
                        }
                    }

                    // Draw text under player's name (need ammo or press x to resupply)
                    C.DrawColor = WhiteColor;
                    C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 1.0);
                    C.DrawTextClipped(Display);
                }
                else
                {
                    if (MyDHP != none)
                    {
                        MyDHP.bCanMGResupply = false;
                        MyDHP.bCanATResupply = false;
                        MyDHP.bCanATReload = false;
                    }

                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, StrX, StrY);
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8.0;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 0.5);

                    Display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(Display);
                }
            }
            // AT weapon assisted reload
            else if (OtherDHP != none && OtherDHP.bWeaponCanBeReloaded)
            {
                if (MyDHP != none && !NamedPlayer.IsA('Vehicle') && OtherDHP.bWeaponNeedsReload)
                {
                    // Draw player name
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8.0;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, StrX, StrY);
                    C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 2.0);
                    Display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(Display);

                    Distance = VSizeSquared(Loc - PawnOwner.Location);

                    MyDHP.bCanMGResupply = false;
                    MyDHP.bCanATResupply = false;

                    if (Distance < 14400.0) // 2 meters
                    {
                        MyDHP.bCanATReload = true;

                        Display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanReloadText, PlayerController(Owner));
                    }
                    else
                    {
                        MyDHP.bCanATReload = false;

                        Display = NeedReloadText;
                    }

                    // Draw text under player's name (need reload or press x to reload)
                    C.DrawColor = WhiteColor;
                    C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 1.0);
                    C.DrawTextClipped(Display);
                }
                // AT weapon resupply
                else if (MyDHP != none && OtherDHP != none && !NamedPlayer.IsA('Vehicle') && MyDHP.bHasATAmmo && OtherDHP.bWeaponCanBeResupplied && OtherDHP.bWeaponNeedsResupply)
                {
                    // Draw player name
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8.0;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, StrX, StrY);
                    C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 2.0);
                    Display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(Display);

                    Distance = VSizeSquared(Loc - PawnOwner.Location);

                    MyDHP.bCanMGResupply = false;
                    MyDHP.bCanATReload = false;

                    if (Distance < 14400.0) // 2 meters
                    {
                        MyDHP.bCanATResupply = true;

                        Display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                    }
                    else
                    {
                        MyDHP.bCanATResupply = false;

                        Display = NeedAmmoText;
                    }

                    // Draw text under player's name (need ammo or press x to resupply)
                    C.DrawColor = WhiteColor;
                    C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 1.0);
                    C.DrawTextClipped(Display);
                }
                // No resupply or assisted reload - just draw player name
                else
                {
                    // Draw player name
                    if (MyDHP != none)
                    {
                        MyDHP.bCanMGResupply = false;
                        MyDHP.bCanATResupply = false;
                        MyDHP.bCanATReload = false;
                    }

                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, StrX, StrY);
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8.0;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.SetPos(ScreenPos.X - StrX * 0.5, ScreenPos.Y - StrY * 0.5);

                    Display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(Display);
                }
            }
        }
    }
}

// Modified to only show the vehicle occupant ('Driver') hit points, not the vehicle's special hit points for engine & ammo stores
simulated function DrawDriverPointSphere()
{
    local ROVehicle       V;
    local ROVehicleWeapon VW;
    local Coords          CO;
    local vector          HeadLoc;
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
                    HeadLoc = CO.Origin + (V.VehHitpoints[i].PointHeight * V.VehHitpoints[i].PointScale * CO.XAxis);
                    HeadLoc = HeadLoc + (V.VehHitpoints[i].PointOffset >> V.Rotation);
                    V.DrawDebugSphere(HeadLoc, V.VehHitpoints[i].PointRadius * V.VehHitpoints[i].PointScale, 10, 0, 255, 0);
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
                    HeadLoc = CO.Origin + (VW.VehHitpoints[i].PointHeight * VW.VehHitpoints[i].PointScale * CO.XAxis);
                    HeadLoc = HeadLoc + (VW.VehHitpoints[i].PointOffset >> rotator(CO.Xaxis));
                    VW.DrawDebugSphere(HeadLoc, VW.VehHitpoints[i].PointRadius * VW.VehHitpoints[i].PointScale, 10, 0, 255, 0);
                }
            }
        }
    }
}

// New function showing vehicle special hit points for engine (blue) & ammo stores (red), plus a DHTreadCraft's extra hit points (gold for gun traverse/pivot, pink for periscopes)
simulated function DrawVehiclePointSphere()
{
    local ROVehicle       V;
    local DHTreadCraft TC;
    local Coords          CO;
    local vector          HeadLoc;
    local int             i;

    foreach DynamicActors(class'ROVehicle', V)
    {
        if (V != none)
        {
            for (i = 0; i < V.VehHitpoints.Length; ++i)
            {
                if (V.VehHitpoints[i].HitPointType != HP_Driver && V.VehHitpoints[i].PointBone != '')
                {
                    CO = V.GetBoneCoords(V.VehHitpoints[i].PointBone);
                    HeadLoc = CO.Origin + (V.VehHitpoints[i].PointHeight * V.VehHitpoints[i].PointScale * CO.XAxis);
                    HeadLoc = HeadLoc + (V.VehHitpoints[i].PointOffset >> V.Rotation);

                    if (V.VehHitpoints[i].HitPointType == HP_Engine)
                    {
                        V.DrawDebugSphere(HeadLoc, V.VehHitpoints[i].PointRadius * V.VehHitpoints[i].PointScale, 10, 0, 0, 255); // blue
                    }
                    else if (V.VehHitpoints[i].HitPointType == HP_AmmoStore)
                    {
                        V.DrawDebugSphere(HeadLoc, V.VehHitpoints[i].PointRadius * V.VehHitpoints[i].PointScale, 10, 255, 0, 0); // red
                    }
                    else
                    {
                        V.DrawDebugSphere(HeadLoc, V.VehHitpoints[i].PointRadius * V.VehHitpoints[i].PointScale, 10, 200, 200, 200); // gray
                    }
                }
            }

            TC = DHTreadCraft(V);

            if (TC != none)
            {
                for (i = 0; i < TC.NewVehHitpoints.Length; ++i)
                {
                    if (TC.NewVehHitpoints[i].PointBone != '')
                    {
                        CO = TC.GetBoneCoords(TC.NewVehHitpoints[i].PointBone);
                        HeadLoc = CO.Origin + (TC.NewVehHitpoints[i].PointHeight * TC.NewVehHitpoints[i].PointScale * CO.XAxis);
                        HeadLoc = HeadLoc + (TC.NewVehHitpoints[i].PointOffset >> TC.Rotation);

                        if (TC.NewVehHitpoints[i].NewHitPointType == NHP_Traverse || TC.NewVehHitpoints[i].NewHitPointType == NHP_GunPitch)
                        {
                            TC.DrawDebugSphere(HeadLoc, TC.NewVehHitpoints[i].PointRadius * TC.NewVehHitpoints[i].PointScale, 10, 255, 255, 0); // gold
                        }
                        else if (TC.NewVehHitpoints[i].NewHitPointType == NHP_GunOptics || TC.NewVehHitpoints[i].NewHitPointType == NHP_PeriscopeOptics)
                        {
                            TC.DrawDebugSphere(HeadLoc, TC.NewVehHitpoints[i].PointRadius * TC.NewVehHitpoints[i].PointScale, 10, 255, 0, 255); // pink
                        }
                        else
                        {
                            TC.DrawDebugSphere(HeadLoc, TC.NewVehHitpoints[i].PointRadius * TC.NewVehHitpoints[i].PointScale, 10, 255, 255, 255); // white
                        }
                    }
                }
            }
        }
    }
}

// Renders the objectives on the HUD similar to the scoreboard
simulated function DrawObjectives(Canvas C)
{
    local DHGameReplicationInfo   DHGRI;
    local DHPlayerReplicationInfo PRI;
    local AbsoluteCoordsInfo      MapCoords, SubCoords;
    local SpriteWidget  Widget;
    local Actor         A;
    local DHPlayer      Player;
    local Controller    P;
    local int           i, OwnerTeam, ObjCount, SecondaryObjCount;
    local bool          bShowRally, bShowArtillery, bShowResupply, bShowArtyCoords, bShowNeutralObj, bShowMGResupplyRequest, bShowHelpRequest, bShowAttackDefendRequest;
    local bool          bShowArtyStrike, bShowDestroyableItems, bShowDestroyedItems, bShowVehicleResupply, bHasSecondaryObjectives;
    local float         MyMapScale, XL, YL, YL_one, Time;
    local vector        Temp, MapCenter;
    // PSYONIX: DEBUG
    local ROVehicleWeaponPawn WeaponPawn;
    local Vehicle       V;
    local float         PawnRotation, X, Y, StrX, StrY;
    local string        s;
    // Net debug
    local Actor         NetActor;
    local Pawn          NetPawn;
    local int           Pos;
    // AT Gun
    local bool          bShowATGun;
    local DHPawn        DHP;
    local DHRoleInfo    RI;

    if (PlayerOwner.Pawn != none)
    {
        DHP = DHPawn(PlayerOwner.Pawn);
    }

    DHGRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (DHGRI == none)
    {
        return;
    }

    // Update time
    if (DHGRI != none)
    {
        if (!DHGRI.bMatchHasBegun)
        {
            CurrentTime = FMax(0.0, DHGRI.RoundStartTime + DHGRI.PreStartTime - DHGRI.ElapsedTime);
        }
        else
        {
            CurrentTime = FMax(0.0, DHGRI.RoundStartTime + DHGRI.RoundDuration - DHGRI.ElapsedTime);
        }
    }

    // Get player
    Player = DHPlayer(PlayerOwner);

    // Get PRI
    PRI = DHPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);

    // Get Role info
    if (PRI.RoleInfo != none)
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
        AnimateMapCurrentPosition -= (Level.TimeSeconds - hudLastRenderTime) / AnimateMapSpeed;

        if (AnimateMapCurrentPosition <= 0.0)
        {
            AnimateMapCurrentPosition = 0.0;
            bAnimateMapIn = false;
        }
    }
    else if (bAnimateMapOut)
    {
        AnimateMapCurrentPosition += (Level.TimeSeconds - hudLastRenderTime) / AnimateMapSpeed;

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

    // Save coordinates for use in menu page
    MapLevelImageCoordinates = SubCoords;

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
    if( MapLevelOverlay.WidgetTexture != none )
    {
        DrawSpriteWidgetClipped(C, MapLevelOverlay, subCoords, true);
    }

    // Calculate level map constants
    Temp = DHGRI.SouthWestBounds - DHGRI.NorthEastBounds;
    MapCenter =  Temp / 2.0  + DHGRI.NorthEastBounds;
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
            bShowVehicleResupply = true;
            DrawIconOnMap(C, SubCoords, MapIconVehicleResupply, MyMapScale, DHGRI.ResupplyAreas[i].ResupplyVolumeLocation, MapCenter);
        }
        else
        {
            // Player resupply icon
            bShowResupply = true;
            DrawIconOnMap(C, SubCoords, MapIconResupply, MyMapScale, DHGRI.ResupplyAreas[i].ResupplyVolumeLocation, MapCenter);
        }
    }

    // Draw AT guns
    for (i = 0; i < arraycount(DHGRI.ATCannons); ++i)
    {
        if (DHGRI.ATCannons[i].ATCannonLocation != vect(0.0, 0.0, 0.0) && DHGRI.ATCannons[i].Team == PlayerOwner.GetTeamNum())
        {
            if (DHGRI.ATCannons[i].ATCannonLocation.Z > 0.0) // ATCannon is active is the Z location is greater than 0
            {
                bShowATGun = true;

                // AT gGun icon
                MapIconATGun.Tints[0] = WhiteColor;
                MapIconATGun.Tints[1] = WhiteColor;
                DrawIconOnMap(C, SubCoords, MapIconATGun, MyMapScale, DHGRI.ATCannons[i].ATCannonLocation, MapCenter);
            }
        }
    }

    if (Level.NetMode == NM_Standalone && bShowDebugInfoOnMap)
    {
        // PSYONIX: DEBUG - Show all vehicles on map who have no driver
        foreach DynamicActors(class'Vehicle', V)
        {
            Widget = MapIconRally[V.GetTeamNum()];
            Widget.TextureScale = 0.04f;

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
                Widget.TextureScale = 0.025f;

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
                    Widget.TextureScale = 0.04f;
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
                Widget.TextureScale = 0.04f;
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
                Widget.TextureScale = 0.04f;
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

                Widget.TextureScale = 0.04f;
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
                    Widget.TextureScale = 0.04f;
                    Widget.RenderStyle = STY_Normal;

                    s = "" $ NetActor;

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
            bShowArtyCoords = true;
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
                    bShowDestroyedItems = true;
                }
                else
                {
                    DrawIconOnMap(C, SubCoords, MapIconDestroyableItem, MyMapScale, Player.Destroyables[i].Location, MapCenter);
                    bShowDestroyableItems = true;
                }
            }
        }
    }

    if (OwnerTeam != 255)
    {
        // Draw the in-progress arty strikes
        if ((OwnerTeam == AXIS_TEAM_INDEX || OwnerTeam == ALLIES_TEAM_INDEX) && DHGRI.ArtyStrikeLocation[OwnerTeam] != vect(0.0, 0.0, 0.0))
        {
            DrawIconOnMap(C, SubCoords, MapIconArtyStrike, MyMapScale, DHGRI.ArtyStrikeLocation[OwnerTeam], MapCenter);
            bShowArtyStrike = true;
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
                bShowRally = true;
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

                bShowArtillery = true;
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

                bShowArtillery = true;
                DrawIconOnMap(C, SubCoords, MapIconRadio, MyMapScale, DHGRI.AlliedRadios[i].Location, MapCenter);
            }
        }

        // Draw player-carried Artillery radio icons if player is an artillery officer
        if (PRI.RoleInfo != none && RI != none && RI.bIsArtilleryOfficer)
        {
            if (OwnerTeam == AXIS_TEAM_INDEX)
            {
                for (i = 0; i < arraycount(DHGRI.CarriedAxisRadios); ++i)
                {
                    if (DHGRI.CarriedAxisRadios[i] == none)
                    {
                        continue;
                    }

                    bShowArtillery = true;
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

                    bShowArtillery = true;
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
                        bShowHelpRequest = true;
                        Widget = MapIconHelpRequest;
                        Widget.Tints[0].A = 125;
                        Widget.Tints[1].A = 125;
                        DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.Objectives[DHGRI.AxisHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 1: // attack request
                    case 2: // defend request
                        bShowAttackDefendRequest = true;
                        DrawIconOnMap(C, SubCoords, MapIconAttackDefendRequest, MyMapScale, DHGRI.Objectives[DHGRI.AxisHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 3: // mg resupply requests
                        bShowMGResupplyRequest = true;
                        DrawIconOnMap(C, SubCoords, MapIconMGResupplyRequest[AXIS_TEAM_INDEX], MyMapScale, DHGRI.AxisHelpRequestsLocs[i], MapCenter);
                        break;

                    case 4: // help request at coords
                        bShowHelpRequest = true;
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
                    if (DHGRI.GermanMortarTargets[i].Location != vect(0.0, 0.0, 0.0) && DHGRI.GermanMortarTargets[i].bCancelled == 0)
                    {
                        DrawIconOnMap(C, SubCoords, MapIconMortarTarget, MyMapScale, DHGRI.GermanMortarTargets[i].Location, MapCenter);
                    }
                }
            }

            // Draw hit location for mortar observer's confirmed hits on his own target
            if (RI != none && RI.bIsMortarObserver && Player != none && Player.MortarTargetIndex != 255)
            {
                if (DHGRI.GermanMortarTargets[Player.MortarTargetIndex].HitLocation != vect(0.0, 0.0, 0.0) && DHGRI.GermanMortarTargets[Player.MortarTargetIndex].bCancelled == 0)
                {
                    DrawIconOnMap(C, SubCoords, MapIconMortarHit, MyMapScale, DHGRI.GermanMortarTargets[Player.MortarTargetIndex].HitLocation, MapCenter);
                }
            }

            // Draw hit location for mortar operator if he has a valid hit location
            if (RI != none && RI.bCanUseMortars && Player != none && Player.MortarHitLocation != vect(0.0, 0.0, 0.0))
            {
                DrawIconOnMap(C, SubCoords, MapIconMortarHit, MyMapScale, Player.MortarHitLocation, MapCenter);
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
                        bShowHelpRequest = true;
                        Widget = MapIconHelpRequest;
                        Widget.Tints[0].A = 125;
                        Widget.Tints[1].A = 125;
                        DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.Objectives[DHGRI.AlliedHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 1: // attack request
                    case 2: // defend request
                        bShowAttackDefendRequest = true;
                        DrawIconOnMap(C, SubCoords, MapIconAttackDefendRequest, MyMapScale, DHGRI.Objectives[DHGRI.AlliedHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 3: // mg resupply requests
                        bShowMGResupplyRequest = true;
                        DrawIconOnMap(C, SubCoords, MapIconMGResupplyRequest[ALLIES_TEAM_INDEX], MyMapScale, DHGRI.AlliedHelpRequestsLocs[i], MapCenter);
                        break;

                    case 4: // help request at coords
                        bShowHelpRequest = true;
                        DrawIconOnMap(C, SubCoords, MapIconHelpRequest, MyMapScale, DHGRI.AlliedHelpRequestsLocs[i], MapCenter);
                        break;

                    default:
                        Log("Unknown requestType found in AlliedHelpRequests[" $ i $ "]:" @ DHGRI.AlliedHelpRequests[i].requestType);
                }
            }

            // Draw all mortar targets on the map
            for (i = 0; i < arraycount(DHGRI.AlliedMortarTargets); ++i)
            {
                if (DHGRI.AlliedMortarTargets[i].Location != vect(0.0, 0.0, 0.0) && DHGRI.AlliedMortarTargets[i].bCancelled == 0)
                {
                    DrawIconOnMap(C, SubCoords, MapIconMortarTarget, MyMapScale, DHGRI.AlliedMortarTargets[i].Location, MapCenter);
                }
            }

            // Draw hit location for mortar observer's confirmed hits on his own target
            if (RI != none && RI.bIsMortarObserver && Player != none && Player.MortarTargetIndex != 255)
            {
                if (DHGRI.AlliedMortarTargets[Player.MortarTargetIndex].HitLocation != vect(0.0, 0.0, 0.0) && DHGRI.GermanMortarTargets[Player.MortarTargetIndex].bCancelled == 0)
                {
                    DrawIconOnMap(C, SubCoords, MapIconMortarHit, MyMapScale, DHGRI.AlliedMortarTargets[Player.MortarTargetIndex].HitLocation, MapCenter);
                }
            }

            // Draw hit location for mortar operator if he has a valid hit location
            if (RI != none && RI.bCanUseMortars && Player != none && Player.MortarHitLocation != vect(0.0, 0.0, 0.0))
            {
                DrawIconOnMap(C, SubCoords, MapIconMortarHit, MyMapScale, Player.MortarHitLocation, MapCenter);
            }
        }
    }

    // Draw objectives
    for (i = 0; i < arraycount(DHGRI.Objectives); ++i)
    {
        if (DHGRI.Objectives[i] == none)
        {
            continue;
        }

        // Set up icon info
        if (DHGRI.Objectives[i].ObjState == OBJ_Axis)
        {
            Widget = MapIconTeam[AXIS_TEAM_INDEX];
        }
        else if (DHGRI.Objectives[i].ObjState == OBJ_Allies)
        {
            Widget = MapIconTeam[ALLIES_TEAM_INDEX];
        }
        else
        {
            bShowNeutralObj = true;
            Widget = MapIconNeutral;
        }
        if (!DHGRI.Objectives[i].bActive)
        {
            Widget.Tints[0] = GrayColor;
            Widget.Tints[1] = GrayColor;
            Widget.Tints[0].A = 50;
            Widget.Tints[1].A = 125;
        }
        else
        {
            Widget.Tints[0] = WhiteColor; Widget.Tints[1] = WhiteColor;
        }

        // Draw flashing icon if objective is disputed
        if (DHGRI.Objectives[i].CompressedCapProgress != 0 && DHGRI.Objectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
        {
            if (DHGRI.Objectives[i].CompressedCapProgress == 1 || DHGRI.Objectives[i].CompressedCapProgress == 2)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.Objectives[i].Location, MapCenter, 2, DHGRI.Objectives[i].ObjName, DHGRI, i);
            }
            else if (DHGRI.Objectives[i].CompressedCapProgress == 3 || DHGRI.Objectives[i].CompressedCapProgress == 4)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.Objectives[i].Location, MapCenter, 3, DHGRI.Objectives[i].ObjName, DHGRI, i);
            }
            else
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.Objectives[i].Location, MapCenter, 1, DHGRI.Objectives[i].ObjName, DHGRI, i);
            }
        }
        else
        {
            DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.Objectives[i].Location, MapCenter, 1, DHGRI.Objectives[i].ObjName, DHGRI, i);
        }

        // If the objective isn't completely captured, overlay a flashing icon from other team
        if (DHGRI.Objectives[i].CompressedCapProgress != 0 && DHGRI.Objectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
        {
            if (DHGRI.Objectives[i].CurrentCapTeam == ALLIES_TEAM_INDEX)
            {
                Widget = MapIconDispute[ALLIES_TEAM_INDEX];
            }
            else
            {
                Widget = MapIconDispute[AXIS_TEAM_INDEX];
            }

            if (DHGRI.Objectives[i].CompressedCapProgress == 1 || DHGRI.Objectives[i].CompressedCapProgress == 2)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.Objectives[i].Location, MapCenter, 4);
            }
            else if (DHGRI.Objectives[i].CompressedCapProgress == 3 || DHGRI.Objectives[i].CompressedCapProgress == 4)
            {
                DrawIconOnMap(C, SubCoords, Widget, MyMapScale, DHGRI.Objectives[i].Location, MapCenter, 5);
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
    MapScaleText.text = "Grid Square: ~" $ string(int(class'DHLib'.static.UnrealToMeters(Abs(DHGRI.NorthEastBounds.X - DHGRI.SouthWestBounds.X)) / 9.0)) $ "m";
    DrawTextWidgetClipped(C, MapScaleText, subCoords);

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

    // Draw timer
    DrawTextWidgetClipped(C, MapTimerTitle, MapCoords, XL, YL, YL_one);

    // Calculate seconds & minutes
    Time = CurrentTime;
    MapTimerTexts[3].Text = String(Int(Time % 10.0));
    Time /= 10.0;
    MapTimerTexts[2].Text = String(Int(Time % 6.0));
    Time /= 6.0;
    MapTimerTexts[1].Text = String(Int(Time % 10.0));
    Time /= 10.0;
    MapTimerTexts[0].Text = String(Int(Time));

    // Draw timer values
    C.Font = GetFontSizeIndex(C, -2);

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
    DrawLegendElement(C, SubCoords, MapIconTeam[AXIS_TEAM_INDEX], LegendAxisObjectiveText);
    DrawLegendElement(C, SubCoords, MapIconTeam[ALLIES_TEAM_INDEX], LegendAlliesObjectiveText);

    if (bShowNeutralObj || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconNeutral, LegendNeutralObjectiveText);
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

    if (bShowVehicleResupply)
    {
        DrawLegendElement(C, SubCoords, MapIconVehicleResupply, LegendResupplyAreaText);
    }

    if ((bShowRally || bShowAllItemsInMapLegend) && OwnerTeam != 255)
    {
        DrawLegendElement(C, SubCoords, MapIconRally[OwnerTeam], LegendRallyPointText);
    }

    if (bShowArtyCoords || bShowAllItemsInMapLegend)
    {
        Widget = MapIconArtyStrike;
        Widget.Tints[TeamIndex].A = 64;
        DrawLegendElement(C, SubCoords, Widget, LegendSavedArtilleryText);
        Widget.Tints[TeamIndex].A = 255;
    }

    if (bShowArtyStrike || bShowAllItemsInMapLegend)
    {
        DrawLegendElement(C, SubCoords, MapIconArtyStrike, LegendArtyStrikeText);
    }

    if ((bShowMGResupplyRequest || bShowAllItemsInMapLegend) && OwnerTeam != 255)
    {
        DrawLegendElement(C, SubCoords, MapIconMGResupplyRequest[OwnerTeam], LegendMGResupplyText);
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
    for (i = 0; i < arraycount(DHGRI.Objectives); ++i)
    {
        if (DHGRI.Objectives[i] == none || !DHGRI.Objectives[i].bActive)
        {
            continue;
        }

        if (!DHGRI.Objectives[i].bRequired)
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

    for (i = 0; i < arraycount(DHGRI.Objectives); ++i)
    {
        if (DHGRI.Objectives[i] == none || !DHGRI.Objectives[i].bActive || !DHGRI.Objectives[i].bRequired)
        {
            continue;
        }

        if (DHGRI.Objectives[i].ObjState != OwnerTeam)
        {
            if (DHGRI.Objectives[i].AttackerDescription == "")
            {
                MapObjectivesTexts.Text = ObjCount $ "." @ "Attack" @ DHGRI.Objectives[i].ObjName;
            }
            else
            {
                MapObjectivesTexts.Text = ObjCount $ "." @ DHGRI.Objectives[i].AttackerDescription;
            }
        }
        else
        {
            if (DHGRI.Objectives[i].DefenderDescription == "")
            {
                MapObjectivesTexts.Text = ObjCount $ "." @ "Defend" @ DHGRI.Objectives[i].ObjName;
            }
            else
            {
                MapObjectivesTexts.Text = ObjCount $ "." @ DHGRI.Objectives[i].DefenderDescription;
            }
        }

        DrawTextWidgetClipped(C, MapObjectivesTexts, SubCoords, XL, YL, YL_one);
        MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
        ObjCount++;
    }

    if (bHasSecondaryObjectives)
    {
        MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
        MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
        MapSecondaryObjectivesTitle.OffsetY = MapObjectivesTexts.OffsetY;
        DrawTextWidgetClipped(C, MapSecondaryObjectivesTitle, SubCoords, XL, YL, YL_one);

        for (i = 0; i < arraycount(DHGRI.Objectives); ++i)
        {
            if (DHGRI.Objectives[i] == none || !DHGRI.Objectives[i].bActive|| DHGRI.Objectives[i].bRequired)
            {
                continue;
            }

            if (DHGRI.Objectives[i].ObjState != OwnerTeam)
            {
                MapObjectivesTexts.Text = (SecondaryObjCount + 1) $ "." @ DHGRI.Objectives[i].AttackerDescription;
            }
            else
            {
                MapObjectivesTexts.Text = (SecondaryObjCount + 1) $ "." @ DHGRI.Objectives[i].DefenderDescription;
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
    local int          i, Team;
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
    local ROGameReplicationInfo GRI;
    local class<Ammunition>     AmmoClass;
    local Weapon                W;
    local byte                  Nation;
    local ROPawn                P;

    GRI = ROGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (PawnOwnerPRI != none)
    {
        if (PawnOwner != none)
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
        }

        if (PawnOwnerPRI.Team != none && GRI != none)
        {
            Nation = GRI.NationIndex[PawnOwnerPRI.Team.TeamIndex];
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

    AmmoIcon.WidgetTexture = none; // this is so we don't show icon on binocs or when we have no weapon

    if (PawnOwner == none)
    {
        return;
    }

    W = PawnOwner.Weapon;

    if (W == none)
    {
        return;
    }

    AmmoClass = W.GetAmmoClass(0);

    if (AmmoClass == none)
    {
        return;
    }

    if (W.ItemName == "Scoped Enfield No.4")
    {
        AmmoIcon.WidgetTexture = texture'DH_InterfaceArt_tex.weapon_icons.EnfieldNo4Sniper_ammo';
    }
    else if (W.ItemName == "Scoped Kar98k Rifle")
    {
        AmmoIcon.WidgetTexture = texture'DH_InterfaceArt_tex.weapon_icons.kar98Sniper_ammo';
    }
    else
    {
        AmmoIcon.WidgetTexture = AmmoClass.default.IconMaterial;
    }

    AmmoCount.Value = W.GetHudAmmoCount();
}

simulated function DrawVoiceIcon(Canvas C, PlayerReplicationInfo PRI)
{
    local DHPawn                DHP;
    local ROVehicleWeaponPawn   ROVWP;
    local ROVehicle             ROV;

    if (!bShowVoiceIcon)
    {
        return;
    }

    foreach RadiusActors(class'DHPawn', DHP, VOICE_ICON_DIST_MAX, PlayerOwner.Pawn.Location) // 100 feet
    {
        if (DHP.Health <= 0 || DHP.PlayerReplicationInfo != PRI)
        {
            continue;
        }

        DrawVoiceIconC(C, DHP);

        return;
    }

    foreach RadiusActors(class'ROVehicle', ROV, VOICE_ICON_DIST_MAX, PlayerOwner.Pawn.Location)
    {
        if (ROV.Driver == none || ROV.PlayerReplicationInfo != PRI)
        {
            continue;
        }

        DrawVoiceIconC(C, ROV.Driver);

        return;
    }

    foreach RadiusActors(class'ROVehicleWeaponPawn', ROVWP, VOICE_ICON_DIST_MAX, PlayerOwner.Pawn.Location)
    {
        if (ROVWP.Driver == none || ROVWP.PlayerReplicationInfo != PRI)
        {
            continue;
        }

        DrawVoiceIconC(C, ROVWP.Driver);

        return;
    }
}

simulated function DrawVoiceIconC(Canvas C, Pawn P)
{
    local byte    Alpha;
    local float   D, Df, Dm;
    local vector  ScreenPosition, WorldLocation, PawnDirection, CameraLocation;
    local rotator CameraRotation;

    Dm = 1600.0;    // distance maximum
    Df = Dm * 0.66; // distance fallout

    // Get world location for icon placement.
    WorldLocation = P.GetBoneCoords(P.HeadBone).Origin + vect(0.0, 0.0, 32.0);

    // Get camera location and rotation, how handy!
    C.GetCameraLocation(CameraLocation, CameraRotation);

    // Get unnormalized direction from the player's eye to the world location
    PawnDirection = WorldLocation - CameraLocation;

    // Ooh, distance.
    D = VSize(PawnDirection);

    // Too far away?  Don't bother.
    if (D > Dm)
    {
        return;
    }

    // Normalize pawn direction now for use
    PawnDirection = Normal(PawnDirection);

    // Ensure we're not drawing icons from players behind us
    if (Acos(PawnDirection dot vector(CameraRotation)) > 1.5705)
    {
        return;
    }

    ScreenPosition = C.WorldToScreen(WorldLocation);

    Alpha = 255;

    if (D > Df)
    {
        Alpha -= byte(((D - Df) / (Dm - Df)) * 255.0);
    }

    VoiceIcon.PosX = ScreenPosition.X / C.ClipX;
    VoiceIcon.PosY = ScreenPosition.Y / C.ClipY;

    // If we can't see the icon from our current location, make it smaller and lighter
    if (!FastTrace(WorldLocation, CameraLocation))
    {
        VoiceIcon.Scale = 0.5;
        VoiceIcon.Tints[0].A = Alpha / 2;
    }
    else
    {
        VoiceIcon.Scale = 0.5;
        VoiceIcon.Tints[0].A = Alpha;
    }

    DrawSpriteWidget(C, VoiceIcon);
}

// For disabling death messages from being displayed - Colin
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

    // Removes expired obituaries
    for (i = 0; i < DHObituaries.Length; ++i)
    {
        if (Level.TimeSeconds > DHObituaries[i].EndOfLife)
        {
            DHObituaries.Remove(i--, 1);
        }
    }

    Scale = C.ClipX / 1600.0;

    C.Font = GetConsoleFont(C);

    Y = 8.0 * Scale;

    // Offset death msgs if we're displaying a hint
    if (bDrawHint)
    {
        Y += 2.0 * Y + (HintCoords.Y + HintCoords.YL) * C.ClipY;
    }

    for (i = 0; i < DHObituaries.Length; ++i)
    {
        O = DHObituaries[i];

        TimeOfDeath = O.EndOfLife - ObituaryLifeSpan;
        FadeInBeginTime = TimeOfDeath + ObituaryDelayTime;
        FadeInEndTime = FadeInBeginTime + ObituaryFadeInTime;
        FadeOutBeginTime = O.EndOfLife - ObituaryFadeInTime;

        //Death message delay and fade in - Basnett, 2011
        if (Level.TimeSeconds < FadeInBeginTime)
        {
            continue;
        }

        Alpha = 255;

        if (Level.TimeSeconds > FadeInBeginTime && Level.TimeSeconds < FadeInEndTime)
        {
            Alpha = Byte(((Level.TimeSeconds - FadeInBeginTime) / ObituaryFadeInTime) * 255.0);
        }
        else if (Level.TimeSeconds > FadeOutBeginTime)
        {
            Alpha = Byte(Abs(255.0 - (((Level.TimeSeconds - FadeOutBeginTime) / ObituaryFadeInTime) * 255.0)));
        }

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
    }
}

simulated function DrawCaptureBar(Canvas Canvas)
{
    local ROGameReplicationInfo GRI;
    local DHPawn                P;
    local ROVehicle             Veh;
    local ROVehicleWeaponPawn   WpnPwn;
    local int    Team;
    local byte   CurrentCapArea, CurrentCapProgress, CurrentCapAxisCappers, CurrentCapAlliesCappers, CurrentCapRequiredCappers;
    local float  AxisProgress, AlliesProgress, AttackersProgress, AttackersRatio, DefendersProgress, DefendersRatio, XL, YL, YPos;
    local string s;

    if (!bSetColour)
    {
        SetAlliedColour();
    }

    bDrawingCaptureBar = false;

    // Don't draw if we have no associated pawn!
    if (PawnOwner == none)
    {
        return;
    }

    // Get capture info from associated pawn
    P = DHPawn(PawnOwner);

    if (P != none)
    {
        CurrentCapArea = (P.CurrentCapArea & 0X0F);
        CurrentCapProgress = P.CurrentCapProgress;
        CurrentCapAxisCappers = P.CurrentCapAxisCappers;
        CurrentCapAlliesCappers = P.CurrentCapAlliesCappers;
        CurrentCapRequiredCappers = (P.CurrentCapArea >> 4);
    }
    else
    {
        // Not a ROPawn, check if current pawn is a vehicle
        Veh = ROVehicle(PawnOwner);

        if (Veh != none)
        {
            CurrentCapArea = (Veh.CurrentCapArea & 0X0F);
            CurrentCapProgress = Veh.CurrentCapProgress;
            CurrentCapAxisCappers = Veh.CurrentCapAxisCappers;
            CurrentCapAlliesCappers = Veh.CurrentCapAlliesCappers;
            CurrentCapRequiredCappers = (Veh.CurrentCapArea >> 4);
        }
        else
        {
            // Not a ROVehicle, check if current pawn is a ROVehicleWeaponPawn
            WpnPwn = ROVehicleWeaponPawn(PawnOwner);

            if (WpnPwn != none)
            {
                CurrentCapArea = (WpnPwn.CurrentCapArea & 0X0F);
                CurrentCapProgress = WpnPwn.CurrentCapProgress;
                CurrentCapAxisCappers = WpnPwn.CurrentCapAxisCappers;
                CurrentCapAlliesCappers = WpnPwn.CurrentCapAlliesCappers;
                CurrentCapRequiredCappers = (WpnPwn.CurrentCapArea >> 4);
            }
            else
            {
                // Unsupported pawn type, return.
                return;
            }
        }
    }

    // Don't render if we're not in a capture zone
    if (CurrentCapArea == 15 && CurrentCapRequiredCappers == 15)
    {
        return;
    }

    // Get GRI
    GRI = ROGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (GRI == none)
    {
        return; // Can't draw without a GRI!
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
        if (GRI.Objectives[CurrentCapArea].ObjState == NEUTRAL_TEAM_INDEX)
        {
            AlliesProgress = 0.0;
            AxisProgress = 0.0;
        }
        else if (GRI.Objectives[CurrentCapArea].ObjState == AXIS_TEAM_INDEX)
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
        AlliesProgress = Float(CurrentCapProgress - 100) / 100.0;

        if (GRI.Objectives[CurrentCapArea].ObjState != NEUTRAL_TEAM_INDEX)
        {
            AxisProgress = 1.0 - AlliesProgress;
        }
    }
    else
    {
        AxisProgress = Float(CurrentCapProgress) / 100.0;

        if (GRI.Objectives[CurrentCapArea].ObjState != NEUTRAL_TEAM_INDEX)
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
        CaptureBarIcons[0].WidgetTexture = CaptureBarTeamIcons[AXIS_TEAM_INDEX];
        CaptureBarIcons[1].WidgetTexture = CaptureBarTeamIcons[ALLIES_TEAM_INDEX];

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
        CaptureBarIcons[0].WidgetTexture = CaptureBarTeamIcons[ALLIES_TEAM_INDEX];
        CaptureBarIcons[1].WidgetTexture = CaptureBarTeamIcons[AXIS_TEAM_INDEX];

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

    // Draw everything.
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

    // Draw the objective name
    YPos = Canvas.ClipY * CaptureBarBackground.PosY - (CaptureBarBackground.TextureCoords.Y2 + 1.0 + 4.0) * CaptureBarBackground.TextureScale * HudScale * ResScaleY;
    s = GRI.Objectives[CurrentCapArea].ObjName;

    // Add a display for the number of cappers in vs the amount needed to capture
    if (CurrentCapRequiredCappers > 1)
    {
        // Displayed when the cap is neutral, the other team completely owns the cap, or there are enemy capturers
        if (Team == 0 && (GRI.Objectives[CurrentCapArea].ObjState == 2 || AxisProgress != 1.0 || CurrentCapAlliesCappers != 0))
        {
            if (CurrentCapAxisCappers < CurrentCapRequiredCappers)
            {
                CaptureBarAttacker.Tints[TeamIndex].A /= 2;
                CaptureBarDefender.Tints[TeamIndex].A /= 2;
            }

            s @= "(" $ CurrentCapAxisCappers @ "/" @ CurrentCapRequiredCappers $ ")";
        }
        else if (Team == 1 && (GRI.Objectives[CurrentCapArea].ObjState == 2 || AlliesProgress != 1.0 || CurrentCapAxisCappers != 0))
        {
            if (CurrentCapAlliesCappers < CurrentCapRequiredCappers)
            {
                CaptureBarAttacker.Tints[TeamIndex].A /= 2;
                CaptureBarDefender.Tints[TeamIndex].A /= 2;
            }

            s @= "(" $ CurrentCapAlliesCappers @ "/" @ CurrentCapRequiredCappers $ ")";
        }
    }

    Canvas.Font = GetConsoleFont(Canvas);
    Canvas.TextSize(s, XL, YL);
    Canvas.DrawColor = WhiteColor;
    Canvas.SetPos(Canvas.ClipX * CaptureBarBackground.PosX - XL / 2.0, YPos - YL);
    Canvas.DrawText(s);

    // Add signal so that vehicle passenger list knows to shift text up
    bDrawingCaptureBar = true;
}

// Modified to fix a bug that spams thousands of "accessed none" errors to log, if there is a missing objective number in the array
simulated function UpdateMapIconLabelCoords(FloatBox LabelCoords, ROGameReplicationInfo GRI, int CurrentObj)
{
    local  int    i, Count;
    local  float  NewY;

    // Do not update label coords if it's disabled in the objective
    if (GRI.Objectives[CurrentObj].bDoNotUseLabelShiftingOnSituationMap)
    {
        GRI.Objectives[CurrentObj].LabelCoords = LabelCoords;

        return;
    }

    if (CurrentObj == 0)
    {
        // Set label position to be same as tested position
        GRI.Objectives[0].LabelCoords = LabelCoords;

        return;
    }

    for (i = 0; i < CurrentObj; ++i)
    {
        if (GRI.Objectives[i] == none) // Matt: added to avoid spamming "accessed none" errors
        {
            continue;
        }

        // Check if there's overlap in the X axis
        if (!(LabelCoords.X2 <= GRI.Objectives[i].LabelCoords.X1 || LabelCoords.X1 >= GRI.Objectives[i].LabelCoords.X2))
        {
            // There's overlap! Check if there's overlap in the Y axis.
            if (!(LabelCoords.Y2 <= GRI.Objectives[i].LabelCoords.Y1 || LabelCoords.Y1 >= GRI.Objectives[i].LabelCoords.Y2))
            {
                // There's overlap on both axis: the label overlaps. Update the position of the label.
                NewY = GRI.Objectives[i].LabelCoords.Y2 - (LabelCoords.Y2 - LabelCoords.Y1) * 0.0;
                LabelCoords.Y2 = NewY + LabelCoords.Y2 - LabelCoords.Y1;
                LabelCoords.Y1 = NewY;

                i = -1; // this is to force re-checking of all possible overlaps to ensure that no other label overlaps with this

                // Safety
                Count++;

                if (Count > CurrentObj * 5)
                {
                    break;
                }
            }
        }

    }

    // Set new label position
    GRI.Objectives[CurrentObj].LabelCoords = LabelCoords;
}

// Matt: modified so if player is in a vehicle, the keybinds to GrowHUD & ShrinkHUD will call same named functions in the vehicle classes
// When player is in a vehicle these functions do nothing to the HUD, but they can be used to add useful custom functionality to vehicles, especially as keys are -/+ by default
exec function GrowHUD()
{
    if (PawnOwner != none && PawnOwner.IsA('Vehicle'))
    {
        if (PawnOwner.IsA('DHTreadCraft'))
        {
            DHTreadCraft(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DHWheeledVehicle'))
        {
            DHWheeledVehicle(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DHTankCannonPawn'))
        {
            DHTankCannonPawn(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DHMountedTankMGPawn'))
        {
            DHMountedTankMGPawn(PawnOwner).GrowHUD();
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
        if (PawnOwner.IsA('DHTreadCraft'))
        {
            DHTreadCraft(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DHWheeledVehicle'))
        {
            DHWheeledVehicle(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DHTankCannonPawn'))
        {
            DHTankCannonPawn(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DHMountedTankMGPawn'))
        {
            DHMountedTankMGPawn(PawnOwner).ShrinkHUD();
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
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local float Time, strX, strY, X, Y, Scale;
    local string S;
    local DHPlayer PC;
    local float SmallH, NameWidth;
    local float XL;
    local DHSpawnPoint SP;
    local class<Vehicle> SVC;

    // Draw fade effects
    C.Style = ERenderStyle.STY_Alpha;

    DrawFadeEffect(C);

    scale = C.ClipX / 1600.0;

    PC = DHPlayer(PlayerOwner);

    if (PC != none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    }

    if (GRI != none)
    {
        // Update round timer
        if (!GRI.bMatchHasBegun)
        {
            CurrentTime = GRI.RoundStartTime + GRI.PreStartTime - GRI.ElapsedTime;
        }
        else
        {
            CurrentTime = GRI.RoundStartTime + GRI.RoundDuration - GRI.ElapsedTime;
        }

        S = default.TimeRemainingText $ GetTimeString(CurrentTime);

        X = 8 * Scale;
        Y = 8 * Scale;

        C.DrawColor = WhiteColor;
        C.Font = GetConsoleFont(C);
        C.TextSize(S, strX, strY);
        C.SetPos(X, Y);
        C.DrawTextClipped(S);

        S = "";

        if (PRI == none || PRI.Team == none || PRI.bIsSpectator)
        {
            // Press ESC to join a team
            S = default.RedeployText[4];
        }
        else if (GRI.bMatchHasBegun &&
                 GRI.bReinforcementsComing[PRI.Team.TeamIndex] == 1)
        {
            Time = Max(PC.LastKilledTime + PC.SpawnTime - GRI.ElapsedTime, 0);

            if (PC.VehiclePoolIndex != 255 && PC.SpawnPointIndex != 255)
            {
                //You will deploy as a {0} driving a {3} at {1} in {2} | Press ESC to change
                S = default.RedeployText[1];
                S = Repl(S, "{3}", GRI.GetVehiclePoolClass(PC.VehiclePoolIndex).default.VehicleNameString);
                S = Repl(S, "{1}", GRI.GetSpawnPoint(PC.SpawnPointIndex).SpawnPointName);
            }
            else if (PC.SpawnPointIndex != 255)
            {
                SP = GRI.GetSpawnPoint(PC.SpawnPointIndex);

                if (SP != none)
                {
                    //You will deploy as a {0} at {1} in {2} | Press ESC to change
                    S = Repl(default.RedeployText[0], "{1}", SP.SpawnPointName);
                }
                else
                {
                    //Press ESC to select a spawn point
                    S = default.RedeployText[3];
                }
            }
            else if (PC.SpawnVehicleIndex != 255)
            {
                SVC = GRI.GetSpawnVehicleClass(PC.SpawnVehicleIndex);

                if (SVC != none)
                {
                    //You will deploy as a {0} at a {1} in {2} | Press ESC to change
                    S = Repl(default.RedeployText[5], "{1}", SVC.default.VehicleNameString);
                }
                else
                {
                    //Press ESC to select a spawn point
                    S = default.RedeployText[3];
                }
            }
            else
            {
                //Press ESC to select a spawn point
                S = default.RedeployText[3];
            }

            if (PC.bUseNativeRoleNames)
            {
                S = Repl(S, "{0}", PRI.RoleInfo.AltName);
            }
            else
            {
                S = Repl(S, "{0}", PRI.RoleInfo.MyName);
            }

            S = Repl(S, "{2}", GetTimeString(Time));
        }

        Y += 4 * scale + strY;

        C.SetPos(X, Y);
        C.DrawTextClipped(S);
    }

    if (PlayerOwner.ViewTarget != PlayerOwner.Pawn && PawnOwner != none && PawnOwner.PlayerReplicationInfo != none)
    {
        S = ViewingText $ PawnOwner.PlayerReplicationInfo.PlayerName;

        C.DrawColor = WhiteColor;
        C.Font = GetConsoleFont(C);
        C.TextSize(S, strX, strY);
        C.SetPos(C.ClipX / 2 - strX / 2, C.ClipY - 8 * scale - strY);
        C.DrawTextClipped(S);
    }

    // Rough spectate hud stuff. TODO: Refine this so its not so plane
    if (PC != none)
    {
        S = PC.GetSpecModeDescription();
        C.DrawColor = WhiteColor;
        C.Font = GetLargeMenuFont(C);

        X = C.ClipX * 0.5;
        Y = C.ClipY * 0.1;

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2, Y  - strY);
        C.DrawTextClipped(S);

        // Draw line 1
        S = SpectateInstructionText1;
        C.Font = GetConsoleFont(C);

        X = C.ClipX * 0.5;
        Y = C.ClipY * 0.9;

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2, Y  - strY);
        C.DrawTextClipped(S);

        // Draw line 2
        S = SpectateInstructionText2;
        X = C.ClipX * 0.5;
        Y += strY + (3 * scale);

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2, Y  - strY);
        C.DrawTextClipped(S);

        // Draw line 3
        S = SpectateInstructionText3;
        X = C.ClipX * 0.5;
        Y += strY + (3 * scale);

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2, Y  - strY);
        C.DrawTextClipped(S);

        // Draw line 4
        S = SpectateInstructionText4;
        X = C.ClipX * 0.5;
        Y += strY + (3 * scale);

        C.TextSize(S, strX, strY);
        C.SetPos(X - strX / 2, Y  - strY);
        C.DrawTextClipped(S);
    }

    // Draw the players name large if thier are viewing someone else in first person
    if ((PawnOwner != none) && (PawnOwner != PlayerOwner.Pawn)
        && (PawnOwner.PlayerReplicationInfo != none) && !PlayerOwner.bBehindView)
    {
        // draw viewed player name
        C.Font = GetMediumFontFor(C);
        C.SetDrawColor(255,255,0,255);
        C.StrLen(PawnOwner.PlayerReplicationInfo.PlayerName,NameWidth,SmallH);
        NameWidth = FMax(NameWidth, 0.15 * C.ClipX);
        if (C.ClipX >= 640)
        {
            C.Font = GetConsoleFont(C);
            C.StrLen("W",XL,SmallH);
            C.SetPos(79*C.ClipX/80 - NameWidth,C.ClipY * 0.68);
            C.DrawText(NowViewing,false);
        }

        C.Font = GetMediumFontFor(C);
        C.SetPos(79*C.ClipX/80 - NameWidth,C.ClipY * 0.68 + SmallH);
        C.DrawText(PawnOwner.PlayerReplicationInfo.PlayerName,false);
    }

    // Draw hints
    if (bDrawHint)
        DrawHint(C);

    DisplayLocalMessages(C);
}

// Modified to make objective title's smaller on the overview
function DrawIconOnMap(Canvas C, AbsoluteCoordsInfo levelCoords, SpriteWidget icon, float myMapScale, vector location, vector MapCenter, optional int flashMode, optional string title, optional ROGameReplicationInfo GRI, optional int objective_index)
{
    local vector HUDLocation;
    local float XL, YL, YL_one, OldFontXScale, OldFontYScale;
    local SpriteWidget myIcon;
    local FloatBox label_coords;

    // Calculate proper position
    HUDLocation = location - MapCenter;
    HUDLocation.Z = 0;
    HUDLocation = GetAdjustedHudLocation(HUDLocation);

    myIcon = icon;

    myIcon.PosX = HUDLocation.X / myMapScale + 0.5;
    myIcon.PosY = HUDLocation.Y / myMapScale + 0.5;

    // Bound the values between 0 and 1
    myIcon.PosX = fmax(0.0, fmin(1.0, myIcon.PosX));
    myIcon.PosY = fmax(0.0, fmin(1.0, myIcon.PosY));

    // Set flashing texture if needed

    if (flashMode != 0)
    {
        if (flashMode == 2)
            myIcon.WidgetTexture = MapIconsFlash;
        else if (flashMode == 3)
            myIcon.WidgetTexture = MapIconsFastFlash;
        else if (flashMode == 4)
            myIcon.WidgetTexture = MapIconsAltFlash;
        else if (flashMode == 5)
            myIcon.WidgetTexture = MapIconsAltFastFlash;

        //else if (flashMode == 1)
        //  myIcon.WidgetTexture = icon.WidgetTexture; // not needed
    }

    // Draw icon!
    DrawSpriteWidgetClipped(C, myIcon, levelCoords, true, XL, YL, true);

    if (title != "" && !GRI.Objectives[objective_index].bDoNotDisplayTitleOnSituationMap)
    {
        // Setup text info
        MapTexts.text = title;
        MapTexts.PosX = myIcon.PosX;
        MapTexts.PosY = myIcon.PosY;
        MapTexts.Tints[TeamIndex].A = myIcon.Tints[TeamIndex].A;
        MapTexts.OffsetY = YL * 0.3;

        // Fake render to get desired label pos
        DrawTextWidgetClipped(C, MapTexts, levelCoords, XL, YL, YL_one, true);

        // Update objective floatbox info with desired coords
        label_coords.X1 = levelCoords.width * MapTexts.PosX - XL/2;
        label_coords.Y1 = levelCoords.height * MapTexts.PosY;
        label_coords.X2 = label_coords.X1 + XL;
        label_coords.Y2 = label_coords.Y1 + YL;

        // Iterate through objectives list and check if we should offset label
        UpdateMapIconLabelCoords(label_coords, GRI, objective_index);

        // Update Y offset
        MapTexts.OffsetY += GRI.Objectives[objective_index].LabelCoords.Y1 - label_coords.Y1;

        // Hack to make the text smaller on the overview for objectives
        OldFontXScale = C.FontScaleX;
        OldFontYScale = C.FontScaleY;
        C.FontScaleX = 0.66;
        C.FontScaleY = 0.66;

        // Draw text
        DrawTextWidgetClipped(C, MapTexts, levelCoords);

        C.FontScaleX = OldFontXScale;
        C.FontScaleY = OldFontYScale;
    }
}

// Modified to make fade to black work with lower hud opacity values
simulated function DrawFadeToBlack(Canvas Canvas)
{
    local float alpha;

    if (FadeToBlackTime ~= 0)
        alpha = 0.0;
    else
        alpha = (FadeToBlackTime - Level.TimeSeconds + FadeToBlackStartTime) / FadeToBlackTime;

    if (alpha <= 0)
        alpha = 0.0;
    else if (alpha > 1)
        alpha = 1.0;

    if (!bFadeToBlackInvert)
        alpha = 1.0 - alpha;

    if (alpha ~= 0)
    {
        bFadeToBlack = false;
        return;
    }

    Canvas.SetPos(0, 0);
    Canvas.Style = ERenderStyle.STY_Alpha;
    Canvas.DrawColor = BlackColor;
    Canvas.DrawColor.A = alpha * 255;
    Canvas.ColorModulate.W = 1.0;
    Canvas.DrawTile(texture'Engine.WhiteTexture', Canvas.ClipX, Canvas.ClipY, 0, 0, 4, 4);
    Canvas.ColorModulate.W = HudOpacity/255;
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
    MapLevelOverlay=(RenderStyle=STY_Alpha,TextureCoords=(X2=511,Y2=511),TextureScale=1.0,ScaleMode=SM_Left,scale=1.0,Tints[0]=(B=255,G=255,R=255,A=125),Tints[1]=(B=255,G=255,R=255,A=255))
    MapScaleText=(RenderStyle=STY_Alpha,DrawPivot=DP_LowerRight,PosX=1.0,PosY=0.0375,WrapHeight=1.0,Tints[0]=(B=255,G=255,R=255,A=128),Tints[1]=(B=255,G=255,R=255,A=128))
    VehicleAltAmmoReloadIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.2,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Up,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=0,B=0,A=128),Tints[1]=(R=255,G=0,B=0,A=128))
    VehicleMGAmmoReloadIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.3,DrawPivot=DP_LowerLeft,PosX=0.15,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Up,Scale=0.75,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=0,B=0,A=128),Tints[1]=(R=255,G=0,B=0,A=128))
    MapIconCarriedRadio=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X1=64,Y1=192,X2=127,Y2=255),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    CanMantleIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.CanMantle',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=127),TextureScale=0.8,DrawPivot=DP_LowerMiddle,PosX=0.55,PosY=0.98,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    CanCutWireIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.CanCut',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=127),TextureScale=0.8,DrawPivot=DP_LowerMiddle,PosX=0.55,PosY=0.98,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    VoiceIcon=(WidgetTexture=texture'DH_InterfaceArt_tex.Communication.Voice',RenderStyle=STY_Alpha,TextureCoords=(X2=63,Y2=63),TextureScale=0.5,DrawPivot=DP_MiddleMiddle,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    MapIconMortarTarget=(WidgetTexture=texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X2=63,Y2=64),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,A=255),Tints[1]=(R=255,A=255))
    MapIconMortarHit=(WidgetTexture=texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(Y1=64,X2=63,Y2=127),TextureScale=0.05,DrawPivot=DP_LowerMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    VehicleAmmoTypeText=(Text="",PosX=0.24,PosY=1.0,WrapWidth=0,WrapHeight=1,OffsetX=8,OffsetY=-4,DrawPivot=DP_LowerLeft,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255),bDrawShadow=false)
    VehicleAltAmmoIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.2,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Left,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    VehicleAltAmmoAmount=(TextureScale=0.2,MinDigitCount=1,DrawPivot=DP_LowerLeft,PosX=0.30,PosY=1.0,OffsetX=135,OffsetY=-40,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    VehicleAltAmmoOccupantsTextOffset=-35
    VehicleOccupantsTextOffset=0.40
    LegendCarriedArtilleryRadioText="Artillery Radioman"
    NeedReloadText="Needs reloading"
    CanReloadText="Press %THROWMGAMMO% to assist reload"
    PlayerNameFontSize=4
    bShowDeathMessages=true
    bShowVoiceIcon=true
    ObituaryFadeInTime=0.5
    ObituaryDelayTime=5.0
    LegendArtilleryRadioText="Artillery Radio"
    SideColors(0)=(B=80,G=80,R=200)
    SideColors(1)=(B=75,G=150,R=80)
    ResupplyZoneNormalPlayerIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    ResupplyZoneNormalVehicleIcon=(WidgetTexture=texture'DH_GUI_Tex.GUI.overheadmap_Icons')
    ResupplyZoneResupplyingPlayerIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash')
    ResupplyZoneResupplyingVehicleIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash')
    NationHealthFigures(1)=texture'DH_GUI_Tex.GUI.US_player'
    NationHealthFiguresBackground(1)=texture'DH_GUI_Tex.GUI.US_player_background'
    NationHealthFiguresStamina(1)=texture'DH_GUI_Tex.GUI.US_player_Stamina'
    NationHealthFiguresStaminaCritical(1)=FinalBlend'DH_GUI_Tex.GUI.US_player_Stamina_critical'
    PlayerArrowTexture=FinalBlend'DH_GUI_Tex.GUI.PlayerIcon_final'
    ObituaryLifeSpan=8.5
    MapIconsFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_Icons_flashing'
    MapIconsFastFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash'
    MapIconsAltFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_alt_flashing'
    MapIconsAltFastFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_alt_fast_flash'
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
    CaptureBarTeamColors(0)=(B=30,G=43,R=213)
    CaptureBarTeamColors(1)=(B=35,G=150,R=40)
    VOICE_ICON_DIST_MAX = 2624.672119
    TeamMessagePrefix="*TEAM* "

    RedeployText(0)="You will deploy as a {0} at {1} in {2} | Press ESC to change"
    RedeployText(1)="You will deploy as a {0} driving a {3} at {1} in {2} | Press ESC to change"
    RedeployText(3)="Press ESC to select a spawn point"
    RedeployText(4)="Press ESC to join a team"
    RedeployText(5)="You will deploy as a {0} at a {1} in {2} | Press ESC to change"

    ReinforcementText="Redeploy in: "
}
