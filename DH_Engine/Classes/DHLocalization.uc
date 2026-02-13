//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// The engine affords us no way to get the current language code. Instead, we
// create localized variables here that will be set according to the current
// language.
//=============================================================================

class DHLocalization extends Object
    abstract;

// ISO-639-3 (3 character) language code of the current language. (e.g. "eng" for English, "rus" for Russian)
var localized string    LanguageCode;
var localized string    LanguageName;

defaultproperties
{
    LanguageCode="eng"
    LanguageName="English"
}
