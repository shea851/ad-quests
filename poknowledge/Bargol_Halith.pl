sub EVENT_SAY { 
	if($text=~/Hail/i){
		quest::say("Hello. traveler. If you be interested in brewing, then you've come to the right man. My wares are for producing the most tasty beverages in all of New Tanaan, and they are yours to purchase should you wish.");
		quest::say("I also have many wares shipped in from all over the world. Should you have any shipment information I can go and fetch your package.");
	}
}

sub EVENT_ITEM {
	
	# Charm quest
	my $quest_t4_1 = 133027; # Shipment Information
	my $quest_t4_2 = 133028; # Case shipped from Bavaria

	if (plugin::check_handin(\%itemcount, $quest_t4_1 => 1))
	{
		quest::say("Here ye go. The case has a bit of damage but hey, it's not my fault!");
		quest::summonitem($quest_t4_2);
	}
	if ($platinum != 0 || $gold !=0 || $silver != 0 || $copper != 0)
	{
		quest::givecash($copper, $silver, $gold, $platinum);

	}
	plugin::return_items(\%itemcount);

}

#END of FILE Zone:poknowledge  ID:202134 -- Bargol_Halith
