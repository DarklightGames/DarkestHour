//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    FSE_InsufficientPrivileges,
    FSE_Fatal,
    FSE_Exhausted
};
