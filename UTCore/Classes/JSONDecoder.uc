//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONDecoder extends Object;

function JSONObject Decode(coerce string S)
{
    local StringBuffer Buffer;

    Buffer = new class'StringBuffer';
    Buffer.Write(S);
}
