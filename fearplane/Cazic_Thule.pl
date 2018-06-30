sub EVENT_KILLED_MERIT
{
	plugin::KillMerit();
}


## Whistling Fists quest

sub EVENT_SAY
{
	# Quest dialogue trigger
	if ($text ="gandan has failed in his task")
	{
		# Emote text
		quest::emote("'s thoughts begin to pervade your own, they creep into your mind with great force. You feel pressure as if your head will explode. You see his thoughts becoming your own. You see in these visions a tome bound in flesh dropped to the ground. You then open your eyes to see that same book, and take it knowing that it was meant for you.");
		# Reward item: Flayed Skin Tome - 18898
		quest::summonitem(18898);
	}
}

sub EVENT_ITEM
{
	# Require items: Satchel of Cazic-Thule - 8226, Flayed Skin Tome - 18898, Flayed Skin Tome - 18899
	if (plugin::check_handin(\%itemcount, 8226 => 1, 18898 => 1, 18899 => 1))
	{
		# Emote text
		quest::emote("seems pleased with the amount of pain that you have been able to inflict. Cazic Thule then grabs your hands and begins to infuse them with his power. Your hands burn like they were placed in lava for a moment, then feel cool as ice. You can feel the sheer power flowing through your new weapons of pain.");
		# Reward item: Whistling Fists - 7836
		quest::summonitem(7836);
		# Grant exp
		quest::exp(100000);
		# Play ding sound
		quest::ding();
	}
	# Return unused items
    	plugin::return_items(\%itemcount);
}
