//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Actor to enable or disable main base supply caches.
//==============================================================================

class DH_ModifyMainBaseSupplyCache extends DH_LevelActors;

enum EModifyAction
{
    ACTION_Disable,
    ACTION_Enable
};

var()   name                        MainBaseSupplyCacheTag;
var()   EModifyAction               ModifyAction;

var private DHMainBaseSupplyCache   MainBaseSupplyCache;

function PostBeginPlay()
{
    super.PostBeginPlay();

    foreach AllActors(class'DHMainBaseSupplyCache', MainBaseSupplyCache, MainBaseSupplyCacheTag)
    {
        break;
    }

    if (MainBaseSupplyCache == none)
    {
        Destroy();
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    if (MainBaseSupplyCache == none)
    {
        return;
    }

    switch (ModifyAction)
    {
        case ACTION_Disable:
            MainBaseSupplyCache.DestroySupplyAttachment();
            break;
        case ACTION_Enable:
            MainBaseSupplyCache.CreateSupplyAttachment();
            break;
    }
}

defaultproperties
{
}
