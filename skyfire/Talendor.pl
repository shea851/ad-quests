sub EVENT_KILLED_MERIT
{
	plugin::KillMerit();
}

sub EVENT_DEATH_COMPLETE
{	
	plugin::SpawnFabled();
}