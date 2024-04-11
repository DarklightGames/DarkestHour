//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCreditsPage extends LargeWindow;

var automated GUIButton b_Close;
var automated GUIScrollTextBox lb_Credits;

var array<string> ProjectLeads;
var array<string> Programmers;
var array<string> Animators;
var array<string> Modelers;
var array<string> TextureArtists;
var array<string> Artists;
var array<string> LevelDesigners;
var array<string> SoundArtists;
var array<string> VoiceActors;
var array<string> LocalizationTeam;
var array<string> CommunityAdmins;
var array<string> PastPatreonSupporters;
var array<string> OtherContributors;
var array<string> SpecialThanks;

var array<string> CreditLines;

var localized string ProjectLeadsText;
var localized string ProgrammersText;
var localized string AnimatorsText;
var localized string ModelersText;
var localized string TextureArtistsText;
var localized string ArtistsText;
var localized string LevelDesignersText;
var localized string SoundArtistsText;
var localized string VoiceActorsText;
var localized string LocalizationTeamText;
var localized string CommunityAdminsText;
var localized string PastPatreonSupportersText;
var localized string OtherContributorsText;
var localized string SpecialThanksText;

function AddSystemMenu(){}

function AddCreditLine(string Line)
{
    CreditLines[CreditLines.Length] = Line;
}

function AddHeader(string Header)
{
    AddCreditLine(Header);
    AddCreditLine("");
}

function AddSection(string Header, array<string> Lines)
{
    local int i;

    AddHeader("====" @ Header @ "====");

    for (i = 0; i < Lines.Length; ++i)
    {
        AddCreditLine(Lines[i]);
    }

    AddCreditLine("");
}

function BuildCreditLines()
{
    local int i;

    CreditLines.Length = 0;

    AddHeader("DARKEST HOUR: EUROPE '44-'45");

    AddSection(ProjectLeadsText, ProjectLeads);
    AddSection(ProgrammersText, Programmers);
    AddSection(AnimatorsText, Animators);
    AddSection(ModelersText, Modelers);
    AddSection(TextureArtistsText, TextureArtists);
    AddSection(ArtistsText, Artists);
    AddSection(LevelDesignersText, LevelDesigners);
    AddSection(VoiceActorsText, VoiceActors);
    AddSection(SoundArtistsText, SoundArtists);
    AddSection(LocalizationTeamText, LocalizationTeam);
    AddSection(CommunityAdminsText, CommunityAdmins);
    AddSection(PastPatreonSupportersText, PastPatreonSupporters);
    AddSection(OtherContributorsText, OtherContributors);
    AddSection(SpecialThanksText, SpecialThanks);
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local string S;

    super.InitComponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);

    BuildCreditLines();

    for (i = 0; i < CreditLines.Length; ++i)
    {
        S $= CreditLines[i] $ "|";
    }

    lb_Credits.SetContent(S);
}

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == b_Close)
    {
        Controller.CloseMenu();
    }

    return true;
}

function bool ButtonClick(GUIComponent Sender)
{
    if (Sender == b_Close)
    {
        Controller.CloseMenu();
    }

    return true;
}

defaultproperties
{
    Begin Object Class=GUIButton Name=CloseButton
        Caption="Close"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.9
        WinLeft=0.4
        WinWidth=0.2
        bBoundToParent=true
        OnClick=DHCreditsPage.InternalOnClick
        OnKeyEvent=CloseButton.InternalOnKeyEvent
    End Object
    b_Close=GUIButton'DH_Interface.DHCreditsPage.CloseButton'
    Begin Object Class=DHGUIScrollTextBox Name=CreditText
        bNoTeletype=true
        OnCreateComponent=CreditText.InternalOnCreateComponent
        StyleName="DHLargeText"
        WinTop=0.08
        WinLeft=0.07
        WinWidth=0.86
        WinHeight=0.8
        bBoundToParent=true
        bScaleToParent=true
    End Object
    lb_Credits=DHGUIScrollTextBox'DH_Interface.DHCreditsPage.CreditText'

    Begin Object Class=DHGUIHeader Name=TitleBar
        StyleName="DHLargeText"
        WinTop=0.02
        WinHeight=0.05
        RenderWeight=0.1
        bBoundToParent=true
        bScaleToParent=true
        bAcceptsInput=true
        bNeverFocus=false
        ScalingType=SCALE_X
        OnMousePressed=DHCreditsPage.FloatingMousePressed
        OnMouseRelease=DHCreditsPage.FloatingMouseRelease
    End Object
    t_WindowTitle=DHGUIHeader'DH_Interface.DHCreditsPage.TitleBar'
    WindowName="Credits"
    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
        DropShadow=none
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinTop=0.02
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=0.98
        RenderWeight=0.000003
    End Object
    i_FrameBG=FloatingImage'DH_Interface.DHCreditsPage.FloatingFrameBackground'

    // TODO: Build the credit lines from lists of a categorized list.
    ProjectLeads(0)="Colin Basnett"
    ProjectLeads(1)="dirtybirdy"
    ProjectLeads(2)="Matty"
    ProjectLeads(3)="Exocet"

    Programmers(0)="Colin Basnett"
    Programmers(1)="Matt UK"
    Programmers(2)="Theel"
    Programmers(3)="Shurek"
    Programmers(4)="PsYcH0_Ch!cKeN"
    Programmers(5)="dirtybirdy"
    Programmers(6)="Daniel Mann"
    Programmers(7)="mimi~"
    Programmers(8)="Hopkins"
    Programmers(9)="Teufelhund"
    Programmers(10)="Fennich_FJR6"
    Programmers(11)="jmoney"
    
    Modelers(0)="RustIronCrowe"
    Modelers(1)="Apekop"
    Modelers(2)="Coyote Ninja"
    Modelers(3)="Diablo"
    Modelers(4)="Garisson"
    Modelers(5)="Maharzan"
    Modelers(6)="Nights2o06"
    Modelers(7)="ScubaSteve"
    Modelers(8)="Silence14"
    Modelers(9)="Tman"
    Modelers(10)="2_k"
    Modelers(11)="FooBar"
    Modelers(12)="DmitriB"
    Modelers(13)="Captain Obvious"
    Modelers(14)="piotrlukasik"
    Modelers(15)="Theel"
    Modelers(16)="Respio"
    Modelers(17)="AAZ"
    Modelers(18)="Mechanic"
    Modelers(19)="eksha"
    Modelers(20)="Leyawynn"
    Modelers(21)="Matty"
    Modelers(22)="Napoleon Blownapart"
    Modelers(23)="Pvt.Winter"
    Modelers(24)="Emercom Camper"

    TextureArtists(0)="Protector"
    TextureArtists(1)="Aeneas2020"
    TextureArtists(2)="Blacklabel"
    TextureArtists(3)="Fennich_FJR6"
    TextureArtists(4)="FooBar"
    TextureArtists(5)="CYoung"
    TextureArtists(6)="Captain Obvious"
    TextureArtists(7)="piotrlukasik"
    TextureArtists(8)="Theel"
    TextureArtists(9)="Groundwaffe"
    TextureArtists(10)="Matty"

    Artists(0)="Der Landser"
    Artists(1)="Protector"
    Artists(2)="Aeneas2020"
    Artists(3)="Fennich_FJR6"
    Artists(4)="Patison"
    Artists(5)="Seven"
    
    Animators(0)="Exocet"
    Animators(1)="Mike Munk (TWI)"
    Animators(2)="TT33"
    Animators(3)="Razorneck"
    Animators(4)="AAZ"
    Animators(5)="Aarón Q.V."
    Animators(6)="Colin Basnett"
    Animators(7)="dirtybirdy"
    Animators(8)="Enfield"

    LevelDesigners(0)="Theel"
    LevelDesigners(1)="SchutzeSepp"
    LevelDesigners(2)="Razorneck"
    LevelDesigners(3)="BOH-rekrut"
    LevelDesigners(4)="Jorg Biermann"
    LevelDesigners(5)="Exocet"
    LevelDesigners(6)="Nestor Makhno"
    LevelDesigners(7)="602RAF_Puff"
    LevelDesigners(8)="Drecks"
    LevelDesigners(9)="FlashPanHunter"
    LevelDesigners(10)="Jeff Duquette"
    LevelDesigners(11)="Sichartshofen"
    LevelDesigners(12)="kashash"
    LevelDesigners(13)="EvilHobo"
    LevelDesigners(14)="TWB*RedYager and TWB*JimMiller"
    LevelDesigners(15)="Ravelo"
    LevelDesigners(16)="dolas"
    LevelDesigners(17)="Bäckis"
    LevelDesigners(18)="WOLFkraut"
    LevelDesigners(19)="Cpt.Caverne"
    LevelDesigners(20)="Mad.Death.Hound"
    LevelDesigners(21)="John Davidson"

    VoiceActors(0)="Logan Laidlaw (American & Canadian)"
    VoiceActors(1)="602RAF_Puff (British)"
    VoiceActors(2)="Ettore Fulvio (Italian)"

    SoundArtists(0)="Fennich_FJR6"
    SoundArtists(1)="Blitzkreig"
    SoundArtists(2)="Wiseq"
    SoundArtists(3)="Boone"
    SoundArtists(4)="Demonizer"
    SoundArtists(5)="PsYcH0_Ch!cKeN"
    SoundArtists(6)="Shurek"
    SoundArtists(7)="engineer"
    SoundArtists(8)="pillam"
    SoundArtists(9)="Logan Laidlaw"
    SoundArtists(10)="jmoney"
    SoundArtists(11)="Nathan B. Lewis"
    SoundArtists(12)="AAZ"

    LocalizationTeam(0)="-Red-(Rus)- (Russian)"

    CommunityAdmins(0)="Colonel_Ironnuts"
    CommunityAdmins(1)="toaster"
    CommunityAdmins(2)="Sugardust"
    CommunityAdmins(3)="Wittmann"
    
    PastPatreonSupporters(0)="-[SiN]-Titus"
    PastPatreonSupporters(1)=".Reflected."
    PastPatreonSupporters(2)="[DNR]Gun4hire"
    PastPatreonSupporters(3)="8BitWarrior"
    PastPatreonSupporters(4)="Brian Briggs"
    PastPatreonSupporters(5)="Caleb Coates"
    PastPatreonSupporters(6)="clad"
    PastPatreonSupporters(7)="Clay McCarty"
    PastPatreonSupporters(8)="Duncan Langford"
    PastPatreonSupporters(9)="Frank Baele"
    PastPatreonSupporters(10)="Garth Davis"
    PastPatreonSupporters(11)="Glock Shanty"
    PastPatreonSupporters(12)="Jeffrey Allan Beeler"
    PastPatreonSupporters(13)="John Ciccariello"
    PastPatreonSupporters(14)="Josef Erik Sedlácek"
    PastPatreonSupporters(15)="Joshua Dressel"
    PastPatreonSupporters(16)="Justin Hall"
    PastPatreonSupporters(17)="Keith Olson"
    PastPatreonSupporters(18)="Kevin Vones"
    PastPatreonSupporters(19)="KS"
    PastPatreonSupporters(20)="Mal"
    PastPatreonSupporters(21)="Mikolaj Stefan"
    PastPatreonSupporters(22)="Munakoiso"
    PastPatreonSupporters(23)="Peter Senzamici"
    PastPatreonSupporters(24)="PFC Patison [29th ID]"
    PastPatreonSupporters(25)="ProjectMouthwash"
    PastPatreonSupporters(26)="Rawhide"
    PastPatreonSupporters(27)="Remington Spooner"
    PastPatreonSupporters(28)="Robert Morra"
    PastPatreonSupporters(29)="Saferight"
    PastPatreonSupporters(30)="Sean Gift"
    PastPatreonSupporters(31)="Zhang Han"
    
    OtherContributors(0)="After-Hourz Gaming Network"
    OtherContributors(1)="All the lads from Splat"
    OtherContributors(2)="The Wild Bunch"
    OtherContributors(3)="Schneller"
    OtherContributors(4)="Beppo and the lads from Sentry Studios"
    OtherContributors(5)="Amizaur for vehicle optics code and German vehicle gun sights"
    OtherContributors(6)="Thommy-L (Fatal Error)"
    OtherContributors(7)="Carpathian Crosses Team"
    OtherContributors(8)="Torben 'thens' Hensgens"
    OtherContributors(9)="29th Infantry Division"
    OtherContributors(10)="Good Guys Gaming Community"
    OtherContributors(11)="ChrisMo1944"
    
    SpecialThanks(0)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    SpecialThanks(1)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    SpecialThanks(2)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    SpecialThanks(3)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    SpecialThanks(4)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8

    ProjectLeadsText="Project Leads"
    ProgrammersText="Programmers"
    AnimatorsText="Animators"
    ModelersText="Modelers"
    TextureArtistsText="Texture Artists"
    ArtistsText="Artists"
    LevelDesignersText="Level Designers"
    SoundArtistsText="Sound Artists"
    VoiceActorsText="Voice Actors"
    LocalizationTeamText="Localization Team"
    CommunityAdminsText="Community Admins"
    PastPatreonSupportersText="Past Patreon Supporters"
    OtherContributorsText="Other Contributors"
    SpecialThanksText="Special Thanks"
}
