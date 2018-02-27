//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_InventorySpawner extends DHConstruction
    abstract;

var class<DHInventorySpawner>   SpawnerClass;

static function class<DHInventorySpawner> GetSpawnerClass(DHConstruction.Context Context)
{
    return default.SpawnerClass;
}

simulated function OnConstructed()
{
    local DHInventorySpawner IS;

    if (Role == ROLE_Authority)
    {
        IS = Spawn(GetSpawnerClass(GetContext()),,, Location, Rotation);
    }
}

static function UpdateProxy(DHConstructionProxy CP)
{
    local int i, j;
    local class<DHInventorySpawner> SpawnerClass;
    local Actor Attachment;
    local array<Material> AttachmentSkins;

    super.UpdateProxy(CP);

    SpawnerClass = GetSpawnerClass(CP.GetContext());

    CP.SetDrawType(DT_Mesh);
    CP.LinkMesh(GetSpawnerClass(CP.GetContext()).default.Mesh);

    for (i = 0; i < SpawnerClass.default.Skins.Length; ++i)
    {
        CP.Skins[i] = CP.CreateProxyMaterial(SpawnerClass.default.Skins[i]);
    }

    AttachmentSkins = (new class'UStaticMesh').FindStaticMeshSkins(SpawnerClass.default.WeaponClass.default.PickupClass.default.StaticMesh);

    for (i = 0; i < AttachmentSkins.Length; ++i)
    {
        AttachmentSkins[i] = CP.CreateProxyMaterial(AttachmentSkins[i]);
    }

    CP.DestroyAttachments();

    for (i = 0; i < SpawnerClass.default.PickupBoneNames.Length; ++i)
    {
        Attachment = CP.Spawn(SpawnerClass.default.ProxyClass);
        Attachment.SetStaticMesh(SpawnerClass.default.WeaponClass.default.PickupClass.default.StaticMesh);

        if (Attachment == none)
        {
            continue;
        }

        CP.AttachToBone(Attachment, SpawnerClass.default.PickupBoneNames[i]);

        for (j = 0; j < AttachmentSkins.Length; ++j)
        {
            Attachment.Skins[j] = AttachmentSkins[j];
        }

        Attachment.SetRelativeLocation(vect(0, 0, 0));
        CP.Attachments[CP.Attachments.Length] = Attachment;
    }
}

static function GetCollisionSize(DHConstruction.Context Context, out float NewRadius, out float NewHeight)
{
    local class<DHInventorySpawner> SpawnerClass;

    SpawnerClass = GetSpawnerClass(Context);

    if (SpawnerClass != none)
    {
        NewRadius = SpawnerClass.default.CollisionRadius;
        NewHeight = SpawnerClass.default.CollisionHeight;
    }
}

defaultproperties
{
    GroupClass=class'DHConstructionGroup_Logistics'
    SpawnerClass=class'DH_Weapons.DH_StielGranateSpawner'
    bDestroyOnConstruction=true
    ProxyTraceDepthMeters=2.0
    bCanPlaceIndoors=true
    ConstructionVerb="drop"
}

