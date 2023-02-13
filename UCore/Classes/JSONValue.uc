//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class JSONValue extends Object
    abstract;

function bool IsString() { return false; }
function bool IsNull() { return false; }
function bool IsNumber() { return false; }
function bool IsBoolean() { return false; }
function bool IsObject() { return false; }
function bool IsArray() { return false; }

function string AsString() { return ""; }
function JSONNumber AsNumber() { return none; }
function int AsInteger() { return 0; }
function float AsFloat() { return 0.0; }
function bool AsBoolean() { return false; }
function JSONObject AsObject() { return none; }
function JSONArray AsArray() { return none; }

function string Encode() { return "null"; }

static function string GetSanitizedString(string S)
{
    S = Repl(S, "\\", "\\\\");
    S = Repl(S, "\"", "\\\"");
    return S;
}

