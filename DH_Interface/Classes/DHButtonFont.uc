//==============================================================================
// This file was automatically generated by the localization tool.
// Do not edit this file directly.
// To regenerate this file, run ./tools/localization/generate_fonts.bat
//==============================================================================

class DHButtonFont extends GUIFont;

event Font GetFont(int ResX)
{
    return Class'DHFonts'.static.GetDHButtonFontByResolution(Controller.ResX, Controller.ResY);
}

defaultproperties
{
    KeyName="DHButtonFont"
}
