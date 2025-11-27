//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// TODO: Should maybe just have an "ignore placement rules" flag?
//==============================================================================

class DHMountedWeaponProxy extends DHConstructionProxy;

// Modified to skip all of the normal construction checks since this object is already in-hand.
// TODO: keep the check that the player is busy (running, crawling etc.)
function DHActorProxy.ActorProxyError GetContextError(Context Context)
{
    local ActorProxyError Error;

    Error.Type = ERROR_None;

    return Error;
}
