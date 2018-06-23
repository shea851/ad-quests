
sub EVENT_DEATH_COMPLETE
{
	quest::setglobal("tunare_done", 1, 3, "H6");
}

sub EVENT_KILLED_MERIT
{
	plugin::KillMerit();
}