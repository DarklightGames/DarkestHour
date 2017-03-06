//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_Resupply extends DHConstruction;

var DHResupplyAttachment ResupplyAttachment;

function PostBeginPlay()
{
    if (Role == ROLE_Authority)
    {
        ResupplyAttachment = Spawn(class'DHResupplyAttachment', self);

        if (ResupplyAttachment != none)
        {
            ResupplyAttachment.ResupplyType = RT_Players;
            ResupplyAttachment.SetBase(self);
        }
        else
        {
            Warn("Failed to spawn resupply attachment!");
        }
    }
}

function OnTeamIndexChanged()
{
    if (ResupplyAttachment != none)
    {
        ResupplyAttachment.SetTeamIndex(GetTeamIndex());
    }
}

event Destroyed()
{
    super.Destroyed();

    if (ResupplyAttachment != none)
    {
        ResupplyAttachment.Destroy();
    }
}

defaultproperties
{
    StaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box'
    bShouldAlignToGround=true
    MenuName="Resupply Box"
}
