//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHContextMenu extends Object
    abstract;

var private   array<int>    EntryIndices;
var localized array<string> EntryTexts;

final function int GetMenuLength() { return EntryIndices.Length; }
final protected function Reset() { EntryIndices.Length = 0; }
protected function AssembleMenu(GUIComponent Component);
protected function ProcessEntry(int EntryIndex, GUIComponent Component);

final protected function AddEntry(int CaptionIndex)
{
    EntryIndices[EntryIndices.Length] = CaptionIndex;
}

final protected function InsertEntry(int CaptionIndex, int Index)
{
    if (Index >= EntryIndices.Length)
    {
        AddEntry(CaptionIndex);
    }

    if (Index >= 0)
    {
        EntryIndices.Insert(Index, 1);
        EntryIndices[Index] = CaptionIndex;
    }
}

protected function string GetEntryString(int EntryIndex, GUIComponent Component)
{
    return "(No string for entry " @ EntryIndex $ ")";
}

final function DHPlayer GetComponentController(GUIComponent Component)
{
    if (Component != none)
    {
        return DHPlayer(Component.PlayerOwner());
    }
}

final function bool OnOpen(GUIContextMenu Sender, GUIComponent Component)
{
    local int i;

    if (Sender == none)
    {
        return false;
    }

    Reset();
    AssembleMenu(Component);

    for (i = 0; i < EntryIndices.Length; ++i)
    {
        Sender.AddItem(GetEntryString(EntryIndices[i], Component));
    }

    return Sender.ContextItems.Length > 0;
}

final function OnClick(GUIContextMenu Sender, GUIComponent Component, int ClickIndex)
{
    if (ClickIndex >= 0 && ClickIndex < EntryIndices.Length)
    {
        ProcessEntry(EntryIndices[ClickIndex], Component);
    }
}
