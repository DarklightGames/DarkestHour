//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHATGunProxy extends DHActorProxy;

var DHATGun Gun;

function SetGun(DHATGun Gun)
{
    if (Gun == none)
    {
        return;
    }

    self.Gun = Gun;

    // update the everything (appearance etc.)
    UpdateAppearance();

    // TODO: size of the proxy projector needs to be disconnected from the "collision size" of constructions
    // so we can use it here
}

// TODO: this is a 1:1 re-declaration from construction_vehicle, move this later
// (perhaps into DHVehicle itself).
function UpdateAppearance()
{
    local int i, j;
    local DHActorProxyAttachment APA;
    local class<DHVehicle> VehicleClass;

    VehicleClass = Gun.Class;

    SetDrawType(DT_Mesh);
    LinkMesh(VehicleClass.default.Mesh);

    for (j = 0; j < VehicleClass.default.Skins.Length; ++j)
    {
        if (VehicleClass.default.Skins[j] != none)
        {
            Skins[j] = CreateProxyMaterial(VehicleClass.default.Skins[j]);
        }
    }

    for (i = 0; i < VehicleClass.default.PassengerWeapons.Length; ++i)
    {
        APA = Spawn(class'DHActorProxyAttachment', self);

        if (APA != none)
        {
            AttachToBone(APA, VehicleClass.default.PassengerWeapons[i].WeaponBone);

            APA.SetDrawType(DT_Mesh);
            APA.LinkMesh(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Mesh);

            for (j = 0; j < VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins.Length; ++j)
            {
                if (VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins[j] != none)
                {
                    APA.Skins[j] = CreateProxyMaterial(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins[j]);
                }
            }

            Attachments[Attachments.Length] = APA;
        }
    }
}

// TODO; we need to run an "update proxy" type thing here, but make the rest of
// the "update proxy" calls generic enough to be used
defaultproperties
{
}

