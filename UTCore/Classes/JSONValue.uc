//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONValue extends Object
    abstract;

function bool IsString()
{
    return false;
}

function bool IsObject()
{
    return false;
}

function bool IsNumber()
{
    return false;
}

function bool IsArray()
{
    return false;
}

function bool IsBoolean()
{
    return false;
}

function bool IsNull()
{
    return false;
}

function bool IsTrue()
{
    return false;
}

function bool IsFalse()
{
    return false;
}

function JSONString AsString();
function JSONObject AsObject();
function JSONNumber AsNumber();
function JSONArray AsArray();
function JSONBoolean AsBoolean();