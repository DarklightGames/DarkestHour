//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
