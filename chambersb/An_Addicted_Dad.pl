# Author:  Corporate
# Date:    20161119
# Purpose: Item deattuner

use warnings;

sub EVENT_SPAWN {
		quest::settimer("checksuspensions", 15);
		quest::settimer("purgeadinstancedata", 60);
}

sub EVENT_TIMER {
	if ($timer eq "checksuspensions") {
		my @suspendList = plugin::ReadVariable('suspension_%');
		foreach my $val (@suspendList) #val will equal char name, which is always unique
		{
			quest::crosszonesignalclientbyname($val, 8675309);
		}
	}
	if ($timer eq "purgeadinstancedata") {
		plugin::AD_PurgeExpiredInstanceData();
		plugin::AD_PurgeExpiredInstanceLockouts();
	}
}

sub EVENT_SAY {
	if ($text=~/Hail/i) {
		plugin::Whisper("Hi there, $name! I've got some sweet questage for you.  Would you like to [".quest::saylink("Deattune an item",1)."] or have you found a [".quest::saylink("Dad Token",1)."]?");
	}
	elsif ($text=~/Deattune an item/i) {
		plugin::Whisper("I charge 5,000 platinum pieces to de-attune one item.  Hand over exactly one item with the platinum, then prepare to be amazed! No tips please!");
		plugin::Whisper("I may also be willing to make a trade to de-attune an item.  My daughter has a sweet tooth and I'm always looking for a [".quest::saylink("treat",1)."] for her.");
	}
	elsif ($text=~/treat/i) {
		plugin::Whisper("She is very fond of Gummies.  If you find any, save them for me!  Hand me one Gummy and one item for a free de-attune.");
	}
	elsif ($text=~/Dad Token/i) {
		plugin::Whisper("You don't have time to grind out a million AAs.  I get it.  Kids running around, chores to do, etc.  Give me a Dad Token and I'll help you out bro.");
	}
}

sub EVENT_ITEM {

	my $gummiesID = 133015;
	my $dadtokenID = 133016;
	my $cost = 5000;
	
	my @item = ($item1, $item2, $item3, $item4);
	my @item_charges = ($item1_charges, $item2_charges, $item3_charges, $item4_charges);
	my @item_attuned = ($item1_attuned, $item2_attuned, $item3_attuned, $item4_attuned);
	
	# Return bogus items
	for my $i (0 .. $#item)
	{
		if ($item[$i] > 0 && $item_attuned[$i] == 0 && $item[$i] != $gummiesID && $item[$i] != $dadtokenID)
		{
			$client->SummonItem($item[$i], $item_charges[$i], $item_attuned[$i]);
			quest::me("I have no need for this $name, you can have it back.");
			$item[$i] = 0;
		}
	}
	
	$emptySlotCount = scalar(grep(/^0$/, @item));
	
	# Platinum quest
	if ($platinum == $cost && $emptySlotCount == 3)
	{
		for my $i (0 .. $#item)
		{
			if ($item[$i] > 0)
			{
				$client->SummonItem($item[$i], $item_charges[$i], 0);
			}
		}
		quest::say("Enjoy, $name!");
		return;
	}
	
	# Gummies quest
	if (grep(/^$gummiesID$/, @item) && $emptySlotCount == 2)
	{
		for my $i (0 .. $#item)
		{
			if ($item[$i] > 0 && $item[$i] != $gummiesID)
			{
				$client->SummonItem($item[$i], $item_charges[$i], 0);
			}
		}
		quest::givecash($copper, $silver, $gold, $platinum);
		quest::say("Enjoy, $name!");
		return;
	}
	
	# AA quest
	if (grep(/^$dadtokenID$/, @item) && $client->GetLevel() >= 51)
	{
		for my $i (0 .. $#item)
		{
			if ($item[$i] > 0)
			{
				$client->AddAAPoints($item_charges[$i]);
			}
		}
		quest::say("Enjoy, $name!");
		return;
	}
	
	# Return remaining items/cash should we arrive here
	quest::givecash($copper, $silver, $gold, $platinum);
		
	for my $i (0 .. $#item)
	{
		if ($item[$i] > 0)
		{
			$client->SummonItem($item[$i], $item_charges[$i], $item_attuned[$i]);
			quest::me("I have no need for this $name, you can have it back.");
		}
	}

}