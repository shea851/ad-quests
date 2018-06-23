# Author: Corporate
# Date: 20171203
# Purpose: Spawn Tunare trigger

sub TunareLogic
{
	my $tunareTree = 127001; # NPC -- trigger -- #_Tunare (in the tree)
	my $tunareForest = 127098; # NPC -- flag -- #Tunare (in the forest)

	if (!$entity_list->GetNPCByNPCTypeID($tunareTree) && !$entity_list->GetNPCByNPCTypeID($tunareForest) && !defined(plugin::ReadQGlobal("tunare_done")))
	{
		quest::spawn2($tunareTree, 0, 0, -1633.0, 1525.0, 205.4, 0);
	}
}

sub EVENT_SPAWN
{
	quest::settimer("tunare_check", 60);
	TunareLogic();
}

sub EVENT_TIMER
{
	if ($timer eq "tunare_check")
	{
		TunareLogic();
	}
}
