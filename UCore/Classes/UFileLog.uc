//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// This log function fixes a bug that exists in the FileLog actor where calling
// Logf with a string larger than 1024 characters will crash the game. To
// mitigate this, we will write it in chunks of 512, just to be extra safe.
//==============================================================================

class UFileLog extends Object;

const BUFFER_LIMIT = 1024;

final static function Logf(FileLog F, string S)
{
    local int i, L;

    if (F == none)
    {
        return;
    }

    L = Len(S);

    for (i = 0; i < L; i += BUFFER_LIMIT)
    {
        F.Logf(Mid(S, i, BUFFER_LIMIT));
    }
}

