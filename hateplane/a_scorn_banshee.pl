# Author: Corporate
# Date: 20180131

sub EVENT_DEATH_COMPLETE
{
	my $spawnChance = 14;
	my $spawnID = 186150;
	# Do random math and spawn thought_destroyer or nothing
	my $randomResult = int(rand(100));
	if ($randomResult < $spawnChance)
	{
		quest::spawn2($spawnID, 0, 0, $x, $y, $z, $h);
	}
}