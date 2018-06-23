# Author: Corporate
# Date: 20170909

no warnings;

sub EVENT_SPAWN {
	return unless $npc->GetLoottableID();
	
	# AA turn in token
	my $token = 133016;
	
	# Chance for drop addition
	my $addchance = 3;
	
	# Minimum level npc to add to
	my $minlevel = 51;
	
	# Do random math and add item
	my $randomResult = int(rand(100));
	if ($npc->GetLevel() >= $minlevel && $randomResult < $addchance)
	{
		$npc->AddItem($token);
	}
}
