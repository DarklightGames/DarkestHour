//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHServerLoading extends UT2K4ServerLoading;

#EXEC OBJ LOAD FILE=DH_GUI_Tex.utx

var localized string DeployingText;
var localized string AuthorText;
var localized string VACSecuredText;
var localized string OfficialMapText;
var localized string CommunityMapText;
var localized string UnspecifiedText;

var Material VACIcon;
var Material OfficialMapIcon;
var Material CommunityMapIcon;

var CacheManager.MapRecord LoadingMapRecord;

simulated event Init()
{
    LoadingMapRecord = class'CacheManager'.static.GetMapRecord(MapName);

    // Calls the base background and text functions (should be after we get the mapRecord)
    super.Init();

    // Draws VAC icon if bVACSecured
    //if (bVACSecured)
    //{
        DrawOpImage(Operations[4]).Image = VACIcon;
        DrawOpText(Operations[5]).Text = VACSecuredText;
    //}
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

    DrawOpText(Operations[8]).Text = Repl(AuthorText, "{0}", Author, false);
    DrawOpText(Operations[2]).Text = Repl(DeployingText, "{0}", Map, false);
    DrawOpText(Operations[1]).Text = "";
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

    M = Material(DynamicLoadObject("myLevel.GUI.LoadingScreen", class'Material'));

    if (!M.Validated)
    {
        // mat must have failed to create from ExtraInfo string
        M = DLOTexture(Backgrounds[0]);
    }

    if (class'DHMapList'.static.IsMapOfficial(LoadingMapRecord.MapName))
    {
        DrawOpImage(Operations[6]).Image = OfficialMapIcon;
        DrawOpText(Operations[7]).Text = OfficialMapText;
    }
    else
    {
        DrawOpImage(Operations[6]).Image = CommunityMapIcon;
        DrawOpText(Operations[7]).Text = CommunityMapText;
    }

    // Draw the background loading screen
    DrawOpImage(Operations[0]).Image = M;
}

defaultproperties
{
    DeployingText="Deploying to {0}"
    AuthorText="Author: {0}"
    OfficialMapText="Official Map"
    OfficialMapIcon=texture'DH_GUI_Tex.Menu.OfficialMapLogo'
    CommunityMapText="Community Map"
    CommunityMapIcon=texture'DH_GUI_Tex.Menu.CommunityMapLogo'

    // The official backgrounds
    Backgrounds(0)="DH_GUI_Tex.LoadingScreens.LoadingScreenDHDefault"
    Operations(2)=RODrawOpShadowedText'ROInterface.ROServerLoading.OpMapname'
    Operations(4)=DrawOpImage'ROInterface.ROServerLoading.OpVACImg'
    Operations(5)=RODrawOpShadowedText'ROInterface.ROServerLoading.OpVACText'

    Begin Object class=DrawOpImage Name=OpConstitutionImg
        Top=0.015
        Lft=0.685
        Width=0.045
        Height=0.066
        DrawColor=(R=255,B=255,G=255,A=255)
        SubXL=128
        SubYL=128
    End Object
    Operations(6)=OpConstitutionImg

    Begin Object class=RODrawOpShadowedText Name=OpConstitutionText
        Top=0.02
        Lft=0.735
        Height=0.05
        Width=0.32
        Justification=2
        VertAlign=1
        FontName="ROInterface.fntROMainMenu"
    End Object
    Operations(7)=OpConstitutionText

    Begin Object class=RODrawOpShadowedText Name=OpMapAuthorText
        Top=0.02
        Lft=0.05
        Height=0.05
        Width=0.32
        Justification=0
        VertAlign=1
        FontName="ROInterface.fntROMainMenu"
    End Object
    Operations(8)=OpMapAuthorText
}
