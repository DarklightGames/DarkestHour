//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleProxy extends DHActorProxy;

var class<DHMountedWeapon>   WeaponClass;
var int VariantIndex;

function DHActorProxy.Context GetContext()
{
    local DHActorProxy.Context Context;

    Context = super.GetContext();
    Context.VariantIndex = VariantIndex;

    return Context;
}

final function SetMountedWeaponClass(class<DHMountedWeapon> WeaponClass, optional int VariantIndex)
{
    if (WeaponClass == none)
    {
        Warn("Cannot set the stationary weapon class to none");
        return;
    }

    self.WeaponClass = WeaponClass;
    self.VariantIndex = VariantIndex;

    UpdateAppearance();
}

function CycleVariant()
{
    VariantIndex = ++VariantIndex % WeaponClass.default.ConstructionClass.static.GetVariantCount();

    UpdateAppearance();
}

// TODO: add specific player/context errors if the player isn't crouched, moving, leaning etc.

function UpdateProxyAppearance()
{
    if (WeaponClass == none || WeaponClass.default.ConstructionClass == none)
    {
        return;
    }

    WeaponClass.default.ConstructionClass.static.UpdateProxy(self);
}

function GetCollisionSize(Context Context, out float OutRadius, out float OutHeight)
{
    if (WeaponClass == none || WeaponClass.default.ConstructionClass == none)
    {
        super.GetCollisionSize(Context, OutRadius, OutHeight);
    }
    
    WeaponClass.default.ConstructionClass.static.GetCollisionSize(Context, OutRadius, OutHeight);
}

function string GetMenuName()
{
    if (WeaponClass == none ||
        WeaponClass.default.ConstructionClass == none ||
        WeaponClass.default.ConstructionClass.default.VehicleClass == none)
    {
        return super.GetMenuName();
    }

    return WeaponClass.default.ConstructionClass.default.VehicleClass.default.VehicleNameString;
}

protected simulated function bool ShouldAlignToGround()
{
    // TODO: we want to be able to override this for certain variants.
    return WeaponClass.default.bShouldAlignToGround;
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_StaticMesh
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=false
    bAcceptsProjectors=false
}