//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHServerLoading extends UT2K4ServerLoading;

#EXEC OBJ LOAD FILE=DH_GUI_Tex.utx

var localized string DeployingText;
var localized string AuthorText;
var localized string UnspecifiedText;

var Material DHTextLogo;
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

    Map = StripMap(MapName);
    Map = StripPrefix(Map);
    Map = AddSpaces(Map);

    Author = LoadingMapRecord.Author;

    if (Author == "")
    {
        Author = default.UnspecifiedText;
    }

    DrawOpText(Operations[5]).Text = Repl(AuthorText, "{0}", Author, false);
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

        // If using default background, the borders should be blacked out
        DrawOpImage(Operations[1]).Image = Material'MenuBlack';
        DrawOpImage(Operations[2]).Image = Material'MenuBlack';
    }
    else
    {
        // If using the map's background, then the borders should be default
        DrawOpImage(Operations[1]).Image = Texture'DH_GUI_Tex.Menu.DHSectionTopper';
        DrawOpImage(Operations[2]).Image = Texture'DH_GUI_Tex.Menu.DHSectionTopper';
    }
    
    DrawOpImage(Operations[0]).Image = M;
}

defaultproperties
{
    DeployingText="Deploying to {0}"
    AuthorText="Author: {0}"

    // The official backgrounds
    Backgrounds(0)="DH_GUI_Tex.LoadingScreen.Background_Default"

    Begin Object class=DrawOpImage Name=OpTopBorder
        Image=Texture'DH_GUI_Tex.Menu.DHSectionTopper' // if you change this, you have to change it in the SetImage() function also
        ImageStyle=0
        Top=0.0
        Lft=0.0
        Width=1.0
        Height=0.09
        DrawColor=(R=0,B=0,G=0,A=255)
    End Object
    Operations(1)=OpTopBorder

    Begin Object class=DrawOpImage Name=OpBottomBorder
        Image=Texture'DH_GUI_Tex.Menu.DHSectionTopper' // if you change this, you have to change it in the SetImage() function also
        ImageStyle=0
        Top=0.91
        Lft=0.0
        Width=1.0
        Height=0.09
        DrawColor=(R=0,B=0,G=0,A=255)
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
        Top=0.92
        Lft=0.05
        Height=0.05
        Width=0.9
        Justification=2
        FontName="DH_Interface.DHHugeButtonFont"
        bWrapText=false
    End Object
    Operations(4)=OpLoading

    Begin Object class=DrawOpText Name=OpMapAuthorText
        Top=0.02
        Lft=0.05
        Height=0.05
        Width=0.9
        Justification=2
        FontName="DH_Interface.DHHugeButtonFont"
    End Object
    Operations(5)=OpMapAuthorText
}
