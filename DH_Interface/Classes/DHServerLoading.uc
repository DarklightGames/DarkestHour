//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHServerLoading extends UT2K4ServerLoading;

#EXEC OBJ LOAD FILE=DH_GUI_Tex.utx

var localized string DeployingText;
var localized string AuthorText;
var localized string LegacyMapText;
var localized string OfficialMapText;
var localized string CommunityMapText;
var localized string UnspecifiedText;
var localized string EnabledText;
var localized string DisabledText;
var localized string GameTypeText;

var Material DHTextLogo;
var Material OfficialMapIcon;
var Material CommunityMapIcon;
var Material DefaultControlsImage;

var CacheManager.MapRecord LoadingMapRecord;

simulated event Init()
{
    LoadingMapRecord = class'CacheManager'.static.GetMapRecord(MapName);

    // Calls the base background and text functions (should be after we get the mapRecord)
    super.Init();
}

simulated function SetText()
{
    local string Map;
    local string Author;
    local string GameType;
    local bool bRallyConstructionsEnabled;

    Map = StripMap(MapName);
    Map = StripPrefix(Map);
    Map = AddSpaces(Map);

    Author = LoadingMapRecord.Author;

    if (Author == "")
    {
        Author = default.UnspecifiedText;
    }

    if (InStr(MapName, "_Advance") >= 0)
    {
        GameType = class'DHGameType_Advance'.default.GameTypeName;
        bRallyConstructionsEnabled = true;
    }
    else if (InStr(MapName, "_Push") >= 0)
    {
        GameType = class'DHGameType_Push'.default.GameTypeName;
    }
    else if (InStr(MapName, "_Cutoff") >= 0)
    {
        GameType = class'DHGameType_Cutoff'.default.GameTypeName;
    }
    else if (InStr(MapName, "_Armoured") >= 0)
    {
        GameType = class'DHGameType_Armoured'.default.GameTypeName;
    }
    else
    {
        GameType = class'DHGameType_Push'.default.GameTypeName;
    }

    if (bRallyConstructionsEnabled)
    {
        DrawOpText(Operations[11]).Text = EnabledText;
        DrawOpText(Operations[11]).DrawColor = class'DHColor'.default.SquadColor;
        DrawOpText(Operations[12]).Text = EnabledText;
        DrawOpText(Operations[12]).DrawColor = class'DHColor'.default.SquadColor;
    }
    else
    {
        DrawOpText(Operations[11]).Text = DisabledText;
        DrawOpText(Operations[11]).DrawColor = class'DHColor'.default.RedEnemy;
        DrawOpText(Operations[12]).Text = DisabledText;
        DrawOpText(Operations[12]).DrawColor = class'DHColor'.default.RedEnemy;
    }

    DrawOpText(Operations[10]).Text = Repl(GameTypeText, "{0}", GameType, false);
    DrawOpText(Operations[7]).Text = Repl(AuthorText, "{0}", Author, false);
    DrawOpText(Operations[4]).Text = Repl(DeployingText, "{0}", Map, false);
}

simulated function string AddSpaces(string S)
{
    local string Result, Char, LastChar;
    local int LastPos, Pos;

    S = Repl(S, "_", " ", false);

    if (Len(S) <= 1)
    {
        return S;
    }

    LastPos = 0;

    while (Pos < Len(S))
    {
        Char = Mid(S, Pos, 1);

        if (Caps(Char) == Char && Locs(Char) != Char && LastChar != " " && LastChar != "-")
        {
            if (Result != "")
            {
                Result $= " ";
            }

            Result $= Mid(S, LastPos, Pos - LastPos);

            LastPos = Pos;
        }

        ++Pos;

        LastChar = Char;
    }

    if (LastPos != Pos)
    {
        if (Result != "")
        {
            Result $= " ";
        }

        Result $= Mid(S, LastPos, Pos - LastPos);
    }

    return Result;
}

simulated function string StripPrefix(string S)
{
    if (Left(S, 3) ~= "dh-" && Len(S) > 3)
    {
        return Right(S, Len(S) - 3);
    }

    return S;
}

simulated function SetImage()
{
    local Material M;

    M = Material'MenuBlack';

    DrawOpImage(Operations[0]).Image = M;

    M = material(DynamicLoadObject(MapName $ ".GUI.LoadingScreen", class'Material'));

    if (M == none)
    {
        M = DLOTexture(Backgrounds[0]);
    }

    if (class'DHMapList'.static.IsMapOfficial(LoadingMapRecord.MapName))
    {
        DrawOpImage(Operations[5]).Image = OfficialMapIcon;
    }
    else if (class'DHMapList'.static.IsMapLegacy(LoadingMapRecord.MapName))
    {
        DrawOpImage(Operations[5]).Image = OfficialMapIcon;
    }
    else
    {
        DrawOpImage(Operations[5]).Image = CommunityMapIcon;
    }

    DrawOpText(Operations[6]).Text = class'DHMapList'.static.GetMapSource(LoadingMapRecord.MapName $ ".rom");

    DrawOpImage(Operations[0]).Image = M;
}

defaultproperties
{
    GameTypeText="Game Type: {0}"
    EnabledText="Enabled"
    DisabledText="Disabled"
    DeployingText="Deploying to {0}"
    AuthorText="Author: {0}"
    LegacyMapText="Legacy Map"
    OfficialMapText="Official Map"
    OfficialMapIcon=Texture'DH_GUI_Tex.Menu.OfficialMapLogo'
    CommunityMapText="Community Map"
    CommunityMapIcon=Texture'DH_GUI_Tex.Menu.CommunityMapLogo'
    DHTextLogo=Texture'DH_GUI_Tex.Menu.DHTextLogo'

    // The official backgrounds
    Backgrounds(0)="DH_GUI_Tex.LoadingScreen.Background_Default"

    Begin Object class=DrawOpImage Name=OpTopBorder
        Image=Texture'DH_GUI_Tex.Menu.DHSectionTopper'
        ImageStyle=0
        Top=0.0
        Lft=0.0
        Width=1.0
        Height=0.09
        DrawColor=(R=255,B=255,G=255,A=255)
    End Object
    Operations(1)=OpTopBorder

    Begin Object class=DrawOpImage Name=OpBottomBorder
        Image=Texture'DH_GUI_Tex.Menu.DHSectionTopper'
        ImageStyle=0
        Top=0.91
        Lft=0.0
        Width=1.0
        Height=0.09
        DrawColor=(R=255,B=255,G=255,A=255)
    End Object
    Operations(2)=OpBottomBorder

    Begin Object class=DrawOpImage Name=OpDHTextLogoImg
        Image=Texture'DH_GUI_Tex.Menu.DHTextLogo'
        ImageStyle=0
        Top=0.1
        Lft=0.0
        Width=0.4
        Height=0.15
        DrawColor=(R=255,B=255,G=255,A=255)
    End Object
    Operations(3)=OpDHTextLogoImg

    Begin Object class=DrawOpText Name=OpLoading
        Top=0.93
        Lft=0.05
        Height=0.05
        Width=0.9
        Justification=0
        FontName="ROInterface.fntROMainMenu""
        bWrapText=false
    End Object
    Operations(4)=OpLoading

    Begin Object class=DrawOpImage Name=OpConstitutionImg
        ImageStyle=0
        Top=0.01
        Lft=0.685
        Width=0.05
        Height=0.07
        DrawColor=(R=255,B=255,G=255,A=255)
        SubXL=128
        SubYL=128
    End Object
    Operations(5)=OpConstitutionImg

    Begin Object class=RODrawOpShadowedText Name=OpConstitutionText
        Top=0.02
        Lft=0.735
        Height=0.05
        Width=0.32
        Justification=0
        VertAlign=1
        FontName="ROInterface.fntROMainMenu"
    End Object
    Operations(6)=OpConstitutionText

    Begin Object class=RODrawOpShadowedText Name=OpMapAuthorText
        Top=0.02
        Lft=0.05
        Height=0.05
        Width=0.32
        Justification=0
        VertAlign=1
        FontName="ROInterface.fntROMainMenu"
    End Object
    Operations(7)=OpMapAuthorText

    Begin Object class=DrawOpImage Name=OpDefaultControlsImg
        Image=Texture'DH_GUI_Tex.Menu.default_keys_2048'
        ImageStyle=0
        Top=0.5
        Lft=0.05
        Width=0.9
        Height=0.4
        DrawColor=(R=200,B=200,G=200,A=220)
    End Object
    Operations(8)=OpDefaultControlsImg

    Begin Object class=RODrawOpShadowedText Name=OpDefaultControlsText
        Text="New Default Controls"
        Top=0.45
        Lft=0.1
        Height=0.05
        Width=0.25
        MaxLines=1
        Justification=0
        VertAlign=1
        FontName="ROInterface.fntROMainMenu"
    End Object
    Operations(9)=OpDefaultControlsText

    Begin Object class=RODrawOpShadowedText Name=OpGameTypeText
        DrawColor=(R=255,G=50,B=50,A=255)
        Top=0.14
        Lft=0.5
        Height=0.05
        Width=0.48
        MaxLines=1
        Justification=2
        VertAlign=1
        FontName="ROInterface.fntROMainMenu"
    End Object
    Operations(10)=OpGameTypeText

    Begin Object class=RODrawOpShadowedText Name=OpRalliesEnabledText
        Top=0.21
        Lft=0.5
        Height=0.05
        Width=0.48
        MaxLines=1
        Justification=2
        VertAlign=1
        FontName="ROInterface.fntROMainMenu"
    End Object
    Operations(11)=OpRalliesEnabledText

    Begin Object class=RODrawOpShadowedText Name=OpConstructionsEnabledText
        Top=0.26
        Lft=0.5
        Height=0.05
        Width=0.48
        MaxLines=1
        Justification=2
        VertAlign=1
        FontName="ROInterface.fntROMainMenu"
    End Object
    Operations(12)=OpConstructionsEnabledText

    Begin Object class=DrawOpImage Name=OpRallyIconImg
        Image=Texture'DH_InterfaceArt2_tex.Icons.rally_point'
        ImageStyle=0
        Top=0.205
        Lft=0.85
        Width=0.04
        Height=0.05
        DrawColor=(R=255,B=255,G=255,A=255)
    End Object
    Operations(13)=OpRallyIconImg

    Begin Object class=DrawOpImage Name=OpConstructionIconImg
        Image=Texture'DH_InterfaceArt2_tex.Icons.Construction'
        ImageStyle=0
        Top=0.255
        Lft=0.85
        Width=0.04
        Height=0.05
        DrawColor=(R=255,B=255,G=255,A=255)
    End Object
    Operations(14)=OpConstructionIconImg

}
