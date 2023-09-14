//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    LinkMesh(Gun.Mesh);

    for (j = 0; j < Gun.Skins.Length; ++j)
    {
        if (Gun.Skins[j] != none)
        {
            Skins[j] = CreateProxyMaterial(Gun.Skins[j]);
        }
    }

    for (i = 0; i < Gun.WeaponPawns.Length; ++i)
    {
        APA = Spawn(class'DHActorProxyAttachment', self);

        if (APA != none)
        {
            AttachToBone(APA, Gun.PassengerWeapons[i].WeaponBone);

            APA.SetDrawType(DT_Mesh);
            APA.LinkMesh(Gun.WeaponPawns[i].Gun.Mesh);

            for (j = 0; j < Gun.WeaponPawns[i].Gun.Skins.Length; ++j)
            {
                if (Gun.WeaponPawns[i].Gun.Skins[j] != none)
                {
                    APA.Skins[j] = CreateProxyMaterial(Gun.WeaponPawns[i].Gun.Skins[j]);
                }
            }

            Attachments[Attachments.Length] = APA;
        }
    }
}

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (Gun == none)
    {
        Destroy();
    }

    // TODO: maybe

    SetLocation(Gun.Location);
    SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(LocalRotation), QuatFromRotator(Gun.Rotation))));
}

// TODO; we need to run an "update proxy" type thing here, but make the rest of
// the "update proxy" calls generic enough to be used
