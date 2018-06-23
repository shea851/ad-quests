sub EVENT_SPAWN {
	quest::setnexthpevent(80);
}

sub EVENT_HP {
	if($hpevent == 80) {
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::setnexthpevent(60);
	} elsif($hpevent == 60) {
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::setnexthpevent(40);
	} elsif($hpevent == 40) {
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::setnexthpevent(20);
	} elsif($hpevent == 20) {
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
		quest::spawn2(108518, 0, 0, $x, $y, $z, $h);
	}
}

sub EVENT_KILLED_MERIT
{
	plugin::KillMerit();
}
