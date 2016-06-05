//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHServerLoading extends UT2K4ServerLoading;

#EXEC OBJ LOAD FILE=DH_GUI_Tex.utx

var localized string DeployingText;
var localized string AuthorText;
var localized string LegacyMapText;
var localized string OfficialMapText;
var localized string CommunityMapText;
var localized string UnspecifiedText;

var Material DHTextLogo;
var Material VACIcon;
var Material OfficialMapIcon;
var Material CommunityMapIcon;

var CacheManager.MapRecord LoadingMapRecord;

simulated event Init()
{
    LoadingMapRecord = class'CacheManager'.static.GetMapRecord(MapName);

    // Calls the base background and text functions (should be after we get the mapRecord)
    super.Init();

    if (bVACSecured)
    {
        DrawOpImage(Operations[9]).Image = VACIcon;
    }
}

simulated function SetText()
{
    local string Map;
    local string Author;

    Map = StripMap(MapName);
    Map = StripPrefix(Map);
    Map = AddSpaces(Map);

    Author = LoadingMapRecord.Author;

    if (Author == "")
    {
        Author = default.UnspecifiedText;
    }

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

    M = Material(DynamicLoadObject(MapName $ ".GUI.LoadingScreen", class'Material'));

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
    vacIcon=texture'InterfaceArt_tex.ServerIcons.VAC_protected'

    DeployingText="Deploying to {0}"
    AuthorText="Author: {0}"
    LegacyMapText="Legacy Map"
    OfficialMapText="Official Map"
    OfficialMapIcon=texture'DH_GUI_Tex.Menu.OfficialMapLogo'
    CommunityMapText="Community Map"
    CommunityMapIcon=texture'DH_GUI_Tex.Menu.CommunityMapLogo'
    DHTextLogo=texture'DH_GUI_Tex.Menu.DHTextLogo'

    // The official backgrounds
    Backgrounds(0)="DH_GUI_Tex.LoadingScreen.Background_Default"

    Begin Object class=DrawOpImage Name=OpTopBorder
        Image=texture'DH_GUI_Tex.Menu.DHSectionTopper'
        ImageStyle=0
        Top=0.0
        Lft=0.0
        Width=1.0
        Height=0.09
        DrawColor=(R=255,B=255,G=255,A=255)
    End Object
    Operations(1)=OpTopBorder

    Begin Object class=DrawOpImage Name=OpBottomBorder
        Image=texture'DH_GUI_Tex.Menu.DHSectionTopper'
        ImageStyle=0
        Top=0.91
        Lft=0.0
        Width=1.0
        Height=0.09
        DrawColor=(R=255,B=255,G=255,A=255)
    End Object
    Operations(2)=OpBottomBorder

    Begin Object class=DrawOpImage Name=OpDHTextLogoImg
        Image=texture'DH_GUI_Tex.Menu.DHTextLogo'
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
        bWrapText=False
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

    Begin Object Class=DrawOpImage Name=OpVACImg
        Top=0.895
        Lft=0.45
        Width=0.05
        Height=0.066
        DrawColor=(R=255,B=255,G=255,A=255)
        SubXL=128
        SubYL=128
    End Object
    Operations(8)=OpVACImg
}
