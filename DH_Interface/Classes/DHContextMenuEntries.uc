//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHContextMenuEntries extends Object
    abstract;

protected static function array<int> AssembleMenu(DHPlayerReplicationInfo PRI, DHPlayerReplicationInfo SecondPRI);
protected static function ProcessEntry(int EntryTypeIndex, DHPlayerReplicationInfo PRI, DHPlayerReplicationInfo SecondPRI);

protected static function string GetEntryString(int EntryTypeIndex, DHPlayerReplicationInfo PRI, DHPlayerReplicationInfo SecondPRI)
{
    return "(No string for entry type " @ EntryTypeIndex $ ")";
}

final static function bool OnOpen(GUIContextMenu Sender, optional DHPlayerReplicationInfo PRI, optional DHPlayerReplicationInfo SecondPRI)
{
    local array<int> MenuEntries;
    local int i;

    MenuEntries = AssembleMenu(PRI, SecondPRI);

    for (i = 0; i < MenuEntries.Length; ++i)
    {
        Sender.AddItem(GetEntryString(MenuEntries[i], PRI, SecondPRI));
    }

    return MenuEntries.Length > 0;
}

final static function int OnClick(int ClickIndex, GUIContextMenu Sender, optional DHPlayerReplicationInfo PRI, optional DHPlayerReplicationInfo SecondPRI)
{
    local array<int> MenuEntries;

    if (ClickIndex < 0)
    {
        return 0;
    }

    MenuEntries = AssembleMenu(PRI, SecondPRI);

    if (ClickIndex < MenuEntries.Length)
    {
        ProcessEntry(MenuEntries[ClickIndex], PRI, SecondPRI);
        return MenuEntries.Length;
    }
}

defaultproperties
{
}
