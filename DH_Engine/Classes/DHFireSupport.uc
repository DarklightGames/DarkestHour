//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// Shared data definitions.
//==============================================================================

class DHFireSupport extends Object
    abstract;

enum EFireSupportError
{
    FSE_None,
    FSE_Disabled,
    FSE_NotEnoughSquadmates,
    FSE_InvalidLocation,
    FSE_InsufficientPrivileges,
    FSE_Fatal
};
