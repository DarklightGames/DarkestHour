//==============================================================================
// This file was automatically generated by the localization tool.
// Do not edit this file directly.
// To regenerate this file, run ./tools/localization/generate_fonts.bat
//==============================================================================

class DHButtonFontDS extends GUIFont;

event Font GetFont(int ResX)
{
    return Class'DHFonts'.static.GetDHButtonFontDSByResolution(Controller.ResX, Controller.ResY);
}

defaultproperties
{
    KeyName="DHButtonFontDS"
}
