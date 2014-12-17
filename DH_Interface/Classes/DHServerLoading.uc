//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHServerLoading extends UT2K4ServerLoading;

#EXEC OBJ LOAD FILE=DH_GUI_Tex.utx

//Variables
var localized string loadingMapPrefix; //"Deploying to..."
var localized string loadingMapAuthorPrefix; //"Author:"
var localized string vacSecuredText; //"NOTE: This server is VAC Secured. Cheating will result in a permanent ban."
var localized string OfficialMapText; //"Official Map"
var localized string CustomMapText; //"Community Map"

var Material vacIcon; //Server is VAC secured icon
var Material OfficialMapIcon; //Icon for indicating the loading map is official
var Material CustomMapIcon; //Icon for indicating the loading map is custom

var CacheManager.MapRecord  LoadingMapRecord; //Record for loading map (to get author, extrainfo, etc)

//Functions

simulated event Init()
{
    //Gets the MapRecord and sets it so we can use it in other functions
    LoadingMapRecord = class'CacheManager'.static.getMapRecord(MapName);

    //Calls the base background and text functions (should be after we get the mapRecord)
    super.Init();

    //Draws VAC icon if bVACSecured
    SetVACInfo();
}

simulated function SetText()
{
    local GUIController GC;
    local DrawOpText HintOp;
    local string Map;

    Map = StripMap(MapName);
    Map = StripPrefix(Map);
    Map = AddSpaces(Map);

    //This sets up the strings for Map Author
    if (LoadingMapRecord.Author == "")
    {
        DrawOpText(Operations[8]).Text = loadingMapAuthorPrefix @ "Unspecified";
    }
    else
    {
        DrawOpText(Operations[8]).Text = loadingMapAuthorPrefix @ LoadingMapRecord.Author;
    }

    //Sets up actual text on the screen for the author
    //DrawOpText(Operations[8]).Text = loadingMapAuthorPrefix @ AuthorFinal;

    //This sets up the strings "Deploying to..." MAPNAME
    DrawOpText(Operations[2]).Text = loadingMapPrefix @ Map;
    DrawOpText(Operations[1]).Text = "";

    //Get GUI Controller
    GC = GUIController(Level.GetLocalPlayerController().Player.GUIController);

    //This draws the loading prefix + mapname "Deploying to... LEVEL"
    if (GC!=none)
    {
        GC.LCDCls();
        GC.LCDDrawTile(GC.LCDLogo,0,0,64,43,0,0,64,43);
        GC.LCDDrawText(loadingMapPrefix,55,10,GC.LCDMedFont);
        GC.LCDDrawText(StripMap(Map),55,26,GC.LCDTinyFont);
        GC.LCDRePaint();
    }

    //Return here if software rendering
    if (Level.IsSoftwareRendering())
        return;

    //Hint stuff
    HintOp = DrawOpText(Operations[3]);

    if (HintOp == none)
    {
        return;
    }

    HintOp.Text = "";
}

//Show the VAC secured icon
simulated function SetVACInfo()
{
    if (bVACSecured)
    {
        DrawOpImage(Operations[4]).Image = vacIcon;
        DrawOpText(Operations[5]).Text = vacSecuredText;
    }
}

//Show the Official or Custom icon and text
simulated function SetMapConstitution(bool bOfficialMap)
{
    if (bOfficialMap)
    {
        DrawOpImage(Operations[6]).Image = OfficialMapIcon;
        DrawOpText(Operations[7]).Text = OfficialMapText;
    }
    else
    {
        DrawOpImage(Operations[6]).Image = CustomMapIcon;
        DrawOpText(Operations[7]).Text = CustomMapText;
    }
}

simulated function string AddSpaces(string s)
{
    local string temp, result, char, lastchar;
    local int lastpos, pos;

    // Replace '_' with ' '
    temp = Repl(s, "_", " ", false);

    // Search for capitals in the name and add spaces inbetween words
    if (len(temp) > 1)
    {
        lastpos = 0;

        while (pos < len(temp))
        {
            char = mid(temp, pos, 1);

            if (Caps(char) == char && Locs(char) != char && lastchar != " " && lastchar != "-")
            {
                if (result != "")
                    result $= " ";

                result $= mid(temp, lastpos, pos - lastpos);
                lastpos = pos;
            }

            pos++;
            lastchar = char;
        }

        if (lastpos != pos)
        {
            if (result != "")
                result $= " ";

            result $= mid(temp, lastpos, pos - lastpos);
        }

        return result;
    }
    else
        return temp;
}

simulated function string StripPrefix(string s)
{
        if ((Left(s, 3) == "DH-" || Left(s, 3) == "dh-") && len(s) > 3)
            return Right(s, len(s) - 3);
        else
            return s;
}

simulated function SetImage()
{
    local string str;
    local material mat;
    local string Map;

    Map = StripMap(MapName);
    Map = StripPrefix(Map);
    Map = AddSpaces(Map);
    Map = Lower(Map);

    Log("DHServerLoading: Map name = " $Map);
            mat = Material'MenuBlack';
            DrawOpImage(Operations[0]).Image = mat;

    //We are going to check to see if the level is officially supported
    //If so set the proper background (loadingscreen) and call the function to add the logo indicating official map
    switch (Map)
    {
        case "bois jacques" :
            str = Backgrounds[1];
            break;
        case "brecourt" :
            str = Backgrounds[2];
            break;
        case "carentan" :
            str = Backgrounds[3];
            break;
        case "dog green" :
            str = Backgrounds[4];
            break;
        case "foy" :
            str = Backgrounds[5];
            break;
        case "freyneux and lamormenil" :
            str = Backgrounds[6];
            break;
        case "ginkel heath" :
            str = Backgrounds[7];
            break;
        case "hill 108" :
            str = Backgrounds[8];
            break;
        case "hurtgenwald" :
            str = Backgrounds[9];
            break;
        case "juno beach" :
            str = Backgrounds[10];
            break;
        case "la chapelle" :
            str = Backgrounds[11];
            break;
        case "la monderie" :
            str = Backgrounds[12];
            break;
        case "noville" :
            str = Backgrounds[13];
            break;
        case "raids" :
            str = Backgrounds[14];
            break;
        case "stoumont" :
            str = Backgrounds[15];
            break;
        case "vieux" :
            str = Backgrounds[16];
            break;
        case "wacht am rhein" :
            str = Backgrounds[17];
            break;
        case "bridgehead" :
            str = Backgrounds[18];
            break;
        case "caen":
            str = Backgrounds[19];
            break;
        case "cambes en plaine":
            str = Backgrounds[20];
            break;
        case "carentan causeway":
            str = Backgrounds[21];
            break;
        case "gran":
            str = Backgrounds[22];
            break;
        case "hill 400":
            str = Backgrounds[23];
            break;
        case "kommerscheidt":
            str = Backgrounds[24];
            break;
        case "lutremange":
            str = Backgrounds[25];
            break;
        case "poteau ambush":
            str = Backgrounds[26];
            break;
        case "simonskall":
            str = Backgrounds[27];
            break;
        case "vieux recon":
            str = Backgrounds[28];
            break;
    }

    //Lets check if an official level was detected or not
    if (str == "")
    {
        //This level is custom, lets check if it has a custom loading screen set in ExtraInfo
        if (LoadingMapRecord.ExtraInfo != "")
        {
            //Try to set the material up from ExtraInfo (if not entered correctly it'll fail)
            mat = Material(DynamicLoadObject(MapName$LoadingMapRecord.ExtraInfo, class'Material'));
        }
        //Check to see if mat failed to set properly
        if (mat.Validated == false)
        {
            //mat must have failed to create from ExtraInfo string
            str = Backgrounds[0]; //use generic background for now
            mat = DLOTexture(str); //set mat to use generic background
        }

        //Set the custom map icon + text
        SetMapConstitution(false);

        //Draw the background loading screen
        DrawOpImage(Operations[0]).Image = mat;
    }
    //Level is official
    else
    {
        //Set the official map icon + text
        SetMapConstitution(true);

        //Actually set the material & draw
        mat = DLOTexture(str);
        DrawOpImage(Operations[0]).Image = mat;
    }
}

static final function string Lower(coerce string Text)
{
    local int IndexChar;

    for (IndexChar = 0; IndexChar < Len(Text); IndexChar++)
        if (Mid(Text, IndexChar, 1) >= "A" &&
           Mid(Text, IndexChar, 1) <= "Z")

    Text = Left(Text, IndexChar) $ Chr(Asc(Mid(Text, IndexChar, 1)) + 32) $ Mid(Text, IndexChar + 1);

    return Text;
}

defaultproperties
{
    loadingMapPrefix="Deploying to"
    loadingMapAuthorPrefix="Author:"
    OfficialMapText="Official Map"
    OfficialMapIcon=texture'DH_GUI_Tex.Menu.OfficialMapLogo'
    CustomMapText="Community Map"
    CustomMapIcon=texture'DH_GUI_Tex.Menu.CommunityMapLogo'
    //The official backgrounds
    Backgrounds(0)="DH_GUI_Tex.LoadingScreens.LoadingScreenDHDefault"
    Backgrounds(1)="DH_GUI_Tex.LoadingScreens.LoadingScreenBoisJacques"
    Backgrounds(2)="DH_GUI_Tex.LoadingScreens.LoadingScreenBrecourt"
    Backgrounds(3)="DH_GUI_Tex.LoadingScreens.LoadingScreenCarentan"
    Backgrounds(4)="DH_GUI_Tex.LoadingScreens.LoadingScreenDogGreen"
    Backgrounds(5)="DH_GUI_Tex.LoadingScreens.LoadingScreenFoy"
    Backgrounds(6)="DH_GUI_Tex.LoadingScreens.LoadingScreenFreyneux"
    Backgrounds(7)="DH_GUI_Tex.LoadingScreens.LoadingScreenGinkelHeath"
    Backgrounds(8)="DH_GUI_Tex.LoadingScreens.LoadingScreenHill108"
    Backgrounds(9)="DH_GUI_Tex.LoadingScreens.LoadingScreenHurtgen"
    Backgrounds(10)="DH_GUI_Tex.LoadingScreens.LoadingScreenJunoBeach"
    Backgrounds(11)="DH_GUI_Tex.LoadingScreens.LoadingScreenLaChapelle"
    Backgrounds(12)="DH_GUI_Tex.LoadingScreens.LoadingScreenLaMonderie"
    Backgrounds(13)="DH_GUI_Tex.LoadingScreens.LoadingScreenNoville"
    Backgrounds(14)="DH_GUI_Tex.LoadingScreens.LoadingScreenRaids"
    Backgrounds(15)="DH_GUI_Tex.LoadingScreens.LoadingScreenStoumont"
    Backgrounds(16)="DH_GUI_Tex.LoadingScreens.LoadingScreenVieux"
    Backgrounds(17)="DH_GUI_Tex.LoadingScreens.LoadingScreenWachtamRhein"
    Backgrounds(18)="DH_GUI_Tex.LoadingScreens.LoadingScreenBridgehead"
    Backgrounds(19)="DH_GUI_Tex.LoadingScreens.LoadingScreenCaen"
    Backgrounds(20)="DH_GUI_Tex.LoadingScreens.LoadingScreenCambesEnPlaine"
    Backgrounds(21)="DH_GUI_Tex.LoadingScreens.LoadingScreenCarentanCauseway"
    Backgrounds(22)="DH_GUI_Tex.LoadingScreens.LoadingScreenGran"
    Backgrounds(23)="DH_GUI_Tex.LoadingScreens.LoadingScreenHill400"
    Backgrounds(24)="DH_GUI_Tex.LoadingScreens.LoadingScreenKommerscheidt"
    Backgrounds(25)="DH_GUI_Tex.LoadingScreens.LoadingScreenLutremange"
    Backgrounds(26)="DH_GUI_Tex.LoadingScreens.LoadingScreenPoteauAmbush"
    Backgrounds(27)="DH_GUI_Tex.LoadingScreens.LoadingScreenSimonskall"
    Backgrounds(28)="DH_GUI_Tex.LoadingScreens.LoadingScreenVieuxRecon"
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
        Justification=0
        VertAlign=1
        FontName="ROInterface.ROHeaderFont"
        //bWrapText=true
    End Object
    Operations(7)=OpConstitutionText
    Begin Object class=RODrawOpShadowedText Name=OpMapAuthorText
        Top=0.02
        Lft=0.05
        Height=0.05
        Width=0.32
        Justification=0
        VertAlign=1
        FontName="ROInterface.ROHeaderFont"
        //bWrapText=true
    End Object
    Operations(8)=OpMapAuthorText
}
