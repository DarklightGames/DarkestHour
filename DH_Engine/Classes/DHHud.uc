//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHHud extends ROHud;

var(ROHud)  SpriteWidget    VehicleAltAmmoReloadIcon; // ammo reload icon for a coax MG, so reload progress can be shown on HUD like a tank cannon reload
var(ROHud)  SpriteWidget    VehicleMGAmmoReloadIcon;  // ammo reload icon for a vehicle mounted MG position
var(DHHud)  SpriteWidget    MapIconCarriedRadio;
var(DHHud)  SpriteWidget    CanMantleIcon;
var(DHHud)  SpriteWidget    VoiceIcon;
var(DHHud)  SpriteWidget    MapIconMortarTarget;
var(DHHud)  SpriteWidget    MapIconMortarHit;

var     localized   string      LegendCarriedArtilleryRadioText;

var     localized   string      NeedReloadText;
var     localized   string      CanReloadText;

var     globalconfig    int     PlayerNameFontSize;     // The size of the name you see when you mouseover a player
var     globalconfig    bool    bSimpleColours;    // For colourblind setting, i.e. Red and Blue only
var     globalconfig    bool    bShowDeathMessages; //Whether or not to show the death messages.
var     globalconfig    bool    bShowVoiceIcon; //Whether or not to show the voice icon above player's heads.

var     int                     AlliedNationID;   // US = 0, Britain = 1, Canada = 2

var     bool                    bSetColour;        // Whether we've set the Allied colour yet

//For some added suspense.
var     float                   ObituaryFadeInTime;
var     float                   ObituaryDelayTime;

var     Obituary                DHObituaries[8];

var const float VOICE_ICON_DIST_MAX;


#exec OBJ LOAD FILE=..\Textures\DH_GUI_Tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_Weapon_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx


simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.overheadmap_Icons');
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.AlliedStar');
    Level.AddPrecacheMaterial(Material'DH_GUI_Tex.GUI.GerCross');

    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_head');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_torso');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Pelvis');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Lupperleg');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Rupperleg');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Lupperarm');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Rupperarm');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Llowerleg');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Rlowerleg');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Llowerarm');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Rlowerarm');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Lhand');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Rhand');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Lfoot');
    Level.AddPrecacheMaterial(Texture'DH_GUI_Tex.Player_hits.US_hit_Rfoot');

    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_head');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_torso');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Pelvis');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Lupperleg');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Rupperleg');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Lupperarm');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Rupperarm');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Llowerleg');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Rlowerleg');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Llowerarm');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Rlowerarm');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Lhand');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Rhand');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Lfoot');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Player_hits.ger_hit_Rfoot');

    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.HUD.MGDeploy');
    //Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.HUD.CanMantle');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.HUD.Compass2_main');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.HUD.TexRotator0');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.OverheadMap.overheadmap_background');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.HUD.VUMeter');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Cursors.Pointer');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.HUD.Needle_rot');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Menu.SectionHeader_captionbar');

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

    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.throttle_background2');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.throttle_background2_bottom');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.throttle_background');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.throttle_main');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.throttle_lever');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.Ger_RPM');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.Rus_RPM');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.Ger_Speedometer');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.Tank_Hud.Rus_Speedometer');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.Tank_Hud.Ger_needle_rot');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.Tank_Hud.Rus_needle_rot');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.Tank_Hud.Ger_needle_rpm_rot');
    Level.AddPrecacheMaterial(TexRotator'InterfaceArt_tex.Tank_Hud.Rus_needle_rpm_rot');

    // Damage icons
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.artkill');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.satchel');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.Strike');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.Generic');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.b792mm');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.buttsmack');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.knife');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.b762mm');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.rusgrenade');
    Level.AddPrecacheMaterial(Texture'InterfaceArt2_tex.deathicons.sniperkill');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.b9mm');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.germgrenade');
    Level.AddPrecacheMaterial(Texture'InterfaceArt2_tex.deathicons.faustkill');
    Level.AddPrecacheMaterial(Texture'InterfaceArt_tex.deathicons.mine');
    Level.AddPrecacheMaterial(Texture'DH_InterfaceArt_tex.deathicons.backblastkill');
    Level.AddPrecacheMaterial(Texture'DH_InterfaceArt_tex.deathicons.piatkill');
    Level.AddPrecacheMaterial(Texture'DH_InterfaceArt_tex.deathicons.schreckkill');
    Level.AddPrecacheMaterial(Texture'DH_InterfaceArt_tex.deathicons.zookakill');
    Level.AddPrecacheMaterial(Texture'DH_InterfaceArt_tex.deathicons.canisterkill');
    Level.AddPrecacheMaterial(Texture'DH_InterfaceArt_tex.deathicons.ATGunKill');
    Level.AddPrecacheMaterial(Texture'DH_InterfaceArt_tex.deathicons.VehicleFireKill');
    Level.AddPrecacheMaterial(Texture'DH_InterfaceArt_tex.deathicons.PlayerFireKill');
}


// This is potentially called from 5 different functions, as GameReplicationInfo isn't replicating until _after_ PostNetBeginPlay()
simulated function SetAlliedColour()
{
    local DHGameReplicationInfo DHGRI;

    DHGRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (DHGRI != none)
    {
         if (bSimpleColours || DHGRI.AlliedNationID == 1)
         {
             CaptureBarTeamColors[1].R=64;
             CaptureBarTeamColors[1].G=80;
             CaptureBarTeamColors[1].B=230;
             SideColors[1].R=64;
             SideColors[1].G=140;
             SideColors[1].B=190;
             AlliedNationID = 1;
         }
         else if (DHGRI.AlliedNationID == 2)
         {
             CaptureBarTeamColors[1].R=210;
             CaptureBarTeamColors[1].G=190;
             CaptureBarTeamColors[1].B=0;
             SideColors[1].R=160;
             SideColors[1].G=155;
             SideColors[1].B=20;
             AlliedNationID = 2;
         }
         else
         {
             CaptureBarTeamColors[1] = default.CaptureBarTeamColors[1];
             SideColors[1] = default.SideColors[1];
             AlliedNationID = default.AlliedNationID;
         }

         if (bSimpleColours)
         {
            CaptureBarTeamColors[0].R = 0;
            CaptureBarTeamColors[0].G = 0;
            CaptureBarTeamColors[0].B = 0;  //Black!
         }

         Scoreboard.bActorShadows = bSimpleColours; // --- Filthy hack to cheat our way around messed up class hierarchy
         bSetColour = true;
    }
}

function DrawCustomBeacon(Canvas C, Pawn P, float ScreenLocX, float ScreenLocY)
{
    local float XL,YL;
    local PlayerReplicationInfo PRI;
    local int PlayerDist;
//  local Actor Hit;

    Log("Are we even getting here?");

    PRI = P.PlayerReplicationInfo;

    if ((PRI == none) || (PRI.Team == none))
        return;

    if ((PlayerOwner == none) || (PlayerOwner.PlayerReplicationInfo == none)
        || (PlayerOwner.PlayerReplicationInfo.Team == none)
        || (PlayerOwner.Pawn == none))
    {
        return;
    }

    if ((PlayerOwner.PlayerReplicationInfo.Team.TeamIndex != PRI.Team.TeamIndex))
        return;

    PlayerDist = VSize(P.Location - PlayerOwner.Pawn.Location);

    if (PlayerDist > 1600)
    {
        return;
    }

    if (!FastTrace(P.Location, PlayerOwner.Pawn.Location))
    {
            Log("Fasttrace from "$P$" to "$PlayerOwner.Pawn$" Failed ");
        return;
    }

    if (PRI.Team != none)
        C.DrawColor = GetTeamColour(PRI.Team.TeamIndex);
    else
        C.DrawColor = GetTeamColour(0);

    C.Font = GetPlayerNameFont(C);
    //C.TextSize(PRI.PlayerName, strX, strY);
    C.StrLen(PRI.PlayerName, XL, YL);
    C.SetPos(ScreenLocX - 0.5*XL , ScreenLocY - YL);
    C.DrawText(PRI.PlayerName, true);

    C.SetPos(ScreenLocX, ScreenLocY);
}


//-----------------------------------------------------------------------------
// Message - Changed message classes
//-----------------------------------------------------------------------------

simulated function Message(PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
    local Class<LocalMessage> MessageClassType;
    local Class<DHStringMessage> DHMessageClassType;

    switch(MsgType)
    {
        case 'Say':
            Msg = PRI.PlayerName$": "$Msg;
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
            DHMessageClassType = class'DHStringMessage';
            break;
    }

    AddDHTextMessage(Msg,DHMessageClassType,PRI);
}

function AddDHTextMessage(string M, class<DHStringMessage> MessageClass, PlayerReplicationInfo PRI)
{
    local int i;

    if (bMessageBeep && MessageClass.default.bBeep)
        PlayerOwner.PlayBeepSound();

    for(i=0; i<ConsoleMessageCount; i++)
    {
        if (TextMessages[i].Text == "")
            break;
    }

    if (i == ConsoleMessageCount)
    {
        for(i=0; i<ConsoleMessageCount-1; i++)
            TextMessages[i] = TextMessages[i+1];
    }

    if (!bSetColour)
    {
       SetAlliedColour();
       //log("Running SAC from AddDHTextMessage");
    }

    TextMessages[i].Text = M;
    TextMessages[i].MessageLife = Level.TimeSeconds + MessageClass.default.LifeTime;
    TextMessages[i].TextColor = MessageClass.static.GetDHConsoleColor(PRI, AlliedNationID, bSimpleColours);
    TextMessages[i].PRI = PRI;
}

//-----------------------------------------------------------------------------
// AddDeathMessage - Adds a death message to the HUD
//-----------------------------------------------------------------------------

function AddDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> DamageType)
{
    local int i;

    if (Victim == none)
        return;

    if (ObituaryCount == arraycount(DHObituaries))
    {
        for (i = 1; i < arraycount(DHObituaries); i++)
            DHObituaries[i - 1] = DHObituaries[i];

        ObituaryCount--;
        DHObituaries[ObituaryCount].KillerName = "";
    }

    if (!bSetColour)
    {
       SetAlliedColour();
       //log("Running SAC from AddDeathMessage");
    }

    if (Killer != none && Killer != Victim)
    {
        DHObituaries[ObituaryCount].KillerName = Killer.PlayerName;
        DHObituaries[ObituaryCount].KillerColor = GetTeamColour(Killer.Team.TeamIndex);
    }

    DHObituaries[ObituaryCount].VictimName = Victim.PlayerName;
    DHObituaries[ObituaryCount].VictimColor = GetTeamColour(Victim.Team.TeamIndex);
    DHObituaries[ObituaryCount].DamageType = DamageType;
    DHObituaries[ObituaryCount].EndOfLife = Level.TimeSeconds + ObituaryLifeSpan;

    // Making the player's name show up in white in the kill list
    if (PlayerOwner != none && Killer != none)
    {
         if (PlayerOwner.PlayerReplicationInfo != none)
          {
              // When the player kills someone
              if (PlayerOwner.PlayerReplicationInfo.PlayerName == Killer.PlayerName)
              {
                   DHObituaries[ObituaryCount].KillerColor = WhiteColor;
              }
          }
    }

    ObituaryCount++;
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
            InitialNumLines = Lines.length;
            Message.DX = TempXL; // Matt: added to fix problem, so Message.DX is always set, even for the 1st pass

            for (i = 0; i < 20; i++)
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

                    for (j = 0; j < Lines.Length; j++)
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

//-----------------------------------------------------------------------------
// GetTeamColour - Returns the appropriate team color
//-----------------------------------------------------------------------------

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
            return default.OverrideConsoleFont;
        default.OverrideConsoleFont = Font(DynamicLoadObject(default.OverrideConsoleFontName, class'Font'));
        if (default.OverrideConsoleFont != none)
            return default.OverrideConsoleFont;
        Log("Warning: HUD couldn't dynamically load font "$default.OverrideConsoleFontName);
        default.OverrideConsoleFontName = "";
    }

    FontSize = default.PlayerNameFontSize;

    if (C.ClipX < 640)
        FontSize++;
    if (C.ClipX < 800)
        FontSize++;
    if (C.ClipX < 1024)
        FontSize++;
    if (C.ClipX < 1280)
        FontSize++;
    if (C.ClipX < 1600)
        FontSize++;
    return LoadFontStatic(Min(8,FontSize));
}

simulated event PostRender(canvas Canvas)
{
    if (!bSetColour)
       SetAlliedColour();

    super.PostRender(Canvas);
}


//-----------------------------------------------------------------------------
// DrawHudPassC - Draw all the widgets here
// Modified to add mantling icon - PsYcH0_Ch!cKeN
//-----------------------------------------------------------------------------

simulated function DrawHudPassC(Canvas C)
{
    local VoiceChatRoom VCR;
    local ROPawn ROP;
    local DHGameReplicationInfo GRI;
    local float Y, XL, YL, alpha;
    local string S;
    local color myColor;
    local AbsoluteCoordsInfo coords;
    local ROWeapon myweapon;

    // Set coordinates to use whole screen
    coords.width = C.ClipX; coords.height = C.ClipY;

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
        DrawSpriteWidget(C, MGDeployIcon);

    // Show Mantling icon if an object can be climbed
    if (PawnOwner != none && DH_Pawn(PawnOwner) != none && DH_Pawn(PawnOwner).bCanMantle)
        DrawSpriteWidget(C, CanMantleIcon);

    // Draw the icon for weapon resting
    if (PawnOwner != none)
    {
        if (PawnOwner.bRestingWeapon)
            DrawSpriteWidget(C, WeaponRestingIcon);
        else if (PawnOwner.bCanRestWeapon)
            DrawSpriteWidget(C, WeaponCanRestIcon);
    }

    // Resupply icon
    if (PawnOwner != none && PawnOwner.bTouchingResupply)
    {
        if (Vehicle(PawnOwner) != none)
        {
            if (Level.TimeSeconds - PawnOwner.LastResupplyTime <=  1.5)
                DrawSpriteWidget(C, ResupplyZoneResupplyingVehicleIcon);
            else
                DrawSpriteWidget(C, ResupplyZoneNormalVehicleIcon);
        }
        else
        {
            if (Level.TimeSeconds - PawnOwner.LastResupplyTime <=  1.5)
                DrawSpriteWidget(C, ResupplyZoneResupplyingPlayerIcon);
            else
                DrawSpriteWidget(C, ResupplyZoneNormalPlayerIcon);
        }
    }

    // Show weapon info
    if (bShowWeaponInfo && PawnOwner != none && PawnOwner.Weapon != none && AmmoIcon.WidgetTexture != none)
    {
        myweapon = ROWeapon(PawnOwner.Weapon);

        if (myweapon != none)
        {
            if (myweapon.bWaitingToBolt || myweapon.AmmoAmount(0) <= 0)
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

            if (myweapon.bHasSelectFire)
            {
                if (myweapon.UsingAutoFire())
                    DrawSpriteWidget(C, AutoFireIcon);
                else
                    DrawSpriteWidget(C, SemiFireIcon);
            }
        }
    }

    DrawCaptureBar(C);

    // Draw Compass
    if (bShowCompass)
        DrawCompass(C);

    // Draw the 'map updated' icon
    if (bShowMapUpdatedIcon)
    {
        alpha = (Level.TimeSeconds - MapUpdatedIconTime) % 2;

        if (alpha < 0.5)
            alpha = 1 - alpha / 0.5;
        else if (alpha < 1)
            alpha = (alpha - 0.5) / 0.5;
        else
            alpha = 1;

        myColor.R = 255;
        myColor.G = 255;
        myColor.B = 255;
        myColor.A = alpha * 255;

        if (myColor.A != 0)
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

            XL = 0; YL = 0; Y = 0;

            if (bShowMapUpdatedText)
            {
                // Check width & height of text label
                S = class'ROTeamGame'.static.ParseLoadingHintNoColor(OpenMapText, PlayerController(Owner));
                C.Font = getSmallMenuFont(C);

                // Draw text
                MapUpdatedText.text = S;
                MapUpdatedText.Tints[0] = myColor; MapUpdatedText.Tints[1] = myColor;
                MapUpdatedText.OffsetY = default.MapUpdatedText.OffsetY * MapUpdatedIcon.TextureScale;
                DrawTextWidgetClipped(C, MapUpdatedText, coords, XL, YL, Y);

                // Offset icon by text height
                MapUpdatedIcon.OffsetY = MapUpdatedText.OffsetY - YL - Y / 2;
            }
            else
            {
                // Offset icon by text height
                MapUpdatedIcon.OffsetY = default.MapUpdatedText.OffsetY * MapUpdatedIcon.TextureScale;
            }


            // Draw icon
            MapUpdatedIcon.Tints[0] = myColor; MapUpdatedIcon.Tints[1] = myColor;
            DrawSpriteWidgetClipped(C, MapUpdatedIcon, coords, true, XL, YL, true, true, true);

            // Check if we should stop showing the icon
            if (Level.TimeSeconds - MapUpdatedIconTime > MaxMapUpdatedIconDisplayTime)
                bShowMapUpdatedIcon = false;
        }
    }

    //if (!bNoEnemyNames)
        DrawPlayerNames(C);

    if ((Level.NetMode == NM_Standalone || GRI.bAllowNetDebug) && bShowRelevancyDebugOverlay)
       DrawNetworkActors(C);

    // portrait
    if ((bShowPortrait || (bShowPortraitVC && Level.TimeSeconds - LastPlayerIDTalkingTime < 2.0)))
    {
        // Start by updating current portrait PRI
        if ((Level.TimeSeconds - LastPlayerIDTalkingTime < 0.1) && (PlayerOwner.GameReplicationInfo != none))
        {
            if ((PortraitPRI == none) || (PortraitPRI.PlayerID != LastPlayerIDTalking))
            {
                if (PortraitPRI == none)
                    PortraitX = 1;
                PortraitPRI = PlayerOwner.GameReplicationInfo.FindPlayerByID(LastPlayerIDTalking);
                if (PortraitPRI != none)
                    PortraitTime = Level.TimeSeconds + 3;
            }
            else
                PortraitTime = Level.TimeSeconds + 0.2;
        }
        else
            LastPlayerIDTalking = 0;

        // Update portrait alpha value (fade in & fade out)
        if (PortraitTime - Level.TimeSeconds > 0)
            PortraitX = FMax(0, PortraitX - 3 * (Level.TimeSeconds - hudLastRenderTime));
        else if (PortraitPRI != none)
        {
            PortraitX = FMin(1, PortraitX + 3 * (Level.TimeSeconds - hudLastRenderTime));
            if (PortraitX == 1)
            {
                //Portrait = none;
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
            PortraitIcon.Tints[TeamIndex].A = 255 * (1 - PortraitX);
            PortraitText[0].Tints[TeamIndex].A = PortraitIcon.Tints[TeamIndex].A;

            XL = 0;
            DrawSpriteWidgetClipped(C, PortraitIcon, coords, true, XL, YL, false, true);

            // Draw first line of text
            PortraitText[0].OffsetX = PortraitIcon.OffsetX * PortraitIcon.TextureScale + XL * 1.1;
            PortraitText[0].text = PortraitPRI.PlayerName;
            C.Font = GetFontSizeIndex(C,-2);
            DrawTextWidgetClipped(C, PortraitText[0], coords);

            // Draw second line of text
            VCR = PlayerOwner.VoiceReplicationInfo.GetChannelAt(PortraitPRI.ActiveChannel);

            if (VCR != none)
                PortraitText[1].text = "(" @ VCR.GetTitle() @ ")";
            else
                PortraitText[1].text = "(?)";
            PortraitText[1].OffsetX = PortraitText[0].OffsetX;

            PortraitText[1].Tints[TeamIndex] = PortraitText[0].Tints[TeamIndex];
            DrawTextWidgetClipped(C, PortraitText[1], coords);

            //Draw the voice icon
            DrawVoiceIcon(C, PortraitPRI);
        }
    }
    if (bShowWeaponInfo && PawnOwner != none && PawnOwner.Weapon != none)
        PawnOwner.Weapon.NewDrawWeaponInfo(C, 0.86 * C.ClipY);

    // Slow, for debugging only
    if (bDebugDriverCollision && class'DH_LevelInfo'.static.DHDebugMode()) // Matt: was 'ROEngine.ROLevelInfo'.static.RODebugMode())
    {
        DrawVehiclePointSphere();
    }

    // Slow, for debugging only
    if (bDebugPlayerCollision && class'DH_LevelInfo'.static.DHDebugMode()) // Matt: was 'ROEngine.ROLevelInfo'.static.RODebugMode())
    {
        DrawPointSphere();
    }
}


//----------------------------------------------------------------------------------------------------------------------------------
// DrawVehicleIcon - draws all the vehicle HUD info, e.g. vehicle icon, passengers, ammo, speed, throttle
// Overridden to handle new system where rider pawns won't exist on clients unless occupied (& generally prevent spammed log errors)
//----------------------------------------------------------------------------------------------------------------------------------
function DrawVehicleIcon(Canvas Canvas, ROVehicle vehicle, optional ROVehicleWeaponPawn passenger)
{
    local  ROTreadCraft           threadCraft;
    local  ROWheeledVehicle       wheeled_vehicle;
    local  ROVehicleWeaponPawn    wpawn;
    local  ROVehicleWeapon        weapon;
    local  ROTankCannon           cannon;
    local  PlayerReplicationInfo  PRI;
    local  AbsoluteCoordsInfo     coords, coords2;
    local  SpriteWidget           widget;
    local  color                  vehicleColor;
    local  rotator                myRot;
    local  int                    i, current, pending;
    local  float                  f, XL, YL, Y_one, myScale, ProportionOfReloadRemaining;
    local  float                  modifiedVehicleOccupantsTextYOffset; // used to offset text vertically when drawing coaxial ammo info
    local  array<string>          lines;

    if (bHideHud)
    {
        return;
    }

    //////////////////////////////////////
    // Draw vehicle icon
    //////////////////////////////////////

    // Figure what the scale is
    myScale = HudScale; // * ResScaleY;

    // Figure where to draw
    coords.PosX = Canvas.ClipX * VehicleIconCoords.X;
    coords.height = Canvas.ClipY * VehicleIconCoords.YL * myScale;
    coords.PosY = Canvas.ClipY * VehicleIconCoords.Y - coords.height;
    coords.width = coords.height;

    // Compute whole-screen coords
    coords2.PosX = 0.0;
    coords2.PosY = 0.0;
    coords2.width = Canvas.ClipX;
    coords2.height = canvas.ClipY;

    // Set initial passenger PosX (shifted if we're drawing ammo info, else it's draw closer to the tank icon)
    VehicleOccupantsText.PosX = default.VehicleOccupantsText.PosX;

    // The IS2 is so frelling huge that it needs to use larger textures
    if (vehicle.bVehicleHudUsesLargeTexture)
    {
        widget = VehicleIconAlt;
    }
    else
    {
        widget = VehicleIcon;
    }

    // Figure what color to draw in
    f = vehicle.Health / vehicle.HealthMax;

    if (f > 0.75)
    {
        vehicleColor = VehicleNormalColor;
    }
    else if (f > 0.35)
    {
        vehicleColor = VehicleDamagedColor;
    }
    else
    {
        vehicleColor = VehicleCriticalColor;
    }

    widget.Tints[0] = vehicleColor;
    widget.Tints[1] = vehicleColor;

    // Draw vehicle icon
    widget.WidgetTexture = vehicle.VehicleHudImage;
    DrawSpriteWidgetClipped(Canvas, widget, coords, true);

    // Draw engine (if needed)
    f = vehicle.EngineHealth / vehicle.default.EngineHealth;

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

        VehicleEngine.PosX = vehicle.VehicleHudEngineX;
        VehicleEngine.PosY = vehicle.VehicleHudEngineY;
        DrawSpriteWidgetClipped(Canvas, VehicleEngine, coords, true);
    }

    // Draw treaded vehicle specific stuff
    threadCraft = ROTreadCraft(vehicle);

    if (threadCraft != none)
    {
        // Update turret references
        if (threadCraft.CannonTurret == none)
        {
            threadCraft.UpdateTurretReferences();
        }

        // Draw threads (if needed)
        if (threadCraft.bLeftTrackDamaged)
        {
            VehicleThreads[0].TextureScale = threadCraft.VehicleHudThreadsScale;
            VehicleThreads[0].PosX = threadCraft.VehicleHudThreadsPosX[0];
            VehicleThreads[0].PosY = threadCraft.VehicleHudThreadsPosY;
            DrawSpriteWidgetClipped(Canvas, VehicleThreads[0], coords, true, XL, YL, false, true);
        }

        if (threadCraft.bRightTrackDamaged)
        {
            VehicleThreads[1].TextureScale = threadCraft.VehicleHudThreadsScale;
            VehicleThreads[1].PosX = threadCraft.VehicleHudThreadsPosX[1];
            VehicleThreads[1].PosY = threadCraft.VehicleHudThreadsPosY;
            DrawSpriteWidgetClipped(Canvas, VehicleThreads[1], coords, true, XL, YL, false, true);
        }

        // Update & draw look turret (if needed)
        if (passenger != none && passenger.IsA('ROTankCannonPawn'))
        {
            threadCraft.VehicleHudTurretLook.Rotation.Yaw = vehicle.Rotation.Yaw - passenger.CustomAim.Yaw;
            widget.WidgetTexture = threadCraft.VehicleHudTurretLook;
            widget.Tints[0].A /= 2;
            widget.Tints[1].A /= 2;
            DrawSpriteWidgetClipped(Canvas, widget, coords, true);
            widget.Tints[0] = vehicleColor;
            widget.Tints[1] = vehicleColor;

            // Draw ammo count since we're a gunner
            if (bShowWeaponInfo)
            {
                // Shift passengers list farther to the right
                VehicleOccupantsText.PosX = VehicleOccupantsTextOffset;

                // Draw icon
                VehicleAmmoIcon.WidgetTexture = passenger.AmmoShellTexture;
                DrawSpriteWidget(Canvas, VehicleAmmoIcon);

                // Draw reload state icon (if needed)
                VehicleAmmoReloadIcon.WidgetTexture = passenger.AmmoShellReloadTexture;
                VehicleAmmoReloadIcon.Scale = passenger.getAmmoReloadState();
                DrawSpriteWidget(Canvas, VehicleAmmoReloadIcon);

                // Draw ammo count
                if (Passenger != none && passenger.Gun != none)
                {
                    VehicleAmmoAmount.Value = passenger.Gun.PrimaryAmmoCount();
                }

                DrawNumericWidget(Canvas, VehicleAmmoAmount, Digits);

                // Draw ammo type
                cannon = ROTankCannon(passenger.Gun);

                if (cannon != none && cannon.bMultipleRoundTypes)
                {
                    // Get ammo types
                    current = cannon.GetRoundsDescription(lines);
                    pending = cannon.GetPendingRoundIndex();

                    VehicleAmmoTypeText.OffsetY = default.VehicleAmmoTypeText.OffsetY * myScale;

                    if (myScale < 0.85)
                    {
                        Canvas.Font = GetConsoleFont(Canvas);
                    }
                    else
                    {
                        Canvas.Font = GetSmallMenuFont(Canvas);
                    }

                    i = (current + 1) % lines.length;

                    while (true)
                    {
                        if (i == pending)
                        {
                            VehicleAmmoTypeText.text = lines[i] $ "<-";
                        }
                        else
                        {
                            VehicleAmmoTypeText.text = lines[i];
                        }

                        if (i == current)
                        {
                            VehicleAmmoTypeText.Tints[TeamIndex].A = 255;
                        }
                        else
                        {
                            VehicleAmmoTypeText.Tints[TeamIndex].A = 128;
                        }

                        DrawTextWidgetClipped(Canvas, VehicleAmmoTypeText, coords2, XL, YL, Y_one);
                        VehicleAmmoTypeText.OffsetY -= YL;

                        i = (i + 1) % lines.length;

                        if (i == (current + 1) % lines.length)
                        {
                            break;
                        }
                    }
                }

                if (cannon != none)
                {
                    // Draw coaxial gun ammo info if needed
                    if (cannon.AltFireProjectileClass != none)
                    {
                        // Draw coaxial gun ammo icon
                        VehicleAltAmmoIcon.WidgetTexture = cannon.hudAltAmmoIcon;
                        DrawSpriteWidget(Canvas, VehicleAltAmmoIcon);

                        // Draw coaxial gun reload state icon (if needed) // Matt: to show reload progress in red, like a tank cannon reload
                        if (DH_ROTankCannonPawn(passenger) != none)
                        {
                            ProportionOfReloadRemaining = DH_ROTankCannonPawn(passenger).GetAltAmmoReloadState();

                            if (ProportionOfReloadRemaining > 0.0)
                            {
                                VehicleAltAmmoReloadIcon.WidgetTexture = DH_ROTankCannonPawn(passenger).AltAmmoReloadTexture;
                                VehicleAltAmmoReloadIcon.Scale = ProportionOfReloadRemaining;
                                DrawSpriteWidget(Canvas, VehicleAltAmmoReloadIcon);
                            }
                        }

                        // Draw coaxial gun ammo ammount
                        VehicleAltAmmoAmount.Value = cannon.getNumMags();
                        DrawNumericWidget(Canvas, VehicleAltAmmoAmount, Digits);

                        // Shift occupants list position to accomodate coaxial gun ammo info
                        modifiedVehicleOccupantsTextYOffset = VehicleAltAmmoOccupantsTextOffset * myScale;
                    }
                }
            }
        }

        // Update & draw turret
        if (threadCraft.CannonTurret != none)
        {
            myRot = rotator(vector(threadCraft.CannonTurret.CurrentAim) >> threadCraft.CannonTurret.Rotation);
            threadCraft.VehicleHudTurret.Rotation.Yaw = vehicle.Rotation.Yaw - myRot.Yaw;
            widget.WidgetTexture = threadCraft.VehicleHudTurret;
            DrawSpriteWidgetClipped(Canvas, widget, coords, true);
        }
    }

    // Draw MG ammo info (if needed)
    if (bShowWeaponInfo && passenger != none && passenger.bIsMountedTankMG)
    {
        weapon = ROVehicleWeapon(passenger.Gun);

        if (weapon != none)
        {
            // Offset vehicle passenger names
            VehicleOccupantsText.PosX = VehicleOccupantsTextOffset;

            // Draw ammo icon
            VehicleMGAmmoIcon.WidgetTexture = weapon.hudAltAmmoIcon;
            DrawSpriteWidget(Canvas, VehicleMGAmmoIcon);

            // Draw reload state icon (if needed) // Matt: to show reload progress in red, like a tank cannon reload
            if (DH_ROMountedTankMGPawn(passenger) != none)
            {
                ProportionOfReloadRemaining = passenger.GetAmmoReloadState();

                if (ProportionOfReloadRemaining > 0.0)
                {
                    VehicleMGAmmoReloadIcon.WidgetTexture = DH_ROMountedTankMGPawn(passenger).VehicleMGReloadTexture;
                    VehicleMGAmmoReloadIcon.Scale = ProportionOfReloadRemaining;
                    DrawSpriteWidget(Canvas, VehicleMGAmmoReloadIcon);
                }
            }

            // Draw ammo count
            VehicleMGAmmoAmount.Value = weapon.getNumMags();
            DrawNumericWidget(Canvas, VehicleMGAmmoAmount, Digits);
        }
    }

    // Draw rpm/speed/throttle gauges if we're the driver
    if (passenger == none)
    {
        wheeled_vehicle = ROWheeledVehicle(vehicle);

        if (wheeled_vehicle != none)
        {
            // Get team index
            if (vehicle.Controller != none && vehicle.Controller.PlayerReplicationInfo != none && vehicle.Controller.PlayerReplicationInfo.Team != none)
            {
                if (vehicle.Controller.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
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
            DrawSpriteWidgetClipped(Canvas, VehicleSpeedIndicator, coords, true, XL, YL, false, true);
            DrawSpriteWidgetClipped(Canvas, VehicleRPMIndicator, coords, true, XL, YL, false, true);

            // Get speed value & update rotator
            f = (((VSize(wheeled_vehicle.Velocity) * 3600.0) / 60.35) / 1000.0);
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
            f = wheeled_vehicle.EngineRPM / 100.0;
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
            DrawSpriteWidgetClipped(Canvas, VehicleSpeedIndicator, coords, true, XL, YL, false, true);
            DrawSpriteWidgetClipped(Canvas, VehicleRPMIndicator, coords, true, XL, YL, false, true);

            // Check if we should draw throttle
            if (ROPlayer(vehicle.Controller) != none &&
                ((ROPlayer(vehicle.Controller).bInterpolatedTankThrottle && threadCraft != none) || (ROPlayer(vehicle.Controller).bInterpolatedVehicleThrottle && threadCraft == none)))
            {
                // Draw throttle background
                DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorBackground, coords, true, XL, YL, false, true);

                // Save YL for use later
                Y_one = YL;

                // Check which throttle variable we should use
                if (PlayerOwner != vehicle.Controller)
                {
                    // Is spectator
                    if (wheeled_vehicle.ThrottleRep <= 100)
                    {
                        f = (wheeled_vehicle.ThrottleRep * -1.0) / 100.0;
                    }
                    else
                    {
                        f = float(wheeled_vehicle.ThrottleRep - 101) / 100.0;
                    }
                }
                else
                {
                    f = wheeled_vehicle.Throttle;
                }

                // Figure which part to draw (top or bottom) depending if throttle is positive or negative, update the scale value and draw the widget
                if (f ~= 0)
                {
                }
                else if (f > 0)
                {
                    VehicleThrottleIndicatorTop.Scale = VehicleThrottleTopZeroPosition + f * (VehicleThrottleTopMaxPosition - VehicleThrottleTopZeroPosition);
                    DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorTop, coords, true, XL, YL, false, true);
                }
                else
                {
                    VehicleThrottleIndicatorBottom.Scale = VehicleThrottleBottomZeroPosition - f * (VehicleThrottleBottomMaxPosition - VehicleThrottleBottomZeroPosition);
                    DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorBottom, coords, true, XL, YL, false, true);
                }

                // Draw throttle foreground
                DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorForeground, coords, true, XL, YL, false, true);

                // Draw the lever thingy
                if (f ~= 0)
                {
                    VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - Y_one * VehicleThrottleTopZeroPosition;
                }
                else if (f > 0)
                {
                    VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - Y_one * VehicleThrottleIndicatorTop.scale;
                }
                else
                {
                    VehicleThrottleIndicatorLever.OffsetY = default.VehicleThrottleIndicatorLever.OffsetY - Y_one * (1 - VehicleThrottleIndicatorBottom.Scale);
                }

                DrawSpriteWidgetClipped(Canvas, VehicleThrottleIndicatorLever, coords, true, XL, YL, true, true);

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
    for (i = 0; i < vehicle.VehicleHudOccupantsX.Length; i++)
    {
        if (vehicle.VehicleHudOccupantsX[i] ~= 0)
        {
            continue;
        }

        if (i == 0)
        {
            // Draw driver
            if (passenger == none) // we're the driver
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsPlayerColor;
            }
            else if (vehicle.Driver != none)
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsOccupiedColor;
            }
            else
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsVacantColor;
            }

            VehicleOccupants.PosX = vehicle.VehicleHudOccupantsX[0];
            VehicleOccupants.PosY = vehicle.VehicleHudOccupantsY[0];
            DrawSpriteWidgetClipped(Canvas, VehicleOccupants, coords, true);
        }
        else
        {
            if (i - 1 >= vehicle.WeaponPawns.Length)
            {
                // Matt: added to replace lines above - if we're already beyond WeaponPawns.Length, there's no point continuing with the for loop
                break;
            }
            // Matt: added to show missing rider/passenger pawns, as now they won't exist on clients unless occupied
            else if (vehicle.WeaponPawns[i - 1] == none)
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsVacantColor;
            }
            else if (vehicle.WeaponPawns[i - 1] == passenger && passenger != none)
            {
                VehicleOccupants.Tints[TeamIndex] = VehiclePositionIsPlayerColor;
            }
            else if (vehicle.WeaponPawns[i - 1].PlayerReplicationInfo != none)
            {
                if (passenger != none && passenger.PlayerReplicationInfo != none && vehicle.WeaponPawns[i - 1].PlayerReplicationInfo == passenger.PlayerReplicationInfo)
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

            VehicleOccupants.PosX = vehicle.VehicleHudOccupantsX[i];
            VehicleOccupants.PosY = vehicle.VehicleHudOccupantsY[i];

            DrawSpriteWidgetClipped(Canvas, VehicleOccupants, coords, true);
        }
    }

    //////////////////////////////////////
    // Draw passenger names
    //////////////////////////////////////

    // Get self's PRI
    if (passenger != none)
    {
        PRI = passenger.PlayerReplicationInfo;
    }
    else
    {
        PRI = vehicle.PlayerReplicationInfo;
    }

    // Clear lines array
    lines.length = 0;

    // Shift text up some more if we're the driver and we're displaying capture bar
    if (bDrawingCaptureBar && vehicle.PlayerReplicationInfo == PRI)
    {
        modifiedVehicleOccupantsTextYOffset -= 0.12 * Canvas.SizeY * myScale;
    }

    // Driver's name
    if (vehicle.PlayerReplicationInfo != none && vehicle.PlayerReplicationInfo != PRI) // don't draw our own name!
    {
        lines[lines.length] = class'ROVehicleWeaponPawn'.default.DriverHudName $ ": " $ vehicle.PlayerReplicationInfo.PlayerName;
    }

    // Passengers' names
    for (i = 0; i < vehicle.WeaponPawns.Length; i++)
    {
        wpawn = ROVehicleWeaponPawn(vehicle.WeaponPawns[i]);

        if (wpawn != none && wpawn.PlayerReplicationInfo != none && wpawn.PlayerReplicationInfo != PRI) // don't draw our own name!
        {
            lines[lines.length] = wpawn.HudName $ ": " $ wpawn.PlayerReplicationInfo.PlayerName;
        }
    }

    // Draw the lines
    if (lines.Length > 0)
    {
        VehicleOccupantsText.OffsetY = default.VehicleOccupantsText.OffsetY * myScale;
        VehicleOccupantsText.OffsetY += modifiedVehicleOccupantsTextYOffset;
        Canvas.Font = GetSmallMenuFont(Canvas);

        for (i = lines.Length - 1; i >= 0 ; i--)
        {
            VehicleOccupantsText.text = lines[i];
            DrawTextWidgetClipped(Canvas, VehicleOccupantsText, coords2, XL, YL, Y_one);
            VehicleOccupantsText.OffsetY -= YL;
        }
    }
}


//-----------------------------------------------------------------------------
// DrawPlayerNames - Draws identify info for friendlies
// Overridden to handle AT reload messages
//-----------------------------------------------------------------------------

function DrawPlayerNames(Canvas C)
{
    local actor HitActor;
    local vector HitLocation, HitNormal, ViewPos;
    local vector ScreenPos, Loc, X, Y, Z, Dir;
    local float strX, strY;
    local string display;
    local float distance;
    local bool bIsAVehicle;
    //Added for mortar resupplying.
    local DH_MortarVehicle V;

    local DH_Pawn MyDHP, OtherDHP;

    if (PawnOwner == none || PawnOwner.Controller == none)
        return;

    if (!bSetColour)
    {
       SetAlliedColour();
       //log("Running SAC from DrawPlayerNames");
    }

    ViewPos = PawnOwner.Location + PawnOwner.BaseEyeHeight * vect(0, 0, 1);
    HitActor = Trace(HitLocation,HitNormal,ViewPos + 1600 * vector(PawnOwner.Controller.Rotation),ViewPos, true);

    //CHECK FOR MORTAR, Basnett 2011
    if (HitActor != none && DH_Pawn(PawnOwner) != none && DH_MortarVehicle(HitActor) != none)
    {
        MyDHP = DH_Pawn(PawnOwner);

        V = DH_MortarVehicle(HitActor);

        if (V != none && V.VehicleTeam == MyDHP.GetTeamNum())
        {
            NamedPlayer = V;

            // Draw player name
            C.Font = GetPlayerNameFont(C);
            Loc = NamedPlayer.Location;
            Loc.Z += NamedPlayer.CollisionHeight + 8;
            ScreenPos = C.WorldToScreen(Loc);

            if (V.PlayerReplicationInfo != none)
            {
                C.DrawColor = GetTeamColour(V.PlayerReplicationInfo.Team.TeamIndex);
                C.TextSize(V.PlayerReplicationInfo.PlayerName, strX, strY);
                C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 2.0);
                display = V.PlayerReplicationInfo.PlayerName;
                C.DrawTextClipped(display);
            }

            //Someone's on it, let's check their ammunition.
            //Also, are we capable of reloading?
            if (MyDHP != none && MyDHP.bHasMortarAmmo && V.bCanBeResupplied)
            {
                distance = VSizeSquared(Loc - PawnOwner.Location);

                if (MyDHP != none)
                {
                    if (MyDHP.bCanMGResupply)
                        MyDHP.bCanMGResupply = false;
                    if (MyDHP.bCanATReload)
                        MyDHP.bCanATReload = false;
                    if (MyDHP.bCanMortarResupply)
                        MyDHP.bCanMortarResupply = false;
                }

                if (distance < 14400.0) // 2 Meters
                {
                    MyDHP.bCanMortarResupply = true;
                    display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                }
                else
                {
                    if (MyDHP.bCanMortarResupply)
                        MyDHP.bCanMortarResupply = false;

                       display = NeedAmmoText;
                }

                // Draw text under player's name (need ammo or press x to resupply)
                C.DrawColor = WhiteColor;
                C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 1.0);
                C.DrawTextClipped(display);
            }
        }

        return;
    }

    if ((Pawn(HitActor) != none) && (Pawn(HitActor).PlayerReplicationInfo != none)
        && ((PawnOwner.PlayerReplicationInfo.Team == none) || (PawnOwner.PlayerReplicationInfo.Team == Pawn(HitActor).PlayerReplicationInfo.Team)))
    {
        if ((NamedPlayer != HitActor) || (Level.TimeSeconds - NameTime > 0.5))
        {
            //PlayerOwner.ReceiveLocalizedMessage(class'ROPlayerNameMessage',0,Pawn(HitActor).PlayerReplicationInfo);
            NameTime = Level.TimeSeconds;
        }

        NamedPlayer = Pawn(HitActor);
    }
    else
        NamedPlayer = none;

    if (NamedPlayer != none && NamedPlayer.PlayerReplicationInfo != none && Level.TimeSeconds - NameTime < 1.0)
    {
        MyDHP = DH_Pawn(PawnOwner);
        OtherDHP = DH_Pawn(NamedPlayer);

        // Quick check simply to stop error log spam
        if (OtherDHP != none)
            bIsAVehicle = false;
        else
            bIsAVehicle = true;

        GetAxes(PlayerOwner.Rotation, X, Y, Z);
        Dir = Normal(NamedPlayer.Location - PawnOwner.Location);

        if (Dir dot X > 0.0)
        {
            C.DrawColor = GetTeamColour(NamedPlayer.PlayerReplicationInfo.Team.TeamIndex);
            C.Font = GetPlayerNameFont(C);

            //------------------------------------------------------------------
            //Mortar resupply
            if (MyDHP != none && OtherDHP != none && MyDHP.bHasMortarAmmo && OtherDHP.bMortarCanBeResupplied)
            {
                // Draw player name
                Loc = NamedPlayer.Location;
                Loc.Z += NamedPlayer.CollisionHeight + 8;
                ScreenPos = C.WorldToScreen(Loc);
                C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, strX, strY);
                C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 2.0);
                display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                C.DrawTextClipped(display);
                distance = VSizeSquared(Loc - PawnOwner.Location);

                if (MyDHP != none)
                {
                    if (MyDHP.bCanMGResupply)
                        MyDHP.bCanMGResupply = false;
                    if (MyDHP.bCanATReload)
                        MyDHP.bCanATReload = false;
                    if (MyDHP.bCanMortarResupply)
                        MyDHP.bCanMortarResupply = false;
                }

                if (distance < 14400.0) // 2 Meters
                {
                    MyDHP.bCanMortarResupply = true;
                    display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                }
                else
                {
                    if (MyDHP.bCanMortarResupply)
                        MyDHP.bCanMortarResupply = false;

                       display = NeedAmmoText;
                }

                // Draw text under player's name (need ammo or press x to resupply)
                C.DrawColor = WhiteColor;
                C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 1.0);
                C.DrawTextClipped(display);
            }
            else if (bIsAVehicle || !OtherDHP.bWeaponCanBeReloaded)
            {
                if (MyDHP != none && !NamedPlayer.IsA('Vehicle') && MyDHP.bHasMGAmmo
                    && OtherDHP.bWeaponCanBeResupplied && OtherDHP.bWeaponNeedsResupply)
                {
                    // Draw player name
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, strX, strY);
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 2.0);
                    display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(display);

                    distance = VSizeSquared(Loc - PawnOwner.Location);

                    if (MyDHP!= none)
                    {
                        if (MyDHP.bCanATResupply)
                            MyDHP.bCanATResupply = false;
                        if (MyDHP.bCanATReload)
                            MyDHP.bCanATReload = false;
                    }

                    if (distance < 14400.0) // 2 Meters
                    {
                        MyDHP.bCanMGResupply = true;
                        display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                    }
                    else
                    {
                        if (MyDHP.bCanMGResupply)
                            MyDHP.bCanMGResupply = false;
                        display = NeedAmmoText;
                    }

                    // Draw text under player's name (need ammo or press x to resupply)
                    C.DrawColor = WhiteColor;
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 1.0);
                    C.DrawTextClipped(display);
                }
                else
                {
                    if (MyDHP!= none)
                    {
                        if (MyDHP.bCanMGResupply)
                            MyDHP.bCanMGResupply = false;
                        if (MyDHP.bCanATResupply)
                            MyDHP.bCanATResupply = false;
                        if (MyDHP.bCanATReload)
                            MyDHP.bCanATReload = false;
                    }

                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, strX, strY);
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 0.5);

                    display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(display);
                }
            }
            else if (OtherDHP != none && OtherDHP.bWeaponCanBeReloaded)
            {
                if (MyDHP!= none && !NamedPlayer.IsA('Vehicle') && OtherDHP.bWeaponNeedsReload)
                {
                    // Draw player name
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, strX, strY);
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 2.0);
                    display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(display);

                    distance = VSizeSquared(Loc - PawnOwner.Location);

                    if (MyDHP!= none)
                    {
                        if (MyDHP.bCanMGResupply)
                            MyDHP.bCanMGResupply = false;
                        if (MyDHP.bCanATResupply)
                            MyDHP.bCanATResupply = false;
                    }

                    if (distance < 14400.0) // 2 Meters
                    {
                        MyDHP.bCanATReload = true;
                        display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanReloadText, PlayerController(Owner));
                    }
                    else
                    {
                        if (MyDHP.bCanATReload)
                            MyDHP.bCanATReload = false;
                        display = NeedReloadText;
                    }

                    // Draw text under player's name (need ammo or press x to resupply)
                    C.DrawColor = WhiteColor;
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 1.0);
                    C.DrawTextClipped(display);
                }
                else if (MyDHP!= none && OtherDHP != none && !NamedPlayer.IsA('Vehicle') && MyDHP.bHasATAmmo
                    && OtherDHP.bWeaponCanBeResupplied && OtherDHP.bWeaponNeedsResupply)
                {
                    // Draw player name
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, strX, strY);
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 2.0);
                    display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(display);

                    distance = VSizeSquared(Loc - PawnOwner.Location);

                    if (MyDHP!= none)
                    {
                        if (MyDHP.bCanMGResupply)
                            MyDHP.bCanMGResupply = false;
                        if (MyDHP.bCanATReload)
                            MyDHP.bCanATReload = false;
                    }

                    if (distance < 14400.0) // 2 Meters
                    {
                        MyDHP.bCanATResupply = true;
                        display = class'ROTeamGame'.static.ParseLoadingHintNoColor(CanResupplyText, PlayerController(Owner));
                    }
                    else
                    {
                        if (MyDHP.bCanATResupply)
                            MyDHP.bCanATResupply = false;
                        display = NeedAmmoText;
                    }

                    // Draw text under player's name (need ammo or press x to resupply)
                    C.DrawColor = WhiteColor;
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 1.0);
                    C.DrawTextClipped(display);
                }
                else
                {
                    if (MyDHP!= none)
                    {
                        if (MyDHP.bCanMGResupply)
                            MyDHP.bCanMGResupply = false;
                        if (MyDHP.bCanATResupply)
                            MyDHP.bCanATResupply = false;
                        if (MyDHP.bCanATReload)
                            MyDHP.bCanATReload = false;
                    }

                    C.TextSize(NamedPlayer.PlayerReplicationInfo.PlayerName, strX, strY);
                    Loc = NamedPlayer.Location;
                    Loc.Z += NamedPlayer.CollisionHeight + 8;
                    ScreenPos = C.WorldToScreen(Loc);
                    C.SetPos(ScreenPos.X - strX * 0.5, ScreenPos.Y - strY * 0.5);

                    display = NamedPlayer.PlayerReplicationInfo.PlayerName;
                    C.DrawTextClipped(display);
                }
            }
        }
    }
}

//-----------------------------------------------------------------------------
// DrawObjectives - Renders the objectives on the HUD similar to the scoreboard
//-----------------------------------------------------------------------------

simulated function DrawObjectives(Canvas C)
{
    local DHGameReplicationInfo DHGRI;
    local DHPlayerReplicationInfo PRI;
    local int i, OwnerTeam, objCount, SecondaryObjCount;
    local AbsoluteCoordsInfo MapCoords, subCoords;
    local bool bShowRally, bShowArtillery, bShowResupply, bShowArtyCoords,
        bShowNeutralObj, bShowMGResupplyRequest, bShowHelpRequest, bShowAttackDefendRequest,
        bShowArtyStrike, bShowDestroyableItems, bShowDestroyedItems, bShowVehicleResupply,
        bHasSecondaryObjectives;
    local float myMapScale, XL, YL, YL_one, time;
    local vector temp, MapCenter;
    local SpriteWidget  widget;
    local Actor A;
    local DHPlayer player;
    local Controller P;
    // PSYONIX: DEBUG
    local Vehicle V;
    local float pawnRotation;
    local ROVehicleWeaponPawn myVehicleWeaponPawn;
    local float X, Y, strX, strY;
    local string S;
    // Net debug
    local Actor NetActor;
    local Pawn NetPawn;
    local int Pos;
    // AT Gun
    local bool bShowATGun;
    local DH_Pawn DHP;
    local DH_RoleInfo RI;

    if (PlayerOwner.Pawn != none)
        DHP = DH_Pawn(PlayerOwner.Pawn);

    // Get DHGRI
    DHGRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (DHGRI == none)
        return;

    // Update time
    if (DHGRI != none)
    {
        if (!DHGRI.bMatchHasBegun)
            CurrentTime = FMax(0.0, DHGRI.RoundStartTime + DHGRI.PreStartTime - DHGRI.ElapsedTime);
        else
            CurrentTime = FMax(0.0, DHGRI.RoundStartTime + DHGRI.RoundDuration - DHGRI.ElapsedTime);
    }

    // Get player
    player = DHPlayer(PlayerOwner);

    // Get PRI
    PRI = DHPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);

    // Get Role info
    if (PRI.RoleInfo != none)
        RI = DH_RoleInfo(PRI.RoleInfo);

    // Get player team -- if none, we won't draw team-specific information on the map
    if (PlayerOwner != none)
        OwnerTeam = PlayerOwner.GetTeamNum();
    else
        OwnerTeam = 255;

    // Set map coords based on resolution
    // We want to keep a 4:3 aspect ratio for the map
    MapCoords.height = C.ClipY * 0.9;
    MapCoords.PosY = C.ClipY * 0.05;
    MapCoords.width = MapCoords.height * 4 / 3;
    MapCoords.PosX = (C.ClipX - MapCoords.width) / 2;

    // Calculate map offset (for animation)
    if (bAnimateMapIn)
    {
        AnimateMapCurrentPosition -= (Level.TimeSeconds - hudLastRenderTime) / AnimateMapSpeed;
        if (AnimateMapCurrentPosition <= 0)
        {
            AnimateMapCurrentPosition = 0;
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
    GetAbsoluteCoordinatesAlt(MapCoords, MapLegendImageCoords, subCoords);

    // Save coordinates for use in menu page
    MapLevelImageCoordinates = subCoords;

    // Draw coordinates text on sides of the map
    for (i = 0; i < 9; i++)
    {
        MapCoordTextXWidget.PosX = (float(i) + 0.5) / 9;
        MapCoordTextXWidget.text = MapCoordTextX[i];
        DrawTextWidgetClipped(C, MapCoordTextXWidget, subCoords);

        MapCoordTextYWidget.PosY = MapCoordTextXWidget.PosX;
        MapCoordTextYWidget.text = MapCoordTextY[i];
        DrawTextWidgetClipped(C, MapCoordTextYWidget, subCoords);
    }

    // Draw level map
    MapLevelImage.WidgetTexture = DHGRI.MapImage;
    if (MapLevelImage.WidgetTexture != none)    // Remove this once all maps have overhead
        DrawSpriteWidgetClipped(C, MapLevelImage, subCoords, true);

    // Calculate level map constants
    temp = DHGRI.SouthWestBounds - DHGRI.NorthEastBounds;
    MapCenter =  temp/2 + DHGRI.NorthEastBounds;
    myMapScale = abs(temp.x);
    if (myMapScale ~= 0)
        myMapScale = 1; // just so we never get divisions by 0

    // Set the font to be used to draw objective text
    C.Font = GetSmallMenuFont(C);

    // Draw resupply areas
    for (i = 0; i < arraycount(DHGRI.ResupplyAreas); i++)
    {
        if (!DHGRI.ResupplyAreas[i].bActive ||
            (DHGRI.ResupplyAreas[i].Team != OwnerTeam && DHGRI.ResupplyAreas[i].Team != NEUTRAL_TEAM_INDEX))
        {
            continue;
        }

        if (DHGRI.ResupplyAreas[i].ResupplyType == 1)
        {
            // Tank resupply icon
            bShowVehicleResupply = true;
            DrawIconOnMap(C, subCoords, MapIconVehicleResupply, myMapScale, DHGRI.ResupplyAreas[i].ResupplyVolumeLocation, MapCenter);
        }
        else
        {
            // Player resupply icon
            bShowResupply = true;
            DrawIconOnMap(C, subCoords, MapIconResupply, myMapScale, DHGRI.ResupplyAreas[i].ResupplyVolumeLocation, MapCenter);
        }
    }

    // Draw AT-Guns
    for (i = 0; i < arraycount(DHGRI.ATCannons); i++)
    {
        if (DHGRI.ATCannons[i].ATCannonLocation != vect(0, 0, 0) && DHGRI.ATCannons[i].Team == PlayerOwner.GetTeamNum())
        {
            if (DHGRI.ATCannons[i].ATCannonLocation.Z > 0)  // ATCannon is active is the Z location is greater than 0
            {
                bShowATGun = true;

                // AT-Gun icon
                MapIconATGun.Tints[0] = WhiteColor;
                MapIconATGun.Tints[1] = WhiteColor;
                DrawIconOnMap(C, subCoords, MapIconATGun, myMapScale, DHGRI.ATCannons[i].ATCannonLocation, MapCenter);
            }
        }
    }

    if (Level.NetMode == NM_Standalone && bShowDebugInfoOnMap)
    {
        // PSYONIX: DEBUG - Show all vehicles on map who have no driver
        foreach DynamicActors(class'Vehicle',V)
        {
                widget = MapIconRally[V.GetTeamNum()];
                widget.TextureScale = 0.04f;
                if (V.health <= 0)
                    widget.RenderStyle = STY_Translucent;
                else
                    widget.RenderStyle = STY_Normal;
                // Empty Vehicle
                if (Bot(V.Controller) == none && (ROWheeledVehicle(V) != none && V.NumPassengers() == 0))
                    DrawDebugIconOnMap(C, subCoords, widget, myMapScale, V.Location, MapCenter, "");
                // Vehicle
                else if (VehicleWeaponPawn(V) == none && V.Controller != none)
                    DrawDebugIconOnMap(C, subCoords, widget, myMapScale, V.Location, MapCenter, Left(Bot(V.Controller).Squad.GetOrders(),1)$" "$V.NumPassengers());
        }
        // PSYONIX: DEBUG - Show all players on map and indicate orders
        for (P = Level.ControllerList; P != none; P = P.NextController)
        {
            if (Bot(P) != none && P.Pawn != none && ROVehicle(P.Pawn) == none)
            {
                widget = MapIconTeam[P.GetTeamNum()];
                widget.TextureScale = 0.025f;

                DrawDebugIconOnMap(C, subCoords, widget, myMapScale, P.Pawn.Location, MapCenter, Left(Bot(P).Squad.GetOrders(),1));
            }
        }
    }

    if ((Level.NetMode == NM_Standalone || DHGRI.bAllowNetDebug) && bShowRelevancyDebugOnMap)
    {
        if (NetDebugMode == ND_All)
        {
            foreach DynamicActors(class'Actor',NetActor)
            {
                if (!NetActor.bStatic && !NetActor.bNoDelete)
                {
                    widget = MapIconNeutral;
                    widget.TextureScale = 0.04f;
                    widget.RenderStyle = STY_Normal;
                    DrawDebugIconOnMap(C, subCoords, widget, myMapScale, NetActor.Location, MapCenter, "");
                }
            }
        }
        else if (NetDebugMode == ND_VehiclesOnly)
        {
            // PSYONIX: DEBUG - Show all vehicles on map who have no driver
            foreach DynamicActors(class'Vehicle',V)
            {
                widget = MapIconRally[V.GetTeamNum()];
                widget.TextureScale = 0.04f;
                widget.RenderStyle = STY_Normal;

                if (ROWheeledVehicle(V) != none)
                    DrawDebugIconOnMap(C, subCoords, widget, myMapScale, V.Location, MapCenter, "");
            }
        }
        else if (NetDebugMode == ND_PlayersOnly)
        {
            foreach DynamicActors(class'DH_Pawn', DHP)
            {
                widget = MapIconTeam[DHP.GetTeamNum()];
                widget.TextureScale = 0.04f;
                widget.RenderStyle = STY_Normal;

                DrawDebugIconOnMap(C, subCoords, widget, myMapScale, DHP.Location, MapCenter, "");
            }
        }
        else if (NetDebugMode == ND_PawnsOnly)
        {
            foreach DynamicActors(class'Pawn',NetPawn)
            {
                if (Vehicle(NetPawn) != none)
                {
                    widget = MapIconRally[V.GetTeamNum()];
                }
                else if (ROPawn(NetPawn) != none)
                {
                    widget = MapIconTeam[NetPawn.GetTeamNum()];
                }
                else
                {
                    widget = MapIconNeutral;
                }

                widget.TextureScale = 0.04f;
                widget.RenderStyle = STY_Normal;

                DrawDebugIconOnMap(C, subCoords, widget, myMapScale, NetPawn.Location, MapCenter, "");
            }
        }
        if (NetDebugMode == ND_AllWithText)
        {
            foreach DynamicActors(class'Actor',NetActor)
            {
                if (!NetActor.bStatic && !NetActor.bNoDelete)
                {
                    widget = MapIconNeutral;
                    widget.TextureScale = 0.04f;
                    widget.RenderStyle = STY_Normal;

                    S = ""$NetActor;

                    // Remove the package name, if it exists
                    Pos = InStr(S, ".");

                    if (Pos != -1)
                        S = Mid(S, Pos + 1);

                    DrawDebugIconOnMap(C, subCoords, widget, myMapScale, NetActor.Location, MapCenter, S);
                }
            }
        }
    }

    if (player != none)
    {
        // Draw the marked arty strike
        temp = player.SavedArtilleryCoords;

        if (temp != vect(0, 0, 0))
        {
            bShowArtyCoords = true;
            widget = MapIconArtyStrike;
            widget.Tints[0].A = 125; widget.Tints[1].A = 125;
            DrawIconOnMap(C, subCoords, widget, myMapScale, temp, MapCenter);
        }

        // Draw the destroyable/destroyed targets
        if (player.Destroyables.length != 0)
        {
            for (i = 0; i < player.Destroyables.length; i++)
            {
                //if (player.Destroyables[i].GetStateName() == 'Broken')
                if (player.Destroyables[i].bHidden || player.Destroyables[i].bDamaged)
                {
                    DrawIconOnMap(C, subCoords, MapIconDestroyedItem, myMapScale,
                        player.Destroyables[i].Location, MapCenter);
                    bShowDestroyedItems = true;
                }
                else
                {
                    DrawIconOnMap(C, subCoords, MapIconDestroyableItem, myMapScale,
                        player.Destroyables[i].Location, MapCenter);
                    bShowDestroyableItems = true;
                }
            }
        }
    }

    if (OwnerTeam != 255)
    {
        // Draw the in-progress arty strikes
        if (OwnerTeam == AXIS_TEAM_INDEX || OwnerTeam == ALLIES_TEAM_INDEX)
           if (DHGRI.ArtyStrikeLocation[OwnerTeam] != vect(0, 0, 0))
           {
               DrawIconOnMap(C, subCoords, MapIconArtyStrike, myMapScale, DHGRI.ArtyStrikeLocation[OwnerTeam], MapCenter);
               bShowArtyStrike = true;
           }

        // Draw the rally points
        for (i = 0; i < arraycount(DHGRI.AxisRallyPoints); i++)
        {
            if (OwnerTeam == AXIS_TEAM_INDEX)
                temp = DHGRI.AxisRallyPoints[i].RallyPointLocation;
            else if (OwnerTeam == ALLIES_TEAM_INDEX)
                temp = DHGRI.AlliedRallyPoints[i].RallyPointLocation;

            // Draw the marked rally point
            if (temp != vect(0, 0, 0))
            {
                bShowRally = true;
                DrawIconOnMap(C, subCoords, MapIconRally[OwnerTeam], myMapScale, temp, MapCenter);
            }
        }

        // Draw Artillery Radio Icons
        if (OwnerTeam == AXIS_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.AxisRadios); i++)
            {
                if (DHGRI.AxisRadios[i] == none ||
                    (DHGRI.AxisRadios[i].IsA('DHArtilleryTrigger') &&
                    !DHArtilleryTrigger(DHGRI.AxisRadios[i]).bShouldShowOnSituationMap))
                {
                    continue;
                }

                bShowArtillery = true;
                DrawIconOnMap(C, subCoords, MapIconRadio, myMapScale, DHGRI.AxisRadios[i].Location, MapCenter);
            }
        }
        else if (OwnerTeam == ALLIES_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.AlliedRadios); i++)
            {
                if (DHGRI.AlliedRadios[i] == none ||
                    (DHGRI.AlliedRadios[i].IsA('DHArtilleryTrigger') &&
                    !DHArtilleryTrigger(DHGRI.AlliedRadios[i]).bShouldShowOnSituationMap))
                {
                    continue;
                }

                bShowArtillery = true;
                DrawIconOnMap(C, subCoords, MapIconRadio, myMapScale, DHGRI.AlliedRadios[i].Location, MapCenter);
            }
        }

        // Draw player-carried Artillery radio icons if player is an artillery officer
        if (PRI.RoleInfo != none && RI != none && RI.bIsArtilleryOfficer)
        {
            if (OwnerTeam == AXIS_TEAM_INDEX)
            {
                for (i = 0; i < arraycount(DHGRI.CarriedAxisRadios); i++)
                {
                    if (DHGRI.CarriedAxisRadios[i] == none)
                        continue;

                    bShowArtillery = true;
                    DrawIconOnMap(C, subCoords, MapIconCarriedRadio, myMapScale, DHGRI.CarriedAxisRadios[i].Location, MapCenter);
                }
            }
            else if (OwnerTeam == ALLIES_TEAM_INDEX)
            {
                for (i = 0; i < arraycount(DHGRI.CarriedAlliedRadios); i++)
                {
                    if (DHGRI.CarriedAlliedRadios[i] == none)
                        continue;

                    bShowArtillery = true;
                    DrawIconOnMap(C, subCoords, MapIconCarriedRadio, myMapScale, DHGRI.CarriedAlliedRadios[i].Location, MapCenter);
                }
            }
        }

        // Draw help requests
        if (OwnerTeam == AXIS_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.AxisHelpRequests); i++)
            {
                if (DHGRI.AxisHelpRequests[i].requestType == 255)
                    continue;

                switch (DHGRI.AxisHelpRequests[i].requestType)
                {
                    case 0: // help request at objective
                        bShowHelpRequest = true;
                        widget = MapIconHelpRequest;
                        widget.Tints[0].A = 125; widget.Tints[1].A = 125;
                        DrawIconOnMap(C, subCoords, widget, myMapScale,
                            DHGRI.Objectives[DHGRI.AxisHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 1: // attack request
                    case 2: // defend request
                        bShowAttackDefendRequest = true;
                        DrawIconOnMap(C, subCoords, MapIconAttackDefendRequest, myMapScale,
                            DHGRI.Objectives[DHGRI.AxisHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 3: // mg resupply requests
                        bShowMGResupplyRequest = true;
                        DrawIconOnMap(C, subCoords, MapIconMGResupplyRequest[AXIS_TEAM_INDEX], myMapScale, DHGRI.AxisHelpRequestsLocs[i], MapCenter);
                        break;

                    case 4: // help request at coords
                        bShowHelpRequest = true;
                        DrawIconOnMap(C, subCoords, MapIconHelpRequest, myMapScale, DHGRI.AxisHelpRequestsLocs[i], MapCenter);
                        break;

                    default:
                        Log("Unknown requestType found in AxisHelpRequests[i]: " $ DHGRI.AxisHelpRequests[i].requestType);
                }
            }

            //------------------------------------------------------------------
            //Draw all mortar targets on the map.
            if (RI != none && (RI.bIsMortarObserver || RI.bCanUseMortars))
            {
                for(i = 0; i < arraycount(DHGRI.GermanMortarTargets); i++)
                {
                    if (DHGRI.GermanMortarTargets[i].Location != vect(0, 0, 0) && DHGRI.GermanMortarTargets[i].bCancelled == 0)
                        DrawIconOnMap(C, subCoords, MapIconMortarTarget, myMapScale, DHGRI.GermanMortarTargets[i].Location, MapCenter);
                }
            }

            //------------------------------------------------------------------
            //Draw hit location for mortar observer's confirmed hits on his own target.
            if (RI != none && RI.bIsMortarObserver && player != none && player.MortarTargetIndex != 255)
            {
                if (DHGRI.GermanMortarTargets[player.MortarTargetIndex].HitLocation != vect(0, 0, 0) && DHGRI.GermanMortarTargets[player.MortarTargetIndex].bCancelled == 0)
                    DrawIconOnMap(C, subCoords, MapIconMortarHit, myMapScale, DHGRI.GermanMortarTargets[player.MortarTargetIndex].HitLocation, MapCenter);
            }

            //------------------------------------------------------------------
            //Draw hit location for mortar operator if he has a valid hit location.
            if (RI != none && RI.bCanUseMortars && player != none && player.MortarHitLocation != vect(0, 0, 0))
                DrawIconOnMap(C, subCoords, MapIconMortarHit, myMapScale, player.MortarHitLocation, MapCenter);

        }
        else if (OwnerTeam == ALLIES_TEAM_INDEX)
        {
            for (i = 0; i < arraycount(DHGRI.AlliedHelpRequests); i++)
            {
                if (DHGRI.AlliedHelpRequests[i].requestType == 255)
                    continue;

                switch (DHGRI.AlliedHelpRequests[i].requestType)
                {
                    case 0: // help request at objective
                        bShowHelpRequest = true;
                        widget = MapIconHelpRequest;
                        widget.Tints[0].A = 125; widget.Tints[1].A = 125;
                        DrawIconOnMap(C, subCoords, widget, myMapScale,
                            DHGRI.Objectives[DHGRI.AlliedHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 1: // attack request
                    case 2: // defend request
                        bShowAttackDefendRequest = true;
                        DrawIconOnMap(C, subCoords, MapIconAttackDefendRequest, myMapScale,
                            DHGRI.Objectives[DHGRI.AlliedHelpRequests[i].objectiveID].Location, MapCenter);
                        break;

                    case 3: // mg resupply requests
                        bShowMGResupplyRequest = true;
                        DrawIconOnMap(C, subCoords, MapIconMGResupplyRequest[ALLIES_TEAM_INDEX], myMapScale, DHGRI.AlliedHelpRequestsLocs[i], MapCenter);
                        break;

                    case 4: // help request at coords
                        bShowHelpRequest = true;
                        DrawIconOnMap(C, subCoords, MapIconHelpRequest, myMapScale, DHGRI.AlliedHelpRequestsLocs[i], MapCenter);
                        break;

                    default:
                        Log("Unknown requestType found in AlliedHelpRequests[i]: " $ DHGRI.AlliedHelpRequests[i].requestType);
                }
            }

            //------------------------------------------------------------------
            //Draw all mortar targets on the map.
            for(i = 0; i < arraycount(DHGRI.AlliedMortarTargets); i++)
            {
                if (DHGRI.AlliedMortarTargets[i].Location != vect(0, 0, 0) && DHGRI.AlliedMortarTargets[i].bCancelled == 0)
                    DrawIconOnMap(C, subCoords, MapIconMortarTarget, myMapScale, DHGRI.AlliedMortarTargets[i].Location, MapCenter);
            }

            //------------------------------------------------------------------
            //Draw hit location for mortar observer's confirmed hits on his own target.
            if (RI != none && RI.bIsMortarObserver && player != none && player.MortarTargetIndex != 255)
            {
                if (DHGRI.AlliedMortarTargets[player.MortarTargetIndex].HitLocation != vect(0, 0, 0) && DHGRI.GermanMortarTargets[player.MortarTargetIndex].bCancelled == 0)
                    DrawIconOnMap(C, subCoords, MapIconMortarHit, myMapScale, DHGRI.AlliedMortarTargets[player.MortarTargetIndex].HitLocation, MapCenter);
            }

            //------------------------------------------------------------------
            //Draw hit location for mortar operator if he has a valid hit location.
            if (RI != none && RI.bCanUseMortars && player != none && player.MortarHitLocation != vect(0, 0, 0))
                DrawIconOnMap(C, subCoords, MapIconMortarHit, myMapScale, player.MortarHitLocation, MapCenter);
        }
    }

    // Draw objectives
    for (i = 0; i < arraycount(DHGRI.Objectives); i++)
    {
        if (DHGRI.Objectives[i] == none)
            continue;

        // Setup icon info
        if (DHGRI.Objectives[i].ObjState == OBJ_Axis)
            widget = MapIconTeam[AXIS_TEAM_INDEX];
        else if (DHGRI.Objectives[i].ObjState == OBJ_Allies)
            widget = MapIconTeam[ALLIES_TEAM_INDEX];
        else
        {
            bShowNeutralObj = true;
            widget = MapIconNeutral;
        }
        if (!DHGRI.Objectives[i].bActive)
        {
            widget.Tints[0] = GrayColor; widget.Tints[1] = GrayColor;
            widget.Tints[0].A = 125; widget.Tints[1].A = 125;
        }
        else
        {
            widget.Tints[0] = WhiteColor; widget.Tints[1] = WhiteColor;
        }

        // Draw flashing icon if objective is disputed
        if (DHGRI.Objectives[i].CompressedCapProgress != 0 && DHGRI.Objectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
        {
            if (DHGRI.Objectives[i].CompressedCapProgress == 1 || DHGRI.Objectives[i].CompressedCapProgress == 2)
                DrawIconOnMap(C, subCoords, widget, myMapScale, DHGRI.Objectives[i].Location, MapCenter, 2, DHGRI.Objectives[i].ObjName, DHGRI, i);
            else if (DHGRI.Objectives[i].CompressedCapProgress == 3 || DHGRI.Objectives[i].CompressedCapProgress == 4)
                DrawIconOnMap(C, subCoords, widget, myMapScale, DHGRI.Objectives[i].Location, MapCenter, 3, DHGRI.Objectives[i].ObjName, DHGRI, i);
            else
                DrawIconOnMap(C, subCoords, widget, myMapScale, DHGRI.Objectives[i].Location, MapCenter, 1, DHGRI.Objectives[i].ObjName, DHGRI, i);
        }
        else
            DrawIconOnMap(C, subCoords, widget, myMapScale, DHGRI.Objectives[i].Location, MapCenter, 1, DHGRI.Objectives[i].ObjName, DHGRI, i);


        // If the objective isn't completely captured, overlay a flashing icon from other team
        if (DHGRI.Objectives[i].CompressedCapProgress != 0 && DHGRI.Objectives[i].CurrentCapTeam != NEUTRAL_TEAM_INDEX)
        {
            if (DHGRI.Objectives[i].CurrentCapTeam == ALLIES_TEAM_INDEX)
                widget = MapIconDispute[ALLIES_TEAM_INDEX];
            else
                widget = MapIconDispute[AXIS_TEAM_INDEX];
            if (DHGRI.Objectives[i].CompressedCapProgress == 1 || DHGRI.Objectives[i].CompressedCapProgress == 2)
                DrawIconOnMap(C, subCoords, widget, myMapScale, DHGRI.Objectives[i].Location, MapCenter, 4);
            else if (DHGRI.Objectives[i].CompressedCapProgress == 3 || DHGRI.Objectives[i].CompressedCapProgress == 4)
                DrawIconOnMap(C, subCoords, widget, myMapScale, DHGRI.Objectives[i].Location, MapCenter, 5);
        }
    }

    // Get player actor
    if (PawnOwner != none)
        A = PawnOwner;
    else if (PlayerOwner.IsInState('Spectating'))
        A = PlayerOwner;
    else if (PlayerOwner.Pawn != none)
        A = PlayerOwner.Pawn;

    // Fix for frelled rotation on weapon pawns
    myVehicleWeaponPawn = ROVehicleWeaponPawn(A);
    if (myVehicleWeaponPawn != none)
    {
       player = DHPlayer(myVehicleWeaponPawn.Controller);
       if (player != none && myVehicleWeaponPawn.VehicleBase != none)
           pawnRotation = -player.CalcViewRotation.Yaw;
       else if (myVehicleWeaponPawn.VehicleBase != none)
           pawnRotation = -myVehicleWeaponPawn.VehicleBase.Rotation.Yaw;
       else
           pawnRotation = -A.Rotation.Yaw;
    }
    else if (A != none)
       pawnRotation = -A.Rotation.Yaw;

    // Draw player icon
    if (A != none)
    {
        // Set proper icon rotation
        if (DHGRI.OverheadOffset == 90)
            TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = pawnRotation - 32768;
        else if (DHGRI.OverheadOffset == 180)
            TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = pawnRotation - 49152;
        else if (DHGRI.OverheadOffset == 270)
            TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = pawnRotation;
        else
            TexRotator(FinalBlend(MapPlayerIcon.WidgetTexture).Material).Rotation.Yaw = pawnRotation - 16384;

        // Draw the player icon
        DrawIconOnMap(C, subCoords, MapPlayerIcon, myMapScale, A.Location, MapCenter);
    }

    // Overhead map debugging
    if (Level.NetMode == NM_Standalone && ROTeamGame(Level.Game).LevelInfo.bDebugOverhead)
    {
        DrawIconOnMap(C, subCoords, MapIconTeam[ALLIES_TEAM_INDEX], myMapScale, DHGRI.NorthEastBounds, MapCenter);
        DrawIconOnMap(C, subCoords, MapIconTeam[AXIS_TEAM_INDEX], myMapScale, DHGRI.SouthWestBounds, MapCenter);
    }

    // Draw timer
    DrawTextWidgetClipped(C, MapTimerTitle, MapCoords, XL, YL, YL_one);

    // Calculate seconds & minutes
    time = CurrentTime;
    MapTimerTexts[3].text = string(int(time % 10));
    time /= 10;
    MapTimerTexts[2].text = string(int(time % 6));
    time /= 6;
    MapTimerTexts[1].text = string(int(time % 10));
    time /= 10;
    MapTimerTexts[0].text = string(int(time));

    // Draw timer values
    C.Font = GetFontSizeIndex(C, -2);
    for (i = 0; i < 4; i++)
       DrawTextWidgetClipped(C, MapTimerTexts[i], MapCoords, XL, YL, YL_one);
    C.Font = GetSmallMenuFont(C);

    // Calc legend coords
    GetAbsoluteCoordinatesAlt(MapCoords, MapLegendCoords, subCoords);

    // Draw legend background
    //DrawSpriteWidgetClipped(C, MapLegend, subCoords, true);

    // Draw legend title
    DrawTextWidgetClipped(C, MapLegendTitle, subCoords, XL, YL, YL_one);

    // Draw legend elements
    LegendItemsIndex = 2; // no item at position #0 and #1 (reserved for title)
    DrawLegendElement(C, subCoords, MapIconTeam[AXIS_TEAM_INDEX], LegendAxisObjectiveText);
    DrawLegendElement(C, subCoords, MapIconTeam[ALLIES_TEAM_INDEX], LegendAlliesObjectiveText);
    if (bShowNeutralObj || bShowAllItemsInMapLegend)
        DrawLegendElement(C, subCoords, MapIconNeutral, LegendNeutralObjectiveText);
    if (bShowArtillery || bShowAllItemsInMapLegend)
        DrawLegendElement(C, subCoords, MapIconRadio, LegendArtilleryRadioText);
    if ((bShowArtillery || bShowAllItemsInMapLegend) && RI.bIsArtilleryOfficer)
        DrawLegendElement(C, subCoords, MapIconCarriedRadio, LegendCarriedArtilleryRadioText);
    if (bShowResupply || bShowAllItemsInMapLegend)
        DrawLegendElement(C, subCoords, MapIconResupply, LegendResupplyAreaText);
    if (bShowVehicleResupply)
        DrawLegendElement(C, subCoords, MapIconVehicleResupply, LegendResupplyAreaText);
    if (bShowRally || bShowAllItemsInMapLegend)
        if (OwnerTeam != 255)
            DrawLegendElement(C, subCoords, MapIconRally[OwnerTeam], LegendRallyPointText);
    if (bShowArtyCoords || bShowAllItemsInMapLegend)
    {
        widget = MapIconArtyStrike;
        widget.Tints[TeamIndex].A = 64;
        DrawLegendElement(C, subCoords, widget, LegendSavedArtilleryText);
        widget.Tints[TeamIndex].A = 255;
    }
    if (bShowArtyStrike || bShowAllItemsInMapLegend)
        DrawLegendElement(C, subCoords, MapIconArtyStrike, LegendArtyStrikeText);
    if (bShowMGResupplyRequest || bShowAllItemsInMapLegend)
        if (OwnerTeam != 255)
            DrawLegendElement(C, subCoords, MapIconMGResupplyRequest[OwnerTeam], LegendMGResupplyText);
    if (bShowHelpRequest || bShowAllItemsInMapLegend)
        DrawLegendElement(C, subCoords, MapIconHelpRequest, LegendHelpRequestText);
    if (bShowAttackDefendRequest || bShowAllItemsInMapLegend)
        DrawLegendElement(C, subCoords, MapIconAttackDefendRequest, LegendOrderTargetText);
    if (bShowDestroyableItems || bShowAllItemsInMapLegend)
        DrawLegendElement(C, subCoords, MapIconDestroyableItem, LegendDestroyableItemText);
    if (bShowDestroyedItems || bShowAllItemsInMapLegend)
        DrawLegendElement(C, subCoords, MapIconDestroyedItem, LegendDestroyedItemText);
    if (bShowATGun)
        DrawLegendElement(C, subCoords, MapIconATGun, LegendATGunText);

    // Calc objective text box coords
    GetAbsoluteCoordinatesAlt(MapCoords, MapObjectivesCoords, subCoords);

    // See if there are any secondary objectives
    for (i = 0; i < arraycount(DHGRI.Objectives); i++)
    {
        if (DHGRI.Objectives[i] == none || !DHGRI.Objectives[i].bActive)
            continue;

        if (!DHGRI.Objectives[i].bRequired)
        {
            bHasSecondaryObjectives=true;
            break;
        }
    }

    // Draw objective text box header
    if (bHasSecondaryObjectives)
    {
        DrawTextWidgetClipped(C, MapRequiredObjectivesTitle, subCoords, XL, YL, YL_one);
    }
    else
    {
        DrawTextWidgetClipped(C, MapObjectivesTitle, subCoords, XL, YL, YL_one);
    }
    MapObjectivesTexts.OffsetY = 0;

    // Draw objective texts
    objCount = 1;
    C.Font = GetSmallMenuFont(C);
    for (i = 0; i < arraycount(DHGRI.Objectives); i++)
    {
        if (DHGRI.Objectives[i] == none || !DHGRI.Objectives[i].bActive || !DHGRI.Objectives[i].bRequired)
            continue;

        if (DHGRI.Objectives[i].ObjState != OwnerTeam)
            MapObjectivesTexts.text = objCount $ ". " $ DHGRI.Objectives[i].AttackerDescription;
        else
            MapObjectivesTexts.text = objCount $ ". " $ DHGRI.Objectives[i].DefenderDescription;

        DrawTextWidgetClipped(C, MapObjectivesTexts, subCoords, XL, YL, YL_one);
        MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
        objCount++;
    }

    if (bHasSecondaryObjectives)
    {
        MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
        MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
        MapSecondaryObjectivesTitle.OffsetY = MapObjectivesTexts.OffsetY;
        DrawTextWidgetClipped(C, MapSecondaryObjectivesTitle, subCoords, XL, YL, YL_one);

        for (i = 0; i < arraycount(DHGRI.Objectives); i++)
        {
            if (DHGRI.Objectives[i] == none || !DHGRI.Objectives[i].bActive|| DHGRI.Objectives[i].bRequired)
                continue;

            if (DHGRI.Objectives[i].ObjState != OwnerTeam)
                MapObjectivesTexts.text = (SecondaryObjCount + 1) $ ". " $ DHGRI.Objectives[i].AttackerDescription;
            else
                MapObjectivesTexts.text = (SecondaryObjCount + 1) $ ". " $ DHGRI.Objectives[i].DefenderDescription;

            DrawTextWidgetClipped(C, MapObjectivesTexts, subCoords, XL, YL, YL_one);
            MapObjectivesTexts.OffsetY += YL + YL_one * 0.5;
            SecondaryObjCount++;
        }
    }

    // Draw 'objectives missing' if no objectives found -- for debug only
    if (objCount == 1)
    {
        MapObjectivesTexts.text = "(OBJECTIVES MISSING)";
        DrawTextWidgetClipped(C, MapObjectivesTexts, subCoords, XL, YL, YL_one);
    }

    // Draw the instruction header
    S = class'ROTeamGame'.static.ParseLoadingHintNoColor(SituationMapInstructionsText, PlayerController(Owner));
    C.DrawColor = WhiteColor;
    C.Font = GetLargeMenuFont(C);

    X = C.ClipX * 0.5;
    Y = C.ClipY * 0.01;

    C.TextSize(S, strX, strY);
    C.SetPos(X - strX / 2, Y);
    C.DrawTextClipped(S);
}

simulated function DrawLocationHits(Canvas C, ROPawn P)
{
    local int i, Team;
    local bool bNewDrawHits;
    local SpriteWidget widget;

    if (PawnOwner.PlayerReplicationInfo != none && PawnOwner.PlayerReplicationInfo.Team != none)
        Team = PawnOwner.PlayerReplicationInfo.Team.TeamIndex;
    else
        Team = 0;

    for (i = 0; i < arraycount(P.DamageList); i++)
    {
        if (P.DamageList[i] > 0)
        {
            // Draw hit
            widget = HealthFigure;
            if (Team == AXIS_TEAM_INDEX)
                widget.WidgetTexture = locationHitAxisImages[i];
            else if (Team == ALLIES_TEAM_INDEX)
                widget.WidgetTexture = locationHitAlliesImages[i];
            else
                continue;

            DrawSpriteWidget(C, widget);

            if (locationHitAlphas[i] > 0)
                bNewDrawHits = true;
        }
    }

    bDrawHits = bNewDrawHits;
}

simulated function UpdateHud()
{
    local ROGameReplicationInfo GRI;
    local class<Ammunition> AmmoClass;
    local Weapon W;
    //local float Time;
    local byte Nation;
    local ROPawn P;

    GRI = ROGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (PawnOwnerPRI != none)
    {
        if (PawnOwner != none)
        {
            P = ROPawn(PawnOwner);
            if (P != none)
            {
                // Set stamina info
                HealthFigureStamina.scale = 1 - P.Stamina / P.default.Stamina;
                HealthFigureStamina.Tints[0].G = 255 - HealthFigureStamina.scale * 255;
                HealthFigureStamina.Tints[1].G = 255 - HealthFigureStamina.scale * 255;
                HealthFigureStamina.Tints[0].B = 255 - HealthFigureStamina.scale * 255;
                HealthFigureStamina.Tints[1].B = 255 - HealthFigureStamina.scale * 255;

                // Set stance info
                if (P.bIsCrouched)
                    StanceIcon.WidgetTexture = StanceCrouch;
                else if (P.bIsCrawling)
                    StanceIcon.WidgetTexture = StanceProne;
                else
                    StanceIcon.WidgetTexture = StanceStanding;
            }
        }

        if (PawnOwnerPRI.Team != none && GRI != none)
        {
            Nation = GRI.NationIndex[PawnOwnerPRI.Team.TeamIndex];
            HealthFigure.WidgetTexture = NationHealthFigures[Nation];
            HealthFigureBackground.WidgetTexture = NationHealthFiguresBackground[Nation];
            if (HealthFigureStamina.scale > 0.9)
            {
                HealthFigureStamina.WidgetTexture = NationHealthFiguresStaminaCritical[Nation];
                HealthFigureStamina.Tints[0].G = 255; HealthFigureStamina.Tints[1].G = 255;
                HealthFigureStamina.Tints[0].B = 255; HealthFigureStamina.Tints[1].B = 255;
            }
            else
                HealthFigureStamina.WidgetTexture = NationHealthFiguresStamina[Nation];
        }
    }

    AmmoIcon.WidgetTexture = none; // This is so we don't show icon on binocs or when we have no weapon

    if (PawnOwner == none)
        return;

    W = PawnOwner.Weapon;
    if (W == none)
        return;

    AmmoClass = W.GetAmmoClass(0);

    if (AmmoClass == none)
        return;

    if (W.ItemName == "Scoped Enfield No.4")
        AmmoIcon.WidgetTexture = Texture'DH_InterfaceArt_tex.weapon_icons.EnfieldNo4Sniper_ammo';
    else if (W.ItemName == "Scoped Kar98k Rifle")
        AmmoIcon.WidgetTexture = Texture'DH_InterfaceArt_tex.weapon_icons.kar98Sniper_ammo';
    else
        AmmoIcon.WidgetTexture = AmmoClass.default.IconMaterial;

    AmmoCount.Value = W.GetHudAmmoCount();
}

simulated function DrawVoiceIcon(Canvas C, PlayerReplicationInfo PRI)
{
    local DH_Pawn   DHP;
    local ROVehicleWeaponPawn   ROVWP;
    local ROVehicle ROV;
    local DHGameReplicationInfo GRI;

    if(bShowVoiceIcon == false)
    {
        return;
    }

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    foreach RadiusActors(class'DH_Pawn', DHP, VOICE_ICON_DIST_MAX, PlayerOwner.Pawn.Location)   //100 feet
    {
        if(DHP.Health <= 0 || DHP.PlayerReplicationInfo != PRI)
        {
            continue;
        }

        DrawVoiceIconC(C, DHP);

        return;
    }

    foreach RadiusActors(class'ROVehicle', ROV, VOICE_ICON_DIST_MAX, PlayerOwner.Pawn.Location)
    {
        if( ROV.Driver == none || ROV.PlayerReplicationInfo != PRI)
        {
            continue;
        }

        DrawVoiceIconC(C, ROV.Driver);

        return;
    }

    foreach RadiusActors(class'ROVehicleWeaponPawn', ROVWP, VOICE_ICON_DIST_MAX, PlayerOwner.Pawn.Location)
    {
        if(ROVWP.Driver == none || ROVWP.PlayerReplicationInfo != PRI)
        {
            continue;
        }

        DrawVoiceIconC(C, ROVWP.Driver);

        return;
    }
}

simulated function DrawVoiceIconC(Canvas C, Pawn P)
{
    local byte Alpha;
    local float D, Df, Dm;
    local vector ScreenPosition, WorldLocation, PawnDirection, CameraLocation;
    local rotator CameraRotation;

    Dm = 1600.0;    //Distance maximum
    Df = Dm * 0.66; //Distance fallout

    //Get world location for icon placement.
    WorldLocation = P.GetBoneCoords(P.HeadBone).Origin + vect(0, 0, 32);

    //Get camera location and rotation, how handy!
    C.GetCameraLocation(CameraLocation, CameraRotation);

    //Get unnormalized direction from the player's eye to the world location,
    PawnDirection = WorldLocation - CameraLocation;

    //Ooh, distance.
    D = VSize(PawnDirection);

    //Too far away?  Don't bother.
    if (D > Dm)
        return;

    //Normalize pawn direction now for use.
    PawnDirection = Normal(PawnDirection);

    //Ensure we're not drawing icons from players behind us.
    if (Acos(PawnDirection dot vector(CameraRotation)) > 1.5705)
        return;

    ScreenPosition = C.WorldToScreen(WorldLocation);    //Get screen position

    Alpha = 255;

    if (D > Df)
        Alpha -= byte(((D - Df) / (Dm - Df)) * 255.0);

    VoiceIcon.PosX = ScreenPosition.X / C.ClipX;
    VoiceIcon.PosY = ScreenPosition.Y / C.ClipY;

    //if we can't see the icon from our current location, make it smaller and lighter.
    if (!FastTrace(WorldLocation, CameraLocation))
    {
        VoiceIcon.scale = 0.5;
        VoiceIcon.Tints[0].A = Alpha / 2;
    }
    else
    {
        VoiceIcon.scale = 0.5;
        VoiceIcon.Tints[0].A = Alpha;
    }

    DrawSpriteWidget(C, VoiceIcon);
}

//For disabling death messages from being displayed. -Colin
function DisplayMessages(Canvas C)
{
    local int i;
    local float X, Y, XL, YL, Scale, TimeOfDeath, FadeInBeginTime, FadeInEndTime;
    local float FadeOutBeginTime;
    local byte Alpha;

    super(HudBase).DisplayMessages(C);

    if (!bShowDeathMessages)
        return;

    while (DHObituaries[0].VictimName != "" && DHObituaries[0].EndOfLife < Level.TimeSeconds)
    {
        for (i = 1; i < ObituaryCount; i++)
            DHObituaries[i - 1] = DHObituaries[i];

        ObituaryCount--;
        DHObituaries[ObituaryCount].VictimName = "";
        DHObituaries[ObituaryCount].KillerName = "";
    }

    Scale = C.ClipX / 1600.0;

    C.Font = GetConsoleFont(C);

    Y = 8 * Scale;

    // Offset death msgs if we're displaying a hint
    if (bDrawHint)
        Y += 2 * Y + (HintCoords.Y + HintCoords.YL) * C.ClipY;

    for (i = 0; i < ObituaryCount; i++)
    {
        TimeOfDeath = DHObituaries[i].EndOfLife - ObituaryLifeSpan;
        FadeInBeginTime = TimeOfDeath + ObituaryDelayTime;
        FadeInEndTime = FadeInBeginTime + ObituaryFadeInTime;
        FadeOutBeginTime = DHObituaries[i].EndOfLife - ObituaryFadeInTime;

        //Death message delay and fade in
        //Basnett, 2011
        if (Level.TimeSeconds < FadeInBeginTime)
            continue;

        Alpha = 255;

        if (Level.TimeSeconds > FadeInBeginTime && Level.TimeSeconds < FadeInEndTime)
            Alpha = byte(((Level.TimeSeconds - FadeInBeginTime) / ObituaryFadeInTime) * 255.0);
        else if (Level.TimeSeconds > FadeOutBeginTime)
            Alpha = byte(Abs(255.0 - (((Level.TimeSeconds - FadeOutBeginTime) / ObituaryFadeInTime) * 255.0)));

        C.TextSize(DHObituaries[i].VictimName, XL, YL);

        X = C.ClipX - 8 * Scale - XL;

        C.SetPos(X, Y + 20 * Scale - YL * 0.5);
        C.DrawColor = DHObituaries[i].VictimColor;
        C.DrawColor.A = Alpha;
        C.DrawTextClipped(DHObituaries[i].VictimName);

        X -= 48 * Scale;

        C.SetPos(X, Y);
        C.DrawColor = WhiteColor;
        C.DrawColor.A = Alpha;
        C.DrawTileScaled(GetDamageIcon(DHObituaries[i].DamageType), Scale * 1.25, Scale * 1.25);

        if (DHObituaries[i].KillerName != "")
        {
            C.TextSize(DHObituaries[i].KillerName, XL, YL);
            X -= 8 * Scale + XL;

            C.SetPos(X, Y + 20 * Scale - YL * 0.5);
            C.DrawColor = DHObituaries[i].KillerColor;
            C.DrawColor.A = Alpha;
            C.DrawTextClipped(DHObituaries[i].KillerName);
        }

        Y += 44 * Scale;
    }
}

simulated function DrawCaptureBar(Canvas Canvas)
{
    local ROGameReplicationInfo GRI;
    local DH_Pawn p;
    local ROVehicle veh;
    local ROVehicleWeaponPawn pveh;
    local int team;
    local byte CurrentCapArea, CurrentCapProgress, CurrentCapAxisCappers, CurrentCapAlliesCappers, CurrentCapRequiredCappers;
    local float axis_progress, allies_progress;
    local float attackers_progress, attackers_ratio, defenders_progress, defenders_ratio;
    local float XL, YL, Y_pos;
    local string s;

    if (!bSetColour)
    {
       SetAlliedColour();
       //log("Running SAC from DrawCaptureBar");
    }

    bDrawingCaptureBar = false;

    // Don't draw if we have no associated pawn!
    if (PawnOwner == none)
        return;

    // Get capture info from associated pawn
    p = DH_Pawn(PawnOwner);

    if (p != none)
    {
        CurrentCapArea = (p.CurrentCapArea & 0X0F);
        CurrentCapProgress = p.CurrentCapProgress;
        CurrentCapAxisCappers = p.CurrentCapAxisCappers;
        CurrentCapAlliesCappers = p.CurrentCapAlliesCappers;
        CurrentCapRequiredCappers = (p.CurrentCapArea >> 4);
    }
    else
    {
        // Not a ROPawn, check if current pawn is a vehicle
        veh = ROVehicle(PawnOwner);
        if (veh != none)
        {
            CurrentCapArea = (veh.CurrentCapArea & 0X0F);
            CurrentCapProgress = veh.CurrentCapProgress;
            CurrentCapAxisCappers = veh.CurrentCapAxisCappers;
            CurrentCapAlliesCappers = veh.CurrentCapAlliesCappers;
            CurrentCapRequiredCappers = (veh.CurrentCapArea >> 4);
        }
        else
        {
            // Not a ROVehicle, check if current pawn is a ROVehicleWeaponPawn
            pveh = ROVehicleWeaponPawn(PawnOwner);
            if (pveh != none)
            {
                CurrentCapArea = (pveh.CurrentCapArea & 0X0F);
                CurrentCapProgress = pveh.CurrentCapProgress;
                CurrentCapAxisCappers = pveh.CurrentCapAxisCappers;
                CurrentCapAlliesCappers = pveh.CurrentCapAlliesCappers;
                CurrentCapRequiredCappers = (pveh.CurrentCapArea >> 4);
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
        return;

    // Get GRI
    GRI = ROGameReplicationInfo(PlayerOwner.GameReplicationInfo);
    if (GRI == none)
        return; // Can't draw without a gri!

    // Get current team
    if (PawnOwner.PlayerReplicationInfo != none && PawnOwner.PlayerReplicationInfo.Team != none)
        team = PawnOwner.PlayerReplicationInfo.Team.TeamIndex;
    else
        team = 0;

    // Get current cap progress on a 0-1 scale for each team
    if (CurrentCapProgress == 0)
    {
        if (GRI.Objectives[CurrentCapArea].ObjState == NEUTRAL_TEAM_INDEX)
        {
            allies_progress = 0;
            axis_progress = 0;
        }
        else if (GRI.Objectives[CurrentCapArea].ObjState == AXIS_TEAM_INDEX)
        {
            allies_progress = 0;
            axis_progress = 1;
        }
        else
        {
            allies_progress = 1;
            axis_progress = 0;
        }
    }
    else if (CurrentCapProgress > 100)
    {
        allies_progress = float(CurrentCapProgress - 100) / 100.0;
        if (GRI.Objectives[CurrentCapArea].ObjState != NEUTRAL_TEAM_INDEX)
            axis_progress = 1 - allies_progress;
    }
    else
    {
        axis_progress = float(CurrentCapProgress) / 100.0;
        if (GRI.Objectives[CurrentCapArea].ObjState != NEUTRAL_TEAM_INDEX)
            allies_progress = 1 - axis_progress;
    }

    // Assign those progress to defender or attacker, depending on current team
    if (team == AXIS_TEAM_INDEX)
    {
        attackers_progress = axis_progress;
        defenders_progress = allies_progress;
        CaptureBarAttacker.Tints[TeamIndex] = CaptureBarTeamColors[AXIS_TEAM_INDEX];
        CaptureBarAttackerRatio.Tints[TeamIndex] = CaptureBarTeamColors[AXIS_TEAM_INDEX];
        CaptureBarDefender.Tints[TeamIndex] = CaptureBarTeamColors[ALLIES_TEAM_INDEX];
        CaptureBarDefenderRatio.Tints[TeamIndex] = CaptureBarTeamColors[ALLIES_TEAM_INDEX];
        CaptureBarIcons[0].WidgetTexture = CaptureBarTeamIcons[AXIS_TEAM_INDEX];
        CaptureBarIcons[1].WidgetTexture = CaptureBarTeamIcons[ALLIES_TEAM_INDEX];

        // Figure ratios
        if (CurrentCapAlliesCappers == 0)
            attackers_ratio = 1;
        else if (CurrentCapAxisCappers == 0)
            attackers_ratio = 0;
        else
            attackers_ratio = float(CurrentCapAxisCappers) / (CurrentCapAxisCappers + CurrentCapAlliesCappers);
        defenders_ratio = 1 - attackers_ratio;
    }
    else
    {
        attackers_progress = allies_progress;
        defenders_progress = axis_progress;
        CaptureBarAttacker.Tints[TeamIndex] = CaptureBarTeamColors[ALLIES_TEAM_INDEX];
        CaptureBarAttackerRatio.Tints[TeamIndex] = CaptureBarTeamColors[ALLIES_TEAM_INDEX];
        CaptureBarDefender.Tints[TeamIndex] = CaptureBarTeamColors[AXIS_TEAM_INDEX];
        CaptureBarDefenderRatio.Tints[TeamIndex] = CaptureBarTeamColors[AXIS_TEAM_INDEX];
        CaptureBarIcons[0].WidgetTexture = CaptureBarTeamIcons[ALLIES_TEAM_INDEX];
        CaptureBarIcons[1].WidgetTexture = CaptureBarTeamIcons[AXIS_TEAM_INDEX];

        // Figure ratios
        if (CurrentCapAxisCappers == 0)
            attackers_ratio = 1;
        else if (CurrentCapAlliesCappers == 0)
            attackers_ratio = 0;
        else
            attackers_ratio = float(CurrentCapAlliesCappers) / (CurrentCapAxisCappers + CurrentCapAlliesCappers);
        defenders_ratio = 1 - attackers_ratio;
    }

    // Draw capture bar at 50% faded if we're at a stalemate
    if (CurrentCapAxisCappers == CurrentCapAlliesCappers)
    {
        CaptureBarAttacker.Tints[TeamIndex].A /= 2;
        CaptureBarDefender.Tints[TeamIndex].A /= 2;
    }

    // Convert attacker/defender progress to widget scale
    // (bar goes from 53 to 203, total width of texture is 256)
    CaptureBarAttacker.Scale = 150.0 / 256.0 * attackers_progress + 53.0 / 256.0;
    CaptureBarDefender.Scale = 150.0 / 256.0 * defenders_progress + 53.0 / 256.0;

    // Convert attacker/defender ratios to widget scale
    // (bar goes from 63 to 193, total width of texture is 256)
    CaptureBarAttackerRatio.Scale = 130.0 / 256.0 * attackers_ratio + 63.0 / 256.0;
    CaptureBarDefenderRatio.Scale = 130.0 / 256.0 * defenders_ratio + 63.0 / 256.0;

    // Check which icon to show on right side
    if (attackers_progress ~= 1.0)
        CaptureBarIcons[1].WidgetTexture = CaptureBarIcons[0].WidgetTexture;

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
    if (!(defenders_progress ~= 0.0) || (attackers_progress ~= 1.0))
        DrawSpriteWidget(Canvas, CaptureBarIcons[1]);

    // Draw the objective name
    Y_pos = Canvas.ClipY * CaptureBarBackground.PosY
        - (CaptureBarBackground.TextureCoords.Y2 + 1 + 4)
            * CaptureBarBackground.TextureScale * HudScale * ResScaleY;
    s = GRI.Objectives[CurrentCapArea].ObjName;

    // Add a display for the number of cappers in vs. the amount needed to capture.
    if (CurrentCapRequiredCappers > 1)
    {
        //Displayed when the cap is neutral, the other team completely owns the cap, or there are enemy capturers.
        if (team == 0 && (GRI.Objectives[CurrentCapArea].ObjState == 2 || axis_progress != 1.0 || CurrentCapAlliesCappers != 0))
        {
            if (CurrentCapAxisCappers < CurrentCapRequiredCappers)
            {
                CaptureBarAttacker.Tints[TeamIndex].A /= 2;
                CaptureBarDefender.Tints[TeamIndex].A /= 2;
            }

            s @= "(" $ CurrentCapAxisCappers @ "/" @ CurrentCapRequiredCappers $ ")";
        }
        else if (team == 1 && (GRI.Objectives[CurrentCapArea].ObjState == 2 || allies_progress != 1.0 || CurrentCapAxisCappers != 0))
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
    Canvas.SetPos(Canvas.ClipX * CaptureBarBackground.PosX - XL / 2.0, Y_pos - YL);
    Canvas.DrawText(s);

    // Add signal so that vehicle passenger list knows to shift text up
    bDrawingCaptureBar = true;
}

// Modified to fix a bug that spams thousands of "accessed none" errors to log, if there is a missing objective number in the array
simulated function UpdateMapIconLabelCoords(FloatBox label_coords, ROGameReplicationInfo GRI, int current_obj)
{
    local  int    i, count;
    local  float  new_y;

    // Do not update label coords if it's disabled in the objective
    if (GRI.Objectives[current_obj].bDoNotUseLabelShiftingOnSituationMap)
    {
        GRI.Objectives[current_obj].LabelCoords = label_coords;
        return;
    }

    if (current_obj == 0)
    {
        // Set label position to be same as tested position
        GRI.Objectives[0].LabelCoords = label_coords;
        return;
    }

    for (i = 0; i < current_obj; i++)
    {
        if (GRI.Objectives[i] == none) // Matt: added to avoid spamming "accessed none" errors
        {
            continue;
        }

        // Check if there's overlap in the X axis
        if (!(label_coords.X2 <= GRI.Objectives[i].LabelCoords.X1 || label_coords.X1 >= GRI.Objectives[i].LabelCoords.X2))
        {
            // There's overlap! Check if there's overlap in the Y axis.
            if (!(label_coords.Y2 <= GRI.Objectives[i].LabelCoords.Y1 || label_coords.Y1 >= GRI.Objectives[i].LabelCoords.Y2))
            {
                // There's overlap on both axis: the label overlaps. Update the position of the label.
                new_y = GRI.Objectives[i].LabelCoords.Y2 - (label_coords.Y2 - label_coords.Y1) * 0.00;
                label_coords.Y2 = new_y + label_coords.Y2 - label_coords.Y1;
                label_coords.Y1 = new_y;

                i = -1; // this is to force rechecking of all possible overlaps to ensure that no other label overlaps with this

                // Safety
                count++;

                if (count > current_obj * 5)
                {
                    break;
                }
            }
        }

    }

    // Set new label position
    GRI.Objectives[current_obj].LabelCoords = label_coords;
}

// Matt: modified so if player is in a vehicle, the keybinds to GrowHUD & ShrinkHUD will call same named functions in the vehicle classes
// When player is in a vehicle these functions do nothing to the HUD, but they can be used to add useful custom functionality to vehicles, especially as keys are -/+ by default
exec function GrowHUD()
{
    if (PawnOwner != none && PawnOwner.IsA('Vehicle'))
    {
        if (PawnOwner.IsA('DH_ROTreadCraft'))
        {
            DH_ROTreadCraft(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DH_ROWheeledVehicle'))
        {
            DH_ROWheeledVehicle(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DH_ROTankCannonPawn'))
        {
            DH_ROTankCannonPawn(PawnOwner).GrowHUD();
        }
        else if (PawnOwner.IsA('DH_ROMountedTankMGPawn'))
        {
            DH_ROMountedTankMGPawn(PawnOwner).GrowHUD();
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
        if (PawnOwner.IsA('DH_ROTreadCraft'))
        {
            DH_ROTreadCraft(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DH_ROWheeledVehicle'))
        {
            DH_ROWheeledVehicle(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DH_ROTankCannonPawn'))
        {
            DH_ROTankCannonPawn(PawnOwner).ShrinkHUD();
        }
        else if (PawnOwner.IsA('DH_ROMountedTankMGPawn'))
        {
            DH_ROMountedTankMGPawn(PawnOwner).ShrinkHUD();
        }
    }
    else
    {
        super.ShrinkHUD();
    }
}

defaultproperties
{
     VehicleAltAmmoReloadIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.20,DrawPivot=DP_LowerLeft,PosX=0.25,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Up,Scale=1.0,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=0,B=0,A=128),Tints[1]=(R=255,G=0,B=0,A=128))
     VehicleMGAmmoReloadIcon=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=127,Y2=127),TextureScale=0.30,DrawPivot=DP_LowerLeft,PosX=0.15,PosY=1.0,OffsetX=0,OffsetY=-8,ScaleMode=SM_Up,Scale=0.75,RenderStyle=STY_Alpha,Tints[0]=(R=255,G=0,B=0,A=128),Tints[1]=(R=255,G=0,B=0,A=128))
     MapIconCarriedRadio=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X1=64,Y1=192,X2=127,Y2=255),TextureScale=0.050000,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     CanMantleIcon=(WidgetTexture=Texture'DH_GUI_Tex.GUI.CanMantle',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=127),TextureScale=0.800000,DrawPivot=DP_LowerMiddle,PosX=0.550000,PosY=0.980000,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     VoiceIcon=(WidgetTexture=Texture'DH_InterfaceArt_tex.Communication.Voice',RenderStyle=STY_Alpha,TextureCoords=(X2=63,Y2=63),TextureScale=0.500000,DrawPivot=DP_MiddleMiddle,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     MapIconMortarTarget=(WidgetTexture=Texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(X2=63,Y2=64),TextureScale=0.050000,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.000000,Tints[0]=(R=255,A=255),Tints[1]=(R=255,A=255))
     MapIconMortarHit=(WidgetTexture=Texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons',RenderStyle=STY_Alpha,TextureCoords=(Y1=64,X2=63,Y2=127),TextureScale=0.050000,DrawPivot=DP_LowerMiddle,ScaleMode=SM_Left,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     LegendCarriedArtilleryRadioText="Artillery Radioman"
     NeedReloadText="Needs reloading"
     CanReloadText="Press %THROWMGAMMO% to assist reload"
     PlayerNameFontSize=4
     bShowDeathMessages=true
     bShowVoiceIcon=true
     ObituaryFadeInTime=0.500000
     ObituaryDelayTime=5.000000
     LegendArtilleryRadioText="Artillery Radio"
     SideColors(0)=(B=80,G=80,R=200)
     SideColors(1)=(B=75,G=150,R=80)
     ResupplyZoneNormalPlayerIcon=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons')
     ResupplyZoneNormalVehicleIcon=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons')
     ResupplyZoneResupplyingPlayerIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash')
     ResupplyZoneResupplyingVehicleIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash')
     NationHealthFigures(1)=Texture'DH_GUI_Tex.GUI.US_player'
     NationHealthFiguresBackground(1)=Texture'DH_GUI_Tex.GUI.US_player_background'
     NationHealthFiguresStamina(1)=Texture'DH_GUI_Tex.GUI.US_player_Stamina'
     NationHealthFiguresStaminaCritical(1)=FinalBlend'DH_GUI_Tex.GUI.US_player_Stamina_critical'
     PlayerArrowTexture=FinalBlend'DH_GUI_Tex.GUI.PlayerIcon_final'
     ObituaryLifeSpan=8.500000
     MapIconsFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_Icons_flashing'
     MapIconsFastFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_fast_flash'
     MapIconsAltFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_alt_flashing'
     MapIconsAltFastFlash=FinalBlend'DH_GUI_Tex.GUI.overheadmap_icons_alt_fast_flash'
     MapBackground=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_background')
     MapPlayerIcon=(WidgetTexture=FinalBlend'DH_GUI_Tex.GUI.PlayerIcon_final',Tints[0]=(G=110))
     MapIconTeam(0)=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons')
     MapIconTeam(1)=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons')
     MapIconRally(0)=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons')
     MapIconRally(1)=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons')
     MapIconMGResupplyRequest(0)=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons')
     MapIconMGResupplyRequest(1)=(WidgetTexture=Texture'DH_GUI_Tex.GUI.overheadmap_Icons')
     locationHitAlliesImages(0)=Texture'DH_GUI_Tex.Player_hits.US_hit_Head'
     locationHitAlliesImages(1)=Texture'DH_GUI_Tex.Player_hits.US_hit_torso'
     locationHitAlliesImages(2)=Texture'DH_GUI_Tex.Player_hits.US_hit_pelvis'
     locationHitAlliesImages(3)=Texture'DH_GUI_Tex.Player_hits.US_hit_LupperLeg'
     locationHitAlliesImages(4)=Texture'DH_GUI_Tex.Player_hits.US_hit_RupperLeg'
     locationHitAlliesImages(5)=Texture'DH_GUI_Tex.Player_hits.US_hit_LupperArm'
     locationHitAlliesImages(6)=Texture'DH_GUI_Tex.Player_hits.US_hit_RupperArm'
     locationHitAlliesImages(7)=Texture'DH_GUI_Tex.Player_hits.US_hit_LlowerLeg'
     locationHitAlliesImages(8)=Texture'DH_GUI_Tex.Player_hits.US_hit_RlowerLeg'
     locationHitAlliesImages(9)=Texture'DH_GUI_Tex.Player_hits.US_hit_LlowerArm'
     locationHitAlliesImages(10)=Texture'DH_GUI_Tex.Player_hits.US_hit_RlowerArm'
     locationHitAlliesImages(11)=Texture'DH_GUI_Tex.Player_hits.US_hit_LHand'
     locationHitAlliesImages(12)=Texture'DH_GUI_Tex.Player_hits.US_hit_RHand'
     locationHitAlliesImages(13)=Texture'DH_GUI_Tex.Player_hits.US_hit_Lfoot'
     locationHitAlliesImages(14)=Texture'DH_GUI_Tex.Player_hits.US_hit_Rfoot'
     MouseInterfaceIcon=(WidgetTexture=Texture'DH_GUI_Tex.Menu.DHPointer')
     CaptureBarTeamIcons(0)=Texture'DH_GUI_Tex.GUI.GerCross'
     CaptureBarTeamIcons(1)=Texture'DH_GUI_Tex.GUI.AlliedStar'
     CaptureBarTeamColors(0)=(B=30,G=43,R=213)
     CaptureBarTeamColors(1)=(B=35,G=150,R=40)
     VOICE_ICON_DIST_MAX = 2624.672119
     TeamMessagePrefix="*TEAM* "
}
